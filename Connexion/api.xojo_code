#tag Module
Protected Module api
	#tag Method, Flags = &h0
		Sub AfficherInfo(EL as XmlNode)
		  dim info as String
		  dim validite, version as String
		  
		  if EL.FirstChild <> nil then
		    info = EL.FirstChild.FirstChild.Value
		    validite  = EL.Child(1).FirstChild.value
		    version =app.LongVersion
		    if version < validite and info<>Config.LastInfo  then
		      msgBox EL.LastChild.FirstChild.Value
		      Config.LastInfo = info
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Connect()
		  if http = Nil then
		    return
		  end if
		  
		  dim EL as XmlNode
		  dim doc as XmlDocument
		  dim update As string
		  
		  response = http.Post(url+"?method=connect&version="+app.LongVersion+"&os="+app.sys+"&stageCode="+str(app.StageCode),timeout)
		  'MsgBox response
		  try
		    doc = new XmlDocument(DefineEncoding(response,Encodings.UTF8))
		    EL = doc.FirstChild
		    AfficherInfo(EL.FirstChild)
		    if EL.LastChild.FirstChild <> nil then
		      update = EL.LastChild.FirstChild.value
		    end if
		    if update <> "" then
		      dim GuW As GetUpdateW
		      GuW = new GetUpdateW(update)
		      GuW.ShowModal
		    end if
		  catch err as XmlException
		  end try
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub init()
		  if System.Network.IsConnected or TargetLinux then
		    http = New HTTPSocket
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateDone()
		  if http = Nil then
		    return
		  end if
		  
		  response = http.Post(url+"?method=updateDone&os="+app.sys,timeout)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		http As HTTPSocket
	#tag EndProperty

	#tag Property, Flags = &h0
		response As string
	#tag EndProperty


	#tag Constant, Name = timeout, Type = Double, Dynamic = False, Default = \"10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = url, Type = String, Dynamic = False, Default = \"http://api.crem.be/AG.php", Scope = Public
	#tag EndConstant


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
			Name="response"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
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
End Module
#tag EndModule
