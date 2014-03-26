#tag Class
Protected Class MacroExe
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub MacroExe(n as integer)
		  MultipleSelectOperation()
		  OpId = 43
		  Mac = app.TheMacros.element(n)
		  NumberOfItemsToSelect = ubound(mac.obinit) +1
		  MacInfo = new MacConstructionInfo(Mac)
		  Histo = Mac.Histo
		  mw = new MacWindow
		  mw.Title = Mac.GetName + " : " + Dico.Value("MacroDescription")
		  mw.EditField1.Text = Mac.expli
		  wnd.setfocus
		  fa = -1
		  
		  
		  
		  //Cette classe a pour objet de choisir de nouveaux objets initiaux et de construire la MacConstructionInfo associée
		  //Dans SetItem, complété par "InstructionsSuivantes", on se borne à déterminer les objets initiaux
		  
		  //Dans le DoOperation, on commence par créer les "InfoMac" associés aux différentes opérations de la macro et d'y placer
		  //les informations ne changeant pas d'une instance de la macro à une autre (essentiellement les id-macros et les numéros de forme et de famille).
		  
		  // ensuite,  on appelle la méthode MacExe de la classe Macro qui se charge de calculer tous les bpt des objets intermédiaires et finaux
		  // Quand on revient à MacroExe, il reste à créer les objets finaux et mettre en place les informations à utiliser lors d'une modification.
		  
		  //La routine MacExe  de Macro est également utilisée lors des modifications d'une figure contenant des macros.
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("MacroExe ")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(s as shape) As Boolean
		  //Les deux infos doivent toujours être lues ensemble: l'id de l'objet choisi et le numéro de côté (0 s'il n'y en a qu'un)
		  MacInfo.RealInit.append s.id
		  MacInfo.RealInitSide.append side
		  s.init = true
		  fa = -1
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim obj as string
		  
		  currentshape = currenthighlightedshape
		  
		  if visible  = nil or currentshape = nil then
		    if drappoint  then
		      display = choose +un +" "+ point
		    else
		      display = choose + un + " " +str
		    end if
		  else
		    if currentshape isa polygon and side <> -1 and fa = 1 then
		      currentshape.unhighlight
		      polygon(currentshape).paintside(g,side,2,config.highlightcolor)
		      obj = lowercase(segment)
		    elseif drappoint and currentshape isa point then
		      obj ="point"
		      currentshape.highlight
		    else
		      obj = lowercase(currenthighlightedshape.gettype)
		      currentshape.highlight
		    end if
		    operation.paint(g)
		    if obj = "arc" then
		      display = cet + " " + obj + " ?"
		    else
		      display = ce + " " + obj + " ?"
		    end if
		  end if
		  
		  Help g, display
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i, n, oper  as integer
		  dim EL as XMLElement
		  dim codesoper() as integer
		  dim s as shape
		  
		  codesoper = Array(0,1,14,16,19,28,35,37,39,24,25,26,27,43,45,46)  //codes des opérations
		  
		  for i = 0 to Histo.Childcount-1  // i : numéro de l'opération
		    EL = XMLElement(Histo.Child(i))
		    if EL.Name = Dico.Value("Operation") then  //est-ce une opération de construction (forme ou tsf) ? prévoir le cas contraire!
		      //Pour les points d'intersection, ptsur = 0 (ils sont traités comme résultant d'une opération d'inter (code 45))
		      oper = val(EL.GetAttribute("OpId"))                           //oper: code de l'opération
		      if codesoper.indexof(oper) <>  -1 then
		        CreateIfMacObject(EL,oper)
		      elseif oper = 17 then
		        CreateIfMacTsf(EL,oper)
		      end if
		    end if
		  next
		  
		  mac.macexe(macinfo)                                       //Exécution de la macro: calcul des positions de tous les points ou de la matrice
		  
		  for i = 0 to ubound(MacInfo.RealFinal)           //Création des skulls des objets finaux
		    n = MacInfo.RealFinal(i)
		    s = objects.GetShape(n)
		    if s isa point then
		      s.createskull(point(s).bpt)
		      point(s).mobility
		    else
		      s.createskull(s.points(0).bpt)
		    end if
		  next
		  
		  wnd.mycanvas1.refreshbackground
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  
		  super.EndOperation
		  drappoint = false
		  if mw <> nil then
		    mw.close
		    mw=nil
		  end if
		  MacInfo = new MacConstructionInfo(Mac)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim n,i as integer
		  dim  sh as shape
		  dim b as boolean
		  
		  
		  
		  sh = operation.getshape(p)
		  str = lowercase(identifier(fa, fo))
		  nobj = visible.count-1
		  redim index(nobj)
		  selectionnerobjetini(p)
		  for i = 0 to visible.count-1
		    sh = visible.element(i)
		    index(i) =sh.pointonside(p)
		  next
		  sh = visible.element(iobj)
		  if sh = nil then
		    return nil
		  end if
		  side = index(iobj)
		  return sh
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateFinal(ifmac as InfoMac) As shape
		  dim  s, newshape as shape
		  dim i as integer
		  
		  
		  newshape = objects.createshape(ifmac.fa,ifmac.fo)
		  newshape.autos
		  newshape.initconstruction
		  newshape.ori = ifmac.ori
		  newshape.MacConstructedBy = MacInfo
		  for i = 0 to ubound(MacInfo.Realinit)
		    s = currentcontent.Theobjects.getshape(MacInfo.Realinit(i))
		    s.addMacConstructedshape newshape
		  next
		  if ifmac.oper = 19 then
		    s = currentcontent.Theobjects.getshape(MacInfo.GetRealId(ifmac.forme0))
		    point(newshape).puton s, ifmac.location
		    point(newshape).ifmac = ifmac
		  end if
		  currentcontent.addshape newshape
		  if ifmac.fa = 1 and (ifmac.fo=4 or ifmac.fo = 5)  then
		    newshape.points(1).hide
		    newshape.ncpts = 1
		  end if
		  if newshape isa arc then
		    arc(newshape).drapori = true
		  end if
		  MacInfo.RealFinal.append newshape.id
		  ifmac.RealId = newshape.id
		  ifmac.final = true
		  for i = 0 to newshape.npts-1
		    if ifmac.childs(i).RealId = 0 then                           //cas où des points devront être identifiés
		      ifmac.childs(i).RealId = newshape.points(i).id
		    end if
		  next
		  return newshape
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  dim EL0, EL1 as XMLElement
		  dim i as integer
		  dim s as shape
		  
		  EL0 = Doc.CreateElement(Dico.value("Macro"))
		  EL0.setAttribute("Name", Mac.Caption)
		  EL1 =  Doc.CreateElement("Initial_Forms")
		  for i = 0 to ubound(MacInfo.RealInit)
		    s = Objects.Getshape(MacInfo.RealInit(i))
		    EL1.appendchild s.XMLPutIdInContainer(Doc)
		  next
		  EL0. appendchild EL1
		  EL1 =  Doc.CreateElement("Final_Forms")
		  for i = 0 to ubound(MacInfo.RealFinal)
		    s = Objects.Getshape(MacInfo.RealFinal(i))
		    EL1.appendchild s.XMLPutIdInContainer(Doc)
		  next
		  EL0.appendchild EL1
		  return EL0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MacroExe(Macr as Macro)
		  Super.MultipleSelectOperation
		  Mac = Macr
		  OpId = 43
		  NumberOfItemsToSelect = ubound(macr.obinit) +1
		  Histo = Macr.Histo
		  MacInfo = new MacConstructionInfo(Mac)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim  EL1, Obj as XMLElement
		  dim i, n as integer
		  dim s as shape
		  dim List as XmlNodeList
		  
		  List = Temp.FirstChild.XQL("Final_Forms")
		  
		  If list.Length > 0 then
		    Obj= XMLElement(List.Item(0))
		    if obj.childcount > 0 then
		      for i = Obj.Childcount-1 downto 0
		        EL1 = XMLelement(Obj.Child(i))
		        n = val(EL1.GetAttribute("Id"))
		        s = objects.Getshape(n)
		        s.delete
		      next
		    end if
		  end if
		  List = Temp.FirstChild.XQL("Initial_Forms")
		  
		  If list.Length > 0 then
		    Obj= XMLElement(List.Item(0))
		    if obj.childcount > 0 then
		      for i =0 to  Obj.Childcount-1
		        EL1 = XMLelement(Obj.Child(i))
		        n = val(EL1.GetAttribute("Id"))
		        s = objects.Getshape(n)
		        s.init = false
		      next
		    end if
		  end if
		  
		  ReDeleteCreatedFigures (Temp)
		  RecreateDeletedFigures(Temp)
		  wnd.refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim  EL1, Obj as XMLElement
		  dim i, n as integer
		  dim s as shape
		  dim List as XmlNodeList
		  dim t as Boolean
		  dim Nom as string
		  
		  
		  Nom = Temp.child(0).GetAttribute("Name")
		  Mac = App.TheMacros.GetMacro(Nom)
		  currentcontent.currentoperation = new macroexe(mac)
		  if Mac = Nil then
		    return
		  end if
		  
		  MacInfo = new MacConstructionInfo(Mac)
		  List = Temp.FirstChild.XQL("Initial_Forms")
		  If list.Length > 0 then
		    Obj= XMLElement(List.Item(0))
		    if obj.childcount > 0 then
		      for i =0 to  Obj.Childcount-1
		        EL1 = XMLelement(Obj.Child(i))
		        n = val(EL1.GetAttribute("Id"))
		        s = objects.Getshape(n)
		        t = setitem(s)
		      next
		    end if
		  end if
		  DoOperation
		  wnd.refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateIfMacObject(EL as XMLElement, oper as integer)
		  dim i, n as integer
		  dim EL0, EL1 as XMLElement
		  dim ifmac, ifm As InfoMac
		  dim s, newshape as shape
		  
		  //Pemière partie: création de l'infomac
		  EL0 = XMLElement(EL.Child(0))
		  EL1 = XMLElement(EL.Child(1))
		  n = val(EL0.GetAttribute("Id"))
		  
		  if (Mac.ObInit.indexof(n) <> -1) or  (Mac.ObInterm.indexof(n) <> -1) or  (Mac.ObFinal.indexof(n)  <> -1) then
		    ifmac = new InfoMac(MacInfo, EL0,EL1,oper)
		    
		    //Deuxième partie : adaptation selon la classe (init, interm, final)
		    
		    if Mac.ObInit.indexof(n) <> -1 then
		      ifmac.RealId =MacInfo.GetRealInit(n)
		      ifmac.init = true
		      s = currentcontent.TheObjects.GetShape(ifmac.RealId)
		      s.ifmac = ifmac
		      if ifmac.npts < s.npts then
		        ifmac.seg = true
		        ifmac.RealSide = MacInfo.GetRealSide(n)
		      end if
		      for i = 0 to ifmac.npts-1
		        ifmac.childs(i).RealId =s.points((i+ifmac.RealSide) mod s.npts).id
		      next
		      ifmac.ori = s.ori
		      
		    end if
		    
		    if Mac.ObInterm.indexof(n) <> -1 then
		      ifmac.interm = true
		      for i = 0 to ubound(ifmac.childs)
		        ifm = ifmac.childs(i)
		        if Mac.ObInit.indexof(Ifm.MacId) <> -1 then
		          ifm.RealId = MacInfo.GetRealInit(Ifm.MacId)
		        end if
		      next
		    end if
		    
		    if (Mac.ObFinal.indexof(n) <> -1)  then // A-t-on affaire  à un objet final?
		      newshape = CreateFinal(ifmac)
		      IdentifyPoints(newshape, ifmac,EL0)
		      newshape.endconstruction
		      newshape.ifmac = ifmac
		      for i = 0 to newshape.npts-1
		        newshape.points(i).forme = ifmac.childs(i).fo
		        if newshape.points(i).forme = 1 then
		          s = currentcontent.TheObjects.getshape(MacInfo.GetRealId(ifmac.childs(i).forme0))
		          newshape.points(i).puton s, ifmac.childs(i).location
		          newshape.points(i).numside(0) = ifmac.childs(i).numside0
		          newshape.points(i).placerptsursurfigure
		          newshape.points(i).ifmac = ifmac.childs(i)
		        end if
		      next
		      
		    end if
		    
		    MacInfo.IfMacs.append ifmac
		    
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateIfMacTsf(EL as XMLElement, oper as integer)
		  dim  EL0 as XMLElement
		  dim ifmac as InfoMac
		  dim fa, fo as integer
		  dim s as shape
		  dim tsf as transformation
		  
		  EL0 = XMLElement(EL.Child(0))
		  
		  fa = val(EL0.GetAttribute(Dico.Value("NrFam")))  //concerne le support
		  fo = val(EL0.GetAttribute(Dico.Value("NrForm")))
		  ifmac = new InfoMac(fa, fo)
		  ifmac.oper = oper
		  ifmac.forme0 = val(EL0.GetAttribute("Id"))   //numéro pour la macro du support de la tsf
		  ifmac.type = val(EL.GetAttribute("TsfType"))
		  ifmac.ori = val(EL.GetAttribute("TsfOri"))
		  ifmac.RealSide = val(EL.GetAttribute("TsfSide"))
		  ifmac.RealId =  MacInfo.GetRealId(ifmac.forme0)
		  MacInfo.IfMacs.append ifmac
		  
		  if ifmac.RealId <> -1 then
		    s = objects.getshape(ifmac.RealId)
		    tsf = CreateTsf(s, ifmac.type,ifmac.Realside, ifmac.ori)
		    ifmac.num = s.tsfi.GetPosition(tsf)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateTsf(s as shape, n as integer, cote as integer, ori as integer) As transformation
		  dim tsf as Transformation
		  
		  tsf = new transformation
		  tsf.supp = s
		  tsf.type = n
		  tsf.index = cote
		  tsf.ori = ori
		  
		  if n <> 0 and  (n < 3 or n > 6 ) then
		    tsf.T = new Tip
		  end if
		  
		  tsf.setfpsp(s)
		  CurrentContent.TheTransfos.AddTsf(tsf)
		  s.tsfi.addtsf tsf
		  
		  return tsf
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(p as BasicPoint)
		  dim MacId, PId,  ninstruc as integer
		  dim EL, EL1 as XMLElement
		  
		  
		  if fa = -1 and CurrentItemToSet > 0 then                               //fa = -1: sert à ne passer qu'une fois dans cette partie de la routine
		    MacId = Mac.ObInit(CurrentItemtoSet-1)
		    ninstruc = Mac.GetInstrucConstruction(MacId, PId)
		    EL = XMLElement(Mac.Histo.Child(ninstruc))
		    EL1 = XMLElement(EL.FirstChild)
		    if MacId = PId then
		      fa = val(EL1.GetAttribute(Dico.Value("NrFam")))       //l'objet initial à choisir est soit une forme  "autonome" soit (si drappoint est true)
		      fo = val(EL1.GetAttribute(Dico.Value("NrForm")))    //un sommet d'une telle forme. Dans les deux cas fa et fo concernent la forme
		    else
		      fa = 0  'l'objet à choisir est un point
		      fo = 0
		    end if
		  end if
		  super.mousemove(p)  //appelle getshape
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IdentifyPoints(newshape as shape, ifmac as InfoMac, EL0 as XMLElement)
		  
		  dim EL1, EL2 as XMLElement
		  dim j, m,  num as integer
		  dim ifm as infomac
		  dim pt as point
		  
		  EL1 = XMLElement(EL0.Child(0))   //EL1 contient la description des points de newshape
		  
		  for j = 0 to newshape.ncpts-1  //On considère les points de construction un à un
		    pt = nil
		    EL2 = XMLElement(EL1.Child(j))
		    m = val(EL2.GetAttribute("Id"))     //m est la macid  du point associé à newshape.points(j)
		    ifm = MacInfo.GetInfoMac(m,num)
		    if ifm <> nil and (ifm.init or ifm.final)   then
		      if ifm.MacId = m then
		        pt  = point(CurrentContent.TheObjects.Getshape(ifm.RealId))
		      else
		        'ifm.childs(num) = ifmac.childs(j)
		        pt = point(Currentcontent.TheObjects.Getshape(ifmac.childs(j).Realid))
		      end if
		      if pt <> nil and pt <> newshape.points(j) then
		        pt.moveto newshape.points(j).bpt
		        newshape.substitutepoint(pt,newshape.points(j))
		      end if
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SelectionnerObjetIni(p as BasicPoint)
		  dim i as integer
		  dim b as Boolean
		  dim sh as shape
		  
		  
		  for i = visible.count-1 downto 0
		    sh = visible.element(i)
		    b = (sh.fam = fa)
		    
		    select case fa                        //une macro valable pour (par ex) un Triangle doit pouvoir être appliquée à un triangiso ou un triangrect ou...
		    case 1               //une macro valable pour un segment  (fa = 1, fo < 3) doit pouvoir être appliquée à un côté de polygone
		      select case fo
		      case 0
		        b = (b and sh.forme <3) or  sh.validsegment(p, side)
		      case 1, 2, 4, 5, 6, 7, 8
		        b = b and (sh.forme = fo)
		      case 3
		        b = b and ((sh.forme >2)  and  (sh.forme < 6))
		      end select
		    case 2
		      select case fo
		      case 0
		        b = b or (sh isa polreg and sh.npts = 3)
		      case 1
		        b =( b and ((sh.forme =1) or (sh.forme = 2)or (sh.forme = 4))) or (sh isa polreg and sh.npts = 3)
		      case 2
		        b = (b and  (sh.forme = 2)) or ( sh isa polreg and sh.npts = 3)
		      case 3, 4
		        b = b and  (sh.forme = fo)
		      end select
		    case 3
		      select case fo
		      case 0
		        b = b or  (sh isa polreg and sh.npts = 4)
		      case 1
		        b = b and (sh.forme > 0) 'and (sh.forme < 4)
		      case 2
		        b = ( b and (sh.forme  =2 or sh.forme = 5 or sh.forme = 7)) or  (sh isa polreg and sh.npts = 4)
		      case 3
		        b = (b and (sh.forme > 2)) or  (sh isa polreg and sh.npts = 4)
		      case 4
		        b = b and (sh.forme >= 4)
		      case 5
		        b = (b and (sh.forme = 5 or sh.forme = 7)) or  (sh isa polreg and sh.npts = 4)
		      case 6, 7
		        b = (b and sh.forme = fo) or (sh isa polreg and sh.npts = 4)
		      end select
		    case 4, 5, 6
		      b = b and sh.forme = fo
		    end select
		    
		    if not b then
		      visremove(sh)
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument, EL as XMLElement) As XMLElement
		  dim EL0, EL1, EL01 as XMLElement
		  dim i as integer
		  dim s as shape
		  
		  EL0 =  Doc.CreateElement("Final_Forms")
		  for i = 0 to ubound(MacInfo.RealFinal)
		    s = Objects.Getshape(MacInfo.RealFinal(i))
		    EL0.appendchild s.XMLPutIdInContainer(Doc)
		  next
		  EL.appendchild EL0
		  
		  EL1 = Doc.CreateElement(Dico.value("Macro"))
		  EL1.setAttribute("Name", Mac.Caption)
		  EL01 =  Doc.CreateElement("Initial_Forms")
		  for i = 0 to ubound(MacInfo.RealInit)
		    s = Objects.Getshape(MacInfo.RealInit(i))
		    EL1.appendchild s.XMLPutIdInContainer(Doc)
		  next
		  EL. appendchild EL1
		  
		  return EL
		  
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Mac As Macro
	#tag EndProperty

	#tag Property, Flags = &h0
		MacInfo As MacConstructionInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		Histo As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		mw As MacWindow
	#tag EndProperty

	#tag Property, Flags = &h0
		side As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		str As string
	#tag EndProperty

	#tag Property, Flags = &h0
		fa As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		fo As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		drappoint As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ntsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentItemToSet"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="MultipleSelectOperation"
		#tag EndViewProperty
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
			Name="Std2flag"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SidetoPaint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="info"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="str"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fa"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fo"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drappoint"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
