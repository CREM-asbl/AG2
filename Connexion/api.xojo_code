#tag Module
Protected Module api
	#tag Method, Flags = &h0
		Sub init()
		  #if DebugBuild then
		    return
		  #endif

		  #if TargetLinux then
		    return
		  #endif

		  sendStat
		  dim update as CheckUpdate = new CheckUpdate
		  dim notification as Notification = new Notification

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SendBug()
		  dim request, directory as String
		  dim http as URLConnection
		  Var d As DateTime = DateTime.Now(New TimeZone("Europe/Brussels"))
		  var date as String

		  #if TargetLinux then
		    return
		  #EndIf

		  #if DebugBuild
		    NotesWindow.EF.Text = app.log
		    NotesWindow.Title = "Debug log " + App.errorType
		    NotesWindow.Show
		    return
		  #EndIf

		  date = d.ToString().ReplaceAll(":", ".")

		  directory="bugs/"+app.FullVersion+"/"+App.ErrorType+"/"+App.Sys+"/"+date+"/"

		  http = new URLConnection
		  request = "dir=" + directory + "&file=log.txt&txt=" + app.log
		  http.SetRequestContent(request, "application/x-www-form-urlencoded")
		  http.Send("POST",url+"/bug.php", timeout)

		  http = new URLConnection
		  request = "dir=" + directory + "&file=bug.hag&txt=" + CurrentContent.Oplist.ToString
		  http.SetRequestContent(request, "application/x-www-form-urlencoded")
		  http.Send("POST",url+"/bug.php")

		  http = new URLConnection
		  request = "dir=" + directory + "&file=bug.fag&txt=" + CurrentContent.MakeXML.ToString
		  http.SetRequestContent(request, "application/x-www-form-urlencoded")
		  http.Send("POST",url+"/bug.php")

		  Exception err
		  Catch

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub sendStat()
		  dim request As string
		  dim NWI as NetworkInterface

		  if System.Network.IsConnected = false then
		    return
		  end if

		  dim http as URLConnection = new URLConnection
		  NWI = System.GetNetworkInterface(0)

		  request = "version=" + app.FullVersion + "&os=" + app.sys +"&mac=" + NWI.MACAddress

		  http.SetRequestContent(request, "application/x-www-form-urlencoded")
		  http.Send("POST",url+"/log.php")
		End Sub
	#tag EndMethod


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
