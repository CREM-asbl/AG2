#tag Window
Begin Window LabelWindow
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   False
   Compatibility   =   ""
   Composite       =   True
   Frame           =   1
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   True
   Height          =   131
   ImplicitInstance=   False
   LiveResize      =   False
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   0
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   False
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   False
   Title           =   "Nommer"
   Visible         =   True
   Width           =   614
   Begin TextField Text
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFF00FF
      Bold            =   False
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   54
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   13
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   547
   End
   Begin ComboBox Size
      AutoComplete    =   False
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "10\r\n11\r\n12\r\n13\r\n14\r\n15\r\n16\r\n17\r\n18\r\n19\r\n20\r\n21\r\n22\r\n23\r\n24\r\n25\r\n26\r\n27\r\n28\r\n29\r\n30"
      Italic          =   False
      Left            =   54
      ListIndex       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   49
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   45
   End
   Begin CheckBox Italic
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Italique"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   444
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      State           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   48
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   60
   End
   Begin PushButton submit
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "OK"
      Default         =   False
      Enabled         =   True
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   261
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   77
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin Label Txt
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   12
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Texte :"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   13
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   36
   End
   Begin Label TxtSize
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   12
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Taille :"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   49
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   36
   End
   Begin Rectangle RecColor
      AutoDeactivate  =   False
      BorderWidth     =   1
      BottomRightColor=   &c00000000
      Enabled         =   True
      FillColor       =   &cFFFF00FF
      Height          =   21
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   170
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   49
      TopLeftColor    =   &c00000000
      Visible         =   True
      Width           =   20
   End
   Begin Label TxtColor
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   111
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Couleur :"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   49
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   47
   End
   Begin Label TxtX
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   12
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Axe X :"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   81
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   36
   End
   Begin Label TxtY
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   128
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Axe Y :"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   81
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   45
   End
   Begin TextField CoordX
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFF00FF
      Bold            =   False
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   60
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   81
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   29
   End
   Begin TextField CoordY
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFF00FF
      Bold            =   False
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   170
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   11
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   81
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   29
   End
   Begin UpDownArrows UpDownArrows1
      AcceptFocus     =   False
      AutoDeactivate  =   True
      Enabled         =   True
      Height          =   23
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   92
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   81
      Visible         =   True
      Width           =   13
   End
   Begin UpDownArrows UpDownArrows2
      AcceptFocus     =   False
      AutoDeactivate  =   True
      Enabled         =   True
      Height          =   23
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   202
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   80
      Visible         =   True
      Width           =   13
   End
   Begin PushButton Cancel
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "Cancel"
      Default         =   False
      Enabled         =   True
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   346
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   14
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   82
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin Label Pol
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   209
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   15
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Police :"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   49
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   40
   End
   Begin ListBox Polices
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   False
      Border          =   True
      ColumnCount     =   1
      ColumnsResizable=   False
      ColumnWidths    =   ""
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   -1
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   False
      HeadingIndex    =   -1
      Height          =   20
      HelpTag         =   ""
      Hierarchical    =   False
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   False
      Left            =   254
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      RequiresSelection=   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollBarVertical=   True
      SelectionType   =   0
      TabIndex        =   16
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   49
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   172
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin PushButton Delete
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "Delete"
      Default         =   False
      Enabled         =   True
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   444
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      TabIndex        =   17
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   82
      Underline       =   False
      Visible         =   False
      Width           =   80
   End
   Begin CheckBox Fixe
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Fixe"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   516
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      Scope           =   0
      State           =   0
      TabIndex        =   18
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   48
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   78
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Close()
		  sizelabel = val(size.text)
		  wnd.setfocus
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  dim i as integer
		  
		  addlab =  addlabel(CurrentContent.CurrentOperation)
		  drapnew = addlab.drapnew
		  Lab = addlab.lab
		  Title = Dico.value("Nommer")
		  Txt.Text = Dico.value("Name")+" : "
		  Text.Text = lab.Text
		  Pol.Text = Dico.value("Font")+ " :"
		  TxtSize.Text = Dico.value("Size")+" : "
		  size.Text = str(lab.Textsize)
		  TxtColor.Text = Dico.value("Color")+" : "
		  RecColor.FillColor = Lab.TextColor
		  Italic.caption = " "+Dico.value("Italic")
		  'Italic.setBoolean(lab.TextFont)
		  Fixe.Caption = Dico.value("Fixe")
		  corr = can.dtransform(lab.correction)
		  CoordX.text =str(corr.X)
		  CoordY.text = str(- corr.y)
		  if drapnew then
		    Delete.visible = false
		    for i = 0 to Polices.ListCount-1
		      if Polices.List(i) = "Times New Roman" then
		        Polices.ListIndex = i
		      end if
		    next
		  else
		    for i = 0 to Polices.ListCount-1
		      if Polices.List(i)  = Lab.TextFont then
		        Polices.ListIndex = i
		      end if
		    next
		    delete.visible = true
		  end if
		  if lab <> nil then
		    fixe.value = lab.fixe
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


	#tag Property, Flags = &h0
		addlab As AddLabel
	#tag EndProperty

	#tag Property, Flags = &h0
		corr As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		drapnew As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Lab As Etiq
	#tag EndProperty


