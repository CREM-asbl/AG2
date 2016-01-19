#tag Class
Protected Class IntersecList
	#tag Method, Flags = &h0
		Sub AddIntersec(Inter as Intersec)
		  if Inter <> nil and GetPosition(inter)  = -1 then
		    Intersecs.append inter
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function count() As integer
		  return ubound(intersecs)+1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function element(n as integer) As Intersec
		  if n >= 0 and n <= Ubound(Intersecs) then
		    return Intersecs(n)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Find(s as shape) As intersec()
		  dim inter(-1) as intersec
		  dim i as integer
		  
		  for i = 0 to count-1
		    if element(i).sh1 = s or element(i).sh2 = s then
		      inter.append element(i)
		    end if
		  next
		  return inter
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Find(s1 as shape, s2 as shape) As Intersec
		  dim i as integer
		  
		  for i = 0 to count-1
		    if (element(i).sh1 = s1 and element(i).sh2 = s2) or (element(i).sh1=s2 and element(i).sh2 = s1) then
		      return element(i)
		    end if
		  next
		  
		  return nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPosition(Inter as Intersec) As Integer
		  
		  dim i as Integer
		  
		  
		  for i=0 to UBound(Intersecs)
		    
		    if Intersecs(i) = Inter then
		      return i
		    end if
		    
		  next
		  
		  return -1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveIntersec(Inter as Intersec)
		  dim pos as integer
		  
		  pos = GetPosition(Inter)
		  
		  if pos <> -1 then
		    Intersecs.remove Pos
		  end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Intersecs(-1) As Intersec
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
