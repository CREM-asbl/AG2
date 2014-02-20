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
		  dim ObCategorie(), FaCategorie(), FoCategorie() as integer
		  
		  
		  select case n
		  case 0
		    Categorie = "Initial"
		    ObCategorie = ObInit
		    FaCategorie = FaInit
		    FoCategorie = FoInit
		  case 1
		    Categorie = "Final"
		    ObCategorie = ObFinal
		    FaCategorie = FaFinal
		    FoCategorie = FoFinal
		  case 2
		    categorie = "Interm"
		    ObCategorie = ObInterm
		    FaCategorie = FaInterm
		    FoCategorie = FoInterm
		  end select
		  
		  Temp=Doc.CreateElement(Categorie)
		  for i = 0 to ubound(ObCategorie)
		    EL = Doc.CreateElement("Obj"+Categorie)
		    EL.SetAttribute("Id", str(ObCategorie(i)))
		    'EL.SetAttribute("Fa",str(FaCategorie(i)))
		    'EL.SetAttribute("Fo",str(FoCategorie(i)))
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
		    end if
		  end if
		  if  file = nil or tos = nil then
		    MsgBox Dico.Value("ErrorOnSave")
		  end if
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Elaguer()
		  dim i, ObId as integer
		  dim EL, EL1 as XmlElement
		  
		  for i = currentcontent.mac.Histo.childcount -1 downto 0
		    EL = XMLElement(Histo.Child(i))
		    EL1 = XMLElement(EL.firstChild)
		    ObId = val(EL1.GetAttribute("Id"))
		    if currentcontent.theobjects.getshape(ObId) = nil then
		      currentcontent.mac.Histo.RemoveChild EL
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MacExe(MacInfo as MacConstructionInfo)
		  dim i, j, oper as integer
		  dim EL as XMLElement
		  dim codesoper() as integer
		  dim ifmac As InfoMac
		  dim s as shape
		  
		  codesoper = Array(0,1,14,16,19,28,33,35,37,39,24,25,26,27,43,45,46)
		  
		  MacInf = MacInfo
		  
		  for i = 0 to ubound(MacInf.ifmacs)             'Histo.Childcount-1  // i: numéro de l'opération
		    NumOp = i
		    EL = XMLElement(Histo.Child(i))
		    ifmac = MacInfo.ifmacs(i)
		    if codesoper.indexof(ifmac.oper) <> -1 then //est-ce une opération de construction d'un objet?
		      ComputeObject(ifmac,EL)
		    elseif ifmac.oper =17 then                                          'On doit calculer la matrice de la transfo et la stocker dans ifmac
		      ComputeMatrix(MacInf.ifmacs(i))
		    end if
		    
		    if not currentcontent.currentoperation isa macroexe then
		      if Validation(ifmac) then
		        for j = 0 to ubound(ObFinal)
		          s = currentcontent.TheObjects.getshape(MacInf.RealFinal(j))
		          s.Valider
		        next
		      else
		        for j = 0 to ubound(ObFinal)
		          s = currentcontent.TheObjects.getshape(MacInf.RealFinal(j))
		          s.invalider
		        next
		      end if
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExeOper(ifmac as infomac, EL as XMLElement, byref nbp As nBPoint)
		  dim MacId, oper as integer
		  dim ifm0,  ifm1 as InfoMac
		  dim EL0, EL1 as XMLElement
		  dim num as integer
		  
		  
		  EL0 = XMLElement(EL.Child(0))                   'Forme construite
		  EL1 = XMLElement(EL.Child(1))                   'Instructions de construction (s'il y en a)
		  
		  if EL1 <> nil and ifmac.oper > 0 then                     'Données de l'éventuelle forme-constructeur
		    MacId = val(EL1.GetAttribute("Id"))
		    ifm1 = MacInf.GetInfoMac(MacId, num)
		  end if
		  
		  select case ifmac.oper
		  case 0 //Construction
		    Construction(ifmac, nbp)
		  case 1 //paraperp
		    paraperp(ifmac,nbp)
		  case 14 //Centre
		    centre(ifmac,nbp)
		  case 16 //Retourner
		  case 19 //Dupliquer
		    dupliquerpoint(EL0,EL1,ifm1,nbp)
		  case 24 //AppliquerTsf
		    Transformer(EL0,EL1,ifm1,nbp)
		  case 25 //Decouper
		  case 26 //Point de division
		    divide(ifmac, nbp)
		  case 27 //Fusionner
		  case 28 //Prolonger
		    extend(ifmac, nbp)
		  case 35 //Identifier
		  case 37 //FixPConstruction
		  case 39 //Flecher
		  case 43 //Macro
		  case 45  //Point d'intersection
		    inter (ifmac, nbp)
		  case 46 //PointSur
		    PointSur (ifmac, nbp)
		  end select
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub centre(ifmac as InfoMac, Byref nbp as nBPoint)
		  
		  dim ifm1 as infomac
		  dim num as integer
		  
		  ifm1= MacInf.GetInfoMac(ifmac.forme0, num)
		  nbp.append ifm1.coord.centre
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub divide(ifmac as infomac, byref nbp as nBPoint)
		  dim id0, id1, MacId, num, num1, num2 as integer
		  dim m as integer
		  dim Trib as TriBpoint
		  dim Bib as BiBPoint
		  dim nb0, nb1 as nBPoint
		  dim bp1, bp2 as BasicPoint
		  dim ifm, ifm1, ifm2 as infomac
		  
		  ifm = MacInf.GetInfoMac(ifmac.Forme0, num)  //ifmac correspondant à l'objet constructeur
		  ifm1 = MacInf.GetInfoMac(ifmac.forme1,num1)
		  if ifm1.macid = ifmac.forme1 then
		    bp1 = ifm1.coord.tab(0)
		  else
		    bp1=ifm1.coord.tab(num1)
		  end if
		  ifm2 = MacInf.GetInfoMac(ifmac.forme2,num2)
		  if ifm2.macid = ifmac.forme2 then
		    bp2 = ifm2.coord.tab(0)
		  else
		    bp2=ifm2.coord.tab(num2)
		  end if
		  if ifm.fa <> 5 and ifm.fa <> 7 then
		    Bib = new BiBPoint(bp1,bp2)
		    nbp.append BiB.subdiv(ifmac.ndiv,ifmac.idiv)
		  elseif ifm.fa = 5 then
		    if ifm.fo = 0 and ifm.coord.taille = 2 then
		      Trib = new TriBPoint(ifm.coord.tab(0),ifm.coord.tab(1),ifm.coord.tab(1))
		    else
		      Trib = new TriBPoint(ifm.coord.tab(0),bp1,bp2)
		    end if
		    nbp.append TriB.subdiv(ifm.ori,ifmac.ndiv, ifmac.idiv)
		  elseif ifm1.fa = 7 then                                     'cas des lacets
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paraperp(ifmac as InfoMac, byref nbp as nBPoint)
		  dim p, q,v, w0, w, u(1)  as BasicPoint
		  dim n, n0, n1, n2, side, npt as integer
		  dim EL2, EL3 as XmlElement
		  dim  ifm1, ifm2, ifm3 as infoMac
		  dim  num, macid as integer
		  dim c as nBPoint
		  dim pt as point
		  dim BiB1, BiB2 as BiBPoint
		  dim r1,r2 as double
		  
		  MacId = ifmac.MacId
		  ifm1 = MacInf.GetInfoMac(ifmac.forme0,num)
		  side = Ifmac.Numside0
		  c = ifm1.coord
		  //On calcule d'abord le vecteur directeur de la paraperp
		  p = c.tab(side)
		  q = c.tab((side+1) mod c.taille)
		  w0 = q - p
		  w=w0.normer
		  if ifmac.fo = 2 or ifmac.fo = 5 Then
		    w=w.VecNorPerp
		  end if
		  
		  redim  nbp.tab(1)
		  //Ensuite on recherche l'origine
		  nbp.tab(0) = GetCoordChild(ifmac.childs(0))
		  if nbp.tab(0) = nil then
		    return
		  end if
		  // et le deuxième point. Le cas où l'objet est une droite est facile
		  if ifmac.fo = 4 or ifmac.fo = 5 then
		    nbp.tab(1) = nbp.tab(0)+w
		    //pour les segments, il y a deux possibilités selon que le deuxième point est un point sur ou pas
		  else
		    BiB1 = new BiBPoint(nbp.tab(0),nbp.tab(0)+w)
		    ifm2 = ifmac.childs(1)
		    if ifm2.ptsur <> 1 then
		      nbp.tab(1) = GetCoordChild(ifmac.childs(1))
		      nbp.tab(1) = nbp.tab(1).projection(BiB1)   //OK si le deuxième point n'est ni pt d'inter  ni un point construit, mais on ne voit pas comment  ce serait possible
		    else
		      ifm3 = MacInf.GetInfoMac(ifm2.forme0,num)    //infomac de l'objet sur lequel est le point (pas nécessairement identique à ifm1)
		      BiB2 = new BiBPoint(ifm3.coord.tab(ifm2.numside0), ifm3.coord.tab((ifm2.numside0+1)mod ifm3.coord.taille))
		      n1 = 0
		      if ifm3.fa <> 5 then
		        if ifm3.fo < 3 then
		          n2 = 2
		        else
		          n2 = 0
		        end if
		        nbp.tab(1) = BiB1.BiBInterDroites(BiB2,n1,n2,r1,r2)
		      else
		        n = BiB1.BibDroiteInterCercle(BiB2,u(),q,v)
		        if n >0 then
		          nbp.tab(1)=u(0)
		        else
		          nbp.tab(1)=nil
		        end if
		      end if
		      'ifm2.location = nbp.tab(1).Location(BiB2)
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Inter(ifmac as infomac, byref nbp as nBPoint)
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
		  nextre0 = NextreDroite(fa0,fo0)
		  
		  mid1 = ifmac.forme1
		  ifm1 = MacInf.GetInfoMac(mid1, num)
		  fa1 = ifm1.fa
		  fo1 = ifm1.fo
		  nb1 = ifm1.coord
		  nextre1 = NextreDroite(fa1,fo1)
		  
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
		Sub Construction(ifmac as InfoMac, byref nbp as nBPoint)
		  dim i, n, m, num as integer
		  dim ifm1, ifm2, ifm3 as infomac
		  dim Bib as BiBPoint
		  
		  if ifmac.fa = 0 then
		    redim nbp.tab(0)
		    ifm1 =  MacInf.GetInfoMac(ifmac.forme1,num)
		    if ifm1.macid = ifmac.forme1 then
		      nbp.tab(0) = ifm1.coord.tab(0)
		    else
		      nbp.tab(0) = ifm1.coord.tab(num)
		    end if
		  else
		    redim nbp.tab(ifmac.ncpts-1)
		    for i = 0 to ifmac.ncpts-1
		      ifm1 = ifmac.childs(i)
		      ifm2 = MacInf.GetInfoMac(ifm1.MacId, num)
		      if ifm2.macid = ifm1.MacId then
		        nbp.tab(i) = ifm2.coord.tab(0)
		      else
		        nbp.tab(i) = ifm2.coord.tab(num)
		      end if
		    next
		    nbp.constructshape(ifmac.fa, ifmac.fo)
		    'for i = 0 to ifmac.ncpts-1
		    'ifm1 = ifmac.childs(i)
		    'if ifm1.ptsur = 1 then
		    'ifm3 = MacInf.GetInfoMac(ifm1.forme0,num)
		    'ifm1.location = ifm1.coord.tab(0).location(ifm3.coord.tab(ifm1.numside0), ifm3.coord.tab((ifm1.numside0+1) mod ifm3.coord.taille))
		    'end if
		    'next
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Caption
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub extend(ifmac as InfoMac, byref nbp as nBPoint)
		  dim index, num as integer
		  dim ifm1 as infomac
		  
		  ifm1 = MacInf.GetInfoMac(ifmac.forme0,num)
		  index = ifmac.numside0
		  nbp.append ifm1.coord.tab(index)
		  nbp.append ifm1.coord.tab((index+1) mod ifm1.coord.taille)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub dupliquerpoint(EL0 as XMLElement, EL1 as XMLElement, ifm1 as InfoMac, byref nbp as nBPoint)
		  dim id1, id0 ,  k, n, np, m, si0 as integer
		  dim fp, sp, bp as BasicPoint
		  dim nb as nBPoint
		  dim loc0 as double
		  
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
		  end if
		  
		  m = ObInterm.indexof(n)
		  if m <> -1 then        //Si c'est une forme intermédiaire
		    ifm = MacInf.GetInfoMac(n, num)
		    return ifm.location
		  end if
		  
		  //Si c'est un point qui n'est ni initial ni intermédiaire
		  
		  ifm = MacInf.GetSommet(numop-1,n,m)
		  return ifm.location
		  
		  
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
		  if M <> nil and M.v1 <> nil  then
		    for i = 0 to n-1
		      if nbp1.tab(i) <> nil then
		        nbp.tab(i) =  M*nbp1.tab(i)
		      else
		        nbp.tab(i) = nil
		      end if
		    next
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeMatrix(ifmac as InfoMac)
		  dim  tsftype, k as integer
		  dim n, MacId, m, ni as integer
		  dim nbp, nbp1 as nBpoint
		  dim bp as BasicPoint
		  dim ar(-1) as basicPoint
		  dim s as shape
		  
		  ni = MacInf.Ifmacs.indexof(ifmac)
		  MacId = ifmac.MacId
		  
		  nbp  = MacInf.GetInfoMac(MacId,m).coord
		  select case ifmac.type
		  case 1
		    ifmac.M = nbp.TranslationMatrix
		  case 2
		    ifmac.M = nbp.RotationMatrix
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
		    s.tsfi.element(ifmac.num).setfpsp(s)
		    s.tsfi.element(ifmac.num).M =  ifmac.M
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeObject(ifmac as InfoMac, EL as XMLElement)
		  dim  oper,  MacId as integer
		  dim s as shape
		  dim nbp as new nBPoint
		  dim p as point
		  dim i as integer
		  
		  MacId = ifmac.MacId //numéro pour la macro de la forme construite
		  
		  if Obinit.indexof(MacId) <> -1 then        //Si c'est une forme initiale
		    s = currentcontent.theobjects.getshape(ifmac.RealId)
		    if ifmac.seg then
		      ifmac.coord = new BiBPoint
		      for i = 0 to 1
		        ifmac.coord.append s.points((ifmac.RealSide +i) mod s.npts).bpt
		      next
		    else
		      ifmac.coord = s.GetCoord
		    end if
		    if oper = 19 then            //Dupliquer Point  -- On met ifmac à jour
		      ifmac.location = point(s).location(0)
		      ifmac.numside1 = point(s).numside(0)
		    end if
		  end if
		  
		  if ObInterm.indexof(MacId) <> -1 then  //Si c'est une forme intermédiaire
		    ExeOper(ifmac, EL,nbp)                                     //on recalcule ou récupère les coordonnées
		    ifmac.coord = nbp
		    for i =0 to ifmac.npts-1
		      ifmac.childs(i).coord = new nBPoint(nbp.tab(i))
		    next
		  end if
		  
		  if (ObFinal.indexof(MacId) <> -1)  then      //Si c'est une forme finale
		    ExeOper(ifmac, EL,nbp)
		    ifmac.coord = nbp
		    //On recalcule les coordonnées
		    s = currentcontent.theobjects.getshape(ifmac.RealId)
		    s.coord = ifmac.coord
		    s.repositionnerpoints
		    'for i = 0 to s.npts-1
		    'if s.points(i).pointsur.count = 1 then
		    's.points(i).puton ( s.points(i).pointsur.element(0), ifmac.childs(i).location)
		    's.modified = true
		    'end if
		    'next
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
		              'MacroExe(CurrentContent.CurrentOperation).DrapPoint = true ' le drapeau indique qu'on est en train de s'occuper d'un
		              return i                                                                                                  ' de la forme de macid Pid plutôt que de cette forme rlle-même
		            end if
		          next
		        end if
		      end if
		    end if
		  next
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCoordChild(ifm as infomac) As BasicPoint
		  dim m, n0, n1 as integer
		  dim p as point
		  dim bp as BasicPoint
		  dim ifm1 as infomac
		  dim Bib as BiBPoint
		  
		  
		  if ifm.init then                                                      'si le point cherché est un point initial
		    n0 = MacInf.GetRealInit(ifm.MacId)
		    p = point(currentcontent.theObjects.Getshape(n0))
		    bp=p.bpt
		  else
		    select case ifm.ptsur
		    case 0, 2                                                                    'cas des points libres et aussi des points  d'inter ou des pts construits
		      ifm1 = MacInf.GetInfoMac(ifm.MacId,m)
		      if ifm1.MacId = ifm.MacId then
		        bp = ifm1.coord.tab(0)
		      else     'Si le point cherché n'est pas ptsur, c'est un sommet de la forme dont on reçoit l'infomac, son numéro nous suffit
		        bp = ifm1.coord.tab(m)
		      end if                              'Il faut aller chercher ses coord dans sa première occurrence dans un objet (on remonte dans les infomac)
		    case 1                                 'sinon il faut le recalculer donc savoir sur qulle forme il est ptsur; cela se trouve dans son infomac personnel , ifm
		      n0 = ifm.numside0
		      ifm1 = MacInf.GetInfoMac(ifm.forme0, m)
		      if ifm1.fa <> 5 then
		        n1 = (n0+1) mod ifm1.coord.taille
		        Bib = new BiBPoint(ifm1.coord.tab(n0), ifm1.coord.tab(n1))
		        bp =BiB.BptOnBiBpt(ifm.location)
		      else                                                                         'cas des arcs et cercles
		        if ifm1.fo = 0 then
		          bp =BiBPoint(ifm1.coord).PositionOnCircle(ifm.location,ifm1.ori)
		        elseif ifm1.fo=1 then
		          bp = TriBPoint(ifm1.coord).PositionOnArc(ifm.location,ifm1.ori)
		        end if
		      end if
		    end select
		  end if
		  return bp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextreDroite(fa as integer, fo as integer) As integer
		  
		  dim nextre as integer
		  
		  select case fa
		  case  1
		    if (fo = 3 or fo = 4 or fo = 5) then
		      nextre = 0
		    elseif fo = 6 then
		      nextre = 1
		    else
		      nextre = 2
		    end if
		  case 2, 3, 4, 6
		    nextre = 2
		  end select
		  return nextre
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Validation(ifmac As infomac) As Boolean
		  dim i as integer
		  dim t as Boolean
		  
		  if ifmac.fa = 0 then
		    return ifmac.coord.tab(0) <> nil
		  else
		    t = true
		    for i = 0 to ifmac.npts-1
		      t = t and ifmac.coord.tab(i) <> nil
		    next
		    return t
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PointSur(ifmac as infomac, byref nbp as nbpoint)
		  dim  MacId, side, num as integer
		  dim ifm1 as infomac
		  dim Bib as BiBPoint
		  
		  
		  redim nbp.tab(0)
		  
		  MacId = ifmac.MacId
		  ifm1 = MacInf.GetInfoMac(ifmac.forme0,num)
		  side = Ifmac.Numside0
		  BiB = new BiBpoint( ifm1.coord.tab(side), ifm1.coord.tab((side+1) mod ifm1.coord.taille))
		  nbp.tab(0) = BiB.BptOnBibpt(ifmac.location)
		  
		End Sub
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
	#tag EndViewBehavior
End Class
#tag EndClass
