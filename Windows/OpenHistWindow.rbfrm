#tag Window
Begin Window OpenHistWindow
   BackColor       =   16777215
   Backdrop        =   ""
   BalloonHelp     =   ""
   CloseButton     =   "False"
   Composite       =   "False"
   Frame           =   2
   FullScreen      =   "False"
   HasBackColor    =   "True"
   Height          =   334
   ImplicitInstance=   "True"
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   "False"
   MaxWidth        =   32000
   MenuBar         =   ""
   MenuBarVisible  =   "True"
   MinHeight       =   64
   MinimizeButton  =   "False"
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   "True"
   Title           =   "Sans_titre"
   Visible         =   "True"
   Width           =   434
   Begin ListBox ListFiles
      AutoDeactivate  =   "True"
      AutoHideScrollbars=   "True"
      Bold            =   "True"
      ColumnCount     =   3
      ColumnsResizable=   "False"
      ColumnWidths    =   "100,100,150"
      ControlOrder    =   0
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   -1
      Enabled         =   "True"
      EnableDrag      =   ""
      EnableDragReorder=   "True"
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   "False"
      HeadingIndex    =   -1
      Height          =   280
      HelpTag         =   ""
      Hierarchical    =   "True"
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   ""
      Left            =   35
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      RequiresSelection=   "True"
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollBarVertical=   "True"
      SelectionType   =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   14
      Underline       =   ""
      UseFocusRing    =   "True"
      Visible         =   "True"
      Width           =   350
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
      BehaviorIndex   =   0
   End
   Begin PushButton ActionB
      AutoDeactivate  =   "True"
      Bold            =   ""
      Cancel          =   ""
      Caption         =   "OK"
      ControlOrder    =   1
      Default         =   ""
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   92
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   298
      Underline       =   ""
      Visible         =   "True"
      Width           =   80
      BehaviorIndex   =   1
   End
   Begin PushButton Cancel
      AutoDeactivate  =   "True"
      Bold            =   ""
      Cancel          =   ""
      Caption         =   "Annuler"
      ControlOrder    =   2
      Default         =   ""
      Enabled         =   "True"
      Height          =   28
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   256
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   298
      Underline       =   ""
      Visible         =   "True"
      Width           =   80
      BehaviorIndex   =   2
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub SetList(dir As folderItem, row as integer)
		  dim i as integer
		  
		  if dir <> nil and dir.Directory then
		    for i=1 to dir.Count
		      if dir.item(i).Directory then
		        ListFiles.AddFolder(dir.item(i).name)
		      elseif dir.Item(i).Type = "HIST" then
		        ListFiles.AddRow(dir.item(i).name)
		      end if
		      ListFiles.cell(row+i,1)=dir.item(i).AbsolutePath
		    next
		  end if
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
		file As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		Dir As folderItem
	#tag EndProperty


#tag EndWindowCode

#tag Events ListFiles
	#tag Event
		Sub Open()
		  Title = Dico.Value("Chooseafile")
		  
		  me.ColumnCount = 2
		  me.ColumnWidths = str(me.Width)+",0"
		  
		  Dir = App.DocFolder.Child("Historiques")
		  if not dir.Exists then
		    Dir = SelectFolder
		  end if
		  
		  Dir = Dir.Child(Config.username)
		  
		  SetList(Dir,-1)
		  
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Change()
		  file = GetFolderItem(me.cell(me.ListIndex,1))
		  if file.Directory then
		    file =nil
		  end if
		End Sub
	#tag EndEvent
	#tag Event
		Sub ExpandRow(row As Integer)
		  SetList(GetFolderItem(me.cell(row,1)),row)
		End Sub
	#tag EndEvent
	#tag Event
		Sub DoubleClick()
		  if file <> nil then
		    close
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ActionB
	#tag Event
		Sub Action()
		  if file <> nil then
		    close
		  else
		    MsgBox Dico.value ("Chooseafile")
		  end if
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.caption = Dico.value("FileOpen")
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Cancel
	#tag Event
		Sub Action()
		  file = nil
		  Close
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  if Config.username ="Enseignant" then
		    me.caption = Dico.value("FileClose")
		  else
		    me.caption = Dico.value("cancel")
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
