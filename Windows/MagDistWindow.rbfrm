#tag Window
Begin Window MagDistWindow
   BackColor       =   16777215
   Backdrop        =   0
   BalloonHelp     =   ""
   CloseButton     =   "False"
   Composite       =   "False"
   Frame           =   1
   FullScreen      =   "False"
   HasBackColor    =   "False"
   Height          =   133
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
   Title           =   "DistMag"
   Visible         =   "True"
   Width           =   281
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
      Left            =   8
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Multiline       =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      Text            =   "Distance Magnétique"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "Arial"
      TextSize        =   12
      Top             =   22
      Underline       =   "False"
      Visible         =   "True"
      Width           =   127
      BehaviorIndex   =   0
   End
   Begin EditField EditField1
      AcceptTabs      =   "False"
      Alignment       =   0
      AutoDeactivate  =   "True"
      BackColor       =   16777215
      Bold            =   "False"
      Border          =   "True"
      ControlOrder    =   1
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   157
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
      TextFont        =   "Arial"
      TextSize        =   12
      Top             =   21
      Underline       =   "False"
      UseFocusRing    =   "True"
      Visible         =   "True"
      Width           =   80
      BehaviorIndex   =   1
   End
   Begin PushButton OKButton
      AutoDeactivate  =   "True"
      Bold            =   "False"
      Cancel          =   "False"
      Caption         =   "OK"
      ControlOrder    =   2
      Default         =   "False"
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   168
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "Arial"
      TextSize        =   12
      Top             =   78
      Underline       =   "False"
      Visible         =   "True"
      Width           =   69
      BehaviorIndex   =   2
   End
   Begin PushButton CancelButton
      AutoDeactivate  =   "True"
      Bold            =   "False"
      Cancel          =   "False"
      Caption         =   "Cancel"
      ControlOrder    =   3
      Default         =   "False"
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   29
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "Arial"
      TextSize        =   12
      Top             =   78
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
		  
		  Title = " "
		  StaticText1.Text = Dico.Value("MagDist")
		  CancelButton.Caption = Dico.Value("Cancel")
		  OKButton.Caption = Dico.Value("OK")
		  EditField1.text = str(Config.magneticdist)
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
		result As integer
	#tag EndProperty


#tag EndWindowCode

#tag Events OKButton
	#tag Event
		Sub Action()
		  Result = 1
		  Hide
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CancelButton
	#tag Event
		Sub Action()
		  result = -1
		  Close
		End Sub
	#tag EndEvent
#tag EndEvents
