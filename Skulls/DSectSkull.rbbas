#tag Class
Protected Class DSectSkull
Inherits NSkull
	#tag Method, Flags = &h0
		Sub DSectSkull(p as BasicPoint)
		  dim i as integer
		  redim cs(4)
		  ref = p
		  for i = 0 to 4
		    cs(i)=new curveshape
		    append cs(i)
		  next
		  for i = 1 to 3
		    cs(i).order = 2
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics)
		  dim i as integer
		  
		  'for i = 1 to 3
		  'if (cs(i).x = 0 and cs(i).y = 0) or (cs(i).x2=0 and cs(i).y2=0) then
		  'return
		  'end if
		  'next
		  'if cs(0).x2 = 0 and cs(0).y2 = 0 then
		  'return
		  'end if
		  g.drawobject self, ref.x, ref.y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesommet(i as integer, p as BasicPoint)
		  select case i
		  case 0
		    cs(0).x = p.x
		    cs(0).y = p.y
		    cs(4).x2 = p.x
		    cs(4).y2 = p.y
		  case 1
		    cs(0).x2=p.x
		    cs(0).y2=p.y
		    cs(1).x = p.x
		    cs(1).y=p.y
		  case 2
		    cs(3).x2 = p.x
		    cs(3).y2=p.y
		    cs(4).x = p.x
		    cs(4).y = p.y
		  end select
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update(p as BasicPoint)
		  ref = p
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatefillcolor(col as color, c as double)
		  fillcolor = col
		  fill = c
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesize(k as double)
		  scale = k
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateextre(n as integer, p as BasicPoint)
		  
		  cs(n+1).x2 = p.x
		  cs(n+1).y2 = p.y
		  cs(n+2).x = p.x
		  cs(n+2).y = p.y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatectrl(i as integer, p as BasicPoint)
		  dim j as integer
		  
		  j = i\2
		  i = i mod 2
		  cs(j+1).controlx(i) = p.x
		  cs(j+1).controly(i) = p.y
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateborderwidth(d as double)
		  borderwidth = d
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatebordercolor(col as color, c as double)
		  bordercolor = col
		  border = c
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paintside(g as graphics, n as integer)
		  if n< 2 then
		    cs(0).bordercolor = bordercolor
		    cs(0).borderwidth = borderwidth
		    cs(0).border = border
		    g.drawobject cs(0), ref.x, ref.y
		  end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		cs(4) As Curveshape
	#tag EndProperty

	#tag Property, Flags = &h0
		ref As BasicPoint
	#tag EndProperty


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
			InheritedFrom="Group2D"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
