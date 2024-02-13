#tag Class
Protected Class Liste
	#tag Method, Flags = &h0
		Sub AddObject(Obj as Variant)
		  if Obj <> nil and GetPosition(Obj)  = -1 then
		    Objects.append Obj
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Concat(ol as liste)
		  dim i as integer
		  
		  for i = 0 to ol.count-1
		    concat ol.element(i)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub concat(s As Variant)
		  if GetPosition(s)  = -1  then
		    objects.append s
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function count() As integer
		  return objects.count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function element(n as integer) As Variant
		  if n >= 0 and n <= Ubound(Objects) then
		    return Objects(n)
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPosition(Obj as Variant) As Integer
		  
		  return Objects.indexof(obj)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAll()
		  redim objects(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveObject(obj as variant)
		  dim pos as integer
		  
		  pos = GetPosition(obj)
		  
		  if pos <> -1 then
		    objects.remove Pos
		  end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Objects(-1) As Variant
	#tag EndProperty


	#tag ViewBehavior
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
