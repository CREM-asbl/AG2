#tag Class
Protected Class PointsList
Inherits Liste
	#tag Method, Flags = &h0
		Sub Concat(ol as pointslist)
		  dim i as integer
		  
		  for i = 0 to ol.count-1
		    concat ol.element(i)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function item(n As Integer) As Point
		  return Point(element(n))
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Points(-1) As Point
	#tag EndProperty


	#tag ViewBehavior
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
	#tag EndViewBehavior
End Class
#tag EndClass
