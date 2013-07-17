#tag Module
Protected Module api
	#tag Method, Flags = &h0
		Sub AfficherReponse()
		  dim date as Date
		  dim info as String
		  dim EL as XmlNode
		  dim doc as XmlDocument
		  dim validite, version as String
		  
		  try
		    doc = new XmlDocument(DefineEncoding(response,Encodings.UTF8))
		    EL = doc.FirstChild
		    info = EL.FirstChild.FirstChild.Value
		    validite  = EL.Child(1).FirstChild.value
		    version = str(App.MajorVersion)+str(App.MinorVersion)+str(App.BugVersion)
		    if version < validite and info<>Config.LastInfo  then
		      msgBox EL.LastChild.FirstChild.Value
		      Config.LastInfo = info
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
		Sub checkInfo()
		  if http = Nil then
		    return
		  end if
		  
		  response = http.Post("www.crem.be/api/data/info.xml",timeout)
		  
		  if response <>"" then
		    AfficherReponse
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub checkUpdate()
		  if http = Nil then
		    return
		  end if
		  
		  response = http.Post(url+"?version="+app.LongVersion+"&os="+app.sys+"&stageCode="+str(app.StageCode),timeout)
		  
		  if response<> "" then
		    dim GuW As GetUpdateW
		    GuW = new GetUpdateW(response)
		    GuW.ShowModal
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub getUpdate()
		  if http = Nil then
		    return
		  end if
		  
		  response = http.Post(url+"?action=update&os="+app.sys,timeout)
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
