#tag Window
Begin Window Confirmation
   BackColor       =   16777215
   Backdrop        =   0
   BalloonHelp     =   ""
   CloseButton     =   "False"
   Composite       =   "False"
   Frame           =   1
   FullScreen      =   "False"
   HasBackColor    =   "False"
   Height          =   96
   ImplicitInstance=   "True"
   LiveResize      =   "False"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   "False"
   MaxWidth        =   32000
   MenuBar         =   0
   MenuBarVisible  =   "True"
   MinHeight       =   64
   MinimizeButton  =   "False"
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   "True"
   Title           =   "Attention"
   Visible         =   "True"
   Width           =   308
   Begin StaticText StaticText1
      AutoDeactivate  =   "True"
      Bold            =   "False"
      ControlOrder    =   0
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   20
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Multiline       =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      Text            =   "Sauver?"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   25
      Underline       =   "False"
      Visible         =   "True"
      Width           =   150
      BehaviorIndex   =   0
   End
   Begin PushButton Yes
      AutoDeactivate  =   "True"
      Bold            =   "False"
      Cancel          =   "False"
      Caption         =   "Oui"
      ControlOrder    =   1
      Default         =   "True"
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   20
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   57
      Underline       =   "False"
      Visible         =   "True"
      Width           =   69
      BehaviorIndex   =   1
   End
   Begin PushButton No
      AutoDeactivate  =   "True"
      Bold            =   "False"
      Cancel          =   "False"
      Caption         =   "Non"
      ControlOrder    =   2
      Default         =   "False"
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   101
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   57
      Underline       =   "False"
      Visible         =   "True"
      Width           =   69
      BehaviorIndex   =   2
   End
   Begin PushButton Cancel
      AutoDeactivate  =   "True"
      Bold            =   "False"
      Cancel          =   "False"
      Caption         =   "Annuler"
      ControlOrder    =   3
      Default         =   "False"
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   218
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   57
      Underline       =   "False"
      Visible         =   "True"
      Width           =   69
      BehaviorIndex   =   3
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  
		  
		  Title = Dico.value("Confirmation")
		  
		  if CurrentContent.bugfound then
		    Cancel.Visible =false
		  end if
		  result=-1
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Confirmation(i as integer)
		  Super.Window
		  StaticText1.text = Dico.value("savepic") + " " + str(i)+" ?"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Confirmation(s as string)
		  Super.Window
		  StaticText1.text = s
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
		Result As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Closing As integer
	#tag EndProperty


#tag EndWindowCode

#tag Events StaticText1
	#tag Event
		Sub Open()
		  me.Text = Dico.value("FileSave")
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Yes
	#tag Event
		Sub Action()
		  
		  result=1
		  Hide
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.caption = Dico.Value("Oui")
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events No
	#tag Event
		Sub Action()
		  result=0
		  Close
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.Caption = Dico.Value("Non")
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Cancel
	#tag Event
		Sub Action()
		  result=-1
		  Hide
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.caption = Dico.value("Cancel")
		End Sub
	#tag EndEvent
#tag EndEvents
