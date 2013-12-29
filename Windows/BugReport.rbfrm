#tag Window
Begin Window BugReport
   BackColor       =   16777215
   Backdrop        =   ""
   BalloonHelp     =   ""
   CloseButton     =   "True"
   Composite       =   "True"
   Frame           =   0
   FullScreen      =   "False"
   HasBackColor    =   "True"
   Height          =   223
   ImplicitInstance=   "True"
   LiveResize      =   "False"
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
   Title           =   "Rapport de bug"
   Visible         =   "True"
   Width           =   300
   Begin ProgressBar TotalBar
      AutoDeactivate  =   "True"
      ControlOrder    =   0
      Enabled         =   "True"
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   20
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Maximum         =   100
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   133
      Value           =   0
      Visible         =   "True"
      Width           =   268
      BehaviorIndex   =   0
   End
   Begin PushButton PushButton1
      AutoDeactivate  =   "True"
      Bold            =   ""
      Cancel          =   ""
      Caption         =   "Cancel"
      ControlOrder    =   1
      Default         =   ""
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   208
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   175
      Underline       =   ""
      Visible         =   "True"
      Width           =   80
      BehaviorIndex   =   1
   End
   Begin StaticText StaticText1
      AutoDeactivate  =   "True"
      Bold            =   ""
      ControlOrder    =   2
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Multiline       =   ""
      Scope           =   0
      TabPanelIndex   =   0
      Text            =   "Envoi fichier log"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   42
      Underline       =   ""
      Visible         =   "True"
      Width           =   100
      BehaviorIndex   =   2
   End
   Begin StaticText StaticText2
      AutoDeactivate  =   "True"
      Bold            =   ""
      ControlOrder    =   3
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Multiline       =   ""
      Scope           =   0
      TabPanelIndex   =   0
      Text            =   "Envoi historique"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   74
      Underline       =   ""
      Visible         =   "True"
      Width           =   100
      BehaviorIndex   =   3
   End
   Begin ProgressBar FirstBar
      AutoDeactivate  =   "True"
      ControlOrder    =   4
      Enabled         =   "True"
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   120
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Maximum         =   100
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   42
      Value           =   0
      Visible         =   "True"
      Width           =   152
      BehaviorIndex   =   4
   End
   Begin ProgressBar SecondBar
      AutoDeactivate  =   "True"
      ControlOrder    =   5
      Enabled         =   "True"
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   120
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Maximum         =   100
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   74
      Value           =   0
      Visible         =   "True"
      Width           =   152
      BehaviorIndex   =   5
   End
   Begin StaticText StaticText3
      AutoDeactivate  =   "True"
      Bold            =   ""
      ControlOrder    =   6
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Multiline       =   ""
      Scope           =   0
      TabPanelIndex   =   0
      Text            =   "Avancement général "
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   106
      Underline       =   ""
      Visible         =   "True"
      Width           =   118
      BehaviorIndex   =   6
   End
   Begin FtpConnexion FTP
      Address         =   ""
      ControlOrder    =   7
      dataport        =   12345
      Height          =   32
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   6
      Port            =   1000
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   6
      transfert       =   0
      Width           =   32
      BehaviorIndex   =   7
   End
   Begin StaticText Etat
      AutoDeactivate  =   "True"
      Bold            =   ""
      ControlOrder    =   8
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Height          =   28
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
      Text            =   " Idle"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   197
      Underline       =   ""
      Visible         =   "True"
      Width           =   300
      BehaviorIndex   =   8
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  FTP.Start
		  
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Close()
		  FTP.Stop
		End Sub
	#tag EndEvent


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
		NumFichier As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Directory() As String
	#tag EndProperty


#tag EndWindowCode

#tag Events PushButton1
	#tag Event
		Sub Action()
		  self.Close
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.caption = Dico.Value("Cancel")
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events FTP
	#tag Event
		Sub AfficherEtat(msg as String)
		  Etat.Text = msg
		End Sub
	#tag EndEvent
	#tag Event
		Function NextFiles() As boolean
		  dim s As  String
		  dim b as Boolean
		  
		  select case NumFichier
		  case 0
		    me.DataSocket.SetFTT(App.DocFolder.Child("AG2.log"))
		    b =  true
		  case 1
		    if app.currentfile<>nil then
		      me.DataSocket.SetFTT(app.currentfile)
		      b =  true
		    else
		      NumFichier=NumFichier+1
		      me.GetProgress(100)
		    end if
		  end select
		  NumFichier=NumFichier+1
		  return b
		  
		  
		  
		  
		End Function
	#tag EndEvent
	#tag Event
		Sub Progress(percent as integer)
		  select case NumFichier
		  case 1
		    FirstBar.Value = percent
		  case 2
		    FirstBar.Value = 100
		    SecondBar.Value = percent
		  end select
		  TotalBar.Value = (FirstBar.Value + SecondBar.Value)/2
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub NextStage(msg As String)
		  dim code As integer
		  dim  temp() as String
		  dim d As date
		  
		  code = val( NthField(msg," ",1))
		  
		  
		  select case code
		  case 220
		    me.Commande("USER",me.login)
		  case 331
		    me.Commande("PASS",me.pass)
		  case 230
		    directory.append("Bugs AG2")
		    directory.append("AG Version "+str(app.MajorVersion)+"."+str(app.MinorVersion)+"."+str(app.BugVersion)+" "+app.StageCodeToString)
		    directory.append(App.Sys)
		    directory.append(App.ErrorType)
		    d = new date()
		    directory.append(d.LongDate+" "+str(d.Hour)+"h"+str(d.Minute)+"min"+str(d.Second))
		    me.Commande("CWD", directory(0))
		  case 257
		    if me.transfert then
		      me.Commande("TYPE","A")
		    else
		      me.Commande("CWD",Directory(0))
		    end if
		  case 250
		    if Ubound(directory)>-1 then
		      Directory.Remove(0)
		    end if
		    if Ubound(directory)>-1 then
		      me.Commande("CWD",directory(0))
		    elseif Not me.transfert then
		      if me.GetFile then
		        me.transfert = true
		        me.Commande("PWD","")
		      else
		        me.Stop
		        msgBox Dico.Value("Bugsent")
		        Close
		      end if
		    end if
		  case 200
		    me.Commande("PASV","")
		  case 227
		    msg = Replace(msg,")","")
		    temp = Split(msg,",")
		    me.dataport = val(temp(4))*256+val(temp(5))
		    me.Commande("STOR",me.CurrentFile)
		  case 226
		    if me.GetFile then
		      me.transfert = true
		      me.Commande("PWD","")
		    else
		      me.Stop
		      msgBox Dico.Value("Bugsent")
		      Close
		    end if
		  case 550
		    me.Commande("MKD",directory(0))
		  end
		  
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
