#tag Window
Begin Window WorkWindow
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Compatibility   =   ""
   Composite       =   True
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   True
   Height          =   595
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   -1173617590
   MenuBarVisible  =   True
   MinHeight       =   595
   MinimizeButton  =   True
   MinWidth        =   800
   Placement       =   0
   Resizeable      =   True
   Title           =   "Sans Titre"
   Visible         =   True
   Width           =   800
   Begin CustomCanvas1 MyCanvas1
      AcceptFocus     =   False
      AcceptTabs      =   True
      AutoDeactivate  =   False
      Backdrop        =   0
      BackgroundPicture=   0
      Bkcol           =   &c00000000
      ctxt            =   False
      DoubleBuffer    =   True
      drapzone        =   False
      Enabled         =   True
      EraseBackground =   False
      FondsEcran      =   0
      Height          =   595
      HelpTag         =   ""
      icot            =   0
      IdContent       =   0
      Index           =   -2147483648
      info            =   ""
      InitialParent   =   ""
      iobj            =   0
      Left            =   122
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MagneticDist    =   0.0
      n               =   0
      NeedsRefresh    =   False
      nobj            =   0
      OffscreenPicture=   0
      scaling         =   0.0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      tit             =   ""
      Top             =   0
      Transparent     =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   678
   End
   Begin Rectangle Tools
      AutoDeactivate  =   False
      BorderWidth     =   1
      BottomRightColor=   &c00000000
      Enabled         =   True
      FillColor       =   &cFF008080
      Height          =   595
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      Top             =   0
      TopLeftColor    =   &c00000000
      Visible         =   True
      Width           =   122
      Begin GroupBox MoveBox
         AutoDeactivate  =   True
         Bold            =   True
         Caption         =   "Mouvements"
         Enabled         =   True
         Height          =   152
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "Tools"
         Italic          =   False
         Left            =   5
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   False
         Scope           =   0
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   59
         Underline       =   False
         Visible         =   True
         Width           =   112
         Begin PushButton MouvBut
            AutoDeactivate  =   True
            Bold            =   True
            ButtonStyle     =   "0"
            Cancel          =   False
            Caption         =   "Tourner"
            Default         =   False
            Enabled         =   True
            Height          =   30
            HelpTag         =   ""
            Index           =   2
            InitialParent   =   "MoveBox"
            Italic          =   False
            Left            =   7
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            Scope           =   0
            TabIndex        =   0
            TabPanelIndex   =   0
            TabStop         =   True
            TextFont        =   "System"
            TextSize        =   0.0
            TextUnit        =   0
            Top             =   112
            Underline       =   False
            Visible         =   True
            Width           =   108
         End
         Begin PushButton MouvBut
            AutoDeactivate  =   True
            Bold            =   True
            ButtonStyle     =   "0"
            Cancel          =   False
            Caption         =   "Retourner"
            Default         =   False
            Enabled         =   True
            Height          =   30
            HelpTag         =   ""
            Index           =   3
            InitialParent   =   "MoveBox"
            Italic          =   False
            Left            =   7
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
            Top             =   142
            Underline       =   False
            Visible         =   True
            Width           =   108
         End
         Begin PushButton MouvBut
            AutoDeactivate  =   True
            Bold            =   True
            ButtonStyle     =   "0"
            Cancel          =   False
            Caption         =   "Zoomer"
            Default         =   False
            Enabled         =   True
            Height          =   30
            HelpTag         =   ""
            Index           =   4
            InitialParent   =   "MoveBox"
            Italic          =   False
            Left            =   7
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            Scope           =   0
            TabIndex        =   2
            TabPanelIndex   =   0
            TabStop         =   True
            TextFont        =   "System"
            TextSize        =   0.0
            TextUnit        =   0
            Top             =   172
            Underline       =   False
            Visible         =   True
            Width           =   108
         End
         Begin PushButton MouvBut
            AutoDeactivate  =   True
            Bold            =   True
            ButtonStyle     =   "0"
            Cancel          =   False
            Caption         =   "Glisser"
            Default         =   False
            Enabled         =   True
            Height          =   30
            HelpTag         =   ""
            Index           =   1
            InitialParent   =   "MoveBox"
            Italic          =   False
            Left            =   7
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
            Top             =   82
            Underline       =   False
            Visible         =   True
            Width           =   108
         End
      End
      Begin GroupBox StdBox
         AutoDeactivate  =   True
         Bold            =   True
         Caption         =   "Formes Standard"
         Enabled         =   True
         Height          =   135
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "Tools"
         Italic          =   False
         Left            =   5
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   False
         Scope           =   0
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   215
         Underline       =   False
         Visible         =   True
         Width           =   112
         Begin Canvas StdOutil
            AcceptFocus     =   True
            AcceptTabs      =   False
            AutoDeactivate  =   True
            Backdrop        =   0
            DoubleBuffer    =   True
            Enabled         =   True
            EraseBackground =   True
            Height          =   50
            HelpTag         =   ""
            Index           =   1
            InitialParent   =   "StdBox"
            Left            =   64
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            Scope           =   0
            TabIndex        =   0
            TabPanelIndex   =   0
            TabStop         =   True
            Top             =   240
            Transparent     =   True
            UseFocusRing    =   True
            Visible         =   True
            Width           =   50
         End
         Begin Canvas StdOutil
            AcceptFocus     =   True
            AcceptTabs      =   False
            AutoDeactivate  =   True
            Backdrop        =   0
            DoubleBuffer    =   True
            Enabled         =   True
            EraseBackground =   True
            Height          =   50
            HelpTag         =   ""
            Index           =   2
            InitialParent   =   "StdBox"
            Left            =   8
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            Scope           =   0
            TabIndex        =   1
            TabPanelIndex   =   0
            TabStop         =   True
            Top             =   292
            Transparent     =   True
            UseFocusRing    =   True
            Visible         =   True
            Width           =   50
         End
         Begin Canvas StdOutil
            AcceptFocus     =   True
            AcceptTabs      =   False
            AutoDeactivate  =   False
            Backdrop        =   0
            DoubleBuffer    =   True
            Enabled         =   True
            EraseBackground =   True
            Height          =   50
            HelpTag         =   ""
            Index           =   0
            InitialParent   =   "StdBox"
            Left            =   8
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            Scope           =   0
            TabIndex        =   2
            TabPanelIndex   =   0
            TabStop         =   True
            Top             =   240
            Transparent     =   True
            UseFocusRing    =   True
            Visible         =   True
            Width           =   50
         End
         Begin Canvas StdOutil
            AcceptFocus     =   True
            AcceptTabs      =   False
            AutoDeactivate  =   True
            Backdrop        =   0
            DoubleBuffer    =   True
            Enabled         =   True
            EraseBackground =   True
            Height          =   50
            HelpTag         =   ""
            Index           =   3
            InitialParent   =   "StdBox"
            Left            =   64
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            Scope           =   0
            TabIndex        =   3
            TabPanelIndex   =   0
            TabStop         =   True
            Top             =   292
            Transparent     =   True
            UseFocusRing    =   True
            Visible         =   True
            Width           =   50
         End
      End
      Begin PushButton PushButton1
         AutoDeactivate  =   False
         Bold            =   True
         ButtonStyle     =   "0"
         Cancel          =   False
         Caption         =   "Annuler"
         Default         =   False
         Enabled         =   True
         Height          =   30
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "Tools"
         Italic          =   False
         Left            =   1
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   False
         LockTop         =   False
         Scope           =   0
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   1
         Underline       =   False
         Visible         =   True
         Width           =   120
      End
      Begin GroupBox LibBox
         AutoDeactivate  =   True
         Bold            =   True
         Caption         =   "Formes Libres"
         Enabled         =   True
         Height          =   238
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "Tools"
         Italic          =   False
         Left            =   5
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   False
         Scope           =   0
         TabIndex        =   3
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   352
         Underline       =   False
         Visible         =   True
         Width           =   112
         Begin Canvas LibOutils
            AcceptFocus     =   True
            AcceptTabs      =   False
            AutoDeactivate  =   True
            Backdrop        =   326336511
            DoubleBuffer    =   False
            Enabled         =   True
            EraseBackground =   True
            Height          =   50
            HelpTag         =   ""
            Index           =   2
            InitialParent   =   "LibBox"
            Left            =   8
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            Scope           =   0
            TabIndex        =   0
            TabPanelIndex   =   0
            TabStop         =   True
            Top             =   433
            Transparent     =   True
            UseFocusRing    =   True
            Visible         =   True
            Width           =   50
         End
         Begin Canvas LibOutils
            AcceptFocus     =   True
            AcceptTabs      =   False
            AutoDeactivate  =   True
            Backdrop        =   419098623
            DoubleBuffer    =   False
            Enabled         =   True
            EraseBackground =   True
            Height          =   50
            HelpTag         =   ""
            Index           =   4
            InitialParent   =   "LibBox"
            Left            =   8
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            Scope           =   0
            TabIndex        =   3
            TabPanelIndex   =   0
            TabStop         =   True
            Top             =   485
            Transparent     =   True
            UseFocusRing    =   True
            Visible         =   True
            Width           =   50
         End
         Begin Canvas LibOutils
            AcceptFocus     =   True
            AcceptTabs      =   False
            AutoDeactivate  =   True
            Backdrop        =   1273780223
            DoubleBuffer    =   False
            Enabled         =   True
            EraseBackground =   True
            Height          =   50
            HelpTag         =   ""
            Index           =   5
            InitialParent   =   "LibBox"
            Left            =   8
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            Scope           =   0
            TabIndex        =   6
            TabPanelIndex   =   0
            TabStop         =   True
            Top             =   537
            Transparent     =   True
            UseFocusRing    =   True
            Visible         =   True
            Width           =   50
         End
         Begin Canvas LibOutils
            AcceptFocus     =   True
            AcceptTabs      =   False
            AutoDeactivate  =   True
            Backdrop        =   2141171711
            DoubleBuffer    =   False
            Enabled         =   True
            EraseBackground =   True
            Height          =   50
            HelpTag         =   ""
            Index           =   1
            InitialParent   =   "LibBox"
            Left            =   64
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            Scope           =   0
            TabIndex        =   1
            TabPanelIndex   =   0
            TabStop         =   True
            Top             =   381
            Transparent     =   True
            UseFocusRing    =   True
            Visible         =   True
            Width           =   50
         End
         Begin Canvas LibOutils
            AcceptFocus     =   True
            AcceptTabs      =   False
            AutoDeactivate  =   True
            Backdrop        =   834662399
            DoubleBuffer    =   False
            Enabled         =   True
            EraseBackground =   True
            Height          =   50
            HelpTag         =   ""
            Index           =   3
            InitialParent   =   "LibBox"
            Left            =   64
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            Scope           =   0
            TabIndex        =   2
            TabPanelIndex   =   0
            TabStop         =   True
            Top             =   433
            Transparent     =   True
            UseFocusRing    =   True
            Visible         =   True
            Width           =   50
         End
         Begin Canvas LibOutils
            AcceptFocus     =   True
            AcceptTabs      =   False
            AutoDeactivate  =   True
            Backdrop        =   680357887
            DoubleBuffer    =   False
            Enabled         =   True
            EraseBackground =   True
            Height          =   50
            HelpTag         =   ""
            Index           =   6
            InitialParent   =   "LibBox"
            Left            =   64
            LockBottom      =   True
            LockedInPosition=   False
            LockLeft        =   True
            LockRight       =   True
            LockTop         =   True
            Scope           =   0
            TabIndex        =   4
            TabPanelIndex   =   0
            TabStop         =   True
            Top             =   485
            Transparent     =   True
            UseFocusRing    =   True
            Visible         =   True
            Width           =   50
         End
         Begin Canvas LibOutils
            AcceptFocus     =   True
            AcceptTabs      =   False
            AutoDeactivate  =   True
            Backdrop        =   1333702655
            DoubleBuffer    =   False
            Enabled         =   True
            EraseBackground =   True
            Height          =   50
            HelpTag         =   ""
            Index           =   0
            InitialParent   =   "LibBox"
            Left            =   8
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            Scope           =   0
            TabIndex        =   5
            TabPanelIndex   =   0
            TabStop         =   True
            Top             =   381
            Transparent     =   True
            UseFocusRing    =   True
            Visible         =   True
            Width           =   50
         End
      End
      Begin PushButton MouvBut
         AutoDeactivate  =   True
         Bold            =   True
         ButtonStyle     =   "0"
         Cancel          =   False
         Caption         =   "Modifier"
         Default         =   False
         Enabled         =   True
         Height          =   30
         HelpTag         =   ""
         Index           =   0
         InitialParent   =   "Tools"
         Italic          =   False
         Left            =   1
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   False
         LockTop         =   False
         Scope           =   0
         TabIndex        =   4
         TabPanelIndex   =   0
         TabStop         =   True
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   31
         Underline       =   False
         Visible         =   True
         Width           =   120
      End
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Function CancelClose(appQuitting as Boolean) As Boolean
		  dim i as integer
		  
		  'if appQuitting then
		  for i = ubound(wcontent) downto 0
		    deletecontent
		    if ubound(wcontent) = i then
		      return true
		    end if
		  next
		  'end if
		  appquitting = true
		  
		  return false
		  
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Close()
		  if fw <> nil then
		    fw.close
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Sub DropObject(obj As DragItem, action As Integer)
		  
		  if obj.FolderItem <> nil then
		    OpenFile(obj.FolderItem)
		  else
		    MsgBox Dico.Value("MsgUnfoundable")+ ou + Dico.Value("MsgNovalidFile")
		  end if
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub EnableMenuItems()
		  if CurrentContent <> nil and ( not CurrentContent.currentoperation isa shapeconstruction) then
		    MyCanvas1.mousecursor = System.Cursors.StandardPointer
		  else
		    setcross
		  end if
		  
		  dim B, B1, B2 as boolean
		  dim item as MenuItem
		  dim i as integer
		  
		  if (MenuBar = HistMenu) then
		    return
		  end if
		  
		  if currentcontent <> nil then
		    MenuBar.Child("FileMenu").Child("FileNew").enabled = not currentcontent.macrocreation
		    MenuBar.Child("FileMenu").Child("FileOpen").enabled =  not currentcontent.macrocreation
		  end if
		  
		  if wnd<>nil and can.rep <> nil and currentcontent <> nil then
		    B =  CurrentContent.TheObjects.count > 1
		    B1 = CurrentContent.TheGrid <> nil
		    B2 = can.rep.labs.count > 0
		    B = (B or B1 or B2) and not currentcontent.macrocreation
		    MenuBar.Child("FileMenu").Child("FileSave").Enabled= B  and not CurrentContent.CurrentFileUptoDate
		    MenuBar.Child("FileMenu").Child("FileClose").enabled =   not currentcontent.macrocreation
		    if MenuMenus.Child("EditMenu").Child("EditUndo").Checked then
		      MenuBar.Child("EditMenu").Child("EditUndo").Enabled = true 
		      wnd.pushbutton1.enabled = true 
		    end if
		    if MenuMenus.Child("EditMenu").Child("EditRedo").Checked then
		      MenuBar.Child("EditMenu").Child("EditRedo").Enabled = (CurrentContent.currentop < CurrentContent.totaloperation -1)
		    end if
		  else
		    B = false
		    MenuBar.Child("FileMenu").Child("FileSave").Enabled= false
		    MenuBar.Child("FileMenu").Child("FileClose").enabled = false
		  end if
		  
		  MenuBar.Child("FileMenu").Child("FilePrint").Enabled = B
		  MenuBar.Child("FileMenu").Child("FileSaveAs").Enabled = B
		  MenuBar.Child("FileMenu").Child("FileSaveStd").Enabled = B
		  MenuBar.Child("FileMenu").Child("FileSaveEps").Enabled= B and (Config.username = Dico.Value("Enseignant"))
		  MenuBar.Child("FileMenu").Child("FileSaveBitmap").Enabled = B
		  
		  if currentcontent <> nil then
		    PushButton1.enabled = currentcontent.currentop > 0
		  end if
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(Key As String) As Boolean
		  dim u(-1), s as integer
		  dim disp, nom as string
		  
		  if CurrentContent.bugfound then
		    return false
		  end if
		  s = asc(key)
		  
		  select case asc(Key)
		  case 59    ' ;
		    config
		  case 181 'µ
		    stdflag = not stdflag
		  case   163  //shift "µ"
		    if CurrentContent.currentoperation <> nil then
		      CurrentContent.CurrentOperation.std2flag = not CurrentContent.CurrentOperation.std2flag
		    end if
		  case 1 'ctrl-shft a
		    currentcontent.drapaff = not currentcontent.drapaff
		    currentcontent.drapeucli = false
		  case 5 'ctrl-shft e
		    currentcontent.drapeucli = not currentcontent.drapeucli
		    currentcontent.drapaff = false
		  case  20 ' ctrl-shft t
		    can.sctxt = nil
		    tw = new TextWindow
		    tw.visible = true
		  case 21 'ctrl-shft u
		    tw = new textwindow
		    tw.source1 = true  //historique
		    tw.visible = true
		  case 22 'ctrl-shft v
		    tw = new textwindow
		    tw.source2 = true  //fag
		    tw.visible = true
		  case 42 'shft *
		    currentcontent.ndec = currentcontent.ndec+1
		    mycanvas1.refreshbackground
		  case 36 '$
		    if currentcontent.ndec > 0 then
		      currentcontent.ndec = currentcontent.ndec-1
		      mycanvas1.refreshbackground
		    end if
		  case 99  'c
		    switchcolors
		  case 100 'd
		    drapdim = not drapdim
		  case 101 'e copie d'écran
		    CurrentContent.currentoperation = new SaveBitMap(0,0,mycanvas1.width,mycanvas1.height)
		    CurrentContent.currentoperation = nil
		    refreshtitle
		  case 112 'p'
		    drappt = not drappt
		  case 113 'q
		    app.quiet = not app.quiet
		  case 114  'r  Bug volontaire!! A déconnecter en temps opportun
		    MsgBox "Bug volontaire -- Ne jamais pousser sur la touche 'r'"
		    's = u(0)
		  case 115 's  Exportation postscript
		    if CurrentContent.currentoperation <> nil then
		      disp = CurrentContent.currentoperation.display + CurrentContent.currentoperation.info
		      nom = CurrentContent.currentoperation.getname
		      CurrentContent.TheObjects.unselectall
		      CurrentContent.currentoperation = new SaveEps(disp, nom, true)
		      CurrentContent.currentoperation.finished = false
		      SaveEPS(CurrentContent.CurrentOPeration).ImmediateDoOperation
		      CurrentContent.currentoperation = nil
		      refreshtitle
		    end if
		  case 116 't Creer Objets Tracés
		    CurrentContent.TheObjects.CreerTrace = not  CurrentContent.TheObjects.creertrace
		  case 26 'ctrl-shft z
		    'mycanvas1.drapzone = not mycanvas1.drapzone
		  case 32   'barre d'espacement
		    if  CurrentContent.CurrentOperation <> nil then
		      CurrentContent.currentoperation.MouseWheel
		    elseif Mycanvas1.ctxt then
		      Mycanvas1.ChoixcontextMenu
		    end if
		  case 45 'touche -
		    DiminueFont
		    refresh
		  case 43, 61 'touche +
		    AugmenteFont
		    refresh
		  case 48, 224 'touche 0
		    ResetFont
		  end select
		  
		  return true
		  
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Maximize()
		  
		  UpdateToolBar
		  'width = screen(0).width -120
		  'height = screen(0).height
		End Sub
	#tag EndEvent

	#tag Event
		Sub Moved()
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  if app.ipctransfert then
		    Quit
		  end if
		  InitParams()
		  updateMenu
		  NewContent(false)
		  DrapShowall = false
		  if MenuMenus.Child("EditMenu").Child("EditCopy").checked  then
		    DrapResel =  MenuBar.Child("EditMenu").Child("EditReselect").checked
		  end if
		  
		  if app.fileName <> "" then
		    dim f as FolderItem
		    f = GetFolderItem(app.FileName)
		    if f <> nil then
		      OpenFile(f)
		    else
		      MsgBox  Dico.Value("MsgErrOpenFile")
		    end if
		    app.FileName = ""
		  end if
		  
		  maximize
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  can.resize
		  can.RefreshBackground
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resizing()
		  
		  can.resize
		  can.RefreshBackground
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Restore()
		  UpdateToolBar
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function CfgOpen() As Boolean Handles CfgOpen.Action
			config
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirCisaillement() As Boolean Handles DefinirCisaillement.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new TransfoConstruction(11)
			refreshtitle
			end if
			return true
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirDemiTour() As Boolean Handles DefinirDemiTour.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new TransfoConstruction(3)
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirDeplacement() As Boolean Handles DefinirDeplacement.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new TransfoConstruction(10)
			refreshtitle
			end if
			return true
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirEtirement() As Boolean Handles DefinirEtirement.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new TransfoConstruction(9)
			refreshtitle
			end if
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirHomothetie() As Boolean Handles DefinirHomothetie.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new TransfoConstruction(7)
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirQuartD() As Boolean Handles DefinirQuartD.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new TransfoConstruction(5)
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirQuartG() As Boolean Handles DefinirQuartG.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new TransfoConstruction(4)
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirRotation() As Boolean Handles DefinirRotation.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new TransfoConstruction(2)
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirSimilitude() As Boolean Handles DefinirSimilitude.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new TransfoConstruction(8)
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirSymetrieaxiale() As Boolean Handles DefinirSymetrieaxiale.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new TransfoConstruction(6)
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirTranslation() As Boolean Handles DefinirTranslation.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new TransfoConstruction(1)
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditCopy() As Boolean Handles EditCopy.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new Copier
			Copier(CurrentContent.CurrentOperation).ImmediateDoOperation
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditDelete() As Boolean Handles EditDelete.Action
			if mousedispo then
			closefw
			CurrentContent.theobjects.unselectall
			CurrentContent.CurrentOperation=new Delete()
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditLink() As Boolean Handles EditLink.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new Lier
			Lier(CurrentContent.CurrentOPeration).ImmediateDoOperation
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditPaste() As Boolean Handles EditPaste.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new Coller
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditRedo() As Boolean Handles EditRedo.Action
			if mousedispo then
			closefw
			CurrentContent.RedoLastOperation
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditReselect() As Boolean Handles EditReselect.Action
			MenuBar.Child("EditMenu").Child("EditReselect").checked = not MenuBar.Child("EditMenu").Child("EditReselect").checked
			Drapresel = MenuBar.Child("EditMenu").Child("EditReselect").checked
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditSelectall() As Boolean Handles EditSelectall.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new Selectionner(true)
			CurrentContent.Currentoperation.Dooperation
			CurrentContent.Currentoperation.endoperation
			CurrentContent.CurrentOperation = nil
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditSelection() As Boolean Handles EditSelection.Action
			if mousedispo then
			closefw
			if not CurrentContent.CurrentOperation isa selectionner or selectionner(CurrentContent.currentoperation).all = true  then
			CurrentContent.CurrentOperation=new Selectionner()
			end if
			refreshtitle
			end if
			return true
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditUndo() As Boolean Handles EditUndo.Action
			if dret = nil then
			currentcontent.currentoperation.Annuler
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditUnlink() As Boolean Handles EditUnlink.Action
			if mousedispo then
			closefw
			CurrentContent.currentoperation = nil
			refreshtitle
			CurrentContent.CurrentOperation = new Delier
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileClose() As Boolean Handles FileClose.Action
			
			deletecontent
			if UBound (wcontent) = -1 then
			NewContent(false)
			end if
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileNew() As Boolean Handles FileNew.Action
			if mousedispo then
			closefw
			NewContent(false)
			refresh
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileOpen() As Boolean Handles FileOpen.Action
			Dim f As FolderItem
			
			if mousedispo then
			closefw
			f=GetOpenFolderItem(FileAGTypes.All)
			if f=nil then
			return true
			else
			OpenFile(f)
			end if
			end if
			setfocus
			return true
			
			
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FilePrint() As Boolean Handles FilePrint.Action
			if mousedispo then
			closefw
			CurrentContent.currentoperation = nil
			refreshtitle
			CurrentContent.CurrentOperation = new Imprimer
			CurrentContent.currentoperation.finished = false
			Imprimer(CurrentContent.CurrentOPeration).ImmediateDoOperation
			CurrentContent.currentoperation = nil
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileSave() As Boolean Handles FileSave.Action
			if mousedispo then
			closefw
			CurrentContent.Save
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileSaveAs() As Boolean Handles FileSaveAs.Action
			if mousedispo then
			closefw
			CurrentContent.SaveAs
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileSaveBitmap() As Boolean Handles FileSaveBitmap.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new SaveBitMap
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileSaveEps() As Boolean Handles FileSaveEps.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new SaveEPS
			CurrentContent.currentoperation.finished = false
			SaveEPS(CurrentContent.CurrentOPeration).ImmediateDoOperation
			CurrentContent.currentoperation = nil
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileSaveStd() As Boolean Handles FileSaveStd.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new SaveStd
			CurrentContent.currentoperation.finished = false
			SaveStd(CurrentContent.CurrentOPeration).ImmediateDoOperation
			CurrentContent.currentoperation = nil
			refreshtitle
			end if
			return true
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function HelpAbout() As Boolean Handles HelpAbout.Action
			if mousedispo then
			dim md as MessageDialog
			Dim b as MessageDialogButton
			Dim mois() as string
			
			mois.Append ("Janvier")
			mois.Append ("Février")
			mois.Append ("Mars")
			mois.Append ("Avril")
			mois.Append ("Mai")
			mois.Append ("Juin")
			mois.Append ("Juillet")
			mois.Append ("Août")
			mois.Append ("Septembre")
			mois.Append ("Octobre")
			mois.Append ("Novembre")
			mois.Append ("Décembre")
			
			
			closefw
			md = New MessageDialog
			md.Title = Dico.value("HelpAbout")
			md.Icon = 0
			md.Message = "Apprenti géomètre v."+App.LongVersion+EndOfLine+"Copyright CREM "+ App.BuildDate.LongDate + EndofLine +EndofLine+ "Programmation: G. Noël et G. Pliez"
			b = md.ShowModal
			end if
			return true
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function HelpUG() As Boolean Handles HelpUG.Action
			dim fi as Folderitem
			
			fi = getfolderitem(Dico.Value("UserGuide"))
			
			if fi.exists then
			fi.launch
			else
			MsgBox Dico.Value("MsgUnfoundable")
			end if
			Return True
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function HelpView() As Boolean Handles HelpView.Action
			if mousedispo then
			closefw
			Config.ShowHelp=not Config.ShowHelp
			can.RefreshBackground
			MenuBar.Child("HelpMenu").Child("HelpView").checked = Config.showhelp
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function HelpVisit() As Boolean Handles HelpVisit.Action
			if mousedispo then
			closefw
			ShowURL "http://www.crem.be/"
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function Histclose() As Boolean Handles Histclose.Action
			if mousedispo then
			close
			end if
			return true
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function Install() As Boolean Handles Install.Action
			Dim f As FolderItem
			
			if mousedispo then
			closefw
			f=GetOpenFolderItem(FileAGTypes.Image)
			if f=nil then
			return true
			else
			mycanvas1.FondsEcran = Picture.Open(f)
			end if
			end if
			
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function MacrosChoose(index as Integer) As Boolean Handles MacrosChoose.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new MacroExe(index)
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function MacrosClose2(index as Integer) As Boolean Handles MacrosClose2.Action
			
			app.themacros.RemoveMac app.themacros.item(index)
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function MacrosCopy2(index as Integer) As Boolean Handles MacrosCopy2.Action
			app.themacros.item(index).CopyMacroToFile
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function MacrosCreate() As Boolean Handles MacrosCreate.Action
			
			closefw
			newcontent(true)
			MenuMacros(true)
			can.resize
			wnd.refreshtitle
			config.trace = false
			can.refreshbackground
			currentcontent.mac = nil
			return true
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function MacrosDescri2(index as Integer) As Boolean Handles MacrosDescri2.Action
			dim Mac as Macro
			
			Mac = app.themacros.item(index)
			Mac.OpenDescripWindow
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function MacrosErase2(index as Integer) As Boolean Handles MacrosErase2.Action
			Dim f As FolderItem
			dim mac as macro
			dim cf as Confirmation
			
			closefw
			currentcontent.currentoperation = nil
			refreshtitle
			
			mac= app.themacros.item(index)
			f = app.MacFolder.Child(mac.caption+".xmag")
			
			if f <> nil then
			cf = new Confirmation("Voulez-vous vraiment supprimer cette macro du disque dur?")
			cf.showmodal
			
			if cf.result = 1 then
			app.themacros.RemoveMac app.themacros.item(index)
			f.delete
			end if
			cf.close
			end if
			
			return true
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function MacrosFinaux() As Boolean Handles MacrosFinaux.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new ChooseFinal
			MenuBar.Child("MacrosMenu").Child("MacrosSave").visible = true
			refreshtitle
			end if
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function MacrosLoad() As Boolean Handles MacrosLoad.Action
			Dim f As FolderItem
			dim Doc as XmlDocument
			dim mac as macro
			dim dlg as OpenDialog
			
			closefw
			currentcontent.currentoperation = nil
			refreshtitle
			dlg = new OpenDialog
			dlg.InitialDirectory = App.MacFolder
			dlg.Filter = FileAGTypes.MACR
			f = dlg.ShowModal
			
			if f <> nil then
			Doc = new XmlDocument(f)
			mac =new Macro(Doc)
			app.themacros.addmac mac
			wnd.updatesousmenusmacros
			end if
			return true
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function MacrosQuit() As Boolean Handles MacrosQuit.Action
			
			CloseMacro
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function MacrosSave() As Boolean Handles MacrosSave.Action
			dim op as operation
			
			closefw
			op = currentcontent.currentoperation
			if op isa choosefinal then
			choosefinal(op).endoperation
			end if
			currentcontent.currentoperation = nil
			CloseMacro
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function NotesOpen() As Boolean Handles NotesOpen.Action
			if mousedispo then
			closefw
			NotesWindow.visible = true
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function OperaClone() As Boolean Handles OperaClone.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new Duplicate()
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function OperaCreateCenter() As Boolean Handles OperaCreateCenter.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new GCConstruction()
			GCConstruction(CurrentContent.CurrentOperation).ImmediateDoOperation
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function OperaCut() As Boolean Handles OperaCut.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new Decouper()
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function OperaDivide() As Boolean Handles OperaDivide.Action
			dim diw as DivideWindow
			
			if mousedispo then
			closefw
			diw = new DivideWindow
			diw.ShowModal
			CurrentContent.CurrentOperation=new Divide(ntemp)
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function OperaIdentify() As Boolean Handles OperaIdentify.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new Identifier()
			refreshtitle
			end if
			return true
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function OperaMerge() As Boolean Handles OperaMerge.Action
			
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new Fusion()
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function OperaProl() As Boolean Handles OperaProl.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new Prolonger()
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsAjust() As Boolean Handles PrefsAjust.Action
			MenuBar.Child("PrefsMenu").Child("PrefsAjust").checked = not MenuBar.Child("PrefsMenu").Child("PrefsAjust").checked
			Config.Ajust = MenuBar.Child("PrefsMenu").Child("PrefsAjust").checked
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsBiface() As Boolean Handles PrefsBiface.Action
			MenuBar.Child("PrefsMenu").Child("PrefsBiface").checked = not MenuBar.Child("PrefsMenu").Child("PrefsBiface").checked
			Config.StdBiface = MenuBar.Child("PrefsMenu").Child("PrefsBiface").checked
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsFleches() As Boolean Handles PrefsFleches.Action
			MenuBar.Child("PrefsMenu").Child("PrefsFleches").checked = not MenuBar.Child("PrefsMenu").Child("PrefsFleches").checked
			currentcontent.PolygFleches = MenuBar.Child("PrefsMenu").Child("PrefsFleches").checked
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsMagDist() As Boolean Handles PrefsMagDist.Action
			dim mw as MagDistWindow
			dim d as double
			
			mw = new MagDistWindow
			mw.ShowModal
			if mw.result=1 then
			d = val(mw.editfield1.text)
			Config.magneticdist = d
			MyCanvas1.SetMagneticDist
			Mycanvas1.zone.width = 2*d
			Mycanvas1.zone.height=2*d
			mw.close
			end if
			return true
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsPolyg() As Boolean Handles PrefsPolyg.Action
			MenuBar.Child("PrefsMenu").Child("PrefsPolyg").checked = not MenuBar.Child("PrefsMenu").Child("PrefsPolyg").checked
			currentcontent.PolygPointes = MenuBar.Child("PrefsMenu").Child("PrefsPolyg").checked
			Config.PolPointes = currentcontent.polygpointes
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsStdForms() As Boolean Handles PrefsStdForms.Action
			
			dim stdw as StdFormsWindow
			
			if mousedispo then
			CurrentContent.CurrentOperation = nil
			refreshtitle
			closefw
			stdw = new stdformswindow
			stdw.ShowModal
			end if
			return true
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsThickness() As Boolean Handles PrefsThickness.Action
			dim mw as ThickWindow
			dim d as double
			
			mw = new ThickWindow
			mw.ShowModal
			if mw.result=1 then
			d = val(mw.TF.text)
			Config.Thickness = d
			mw.close
			end if
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsTrace() As Boolean Handles PrefsTrace.Action
			
			MenuBar.Child("PrefsMenu").Child("PrefsTrace").checked = not MenuBar.Child("PrefsMenu").Child("PrefsTrace").checked
			Config.Trace =MenuBar.Child("PrefsMenu").Child("PrefsTrace").checked
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsUAChoix() As Boolean Handles PrefsUAChoix.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new Unit(1)
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsUADef() As Boolean Handles PrefsUADef.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new Unit(3)
			refreshtitle
			end if
			return true
			
			
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsULChoix() As Boolean Handles PrefsULChoix.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new Unit(0)
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsULDef() As Boolean Handles PrefsULDef.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new Unit(2)
			refreshtitle
			end if
			return true
			
			
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsARPlan() As Boolean Handles ToolsARPlan.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new ChangePosition(0)
			ChangePosition(CurrentContent.Currentoperation).ImmediateDoOperation
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsAvPlan() As Boolean Handles ToolsAvPlan.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new ChangePosition(1)
			ChangePosition(CurrentContent.Currentoperation).ImmediateDoOperation
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsColorBorder() As Boolean Handles ToolsColorBorder.Action
			colorchange(true)
			refreshtitle
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsColorFill() As Boolean Handles ToolsColorFill.Action
			colorchange(false)
			refreshtitle
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsColorStdFam() As Boolean Handles ToolsColorStdFam.Action
			CurrentContent.currentoperation = nil
			closefw
			refreshtitle
			drapstdcolor = true
			return true
			
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsColorTransparent() As Boolean Handles ToolsColorTransparent.Action
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsGrid() As Boolean Handles ToolsGrid.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new CreateGrid()
			Refresh
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsHide() As Boolean Handles ToolsHide.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new Hide()
			Hide(CurrentContent.CurrentOperation).ImmediateDoOperation
			refreshtitle
			end if
			return true
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsHisto() As Boolean Handles ToolsHisto.Action
			Dim f As FolderItem
			Dim dlg as OpenDialog
			dim ohw as OpenHistWindow
			
			if mousedispo then
			closefw
			MyCanvas1.Mousecursor = system.cursors.wait
			if not (Config.username = "Enseignant") then
			ohw = new OpenHistWindow
			ohw.ShowModal
			f = ohw.file
			ohw.close
			if f<>nil  then
			OpenFile(f)
			end if
			else
			dlg = new OpenDialog
			dlg.InitialDirectory = App.DocFolder.Child("Historiques")
			dlg.Filter = FileAGTypes.HIST
			f = dlg.ShowModal
			if f <> nil then
			OpenFile(f)
			end if
			end if
			MyCanvas1.Mousecursor = System.Cursors.StandardPointer
			end if
			return true
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsLabel() As Boolean Handles ToolsLabel.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new AddLabel()
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsOpq() As Boolean Handles ToolsOpq.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new TransparencyChange(100)
			TransparencyChange(CurrentContent.CurrentOperation).ImmediateDoOperation
			refreshtitle
			end if
			return true
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsRigid() As Boolean Handles ToolsRigid.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new Rigidifier()
			Rigidifier(CurrentContent.CurrentOperation).ImmediateDoOperation
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsSTsp() As Boolean Handles ToolsSTsp.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new TransparencyChange(50)
			TransparencyChange(CurrentContent.CurrentOperation).ImmediateDoOperation
			refreshtitle
			end if
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsThick1() As Boolean Handles ToolsThick1.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new Epaisseur(Config.Thickness)
			Epaisseur(CurrentContent.CurrentOperation).ImmediateDoOperation
			MenuBar.Child("ToolsMenu").Child("ToolsThickness").Child("ToolsThick1").checked = true
			MenuBar.Child("ToolsMenu").Child("ToolsThickness").Child("ToolsThick2").checked = false
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsThick2() As Boolean Handles ToolsThick2.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new Epaisseur(1.5*Config.Thickness)
			Epaisseur(CurrentContent.CurrentOperation).ImmediateDoOperation
			MenuBar.Child("ToolsMenu").Child("ToolsThickness").Child("ToolsThick1").checked = false
			MenuBar.Child("ToolsMenu").Child("ToolsThickness").Child("ToolsThick2").checked = true
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsTrace() As Boolean Handles ToolsTrace.Action
			if mousedispo then
			closefw
			MyCanvas1.ClearOffscreen
			CurrentContent.CurrentOperation = new Tracer()
			Tracer(CurrentContent.CurrentOperation).ImmediateDoOperation
			refreshtitle
			end if
			return true
			
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsTsp() As Boolean Handles ToolsTsp.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new TransparencyChange(0)
			TransparencyChange(CurrentContent.CurrentOperation).ImmediateDoOperation
			refreshtitle
			end if
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function TransfosAppliquer() As Boolean Handles TransfosAppliquer.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new AppliquerTsf()
			refreshtitle
			end if
			return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function TransfosFixedPoints() As Boolean Handles TransfosFixedPoints.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new FixPConstruction
			refreshtitle
			end if
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function TransfosHide() As Boolean Handles TransfosHide.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new HideTsf
			refreshtitle
			end if
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function UnInstall() As Boolean Handles UnInstall.Action
			mycanvas1.FondsEcran = nil
			Return False
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function winitem(index as Integer) As Boolean Handles winitem.Action
			dim i as integer
			dim oldOp as Operation
			
			if mousedispo then
			closefw
			if index <> GetNumWindow then
			oldOp = CurrentContent.CurrentOperation
			MenuBar.Child("Fenetres").Item(GetNumWindow).checked = false
			CurrentContent = wcontent(index)
			if oldOp isa ReadHisto then
			if not CurrentContent.CurrentOperation isa ReadHisto then
			MenuBar = Menu
			ReadHisto(oldOp).Hcmd.visible = false
			wnd.draphisto = false
			wnd.refreshtitle
			end if
			elseif CurrentContent.CurrentOperation isa ReadHisto then
			MenuBar = HistMenu
			ReadHisto(CurrentContent.CurrentOperation).Hcmd.visible = true
			wnd.draphisto = true
			wnd.DisableToolBar
			elseif CurrentContent.Macrocreation then
			MenuMacros(true)
			end if
			MenuBar.Child("Fenetres").Item(index).checked = true
			can.sctxt = nil
			refresh
			end if
			end if
			return true
			
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h0
		Sub Annuler()
		  'dim op as operation
		  'op =CurrentContent.CurrentOperation
		  'closefw
		  'if  op isa MultipleSelectOperation and ( MultipleSelectOperation(op).currentitemtoset >= 1) then
		  'if op isa AppliquerTsf then
		  'AppliquerTsf(op).tsf.highlighted = false
		  'end if
		  'CurrentContent.abortconstruction
		  'else
		  'CurrentContent.UndoLastOperation
		  'end if
		  'mycanvas1.refreshBackground
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AugmenteFont()
		  dim obj as ObjectsList
		  dim i as integer
		  
		  Config.TextSize = Config.TextSize +1
		  updateTextSize
		  obj = currentcontent.Theobjects
		  for i = 0 to obj.count -1
		    obj.item(i).augmentefont
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub closefw()
		  if fw = nil then
		    return
		  else
		    selectedtool = -1
		    if fw.kit = 0 then
		      stdoutil(fw.fam).refresh
		    else
		      liboutils(fw.fam).refresh
		    end if
		    fw.close
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CloseMacro()
		  closefw
		  deletecontent
		  MenuMacros(false)
		  
		  MenuBar.Child("MacrosMenu").Child("MacrosCreate").visible = true
		  MenuBar.Child("MacrosMenu").Child("MacrosLoad").visible = true
		  Config.Trace =MenuBar.Child("PrefsMenu").Child("PrefsTrace").checked
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CloseSousMenu(mitem as menuitem)
		  dim i as integer
		  
		  for i =  mitem.count-1 downto 0
		    mitem.remove i
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CloseSousMenusMacros()
		  dim mitem as menuitem
		  
		  mitem = MenuMenus.Child("MacrosMenu").Child("MacrosExecute")
		  CloseSousMenu(mitem)
		  mitem = MenuMenus.Child("MacrosMenu").Child("MacrosClose")
		  CloseSousMenu(mitem)
		  mitem = MenuMenus.Child("MacrosMenu").Child("MacrosDescri")
		  CloseSousMenu(mitem)
		  mitem = MenuMenus.Child("MacrosMenu").Child("MacrosErase")
		  CloseSousMenu(mitem)
		  mitem = MenuMenus.Child("MacrosMenu").Child("MacrosCopy")
		  CloseSousMenu(mitem)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub colorchange(b as boolean)
		  dim col as color
		  dim coul as couleur
		  
		  if mousedispo then
		    closefw
		    if selectcolor(col,"Choisis une couleur") then
		      coul = new couleur(col)
		      CurrentContent.CurrentOperation=new ColorChange(b,coul)
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub config()
		  ConfigWindow.showmodal
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CopyCFGMenu()
		  dim mitem,sm as MenuItem
		  
		  if Config.pwok then
		    mitem = new MenuItem
		    mitem.Name = "Cfg"
		    mitem.Text = Dico.Value("Cfg")
		    sm = new MenuItem 'sous-menu nécessaire pour fonctionner sur Mac
		    sm.Name = "CfgOpen"
		    sm.Text = Dico.Value("Customize")
		    mitem.append sm
		    MenuBar.append mitem
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CopyMenuBar()
		  dim i, nmen as integer
		  dim mitem as MenuItem
		  
		  nmen = MenuMenus.count
		  for i = 0 to nmen-1
		    mitem = CopyMenuItem(MenuMenus.item(i))
		    if mitem <> nil then
		      MenuBar.append mitem
		    end if
		  next
		  CopyCFGMenu
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CopyMenuItem(mitem as menuitem) As menuitem
		  dim item, jtem as menuitem
		  dim i, nitem as integer
		  
		  
		  item = new MenuItem
		  item.Name = mitem.Name
		  item.KeyboardShortCut = mitem.KeyboardShortCut
		  item.index = mitem.index
		  if not  (item.Name = "MacrosChoose" or item.Name="MacrosErase2" or item.Name = "MacrosClose2" or item.Name = "MacrosDescri2" or item.Name="MacrosCopy2")   then '
		    item.Text = Dico.Value(item.Name)
		  else
		    item.Text = mitem.Text
		  end if
		  
		  
		  if item.name = "PrefsFreeForms" then
		    return nil
		  end if
		  
		  nitem = mitem.count
		  
		  if nitem = 0 then
		    if mitem.checked then
		      return item
		    else
		      return nil
		    end if
		  else
		    for i = 0 to nitem-1
		      jtem = CopyMenuItem(mitem.item(i))
		      if jtem <> nil then
		        item.append jtem
		      end if
		    next
		    if item.count > 0 then
		      return item
		    else
		      return nil
		    end if
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CountContent() As integer
		  return UBound(wcontent)+1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateSousMenu(muitem as menuitem, nom as string)
		  dim i as integer
		  dim mitem as MenuItem
		  
		  for i = 0 to app.themacros.count-1
		    mitem = new MenuItem
		    mitem.Name = nom
		    mitem.index  = i
		    mitem.checked = true
		    muitem.append mitem
		    mitem.Text = app.TheMacros.item(i).caption
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateSousMenusMacros()
		  dim mitem as MenuItem
		  
		  mitem = MenuMenus.Child("MacrosMenu").Child("MacrosExecute")
		  CreateSousMenu(mitem, "MacrosChoose")
		  mitem = MenuMenus.Child("MacrosMenu").Child("MacrosClose")
		  CreateSousMenu(mitem, "MacrosClose2")
		  mitem = MenuMenus.Child("MacrosMenu").Child("MacrosDescri")
		  CreateSousMenu(mitem, "MacrosDescri2")
		  mitem = MenuMenus.Child("MacrosMenu").Child("MacrosErase")
		  CreateSousMenu(mitem,"MacrosErase2")
		  mitem = MenuMenus.Child("MacrosMenu").Child("MacrosCopy")
		  CreateSousMenu(mitem,"MacrosCopy2")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub deleteContent()
		  dim conf as Confirmation
		  dim i,n,val As integer
		  
		  val = 0
		  
		  if not currentcontent.macrocreation then
		    if CurrentContent.TheObjects.count > 1 and not CurrentContent.CurrentFileUptoDate then
		      conf = new Confirmation(CurrentContent.id)
		      Conf.ShowModal
		      val = Conf.result      ''Yes
		      conf.close
		    end if
		    select case val
		    case -1             '-1: annuler
		      return
		    case  1
		      CurrentContent.Save
		    end select
		  end if
		  
		  n = GetNumWindow
		  wcontent.Remove(n)
		  MenuBar.Child("Fenetres").Remove(n)
		  
		  if ubound(wcontent) >= n then
		    for i=n to UBound (wcontent)
		      MenuBar.Child("Fenetres").item(i).index = i
		    next
		    CurrentContent = wcontent(n)
		  elseif ubound(wcontent) >-1 then
		    currentcontent = wcontent(ubound(wcontent))
		  else
		    CurrentContent = nil
		  end if
		  if CurrentContent <> nil then
		    MenuBar.Child("Fenetres").Item(GetNumWindow).checked = true
		    refresh
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DiminueFont()
		  dim obj as ObjectsList
		  dim i as integer
		  
		  Config.TextSize = Config.TextSize -1
		  updateTextSize
		  obj = currentcontent.Theobjects
		  for i = 0 to obj.count -1
		    obj.item(i).diminuefont
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DisableToolBar()
		  Tools.Enabled = false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnableToolbar()
		  Tools.Enabled = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub endselect()
		  if CurrentContent.currentoperation isa selectionner then
		    selectionner(CurrentContent.currentoperation).endoperation
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EraseMenuBar()
		  dim i, n as integer
		  n = menubar.count
		  
		  for i = n-1 downto 2
		    menubar.remove i
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMenuItem(menu as string, sousmenu as string) As Boolean
		  Return MenuMenus.Child(menu).Child(sousmenu).checked
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetNumWindow() As integer
		  dim i as integer
		  
		  for i=0 to UBound(wcontent)
		    if (wcontent(i)=currentContent) then
		      return i
		    end if
		  next
		  return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetStdSpecs(v as integer, sv as integer) As StdPolygonSpecifications
		  
		  return config.StdFamilies(v,sv)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IcoDraw(Fa as integer, Fo as integer)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitParams()
		  wnd = self
		  can = wnd.mycanvas1
		  
		  width = screen(0).width -120
		  height = screen(0).height
		  
		  title = Config.username
		  AcceptFileDrop(FileAGTypes.SAVE)
		  AcceptFileDrop(FileAGTypes.HIST)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LibBoxRefresh()
		  LibBox.Visible = (Config.ShowTools and not draphisto) or (CurrentContent <> nil and CurrentContent.TheGrid <>nil)
		  if LibBox.Visible then
		    dim i as integer
		    for i=0 to 6
		      LibOutils(i).Visible =true
		    next
		  end if
		  LibBox.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Manageprefs()
		  if menumenus.Child("PrefsMenu").Child("PrefsTrace").checked  then
		    MenuBar.Child("PrefsMenu").Child("PrefsTrace").checked = config.trace
		  end if
		  if menumenus.Child("PrefsMenu").Child("PrefsPolyg").checked  then
		    MenuBar.Child("PrefsMenu").Child("PrefsPolyg").checked = currentcontent.polygpointes
		  end if
		  if menumenus.Child("PrefsMenu").Child("PrefsBiface").checked  then
		    MenuBar.Child("PrefsMenu").Child("PrefsBiface").checked = config.stdbiface
		  end if
		  if menumenus.Child("PrefsMenu").Child("PrefsAjust").checked  then
		    MenuBar.Child("PrefsMenu").Child("PrefsAjust").checked = config.Ajust
		  end if
		  if menumenus.Child("HelpMenu").Child("HelpView").checked  then
		    MenuBar.Child("HelpMenu").Child("HelpView").checked = Config.showhelp
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MenuMacros(t as Boolean)
		  dim i as integer
		  
		  MenuMenus.Child("MacrosMenu").Child("MacrosQuit").checked = t
		  MenuMenus.Child("MacrosMenu").Child("MacrosFinaux").checked = t
		  MenuMenus.Child("MacrosMenu").Child("MacrosSave").checked = t
		  MenuMenus.Child("MacrosMenu").Child("MacrosExecute").checked = not t
		  MenuMenus.Child("MacrosMenu").Child("MacrosErase").checked = not t
		  MenuMenus.Child("MacrosMenu").Child("MacrosDescri").checked = not t
		  MenuMenus.Child("MacrosMenu").Child("MacrosClose").checked = not t
		  MenuMenus.Child("MacrosMenu").Child("MacrosCopy").checked = not t
		  EraseMenuBar
		  CopyMenuBar
		  MenuBar.Child("FileMenu").Child("FileOpen").visible=not t
		  MenuBar.Child("FileMenu").Child("FileSave").visible =not t
		  MenuBar.Child("FileMenu").Child("FileSaveAs").visible =not t
		  MenuBar.Child("OperaMenu").Child("OperaCut").visible =not t
		  MenuBar.Child("OperaMenu").Child("OperaMerge").visible =not t
		  MenuBar.Child("OperaMenu").Child("OperaIdentify").visible =not t
		  for i =0 to MenuBar.Child("ToolsMenu").count-1
		    MenuBar.Child("ToolsMenu").Item(i).visible = not t
		  next
		  MenuBar.Child("ToolsMenu").visible = not t
		  for i =0 to MenuBar.Child("PrefsMenu").count-1
		    MenuBar.Child("PrefsMenu").Item(i).visible = not t
		  next
		  MenuBar.Child("PrefsMenu").visible = not t
		  for i =0 to MenuBar.Child("PrefsMenu").count-1
		    MenuBar.Child("PrefsMenu").Item(i).visible = not t
		  next
		  MenuBar.Child("Cfg").visible = not t
		  
		  for i =0 to MenuBar.Child("EditMenu").count-2
		    MenuBar.Child("EditMenu").Item(i).visible = not t
		  next
		  MenuBar.Child("EditMenu").visible = not t
		  for i = 1 to 3
		    MouvBut(i).visible =not t
		  next
		  PushButton1.visible=not t
		  stdbox.visible = not t
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function mousedispo() As Boolean
		  return dret = nil and (CurrentContent.currentoperation = nil or CurrentContent.currentoperation.finished = true)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveBoxRefresh()
		  dim i as integer
		  MoveBox.Visible = false
		  
		  for i=0 to 4
		    MouvBut(i).visible = Config.MvBt(i) and not draphisto
		    MoveBox.Visible = MoveBox.Visible or MouvBut(i) .visible
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NewContent(t as Boolean)
		  dim mitem as MenuItem
		  
		  if (GetNumWindow<>-1) then
		    MenuBar.Child("Fenetres").Item(GetNumWindow).checked = false
		  end if
		  
		  numfig=numfig+1
		  currentContent = new WindContent(numfig)
		  wcontent.Append(currentContent)
		  currentcontent.macrocreation = t
		  currentcontent.Creerrepere
		  mitem = new MenuItem
		  mitem.Name = "winitem"
		  mitem.index = GetNumWindow
		  mitem.Text = Dico.Value("Figure") +"  " + str(numfig)
		  MenuBar.Child("Fenetres").append mitem
		  MenuBar.Child("Fenetres").Item(GetNumWindow).checked = true
		  'MenuBar.Child("PrefsMenu").Child("PrefsPolyg").checked = true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OpenFile(f as Folderitem)
		  dim nc as boolean
		  
		  if  CurrentContent.TheObjects.count > 1 then
		    closefw
		    NewContent(false)
		    nc = true
		  end if
		  
		  if f.Type = "HIST" then
		    CurrentContent.currentoperation = new ReadHisto(f)
		  elseif f.Type = "SAVE" then
		    CurrentContent.CurrentOperation = new Ouvrir(f)
		  else
		    MsgBox Dico.Value("MsgUnfoundable")+ ou + Dico.Value("MsgNovalidFile")
		    if nc then
		      deleteContent
		    end if
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub openformswindow(k as integer, f as integer)
		  closefw
		  CurrentContent.CurrentOperation = nil
		  fw=new FormsWindow(k,f,false)
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PointerPolyg()
		  if not CurrentContent.currentoperation isa readhisto and MenuBar.Child("PrefsMenu").Child("PrefsPolyg") <> nil then
		    MenuBar.Child("PrefsMenu").Child("PrefsPolyg").checked = true
		  end if
		  currentcontent.PolygPointes = true
		  refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReadNomsMouvBut()
		  dim i as integer
		  
		  PushButton1.Caption = Dico.Value("Cancel")
		  MouvBut(0).Caption = Dico.Value("Modify")
		  MouvBut(1).Caption = Dico.Value("Slide")
		  MouvBut(2).Caption = Dico.Value("Turn")
		  MouvBut(3).Caption = Dico.Value("Flip")
		  MouvBut(4).Caption = Dico.Value("Zoom")
		  
		  for i=0 to 4
		    MouvBut(i).HelpTag = MouvBut(i).Caption
		  next
		  PushButton1.HelpTag = PushButton1.caption
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReadStTexts()
		  LibBox.caption = Dico.Value("PrefsFreeForms")
		  StdBox.caption = Dico.Value("PrefsStdForms")
		  MoveBox.caption = Dico.Value("Moves")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Refresh()
		  if not currentcontent.macrocreation then
		    refreshtitle
		    if not draphisto then
		      updatemenu
		    end if
		    updatetoolbar
		    PushButton1.Visible = not draphisto
		    can.RefreshBackground
		    MoveBoxRefresh
		    StdBoxRefresh
		    LibBoxRefresh
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub refreshtitle()
		  if currentcontent.macrocreation then
		    Title=Dico.Value("MacrosCreate") + "*"
		  elseif draphisto then
		    Title =  Rh.Histfile.Name
		  else
		    Title=CurrentContent.GetWindTitle
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetFont()
		  Config.TextSize = 12
		  updateTextSize
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ScreenAdjust()
		  MyCanvas1.Resize
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setcross()
		  if backcolor = blanc then
		    can.mousecursor = cross
		  else
		    can.mousecursor = whitecross
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetIco(Fam as integer, Form As integer)
		  dim i,  h, taille, haut, larg as double
		  dim dlx, dly, urx, ury as double
		  dim specs as StdPolygonSpecifications
		  
		  StdOutil(fam).Visible = fam < Config.nstdfam
		  
		  if not StdOutil(fam).Visible then
		    return
		  end if
		  
		  h = stdoutil(fam).height
		  specs = config.stdfamilies(fam,form)
		  
		  if specs.family = "Cubes"  then
		    ico(fam) = new Cubeskull(new BasicPoint(3, 0.5*h-6), form,1)
		    taille = 0.5*h
		    ico(fam).x = 3
		    ico(fam).y = h-taille-3
		    Cubeskull(ico(fam)).updatesize(taille)
		    ico(fam).fillcolor = config.stdcolor(fam).col
		    if form = 1 then
		      cubeskull(ico(Fam)).Update( new BasicPoint (0.5*h-4,0.5*h-4), 1)
		      taille = 0.4*h
		      Cubeskull(ico(fam)).updatesize(taille)
		    end if
		    if form = 2 then
		      ico(fam).fill = 0
		    end if
		  elseif specs.family = "Rods" then
		    ico(fam) = new Cubeskull(new BasicPoint(3,0.5*h-6), 0, 1)
		    taille = 0.5*h
		    Cubeskull(ico(fam)).updatesize(taille)
		    cubeskull(ico(fam)).updatefillcolor(specs.coul.col,100)
		  elseif  ubound(specs.angles) > 0 then                 'cas des polygonestd
		    ico(Fam) = new LSkull(config.stdfamilies(fam,form))
		    dlx =  LSkull(ico(Fam)).BB.First.x
		    dly =  LSkull(ico(Fam)).BB.first.y
		    urx =  LSkull(ico(Fam)).BB.second.x
		    ury =  LSkull(ico(Fam)).BB.second.y
		    larg = urx - dlx
		    haut = ury-dly
		    taille = 0.8*h/max(larg,haut)
		    LSkull(ico(fam)).UpdateSize(taille)
		    ico(fam).x =  (h-larg*taille)/4
		    if dlx < 0 then
		      ico(fam).x = ico(fam).x-dlx*taille/2
		    end if
		    ico(fam).y =  (h+haut*taille)/4
		    ico(fam).borderwidth = 0.02
		  else                                                    'cas des cerclesstd
		    taille = 0.4*h*specs.distances(0)
		    ico(fam) = new OvalShape
		    ico(fam).borderwidth = 1
		    OvalShape(ico(fam)).width = 2*taille '3*h/4
		    OvalShape(ico(fam)).height = 2*taille ' 3*h/4
		    ico(fam).x = (h -larg*taille)/4
		    ico(fam).y = (h+haut*taille)/4
		  end if                                                         'partie  commune
		  ico(fam).bordercolor = Config.Bordercolor.col
		  ico(fam).border = 100
		  ico(fam).fill = 100
		  if specs.family <> "Rods" then              'la couleur de fond d'une réglette varie avec la longueur, non la famille
		    ico(fam).fillcolor=config.stdcolor(fam).col
		    ico(fam).fill =100
		  end if
		  ico(fam).borderwidth= 1/h
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub settrace(n as integer)
		  if n = 1 then
		    config.trace = true
		  else
		    config.trace = false
		  end if
		  MenuBar.Child("PrefsMenu").Child("PrefsTrace").checked  = config.trace
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StdBoxRefresh()
		  dim i as integer
		  
		  if  Config.ShowStdTools and not draphisto then
		    for i = 0 to config.nstdfam-1
		      if ico(i) = nil then
		        setico(i,0)
		      end if
		      StdOutil(i).visible =true
		    next
		    StdBox.visible = true
		  else
		    StdBox.visible = false
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Switchcolors()
		  dim i , j, k As integer
		  dim s as shape
		  dim coul as couleur
		  
		  
		  Config.Hidecolor = config.Hidecolor.comp
		  config.Fillcolor = config.Fillcolor.comp
		  can.Bkcol = config.fillcolor.col
		  config.Bordercolor = config.Bordercolor.comp
		  config.highlightcolor = config.highlightcolor.comp
		  config.weightlesscolor = config.weightlesscolor.comp
		  config.TransfoColor = config.TransfoColor.comp
		  if backcolor = blanc then
		    backcolor = noir
		  else
		    backcolor = blanc
		  end if
		  
		  s = can.rep
		  for j = 0 to s.labs.count-1
		    coul = new couleur(s.labs.item(i).TextColor)
		    s.labs.item(i).TextColor = coul.comp.col
		  next
		  
		  for i = 1 to CurrentContent.TheObjects.count -1
		    s = CurrentContent.TheObjects.item(i)
		    s.colsw = false
		    for j = 0 to ubound(s.childs)
		      s.childs(j).colsw = false
		    next
		  next
		  
		  for i = 1 to CurrentContent.TheObjects.count -1
		    s = CurrentContent.TheObjects.item(i)
		    if not s.colsw then
		      s.bordercolor = s.bordercolor.comp
		      s.fillcolor = s.fillcolor.comp
		      for j = 0 to s.labs.count-1
		        coul = new couleur(s.labs.item(j).TextColor)
		        s.labs.item(j).Textcolor = coul.comp.col
		      next
		      for j = 0 to ubound(s.childs)
		        if not s.childs(j).colsw then
		          s.childs(j).bordercolor = s.childs(j).bordercolor.comp
		          if s.childs(j).labs.count > 0 then
		            for k = 0 to s.childs(j).labs.count-1
		              coul = new couleur(s.childs(j).labs.item(k).TextColor)
		              s.childs(j).labs.item(k).TextColor = coul.comp.col
		            next
		          end if
		          s.childs(j).colsw = true
		        end if
		      next
		      if s isa polygon then
		        for j = 0 to s.npts-1
		          s.colcotes(j) = s.colcotes(j).comp
		        next
		      end if
		      s.colsw = true
		    end if
		  next
		  for i = 0 to config.nstdfam-1
		    config.stdcolor(i) = config.stdcolor(i).comp
		    'ico(i).updatefillcolor(config.stdcolor(i).col,100)
		  next
		  can.RefreshBackground
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TradMenu()
		  MenuBar.Child("FileMenu").Text = Dico.Value("FileMenu")
		  MenuBar.Child("FileMenu").Child("FileNew").Text = Dico.Value("FileNew")
		  MenuBar.Child("FileMenu").Child("FileOpen").Text = Dico.Value("FileOpen")
		  MenuBar.Child("FileMenu").Child("FileClose").Text = Dico.Value("FileClose")
		  MenuBar.Child("FileMenu").Child("FileSave").Text = Dico.Value("FileSave")
		  MenuBar.Child("FileMenu").Child("FileSaveAs").Text = Dico.Value("FileSaveAs")
		  MenuBar.Child("FileMenu").Child("FileSaveEps").Text = Dico.Value("FileSaveEps")
		  MenuBar.Child("FileMenu").Child("FileSaveBitmap").Text = Dico.Value("FileSaveBitmap")
		  MenuBar.Child("FileMenu").Child("FilePrint").Text = Dico.Value("FilePrint")
		  MenuBar.Child("FileMenu").Child("FileQuit").Text = Dico.Value("FileQuit")
		  MenuBar.Child("Fenetres").Text = Dico.Value("Windows")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatemenu()
		  EraseMenuBar
		  CopyMenuBar
		  ReadNomsMouvBut
		  ReadStTexts
		  TradMenu
		  if MenuBar.Child("PrefsMenu") <> nil then 'correctif pour annuler dans InitWindow
		    if MenuBar.Child("PrefsMenu").Child("PrefsPolyg") <> nil then
		      MenuBar.Child("PrefsMenu").Child("PrefsPolyg").checked  = Config.PolPointes
		    end if
		    if MenuBar.Child("PrefsMenu").Child("PrefsTrace") <> nil then
		      MenuBar.Child("PrefsMenu").Child("PrefsTrace").checked  = config.trace
		    end if
		    if MenuBar.Child("PrefsMenu").Child("PrefsAjust") <> nil then
		      MenuBar.Child("PrefsMenu").Child("PrefsAjust").checked = Config.Ajust
		    end if
		  end if
		  if  MenuBar.Child("ToolsMenu").Child("ToolsThickness") <> nil then
		    MenuBar.Child("ToolsMenu").Child("ToolsThickness").child("ToolsThick1").checked = true
		  end if
		  updateToolBar
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateSousMenusMacros()
		  CloseSousMenusMacros
		  CreateSousMenusMacros
		  EraseMenuBar
		  CopyMenuBar
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub updateTextSize()
		  dim i as integer
		  
		  PushButton1.TextSize = Config.TextSize
		  
		  for i = 0 to 4
		    MouvBut(i).TextSize = config.TextSize
		  next
		  
		  if fw <> nil then
		    fw.updateTextSize
		  end if
		  
		  MyCanvas1.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateToolBar()
		  dim espace as integer
		  dim st as string
		  
		  espace = min((me.Height-me.MinHeight)/3,5)
		  if(me.Height = me.MinHeight) then
		    MoveBox.TextSize = 8
		    StdBox.TextSize = 8
		    LibBox.TextSize = 8
		    espace = espace+2
		  else
		    MoveBox.TextSize = 0
		    StdBox.TextSize = 0
		    LibBox.TextSize = 0
		  end if
		  MoveBox.Top = 60+espace
		  StdBox.top = MoveBox.top+MoveBox.Height+espace
		  LibBox.Top = StdBox.top+StdBox.Height+espace
		  st = config.menu
		  if st = "Menu_A" then
		    Tools.FillColor = &c000088
		  elseif st = "Menu_B" then
		    Tools.FillColor = &c008800
		  elseif st = "Menu_C" then
		    Tools.FillColor = &c880000
		  elseif st = "Menu_AB" then
		    Tools.FillColor = &c888800
		  elseif st = "Menu_AC" then
		    Tools.FillColor = &c880088
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
		Base As Menuitem
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Cerc As OvalSkull
	#tag EndProperty

	#tag Property, Flags = &h0
		drapdim As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		draphisto As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Drapico As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drappt As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		DrapResel As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Drapshowall As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drapstdcolor As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Form As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		fw As Formswindow
	#tag EndProperty

	#tag Property, Flags = &h0
		hh As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Ico(4) As Object2D
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Kit As string
	#tag EndProperty

	#tag Property, Flags = &h0
		nlib As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ntemp As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		numfig As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		quitting As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		rh As ReadHisto
	#tag EndProperty

	#tag Property, Flags = &h0
		Sans_titre As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Seg As segskull
	#tag EndProperty

	#tag Property, Flags = &h0
		SelectedTool As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		selshape As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		stdflag As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		tw As Textwindow
	#tag EndProperty

	#tag Property, Flags = &h0
		Version As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		wcontent(-1) As WindContent
	#tag EndProperty


