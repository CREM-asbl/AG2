#tag Class
Protected Class Macro
	#tag Method, Flags = &h0
		Sub centre(ifmac as infomac, byref nbp As nBPoint)

		  dim infoMac as infomac
		  dim num as integer

		  infoMac= MacInf.GetInfoMac(ifmac.forme0, num)
		  nbp.append infoMac.coord.centre
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeFix(ifmac as infomac, nbp as nBPoint)
		  dim M as Matrix
		  dim infoMac as InfoMac
		  dim num as integer

		  infoMac = MacInf.GetInfoMac(ifmac.forme0,num)
		  M = infoMac.M
		  if M <> nil and M.v1 <> nil then
		    nbp.append M.fixpt
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeMatrix(ifmac As infomac)
		  dim  m as integer
		  dim nbp as nBpoint
		  dim s as shape
		  dim infoMac as infomac

		  infoMac = MacInf.GetInfoMac(ifmac.forme0,m)
		  if infoMac.MacId <> ifmac.forme0 then
		    infoMac = infoMac.childs(m)
		  end if
		  nbp = infoMac.coord
		  select case ifmac.type
		  case 1
		    infoMac.M = nbp.TranslationMatrix
		  case 2
		    infoMac.M = nbp.RotationMatrix
		  case 3
		    infoMac.M = new rotationmatrix(nbp.tab(0), PI)
		  case 4
		    infoMac.M = new rotationmatrix(nbp.tab(0),PIDEMI)
		  case 5
		    infoMac.M = new rotationmatrix(nbp.tab(0), -PIDEMI)
		  case 6
		    infoMac.M = new SymmetryMatrix(nbp.tab(0),nbp.tab(1))
		  case 7,8
		    infoMac.M = nbp.SimilarityMatrix
		  case 9,11
		    infoMac.M = nbp.EtirCisailMatrix
		  case 10
		    infoMac.M = nbp.IsometryMatrix
		  end select

		  'k = ObFinal.indexof(MacId)
		  if  infoMac.final then      //Si le support est une forme finale ou initiale
		    s = currentcontent.theobjects.getshape(ifmac.RealId)
		    s.tsfi.item(ifmac.num).setfpsp(s)
		    s.tsfi.item(ifmac.num).M =  infoMac.M
		  end if

		  Exception err
		    var d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("m", m)
		    d.setVariable("s", s)
		    d.setVariable("nbp", nbp)
		    d.setVariable("infoMac", infoMac)
		    err.Message = "Erreur dans " + CurrentMethodName + ": " + err.message + d.getString
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeObject(ifmac as InfoMac)
		  dim MacId as integer
		  dim s as shape
		  dim nbp as new nBPoint
		  dim i as integer
		  dim maxIndex as integer

		  MacId = ifmac.MacId //numéro pour la macro de la forme construite

		  //Si la forme considérée est initiale, il suffit de récolter les informations dans la liste des objets précédemment créés.
		  if Obinit.indexof(MacId) <> -1 then
		    s = currentcontent.theobjects.getshape(ifmac.RealId)
		    if ifmac.seg then
		      ifmac.coord = s.GetBiBSide(ifmac.RealSide)
		    else
		      ifmac.coord = s.GetCoord
		      if s isa point and s.forme=1 then
		        ifmac.location = point(s).location(0)  //On ne tient pas compte de la valeur figurant dans la macro
		      end if
		    end if
		    if ifmac.childs.Count > 0 then
		      for i = 0 to ifmac.childs.Count-1
		        if i < ifmac.coord.taille then
		          ifmac.childs(i).coord = new nbPoint(ifmac.coord.tab(i))
		        end if
		      next
		    end if
		  end if

		  if ObInterm.indexof(MacId) <> -1 then  //Si c'est une forme intermédiaire
		    ExeOper(ifmac, nbp)                                     //on recalcule ou récupère les coordonnées
		    ifmac.coord = nbp
		    if nbp <> nil and nbp.taille > 0 then
		      if ifmac.npts-1 < nbp.taille-1 then
		        maxIndex = ifmac.npts-1
		      else
		        maxIndex = nbp.taille-1
		      end if
		      for i = 0 to maxIndex
		        ifmac.childs(i).coord = new nBPoint(nbp.tab(i))
		      next
		    end if
		  end if

		  if (ObFinal.indexof(MacId) <> -1)  then      //Si c'est une forme finale
		    ExeOper(ifmac, nbp)
		    if nbp = nil or nbp.taille = 0 then
		      return
		    end if
		    ifmac.coord = nbp
		    for i = 0 to ifmac.npts-1
		      if i >= nbp.taille or nbp.tab(i) = nil then
		        return
		      end if
		    next

		    //On recalcule les coordonnées
		    s = currentcontent.theobjects.getshape(ifmac.RealId)
		    if s isa point then
		      point(s).bpt=ifmac.coord.tab(0)
		      s.coord=ifmac.coord
		      if s.forme = 1 then
		        redim point(s).location(-1)
		        redim point(s).numside(-1)
		        redim point(s).location(0)
		        redim point(s).numside(0)
		        point(s).location(0) = ifmac.location
		        point(s).numside(0) = ifmac.numside0
		        ifmac.RealSide = ifmac.numside0
		      end if
		    end if
		    for i = 0 to s.npts-1
		      if i < ifmac.coord.taille then
		        s.coord.tab(i) = ifmac.coord.tab(i)
		        if i < ifmac.childs.count and s.points(i).forme=1 then
		          redim s.points(i).location(-1)
		          redim s.points(i).numside(-1)
		          redim s.points(i).location(0)
		          redim s.points(i).numside(0)
		          s.points(i).location(0) = ifmac.childs(i).location
		          s.points(i).numside(0) = ifmac.childs(i).numside0
		          ifmac.childs(i).RealSide =  ifmac.childs(i).numside0
		        end if
		      end if
		    next
		    s.repositionnerpoints
		  end if

		  Exception err
		    var d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("MacID", MacId)
		    d.setVariable("s", s)
		    d.setVariable("nbp", nbp)
		    d.setVariable("i", i)
		    err.Message = err.message + d.getString
		    Raise err

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Construction(ifmac as infomac, byref nbp As nBPoint)
		  dim i,  num as integer
		  dim ifm1, ifm2 as infomac
		  dim p as point

		  if ifmac.fa = 0 then
		    redim nbp.tab(-1)
		    redim nbp.tab(0)
		    ifm1 =  MacInf.GetInfoMac(ifmac.forme1,num)
		    if ifm1.macid = ifmac.forme1 then
		      nbp.tab(0) = ifm1.coord.tab(0)
		    else
		      nbp.tab(0) = ifm1.coord.tab(num)
		    end if
		  else
		    redim nbp.tab(-1)
		    redim nbp.tab(ifmac.npts-1)
		    for i = 0 to ifmac.ncpts-1
		      ifm1 = ifmac.childs(i)
		      if ifm1.init = true then
		        p = point(currentcontent.theobjects.getshape(ifm1.RealId))
		        ifm1.coord = p.GetCoord
		        nbp.tab(i) = ifm1.coord.tab(0)
		        if  p.forme=1 then
		          ifm1.location = p.location(0)  //On ne tient pas compte de la valeur figurant dans la macro
		        end if
		      else
		        ifm2 = MacInf.GetInfoMac(ifm1.MacId, num)
		        if ifm2.macid = ifm1.MacId then
		          nbp.tab(i) = ifm2.coord.tab(0)
		        else
		          if num < ifm2.npts then
		            nbp.tab(i) = ifm2.coord.tab(num)
		          else
		            nbp.tab(i) = ifm2.childs(num).coord.tab(0)
		          end if
		        end if
		      end if
		    next
		    nbp.constructshape(ifmac.fa, ifmac.fo)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  codesoper = Array(0,1,14,16,19,28,35,37,39,24,25,26,27,43,45,46)  //codes des opérations
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Doc as XMLDocument)
		  Dim List As XMLNodeList
		  dim Temp, EL1 As  XMLElement
		  dim i as integer


		  Constructor()
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
		  'Histo.RemoveChild Temp

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
		  'Histo.RemoveChild Temp

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
		  'Histo.RemoveChild Temp


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CopyMacroToFile()
		  Dim file As FolderItem              //Sauvegarde d'une macro dans le dossier "Macros" de Mes Documents/Apprenti Geometre lors de la création de la macro
		  Dim tos as TextOutputStream
		  dim place as integer
		  Dim dlg as New SaveAsDialog



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
		      tos.write  histo.tostring
		      tos.close
		    end if
		  end if

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
		Sub divide(ifmac as infomac, byref nbp As nBPoint)
		  dim num, num1, num2 as integer
		  dim Trib as TriBpoint
		  dim Bib as BiBPoint
		  dim bp1, bp2 as BasicPoint
		  dim ifm, ifm1, ifm2 as infomac

		  ifm = MacInf.GetInfoMac(ifmac.Forme0, num)  //ifmac correspondant à l'objet constructeur
		  ifm1 = MacInf.GetInfoMac(ifmac.forme1,num1)

		  if ifm1 <> nil then
		    if ifm1.macid = ifmac.forme1 then
		      bp1 = ifm1.coord.tab(0)
		    else
		      bp1=ifm1.childs(num1).coord.tab(0)
		    end if
		  end if

		  ifm2 = MacInf.GetInfoMac(ifmac.forme2,num2)
		  if ifm2 <> nil then
		    if ifm2.macid = ifmac.forme2 then
		      bp2 = ifm2.coord.tab(0)
		    else
		      bp2=ifm2.childs(num2).coord.tab(0)
		    end if
		  end if

		  if ifm.fa <> 5 and ifm.fa <> 7 then
		    Bib = new BiBPoint(bp1,bp2)
		    nbp.append BiB.subdiv(ifmac.ndiv,ifmac.idiv)
		  elseif ifm.fa = 5 then
		    'if ifm.fo = 0 and ifm.coord.taille = 2 then
		    'Trib = new TriBPoint(ifm.coord.tab(0),ifm.coord.tab(1),ifm.coord.tab(1))
		    'else
		    Trib = new TriBPoint(ifm.coord.tab(0),bp1,bp2)
		    'end if
		    nbp.append TriB.subdiv(ifm.ori,ifmac.ndiv, ifmac.idiv)
		  elseif ifm1.fa = 7 then                                     'cas des lacets
		  end if


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub dupliquerpoint(ifmac as infomac, byref nbp As nBPoint)
		  dim num0, side, m as integer
		  dim nb as nBPoint
		  dim ifm0, ifm1 as infomac
		  dim Bib as BiBPoint

		  if ifmac.ptsur <> 1 then
		    return
		  end if

		  ifm1 = MacInf.GetInfoMac(ifmac.forme2,m)
		  if ifm1.macId <> ifmac.forme2 then
		    ifm1 = ifm1.childs(m)       //infomac du dupliqué
		  end if

		  // Si le dupliqué est
		  ifmac.location = ifm1.location
		  side = ifmac.numside1                           //numero de coté du dupliqué
		  ifm0 = MacInf.GetInfoMac(ifmac.Forme0, num0)   //ifmac du support du duplicat
		  side = (side+ifmac.num) mod ifm0.npts                   //numero du coté du duplicat
		  ifmac.numside0 = side
		  nb = ifm0.coord
		  BiB = new BiBPoint (nb.tab(side), nb.tab((side+1) mod nb.taille))
		  nbp.append BiB.BptOnBiBpt(ifmac.location)



		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Elaguer()
		  dim i, ObId as integer
		  dim EL, EL1 as XMLElement

		  for i = Histo.childcount -1 downto 0
		    EL = XMLElement(Histo.Child(i))
		    EL1 = XMLElement(EL.firstChild)
		    if EL1 <> nil then
		      ObId = val(EL1.GetAttribute("Id"))
		      if currentcontent.theobjects.getshape(ObId) = nil then
		        Histo.RemoveChild EL
		      end if
		    end if
		  next

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExeOper(ifmac as infomac, byref nbp As nBPoint)
		  select case ifmac.oper
		  case 0 //Construction
		    Construction(ifmac, nbp)
		  case 1 //paraperp
		    paraperp(ifmac,nbp)
		  case 14 //Centre
		    centre(ifmac,nbp)
		  case 16 //Retourner
		  case 19 //Dupliquer
		    dupliquerpoint(ifmac,nbp)
		  case 24 //AppliquerTsf
		    Transformer(ifmac,nbp)
		  case 25 //Decouper
		  case 26 //Point de division
		    divide(ifmac, nbp)
		  case 27 //Fusionner
		  case 28 //Prolonger
		    extend(ifmac, nbp)
		  case 35 //Identifier  Pour mémoire
		  case 37 //FixPConstruction
		    computefix(ifmac,nbp)
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
		Function GetName() As string
		  return Caption
		End Function
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
		Sub MacExe(MacInfo as MacConstructionInfo)
		  dim i, j as integer
		  dim ifmac As InfoMac
		  dim s as shape

		  //Dans cette phase, on calcule les objets et on met les valeurs numériques dans l'objet IfMac associé

		  MacInf = MacInfo

		  for i = 0 to ubound(MacInf.ifmacs)    'Histo.Childcount-1  // i: numéro de l'opération
		    ifmac = MacInfo.ifmacs(i)
		    if codesoper.indexof(ifmac.oper) <> -1 then //est-ce une opération de construction d'un objet?
		      ComputeObject(ifmac)
		    elseif ifmac.oper =17 then                          'On doit calculer la matrice de la transfo et la stocker dans l'infomac du support
		      ComputeMatrix(ifmac)
		    end if

		    if not (currentcontent.currentoperation isa macroexe) and not (ifmac.oper = 17) then
		      if Validation(ifmac) then
		        for j = 0 to ubound(ObFinal)
		          s = currentcontent.TheObjects.getshape(MacInfo.RealFinal(j))
		          s.Valider
		        next
		      else
		        for j = 0 to ubound(ObFinal)
		          s = currentcontent.TheObjects.getshape(MacInfo.RealFinal(j))
		          s.invalider
		        next
		      end if
		    end if
		  next
		End Sub
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
		Sub OpenDescripWindow()
		  mw = new MacWindow(self)
		  mw.Title = GetName + " : " + Dico.Value("MacroDescription") +" " + caption
		  mw.EF.Text = expli
		  WorkWindow.setfocus

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paraperp(ifmac as infomac, byref nbp As nBPoint)
		  dim  q,v, w, u(1)  as BasicPoint
		  dim n,  n1, n2, side as integer
		  dim  ifm1, ifm2, ifm3 as infoMac
		  dim  num, macid as integer
		  dim BiB1, BiB2 as BiBPoint
		  dim r1, r2 as double


		  MacId = ifmac.MacId
		  ifm1 = MacInf.GetInfoMac(ifmac.forme0,num)
		  side = Ifmac.Numside0
		  //On calcule d'abord le vecteur directeur de la paraperp
		  BiB1 =BiBPoint(ifm1.coord.getBiBSide(side))  'new BiBPoint(c.tab(side), c.tab((side+1) mod c.taille))
		  n = 1
		  if ifmac.fo = 2 or ifmac.fo = 5 Then
		    n = 2
		  end if
		  w=BiB1.VecNorParaPerp(n)
		  redim nbp.tab(-1)
		  redim  nbp.tab(1)
		  //Ensuite on recherche l'origine
		  nbp.tab(0) = ifmac.childs(0).coord.tab(0)    'GetCoordChild(ifmac.childs(0))
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
		      nbp.tab(1) =  ifm2.coord.tab(0).projection(BiB1)   //OK si le deuxième point n'est ni pt d'inter  ni un point construit, mais on ne voit pas comment  ce serait possible
		    else
		      ifm3 = MacInf.GetInfoMac(ifm2.forme0,num)    //infomac de l'objet sur lequel est le point (pas nécessairement identique à ifm1)
		      BiB2 = BiBPoint(ifm3.coord.GetBiBSide(ifm2.numside0))
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
		    end if

		  end if

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PointSur(ifmac as infomac, byref nbp As nBPoint)
		  dim   side, num as integer
		  dim ifm1 as infomac
		  dim Bib as BiBPoint
		  dim Trib as TriBPoint

		  redim nbp.tab(-1)
		  redim nbp.tab(0)


		  ifm1 = MacInf.GetInfoMac(ifmac.MacId,num)

		  if ifm1.fa <> 5 then 'cas des segments, droites, côtés de polygones,...
		    side = Ifmac.Numside0
		    if ifm1.fa = 1 and ifm1.fo = 8 then
		      BiB = new BiBPoint(ifm1.coord.tab(0),ifm1.coord.tab(side+1))
		    elseif ifm1.fa = 1 and ifm1.fo = 7 then
		      if side = 0 then
		        BiB = new BiBPoint(ifm1.coord.tab(0),ifm1.coord.tab(1))
		      else
		        BiB = new BiBPoint(ifm1.coord.tab(2),ifm1.coord.tab(2)+ifm1.coord.tab(1)-ifm1.coord.tab(0))
		      end if
		    else
		      BiB = BiBPoint(ifm1.coord.GetBiBSide(side))
		    end if
		    nbp.tab(0) = BiB.BptOnBibpt(ifmac.location)
		  else
		    select case  ifm1.fo
		    case  0   'cas des cercles
		      BiB = new BiBpoint( ifm1.coord.tab(0), ifm1.coord.tab(1))
		      nbp.tab(0) = BiB.PositionOnCircle(ifmac.location, ifm1.ori)
		    case 1 'cas des arcs
		      TriB = new TriBpoint( ifm1.coord.tab(0), ifm1.coord.tab(1), ifm1.coord.tab(2))
		      nbp.tab(0) = TriB.PositionOnCircle(ifmac.location, ifm1.ori)
		    end select
		  end if

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveFileMacro()
		  Dim file As FolderItem              //Sauvegarde d'une macro dans le dossier "Macros" de Mes Documents/Apprenti Geometre lors de la création de la macro
		  Dim tos as TextOutputStream
		  dim place as integer
		  dim Doc as XMLDocument
		  dim Histo as XMLElement
		  Dim dlg as New SaveAsDialog
		  dim d as new Date

		  if ubound(ObFinal) = -1 then
		    return
		  end if

		  CurrentContent.CurrentOperation = nil
		  WorkWindow.refreshtitle

		  Doc = CurrentContent.OpList
		  Histo = XMLElement(Doc.FirstChild)
		  Histo.SetAttribute("Creation_Date",d.ShortDate)
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
		      WorkWindow.updatesousmenusmacros
		    end if
		  end if





		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument, n as integer) As XMLElement
		  dim Temp, EL as XMLElement
		  dim i as integer
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
		    EL.SetAttribute("Fa",str(FaCategorie(i)))
		    EL.SetAttribute("Fo",str(FoCategorie(i)))
		    Temp.AppendChild EL
		  next

		  return Temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function toString() As String
		  return Histo.ToString
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
		Sub Transformer(ifmac as infomac, byref nbp As nBPoint)
		  dim  i, n, num as integer
		  dim nbp1 as nBPoint
		  dim M as Matrix
		  dim ifm1, ifm2 as infomac


		  ifm1 = MacInf.GetInfoMac(ifmac.forme0, num)  //lecture support
		  if ifm1.MacId <> ifmac.forme0 and num <> -1 then
		    ifm1=ifm1.childs(num)
		  end if
		  ifm2 = MacInf.GetInfoMac(ifmac.forme1, num)  //lecture source
		  if ifm2.MacId <> ifmac.forme1 then
		    ifm2 = ifm2.childs(num)
		  end if
		  nbp1 = ifm2.coord
		  n = nbp1.taille
		  redim nbp.tab(-1)
		  redim nbp.tab(n-1)
		  M = ifm1.M
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
		Sub Trier()
		  ObInit.sortwith(FaInit,FoInit)
		  ObInterm.sortwith(FaInterm,FoInterm)
		  ObFinal.sortwith(FaFinal,FoFinal)
		End Sub
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
		Description As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		Expli As string
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
		Histo As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		MacInf As MacConstructionInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		mw As MacWindow
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


	#tag ViewBehavior
		#tag ViewProperty
			Name="Caption"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Expli"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
