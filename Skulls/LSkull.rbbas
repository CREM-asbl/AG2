#tag Class
Protected Class LSkull
Inherits NSkull
	#tag Method, Flags = &h0
		Sub LSkull(p as BasicPoint)
		  ref = p
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub addcurve(n as integer)
		  dim cv as curveshape
		  dim m as integer
		  dim i as integer
		  
		  select case n
		  case 0
		    cv = new curveshape
		    cv.Order = 0
		    cs.append cv
		    append cv
		  case 1
		    for i = 0 to 2
		      cv = new curveshape
		      cv.Order = 2
		      cs.append cv
		      append cv
		    next
		  case 2
		    cv = new curveshape
		    cv.Order = 2
		    cs.append cv
		    append cv
		  end select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update(p as BasicPoint)
		  ref = p
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateextre(n as integer, p as BasicPoint)
		  
		  cs(n).x2 = p.x
		  cs(n).y2 = p.y
		  cs(n+1).x = p.x
		  cs(n+1).y = p.y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatectrl(n as integer, j as integer, p as BasicPoint)
		  
		  cs(n).controlx(j) = p.x
		  cs(n).controly(j) = p.y
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesommet(k as integer, p as BasicPoint)
		  
		  cs(k).x = p.x
		  cs(k).y = p.y
		  if k =0 then
		    cs(ubound(cs)).x2 = p.x
		    cs(ubound(cs)).y2 = p.y
		  else
		    cs(k-1).x2 = p.x
		    cs(k-1).y2 =p.y
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paintside(g as graphics, i as integer, ep as double, coul as couleur)
		  dim j as integer
		  
		  cs(i).bordercolor = coul.col
		  cs(i).borderwidth = ep*borderwidth
		  g.drawobject(cs(i), ref.x, ref.y)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics)
		  dim i as integer
		  
		  g.drawobject self,ref.x, ref.y
		  
		  for i = 0 to count-1
		    g.drawobject item(i), ref.x, ref.y
		  next
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="currentcurve"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="NSkull"
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
			Name="X"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			InheritedFrom="Object2D"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Y"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			InheritedFrom="Object2D"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Rotation"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			InheritedFrom="Object2D"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Scale"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			InheritedFrom="Object2D"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			InheritedFrom="Object2D"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FillColor"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
			InheritedFrom="Object2D"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			InheritedFrom="Object2D"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderColor"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
			InheritedFrom="Object2D"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderWidth"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			InheritedFrom="Object2D"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="FigureShape"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
