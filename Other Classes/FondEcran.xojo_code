#tag Class
Protected Class FondEcran
	#tag Method, Flags = &h0
		Function GetAlign() As string
		  return self.Align
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return self.Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setImage(image As Picture)
		  self.image = image
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setName(Name as string)
		  self.Name = Name
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		align As String
	#tag EndProperty

	#tag Property, Flags = &h0
		image As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As string
	#tag EndProperty

	#tag Property, Flags = &h0
		stretched As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="align"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="image"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="stretched"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
