#tag Class
Protected Class DSkull
Inherits LSkull
	#tag Method, Flags = &h0
		Sub Constructor(p as BasicPoint)
		  super.constructor(p)
		  '//On utilise les mêmes routines de dessin que pour un secteur de disque (DSect) sauf pour la routine
		  '// CreateExtreAndCtrlPoints qui est dès lors placée dans la classe "Secteur".
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics)
		  dim i as integer
		  if not (currentcontent.currentoperation isa retourner and dret <>nil) then
		    'si dret <> nil et currentop est une des opérations mentionnées, le calcul des extre et ctrl est fait par le timer
		    update(skullof)
		  end if
		  g.drawobject self, x, y
		  for i = 0 to count-1
		    g.drawobject item(i), x, y
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paintside(g as graphics, n as integer, ep as double, col as couleur)
		  dim i as integer
		  
		  for i = 0 to 4
		    item(i).bordercolor = col.col
		    item(i).borderwidth = ep
		    item(i).border =100
		  next
		  
		  select case n
		  case 0
		    g.drawobject item(0), ref.x, ref.y
		  case 1
		    for i = 1 to 3
		      g.drawobject item(i), ref.x, ref.y
		    next
		  case 2
		    g.drawobject item(4), ref.x, ref.y
		  end select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update(p as BasicPoint)
		  ref = p
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatectrl(i as integer, p as BasicPoint)
		  dim j as integer
		  
		  j = i\2
		  i = i mod 2
		  item(j+1).controlx(i) = p.x
		  item(j+1).controly(i) = p.y
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesommet(i as integer, p as BasicPoint)
		  select case i
		  case 0
		    item(0).x = p.x
		    item(0).y = p.y
		    item(4).x2 = p.x
		    item(4).y2 = p.y
		  case 1
		    item(0).x2=p.x
		    item(0).y2=p.y
		    item(1).x = p.x
		    item(1).y=p.y
		  case 2
		    item(3).x2 = p.x
		    item(3).y2=p.y
		    item(4).x = p.x
		    item(4).y = p.y
		  end select
		  
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="angle"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderColor"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderWidth"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="currentcurve"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FillColor"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Rotation"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Scale"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="X"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Y"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
