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
		Sub checkUpdate()
		  dim log,info,update As string
		  Dim form As Dictionary
		  dim NWI as NetworkInterface
		  
		  init
		  
		  if http = Nil then
		    return
		  end if
		  
		  NWI = System.GetNetworkInterface(0)
		  
		  form = New Dictionary
		  form.Value("version") = app.FullVersion
		  form.Value("os") = app.sys
		  form.Value("mac") = NWI.MACAddress
		  
		  http.SetFormData(form)
		  log = http.Post(url+"/log.php",timeout)
		  
		  
		  AfficherInfo
		  
		  
		  update = http.Get(url+"version.xml", timeout)
		  if update > app.LongVersion  or (app.StageCode <> 3 and update = app.LongVersion) then
		    GetUpdateW.ShowModal
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub init()
		  #if DebugBuild then
		    return
		  #endif
		  
		  if System.Network.IsConnected then
		    http = New HTTPSocket
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SendBug()
		  dim request, directory, file,date as String
		  Dim form As Dictionary
		  
		  if http = Nil then
		    return
		  end if
		  
		  date = app.bugtime.LongDate+" "+str(app.bugtime.Hour)+"h"+str(app.bugtime.Minute)
		  directory="bugs/"+app.FullVersion+"/"+App.ErrorType+"/"+App.Sys+"/"+date+"/"
		  
		  form = New Dictionary
		  form.Value("dir") = directory
		  form.Value("file") = "log.txt"
		  form.Value("txt") = app.log
		  
		  http.SetFormData(form)
		  request = http.post(url+"/bug.php",timeout)
		  
		  
		  form.Value("file") = "bug.hag"
		  form.Value("txt") = currentContent.Oplist.toString
		  
		  http.SetFormData(form)
		  request = http.post(url+"/bug.php",timeout)
		  
		  form.Value("file") = "bug.fag"
		  form.Value("txt") = currentContent.MakeXML.toString
		  
		  http.SetFormData(form)
		  request = http.post(url+"/bug.php",timeout)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		http As HTTPSocket
	#tag EndProperty


	#tag Constant, Name = timeout, Type = Double, Dynamic = False, Default = \"10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = url, Type = String, Dynamic = False, Default = \"https://api.crem.be/AG/", Scope = Public
	#tag EndConstant


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
End Module
#tag EndModule
