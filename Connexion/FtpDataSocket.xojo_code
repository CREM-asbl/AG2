#tag Class
Protected Class FtpDataSocket
Inherits TCPSocket
	#tag Event
		Sub Connected()
		  if upload then
		    SendFile
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Sub DataAvailable()
		  GetFile
		End Sub
	#tag EndEvent

	#tag Event
		Sub SendComplete(userAborted as Boolean)
		  Stop
		End Sub
	#tag EndEvent

	#tag Event
		Function SendProgress(bytesSent as Integer, bytesLeft as Integer) As Boolean
		  gFileSent =gFileSent+bytesSent
		  ControlSock.GetProgress((gFileSent*100)/gFileSize)
		  SendFile
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(cSock As FtpConnexion)
		  ControlSock = cSock
		  Address = cSock.Address
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetFile()
		  ControlSock.GetProgress(BytesAvailable*100/gFileSize)
		  
		  if BytesAvailable = gFileSize then
		    gBS = FileToTransfert.CreateBinaryFile("")
		    gBS.Write(ReadAll)
		    Stop
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SendFile()
		  dim temp as string
		  
		  if FileToTransfert <> nil and FileToTransfert.Length>0 then
		    if gBS = nil then
		      gBS = FileToTransfert.openasBinaryFile(false)
		      gFileSize = FileToTransfert.Length
		    end if
		    if not gBS.EOF then
		      temp = gBS.read(gBufferSize)
		      Me.write(temp)
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFTT(f as FolderItem)
		  FileToTransfert = f
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFTT(nom As String)
		  FileToTransfert =  GetFolderItem(nom)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetIsUpload(b as boolean)
		  Upload =b
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Stop()
		  gBS.Close
		  gBS = nil
		  FileToTransfert = nil
		  gFileSent = 0
		  gFileSize = 0
		  Close
		  
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = Licence
		
		Copyright © 2010 CREM
		Noël Guy - Pliez Geoffrey
		
		This file is part of Apprenti Géomètre 2.
		
		Apprenti Géomètre 2 is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.
		
		Apprenti Géomètre 2 is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.
		
		You should have received a copy of the GNU General Public License
		along with Apprenti Géomètre 2.  If not, see <http://www.gnu.org/licenses/>.
	#tag EndNote


	#tag Property, Flags = &h1
		Protected ControlSock As Ftpconnexion
	#tag EndProperty

	#tag Property, Flags = &h0
		FileToTransfert As Folderitem
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected gBS As BinaryStream
	#tag EndProperty

	#tag Property, Flags = &h0
		gBufferSize As integer = 1024
	#tag EndProperty

	#tag Property, Flags = &h0
		gFileSent As integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		gFileSize As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Upload As boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Address"
			Visible=true
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="gBufferSize"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="gFileSent"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="gFileSize"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
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
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Upload"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
