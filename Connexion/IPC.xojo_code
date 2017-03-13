#tag Class
Protected Class IPC
Inherits IPCSocket
	#tag Event
		Sub DataAvailable()
		  dim f as FolderItem
		  dim data as string
		  
		  data = me.ReadAll
		  data = DefineEncoding(data,Encodings.UTF8)
		  
		  WorkWindow.Restore
		  
		  if data <> "focus" then
		    f =  GetFolderItem(data)
		    if f = nil then
		      MsgBox  Dico.Value("MsgErrOpenFile")
		    else
		      WorkWindow.OpenFile(f)
		    end if
		  end if
		  app.ipc = new IPC
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor()
		  path = "SpecialFolder.Documents"
		  
		  if not app.ipctransfert then 
		    listen
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As String
		  return "IPC"
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Send(file as string)
		  file = DefineEncoding(file,Encodings.UTF8)
		  
		  Connect
		  while not IsConnected
		    Poll
		    if LastErrorCode > 0 then
		      return
		    end if
		  wend
		  if file <> "" then
		    Write(file)
		  else
		    Write("focus")
		  end if
		  Flush
		  Close
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Path"
			Visible=true
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
