#tag Class
Protected Class CircleSkull
Inherits NSkull
	#tag Method, Flags = &h0
		Sub CircleSkull(p as BasicPoint)
		  dim i as integer
		  ref = p
		  redim cs(2)
		  for i = 0 to 2
		    cs(i) = new CurveShape
		    cs(i).order = 2
		    append cs(i)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesize(k as double)
		  scale = k
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics)
		  
		  g.drawobject self, ref.x, ref.y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatectrl(i as integer, p as BasicPoint)
		  dim j as integer
		  
		  j = i\2
		  i = i mod 2
		  cs(j).controlx(i) = p.x
		  cs(j).controly(i) = p.y
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesommet(n as integer, p as BasicPoint)
		  if n = 1 then
		    cs(0).x = p.x
		    cs(0).y = p.y
		    cs(2).x2 = p.x
		    cs(2).y2 = p.y
		  end if
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
