#tag Class
Protected Class Notification
Inherits URLConnection
	#tag Event
		Sub ContentReceived(URL As String, HTTPStatus As Integer, content As String)
		  dim doc as XmlDocument
		  dim El as XmlNode
		  dim info, validite, version as String
		  
		  try
		    doc = new XmlDocument(DefineEncoding(content, Encodings.UTF8))
		    El = doc.FirstChild
		    info = El.FirstChild.FirstChild.Value
		    validite =  El.Child(1).FirstChild.Value
		    version = app.copyright
		    if version < validite and info<>Config.LastInfo  then
		      MsgBox  El.LastChild.FirstChild.Value
		      Config.LastInfo = info
		    end if
		  catch err as XmlException
		  end try
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor()
		  Send("GET",url+"info.xml")
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
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
		#tag ViewProperty
			Name="AllowCertificateValidation"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HTTPStatusCode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
