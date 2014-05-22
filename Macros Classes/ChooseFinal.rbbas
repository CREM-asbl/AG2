#tag Class
Protected Class ChooseFinal
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub ChooseFinal()
		  dim i as integer
		  dim s as shape
		  
		  SelectOperation
		  OpId = 42
		  drapcoul = false
		  finished = false
		  NumberOfItemsToSelect = 1
		  CurrentItemToSet = 1
		  Mac = currentcontent.mac
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.value("MacrosFinaux")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i as integer
		  dim s as shape
		  
		  drapcoul = true
		  objects.unselectall
		  
		  currentshape.unhighlight
		  IdentifyInit(currentshape)
		  
		  for i = 1 to currentcontent.TheObjects.count -1
		    s =  currentcontent.TheObjects.element(i)
		    if DejaClasse(s) <> -1 then
		      fixecouleurs(s)
		    end if
		  next
		  wnd.mycanvas1.refreshbackground
		  showattraction
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IdentifyInit(s as shape)
		  'currentshape est l'objet sélectionné comme final
		  
		  if s = currentshape and Mac.ObFinal.indexof(s.id) = -1 then
		    addfinal(currentshape)
		  elseif dejaclasse(s) <> -1 then
		    return
		  end if
		  
		  if s isa point then
		    pointidentifyinit(point(s))
		    return
		  end if
		  
		  if s.constructedby = nil and s.MacConstructedby = nil then
		    IdentifyInit1(s)
		  else
		    IdentifyInit2(s)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g As Graphics)
		  
		  Super.Paint(g)
		  
		  
		  if CurrentHighLightedShape <> nil then
		    display = click+pour+selectionner
		  else
		    display =  choose + aform + ou + savethemacro
		  end if
		  
		  Help g, display
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecouleurs(s as shape)
		  dim t as integer
		  
		  t = dejaclasse(s)
		  
		  select case t
		  case 2
		    s.fixecouleurtrait(blue,100)
		    s.borderwidth = 2
		  case 0
		    s.fixecouleurtrait(red, 100)
		    s.borderwidth = 2
		  case 1
		    s.fixecouleurtrait(black,100)
		  else
		    s.fixecouleurtrait(grey,100)
		  end select
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddFinal(s as shape)
		  if DejaClasse(s) <> 2 then 'and not s.init and not s.interm
		    mac.ObFinal.append s.id
		    mac.FaFinal.append s.fam
		    mac.FoFinal.append s.forme
		  end if
		  
		  // Les id ci-dessus sont relatifs à la macro
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddInit(s as shape)
		  dim i as integer
		  
		  if s isa point and not s.isptsur then
		    for i = 0 to ubound(point(s).parents)
		      if DejaClasse(point(s).parents(i))  =  0  then
		        return
		      end if
		    next
		  end if
		  
		  if  DejaClasse(s) = -1 then
		    mac.ObInit.append s.id
		    mac.FaInit.append s.fam
		    mac.FoInit.append s.forme
		  end if
		  
		  // Les id ci-dessus sont relatifs à la macro
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddInterm(s as shape)
		  if  DejaClasse(s) = -1 then
		    mac.ObInterm.append  s.id
		    mac.FaInterm.append s.fam
		    mac.FoInterm.append s.forme
		  end if
		  
		  // Les id ci-dessus sont relatifs à la macro
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s as shape
		  dim i, j as integer
		  
		  s = super.getshape(p)
		  
		  if visible.count > 0 then
		    for i =  visible.count-1 downto 0
		      s = Visible.element(i)
		      if DejaClasse(s) = 2 then
		        visible.removeshape s
		        nobj = visible.count
		      end if
		    next
		  end if
		  
		  if Visible.count > 0  then
		    return visible.element(iobj)
		  else
		    return nil
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  dim i, j as integer
		  dim s as shape
		  
		  CurrentItemtoSet = NumberOfItemsToSelect +1
		  mac.Histo = currentcontent.Histo
		  mac.Elaguer
		  mac.ObInit.sort
		  mac.ObInterm.sort
		  mac.ObFinal.sort
		  
		  for i =  currentcontent.TheObjects.count -1 downto 1
		    s =  currentcontent.TheObjects.element(i)
		    if DejaClasse(s) <> -1 then
		      fixecouleurs(s)
		    else
		      s.delete
		    end if
		    if not s isa point then
		      for j = 0 to s.npts-1
		        fixecouleurs(s.points(j))
		      next
		    end if
		  next
		  super.endoperation
		  
		  mw = new  MacWindow
		  mw.mac = mac
		  mw.ShowModal
		  currentcontent.currentoperation = nil
		  MenuMenus.Child("MacrosMenu").Child("MacrosFinaux").checked = false
		  wnd.EraseMenuBar
		  wnd.CopyMenuBar
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(s as shape) As Boolean
		  if s = nil then
		    return false
		  end if
		  
		  currentshape = s
		  NumberOfItemsToSelect = NumberofItemsToSelect+1
		  DoOperation
		  return true
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddTsfInterm(tsf As Transformation)
		  if not tsf.Final  then
		    tsf.Interm = true
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PointIdentifyInit(p as point)
		  dim op as integer
		  dim t as boolean
		  dim i as integer
		  
		  if p.constructedby = nil and p.macconstructedby = nil  then
		    PointIdentifyInit1(p)
		  else
		    PointIdentifyInit2(p)
		    'elseif NbreParentsNonFinal(p) <= 0 then
		    'AddInit(p)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbreParentsNonFinal(p as point) As integer
		  dim i, n as integer
		  for i = 0 to ubound(p.parents)
		    if DejaClasse(p.parents(i)) <> 2 then
		      n = n+1
		    end if
		  next
		  
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DejaClasse(s as shape) As integer
		  dim t as integer
		  
		  if  Mac.Obinit.indexof(s.id) <> -1 then
		    t = 0
		  elseif   Mac.ObInterm.indexof(s.id) <> -1 then
		    t = 1
		  elseif  Mac.ObFinal.indexof(s.id) <> -1 then
		    t = 2
		  else
		    t = -1
		  end if
		  return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IdentifyInit1(s as shape)
		  dim t as Boolean  'Cas des formes non construites par une autre
		  dim i, n as integer
		  
		  t = true
		  n = EtapeDeConstruction(s)
		  for i =0 to s.ncpts-1
		    t = t and (EtapeDeConstruction(s.points(i)) = n)
		  next
		  if t then
		    AddInit(s)
		  else
		    AddInterm(s)
		    for i = 0 to s.ncpts-1
		      if EtapeDeConstruction(s.points(i)) < n then
		        PointIdentifyInit(s.points(i))
		      else
		        AddInit(s.Points(i))
		      end if
		    next
		  end if
		  return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IdentifyInit2(s as shape)
		  dim tsf as transformation
		  dim macinfo as MacConstructionInfo
		  dim sh as shape
		  dim i as integer
		  
		  AddInterm(s)          // s est une forme construite
		  if s.constructedby <> nil then
		    IdentifyInit(s.constructedby.shape)
		    select case s.constructedby.oper
		    case 1,2
		      pointidentifyinit(s.points(0))
		      if droite(s).nextre=2 then
		        pointidentifyinit(s.points(1))
		      end if
		    case 3, 5, 9
		    case  6 ' Transfos
		      tsf = transformation(s.constructedby.Data(0))
		      AddTsfInterm(tsf)
		      IdentifyInit(tsf.supp)
		    case 8  'Prolongements (A faire)
		    end select
		  elseif s.MacConstructedby <> nil then
		    MacInfo = s.MacConstructedBy
		    for i = 0 to ubound(MacInfo.RealInit)
		      sh = objects.getshape(MacInfo.RealInit(i))
		      identifyinit(sh)
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EtapeDeConstruction(s as shape) As integer
		  dim i, j as integer
		  dim EL, EL1, EL2, EL3 as XMLElement
		  
		  for i =0 to currentcontent.Histo.childcount -1
		    EL = XMLElement(currentcontent.Histo.Child(i))
		    EL1 = XMLElement(EL.Child(0))
		    if s.id = val(EL1.GetAttribute("Id")) then
		      return i
		    elseif val(EL1.GetAttribute(Dico.Value("Npts"))) > 0 then
		      EL2 = XMLElement(EL1.Child(0))
		      for j = 0 to EL2.ChildCount -1
		        EL3=XMLElement(EL2.Child(j))
		        if s.id = val(EL3.GetAttribute("Id")) then
		          return i
		        end if
		      next
		    end if
		  next
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PointIdentifyInit2(p as point)
		  dim op as integer  'cas des points construits
		  dim macinfo as MacConstructionInfo
		  dim sh as shape
		  dim i as integer
		  
		  AddInterm(p)
		  
		  if p.constructedby <> nil then
		    op = p.constructedby.oper
		    select case op
		    case 0, 3, 5,  7
		      IdentifyInit(p.constructedby.shape)
		    case 4
		      IdentifyInit(p.constructedby.shape)
		      IdentifyInit(p.constructedby.data(0))
		      IdentifyInit(p.constructedby.data(1))
		    case 6
		      IdentifyInit(p.constructedby.shape)
		      IdentifyInit(transformation(p.constructedby.Data(0)).supp)
		    case 7
		      IdentifyInit(p.constructedby.shape)
		    case 9
		      //A compléter
		    case 10
		      IdentifyInit(p.pointsur.element(0))
		      identifyinit(p.constructedby.shape)
		    end select
		    
		  elseif p.macconstructedby <> nil then
		    MacInfo = p.MacConstructedBy
		    for i = 0 to ubound(MacInfo.RealInit)
		      sh = objects.getshape(MacInfo.RealInit(i))
		      identifyinit(sh)
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PointIdentifyInit1(p as point)
		  'cas des points non construits
		  dim t as Boolean
		  dim i, n as integer
		  
		  
		  if p.pointsur.count = 2 then
		    AddInterm(p)
		    IdentifyInit(p.pointsur.element(0))
		    IdentifyInit(p.pointsur.element(1))
		  else
		    n = EtapeDeConstruction(p)
		    t = true
		    for i = 0 to ubound(p.parents)
		      t = t and ( n  < EtapedeConstruction(p.parents(i)) )
		    next
		    if t then
		      Addinit(p)
		    else
		      'if p.constructing  then   'forme=1 and  (ubound(p.constructedshapes) > -1)  then       '(ubound(p.parents) =0) then 'or
		      'AddInit(p)
		      'else
		      AddInterm(p)
		      'end if
		      for i = 0 to ubound(p.parents)
		        IdentifyInit(p.parents(i))
		      next
		    end if
		  end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		drapcoul As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		mw As MacWindow
	#tag EndProperty

	#tag Property, Flags = &h0
		Mac As Macro
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="CurrentItemToSet"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="MultipleSelectOperation"
		#tag EndViewProperty
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
			Name="display"
			Group="Behavior"
			Type="string"
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
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapcoul"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
