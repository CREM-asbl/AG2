#tag Window
Begin Window GetUpdateW
   BackColor       =   16777215
   Backdrop        =   ""
   BalloonHelp     =   ""
   CloseButton     =   "False"
   Composite       =   "True"
   Frame           =   3
   FullScreen      =   "False"
   HasBackColor    =   "False"
   Height          =   172
   ImplicitInstance=   "True"
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   "False"
   MaxWidth        =   32000
   MenuBar         =   ""
   MenuBarVisible  =   "True"
   MinHeight       =   64
   MinimizeButton  =   "False"
   MinWidth        =   64
   Placement       =   2
   Resizeable      =   "False"
   Title           =   "Update"
   Visible         =   "True"
   Width           =   438
   Begin FtpConnexion FTP
      Address         =   ""
      ControlOrder    =   0
      dataport        =   12345
      Height          =   32
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      Port            =   0
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   0
      transfert       =   0
      Width           =   32
      BehaviorIndex   =   0
   End
   Begin StaticText StaticText1
      AutoDeactivate  =   "True"
      Bold            =   "True"
      ControlOrder    =   1
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Height          =   77
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   0
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Multiline       =   ""
      Scope           =   0
      TabPanelIndex   =   0
      Text            =   "Recherche de mises à jour ..."
      TextAlign       =   1
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   18
      Top             =   0
      Underline       =   ""
      Visible         =   "True"
      Width           =   438
      BehaviorIndex   =   1
   End
   Begin PushButton PushButton1
      AutoDeactivate  =   "True"
      Bold            =   "True"
      Cancel          =   ""
      Caption         =   "Mettre à jour"
      ControlOrder    =   2
      Default         =   "True"
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   192
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   134
      Underline       =   ""
      Visible         =   "True"
      Width           =   134
      BehaviorIndex   =   2
   End
   Begin StaticText Statut
      AutoDeactivate  =   "True"
      Bold            =   ""
      ControlOrder    =   3
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Height          =   33
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   51
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Multiline       =   "True"
      Scope           =   0
      TabPanelIndex   =   0
      Text            =   ""
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   89
      Underline       =   ""
      Visible         =   "True"
      Width           =   350
      BehaviorIndex   =   3
   End
   Begin PushButton PushButton2
      AutoDeactivate  =   "True"
      Bold            =   ""
      Cancel          =   ""
      Caption         =   "Annuler"
      ControlOrder    =   4
      Default         =   ""
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   338
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   134
      Underline       =   ""
      Visible         =   "True"
      Width           =   80
      BehaviorIndex   =   4
   End
   Begin ProgressBar TotalBar
      AutoDeactivate  =   "True"
      ControlOrder    =   5
      Enabled         =   "True"
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   51
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Maximum         =   100
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   68
      Value           =   0
      Visible         =   "False"
      Width           =   350
      BehaviorIndex   =   5
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  dim refs(-1) as String
		  
		  refs = Split(list,"-")
		  newVersion = refs(0)
		  StaticText1.Text = newVersion+" est disponible ("+SizeUnit(val(refs(1)),0)+")"
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Function SizeUnit(size As double, niveau as integer) As String
		  dim t as string
		  if size < 1024  or niveau =2 then
		    t =format(size,"#.00")
		    select case(niveau)
		    case 0
		      t = t +"o"
		    case 1
		      t=t+"Ko"
		    case 2
		      t=t+"Mo"
		    end
		    return t
		  else
		    size = size /1024.0
		    return SizeUnit(size,niveau+1)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update()
		  dim f as FolderItem
		  
		  #if TargetWin32
		    f = DesktopFolder.Child(newversion)
		  #else
		    f = DesktopFolder
		  #endif
		  StaticText1.Text = "Ouverture de la mise à jour..."
		  api.updateDone
		  f.Launch
		  Quit
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetUpdateW(l as string)
		  list = l
		  // Calling the overridden superclass constructor.
		  Super.Window
		  
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


	#tag Property, Flags = &h0
		CurrentFolder As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		newVersion As string
	#tag EndProperty

	#tag Property, Flags = &h0
		list As string
	#tag EndProperty

	#tag Property, Flags = &h0
		updated As boolean
	#tag EndProperty


#tag EndWindowCode

#tag Events FTP
	#tag Event
		Sub AfficherEtat(msg as String)
		  Statut.Text = msg
		End Sub
	#tag EndEvent
	#tag Event
		Sub NextStage(msg As String)
		  dim code As integer
		  dim  temp() as String
		  
		  code = val( NthField(msg," ",1))
		  
		  select case code
		  case 220
		    me.Commande("USER",me.login)
		  case 331
		    me.Commande("PASS",me.pass)
		  case 230
		    me.Commande("CWD","MAJ/")
		  case 226,250
		    if not me.GetFile then
		      me.Stop
		      StaticText1.Text="Téléchargement terminé."
		      Update
		    end if
		  case 257
		    me.Commande("TYPE","I")
		  case 213
		    me.DataSocket.gFileSize = val( NthField(msg," ",2))
		    me.Commande("PASV","")
		  case 200
		    me.Commande ("SIZE",me.CurrentFile)
		  case 227
		    msg = Replace(msg,")","")
		    temp = Split(msg,",")
		    me.dataport = val(temp(4))*256+val(temp(5))
		    me.Commande("RETR",me.CurrentFile)
		  end
		End Sub
	#tag EndEvent
	#tag Event
		Function NextFiles() As boolean
		  if not updated then
		    CurrentFolder = DesktopFolder
		    me.CurrentFile = newVersion
		    me.DataSocket.SetFTT(CurrentFolder.Child(newversion))
		    me.Commande("PWD","")
		    updated = true
		    return true
		  end if
		  
		  return false
		End Function
	#tag EndEvent
	#tag Event
		Sub Progress(percent as integer)
		  TotalBar.Value = percent
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton1
	#tag Event
		Sub Action()
		  FTP.Start
		  StaticText1.Text = "Téléchargement en cours..."
		  PushButton1.Visible = false
		  TotalBar.Visible = true
		  
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.Caption = Dico.Value("Update")
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton2
	#tag Event
		Sub Action()
		  Ftp.Stop
		  StaticText1.Text = "Mise à jour annulée."
		  updated = false
		  Close
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.Caption = Dico.Value("Cancel")
		End Sub
	#tag EndEvent
#tag EndEvents
