#tag Window
Begin Window NotesWindow
   BackColor       =   16777215
   Backdrop        =   ""
   BalloonHelp     =   ""
   CloseButton     =   "True"
   Composite       =   "False"
   Frame           =   0
   FullScreen      =   "False"
   HasBackColor    =   "False"
   Height          =   600
   ImplicitInstance=   "True"
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   "True"
   MaxWidth        =   32000
   MenuBar         =   1246849023
   MenuBarVisible  =   "True"
   MinHeight       =   64
   MinimizeButton  =   "True"
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   "True"
   Title           =   "Notes"
   Visible         =   "False"
   Width           =   625
   Begin EditField EF
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   "True"
      BackColor       =   16777215
      Bold            =   ""
      Border          =   "True"
      ControlOrder    =   0
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Format          =   ""
      Height          =   482
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   5
      LimitText       =   0
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Mask            =   ""
      Multiline       =   "True"
      Password        =   ""
      ReadOnly        =   "False"
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollbarVertical=   "True"
      Styled          =   "True"
      TabPanelIndex   =   0
      Text            =   ""
      TextColor       =   0
      TextFont        =   "MS Sans Serif"
      TextSize        =   0
      Top             =   0
      Underline       =   ""
      UseFocusRing    =   "True"
      Visible         =   "True"
      Width           =   600
      BehaviorIndex   =   0
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Resized()
		  Refresh
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  dim f as folderitem
		  
		  Title = Dico.Value("Notes")
		  
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
		  
		  Dim m as MenuItem
		  Dim i,n as Integer
		  
		  if FontMenu.count = 1 then
		    n= FontCount-1
		    FontFontName(0).Text=Font(0)
		    nf = 0
		    For i=1 to n
		      If Font(i)="Arial"  or Font(i) = "Courier New" or Font(i) = "Times New Roman"  or Font(i) = "Symbol" Then
		        nf = nf+1
		        m= New FontFontName
		        m.Text=Font(i)
		      end if
		    Next
		  end if
		  
		  If Config.username = "Tutoriel" then
		    if tutor = 0 then
		      tutor = 1
		    end if
		    Title = "Tutor"+str(tutor)+".rtf"
		    f=getfolderitem(Title)
		    f.OpenStyledEditField EF
		  end if
		  
		  EF.width = self.width-10
		  EF.height = self.height-10
		End Sub
	#tag EndEvent

	#tag Event
		Sub EnableMenuItems()
		  Dim i,n as Integer
		  n= FontCount-1
		  For i=0 to nf
		    FontFontName(i).enable
		  Next
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resizing()
		  EF.width = self.width-10
		  EF.height = self.height-10
		End Sub
	#tag EndEvent

	#tag Event
		Function CancelClose(appQuitting as Boolean) As Boolean
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

#tag MenuHandler
		Function CentrerMenu() As Boolean Handles CentrerMenu.Action
			EF.Selalignment = 2
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function EditCopier() As Boolean Handles EditCopier.Action
			EF.Copy
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function EditColler() As Boolean Handles EditColler.Action
			EF.Paste
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function FileSave() As Boolean Handles FileSave.Action
			Save
			
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function FileClose() As Boolean Handles FileClose.Action
			close
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function GaucheMenu() As Boolean Handles GaucheMenu.Action
			EF.Selalignment = 1
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function DroiteMenu() As Boolean Handles DroiteMenu.Action
			EF.Selalignment = 3
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function NormalMenu() As Boolean Handles NormalMenu.Action
			EF.StyledText.Bold(EF.SelStart,  EF.SelLength ) = false
			EF.StyledText.Italic(EF.SelStart,  EF.SelLength ) = false
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
		Function Charmap() As Boolean Handles Charmap.Action
			dim s as shell
			s = new shell
			s.Execute "%SystemRoot%\System32\charmap.exe"
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function FileOpen() As Boolean Handles FileOpen.Action
			dim f as folderitem
			
			Dim TT as New FileType
			
			TT.Name= "Rtf  Files"
			TT.Extensions=".rtf"
			
			f =GetOpenFolderItem(TT)
			if f <> nil then
			f.OpenStyledEditField EF
			title = f.name
			end if
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function FontFontName(index as Integer) As Boolean Handles FontFontName.Action
			EF.StyledText.Font(EF.SelStart,  EF.SelLength) =  FontFontName(Index).Text
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function NextMenu() As Boolean Handles NextMenu.Action
			dim f as FolderItem
			
			Tutor=Tutor+1
			
			If Config.username = "Tutoriel" then
			Title = "Tutor"+str(tutor)+".rtf"
			f=getfolderitem(Title)
			f.OpenStyledEditField EF
			refresh
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


	#tag Method, Flags = &h0
		Sub Save()
		  dim f as folderitem
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
		  f =GetSaveFolderItem("StyledText",nomfich)
		  if f <> nil then
		    f.SaveStyledEditField EF
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
		pol As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Tutor As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		nf As Integer
	#tag EndProperty


#tag EndWindowCode

