#tag Module
Protected Module api
	#tag Method, Flags = &h0
		Sub AfficherInfo()
		  dim doc as XmlDocument
		  dim El as XmlNode
		  dim info, data, validite, version as String
		  
		  if http = Nil then
		    return
		  end if
		  
		  data = http.Get(url+"info.xml",timeout)
		  
		  try
		    doc = new XmlDocument(DefineEncoding(data,Encodings.UTF8))
		    El = doc.FirstChild
		    info = El.FirstChild.FirstChild.Value
		    validite =  El.Child(1).FirstChild.Value
		    version = app.LongVersion
		    if version < validite and info<>Config.LastInfo  then
		      MsgBox  El.LastChild.FirstChild.Value
		      Config.LastInfo = info
		    end if
		  catch err as XmlException
		  end try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Connect()
		  if http = Nil then
		    return
		  end if
		  
		  dim log,info,update As string
		  
		  log = http.Post(url+"/log.php?version="+app.LongVersion+"&os="+app.sys+"&stageCode="+str(app.StageCode),timeout)
		  
		  AfficherInfo
		  
		  update = http.Get(url+"version.xml",timeout)
		  if update <> app.LongVersion  then
		    dim GuW As GetUpdateW
		    GuW = new GetUpdateW(update)
		    GuW.ShowModal
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


	#tag Property, Flags = &h0
		http As HTTPSocket
	#tag EndProperty

	#tag Property, Flags = &h0
		response As string
	#tag EndProperty


	#tag Constant, Name = timeout, Type = Double, Dynamic = False, Default = \"10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = url, Type = String, Dynamic = False, Default = \"http://api.crem.be/AG/", Scope = Public
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
