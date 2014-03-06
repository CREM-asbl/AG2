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
		  dim  i, j as integer  //lors du premier passage, s est un objet sélectionné comme final
		  dim t as boolean
		  dim sh as shape
		  dim op as integer
		  dim tsf as Transformation
		  
		  if   s.interm or s.init then
		    return
		  end if
		  
		  if s isa point then
		    pointidentifyinit(point(s))
		    return
		  end if
		  
		  if s.constructedby = nil then
		    t = true
		    for i =0 to s.ncpts-1
		      t = t and (s.id < s.points(i).id and s.points(i).pointsur.count < 2)  // t = true si tous les sommets de s sont postérieurs à s --> s est initial
		    next
		    if t then  'and (s isa droite or s isa polyqcq or ( (s.fam = 2 or s.fam = 3) and (s.forme = 0) ) ) then  's a été créé avant ses sommets et est un polyqcq ou une droite (segment)
		      AddInit(s)
		    else
		      AddInterm(s)
		      for i = 0 to s.ncpts-1
		        if s.id > s.points(i).id  or ubound(s.points(i).parents) = 0 or s.points(i).pointsur.count > 0 then
		          PointIdentifyInit(s.points(i)) //on identifie l'origine des points de construction de s plus vieux que s
		        end if
		      next
		    end if
		    return
		  end if
		  
		  AddInterm(s)          // s est une forme construite
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
		    IdentifyInit(s.constructedby.shape)
		    AddTsfInterm(tsf)
		    IdentifyInit(tsf.supp)
		  case 8  'Prolongements (A faire)
		  end select
		  
		  
		  
		  
		  
		  
		  
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
		  
		  if s.final then
		    s.fixecouleurtrait(blue,100)
		    s.borderwidth = 2
		  elseif s.init then
		    s.fixecouleurtrait(red, 100)
		    s.borderwidth = 2
		  elseif s.interm then
		    s.fixecouleurtrait(black,100)
		  else
		    s.fixecouleurtrait(grey,100)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddFinal(s as shape)
		  if not s.Final  then 'and not s.init and not s.interm
		    currentcontent.mac.ObFinal.append s.id
		    currentcontent.mac.FaFinal.append s.fam
		    currentcontent.mac.FoFinal.append s.forme
		    s.Final = true
		  end if
		  
		  // Les id ci-dessus sont relatifs à la macro
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddInit(s as shape)
		  dim i as integer
		  
		  if s isa point and not s.isptsur then
		    for i = 0 to ubound(point(s).parents)
		      if point(s).parents(i).init then
		        return
		      end if
		    next
		  end if
		  
		  if not s.Init and not s.Interm and not s.final then
		    currentcontent.mac.ObInit.append s.id
		    currentcontent.mac.FaInit.append s.fam
		    currentcontent.mac.FoInit.append s.forme
		    s.Init = true
		  end if
		  
		  // Les id ci-dessus sont relatifs à la macro
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddInterm(s as shape)
		  if not s.Final and not s.Init and not s.Interm then
		    currentcontent.mac.ObInterm.append  s.id
		    currentcontent.mac.FaInterm.append s.fam
		    currentcontent.mac.FoInterm.append s.forme
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
		  dim i, j as integer
		  dim s as shape
		  
		  CurrentItemtoSet = NumberOfItemsToSelect +1
		  currentcontent.mac.Histo = currentcontent.Histo
		  currentcontent.mac.Elaguer
		  currentcontent.mac.ObInit.sort
		  currentcontent.mac.ObInterm.sort
		  currentcontent.mac.ObFinal.sort
		  
		  for i =  currentcontent.TheObjects.count -1 downto 1
		    s =  currentcontent.TheObjects.element(i)
		    if s.init or s.Interm or s.final then
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
		    case 7
		      IdentifyInit(p.constructedby.shape)
		    case 9
		      //A compléter
		    case 10
		      IdentifyInit(p.pointsur.element(0))
		      identifyinit(p.constructedby.shape)
		    end select
		  elseif NbreParentsNonFinal(p) <= 0 then
		    AddInit(p)
		  else
		    if p.pointsur.count = 1 and  p.constructedby = nil then
		      AddInit(p)
		      IdentifyInit(p.pointsur.element(0))
		    elseif p.pointsur.count = 2 then
		      AddInterm(p)
		      IdentifyInit(p.pointsur.element(0))
		      IdentifyInit(p.pointsur.element(1))
		    else
		      t = true
		      for i = 0 to ubound(p.parents)
		        t = t and  (p.id < p.parents(i).id)   'p est-il plus vieux que tous ses parents?
		      next
		      if t then                                                 'oui
		        Addinit(p)
		      else                                                         'non certains de ses parents sont plus vieux que p
		        for i = 0 to ubound(p.parents)
		          if p.id > p.parents(i).id and not p.parents(i).final  then
		            AddInterm(p)     'si p.parents(i) est plus vieux que p sans être un objet final
		            IdentifyInit(p.parents(i))                                                       'on identifie les initiaux avant parents(i)
		          else
		            AddInit(p)                                                                                'p devient un objet initial sinon il y a risque de boucle
		          end if
		        next
		      end if
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbreParentsNonFinal(p as point) As integer
		  dim i, n as integer
		  for i = 0 to ubound(p.parents)
		    if not p.parents(i).final then
		      n = n+1
		    end if
		  next
		  
		  return n
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
