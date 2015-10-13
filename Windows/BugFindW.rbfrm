#tag Window
Begin Window BugFindW
   BackColor       =   16777215
   Backdrop        =   ""
   BalloonHelp     =   ""
   CloseButton     =   "False"
   Composite       =   "False"
   Frame           =   0
   FullScreen      =   "False"
   HasBackColor    =   "True"
   Height          =   144
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
   Title           =   "Bug découvert"
   Visible         =   "True"
   Width           =   421
   Begin StaticText StaticText2
      AutoDeactivate  =   "True"
      Bold            =   "True"
      ControlOrder    =   0
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Height          =   110
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Multiline       =   "True"
      Scope           =   0
      TabPanelIndex   =   0
      Text            =   "Cette figure a provoqué une erreur et va être fermée.\r\nNous nous excusons de ce désagrément.\r\n"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "SmallSystem"
      TextSize        =   12
      Top             =   0
      Underline       =   ""
      Visible         =   "True"
      Width           =   381
      BehaviorIndex   =   0
   End
   Begin PushButton Accepter
      AutoDeactivate  =   "True"
      Bold            =   ""
      Cancel          =   ""
      Caption         =   "OK"
      ControlOrder    =   1
      Default         =   ""
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   251
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   110
      Underline       =   ""
      Visible         =   "True"
      Width           =   80
      BehaviorIndex   =   1
   End
   Begin PushButton Refuser
      AutoDeactivate  =   "True"
      Bold            =   ""
      Cancel          =   ""
      Caption         =   "Annuler"
      ControlOrder    =   2
      Default         =   ""
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   334
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   110
      Underline       =   ""
      Visible         =   "True"
      Width           =   80
      BehaviorIndex   =   2
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  dim s as string
		  
		  s = " "+ EndOfLine +  dico.value("bugfound")+ EndOfLine + dico.value("bugcontinue") + EndOfLine + dico.value( "bugsorry")
		  if System.Network.IsConnected then
		    Refuser.visible = true
		    StaticText2.text = s + EndofLine + EndOfLine+dico.value( "bugsignal")
		  else
		    Refuser.visible = false
		    StaticText2.text = s
		  end if
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


#tag EndWindowCode

#tag Events Accepter
	#tag Event
		Sub Action()
		  dim Br as BugReport
		  
		  if System.Network.IsConnected then
		    br = new BugReport
		    Br.Show
		  end if
		  Close
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Refuser
	#tag Event
		Sub Action()
		  Close
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.caption = Dico.Value("Cancel")
		End Sub
	#tag EndEvent
#tag EndEvents
