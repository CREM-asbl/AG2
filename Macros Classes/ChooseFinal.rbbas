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
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IdentifyInit(s as shape)
		  dim  i as integer  //lors du premier passage, s est un objet sélectionné comme final
		  dim t as boolean
		  dim sh as shape
		  
		  if  s.interm or s.init then
		    return
		  end if
		  
		  if s.constructedby <> nil then
		    Addinterm(s)
		    identifyinit(s.constructedby.shape)
		    if s.isaparaperp then
		      identifyinit(s.points(0))
		      if droite(s).nextre=2 then
		        identifyinit(s.points(1))
		      end if
		    end if
		  elseif s isa point then
		    select case point(s).pointsur.count
		    case 0
		      t = true
		      for i = 0 to ubound(point(s).parents)
		        t = t and  (s.id < point(s).parents(i).id)
		      next
		      if t then
		        Addinit(s)
		      else
		        for i = 0 to ubound(point(s).parents)
		          if s.id > point(s).parents(i).id  then
		            IdentifyInit(point(s).parents(i))
		          end if
		        next
		      end if
		    case 1
		      AddInterm(s)
		      IdentifyInit(point(s).pointsur.element(0))
		    case 2
		      AddInterm(s)
		      IdentifyInit(point(s).pointsur.element(0))
		      IdentifyInit(point(s).pointsur.element(1))
		    end select
		  else
		    t = true
		    for i =0 to s.ncpts-1
		      t = t and s.id < s.points(i).id
		    next
		    if t then
		      AddInit(s)
		    else
		      AddInterm(s)
		      for i = 0 to s.ncpts-1
		        if s.id > s.points(i).id then
		          identifyinit(s.points(i))
		        end if
		      next
		    end if
		  end if
		  
		  
		  
		  
		  
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
		    display =  choose + aform
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
		  Dim d as New MessageDialog
		  Dim b as MessageDialogButton
		  
		  if s = nil then
		    return false
		  end if
		  
		  drapcoul = true
		  objects.unselectall
		  
		  currentshape = CurrentHighlightedshape
		  CurrentHighlightedShape = nil
		  AddFinal(currentshape)
		  IdentifyInit(currentshape)
		  Fixecouleurs(currentshape)
		  currentshape.unhighlight
		  wnd.mycanvas1.refreshbackground
		  
		  d.icon=MessageDialog.GraphicCaution   //display warning icon
		  d.ActionButton.Caption= Dico.VALUE("Oui")
		  d.CancelButton.Caption = Dico.Value("Non")
		  d.cancelbutton.visible = true
		  d.Message= Dico.value("ChoiceFinished")
		  b=d.ShowModal     //display the dialog
		  
		  if not (b =  d.ActionButton)  then
		    NumberOfItemsToSelect = NumberofItemsToSelect+1
		    showattraction
		  End if
		  
		  return true
		  
		  
		End Function
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
