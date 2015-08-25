#tag Window
Begin Window PrefChangeWindow
   BackColor       =   16777215
   Backdrop        =   0
   BalloonHelp     =   ""
   CloseButton     =   "False"
   Composite       =   "False"
   Frame           =   1
   FullScreen      =   "False"
   HasBackColor    =   "False"
   Height          =   115
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
   Resizeable      =   "False"
   Title           =   "Choix Config"
   Visible         =   "True"
   Width           =   366
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
      Text            =   "Configuration :"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   14
      Underline       =   "False"
      Visible         =   "True"
      Width           =   107
      BehaviorIndex   =   0
   End
   Begin PopupMenu PopupMenu1
      AutoDeactivate  =   "True"
      Bold            =   "False"
      ControlOrder    =   1
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   "False"
      Left            =   152
      ListIndex       =   0
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   14
      Underline       =   "False"
      Visible         =   "True"
      Width           =   154
      BehaviorIndex   =   1
   End
   Begin PushButton PushButton1
      AutoDeactivate  =   "True"
      Bold            =   "False"
      Cancel          =   "False"
      Caption         =   "OK"
      ControlOrder    =   2
      Default         =   "True"
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   183
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   75
      Underline       =   "False"
      Visible         =   "True"
      Width           =   69
      BehaviorIndex   =   2
   End
   Begin PushButton PushButton2
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
      Left            =   58
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   75
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
		  Title=Dico.value("PrefsChange")
		  oldMenu = Config.Menu
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub update()
		  
		  Config.ChargerConfig
		  wnd.refresh
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
		oldMenu As string
	#tag EndProperty


#tag EndWindowCode

#tag Events StaticText1
	#tag Event
		Sub Open()
		  me.Text = Dico.value("Configuration")
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PopupMenu1
	#tag Event
		Sub Change()
		  Config.Menu = PopupMenu1.text
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  dim i as integer
		  dim menus(-1) as string
		  
		  menus = app.MenusDispo
		  for i=0 to UBound(menus)
		    me.addRow(menus(i))
		    if menus(i) = config.Menu then
		      me.ListIndex = i
		    end if
		  next
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton1
	#tag Event
		Sub Open()
		  me.Caption = Dico.value("OK")
		End Sub
	#tag EndEvent
	#tag Event
		Sub Action()
		  update
		  close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton2
	#tag Event
		Sub Action()
		  Config.Menu = oldMenu
		  update
		  Close
		End Sub
	#tag EndEvent
#tag EndEvents
