#tag Window
Begin Window StdFormswindow
   BackColor       =   16777215
   Backdrop        =   0
   BalloonHelp     =   ""
   CloseButton     =   "False"
   Composite       =   "False"
   Frame           =   1
   FullScreen      =   "False"
   HasBackColor    =   "False"
   Height          =   148
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
   Title           =   "StdForms"
   Visible         =   "True"
   Width           =   277
   Begin StaticText StaticText1
      AutoDeactivate  =   "True"
      Bold            =   "False"
      ControlOrder    =   0
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   14
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Multiline       =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      Text            =   "StdFile: "
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "Arial"
      TextSize        =   12
      Top             =   14
      Underline       =   "False"
      Visible         =   True
      Width           =   100
      BehaviorIndex   =   0
   End
   Begin PopupMenu PopupMenu1
      AutoDeactivate  =   "True"
      Bold            =   "False"
      ControlOrder    =   1
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   "False"
      Left            =   118
      ListIndex       =   1
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "Arial"
      TextSize        =   12
      Top             =   13
      Underline       =   "False"
      Visible         =   True
      Width           =   126
      BehaviorIndex   =   1
   End
   Begin StaticText StaticText2
      AutoDeactivate  =   "True"
      Bold            =   "False"
      ControlOrder    =   2
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   14
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Multiline       =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      Text            =   "Label:"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "Arial"
      TextSize        =   12
      Top             =   63
      Underline       =   "False"
      Visible         =   True
      Width           =   100
      BehaviorIndex   =   2
   End
   Begin PopupMenu PopupMenu2
      AutoDeactivate  =   "True"
      Bold            =   "False"
      ControlOrder    =   3
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "1\r\n2\r\n3"
      Italic          =   "False"
      Left            =   126
      ListIndex       =   0
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "Arial"
      TextSize        =   12
      Top             =   62
      Underline       =   "False"
      Visible         =   True
      Width           =   42
      BehaviorIndex   =   3
   End
   Begin PushButton OKButton
      AutoDeactivate  =   "True"
      Bold            =   "False"
      Cancel          =   "False"
      Caption         =   "OK"
      ControlOrder    =   4
      Default         =   "False"
      Enabled         =   True
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   158
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "Arial"
      TextSize        =   12
      Top             =   106
      Underline       =   "False"
      Visible         =   True
      Width           =   69
      BehaviorIndex   =   4
   End
   Begin PushButton CancelButton
      AutoDeactivate  =   "True"
      Bold            =   "False"
      Cancel          =   "False"
      Caption         =   "Cancel"
      ControlOrder    =   5
      Default         =   "False"
      Enabled         =   True
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   45
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "Arial"
      TextSize        =   12
      Top             =   106
      Underline       =   "False"
      Visible         =   True
      Width           =   69
      BehaviorIndex   =   5
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  
		  Title = Dico.Value("PrefsStdForms")
		  OKButton.Caption = Dico.Value("OK")
		  CancelButton.Caption = Dico.value("Cancel")
		  StaticText1.Text = Dico.Value("PrefsStdFormsFile")
		  StaticText2.Text = Dico.Value("PrefsStdFormsSize")
		  
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
		oldnfam As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		nstdfile As integer
	#tag EndProperty


#tag EndWindowCode

#tag Events PopupMenu1
	#tag Event
		Sub Open()
		  dim i,j as integer
		  dim nom as string
		  
		  for i=1 to app.AppFolder.count
		    nom = app.AppFolder.trueItem(i).Name
		    if right(nom,4)=".std" then
		      me.addRow(nom)
		      if nom = Config.stdfile then
		        me.ListIndex= j
		      end if
		      j = j+1
		    end if
		  next
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events OKButton
	#tag Event
		Sub Action()
		  dim i as integer
		  
		  Config.setStdFile(popupmenu1.text)
		  Config.stdsize = val(popupmenu2.text)
		  
		  'todo : à améliorer
		  wnd.StdBoxRefresh
		  for i=0 to 3
		    wnd.SetIco(i,0)
		    wnd.StdOutil(i).refresh
		  next
		  Close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CancelButton
	#tag Event
		Sub Action()
		  close
		End Sub
	#tag EndEvent
#tag EndEvents
