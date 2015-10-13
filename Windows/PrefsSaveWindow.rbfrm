#tag Window
Begin Window PrefsSaveWindow
   BackColor       =   16777215
   Backdrop        =   0
   BalloonHelp     =   ""
   CloseButton     =   "False"
   Composite       =   "False"
   Frame           =   1
   FullScreen      =   "False"
   HasBackColor    =   "False"
   Height          =   94
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
   Title           =   "Enregistrer Sous"
   Visible         =   "True"
   Width           =   408
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
      Text            =   "Nom de la configuration"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   14
      Underline       =   "False"
      Visible         =   "True"
      Width           =   185
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
      Left            =   217
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
      ScrollbarVertical=   "True"
      Styled          =   "False"
      TabPanelIndex   =   0
      Text            =   ""
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   13
      Underline       =   "False"
      UseFocusRing    =   "True"
      Visible         =   "True"
      Width           =   108
      BehaviorIndex   =   1
   End
   Begin PushButton ButtonOk
      AutoDeactivate  =   "True"
      Bold            =   "False"
      Cancel          =   "False"
      Caption         =   "Ok"
      ControlOrder    =   2
      Default         =   "True"
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   256
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   52
      Underline       =   "False"
      Visible         =   "True"
      Width           =   69
      BehaviorIndex   =   2
   End
   Begin PushButton CancelButton
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
      Left            =   20
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   52
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
		  Title=Dico.value("PrefsSave")
		  EditField1.text = config.Menu
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

#tag Events StaticText1
	#tag Event
		Sub Open()
		  me.Text = Dico.value("NomConfig")
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ButtonOk
	#tag Event
		Sub Action()
		  dim nom as string
		  nom = EditField1.text
		  if (instr(nom, " ") <> 0)or (nom.Len() = 0)  then
		    MsgBox Dico.Value("Noblankspace")
		  else
		    Config.setMenu(nom)
		    Config.SaveToFile
		    Config.save
		    Close
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CancelButton
	#tag Event
		Sub Open()
		  me.Caption = dico.value("Cancel")
		End Sub
	#tag EndEvent
	#tag Event
		Sub Action()
		  close
		End Sub
	#tag EndEvent
#tag EndEvents
