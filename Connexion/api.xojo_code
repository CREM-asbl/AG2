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

		  if Config <> Nil then
		    if Config.UUID = "" then
		      Config.UUID = GenerateInstallationUUID()
		      Config.InstallationUUID = Config.UUID
		      Config.Save
		    end if
		    InstallationUUID = Config.UUID
		  else
		    InstallationUUID = GenerateInstallationUUID()
		  end if

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
		  dim uuid, osVersion, arch, locale as String

		  if System.Network.IsConnected = false then
		    return
		  end if

		  dim http as URLConnection = new URLConnection
		  NWI = System.GetNetworkInterface(0)

		  uuid = GetInstallationUUID()
		  osVersion = GetOSVersion()
		  arch = GetArch()
		  locale = GetLocale()

		  request = "version=" + app.FullVersion + "&os=" + app.sys +"&mac=" + NWI.MACAddress

		  if uuid <> "" then
		    request = request + "&uuid=" + uuid
		  end if
		  if osVersion <> "" then
		    request = request + "&os_version=" + osVersion
		  end if
		  if arch <> "" then
		    request = request + "&arch=" + arch
		  end if
		  if locale <> "" then
		    request = request + "&locale=" + locale
		  end if

		  http.SetRequestContent(request, "application/x-www-form-urlencoded")
		  http.Send("POST",url+"/log.php")
		End Sub
	#tag EndMethod


	#tag Method, Flags = &h0
		Function GenerateInstallationUUID() As String
		  dim r as Random
		  dim hex as String
		  dim i as Integer
		  dim uuid as String

		  r = new Random
		  hex = "0123456789abcdef"
		  for i = 0 to 31
		    uuid = uuid + hex.Mid(r.InRange(0, 15) + 1, 1)
		  next

		  uuid = uuid.Left(8) + "-" + uuid.Mid(9, 4) + "-" + "4" + uuid.Mid(14, 3) + "-" + "8" + uuid.Mid(18, 3) + "-" + uuid.Mid(21, 12)
		  return uuid
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetInstallationUUID() As String
		  if Config <> Nil then
		    if Config.UUID = "" then
		      Config.UUID = GenerateInstallationUUID()
		      Config.InstallationUUID = Config.UUID
		      Config.Save
		    end if
		    return Config.UUID
		  end if
		  return InstallationUUID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetOSVersion() As String
		  dim result as String
		  try
		    result = app.Version
		  catch err as RuntimeException
		    result = ""
		  end try
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetArch() As String
		  dim result as String
		  #if Target64Bit then
		    result = "x64"
		  #elseif Target32Bit then
		    result = "x86"
		  #endif
		  #if TargetARM then
		    result = result + " (ARM)"
		  #endif
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLocale() As String
		  dim result as String
		  try
		    result = Locale.Current.Identifier
		  catch err as RuntimeException
		    result = ""
		  end try
		  return result
		End Function
	#tag EndMethod

	#tag Property, Flags = &h0
		InstallationUUID As String
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
