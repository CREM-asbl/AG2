#tag Window
Begin Window HistCmd
   BackColor       =   16777215
   Backdrop        =   ""
   BalloonHelp     =   ""
   CloseButton     =   "False"
   Composite       =   "False"
   Frame           =   3
   FullScreen      =   "False"
   HasBackColor    =   "False"
   Height          =   22
   ImplicitInstance=   "True"
   LiveResize      =   "False"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   "False"
   MaxWidth        =   32000
   MenuBar         =   ""
   MenuBarVisible  =   "True"
   MinHeight       =   22
   MinimizeButton  =   "False"
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   "False"
   Title           =   ""
   Visible         =   "True"
   Width           =   600
   Begin ContainerControl1 HistCtrl
      AcceptFocus     =   ""
      AcceptTabs      =   ""
      AutoDeactivate  =   "True"
      ControlOrder    =   0
      Enabled         =   True
      EraseBackground =   "True"
      Height          =   22
      HelpTag         =   ""
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      Top             =   0
      UseFocusRing    =   ""
      Visible         =   "True"
      Width           =   600
      BehaviorIndex   =   0
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  Left = (Wnd.Width-HistCtrl.Width)/2
		  Top = Wnd.Height-20
		  
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
		rh As ReadHisto
	#tag EndProperty

	#tag Property, Flags = &h0
		tw As TextWindow
	#tag EndProperty


#tag EndWindowCode

#tag Events HistCtrl
	#tag Event
		Sub BAction(msg as string)
		  select case msg
		  case "First"
		    ReadHisto(CurrentContent.CurrentOperation).FirstOper
		  case "Prec"
		    ReadHisto(CurrentContent.CurrentOperation).PrecOper
		  case "BNext"
		    ReadHisto(CurrentContent.CurrentOperation).NextOper
		  case "Last"
		    ReadHisto(CurrentContent.CurrentOperation).LastOper
		  case "Stop"
		    ReadHisto(CurrentContent.CurrentOperation).Endoperation
		    self.close
		  end select
		  
		End Sub
	#tag EndEvent
	#tag Event
		Function KeyDown(Key As String) As Boolean
		  if asc(key) = 20 then
		    tw = new TextWindow
		    tw.visible = true
		  end if
		End Function
	#tag EndEvent
#tag EndEvents
