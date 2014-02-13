#tag Class
Protected Class MacrosList
	#tag Method, Flags = &h0
		Function element(idx As Integer) As Macro
		  if idx>=0 and idx<=Ubound(macs) then
		    return macs(idx)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function count() As integer
		  return Ubound(macs)+1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddMac(m as macro)
		  dim i as integer
		  
		  for i = 0 to ubound(macs)
		    if m.caption = macs(i).caption then
		      return
		    end if
		  next
		  macs.append m
		  m.creermenuitem
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveMac(m as macro)
		  if macs.indexof(m) <> -1 then
		    macs.remove macs.indexof(m)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPosition(m as macro) As integer
		  return macs.indexof(m)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub macroslist()
		  redim macs(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLLoadMacros(EL as XMLElement)
		  dim List as XmlNodeList
		  dim macr, temp as XMLElement
		  dim doc as XMLDocument
		  dim mac as macro
		  dim i as integer
		  
		  List = EL.XQL(Dico.Value("Macros"))
		  if  list.Length > 0 then
		    macr = XMLElement(List.Item(0))
		    for i = 0 to macr.childcount-1
		      temp = XMLElement(macr.child(i))
		      doc = new XMLDocument(temp.ToString)
		      mac = new macro(doc)
		      addmac(mac)
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMacro(str as string) As Macro
		  dim i as integer
		  
		  for i = 0 to ubound(macs)
		    if macs(i).Caption = str then
		      return macs(i)
		    end if
		  next
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		macs(-1) As Macro
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
