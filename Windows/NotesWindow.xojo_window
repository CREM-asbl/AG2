#tag DesktopWindow
Begin DesktopWindow NotesWindow
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF00
   Composite       =   False
   DefaultLocation =   1
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   600
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   1246849023
   MenuBarVisible  =   True
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "Notes"
   Type            =   0
   Visible         =   False
   Width           =   625
   Begin TextArea EF
      AcceptTabs      =   True
      Alignment       =   0
      AutoDeactivate  =   False
      AutomaticallyCheckSpelling=   True
      BackColor       =   &c00FFFFFF
      Bold            =   False
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   600
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   0
      LimitText       =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollbarVertical=   True
      Styled          =   True
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "MS Sans Serif"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   0
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   0
      UseFocusRing    =   True
      Visible         =   True
      Width           =   625
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Function CancelClosing(appQuitting As Boolean) As Boolean
		  dim conf as Confirmation
		  dim n as integer
		  
		  
		  
		  if appquitting then
		    conf = new Confirmation("Save Notes ?")
		    
		    conf.ShowModal
		    select case Conf.result
		    case -1
		      conf.close
		      return true
		    case 0
		      conf.close
		      return false
		    case 1
		      Save
		      conf.close
		      return false
		    end
		  end if
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Opening()
		  
		  Dim m as MenuItem
		  Dim i,n as Integer
		  
		  SetMenu
		  Title = Dico.Value("Notes")
		  
		  if FontMenu.count = 1 then
		    n= FontCount-1
		    FontFontName(0).Text = "System"
		    nf = 0
		    For i=0 to n
		      If Font(i)="Arial"  or Font(i) = "Courier New" or Font(i) = "Times New Roman"  or Font(i) = "Symbol" Then
		        nf = nf+1
		        FontMenu.AddMenu(New MenuItem)
		        FontMenu.MenuAt(nf).index = nf
		        FontMenu.MenuAt(nf).Name= "FontFontName"
		        FontMenu.MenuAt(nf).Text =  Font(i)
		      end if
		    Next
		  end if
		  
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  Refresh
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resizing()
		  EF.width = self.width-10
		  EF.height = self.height-10
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function CentrerMenu() As Boolean Handles CentrerMenu.Action
		  EF.Selalignment = 2
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function Charmap() As Boolean Handles Charmap.Action
		  dim s as shell
		  s = new shell
		  s.Execute "%SystemRoot%\System32\charmap.exe"
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function Col(index as Integer) As Boolean Handles Col.Action
		  select case index
		  case 0
		    EF.StyledText.TextColor(EF.SelStart,  EF.SelLength ) = RGB(255,0,0)
		  case 1
		    EF.StyledText.TextColor(EF.SelStart,  EF.SelLength ) = RGB(0,255,0)
		  case 2
		    EF.StyledText.TextColor(EF.SelStart,  EF.SelLength ) = RGB(0,0,255)
		  case 3
		    EF.StyledText.TextColor(EF.SelStart,  EF.SelLength ) = RGB(0,0,0)
		  end select
		  
		  
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DroiteMenu() As Boolean Handles DroiteMenu.Action
		  EF.Selalignment = 3
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditColler() As Boolean Handles EditColler.Action
		  EF.Paste
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditCopier() As Boolean Handles EditCopier.Action
		  EF.Copy
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileClose() As Boolean Handles FileClose.Action
		  close
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileOpen() As Boolean Handles FileOpen.Action
		  dim f as folderitem
		  dim t as textinputstream 
		  dim st as new StyledText
		  
		  
		  
		  
		  f =GetOpenFolderItem("Rtf")
		  if f <> nil then
		    title = f.name
		    t = TextInputStream.Open(f)
		    if t <> nil then
		      St.RTFData = t.ReadAll
		      EF.StyledText.Text = st.Text
		    end if
		  else 
		    MsgBox Dico.value("MsgNoValidFile")
		  end if
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FilePrint() As Boolean Handles FilePrint.Action
		  Dim stp as StyledTextPrinter
		  Dim g as Graphics
		  
		  g= OpenPrinterDialog()
		  If g <> Nil then
		    stp=EF.StyledTextPrinter(g,72*7.5)
		    stp.DrawBlock 14,14,72*10
		  End if
		  
		  
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileSave() As Boolean Handles FileSave.Action
		  Save
		  
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FontFontName(index as Integer) As Boolean Handles FontFontName.Action
		  EF.StyledText.Font(EF.SelStart,  EF.SelLength) =  FontFontName(Index).Text
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function GaucheMenu() As Boolean Handles GaucheMenu.Action
		  EF.Selalignment = 1
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function GrasMenu() As Boolean Handles GrasMenu.Action
		  
		  
		  EF.StyledText.Bold(EF.SelStart,  EF.SelLength ) = true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ItaliqueMenu() As Boolean Handles ItaliqueMenu.Action
		  EF.StyledText.Italic (EF.SelStart,  EF.SelLength ) = true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function NormalMenu() As Boolean Handles NormalMenu.Action
		  EF.StyledText.Bold(EF.SelStart,  EF.SelLength ) = false
		  EF.StyledText.Italic(EF.SelStart,  EF.SelLength ) = false
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function TItem(index as Integer) As Boolean Handles TItem.Action
		  select case index
		  case 0
		    EF.StyledText.Size (EF.SelStart,  EF.SelLength ) = 12
		  case 1
		    EF.StyledText.Size (EF.SelStart,  EF.SelLength ) = 16
		  case 2
		    EF.StyledText.Size (EF.SelStart,  EF.SelLength ) = 20
		  case 3
		    EF.StyledText.Size (EF.SelStart,  EF.SelLength ) = 25
		  end select
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h0
		Sub Save()
		  dim nomfich as string
		  dim n as integer
		  
		  if currentcontent.currentoperation isa choosefinal then
		    currentcontent.Mac.Expli =  EF.text
		    return
		  end if
		  
		  if title = "" then
		    nomfich= Dico.value("Notes.rtf")
		  else
		    n = instr(title,".")
		    if n <>0 then
		      nomfich = left(title,n-1)+".rtf"
		    else
		      nomfich = title+".rtf"
		    end if
		  end if
		  dim f as FolderItem= GetSaveFolderItem(FileAGTypes.Rtf, nomfich)
		  if f <> nil then
		    Dim s as TextOutputStream=TextOutputStream.Create(f)
		    s.Write EF.StyledText.RTFData
		    s = nil
		  end if
		  
		  Exception err
		    err.message = err.message+CurrentMethodName+EndOfLine+app.ObjectToJSON(self)
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetMenu()
		  FileMenu.Text = Dico.Value("FileMenu")
		  FileOpen.Text = Dico.Value("FileOpen")
		  FileSave.Text = Dico.Value("FileSave")
		  FileClose.Text = Dico.Value("FileClose")
		  FilePrint.Text = Dico.Value("FilePrint")
		  EditMenu.Text = Dico.value("EditMenu")
		  EditCopy.Text = Dico.Value("EditCopy")
		  EditPaste.Text = Dico.Value("EditPaste")
		  NormalMenu.Text = Dico.Value("NormalMenu")
		  GrasMenu.Text = Dico.Value("GrasMenu")
		  ItaliqueMenu.Text = Dico.Value("ItalicMenu")
		  CouleurMenu.Text =Dico.Value("ToolsColor")
		  TailleMenu.Text =Dico.Value("Size")
		  GaucheMenu.Text =Dico.Value("Left")
		  CentrerMenu.Text =Dico.Value("Centre")
		  DroiteMenu.Text =Dico.Value("Right")
		  FontMenu.Text =Dico.Value("Fonts")
		  Col(0).Text = Dico.value("ColRed")
		  Col(1).Text = Dico.value("ColVert")
		  Col(2).Text = Dico.value("ColBleu")
		  Col(3).Text = Dico.value("ColNoir")
		  
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
		nf As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		pol As string
	#tag EndProperty


#tag EndWindowCode

#tag Events EF
	#tag Event
		Sub Open()
		  me.Styled = true
		  me.width = self.width-10
		  me.height = self.height-1
		  me.BackgroundColor = blanc
		  'me.AcceptPictureDrop
		  'me.AcceptFileDrop
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
			"9 - Modeless Dialog"
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
		Name="nf"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="pol"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="string"
		EditorType="MultiLineEditor"
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
