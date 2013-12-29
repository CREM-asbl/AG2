#tag Window
Begin Window DictWindow
   BackColor       =   16777215
   Backdrop        =   0
   BalloonHelp     =   ""
   CloseButton     =   "True"
   Composite       =   "True"
   Frame           =   1
   FullScreen      =   "False"
   HasBackColor    =   "True"
   Height          =   607
   ImplicitInstance=   "True"
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   "False"
   MaxWidth        =   32000
   MenuBar         =   -1100719104
   MenuBarVisible  =   "True"
   MinHeight       =   64
   MinimizeButton  =   "True"
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   "True"
   Title           =   "Créer ou modifier un dictionnaire"
   Visible         =   "True"
   Width           =   822
   Begin ListBox ListBox1
      AutoDeactivate  =   "True"
      AutoHideScrollbars=   "True"
      Bold            =   "False"
      ColumnCount     =   1
      ColumnsResizable=   "True"
      ColumnWidths    =   ""
      ControlOrder    =   0
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   -1
      Enabled         =   "True"
      EnableDrag      =   "False"
      EnableDragReorder=   "False"
      GridLinesHorizontal=   3
      GridLinesVertical=   3
      HasHeading      =   "True"
      HeadingIndex    =   0
      Height          =   693
      HelpTag         =   ""
      Hierarchical    =   "False"
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   "False"
      Left            =   1
      LockBottom      =   "False"
      LockLeft        =   "False"
      LockRight       =   "False"
      LockTop         =   "False"
      RequiresSelection=   ""
      Scope           =   0
      ScrollbarHorizontal=   "False"
      ScrollBarVertical=   "True"
      SelectionType   =   1
      TabPanelIndex   =   0
      TextFont        =   "Arial"
      TextSize        =   12
      Top             =   1
      Underline       =   "False"
      UseFocusRing    =   "False"
      Visible         =   "True"
      Width           =   819
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
      BehaviorIndex   =   0
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub EnableMenuItems()
		  chargerdict.enable
		  creerdict.enabled=enablecreer
		  findict.enable
		  modifdict.enabled=enablecreer
		  SauverDict.enabled=enablecreer
		  'LignesInserer.enabled=enablecreer
		  'Lignessupprimer.enabled=enablecreer
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  return false
		End Function
	#tag EndEvent

	#tag Event
		Sub Resized()
		  Listbox1.width = width
		  Listbox1.height = height
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  Title = Dico.value("NewDictWindow")
		  Listbox1.width = width
		  Listbox1.height = height
		  Listbox1.heading(0) = Dico.value("Code")
		  ndict = 0
		  
		End Sub
	#tag EndEvent