#tag EndWindowCode

#tag Events Text
	#tag Event
		Sub TextChange()
		  dim n as integer
		  dim s as string
		  dim k as Byte
		  
		  s = me.Text
		  n = s.len
		  k = asc(right(s,1))
		  if k < 32 or k = 127 then
		    s = left(s,n-1)
		    me.Text = s
		  end if
		  
		  
		  Lab.Text = me.Text
		  Wnd.Refresh
		  
		End Sub
	#tag EndEvent
	#tag Event
		Function KeyDown(Key As String) As Boolean
		  if asc(Key) = 13 then
		    self.close
		  end if
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events Size
	#tag Event
		Sub Change()
		  dim n as integer
		  
		  n = val(me.text)
		  lab.SetSize(n)
		  'lab.taille = n
		  Wnd.Refresh
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.text = str(sizelabel)
		End Sub
	#tag EndEvent
	#tag Event
		Sub TextChanged()
		  sizelabel = val(me.text)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Italic
	#tag Event
		Sub Action()
		  lab.SetItalic(me.Value)
		  Wnd.Refresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events submit
	#tag Event
		Sub Action()
		  self.close()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events RecColor
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  dim col as color
		  if selectcolor(col,"Choisis une couleur") then
		    RecColor.FillColor = col
		    lab.SetColor( col)
		  end if
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events UpDownArrows1
	#tag Event
		Sub Down()
		  CoordX.Text = str(val(CoordX.Text)-1)
		  Corr.X = val(CoordX.text)
		  lab.correction = can.idtransform(corr)
		  can.Refreshbackground
		End Sub
	#tag EndEvent
	#tag Event
		Sub Up()
		  CoordX.Text = str(val(CoordX.Text)+1)
		  Corr.X = val(CoordX.text)
		  lab.correction = can.idtransform(corr)
		  can.Refreshbackground
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events UpDownArrows2
	#tag Event
		Sub Down()
		  CoordY.Text = str(val(CoordY.Text)-1)
		  Corr.Y = - val(CoordY.text)
		  lab.correction = can.idtransform(corr)
		  can.RefreshBackground
		End Sub
	#tag EndEvent
	#tag Event
		Sub Up()
		  CoordY.Text = str(val(CoordY.Text)+1)
		  Corr.Y = - val(CoordY.text)
		  lab.correction = can.idtransform(corr)
		  can.RefreshBackground
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Cancel
	#tag Event
		Sub Action()
		  dim OldLab as Etiq
		  
		  OldLab = AddLab.OldLabel
		  
		  If OldLab <> nil then
		    Lab.Text = OldLab.Text
		    Lab.TextColor = OldLab.TextColor
		    Lab.Textsize = OldLab.Textsize
		    Lab.TextFont = OldLab.TextFont
		    Lab.fixe = OldLab.fixe
		    Lab.Correction = OldLab.Correction
		  else
		    Lab.Text =""
		  end if
		  
		  self.close()
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.caption = Dico.value("Cancel")
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Polices
	#tag Event
		Sub Open()
		  dim i, k, n as integer
		  
		  n= FontCount-1
		  For i=1 to n
		    If Font(i)="Arial"  or Font(i) = "Courier New" or Font(i) = "Times New Roman"  or Font(i) = "Symbol" Then
		      me.AddRow Font(i)
		    end if
		  Next
		  
		  'i = 0
		  'while me.List(i) <> "Times New Roman" and i < me.listcount
		  'i = i+1
		  'wend
		  'if i < me.listcount then
		  'me.removerow i
		  'me.InsertRow 0, "Times New Roman"
		  'end if
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Change()
		  Lab.Textfont = me.text
		  wnd.refresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Delete
	#tag Event
		Sub Open()
		  me.caption = Dico.value("Delete")
		End Sub
	#tag EndEvent
	#tag Event
		Sub Action()
		  lab.text = ""
		  lab.chape.labs.removeobject(lab)
		  self.close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Fixe
	#tag Event
		Sub Action()
		  lab.setfixe(me.value)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="BackColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		Type="Picture"
		EditorType="Picture"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="drapnew"
		Group="Behavior"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Frame"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LiveResize"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		Type="MenuBar"
		EditorType="MenuBar"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Placement"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
	#tag EndViewProperty
#tag EndViewBehavior
