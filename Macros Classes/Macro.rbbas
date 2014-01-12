#tag Class
Protected Class Macro
	#tag Method, Flags = &h0
		Sub Macro()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreerMenuItem()
		  dim mitem as Menuitem
		  dim k, nitem as integer
		  
		  MenuMenus.Child("MacrosMenu").Child("MacrosSave").checked = false
		  MenuMenus.Child("MacrosMenu").Child("MacrosQuit").checked = false
		  MenuMenus.Child("MacrosMenu").Child("MacrosFinaux").checked = false
		  
		  mitem = new MenuItem
		  mitem.Name = "MacrosChoose"
		  mitem.Text = Caption
		  mitem.checked = true
		  k = app.themacros.count-1
		  MenuMenus.Child("MacrosMenu").Child("MacrosExecute").append mitem
		  mitem.index  = k
		  wnd.EraseMenuBar
		  wnd.CopyMenuBar
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Macro(Doc as XMLDocument)
		  dim List as XMLNodeList
		  dim Temp, EL, EL1 As  XMLElement
		  dim i as integer
		  
		  Histo =  XMLElement(Doc.FirstChild)
		  Caption =  Histo.GetAttribute("Name")
		  List = Histo.XQL("Description")
		  if  List.length > 0 then
		    Description = XMLElement(List.Item(0))
		    Expli = Description.child(0).value
		  end if
		  
		  List = Histo.XQL("Initial")
		  if List.length > 0 then
		    Temp = XMLElement(List.Item(0))
		    for i = 0 to Temp.childcount-1
		      EL1 = XMLElement(Temp.Child(i))
		      ObInit.append val(EL1.GetAttribute("Id"))
		      FaInit.append val(EL1.GetAttribute("Fa"))
		      FoInit.append val(EL1.GetAttribute("Fo"))
		    next
		  end if
		  Histo.RemoveChild Temp
		  
		  List = Histo.XQL("Final")
		  if List.length > 0 then
		    Temp = XMLElement(List.Item(0))
		    for i = 0 to Temp.childcount-1
		      EL1 = XMLElement(Temp.Child(i))
		      ObFinal.append val(EL1.GetAttribute("Id"))
		      FaFinal.append val(EL1.GetAttribute("Fa"))
		      FoFinal.append val(EL1.GetAttribute("Fo"))
		    next
		  end if
		  Histo.RemoveChild Temp
		  
		  List = Histo.XQL("Interm")
		  if List.length > 0 then
		    Temp = XMLElement(List.Item(0))
		    for i = 0 to Temp.childcount-1
		      EL1 = XMLElement(Temp.Child(i))
		      ObInterm.append val(EL1.GetAttribute("Id"))
		      FaInterm.append val(EL1.GetAttribute("Fa"))
		      FoInterm.append val(EL1.GetAttribute("Fo"))
		    next
		  end if
		  Histo.RemoveChild Temp
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument, n as integer) As XMLElement
		  dim Temp, EL as XmlElement
		  dim i as integer
		  dim s as shape
		  dim categorie as string
		  dim ObCategorie(), FaCategorie(), FOCategorie() as integer
		  
		  select case n
		  case 0
		    categorie = "Initial"
		    ObCategorie = ObInit
		    FaCategorie = FaInit
		    FoCategorie = FoInit
		  case 1
		    categorie = "Final"
		    ObCategorie = ObFinal
		    FaCategorie = FaFinal
		    FoCategorie = FoFinal
		  case 2
		    categorie = "Interm"
		    ObCategorie = ObInterm
		    FaCategorie = FaInterm
		    FOCategorie = FoInterm
		  end select
		  
		  Temp=Doc.CreateElement(Categorie)
		  for i = 0 to ubound(ObCategorie)
		    EL = Doc.CreateElement("Obj"+Categorie)
		    EL.SetAttribute("Id", str(ObCategorie(i)))
		    EL.SetAttribute("Fa",str(FaCategorie(i)))
		    EL.SetAttribute("Fo",str(FoCategorie(i)))
		    Temp.AppendChild EL
		  next
		  
		  return Temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveFileMacro()
		  Dim file As FolderItem              //Sauvegarde d'une macro dans le dossier "Macros" de Mes Documents/Apprenti Geometre lors de la création de la macro
		  Dim tos as TextOutputStream
		  dim place as integer
		  dim i as integer
		  dim Doc as XMLDocument
		  dim Histo as XMLElement
		  Dim dlg as New SaveAsDialog
		  
		  if ubound(ObFinal) = -1 then
		    return
		  end if
		  
		  CurrentContent.CurrentOperation = nil
		  wnd.refreshtitle
		  
		  Doc = CurrentContent.OpList
		  Histo = XMLElement(Doc.FirstChild)
		  ToXML(Doc, Histo)
		  
		  dlg.InitialDirectory=app.MacFolder
		  dlg.promptText=""
		  dlg.Title= Dico.Value("SaveMacro")
		  dlg.filter=FileAGTypes.MACR
		  
		  file=dlg.ShowModal()
		  If file <> Nil then
		    place = Instr(file.name,".xmag")
		    if place <> 0 then
		      Caption=Left(file.name,place-1)
		    else
		      Caption = file.name
		      file.name = Caption + ".xmag"
		    end if
		    tos=file.CreateTextFile
		    if tos <> nil then
		      Histo.SetAttribute("Name",Caption)
		      if expli <> "" then
		        Histo.RemoveChild Description
		        Histo.appendChild DescriptionToMac(Doc)
		      end if
		      tos.write Doc.tostring
		      tos.close
		      app.theMacros.addmac self
		      creermenuitem
		    end if
		  end if
		  if  file = nil or tos = nil then
		    MsgBox Dico.Value("ErrorOnSave")
		  end if
		  wnd.closemacro
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Elaguer()
		  dim i, ObId as integer
		  dim EL, EL1 as XmlElement
		  
		  for i = wnd.mac.Histo.childcount -1 downto 0
		    EL = XMLElement(Histo.Child(i))
		    EL1 = XMLElement(EL.firstChild)
		    ObId = val(EL1.GetAttribute("Id"))
		    if currentcontent.theobjects.getshape(ObId) = nil then
		      wnd.mac.Histo.RemoveChild EL
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MacExe(MacInfo as MacConstructionInfo)
		  dim i, oper as integer
		  dim EL as XMLElement
		  dim codesoper() as integer
		  dim ifmac As InfoMac
		  
		  codesoper = Array(0,1,14,16,19,28,33,35,37,39,24,25,26,27,43,45)
		  
		  MacInf = MacInfo
		  
		  for i = 0 to Histo.Childcount-1  // i: numéro de l'opération
		    NumOp = i
		    EL = XMLElement(Histo.Child(i))
		    
		    if EL.Name = Dico.Value("Operation") then
		      oper = val(EL.GetAttribute("OpId"))  //oper: code de l'opération
		      ifmac = MacInfo.ifmacs(i)
		      if codesoper.indexof(oper) <> -1 then //est-ce une opération de construction d'un objet?
		        ComputeObject(ifmac,EL)
		      elseif oper =17 then   'On doit calculer la matrice de la transfo et la stocker dans ifmac
		        ComputeMatrix(ifmac, EL)
		      end if
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExeOper(EL as XMLElement, byref nbp As nBPoint)
		  dim MacId, oper as integer
		  dim ifm0,  ifm1 as InfoMac
		  dim EL0, EL1 as XMLElement
		  dim num as integer
		  
		  
		  EL0 = XMLElement(EL.Child(0))                   'Forme construite
		  EL1 = XMLElement(EL.Child(1))                   'Instructions de construction (s'il y en a)
		  MacId = val(EL0.GetAttribute("Id"))
		  ifm0 = MacInf.GetInfoMac(MacId,num )
		  oper = val(EL.GetAttribute("OpId"))
		  
		  if EL1 <> nil and oper > 0 then                     'Données de l'éventuelle forme-constructeur
		    MacId = val(EL1.GetAttribute("Id"))
		    ifm1 = MacInf.GetInfoMac(MacId, num)
		  end if
		  
		  select case oper
		  case 0 //Construction
		    Construction(EL0,EL1,nbp)
		  case 1 //paraperp
		    paraperp(EL0,EL1,nbp)
		  case 14 //Centre
		    centre(ifm1,nbp)
		  case 16 //Retourner
		  case 19 //Dupliquer
		    dupliquerpoint(EL0,EL1,ifm1,nbp)
		  case 24 //AppliquerTsf
		    Transformer(EL0,EL1,ifm1,nbp)
		  case 25 //Decouper
		  case 26 //Point de division
		    divide(EL0,EL1, nbp)
		  case 27 //Fusionner
		  case 28 //Prolonger
		    extend(EL0,EL1,ifm1,nbp)
		  case 35 //Identifier
		  case 37 //FixPConstruction
		  case 39 //Flecher
		  case 43 //Macro
		  case 45  //Point d'intersection
		    inter (ifm0, nbp)
		  end select
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub centre(ifmac as InfoMac, Byref nbp as nBPoint)
		  nbp.append ifmac.coord.centre
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub divide(EL0 as XMLElement, EL1 as XMLElement, byref nbp as nBPoint)
		  dim id0, id1, MacId, num as integer
		  dim m, ndiv, div,si as integer
		  dim Trib as TriBpoint
		  dim Bib as BiBPoint
		  dim nb0, nb1 as nBPoint
		  dim ifmac as infomac
		  dim s as shape
		  dim bp1, bp2 as BasicPoint
		  dim ni as integer
		  
		  MacId = val(EL1.GetAttribute("Id"))
		  ifmac = MacInf.GetInfoMac(MacId, num)  //ifmac correspondant à l'objet constructeur
		  si =ifmac.RealSide
		  ni = MacInf.IfMacs.IndexOf(ifmac)
		  ndiv = val(EL1.GetAttribute("NDivP"))
		  div = val(EL1.GetAttribute("DivP"))
		  
		  if ifmac.fa = 1 and ifmac.fo = 0 then
		    bp1 = ifmac.coord.tab(si)
		    bp2 = ifmac.coord.tab((si +1) mod ifmac.coord.taille)
		    Bib = new BiBPoint(bp1,bp2)
		    nbp.append BiB.subdiv(ndiv,div)
		  elseif ifmac.fa <> 5 and ifmac.fa <> 7 then
		    id0 = val(EL1.GetAttribute("Id0"))  //id0 et id1 sont des MacId relatifs au bipoint
		    id1 = val(EL1.GetAttribute("Id1"))
		    bp1 = MacInf.GetSommet(ni,id0,m).coord.tab(m)
		    bp2 =MacInf.GetSommet(ni,id1,m).coord.tab(m)
		    Bib = new BiBPoint(bp1,bp2)
		    nbp.append BiB.subdiv(ndiv,div)
		  elseif ifmac.fa = 5 then
		    if ifmac.fo = 0 and ifmac.coord.taille = 2 then
		      Trib = new TriBPoint(ifmac.coord.tab(0),ifmac.coord.tab(1),ifmac.coord.tab(1))
		    else
		      Trib = new TriBPoint(ifmac.coord)
		    end if
		    nbp.append TriB.subdiv(ifmac.ori,ndiv, div)
		  elseif ifmac.fa = 7 then                                     'cas des lacets
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paraperp(EL0 as XMLElement, EL1 as XMLElement, byref nbp as nBPoint)
		  dim p, q, w0, w as BasicPoint
		  dim n0, side, npt,fam, fom, ni as integer
		  dim EL2, EL3 as XmlElement
		  dim ifmac,  ifm1, ifm2 as infoMac
		  dim pere, num, macid as integer
		  dim c as nBPoint
		  dim pt as point
		  
		  MacId = val(EL0.GetAttribute("Id"))
		  ifmac = MacInf.GetInfoMac(MacId, num)
		  pere = ifmac.forme0
		  ifm1 = MacInf.GetInfoMac(pere,num)
		  c = ifm1.coord
		  side = Ifmac.NumSide0
		  //On calcule d'abord le vecteur directeur de la paraperp
		  npt = c.taille
		  p = c.tab(side)
		  q = c.tab ((side+1) mod npt)
		  w0 = q - p
		  w=w0.normer
		  if val(EL1.GetAttribute("Oper")) = 2 Then
		    w=w.VecNorPerp
		  end if
		  
		  //Ensuite on recherche l'origine
		  ifm1=ifmac.childs(0)
		  if ifm1.init then
		    pt = point(currentcontent.TheObjects.Getshape(ifm1.realid))
		    nbp.append pt.bpt
		  else
		    ifm2 = MacInf.GetInfoMac(ifm1.MacId,num)
		    if num = 999 then
		      nbp.append ifm2.coord.tab(0)
		    else
		      nbp.append ifm2.Coord.tab(num)
		    end if
		  end if
		  nbp.Append nbp.tab(0)+w
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Inter(ifmac as infomac, byref nbp as nBPoint)
		  dim EL10, EL11 as XMLElement
		  dim Mid,  mid0, mid1, ncot0, ncot1, m, nextre0, nextre1, n, num as integer
		  dim nb1, nb0 as nBPoint
		  dim Bib1, Bib0 as BiBPoint
		  dim r1, r2 as double
		  dim fa1, fa0, fo1, fo0 as integer
		  dim bp as BasicPoint
		  dim  ifm0, ifm1 as infomac
		  dim bb(), q, v as BasicPoint
		  
		  Mid = ifmac.MacId
		  mid0 = ifmac.forme0
		  ifm0 = MacInf.GetInfoMac(mid0, num)
		  fa0 = ifm0.fa
		  fo0 = ifm0.fo
		  nb0 = ifm0.coord
		  
		  mid1 = ifmac.forme1
		  ifm1 = MacInf.GetInfoMac(mid1, num)
		  fa1 = ifm1.fa
		  fo1 = ifm1.fo
		  nb1 = ifm1.coord
		  
		  if fa0 = 1 and (fo0 = 3 or fo0 = 4 or fo0 = 5) then
		    nextre0 = 0
		  elseif fa0 = 1 and fo0 = 6 then
		    nextre0 = 1
		  else
		    nextre0 = 2
		  end if
		  
		  if fa1 = 1 and (fo1 = 3 or fo1 = 4 or fo1 = 5) then
		    nextre1 = 0
		  elseif fa1 = 1 and fo1 = 6 then
		    nextre1 = 1
		  else
		    nextre1 = 2
		  end if
		  
		  if fa0 <> 5  then
		    ncot0 = ifmac.NumSide0
		  else
		    ncot0 = 0
		  end if
		  Bib0 = new BiBPoint(nb0.tab(ncot0), nb0.tab((ncot0+1) mod nb0.taille))
		  
		  
		  if fa1 <> 5 then
		    ncot1 = ifmac.Numside1
		  else
		    ncot1 = 0
		  end if
		  Bib1 = new BiBPoint(nb1.tab(ncot1), nb1.tab((ncot1+1) mod nb1.taille))
		  
		  
		  if fa0 <> 5 and fa1 <> 5 then
		    bp =  bib0.BiBInterDroites(Bib1,nextre0,nextre1,r1,r2)
		    nbp.append bp
		  else
		    if fa0 = 5 and Fa1 = 5 then
		      m = BiB0.BibInterCercles(BiB1,bb,q,v)
		      n = ifmac.numside1
		    else
		      if fa1 = 5 then
		        m = bib0.bibdroiteintercercle(bib1,bb,q,v)
		        n = ifmac.numside1
		      elseif fa0 = 5 then
		        m = bib1.bibdroiteintercercle(bib0,bb,q,v)
		        n = ifmac.numside0
		      end if
		    end if
		    select case m
		    case 0
		      nbp.append nil
		    case 1
		      nbp.append bb(0)
		    case 2
		      nbp.append bb(n)
		    end select
		  end if
		  
		  //A revoir pour le cas des arcs (et cercles) et  pour les points d'inter qui sont des objets finaux
		  
		  
		  
		  
		  
		  // Encore considérer les intersections droite-cercle et cercle-cercle
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Construction(EL0 as XMLElement, EL1 as XMLElement, byref nbp as nBPoint)
		  dim MacId, i, n, oper as integer
		  dim ifm as InfoMac
		  dim EL01, EL02 as XMLElement
		  dim nbp1 as nBPoint
		  dim fa, fo,m as integer
		  
		  fa = val(EL0.GetAttribute(Dico.Value("NrFam")))
		  fo = val(EL0.GetAttribute(Dico.Value("NrForm")))
		  if fa > 0 then
		    EL01 = XMLElement(EL0.FirstChild)
		  end if
		  
		  select case fa
		  case 0
		    MacId = val(EL0.GetAttribute("Id"))
		    nbp = MacInf.GetSommet(NumOp-1,MacId,m).coord
		  case 1
		    select case fo
		    case -1,0, 1, 2, 3, 4, 5, 6
		      n = 1
		    case 7,8
		      n = 2
		    end select
		  case 2  'Triangles
		    select case fo
		    case 0, 1, 3  'Triqcq
		      n = 2
		    case 2, 4
		      n = 1
		    end select
		  case 3  'Quadris
		    select case fo
		    case 7
		      n = 1
		    case 3,4,5,6
		      n = 2
		    case 2
		      n = 3
		    end select
		  case 4 'Polreg
		    n = 1
		  case 5  'Circles
		    select case fo
		    case 0
		      n = 1
		    else
		      n = 2
		    end select
		  case 6 'Polyqcq
		    n = fo+2
		  end select
		  redim nbp.tab(n)
		  for i = 0 to n
		    m = 0
		    EL02 = XMLElement(EL01.child(i))
		    MacId = val(EL02.GetAttribute("Id"))
		    ifm = MacInf.GetSommet(NumOp-1,MacId,m)
		    nbp.tab(i) = ifm.coord.tab(m)
		  next
		  nbp.constructshape(fa,fo)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Caption
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub extend(EL0 as XMLElement, EL1 as XMLelement, ifm1 as InfoMac, byref nbp as nBPoint)
		  dim index, npt as integer
		  dim c as nBPoint
		  dim p, q as BasicPoint
		  
		  index = val(EL1.GetAttribute("Index"))
		  c = ifm1.coord
		  npt = c.Taille
		  p = c.tab(index)
		  q = c.tab ((index+1) mod npt)
		  nbp.append p
		  nbp.append q
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub dupliquerpoint(EL0 as XMLElement, EL1 as XMLElement, ifm1 as InfoMac, byref nbp as nBPoint)
		  dim id1, id0 ,  k, n, np, m as integer
		  dim fp, sp, bp as BasicPoint
		  dim nb as nBPoint
		  
		  id1 =  val(EL1.GetAttribute("Id")) //point source
		  loc0 = GetLocation(id1)
		  si0 = GetSide(id1)
		  
		  k = val(EL1.GetAttribute("Data0")) //Point image
		  n = val(EL0.GetAttribute("PointSur"))
		  nb = MacInf.GetSommet(numop-1,n,m).Coord
		  np = nb.Taille
		  
		  si0 = ( si0+k ) mod np
		  fp = nb.tab(si0)
		  sp = nb.tab((si0+1) mod np)
		  bp = fp*(1-loc0)+sp*loc0
		  nbp.append bp
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLocation(n as integer) As double
		  dim i, j, k, m, num as integer
		  dim s as shape
		  dim ifm as infomac
		  dim EL, EL0, EL1 as XMLElement
		  
		  m = Obinit.indexof(n)
		  if m <> -1 then        //Si c'est une forme initiale
		    ifm = MacInf.GetInfoMac(n, num)
		    return ifm.location
		    's= currentcontent.theobjects.getshape(ifm.realid)
		    'if s isa point and point(s).pointsur.count = 1 then
		    'return point(s).location(0)
		    'end if
		  end if
		  
		  m = ObInterm.indexof(n)
		  if m <> -1 then        //Si c'est une forme intermédiaire
		    ifm = MacInf.GetInfoMac(n, num)
		    return ifm.location
		  end if
		  
		  //Si c'est un point qui n'est ni initial ni intermédiaire
		  
		  ifm = MacInf.GetSommet(numop-1,n,m)
		  return ifm.location
		  
		  'for i = numop -1 downto 0
		  'EL = XMLElement(Histo.Child(i))
		  'EL0 = XMLElement(EL.Child(0))
		  'if EL0.Childcount > 0 then
		  'EL1 = XMLElement(EL0.FirstChild)
		  'for j = 0 to EL1.Childcount-1
		  'if n = val(EL1.Child(j).GetAttribute("Id")) then
		  'ifm = Macinf.IfMacs(i)
		  'return ifm.location
		  'end if
		  'next
		  'end if
		  'next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSide(n as integer) As integer
		  dim i, j, k, m, num as integer
		  dim s as shape
		  dim ifm as infomac
		  dim EL, EL0, EL1 as XMLElement
		  
		  m = Obinit.indexof(n)
		  if m <> -1 then        //Si c'est une forme initiale
		    ifm = MacInf.GetInfoMac(n,num)
		    k = ifm.realid
		    s= currentcontent.theobjects.getshape(k)
		    if s isa point and point(s).pointsur.count = 1 then
		      return point(s).numside(0)
		    end if
		  end if
		  
		  m = ObInterm.indexof(n)
		  if m <> -1 then        //Si c'est une forme intermédiaire
		    ifm = MacInf.GetInfoMac(n,num)
		    return ifm.Realside
		  end if
		  
		  //Si c'est un point qui n'est ni initial ni intermédiaire
		  
		  
		  for i = numop -1 downto 0
		    EL = XMLElement(Histo.Child(i))
		    EL0 = XMLElement(EL.Child(0))
		    if EL0.Childcount > 0 then
		      EL1 = XMLElement(EL0.FirstChild)
		      for j = 0 to EL1.Childcount-1
		        if n = val(EL1.Child(j).GetAttribute("Id")) then
		          ifm = Macinf.IfMacs(i)
		          return ifm.Realside
		        end if
		      next
		    end if
		  next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToXML(Docu as XMLDocument, EL as XMLElement)
		  EL.AppendChild ToMac(Docu,0)
		  EL.AppendChild ToMac(Docu,1)
		  EL.AppendChild ToMac(Docu,2)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DescriptionToMac(Doc as XMLDocument) As XMLElement
		  dim Descri as XMLElement
		  
		  Descri = Doc.CreateElement("Description")
		  Descri.AppendChild Doc.CreateTextNode(expli)
		  return Descri
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Transformer(EL0 as XMLElement, EL1 as XMLElement, ifm1 as InfoMac, byref nbp as nBPoint)
		  dim MacId, i, n, op as integer
		  dim nbp1 as nBPoint
		  dim M as Matrix
		  
		  nbp1 = ifm1.coord
		  n = nbp1.taille
		  redim nbp.tab(n)
		  M = GetMatrix(ifm1, EL1)
		  if M <> nil then
		    for i = 0 to n-1
		      nbp.tab(i) =  M*nbp1.tab(i)
		    next
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeMatrix(ifmac as InfoMac, EL as XMLElement)
		  dim  tsftype, k as integer
		  dim n, MacId, m, ni as integer
		  dim nbp, nbp1 as nBpoint
		  dim bp as BasicPoint
		  dim ar(-1) as basicPoint
		  dim s as shape
		  
		  ni = MacInf.Ifmacs.indexof(ifmac)
		  MacId = val(EL.Child(0).GetAttribute("Id"))
		  
		  nbp  = MacInf.GetInfoMac(MacId,m).coord
		  select case ifmac.type
		  case 1
		    ifmac.M = nbp.TranslationMatrix
		  case 2
		    ifmac.M=nbp.RotationMatrix
		  case 3, 4, 5
		    bp = nbp.tab(0)
		    nbp1 = new nBPoint(bp)
		    nbp1.append  bp+new BasicPoint(1,0)
		    select case ifmac.type
		    case 3
		      nbp1.append  bp+new BasicPoint(-1,0)
		    case 4
		      nbp1.append  bp+new BasicPoint(0,1)
		    case 5
		      nbp1.append  bp+new BasicPoint(0,-1)
		    end select
		    ifmac.M = nbp.RotationMatrix
		  case 6
		    ifmac.M = new SymmetryMatrix(nbp.tab(0),nbp.tab(1))
		  case 7
		    ifmac.M = new SimilarityMatrix(nbp.tab(0),nbp.tab(1),nbp.tab(3),nbp.tab(2))
		  case 8
		    ifmac.M = nbp.SimilarityMatrix
		  end select
		  
		  k = ObFinal.indexof(MacId)
		  if k <> -1 then      //Si c'est une forme finale
		    s = currentcontent.theobjects.getshape(ifmac.RealId)
		    s.tsfi.element(ifmac.num).M =  ifmac.M
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeObject(ifmac as InfoMac, EL as XMLElement)
		  dim  oper,  MacId as integer
		  dim s as shape
		  dim nbp as new nBPoint
		  
		  MacId = val(EL.Child(0).GetAttribute("Id"))  //numéro pour la macro de la forme construite
		  
		  if Obinit.indexof(MacId) <> -1 then        //Si c'est une forme initiale
		    s = currentcontent.theobjects.getshape(ifmac.RealId)
		    ifmac.coord = s.GetCoord
		    if oper = 19 then            //On met ifmac à jour
		      ifmac.location = point(s).location(0)
		      ifmac.numside1 = point(s).numside(0)
		    end if
		  end if
		  
		  if ObInterm.indexof(MacId) <> -1 then  //Si c'est une forme intermédiaire
		    ExeOper(EL,nbp)                                     //on recalcule ou récupère les coordonnées
		    ifmac.coord = nbp
		    ifmac.location =loc0
		  end if
		  
		  if (ObFinal.indexof(MacId) <> -1)  then      //Si c'est une forme finale
		    ExeOper(EL,nbp)
		    ifmac.coord = nbp
		    ifmac.location = loc0
		    //On recalcule les coordonnées
		    s = currentcontent.theobjects.getshape(ifmac.RealId)
		    s.coord = ifmac.coord
		    s.repositionnerpoints
		    s.modified = true
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMatrix(ifm1 as infomac, EL1 as XMLElement) As Matrix
		  dim i, op as integer
		  dim ifm as InfoMac
		  dim tsfnum, supp as integer
		  
		  tsfnum = val(EL1.GetAttribute("Nr"))
		  supp = val(EL1.GetAttribute("SuppTsf"))
		  
		  for i = 0 to ubound(MacInf.ifmacs)
		    ifm = MacInf.ifmacs(i)
		    if (ifm.MacId = supp) and  (ifm.num = tsfnum) and (ifm.M <> nil) then
		      return ifm.M
		    end if
		  next
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetInstrucConstruction(n as integer, Byref Pid as integer) As integer
		  dim i, j, op, Mid, m as integer
		  dim EL, EL1, EL2 as XMLElement
		  
		  for i = 0 to Histo.ChildCount-1
		    EL = XMLElement(Histo.Child(i))
		    op = val(EL.GetAttribute("OpId"))
		    EL1 = XMLElement(EL.FirstChild)
		    if EL1 <> nil then
		      Pid = val(EL1.GetAttribute("Id"))  'PId est la macid de la forme soit que l'on construit, soit dont on recherche un des sommets
		      if op = 0 and   Pid = n then
		        return i                                          'i est le numéro de l'instruction
		      else
		        EL1 = XmlElement(EL1.FirstChild)
		        if EL1 <> nil then
		          for j = 0 to EL1.ChildCount-1
		            EL2 = XmlElement(EL1.Child(j))
		            m = val(EL2.GetAttribute("Id"))
		            if m = n then
		              MacroExe(CurrentContent.CurrentOperation).DrapPoint = true ' le drapeau indique qu'on est en train de s'occuper d'un
		              return i                                                                                                  ' de la forme de macid Pid plutôt que de cette forme rlle-même
		            end if
		          next
		        end if
		      end if
		    end if
		  next
		  
		End Function
	#tag EndMethod


	#tag Note, Name = Licence
		
		Copyright © 2010 CREM
		Noël Guy - Pliez Geoffrey
		
		This file is part of Apprenti Géomètre 2.
		
		Apprenti Géomètre 2 is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.
		
		Apprenti Géomètre 2 is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.
		
		You should have received a copy of the GNU General Public License
		along with Apprenti Géomètre 2.  If not, see <http://www.gnu.org/licenses/>.
	#tag EndNote


	#tag Property, Flags = &h0
		Caption As String
	#tag EndProperty

	#tag Property, Flags = &h0
		codesoper() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FaFinal() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FaInit() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FaInterm() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FoFinal() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FoInit() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FoInterm() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ObFinal() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ObInit() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ObInterm() As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		MacInf As MacConstructionInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		Expli As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Description As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		Histo As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		NumOp As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		si0 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		loc0 As double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Caption"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NumOp"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Expli"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="loc0"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="si0"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