#tag MenuHandler
		Function ChargerDict() As Boolean Handles ChargerDict.Action
			dim Doc as XMLDocument
			dim EL, EL1 as XMLNode
			dim EL2 as XMLElement
			dim Key as variant
			dim  Txt as string
			dim i,j,k as integer
			
			Dim DctType as New FileType
			DctType.Name = "dictionnaire"
			DctType.MacType = "DCT"
			DctType.Extensions = "dct"
			
			dim f as folderitem
			Dim dlg as OpenDialog
			
			
			dlg=New OpenDialog
			dlg.InitialDirectory=app.appfolder
			dlg.Title= ""
			dlg.Filter=DctType
			f=dlg.ShowModal()
			
			If f = Nil then
			return true
			end if
			ListBox1.ColumnCount = ListBox1.ColumnCount + 1
			ndict = ndict+1
			Dict.Append new Dictionnaire
			
			Doc=new XMLDocument(f)
			EL = Doc.DocumentElement
			Language.Append  EL.Name
			Listbox1.heading(ndict) = Language(ndict-1)
			
			j=0
			EL1 = EL.FirstChild
			for i = 0 to  EL.ChildCount -1
			if ndict = 1 then
			listbox1.addfolder(EL1.name)
			ListBox1.cellalignment(j,0)=ListBox.AlignCenter
			end if
			j = j+1
			EL2 = XMLElement(EL1.FirstChild)
			for k = 0 to EL1.Childcount -1
			Key = EL2.Name
			Txt = EL2.GetAttribute("Name")
			if txt = "---" then
			txt = ""
			end if
			if ndict = 1 then
			listbox1.addrow Key
			end if
			listbox1.cell(j,ndict) = Txt
			j = j+1
			EL2= XMLElement(EL2.NextSibling)
			next
			EL1 = XMLElement(EL1.NextSibling)
			next
			refresh
			return false
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function ModifDict() As Boolean Handles ModifDict.Action
			ListBox1.setfocus
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function CreerDict() As Boolean Handles CreerDict.Action
			if NewLanguage then
			ListBox1.ColumnCount = ListBox1.ColumnCount + 1
			ndict = ndict+1
			ListBox1.Heading(ndict) = Language(ndict-1)
			end if
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function FinDict() As Boolean Handles FinDict.Action
			self.close
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function LignesInserer() As Boolean Handles LignesInserer.Action
			dim r as integer
			
			r = GetSelect
			if r <> -1 then
			ListBox1.Insertrow  (r+1, " ")
			ListBox1.Editcell(r+1,0)
			end if
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function LignesSupprimer() As Boolean Handles LignesSupprimer.Action
			dim r as integer
			
			r = GetSelect
			if r <> -1 then
			ListBox1.RemoveRow  (r)
			end if
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function SauverDict() As Boolean Handles SauverDict.Action
			dim Doc as new XMLDocument
			dim Langue, EL, EL1 as XMLnode
			dim fi as folderitem
			dim tos as TextOutputStream
			dim i, n as integer
			
			Dim DctType as New FileType
			DctType.Name = "dictionnaire"
			DctType.MacType = "DCT"
			DctType.Extensions = "dct"
			
			Dim dlg as New SaveAsDialog
			n = Listbox1.Listcount
			Doc = new XMLDocument
			Doc.Preservewhitespace = true
			
			if colonne = 0 then
			MsgBox Dico.value("messdico2")
			return false
			end if
			Langue = Doc.AppendChild(Doc.CreateElement(Language(colonne-1)))
			
			for i = 0 to n-1
			if ListBox1.Cell(i,1) = "" or ListBox1.Cell(i,1) = " " then
			EL = Langue.AppendChild(Doc.CreateElement(ListBox1.Cell(i,0)))
			else
			EL1 = Doc.CreateElement(ListBox1.Cell(i,0))
			if ListBox1.Cell(i,colonne) <> "" and ListBox1.Cell(i,colonne) <> " " then
			EL1.SetAttribute("Name",ListBox1.Cell(i,colonne))
			else
			EL1.SetAttribute("Name","---")
			end if
			EL.AppendChild EL1
			end if
			next
			
			dlg.InitialDirectory=app.appfolder
			dlg.promptText=""
			dlg.SuggestedFileName=Language(colonne-1)+".dct"
			dlg.Title= ""
			dlg.filter=DctType
			
			fi=dlg.ShowModal()
			If fi <> Nil then
			tos=fi.CreateTextFile
			tos.write(Doc.ToString)
			tos.close
			n = InStr(fi.Name,".")
			Dico.load(Left(fi.name,n-1))
			return true
			Else
			return false
			End if
			
		End Function
#tag EndMenuHandler


	#tag Method, Flags = &h1
		Protected Function GetSelect() As integer
		  dim i, n as integer
		  
		  if ListBox1.selcount = 1 then
		    n = ListBox1.ListCount
		    for i = 0 to n-1
		      if Listbox1.Selected(i) then
		        return i
		      end if
		    next
		  else
		    return  -1
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function NewLanguage() As boolean
		  dim nlw As NewLanguageWindow
		  dim ok as Boolean
		  
		  nlw = new NewLanguageWindow
		  nlw.ShowModal
		  if nlw.Result<>-1 then
		    Language.append nlw.EditField1.Text
		    ok = true
		  end if
		  nlw.close
		  
		  return ok
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Enablecreer() As Boolean
		  return ndict > 0
		End Function
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


	#tag Property, Flags = &h1
		Protected Language() As string
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected ndict As integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Colonne As integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Dict(-1) As Dictionnaire
	#tag EndProperty


#tag EndWindowCode

#tag Events ListBox1
	#tag Event
		Function SortColumn(column As Integer) As Boolean
		  return true
		End Function
	#tag EndEvent
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  return false
		End Function
	#tag EndEvent
	#tag Event
		Function CellClick(row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  if column>0 then
		    me.EditCell(row,column)
		    self.colonne = column
		  end if
		  return false
		End Function
	#tag EndEvent
	#tag Event
		Function HeaderPressed(column as Integer) As Boolean
		  self.colonne = column
		  return true
		End Function
	#tag EndEvent
	#tag Event
		Sub Open()
		  dim i, n as integer
		  dim k as string
		  
		  me.scrollbarvertical = true
		  me.hasheading = true
		  me.setfocus
		  me.columnalignment(0)= ListBox.AlignLeft
		  me.SelectionType = ListBox.SelectionSingle
		End Sub
	#tag EndEvent
#tag EndEvents
