#tag Class
Protected Class MacConstructionInfo
	#tag Method, Flags = &h0
		Sub MacConstructionInfo(m as Macro)
		  Mac = m
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetInfoMac(n as integer) As InfoMac
		  dim i as integer
		  
		  for i = 0 to ubound (IfMacs)
		    if IfMacs(i).MacId = n then
		      return IfMacs(i)
		    end if
		  next
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetInfoTsf(n as integer) As infomac
		  dim i as integer
		  
		  for i = 0 to ubound (IfMacs)
		    if IfMacs(i).TsfId = n then
		      return IfMacs(i)
		    end if
		  next
		  return nil
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Mac As Macro
	#tag EndProperty

	#tag Property, Flags = &h0
		IfMacs() As InfoMac
	#tag EndProperty

	#tag Property, Flags = &h0
		RealInit() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RealFinal() As Integer
	#tag EndProperty


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
