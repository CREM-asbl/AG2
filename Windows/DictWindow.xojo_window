#tag DesktopWindow
Begin DesktopWindow DictWindow
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF00
   Composite       =   True
   DefaultLocation =   1
   FullScreen      =   False
   HasBackgroundColor=   True
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   False
   HasMinimizeButton=   True
   Height          =   607
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   -1100719104
   MenuBarVisible  =   True
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "Créer ou modifier un dictionnaire"
   Type            =   1
   Visible         =   True
   Width           =   822
   Begin DesktopListBox ListBox1
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   True
      AllowExpandableRows=   False
      AllowFocusRing  =   True
      AllowResizableColumns=   False
      AllowRowDragging=   False
      AllowRowReordering=   False
      AutoDeactivate  =   "True"
      AutoHideScrollbars=   "True"
      Bold            =   False
      Border          =   "True"
      ColumnCount     =   1
      ColumnsResizable=   "True"
      ColumnWidths    =   ""
      DefaultRowHeight=   -1
      DropIndicatorVisible=   False
      Enabled         =   True
      EnableDrag      =   "False"
      EnableDragReorder=   "False"
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      GridLineStyle   =   0
      HasBorder       =   True
      HasHeader       =   False
      HasHeading      =   "True"
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      HeadingIndex    =   0
      Height          =   693
      HelpTag         =   ""
      Hierarchical    =   "False"
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   False
      Left            =   1
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   False
      LockTop         =   False
      RequiresSelection=   False
      RowSelectionType=   0
      Scope           =   0
      ScrollbarHorizontal=   "False"
      ScrollBarVertical=   "True"
      SelectionType   =   "1"
      ShowDropIndicator=   "False"
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "Arial"
      TextSize        =   "12.0"
      TextUnit        =   "0"
      Tooltip         =   ""
      Top             =   1
      Transparent     =   False
      Underline       =   False
      UseFocusRing    =   "False"
      Visible         =   True
      Width           =   819
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub MenuBarSelected()
		  chargerdict.enabled = true
		  creerdict.enabled = enablecreer
		  findict.enabled = true
		  SauverDict.enabled = enablecreer
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  return false
		End Function
	#tag EndEvent

	#tag Event
		Sub Opening()
		  Title = Dico.value("NewDictWindow")
		  Listbox1.width = width
		  Listbox1.height = height
		  Listbox1.HeaderAt(0) = Dico.value("Code")
		  ndict = 0
		  
		  ChargerLangRef(config.langue)
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  Listbox1.width = width
		  Listbox1.height = height
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function ChargerDict() As Boolean Handles ChargerDict.Action
		  
		  dim n as integer
		  
		  LanguageWindow.showmodal
		  Lang = Languagewindow.langue
		  LanguageWindow.Close
		  
		  if language.indexof(lang)= -1 then  //on ne recharge pas un dictionnaire déjà chargé
		    ndict = ndict+1
		    Language.append Lang
		    ListBox1.ColumnCount = ListBox1.ColumnCount + 1
		    Listbox1.headerAt(ndict) = Language(ndict-1)
		    ChargerLang(Lang)
		  end if
		  return false
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function CreerDict() As Boolean Handles CreerDict.Action
		  if NewLanguage then
		    ListBox1.ColumnCount = ListBox1.ColumnCount + 1
		    ndict = ndict+1
		    ListBox1.HeaderAt(ndict) = Language(ndict-1)
		  end if
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FinDict() As Boolean Handles FinDict.Action
		  self.close
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ModifDict() As Boolean Handles ModifDict.Action
		  ListBox1.setfocus
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function SauverDict() As Boolean Handles SauverDict.Action
		  dim Doc as new XMLDocument
		  dim Langue, EL, EL1 as XMLnode
		  dim fi as folderitem
		  dim tos as TextOutputStream
		  dim i, n as integer
		  dim msg as MessageDialog
		  dim but as MessageDialogButton
		  
		  msg = new MessageDialog
		  msg.Message = Dico.Value("ClickInTheColumnToSave")
		  msg.AlternateActionButton.visible = true
		  msg.AlternateActionButton.Caption = Dico.Value("Cancel")
		  but = msg.ShowModal
		  if but <> msg.ActionButton then
		    return false
		  end if
		  
		  Dim DctType as New FileType
		  DctType.Name = "dictionnaire"
		  DctType.MacType = "DCT"
		  DctType.Extensions = "dct"
		  
		  Dim dlg as New SaveAsDialog
		  n = Listbox1.RowCount
		  Doc = new XMLDocument
		  Doc.Preservewhitespace = true
		  
		  if colonne = 0 then
		    MsgBox Dico.value("messdico2")
		    return false
		  end if
		  Langue = Doc.AppendChild(Doc.CreateElement(Language(colonne-1)))
		  
		  for i = 0 to n-1
		    if ListBox1.CellTextAt(i,1) = "" or ListBox1.CellTextAt(i,1) = " " then
		      EL = Langue.AppendChild(Doc.CreateElement(ListBox1.CellTextAt(i,0)))
		    else
		      EL1 = Doc.CreateElement(ListBox1.CellTextAt(i,0))
		      if ListBox1.CellTextAt(i,colonne) <> "" and ListBox1.CellTextAt(i,colonne) <> " " then
		        EL1.SetAttribute("Name",ListBox1.CellTextAt(i,colonne))
		      else
		        EL1.SetAttribute("Name","---")
		      end if
		      EL.AppendChild EL1
		    end if
		  next
		  
		  if Language(colonne-1) = "Francais" or Language(colonne-1) = "English" then
		    dlg.InitialDirectory = app.appfolder
		  else
		    dlg.InitialDirectory=app.Dctfolder
		  end if
		  dlg.promptText=""
		  dlg.SuggestedFileName=Language(colonne-1)+".dct"
		  dlg.Title= ""
		  dlg.filter=DctType
		  
		  fi=dlg.ShowModal()
		  If fi <> Nil then
		    tos=fi.CreateTextFile
		    tos.write(Doc.ToString)
		    tos.close
		    return true
		  Else
		    return false
		  End if
		  
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h0
		Sub ChargerLang(lang as string)
		  dim List as XmlNodeList
		  dim EL, EL1 as XMLNode
		  dim EL2 as XMLElement
		  dim Key as variant
		  dim  Txt as string
		  dim i,j,k as integer
		  
		  EL = Dico.getXML(lang)
		  if EL = nil then
		    return
		  end if
		  
		  j = 0
		  for i = 0 to  EL.ChildCount -1
		    j = j+1
		    EL1 = EL.Child(i)
		    while j < Listbox1.RowCount and  listbox1.CellTextAt(j,1) <> "" and listbox1.CellTextAt(j,1) <> " "
		      Key = listbox1.CellTextAt(j,0)
		      List = EL1.XQL(Key)
		      if List.length > 0 then
		        EL2 = XMLElement(List.item(0))
		        Txt = EL2.GetAttribute("Name")
		        if txt = "---" then
		          txt = ""
		        end if
		        listbox1.CellTextAt(j,ndict) = Txt
		      end if
		      j = j+1
		    wend
		    
		  next
		  refresh
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChargerLangRef(lang as string)
		  dim EL, EL1 as XMLNode
		  dim EL2 as XMLElement
		  dim Name,Key as String
		  dim  Txt as string
		  dim i,j,k as integer
		  
		  
		  EL = Dico.getXML(lang)
		  
		  if EL = nil then
		    return
		  end if
		  
		  Language.Append  EL.Name
		  ListBox1.ColumnCount = ListBox1.ColumnCount + 1
		  ndict = ndict+1
		  Listbox1.headerAt(ndict) = Language(ndict-1)
		  
		  j=0
		  EL1 = EL.FirstChild
		  for i = 0 to  EL.ChildCount -1
		    if ndict = 1 then
		      listbox1.AddExpandableRow(EL1.name)
		      ListBox1.CellAlignmentAt(j,0) = DesktopListBox.Alignments.Center
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
		      listbox1.CellTextAt(j,ndict) = Txt
		      j = j+1
		      EL2= XMLElement(EL2.NextSibling)
		    next
		    EL1 = XMLElement(EL1.NextSibling)
		  next
		  refresh
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Enablecreer() As Boolean
		  return ndict > 0
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
		Protected Function oldGetSelect() As integer
		  dim i, n as integer
		  
		  if ListBox1.SelectedRowCount = 1 then
		    n = ListBox1.RowCount
		    for i = 0 to n-1
		      if Listbox1.RowSelectedAt(i) then
		        return i
		      end if
		    next
		  else
		    return  -1
		  end if
		  
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
		Protected Colonne As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		lang As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Language() As string
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected ndict As integer
	#tag EndProperty


#tag EndWindowCode

#tag Events ListBox1
	#tag Event
		Function ColumnSorted(column As Integer) As Boolean
		  return true
		End Function
	#tag EndEvent
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  return false
		End Function
	#tag EndEvent
	#tag Event
		Function CellPressed(row As Integer, column As Integer, x As Integer, y As Integer) As Boolean
		  if column>0 then
		    me.EditCellAt(row,column)
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
		Sub Opening()
		  dim i, n as integer
		  dim k as string
		  
		  me.HasVerticalScrollbar = true
		  me.HasHeader = true
		  me.setfocus
		  me.ColumnAlignmentAt(0) = DesktopListBox.Alignments.Left
		  me.RowSelectionType = DesktopListBox.RowSelectionTypes.Single
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
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
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Locations"
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
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=false
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="lang"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="string"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
