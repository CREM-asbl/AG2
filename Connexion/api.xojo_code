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
		  
		  data = http.SendSync("GET",url+"info.xml", timeout)
		  
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
		  dim log,info,update,request As string
		  dim NWI as NetworkInterface
		  
		  init
		  
		  if http = Nil then
		    return
		  end if
		  
		  NWI = System.GetNetworkInterface(0)
		  
		  request = "version=" + app.FullVersion + "&os=" + app.sys +"&mac=" + NWI.MACAddress
		  
		  http.SetRequestContent(request, "application/x-www-form-urlencoded")
		  log = http.SendSync("POST",url+"/log.php", timeout)
		  
		  AfficherInfo
		  
		  update = http.SendSync("GET",url+"version.xml", timeout)
		  if update > app.LongVersion  or (app.StageCode <> 3 and update = app.LongVersion) then
		    GetUpdateW.ShowModal
		  end if
		  
		  
		  'si la connexion ne s'établit pas le programme n'est plus bloqué
		  Exception err
		  Catch
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub init()
		  #if DebugBuild then
		    return
		  #endif
		  
		  if System.Network.IsConnected then
		    http = New URLConnection
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SendBug()
		  dim request, directory, response as String
		  
		  
		  if http = Nil then
		    return
		  end if
		  
		  directory="bugs/"+app.FullVersion+"/"+App.ErrorType+"/"+App.Sys+"/"
		  
		  request = "dir=" + directory + "&file=log.txt&txt=" + app.log
		  http.SetRequestContent(request, "application/x-www-form-urlencoded")
		  response = http.SendSync("POST",url+"/bug.php")
		  
		  request = "dir=" + directory + "&file=bug.hag&txt=" + CurrentContent.Oplist.ToString
		  http.SetRequestContent(request, "application/x-www-form-urlencoded")
		  response = http.SendSync("POST",url+"/bug.php")
		  
		  request = "dir=" + directory + "&file=bug.fag&txt=" + CurrentContent.MakeXML.ToString
		  http.SetRequestContent(request, "application/x-www-form-urlencoded")
		  response = http.SendSync("POST",url+"/bug.php")
		  
		  'si la connexion ne s'établit pas le programme n'est plus bloqué
		  Exception err
		  Catch
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		http As URLConnection
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
