#tag Class
Protected Class ChooseFinal
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub ChooseFinal()
		  SelectOperation
		  OpId = 42
		  drapcoul = false
		  finished = false
		  NumberOfItemsToSelect = 1
		  CurrentItemToSet = 1
		  
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
		  AddFinal(currentshape)
		  IdentifyInit(currentshape)
		  for i = 1 to currentcontent.TheObjects.count -1
		    s =  currentcontent.TheObjects.element(i)
		    if s.init or s.Interm or s.final then
		      fixecouleurs(s)
		    end if
		  next
		  wnd.mycanvas1.refreshbackground
		  showattraction
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IdentifyInit(s as shape)
		  dim  i as integer  //lors du premier passage, s est un objet sélectionné comme final
		  dim t as boolean
		  dim sh as shape
		  dim op as integer
		  dim tsf as Transformation
		  
		  if  s.interm or s.init then
		    return
		  end if
		  if s isa point then
		    IdentifyInit(point(s))
		    return
		  end if
		  
		  if s.constructedby = nil then
		    t = true
		    for i =0 to s.ncpts-1
		      t = t and s.id < s.points(i).id
		    next
		    if t then  'and (s isa droite or s isa polyqcq or ( (s.fam = 2 or s.fam = 3) and (s.forme = 0) ) ) then  's a été créé avant ses sommets et est un polyqcq ou une droite (segment)
		      AddInit(s)
		    else
		      AddInterm(s)
		      for i = 0 to s.ncpts-1
		        if s.id > s.points(i).id then
		          identifyinit(s.points(i))
		        end if
		      next
		    end if
		    return
		  end if
		  
		  select case s.constructedby.oper
		  case 1,2
		    identifyinit(s.constructedby.shape)
		    identifyinit(s.points(0))
		    if droite(s).nextre=2 then
		      identifyinit(s.points(1))
		    end if
		  case 3, 5, 9
		  case  6 ' Transfos
		    tsf = transformation(s.constructedby.Data(0))
		    IdentifyInit(s.constructedby.shape)
		    AddTsfInterm(tsf)
		    IdentifyInit(tsf.supp)
		  case 8  'Prolongements
		  end select
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g As Graphics)
		  dim i, j as integer
		  dim s as shape
		  
		  for i = 0 to currentcontent.theobjects.count-1
		    s= currentcontent.TheObjects.element(i)
		    if not s isa point then
		      for j = 0 to s.npts-1
		        fixecouleurs(s.points(j))
		      next
		    end if
		  next
		  Super.Paint(g)
		  
		  
		  if CurrentHighLightedShape <> nil then
		    display = click+pour+selectionner
		  else
		    display =  choose + aform + ou + save + themacro
		  end if
		  
		  Help g, display
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecouleurs(s as shape)
		  
		  if s.final then
		    s.fixecouleurtrait(blue,100)
		    s.borderwidth = 2
		  elseif s.init then
		    s.fixecouleurtrait(red, 100)
		  elseif s.interm then
		    s.fixecouleurtrait(black,100)
		  else
		    s.fixecouleurtrait(grey,100)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddFinal(s as shape)
		  if not s.Final and not s.Init and not s.Interm then
		    wnd.mac.ObFinal.append s.id
		    wnd.mac.FaFinal.append s.fam
		    wnd.mac.FoFinal.append s.forme
		    s.Final = true
		  end if
		  
		  // Les id ci-dessus sont relatifs à la macro
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddInit(s as shape)
		  if not s.Final and not s.Init and not s.Interm then
		    wnd.mac.ObInit.append s.id
		    wnd.mac.FaInit.append s.fam
		    wnd.mac.FoInit.append s.forme
		    s.Init = true
		  end if
		  
		  // Les id ci-dessus sont relatifs à la macro
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddInterm(s as shape)
		  if not s.Final and not s.Init and not s.Interm then
		    wnd.mac.ObInterm.append  s.id
		    wnd.mac.FaInterm.append s.fam
		    wnd.mac.FoInterm.append s.forme
		    s.Interm = true
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
		      if s.final then
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
		  dim i as integer
		  dim s as shape
		  
		  CurrentItemtoSet = NumberOfItemsToSelect +1
		  
		  for i = 1 to currentcontent.TheObjects.count -1
		    s =  currentcontent.TheObjects.element(i)
		    if s.init or s.Interm or s.final then
		      fixecouleurs(s)
		    else
		      s.delete
		    end if
		  next
		  wnd.mac.Histo = currentcontent.Histo
		  wnd.mac.Elaguer
		  wnd.mac.ObInit.sort
		  wnd.mac.ObInterm.sort
		  wnd.mac.ObFinal.sort
		  
		  
		  
		  super.endoperation
		  
		  mw = new  MacWindow
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
		Sub AddTsfFinal(tsf As Transformation)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddTsfInterm(tsf As Transformation)
		  if not tsf.Final  then
		    wnd.mac.TsfInterm.append  Tsf.supp.id
		    wnd.mac.TsfTyInterm.append tsf.type
		    wnd.mac.TsfSidInterm.append tsf.index
		    tsf.Interm = true
		  end if
		  
		  // Les id ci-dessus sont relatifs à la macro
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PointIdentifyInit(p as point)
		  dim op as integer
		  dim t as boolean
		  dim i as integer
		  
		  if p.constructedby <> nil then
		    AddInterm(p)
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
		    case 9
		    case 10
		      IdentifyInit(p.pointsur.element(0))
		      identifyinit(p.constructedby.shape)
		    end select
		  else
		    select case p.pointsur.count
		    case 0
		      t = true
		      for i = 0 to ubound(p.parents)
		        t = t and  (p.id < p.parents(i).id)
		      next
		      if t then
		        Addinit(p)
		      else
		        for i = 0 to ubound(p.parents)
		          if p.id > p.parents(i).id  then
		            IdentifyInit(p.parents(i))
		          end if
		        next
		      end if
		    case 1
		      IdentifyInit(p.pointsur.element(0))
		      AddInit(p)
		    case 2
		      AddInterm(p)
		      IdentifyInit(p.pointsur.element(0))
		      IdentifyInit(p.pointsur.element(1))
		    end select
		  end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		drapcoul As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		mw As MacWindow
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
