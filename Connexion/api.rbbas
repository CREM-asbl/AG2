#tag Module
Protected Module api
	#tag Method, Flags = &h0
		Sub AfficherInfo(EL as XmlNode)
		  dim info as String
		  dim validite, version as String
		  
		  info = EL.FirstChild.FirstChild.Value
		  validite  = EL.Child(1).FirstChild.value
		  version = str(App.MajorVersion)+str(App.MinorVersion)+str(App.BugVersion)
		  if version < validite and info<>Config.LastInfo  then
		    msgBox EL.LastChild.FirstChild.Value
		    Config.LastInfo = info
		  end if
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
		  
		  response = http.Post(url+"?action=updateDone&os="+app.sys,timeout)
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
		  
		  response = http.Post(url+"?action=connect&version="+app.LongVersion+"&os="+app.sys+"&stageCode="+str(app.StageCode),timeout)
		  
		  try
		    doc = new XmlDocument(DefineEncoding(response,Encodings.UTF8))
		    EL = doc.FirstChild
		    AfficherInfo(EL.FirstChild)
		    update = EL.LastChild.FirstChild.value
		    if update <> "" then
		      dim GuW As GetUpdateW
		      GuW = new GetUpdateW(update)
		      GuW.ShowModal
		    end if
		  catch err as XmlException
		  end try
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		response As string
	#tag EndProperty

	#tag Property, Flags = &h0
		http As HTTPSocket
	#tag EndProperty


	#tag Constant, Name = timeout, Type = Double, Dynamic = False, Default = \"10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = url, Type = String, Dynamic = False, Default = \"http://www.crem.be/api/AG.php", Scope = Public
	#tag EndConstant


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
		#tag ViewProperty
			Name="response"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
