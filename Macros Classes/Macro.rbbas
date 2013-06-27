#tag Class
Protected Class Macro
	#tag Method, Flags = &h0
		Sub Macro()
		  wnd.MenuBar.child("Fenetres").Item(wnd.GetNumWindow).text = Dico.Value("MacrosCreate")
		  wnd.refreshtitle
		  wnd.refresh
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Sauvegarder()
		  
		  
		  if ubound(ObFinal) = -1 then
		    return
		  end if
		  
		  CurrentContent.CurrentOperation = nil
		  wnd.refreshtitle
		  
		  Doc = CurrentContent.OpList
		  Histo = XMLElement(Doc.FirstChild)
		  Histo.AppendChild ToMac(Doc,"Initial",ObInit())
		  Histo.AppendChild ToMac(Doc,"Final",ObFinal())
		  Histo.AppendChild ToMac(Doc,"Interm",ObInterm())
		  SaveFileMacro
		  app.theMacros.addmac self
		  creermenuitem
		  wnd.closemacro
		  
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
		  Caption = GetName
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
		Function ToMac(Doc as XMLDocument, Categorie as string, ObCategorie() as integer) As XMLElement
		  dim Temp, EL as XmlElement
		  dim i as integer
		  dim s as shape
		  
		  Temp=Doc.CreateElement(Categorie)
		  for i = 0 to ubound(ObCategorie)
		    EL = Doc.CreateElement("Obj"+Categorie)
		    EL.SetAttribute("Id", str(ObCategorie(i)))
		    s = currentcontent.TheObjects.getshape(ObCategorie(i))
		    EL.SetAttribute("Fa",str(s.fam))
		    EL.SetAttribute("Fo",str(s.forme))
		    Temp.AppendChild EL
		  next
		  
		  return Temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveFileMacro()
		  Dim file As FolderItem
		  Dim tos as TextOutputStream
		  dim place as integer
		  dim i as integer
		  
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
		      Histo.SetAttribute("Name",Caption)
		      if expli <> "" then
		        Histo.RemoveChild Description
		        Description = Doc.CreateElement("Description")
		        Description.AppendChild Doc.CreateTextNode(expli)
		        Histo.appendChild Description
		      end if
		      tos.write Doc.tostring
		      tos.close
		    end if
		  End if
		  
		  if file = nil or tos = nil then
		    MsgBox Dico.Value("ErrorOnSave")
		  end if
		  
		  
		  
		  
		  
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
		  dim i, j, k, n, oper,  MacId as integer
		  dim EL, EL1 as XMLElement
		  dim codesoper() as integer
		  dim ifmac As InfoMac
		  dim s, newshape as shape
		  dim nbp as nBPoint
		  
		  codesoper = Array(0,1,14,16,19,28,33,35,37,39,17,24,25,26,27, 45)
		  
		  MacInf = MacInfo
		  
		  for i = 0 to Histo.Childcount-1  // i: numéro de l'opération
		    nbp = new nBPoint
		    numop = i
		    EL = XMLElement(Histo.Child(i))
		    
		    if EL.Name = Dico.Value("Operation") then
		      oper = val(EL.GetAttribute("OpId"))  //oper: code de l'opération
		      ifmac = MacInfo.ifmacs(i)
		      
		      if codesoper.indexof(oper) <> -1 then //est-ce une opération de construction ?
		        MacId = val(EL.Child(0).GetAttribute("Id"))  //numéro pour la macro de la forme construite
		        
		        if Obinit.indexof(MacId) <> -1 then        //Si c'est une forme initiale
		          ifmac.coord = Getcoord(MacId)
		          if oper = 19 then            //On met ifmac à jour
		            ifmac.location = GetLocation(MacId)
		            ifmac.side = GetSide(MacId)
		          end if
		        end if
		        
		        if ObInterm.indexof(MacId) <> -1 then  //Si c'est une forme intermédiaire
		          ExeOper(EL,nbp)                                     //on recalcule ou récupère les coordonnées
		          ifmac.coord = nbp
		          ifmac.location =loc0
		          ifmac.side = si0
		        end if
		        
		        k = ObFinal.indexof(MacId)
		        if k <> -1 then      //Si c'est une forme finale
		          ExeOper(EL,nbp)
		          ifmac.coord = nbp
		          ifmac.location = loc0
		          ifmac.side = si0                    //On recalcule les coordonnées
		          
		          s = currentcontent.theobjects.getshape(MacInf.RealFinal(k))
		          if s isa point then
		            point(s).moveto ifmac.coord.tab(0)
		          else                  //On va rechercher la forme
		            for j = 0 to ubound(s.points)
		              s.points(j).moveto ifmac.coord.tab(j)   //On repositionne les sommets
		            next
		          end if
		        end if
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
		  
		  
		  EL0 = XMLElement(EL.Child(0))                   'Forme construite
		  EL1 = XMLElement(EL.Child(1))                   'Instructions de construction (s'il y en a)
		  
		  oper = val(EL.GetAttribute("OpId"))
		  if EL1 <> nil and oper > 0 then                     'Données de l'éventuelle forme-constructeur
		    MacId = val(EL1.GetAttribute("Id"))
		    ifm1 = MacInf.GetInfoMac(MacId)
		  end if
		  
		  select case oper
		  case 0 //Construction
		    Construction(EL0,EL1,nbp)
		  case 1 //paraperp
		    paraperp(EL0,EL1,ifm1,nbp)
		  case 14 //Centre
		    centre(ifm1,nbp)
		  case 16 //Retourner
		  case 17 //TransfoConstruction
		  case 19 //Dupliquer
		    dupliquer(EL0,EL1,ifm1,nbp)
		  case 24 //AppliquerTsf
		  case 25 //Decouper
		  case 26 //Point de division
		    divide(EL0,EL1,ifm1,nbp)
		  case 27 //Fusionner
		  case 28 //Prolonger
		    extend(EL0,EL1,ifm1,nbp)
		  case 35 //Identifier
		  case 37 //FixPConstruction
		  case 39 //Flecher
		  case 45  //Point d'intersection
		    inter (EL0, EL1, nbp)
		  end select
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub centre(ifmac as InfoMac, Byref nbp as nBPoint)
		  nbp.append ifmac.coord.centre
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub divide(EL0 as XMLElement, EL1 as XMLElement, ifm1 as InfoMac, byref nbp as nBPoint)
		  dim id0, id1, idfather as integer
		  dim fp, sp as BasicPoint
		  dim ndiv, div as integer
		  dim ifm as InfoMac
		  dim Trib as TriBpoint
		  dim Bib as BiBPoint
		  
		  ndiv = val(EL1.GetAttribute("NDivP"))
		  div = val(EL1.GetAttribute("DivP"))
		  idfather = val(EL1.GetAttribute("Id"))
		  ifm = MacInf.GetInfoMac(idfather)
		  
		  if ifm.fa <> 5 and ifm.fa <> 7 then
		    Bib = new BiBPoint(ifm.coord)
		    nbp.append BiB.subdiv(ndiv,div)
		  elseif ifm.fa = 5 then
		    Trib = new TriBPoint(ifm.coord)
		    nbp.append TriB.subdiv(ifm.ori,ndiv, div)
		  else  'cas des lacets
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paraperp(EL0 as XMLElement, EL1 as XMLElement, ifmac as InfoMac, byref nbp as nBPoint)
		  dim p, q, w0, w as BasicPoint
		  dim n0, index, npt as integer
		  dim EL2, EL3 as XmlElement
		  dim ifm1, ifm2 as infoMac
		  dim pere, num as integer
		  dim c as nBPoint
		  
		  //On calcule d'abord le vecteur directeur de la paraperp
		  
		  index = val(EL1.GetAttribute("Index"))
		  
		  c = ifmac.coord
		  npt = c.taille
		  p = c.tab(index)
		  q = c.tab ((index+1) mod npt)
		  w0 = q - p
		  w=w0.normer
		  if val(EL1.GetAttribute("Oper")) = 2 Then
		    w=w.VecNorPerp
		  end if
		  
		  //Ensuite on recherche l'origine
		  EL2 = XMLElement(EL0.Child(0))
		  EL3 = XMLElement(EL2.Child(0))
		  n0 = val(EL3.GetAttribute("Id"))   //MacId de l'origine de la paraperp
		  ifm1 = MacInf.GetInfoMac(n0)
		  if ifm1 <> nil then                         //Cas d'un point isolé, on le retrouve illico
		    nbp.append ifm1.Coord.tab(0)
		  else                                                 //Sinon, il faut retourner chercher dans Histo quel est l'objet dont  l'origine de la paraperp est un sommet
		    GetInfoSommet(n0, pere, num)  //pere est la macid de la 1ere forme dont le point cherché est sommet et num est le numéro de ce sommet
		    ifm2 = MacInf.GetInfoMac(pere)
		    nbp.append ifm2.Coord.tab(num)
		  end if
		  nbp.Append nbp.tab(0)+w
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCoord(n as integer) As nBpoint
		  dim i, j, k, m as integer
		  dim s as shape
		  dim ifm as infomac
		  dim EL, EL0, EL1 as XMLElement
		  
		  m = Obinit.indexof(n)
		  if m <> -1 then        //Si c'est une forme initiale
		    k = MacInf.RealInit(m)
		    s= currentcontent.theobjects.getshape(k)
		    return new nBPoint(s)
		  end if
		  
		  m = ObInterm.indexof(n)
		  if m <> -1 then        //Si c'est une forme intermédiaire
		    ifm = MacInf.GetInfoMac(n)
		    return ifm.coord
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
		          return new nBPoint(ifm.coord.tab(j))
		        end if
		      next
		    end if
		  next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Inter(EL0 as XMLElement, EL1 as XMLElement, byref nbp As nBPoint)
		  dim EL10, EL11 as XMLElement
		  dim mid1, mid2, ncot1, ncot2 as integer
		  dim nb1, nb2 as nBPoint
		  dim Bib1, Bib2 as BiBPoint
		  dim r1, r2 as double
		  dim fa1, fa2, fo1, fo2 as integer
		  dim ar1() as integer
		  dim bp as BasicPoint
		  
		  EL10 = XMLElement(EL1.Child(0))
		  fa1 = val(EL10.GetAttribute(Dico.Value("NrFam")))
		  fo1 = val(EL10.GetAttribute(Dico.Value("NrForm")))
		  mid1 = val(EL10.GetAttribute("Id"))
		  nb1 = GetCoord(mid1)
		  
		  EL11 = XMLElement(EL1.Child(1))
		  fa2 = val(EL11.GetAttribute(Dico.Value("NrFam")))
		  fo2 = val(EL11.GetAttribute(Dico.Value("NrForm")))
		  mid2 = val(EL11.GetAttribute("Id"))
		  nb2 = GetCoord(mid2)
		  
		  if fa1 <> 5  then
		    ncot1 = val(EL1.GetAttribute("NumSide0"))
		    Bib1 = new BiBPoint(nb1.tab(ncot1), nb1.tab((ncot1+1) mod nb1.taille))
		  else
		  end if
		  if fa2 <> 5 then
		    ncot2 = val(EL1.GetAttribute("NumSide1"))
		    Bib2 = new BiBPoint(nb2.tab(ncot2), nb2.tab((ncot2+1) mod nb2.taille))
		  else
		  end if
		  
		  if fa1 <> 5 and fa2 <> 5 then
		    bp =  bib1.BiBInterDroites(Bib2,0,0,r1,r2)
		    if(( fa1 = 2) or (fa1 = 3) or (fa1 = 6) or (fa1 = 7)) and ((r1<0)or (r1> 1)) then
		      nbp.append nil
		    elseif(( fa2 = 2) or (fa2 = 3) or (fa2 = 6) or (fa2 = 7)) and ((r2<0)or (r2> 1)) then
		      nbp.append nil
		    else
		      nbp.append bp
		    end if
		    
		    
		  else
		    
		  end if
		  
		  
		  
		  
		  
		  
		  
		  // Encore considérer les intersections droite-cercle et cercle-cercle
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Construction(EL0 as XMLElement, EL1 as XMLElement, byref nbp As nBPoint)
		  dim MacId, i, n, oper as integer
		  dim ifm0, ifm1 as InfoMac
		  dim EL01, EL02 as XMLElement
		  dim nbp1 as nBPoint
		  dim fa, fo as integer
		  
		  fa = val(EL0.GetAttribute(Dico.Value("NrFam")))
		  fo = val(EL0.GetAttribute(Dico.Value("NrForm")))
		  if fa > 0 then
		    EL01 = XMLElement(EL0.FirstChild)
		  end if
		  
		  select case fa
		  case 0
		    MacId = val(EL0.GetAttribute("Id"))
		    nbp = GetCoord(MacId)
		  case 1
		    select case fo
		    case -1,0, 1, 2, 3, 4, 5, 6
		      n = 1
		    case 7,8
		      n = 2
		    end select
		  case 2
		    'select case fo
		    'case 0
		    n = 2
		    'end select
		  case 3
		    select case fo
		    case 7
		      n = 1
		    else
		      n = 3
		    end select
		  case 4
		    n = 1
		  case 5
		    select case fo
		    case 0
		      n = 1
		    else
		      n = 2
		    end select
		  case 6
		    n = fo+2
		  end select
		  
		  for i = 0 to n
		    EL02 = XMLElement(EL01.child(i))
		    MacId = val(EL02.GetAttribute("Id"))
		    nbp.append  GetCoord(MacId).tab(0)
		  next
		  nbp = nbp.constructshape(fa,fo)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetInfoSommet(mid as integer, byref pid as integer, byref index as integer)
		  dim i, j, n as integer
		  dim EL, EL0, EL1, EL2 as XMLElement
		  
		  for i = 0 to Histo.ChildCount-1
		    EL = XMLElement(Histo.Child(i))
		    if EL.Name =  Dico.Value("Operation") then
		      EL0 = XMLElement(EL.Child(0))
		      EL1= XMLElement(EL0.Child(0))
		      for j = 0 to EL1.Childcount -1
		        EL2 = XMLElement(EL1.Child(j))
		        n = val(EL2.GetAttribute("Id"))
		        if n = mid then
		          index = j
		          pid = val(EL0.GetAttribute("Id"))
		          return
		        end if
		      next
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Histo.GetAttribute("Name")
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
		Sub dupliquer(EL0 as XMLElement, EL1 as XMLElement, ifm1 as InfoMac, byref nbp as nBPoint)
		  dim id1, id0 ,  k, n, np as integer
		  dim fp, sp, bp as BasicPoint
		  dim nb as nBPoint
		  
		  id1 =  val(EL1.GetAttribute("Id")) //point source
		  loc0 = GetLocation(id1)
		  si0 = GetSide(id1)
		  
		  k = val(EL1.GetAttribute("Data0")) //Point image
		  n = val(EL0.GetAttribute("PointSur"))
		  nb = GetCoord(n)
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
		  dim i, j, k, m as integer
		  dim s as shape
		  dim ifm as infomac
		  dim EL, EL0, EL1 as XMLElement
		  
		  m = Obinit.indexof(n)
		  if m <> -1 then        //Si c'est une forme initiale
		    k = MacInf.RealInit(m)
		    s= currentcontent.theobjects.getshape(k)
		    if s isa point and point(s).pointsur.count = 1 then
		      return point(s).location(0)
		    end if
		  end if
		  
		  m = ObInterm.indexof(n)
		  if m <> -1 then        //Si c'est une forme intermédiaire
		    ifm = MacInf.GetInfoMac(n)
		    return ifm.location
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
		          return ifm.location
		        end if
		      next
		    end if
		  next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSide(n as integer) As integer
		  dim i, j, k, m as integer
		  dim s as shape
		  dim ifm as infomac
		  dim EL, EL0, EL1 as XMLElement
		  
		  m = Obinit.indexof(n)
		  if m <> -1 then        //Si c'est une forme initiale
		    k = MacInf.RealInit(m)
		    s= currentcontent.theobjects.getshape(k)
		    if s isa point and point(s).pointsur.count = 1 then
		      return point(s).numside(0)
		    end if
		  end if
		  
		  m = ObInterm.indexof(n)
		  if m <> -1 then        //Si c'est une forme intermédiaire
		    ifm = MacInf.GetInfoMac(n)
		    return ifm.side
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
		          return ifm.side
		        end if
		      next
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
		Histo As XMLElement
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
		Doc As XMLDocument
	#tag EndProperty

	#tag Property, Flags = &h0
		MacInf As MacConstructionInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		NumOp As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Expli As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Description As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		loc0 As double
	#tag EndProperty

	#tag Property, Flags = &h0
		si0 As Integer
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
