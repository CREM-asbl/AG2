#tag Class
Protected Class FtpConnexion
Inherits TCPSocket
	#tag Event
		Sub Connected()
		  AfficherEtat ("Connected")
		  crlf =  chr(13) + chr(10)
		  DataSocket = New FtpDataSocket(self)
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub DataAvailable()
		  NextStage(ReadAll)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Error()
		  dim n as integer
		  if LastErrorCode = 102 then
		    n = MsgBox (" Perte de connexion",53)
		  else
		    n = MsgBox (" Erreur Connexion ",53)
		  end if
		  if n = 4 then
		    if not DataSocket.IsConnected then
		      Commande("PWD","")
		    else
		      DataSocket.Connect
		    end if
		  else
		    quit
		  end if
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Commande(cmd as String, param as String)
		  select case cmd
		  case "USER"
		    AfficherEtat("sending login ...")
		  case "PASS"
		    AfficherEtat("sending pass...")
		  case "CWD"
		    AfficherEtat("opening "+param)
		  case "MKD"
		    AfficherEtat("creating new repertory...")
		  case "TYPE"
		    AfficherEtat("changing type...")
		  case "PASV"
		    AfficherEtat("running passive mode...")
		  case "STOR"
		    AfficherEtat("sending "+param+"  ...")
		    DataSocket.SetIsUpload(true)
		    DataSocket.Port = dataport
		    DataSocket.Connect
		  case "RETR"
		    AfficherEtat("get "+param+" ...")
		    DataSocket.SetIsUpload (false)
		    DataSocket.Port = dataport
		    DataSocket.Connect
		  case "SIZE"
		    AfficherEtat "getsize "+param+"..."
		  end select
		  
		  Write(cmd+" "+param+crlf)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EstimationTime(time as integer) As String
		  dim t as string
		  
		  
		  if time = 0 then
		    t = "0 sec"
		  elseif time >0 then
		    if (time>3600) then
		      t = str(Round(time/3600))+" h "
		    end if
		    if (time mod (3600) > 60) then
		      t = t+str(Round((time mod 3600)/60))+" min "
		    end if
		    if (time mod 60 > 0) then
		      t = t+str(Round(time mod 60))+" sec "
		    end if
		  else
		    t = "???"
		  end if
		  
		  return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFile() As Boolean
		  dim b as Boolean
		  
		  b = NextFiles
		  if b and DataSocket.FileToTransfert<>nil then
		    CurrentFile = DataSocket.FileToTransfert.Name
		    Time = new Date()
		  end if
		  return b
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetProgress(percent as integer)
		  dim d as Date
		  dim temps,estimation as integer
		  dim Trestant,vitesse as String
		  
		  Progress (percent)
		  
		  d = new Date()
		  temps = d.TotalSeconds-Time.TotalSeconds
		  estimation = temps*(100-percent)/percent
		  Trestant = EstimationTime(estimation)
		  vitesse =  str(Round((DataSocket.BytesAvailable/1024)/temps))+"ko/s"
		  
		  AfficherEtat ("temps restant : "+Trestant+"- "+str(percent)+"% ("+vitesse+")")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Start()
		  Address = Serveur
		  Port = portFTP
		  Connect
		  
		  While not IsConnected
		    if LastErrorCode <> 0 then
		      MsgBox str(LastErrorCode)
		      quit
		    end if
		    Poll
		  wend
		  
		  if not IsConnected then
		    AfficherEtat Dico.value("No Connection")
		    MsgBox Dico.value("No Connection")
		    close
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Stop()
		  if DataSocket <>nil then
		    DataSocket.Close
		  end if
		  write ("QUIT " +crlf)
		  close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Suite()
		  NextStage ("250")
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event AfficherEtat(msg as String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event NextFiles() As boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event NextStage(msg As String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Progress(percent as integer)
	#tag EndHook


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


	#tag Property, Flags = &h0
		crlf As String
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentFile As String
	#tag EndProperty

	#tag Property, Flags = &h0
		dataport As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		DataSocket As FtpDataSocket
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Time As Date
	#tag EndProperty

	#tag Property, Flags = &h0
		transfert As boolean
	#tag EndProperty


	#tag Constant, Name = login, Type = String, Dynamic = False, Default = \"AG2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = pass, Type = String, Dynamic = False, Default = \"Ffiarpg79AG2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = portFTP, Type = Double, Dynamic = False, Default = \"21", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Serveur, Type = String, Dynamic = False, Default = \"serveur.crem.be", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Address"
			Visible=true
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="crlf"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentFile"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="dataport"
			Group="Behavior"
			InitialValue="12345"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
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
			Name="transfert"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
