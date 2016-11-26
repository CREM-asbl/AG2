#tag Class
Protected Class IntersecList
Inherits Liste
	#tag Method, Flags = &h0
		Function Find(s as shape) As intersec()
		  dim inter(-1) as intersec
		  dim i as integer
		  dim int as intersec
		  
		  for i = 0 to count-1
		    int = intersec(item(i))
		    if int.sh1 = s or int.sh2 = s then
		      inter.append item(i)
		    end if
		  next
		  return inter
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Find(s1 as shape, s2 as shape) As Intersec
		  dim i as integer
		  dim int as intersec
		  
		  
		  for i = 0 to count-1
		    int= intersec(item(i))
		    if (int.sh1 = s1 and int.sh2 = s2) or (int.sh1=s2 and int.sh2 = s1) then
		      return intersec(item(i))
		    end if
		  next
		  
		  return nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function item(n as integer) As Intersec
		  return Intersec(Element(n))
		End Function
	#tag EndMethod


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
