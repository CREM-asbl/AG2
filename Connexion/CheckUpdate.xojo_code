#tag Class
Protected Class CheckUpdate
Inherits URLConnection
	#tag Event
		Sub ContentReceived(URL As String, HTTPStatus As Integer, content As String)
		  if content > app.LongVersion  or (app.StageCode <> 3 and content = app.LongVersion) then
		    GetUpdateW.ShowModal
		  end if
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor()
		  Send("GET",url+"version.xml")
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
