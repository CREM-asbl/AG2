#tag Class
Protected Class IPC
Inherits IPCSocket
Implements StringProvider
	#tag Event
		Sub DataAvailable()
		  dim f as FolderItem
		  dim data as string
		  
		  data = me.ReadAll
		  if data <> "focus" then
		    f = new FolderItem(data)
		    wnd.Restore
		    wnd.OpenFile(f)
		  end if
		  listen
		  
		Exception err
		  dim d As Debug
		  d = new Debug
		  d.setMethod(getString,"dataAvailable")
		  d.setVariable("data",data)
		  d.setVariable("file",f)
		  err.message = err.message+d.getString
		  
		  Raise err
		  
		  
		  
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Send(file As folderItem)
		  Connect
		  while not IsConnected
		    Poll
		    if LastErrorCode > 0 then
		      return
		    end if
		  wend
		  if file <> nil then
		    Write(file.AbsolutePath)
		  else
		    Write("focus")
		  end if
		  Flush
		  Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IPC()
		  path = DocumentsFolder.name
		  
		Exception err
		  dim d As Debug
		  d = new Debug
		  d.setMethod(getString,"dataAvailable")
		  d.setVariable("path",path)
		  err.message = err.message+d.getString
		  Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As String
		  return "IPC"
		  
		  
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="IPCSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InheritedFrom="IPCSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="IPCSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ControlOrder"
			Visible=true
			Group="Position"
			InheritedFrom="IPCSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InheritedFrom="IPCSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InheritedFrom="IPCSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Path"
			Visible=true
			Group="Behavior"
			Type="String"
			InheritedFrom="IPCSocket"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