#tag EndWindowCode

#tag Events MoveBox
	#tag Event
		Sub Open()
		  MoveBoxRefresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events MouvBut
	#tag Event
		Sub Action(index as Integer)
		  if CurrentContent.TheObjects.count = 1 then
		    return
		  end if
		  
		  
		  if mousedispo then
		    closefw
		    select case index
		    case 0
		      if currentcontent.Thefigs.count > 0 then
		        CurrentContent.CurrentOperation = new modifier()
		      end if
		    case 1
		      CurrentContent.CurrentOperation = new Glisser()
		    case 2
		      CurrentContent.CurrentOperation = new tourner()
		    case 3
		      CurrentContent.CurrentOperation = new retourner()
		    case 4
		      CurrentContent.CurrentOperation = new redimensionner()
		    end select
		    refreshtitle
		    if index <> 0 then
		      can.mousecursor = System.Cursors.StandardPointer
		    else
		      wnd.setcross
		    end if
		    SetFocus
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events StdBox
	#tag Event
		Sub Open()
		  StdBoxRefresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events StdOutil
	#tag Event
		Sub MouseUp(index as Integer, X As Integer, Y As Integer)
		  dim c as color
		  
		  if app.quitting then
		    return
		  end if
		  closefw
		  
		  if not Config.ShowStdTools then
		    return
		  end if
		  
		  Kit = "Standard"
		  
		  me.SetFocus
		  
		  if drapstdcolor then
		    c = Config.stdcolor(index).col
		    if selectcolor(c, "Choisis une  couleur") then
		      Config.stdcolor(index) = new couleur(c)
		    end if
		    setico(index,0)
		    stdoutil(index).refresh
		    drapstdcolor = false
		  else
		    selectedTool = index
		    drapico = true
		    openformswindow(0,SelectedTool)
		  end if
		  
		End Sub
	#tag EndEvent
	#tag Event
		Function MouseDown(index as Integer, X As Integer, Y As Integer) As Boolean
		  if mousedispo then
		    return true
		  end if
		End Function
	#tag EndEvent
	#tag Event
		Sub Paint(index as Integer, g As Graphics, areas() As REALbasic.Rect)
		  dim fs as figureshape
		  if index < Config.nstdfam then
		    g.ForeColor = RGB(255,255,255)
		    g.FillRect(0,0,g.Width,g.Height)
		    if  ico(index) isa cubeskull  then
		      cubeskull(ico(index)).paint(g)
		    else
		      g.drawobject ico(index), ico(index).x, ico(index).y
		    end if
		  end if
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open(index as Integer)
		  setIco(index,0)
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton1
	#tag Event
		Sub Action()
		  if dret = nil then
		    if currentcontent.currentoperation <> nil then
		      currentcontent.currentoperation.Annuler
		      if CurrentContent.CurrentOp = 0 then
		        me.Enabled = false
		      end if
		    else
		      currentcontent.undolastoperation
		    end if
		  end if
		  'setfocus
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseEnter()
		  dim EL, EL1, EL2, EL3 as XMLElement
		  dim Name, Type as string
		  dim op, op1 as integer
		  dim n1, n2, n3 as integer
		  
		  if currentcontent.currentop = 0 or currentcontent.currentoperation = nil then
		    return
		  end if
		  
		  currentcontent.currentoperation.canceling = true
		  EL = currentcontent.OpToCancel
		  EL1 = XMLElement(EL.firstchild)
		  
		  if EL = nil  or EL1 = nil then
		    return
		  end if
		  
		  op = val(EL.GetAttribute("OpId"))
		  Name = EL.GetAttribute(Dico.Value("Type")) + EL1.GetAttribute("Type")
		  me.Helptag = Dico.Value("Cancel") + " " + lowercase(Name)
		  n1 =val(EL1.GetAttribute("Id"))
		  selshape = currentcontent.TheObjects.GetShape(n1)
		  
		  
		  select case op
		  case 19 //Dupliquer
		    EL2 = XMLElement(EL1.firstchild)
		    EL3 = XMLElement(EL2.firstchild)
		    if EL3 <> nil then
		      Type = EL3.GetAttribute("Type") '+ " n°" + 
		      n1 = val(EL2.GetAttribute("Id"))
		      selshape = currentcontent.TheObjects.GetShape(n1)
		    end if
		  end select
		  selshape.highlight
		  me.Helptag = me.Helptag + " "+  lowercase(Type)
		  can.refreshbackground
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseExit()
		  if selshape <> nil then
		    currentcontent.TheObjects.unhighlightall
		    can.refreshbackground
		  end if
		  if currentcontent.currentoperation <> nil then
		    currentcontent.currentoperation.canceling = false
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events LibBox
	#tag Event
		Sub Open()
		  LibBoxRefresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events LibOutils
	#tag Event
		Function MouseDown(index as Integer, X As Integer, Y As Integer) As Boolean
		  if mousedispo then
		    if selectedtool = 0 and fw = nil then
		      selectedtool = -1
		      liboutils(0).refresh
		    end if
		    closefw
		    return true
		  end if
		End Function
	#tag EndEvent
	#tag Event
		Sub MouseUp(index as Integer, X As Integer, Y As Integer)
		  
		  if mousedispo then
		    Me.SetFocus
		    selectedTool = index
		    Kit = "Libre"
		    if selectedtool <> 0 then
		      openformswindow(1, selectedtool)
		    else
		      CurrentContent.CurrentOperation=new ShapeConstruction(selectedtool, 0)  'cas du point
		    end if
		  end if
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseExit(index as Integer)
		  refreshtitle
		End Sub
	#tag EndEvent
	#tag Event
		Sub Paint(index as Integer, g As Graphics, areas() As REALbasic.Rect)
		  
		  me.Visible = Config.nlibvis(index) or (index = 6 and CurrentContent <> nil and CurrentContent.TheGrid <> nil)
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
		Name="drapdim"
		Group="Behavior"
		Type="boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="draphisto"
		Group="Behavior"
		Type="boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Drapico"
		Group="Behavior"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="drappt"
		Group="Behavior"
		Type="boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="DrapResel"
		Group="Behavior"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Drapshowall"
		Group="Behavior"
		Type="boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="drapstdcolor"
		Group="Behavior"
		Type="boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Form"
		Group="Behavior"
		Type="integer"
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
		Name="hh"
		Group="Behavior"
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
		Name="nlib"
		Group="Behavior"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ntemp"
		Group="Behavior"
		Type="integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="numfig"
		Group="Behavior"
		InitialValue="0"
		Type="Integer"
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
		Name="quitting"
		Group="Behavior"
		Type="Boolean"
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
		Name="Sans_titre"
		Group="Behavior"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="SelectedTool"
		Group="Behavior"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="stdflag"
		Group="Behavior"
		Type="boolean"
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
		Name="Version"
		Group="Behavior"
		Type="integer"
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
