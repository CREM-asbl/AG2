#tag Window
Begin Window Languagewindow
   BackColor       =   16777215
   Backdrop        =   0
   BalloonHelp     =   ""
   CloseButton     =   "False"
   Composite       =   "False"
   Frame           =   1
   FullScreen      =   "False"
   HasBackColor    =   "False"
   Height          =   55
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
   Title           =   "Choix de la langue"
   Visible         =   "True"
   Width           =   251
   Begin PopupMenu LanguagePopup
      AutoDeactivate  =   "True"
      Bold            =   "False"
      ControlOrder    =   0
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Height          =   21
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   "False"
      Left            =   15
      ListIndex       =   0
      LockBottom      =   "False"
      LockLeft        =   "True"
      LockRight       =   "False"
      LockTop         =   "True"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   14
      Underline       =   "False"
      Visible         =   "True"
      Width           =   126
      BehaviorIndex   =   0
   End
   Begin PushButton OKButton
      AutoDeactivate  =   "True"
      Bold            =   "False"
      Cancel          =   "False"
      Caption         =   "OK"
      ControlOrder    =   1
      Default         =   "True"
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   159
      LockBottom      =   "False"
      LockLeft        =   "True"
      LockRight       =   "False"
      LockTop         =   "True"
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   12
      Top             =   15
      Underline       =   "False"
      Visible         =   "True"
      Width           =   69
      BehaviorIndex   =   1
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Paint(g As Graphics)
		  Title=Dico.value("LangWindow")
		  OKButton.SetFocus
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Languagewindow(w as Window)
		  // Calling the overridden superclass constructor.
		  Parent  = w
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
		Parent As Window
	#tag EndProperty


#tag EndWindowCode

#tag Events LanguagePopup
	#tag Event
		Sub Open()
		  dim i as integer
		  dim dicos(-1) as string
		  
		  dicos = app.DicoDispo
		  for i=0 to UBound(dicos)
		    me.addRow(dicos(i))
		    if dicos(i) = config.Langue then
		      me.ListIndex = i
		    end if
		  next
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Change()
		  if parent isa configwindow then
		    Config.SetLangue(LanguagePopup.Text)
		    refresh
		    Parent.refresh
		    wnd.updatemenu
		  elseif parent isa dictwindow then
		    dictwindow(parent).lang = Languagepopup.text
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events OKButton
	#tag Event
		Sub Action()
		  if parent isa configwindow then
		    Config.SetLangue(LanguagePopup.Text)
		    refresh
		    Parent.refresh
		    wnd.updatemenu
		  elseif parent isa dictwindow then
		    DictWindow(Parent).Lang = LanguagePopup.Text
		  end if
		  self.close
		End Sub
	#tag EndEvent
#tag EndEvents
