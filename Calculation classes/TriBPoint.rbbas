#tag Class
Protected Class TriBPoint
Inherits nBpoint
	#tag Method, Flags = &h0
		Sub TriBPoint(p as BasicPoint, q as BasicPoint, r as BasicPoint)
		  Tab.append p
		  Tab.append q
		  Tab.append r
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Orientation() As integer
		  dim u,v as BasicPoint
		  
		  u = tab(1)-tab(0)
		  v = tab(2)-tab(1)
		  return sign(u.vect(v))
		End Function
	#tag EndMethod


	#tag ViewBehavior
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
	#tag EndViewBehavior
End Class
#tag EndClass
