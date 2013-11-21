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
		  
		  //Cette classe a pour objet de choisir de nouveaux objets initiaux et de construire la MacConstructionInfo associée
		  //Dans SetItem, complété par "InstructionsSuivantes", on se borne à créer les "InfoMac" associés aux différentes opérations de la macro et d'y placer
		  //les informations ne changeant pas d'une instance de la macro à une autre (essentiellement les id-macros et les numéros de forme et de famille).
		  
		  //Dans le DoOperation, on appelle la méthode MacExe de la classe Macro qui se charge de calculer tous les bpt des objets intermédiaires et finaux
		  // Quand on revient à MacroExe, il reste à créer les objets finaux et mettre en place les informations à utiliser lors d'une modification.
		  
		  //La routine MacExe  de Macro est également utilisée lors des modifications d'une figure contenant des macros.
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return "MacroExe "
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(s as shape) As Boolean
		  MacInfo.RealInit.append s.id
		  MacInfo.RealSide.append side
		  s.init = true
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim obj as string
		  
		  
		  
		  currentshape = currenthighlightedshape
		  
		  if visible  = nil or currentshape = nil then
		    display = choose + un + " " +str
		  else
		    if side <> -1 then
		      polygon(currentshape).paintside(g,side,2,config.highlightcolor)
		      currentshape.unhighlight
		      obj = lowercase(segment)
		    else
		      obj = lowercase(currenthighlightedshape.gettype)
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
		  dim i, j, k, n, m, index, p, type,oper, fa, fo, side as integer
		  dim EL, EL0 as XMLElement
		  dim codesoper() as integer
		  dim ifmac As InfoMac
		  dim s, newshape as shape
		  dim bp() as BasicPoint
		  dim pt as Point
		  
		  
		  codesoper = Array(0,1,14,16,19,28,35,37,39,17,24,25,26,27,43,45)  //codes des opérations
		  
		  
		  for i = 0 to Histo.Childcount-1  // i : numéro de l'opération
		    EL = XMLElement(Histo.Child(i))
		    if EL.Name = Dico.Value("Operation") then  //est-ce une opération de construction ? prévoir le cas contraire!
		      //Pour les points d'intersection, ptsur = 0 (ils sont traités comme résultant d'une opération d'inter (code 45))
		      oper = val(EL.GetAttribute("OpId"))                           //oper: code de l'opération
		      if codesoper.indexof(oper) = -1 then
		        return
		      end if
		      EL0 = XMLElement(EL.Child(0))
		      n = val(EL0.GetAttribute("Id"))                    //numéro pour la macro de la forme construite (à placer dans la MacId)
		      if (Mac.ObInit.indexof(n) = -1) and  (Mac.ObInterm.indexof(n)  = -1) and  (Mac.ObFinal.indexof(n)  = -1) then
		        return
		      end if
		      
		      fa = val(EL0.GetAttribute(Dico.Value("NrFam")))
		      fo = val(EL0.GetAttribute(Dico.Value("NrForm")))
		      ifmac = new InfoMac(fa, fo)
		      ifmac.ptsur = val(EL0.GetAttribute("PointSur"))
		      ifmac.MacId = n
		      
		      if Mac.ObInit.indexof(n) <> -1 then
		        ifmac.RealId =MacInfo.RealInit(Mac.ObInit.indexof(n))
		        ifmac.init = true
		        s = currentcontent.TheObjects.GetShape(ifmac.RealId)
		        ifmac.coord = s.coord
		      end if
		      if Mac.ObInterm.indexof(n) <> -1 then
		        ifmac.interm = true
		      end if
		      if Mac.ObFinal.indexof(n) <> -1 then // A-t-on affaire  à un objet final?
		        CreateFinal(oper,ifmac,EL0)
		        ifmac.RealId = MacInfo.RealFinal(Mac.ObFinal.indexof(n))
		        ifmac.final = true
		      end if
		      MacInfo.IfMacs.append ifmac
		    end if
		  next
		  
		  mac.macexe(macinfo)                                       //Exécution de la macro: calcul des positions de tous les points
		  
		  for i = 0 to ubound(MacInfo.RealFinal)           //Création des skulls des objets finaux
		    n = MacInfo.RealFinal(i)
		    s = objects.GetShape(n)
		    if s isa point then
		      s.createskull(point(s).bpt)
		      point(s).mobility
		    else
		      for j = 0 to s.npts-1
		        s.createskull(s.points(j).bpt)
		        s.points(j).mobility
		      next
		    end if
		    s.endconstruction
		    s.setMacConstructedBy(MacInfo)
		    s.CreateExtreAndCtrlPoints
		    s.updateskull
		  next
		  
		  
		  
		  wnd.mycanvas1.refreshbackground
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.EndOperation
		  if mw <> nil then
		    mw.close
		    MacInfo = new MacConstructionInfo(Mac)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim n,i, fa, fo as integer
		  dim  sh as shape
		  dim b as boolean
		  
		  n = CurrentItemToSet
		  
		  sh = operation.getshape(p)
		  fa = mac.fainit(n-1)
		  fo = mac.foinit(n-1)
		  str = lowercase(identifier(fa, fo))
		  nobj = visible.count
		  
		  for i = visible.count-1 downto 0
		    sh = visible.element(i)
		    b = (sh.fam <> fa)
		    
		    select case fa   //une macro valable pour (par ex) un Triangle doit pouvoir être appliquée à un triangiso ou un triangrect ou...
		    case 1               //une macro valable pour un segment  (fa = 1, fo < 3) doit pouvoir être appliquée à un côté de polygone
		      select case fo
		      case 0
		        b = not sh.validsegment(p, side)   ' b or (sh.forme  > 2)
		      case 3
		        b = b or ((sh.forme <3) or (sh.forme > 5))
		      case 6,7,8
		        b = b or (sh.forme  <> fo)
		      end select
		    case 2
		      select case fo
		      case 0
		        b = b and not (sh.fam=6 and sh.forme = 0)
		      case 1
		        b = b or (sh.forme =0) or (sh.forme = 3)
		      case 2
		        b = not (sh isa polreg and sh.npts = 3)
		      case 3
		        b = b or (sh.fam < 3)
		      case  4
		        b = b or (sh.forme <> fo)
		      end select
		    case 3
		      select case fo
		      case 0
		        b = b and not (sh.fam=6 and sh.forme = 1)
		      case 1
		        b = b or (sh.forme > 3)
		      case 2, 3, 5, 6
		        b = b or (sh.forme <> fo)
		      case 4
		        b = b or (sh.fam < 4)
		      case 7
		        b = not (sh isa polreg and sh.npts = 4)
		      end select
		    case 4
		      b = not (sh isa polreg and sh.npts = fo+3)
		    case 5
		      b = b or sh.forme <> fo
		    case 6
		      b = not (sh isa polygon and sh.npts = fo+3)
		    end select
		    
		    if b then
		      visremove(sh)
		    end if
		  next
		  
		  nobj = visible.count-1
		  redim index(nobj)
		  
		  iobj = 0
		  
		  for i = 0 to visible.count-1
		    sh = visible.element(i)
		    'if sh isa droite then
		    'index(i) = 0
		    if sh isa polygon then
		      index(i) = polygon(sh).pointonside(p)
		    else
		      index(i)=-1
		    end if
		  next
		  
		  sh = visible.element(iobj)
		  if sh = nil then
		    return nil
		  end if
		  side = index(iobj)  // side <> -1 ssi on a choisi un côté de polygone
		  return sh
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateFinal(oper as integer, ifmac as InfoMac, EL0 as XMLElement)
		  dim newshape, s as shape
		  dim EL1, EL2 as XMLElement
		  dim i, j, m, n, p, pid, index, fa, fo as integer
		  dim pt as point
		  
		  newshape = objects.createshape(ifmac.fa,ifmac.fo)
		  newshape.initconstruction
		  newshape.MacConstructedBy = MacInfo
		  for i = 0 to ubound(MacInfo.Realinit)
		    s = currentcontent.Theobjects.getshape(MacInfo.Realinit(i))
		    s.addMacConstructedshape newshape
		  next
		  
		  select case oper
		  case 0
		    EL1 = XMLElement(EL0.Child(0))   //EL1 contient la description des points de newshape
		    
		    for j = 0 to newshape.ncpts-1  //On considère les points de construction un à un
		      EL2 = XMLElement(EL1.Child(j))
		      m = val(EL2.GetAttribute("Id"))     //m est l'id dans la macro du point associé à newshape.points(j)
		      
		      p = -1
		      index = -1
		      Mac.GetInfoSommet(m, pid, index, fa , fo)  //pid est la Macro-Id du premier parent dans la macro du point associé à newshape.points(j). Normalement pid <> -1
		      //On peut avoir m = pid si le point associé à newshape.points(j) est un point isolé
		      //index est le  numéro de newshape.points(j) dans ce premier parent (fa et fo sont relatifs au parent)
		      p = Mac.ObInit.indexof(pid)
		      
		      if p <> -1 then                                                                     //points(j) appartient à un objet initial ou est un objet initial
		        n = MacInfo.RealInit(p)                                                                 //p est l'id de l'objet initial en question
		        s = currentcontent.TheObjects.GetShape(n)             // s est cet objet initial
		        
		        if index = 0  then                          //newshape.points(j) correspond à un point initial isolé
		          pt = point(s)
		          newshape.substitutepoint(pt,newshape.points(j))
		          
		        end if
		      end if
		    next
		  end select
		  currentcontent.addshape newshape
		  MacInfo.RealFinal.append newshape.id
		  
		  
		End Sub
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
		  dim EL, EL1, Obj as XMLElement
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
		  dim EL, EL1, Obj as XMLElement
		  dim i, n as integer
		  dim s as shape
		  dim List as XmlNodeList
		  dim t as Boolean
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
		  ReDeleteDeletedFigures (Temp)
		  RecreateCreatedFigures(Temp)
		  wnd.refresh
		End Sub
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
	#tag EndViewBehavior
End Class
#tag EndClass
