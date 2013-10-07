#tag Window
Begin Window InitWindow
   BackColor       =   16777215
   Backdrop        =   1356826623
   BalloonHelp     =   ""
   CloseButton     =   "False"
   Composite       =   "True"
   Frame           =   4
   FullScreen      =   "False"
   HasBackColor    =   "False"
   Height          =   584
   ImplicitInstance=   "True"
   LiveResize      =   "False"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   "True"
   MaxWidth        =   32000
   MenuBar         =   0
   MenuBarVisible  =   "True"
   MinHeight       =   64
   MinimizeButton  =   "True"
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   "False"
   Title           =   ""
   Visible         =   "True"
   Width           =   772
   Begin PopupMenu PopupMenu1
      AutoDeactivate  =   "True"
      Bold            =   "True"
      ControlOrder    =   0
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   "False"
      Left            =   559
      ListIndex       =   0
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   405
      Underline       =   "False"
      Visible         =   "True"
      Width           =   135
      BehaviorIndex   =   0
   End
   Begin PushButton PushButton1
      AutoDeactivate  =   "True"
      Bold            =   "True"
      Cancel          =   "False"
      Caption         =   "Ok"
      ControlOrder    =   1
      Default         =   "False"
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   706
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   402
      Underline       =   "False"
      Visible         =   "False"
      Width           =   42
      BehaviorIndex   =   1
   End
   Begin EditField User
      AcceptTabs      =   "False"
      Alignment       =   1
      AutoDeactivate  =   "True"
      BackColor       =   16777215
      Bold            =   "True"
      Border          =   "True"
      ControlOrder    =   2
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Format          =   ""
      Height          =   24
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   640
      LimitText       =   0
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Mask            =   ""
      Multiline       =   "False"
      Password        =   "False"
      ReadOnly        =   "False"
      Scope           =   0
      ScrollbarHorizontal=   "False"
      ScrollbarVertical=   "False"
      Styled          =   "False"
      TabPanelIndex   =   0
      Text            =   ""
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   370
      Underline       =   "False"
      UseFocusRing    =   "True"
      Visible         =   "False"
      Width           =   108
      BehaviorIndex   =   2
   End
   Begin PushButton PushButton2
      AutoDeactivate  =   "True"
      Bold            =   "True"
      Cancel          =   "False"
      Caption         =   "Enseignant(e)"
      ControlOrder    =   3
      Default         =   "False"
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   559
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   330
      Underline       =   "False"
      Visible         =   "True"
      Width           =   112
      BehaviorIndex   =   3
   End
   Begin PushButton PushButton3
      AutoDeactivate  =   "True"
      Bold            =   "True"
      Cancel          =   "False"
      Caption         =   "Elève"
      ControlOrder    =   4
      Default         =   "False"
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   559
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   368
      Underline       =   "False"
      Visible         =   "True"
      Width           =   69
      BehaviorIndex   =   4
   End
   Begin PushButton PushButton4
      AutoDeactivate  =   "True"
      Bold            =   "True"
      Cancel          =   ""
      Caption         =   "Annuler"
      ControlOrder    =   5
      Default         =   ""
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   586
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   446
      Underline       =   ""
      Visible         =   "True"
      Width           =   108
      BehaviorIndex   =   5
   End
End
#tag EndWindow

#tag WindowCode
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
		result As integer
	#tag EndProperty


#tag EndWindowCode

#tag Events PopupMenu1
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
		  me.ListIndex = max(0,me.ListIndex)
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton1
	#tag Event
		Sub Action()
		  Config.Menu = PopupMenu1.Text
		  Config.ChargerConfig
		  Close
		  
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events User
	#tag Event
		Function KeyDown(Key As String) As Boolean
		  if Key = chr(13) then
		    if me.text <> "" then
		      close
		    end if
		  end if
		End Function
	#tag EndEvent
	#tag Event
		Sub GotFocus()
		  Config.pwok = false
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub TextChange()
		  Config.username = me.text
		  if me.text <> "" then
		    pushbutton1.visible = true
		    pushbutton1.default = true
		  else
		    pushbutton1.visible = false
		    pushbutton1.default = false
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton2
	#tag Event
		Sub Action()
		  dim pw as PasswordWindow
		  
		  Config.pwok = false
		  
		  if Config.Password <> "1" then
		    pw=new PasswordWindow
		    pw.ShowModal
		    select case pw.Result
		    case 1
		      if hash(pw.editField1.Text)<>Config.Password then
		        msgBox Dico.value("MsgPWFalse")
		      else
		        Config.pwok = true
		      end if
		    end select
		    pw.close
		  else
		    Config.pwok = true
		  end if
		  
		  if Config.pwok = true then
		    pushbutton1.visible = true
		    user.visible = false
		    pushbutton3.visible = false
		    'todo : Remplacer par méthode setUser dans Configuration
		    Config.user = "prof"
		    Config.username = Dico.Value("Enseignant")
		    ////////
		    pushbutton1.setfocus
		    pushbutton1.default=true
		  end if
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.caption = Dico.Value("Enseignant")
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton3
	#tag Event
		Sub Action()
		  user.visible = true
		  user.setfocus
		  Config.user = "pup"
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.Caption = Dico.value("Pupil")
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton4
	#tag Event
		Sub Action()
		  Quit
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.caption = Dico.value("Cancel")
		End Sub
	#tag EndEvent
#tag EndEvents
