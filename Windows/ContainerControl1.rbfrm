#tag Window
Begin ContainerControl ContainerControl1
   AcceptFocus     =   ""
   AcceptTabs      =   ""
   AutoDeactivate  =   "True"
   ControlOrder    =   ""
   Enabled         =   "True"
   EraseBackground =   "True"
   Height          =   22
   HelpTag         =   ""
   InitialParent   =   ""
   Left            =   32
   LockBottom      =   ""
   LockLeft        =   ""
   LockRight       =   ""
   LockTop         =   ""
   TabPanelIndex   =   0
   Top             =   32
   UseFocusRing    =   ""
   Visible         =   "False"
   Width           =   600
   Begin BevelButton Stop
      AcceptFocus     =   "False"
      AutoDeactivate  =   "True"
      Bevel           =   0
      Bold            =   "False"
      ButtonType      =   0
      Caption         =   "Stop"
      CaptionAlign    =   3
      CaptionDelta    =   0
      CaptionPlacement=   1
      ControlOrder    =   0
      Enabled         =   True
      HasMenu         =   0
      Height          =   22
      HelpTag         =   ""
      Icon            =   ""
      IconAlign       =   0
      IconDX          =   0
      IconDY          =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   480
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      MenuValue       =   0
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   0
      Underline       =   "False"
      Value           =   "False"
      Visible         =   True
      Width           =   120
      BehaviorIndex   =   0
   End
   Begin BevelButton First
      AcceptFocus     =   "False"
      AutoDeactivate  =   "True"
      Bevel           =   0
      Bold            =   "False"
      ButtonType      =   0
      Caption         =   "First <<"
      CaptionAlign    =   3
      CaptionDelta    =   0
      CaptionPlacement=   1
      ControlOrder    =   1
      Enabled         =   True
      HasMenu         =   0
      Height          =   22
      HelpTag         =   "Première construction"
      Icon            =   ""
      IconAlign       =   0
      IconDX          =   0
      IconDY          =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   0
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      MenuValue       =   0
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   0
      Underline       =   "False"
      Value           =   "False"
      Visible         =   True
      Width           =   120
      BehaviorIndex   =   1
   End
   Begin BevelButton Prec
      AcceptFocus     =   "False"
      AutoDeactivate  =   "True"
      Bevel           =   0
      Bold            =   "False"
      ButtonType      =   0
      Caption         =   "Prec <"
      CaptionAlign    =   3
      CaptionDelta    =   0
      CaptionPlacement=   1
      ControlOrder    =   2
      Enabled         =   True
      HasMenu         =   0
      Height          =   22
      HelpTag         =   ""
      Icon            =   ""
      IconAlign       =   0
      IconDX          =   0
      IconDY          =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   120
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      MenuValue       =   0
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   0
      Underline       =   "False"
      Value           =   "False"
      Visible         =   True
      Width           =   120
      BehaviorIndex   =   2
   End
   Begin BevelButton BNext
      AcceptFocus     =   "False"
      AutoDeactivate  =   "True"
      Bevel           =   0
      Bold            =   "False"
      ButtonType      =   0
      Caption         =   "> Next"
      CaptionAlign    =   3
      CaptionDelta    =   0
      CaptionPlacement=   1
      ControlOrder    =   3
      Enabled         =   True
      HasMenu         =   0
      Height          =   22
      HelpTag         =   ""
      Icon            =   ""
      IconAlign       =   0
      IconDX          =   0
      IconDY          =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   240
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      MenuValue       =   0
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   0
      Underline       =   "False"
      Value           =   "False"
      Visible         =   True
      Width           =   120
      BehaviorIndex   =   3
   End
   Begin BevelButton Last
      AcceptFocus     =   "False"
      AutoDeactivate  =   "True"
      Bevel           =   0
      Bold            =   "False"
      ButtonType      =   0
      Caption         =   ">> Last "
      CaptionAlign    =   3
      CaptionDelta    =   0
      CaptionPlacement=   1
      ControlOrder    =   4
      Enabled         =   True
      HasMenu         =   0
      Height          =   22
      HelpTag         =   ""
      Icon            =   ""
      IconAlign       =   0
      IconDX          =   0
      IconDY          =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   "False"
      Left            =   360
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      MenuValue       =   0
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   0
      Underline       =   "False"
      Value           =   "False"
      Visible         =   True
      Width           =   120
      BehaviorIndex   =   4
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  width = 600
		  First.caption = Dico.value("HstFirst")
		  Prec.Caption = Dico.Value("HstPrec")
		  BNext.caption = Dico.value("HstNext")
		  Last.Caption = Dico.value("HstLast")
		  Stop.Caption=Dico.Value("HstStop")
		End Sub
	#tag EndEvent


	#tag Hook, Flags = &h0
		Event BAction(msg as string)
	#tag EndHook


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


#tag EndWindowCode

#tag Events Stop
	#tag Event
		Sub Action()
		  if dret = nil then
		    BAction(me.Name)
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events First
	#tag Event
		Sub Action()
		  BAction(me.name)
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseEnter()
		  dim EL as XMLElement
		  
		  if rh.noper > 1 then
		    EL = XMLElement(rh.Histo.Child(1))
		    me.HelpTag = Dico.value(EL.GetAttribute("Type"))
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Prec
	#tag Event
		Sub Action()
		  if dret = nil then
		    BAction(me.Name)
		  end if
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseEnter()
		  dim EL as XMLElement
		  
		  if rh.currentop > 1 then
		    EL = XMLElement(rh.Histo.Child(rh.currentop-1))
		    me.HelpTag = Dico.value(EL.GetAttribute("Type"))
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events BNext
	#tag Event
		Sub Action()
		  if dret = nil then
		    BAction(me.Name)
		  end if
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseEnter()
		  dim EL as XMLElement
		  
		  if rh.currentop < rh.noper-1 then
		    EL = XMLElement(rh.Histo.Child(rh.currentop+1))
		    me.HelpTag = "Operation nr "+ str(rh.currentop+1) + " "+ Dico.value(EL.GetAttribute("Type"))
		  else
		    me.HelpTag = Dico.value("End_of_file")
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Last
	#tag Event
		Sub Action()
		  if dret = nil then
		    BAction(me.Name)
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
