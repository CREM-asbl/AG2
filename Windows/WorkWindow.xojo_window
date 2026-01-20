#tag DesktopWindow
Begin DesktopWindow WorkWindow
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF00
   Composite       =   True
   DefaultLocation =   0
   FullScreen      =   False
   HasBackgroundColor=   True
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   595
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   -1173617590
   MenuBarVisible  =   True
   MinimumHeight   =   595
   MinimumWidth    =   800
   Resizeable      =   True
   Title           =   "Sans Titre"
   Type            =   0
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
      drapCH          =   False
      drapzone        =   False
      Enabled         =   True
      Height          =   595
      HelpMess        =   False
      HelpTag         =   ""
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
      OKMess          =   False
      scaling         =   0.0
      Scope           =   0
      side            =   0
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
   Begin DesktopRectangle Tools
      AllowAutoDeactivate=   True
      BorderColor     =   &c000000
      BorderThickness =   1.0
      CornerSize      =   16.0
      Enabled         =   True
      FillColor       =   &c80808000
      Height          =   595
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
      Tooltip         =   ""
      Top             =   0
      Transparent     =   False
      Visible         =   True
      Width           =   122
      Begin DesktopGroupBox MoveBox
         AllowAutoDeactivate=   True
         Bold            =   True
         Caption         =   "Mouvements"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   152
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
         Tooltip         =   ""
         Top             =   59
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   112
         Begin DesktopButton MouvBut
            AllowAutoDeactivate=   True
            Bold            =   True
            Cancel          =   False
            Caption         =   "Tourner"
            Default         =   False
            Enabled         =   True
            FontName        =   "System"
            FontSize        =   0.0
            FontUnit        =   0
            Height          =   30
            Index           =   2
            InitialParent   =   "MoveBox"
            Italic          =   False
            Left            =   7
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            MacButtonStyle  =   0
            Scope           =   0
            TabIndex        =   0
            TabPanelIndex   =   0
            TabStop         =   True
            Tooltip         =   ""
            Top             =   112
            Transparent     =   False
            Underline       =   False
            Visible         =   True
            Width           =   108
         End
         Begin DesktopButton MouvBut
            AllowAutoDeactivate=   True
            Bold            =   True
            Cancel          =   False
            Caption         =   "Retourner"
            Default         =   False
            Enabled         =   True
            FontName        =   "System"
            FontSize        =   0.0
            FontUnit        =   0
            Height          =   30
            Index           =   3
            InitialParent   =   "MoveBox"
            Italic          =   False
            Left            =   7
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            MacButtonStyle  =   0
            Scope           =   0
            TabIndex        =   1
            TabPanelIndex   =   0
            TabStop         =   True
            Tooltip         =   ""
            Top             =   142
            Transparent     =   False
            Underline       =   False
            Visible         =   True
            Width           =   108
         End
         Begin DesktopButton MouvBut
            AllowAutoDeactivate=   True
            Bold            =   True
            Cancel          =   False
            Caption         =   "Zoomer"
            Default         =   False
            Enabled         =   True
            FontName        =   "System"
            FontSize        =   0.0
            FontUnit        =   0
            Height          =   30
            Index           =   4
            InitialParent   =   "MoveBox"
            Italic          =   False
            Left            =   7
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            MacButtonStyle  =   0
            Scope           =   0
            TabIndex        =   2
            TabPanelIndex   =   0
            TabStop         =   True
            Tooltip         =   ""
            Top             =   172
            Transparent     =   False
            Underline       =   False
            Visible         =   True
            Width           =   108
         End
         Begin DesktopButton MouvBut
            AllowAutoDeactivate=   True
            Bold            =   True
            Cancel          =   False
            Caption         =   "Glisser"
            Default         =   False
            Enabled         =   True
            FontName        =   "System"
            FontSize        =   0.0
            FontUnit        =   0
            Height          =   30
            Index           =   1
            InitialParent   =   "MoveBox"
            Italic          =   False
            Left            =   7
            LockBottom      =   False
            LockedInPosition=   False
            LockLeft        =   False
            LockRight       =   False
            LockTop         =   False
            MacButtonStyle  =   0
            Scope           =   0
            TabIndex        =   3
            TabPanelIndex   =   0
            TabStop         =   True
            Tooltip         =   ""
            Top             =   82
            Transparent     =   False
            Underline       =   False
            Visible         =   True
            Width           =   108
         End
      End
      Begin DesktopGroupBox StdBox
         AllowAutoDeactivate=   True
         Bold            =   True
         Caption         =   "Formes Standard"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   135
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
         Tooltip         =   ""
         Top             =   215
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   112
         Begin DesktopCanvas StdOutil
            AllowAutoDeactivate=   True
            AllowFocus      =   False
            AllowFocusRing  =   True
            AllowTabs       =   False
            Backdrop        =   0
            Enabled         =   True
            Height          =   50
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
            Tooltip         =   ""
            Top             =   292
            Transparent     =   True
            Visible         =   True
            Width           =   50
         End
         Begin DesktopCanvas StdOutil
            AllowAutoDeactivate=   True
            AllowFocus      =   False
            AllowFocusRing  =   True
            AllowTabs       =   False
            Backdrop        =   0
            Enabled         =   True
            Height          =   50
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
            Tooltip         =   ""
            Top             =   240
            Transparent     =   True
            Visible         =   True
            Width           =   50
         End
         Begin DesktopCanvas StdOutil
            AllowAutoDeactivate=   True
            AllowFocus      =   False
            AllowFocusRing  =   True
            AllowTabs       =   False
            Backdrop        =   0
            Enabled         =   True
            Height          =   50
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
            Tooltip         =   ""
            Top             =   292
            Transparent     =   True
            Visible         =   True
            Width           =   50
         End
         Begin DesktopCanvas StdOutil
            AllowAutoDeactivate=   True
            AllowFocus      =   False
            AllowFocusRing  =   True
            AllowTabs       =   False
            Backdrop        =   0
            Enabled         =   True
            Height          =   50
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
            Tooltip         =   ""
            Top             =   240
            Transparent     =   True
            Visible         =   True
            Width           =   50
         End
      End
      Begin DesktopGroupBox LibBox
         AllowAutoDeactivate=   True
         Bold            =   True
         Caption         =   "Formes Libres"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   238
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
         Tooltip         =   ""
         Top             =   352
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   112
         Begin DesktopCanvas LibOutils
            AllowAutoDeactivate=   True
            AllowFocus      =   False
            AllowFocusRing  =   True
            AllowTabs       =   False
            Backdrop        =   326336511
            Enabled         =   True
            Height          =   50
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
            Tooltip         =   ""
            Top             =   433
            Transparent     =   True
            Visible         =   True
            Width           =   50
         End
         Begin DesktopCanvas LibOutils
            AllowAutoDeactivate=   True
            AllowFocus      =   False
            AllowFocusRing  =   True
            AllowTabs       =   False
            Backdrop        =   419098623
            Enabled         =   True
            Height          =   50
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
            Tooltip         =   ""
            Top             =   485
            Transparent     =   True
            Visible         =   True
            Width           =   50
         End
         Begin DesktopCanvas LibOutils
            AllowAutoDeactivate=   True
            AllowFocus      =   False
            AllowFocusRing  =   True
            AllowTabs       =   False
            Backdrop        =   1273780223
            Enabled         =   True
            Height          =   50
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
            Tooltip         =   ""
            Top             =   537
            Transparent     =   True
            Visible         =   True
            Width           =   50
         End
         Begin DesktopCanvas LibOutils
            AllowAutoDeactivate=   True
            AllowFocus      =   False
            AllowFocusRing  =   True
            AllowTabs       =   False
            Backdrop        =   2141171711
            Enabled         =   True
            Height          =   50
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
            Tooltip         =   ""
            Top             =   381
            Transparent     =   True
            Visible         =   True
            Width           =   50
         End
         Begin DesktopCanvas LibOutils
            AllowAutoDeactivate=   True
            AllowFocus      =   False
            AllowFocusRing  =   True
            AllowTabs       =   False
            Backdrop        =   834662399
            Enabled         =   True
            Height          =   50
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
            Tooltip         =   ""
            Top             =   433
            Transparent     =   True
            Visible         =   True
            Width           =   50
         End
         Begin DesktopCanvas LibOutils
            AllowAutoDeactivate=   True
            AllowFocus      =   False
            AllowFocusRing  =   True
            AllowTabs       =   False
            Backdrop        =   680357887
            Enabled         =   True
            Height          =   50
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
            Tooltip         =   ""
            Top             =   485
            Transparent     =   True
            Visible         =   True
            Width           =   50
         End
         Begin DesktopCanvas LibOutils
            AllowAutoDeactivate=   True
            AllowFocus      =   False
            AllowFocusRing  =   True
            AllowTabs       =   False
            Backdrop        =   1333702655
            Enabled         =   True
            Height          =   50
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
            Tooltip         =   ""
            Top             =   381
            Transparent     =   True
            Visible         =   True
            Width           =   50
         End
      End
      Begin DesktopButton MouvBut
         AllowAutoDeactivate=   True
         Bold            =   True
         Cancel          =   False
         Caption         =   "Modifier"
         Default         =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   30
         Index           =   0
         InitialParent   =   "Tools"
         Italic          =   False
         Left            =   5
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   False
         LockTop         =   False
         MacButtonStyle  =   0
         Scope           =   0
         TabIndex        =   4
         TabPanelIndex   =   0
         TabStop         =   True
         Tooltip         =   ""
         Top             =   33
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   112
      End
      Begin DesktopButton PushButton1
         AllowAutoDeactivate=   True
         Bold            =   True
         Cancel          =   False
         Caption         =   "Annuler"
         Default         =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   30
         Index           =   -2147483648
         InitialParent   =   "Tools"
         Italic          =   False
         Left            =   5
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   False
         LockRight       =   False
         LockTop         =   False
         MacButtonStyle  =   0
         Scope           =   0
         TabIndex        =   5
         TabPanelIndex   =   0
         TabStop         =   True
         Tooltip         =   ""
         Top             =   3
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   112
      End
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Function CancelClosing(appQuitting As Boolean) As Boolean
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
		Sub Closing()
		  HistCmd.close
		End Sub
	#tag EndEvent

	#tag Event
		Sub DropObject(obj As DragItem, action As DragItem.Types)
		  if obj.FolderItem <> nil then
		    OpenFile(obj.FolderItem)
		  else
		    MsgBox Dico.Value("MsgUnfoundable")+ ou + Dico.Value("MsgNovalidFile")
		  end if

		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(key As String) As Boolean
		  Dim u(-1), s As Integer
		  dim disp, nom as string
		  dim sh as shape

		  setfocus
		  if CurrentContent <> nil and CurrentContent.bugfound then
		    return false
		  end if
		  s = asc(key)


		  select case asc(Key)
		  case 1 'ctrl-shft a  Modifications affines
		    currentcontent.drapaff = not currentcontent.drapaff
		    currentcontent.drapeucli = false
		  case 5 'ctrl-shft e  Modifications euclidiennes
		    currentcontent.drapeucli = not currentcontent.drapeucli
		    currentcontent.drapaff = false
		  case 7 'ctrl-shft g Decomposition d'un polygone
		    drapg = not drapg
		  case  20 ' ctrl-shft t Afficher le currentcontent
		    can.sctxt = nil
		    tw = new TextWindow
		    tw.visible = true
		  case 26 'ctrl-shft z Afficher zone de magnétisme
		    mycanvas1.drapzone = not mycanvas1.drapzone
		  case 32 'barre d'espacement Remplace la mousewheel
		    if  CurrentContent.CurrentOperation <> nil then
		      CurrentContent.currentoperation.MouseWheel
		    elseif Mycanvas1.ctxt then
		      Mycanvas1.ChoixcontextMenu
		    end if
		  case 36 '$ Diminuer décimales
		    if currentcontent.ndec > 0 then
		      currentcontent.ndec = currentcontent.ndec-1
		      mycanvas1.refreshbackground
		    end if
		  case 42 'shft * Augmenter décimales
		    currentcontent.ndec = currentcontent.ndec+1
		    mycanvas1.refreshbackground
		  case 43, 61 'touche + Textes plus grands
		    AugmenteFont
		    refresh
		  case 45 'touche - Textes plus petits
		    DiminueFont
		    refresh
		  case 48, 224 'touche 0 réinitialise taille textes
		    ResetFont
		    refresh
		  case 59    ' ; Afficher fenetre de configuration
		    config
		  case 99  'c Inverser couleurs
		    switchcolors
		  case 100 'd ?
		    drapdim = not drapdim
		  case 101 'e copie d'écran
		    CurrentContent.currentoperation = new SaveBitMap(0,0,mycanvas1.width,mycanvas1.height)
		    CurrentContent.currentoperation = nil
		    refreshtitle
		  case 112 'p' afficher numéros des points
		    drappt = not drappt
		  case 113 'q ?
		    app.quiet = not app.quiet
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
		    CurrentContent.TheObjects.CreateTrace = not  CurrentContent.TheObjects.createTrace
		  case 181 'µ
		    stdflag = not stdflag
		  end select

		  return true


		End Function
	#tag EndEvent

	#tag Event
		Sub Maximized()
		  UpdateToolBar
		End Sub
	#tag EndEvent

	#tag Event
		Sub MenuBarSelected()
		  If CurrentContent <> Nil And ( Not CurrentContent.currentoperation IsA shapeconstruction) Then
		    MyCanvas1.mousecursor = System.Cursors.StandardPointer
		  else
		    setcross
		  end if

		  dim B, B1, B2 as boolean
		  dim item as MenuItem
		  dim i, c, n as integer

		  c = MenuBar.Child("Fenetres").Count
		  n = GetNumWindow
		  if GetNumWindow > -1 and MenuBar.Child("Fenetres").Count > GetNumWindow then
		    MenuBar.Child("Fenetres").MenuAt(GetNumWindow).HasCheckMark = true
		  end if

		  if (MenuBar = HistMenu) then
		    return
		  end if

		  if currentcontent <> nil then
		    MenuBar.Child("FileMenu").Child("FileNew").enabled = not currentcontent.macrocreation
		    MenuBar.Child("FileMenu").Child("FileOpen").enabled =  not currentcontent.macrocreation

		    PushButton1.enabled = currentcontent.currentop > 0

		    if can.rep <> nil then
		      B =  CurrentContent.TheObjects.count > 1
		      B1 = CurrentContent.TheGrid <> nil
		      B2 = can.rep.labs.count > 0
		      B = (B or B1 or B2) and not currentcontent.macrocreation
		      MenuBar.Child("FileMenu").Child("FileSave").Enabled= B  and not CurrentContent.CurrentFileUptoDate
		      MenuBar.Child("FileMenu").Child("FileClose").enabled =   not currentcontent.macrocreation
		      if MenuMenus.Child("EditMenu").Child("EditUndo").HasCheckMark then
		        MenuBar.Child("EditMenu").Child("EditUndo").Enabled = B
		        pushbutton1.enabled = B
		      end if
		      if MenuMenus.Child("EditMenu").Child("EditRedo").HasCheckMark then
		        MenuBar.Child("EditMenu").Child("EditRedo").Enabled = (CurrentContent.currentop < CurrentContent.totaloperation -1)
		      end if
		      if MenuMenus.Child("EditMenu").Child("EditLink").HasCheckMark then
		        MenuBar.Child("EditMenu").Child("EditLink").Enabled = CurrentContent.TheObjects.count > 2
		      end if
		      if MenuMenus.Child("EditMenu").Child("EditUnlink").HasCheckMark then
		        MenuBar.Child("EditMenu").Child("EditUnlink").Enabled = CurrentContent.TheObjects.Groupes.count > 0
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

		    if MenuBar.Child("PrefsMenu") <> nil then

		      if MenuBar.Child("PrefsMenu").child("Fonds") <> nil then
		        MenuBar.Child("PrefsMenu").child("Fonds").child("FondEcranConfigurer").enabled = MyCanvas1.FondsEcran <> nil
		      end if

		      if MenuBar.Child("PrefsMenu").child("PrefsFleches") <> nil then
		        MenuBar.Child("PrefsMenu").Child("PrefsFleches").HasCheckMark  = Config.PolFleches
		      end if
		      if MenuBar.Child("PrefsMenu").Child("PrefsPolyg")<> nil then
		        MenuBar.Child("PrefsMenu").Child("PrefsPolyg").HasCheckMark  = config.polpointes
		      end if
		      MenuBar.Child("PrefsMenu").Child("PrefsTrace").HasCheckMark  = config.trace
		      if MenuBar.Child("PrefsMenu").Child("PrefsArea")<> nil then
		        MenuBar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaArith").HasCheckMark = (config.area = 0)
		        MenuBar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaAlg").HasCheckMark = (config.area = 1)
		      end if
		    end if

		    if MenuBar.child("HelpMenu") <> nil and MenuBar.Child("HelpMenu").Child("HelpView") <> nil then
		      MenuBar.Child("HelpMenu").Child("HelpView").HasCheckMark = Config.showhelp
		    end if
		  end if

		End Sub
	#tag EndEvent

	#tag Event
		Sub Moved()
		  Formswindow.Close
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  InitParams()
		  updateMenu
		  NewContent(false)
		  DrapShowall = false

		  if MenuMenus.Child("EditMenu").Child("EditCopy").HasCheckMark  then
		    DrapResel =  MenuBar.Child("EditMenu").Child("EditReselect").HasCheckMark
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
		Sub Restored()
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
		    Formswindow.close
		    CurrentContent.CurrentOperation = new TransfoConstruction(11)
		    refreshtitle
		  end if
		  return true


		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirDemiTour() As Boolean Handles DefinirDemiTour.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation = new TransfoConstruction(3)
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirDeplacement() As Boolean Handles DefinirDeplacement.Action
		  If mousedispo Then
		    Formswindow.close
		    CurrentContent.CurrentOperation = new TransfoConstruction(10)
		    refreshtitle
		  end if
		  return true


		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirEtirement() As Boolean Handles DefinirEtirement.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation = new TransfoConstruction(9)
		    refreshtitle
		  end if
		  Return True

		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirHomothetie() As Boolean Handles DefinirHomothetie.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation = new TransfoConstruction(7)
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirQuartD() As Boolean Handles DefinirQuartD.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation = new TransfoConstruction(5)
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirQuartG() As Boolean Handles DefinirQuartG.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation = new TransfoConstruction(4)
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirRotation() As Boolean Handles DefinirRotation.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation = new TransfoConstruction(2)
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirSimilitude() As Boolean Handles DefinirSimilitude.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation = new TransfoConstruction(8)
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirSymetrieaxiale() As Boolean Handles DefinirSymetrieaxiale.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation = new TransfoConstruction(6)
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function DefinirTranslation() As Boolean Handles DefinirTranslation.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation = new TransfoConstruction(1)
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditCopy() As Boolean Handles EditCopy.Action
		  if mousedispo then
		    Formswindow.close
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
		    Formswindow.close
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
		    Formswindow.close
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
		    Formswindow.close
		    CurrentContent.CurrentOperation = new Coller
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditRedo() As Boolean Handles EditRedo.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.RedoLastOperation
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditReselect() As Boolean Handles EditReselect.Action
		  MenuBar.Child("EditMenu").Child("EditReselect").HasCheckMark = not MenuBar.Child("EditMenu").Child("EditReselect").HasCheckMark
		  Drapresel = MenuBar.Child("EditMenu").Child("EditReselect").HasCheckMark
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditSelectall() As Boolean Handles EditSelectall.Action
		  if mousedispo then
		    Formswindow.close
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
		    Formswindow.close
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
		  Annuler
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditUnlink() As Boolean Handles EditUnlink.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.currentoperation = nil
		    refreshtitle
		    CurrentContent.CurrentOperation = new Delier
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EpsConvertToPdf() As Boolean Handles EpsConvertToPdf.Action
		  dim sh as new shell
		  dim f, f1 as folderitem
		  dim s, S1 as string
		  dim dlg as new OpenDialog


		  dlg.ActionButtonCaption = "Convertir"
		  dlg.Title = "Choisis un fichier .eps"
		  dlg.Filter = FileAGTypes.EPS

		  f = dlg.ShowModal
		  if f = nil then
		    return true
		  end if
		  s=  f.shellpath
		  if dlg.Result <> nil then
		    #if targetWindows then
		      sh.Execute(f.shellpath)
		      s1 = s.replace(f.name,"")
		      sh.execute("cd "+ s1)
		      sh.execute("epstopdf --nosafer "+s)
		    #elseif targetMacOS then
		      s1 = s.replace("eps","pdf")
		      sh.execute ("pstopdf "+ s +" -o "+s1, f.shellpath)
		    #elseif targetlinux then
		    #Endif
		    s1 = s.replace("eps","pdf")
		    sh.execute(s1)
		  end if
		  Return True

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
		    Formswindow.close
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
		    Formswindow.close
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
		    Formswindow.close
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
		    Formswindow.close
		    CurrentContent.Save
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileSaveAs() As Boolean Handles FileSaveAs.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.SaveAs
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileSaveBitmap() As Boolean Handles FileSaveBitmap.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation = new SaveBitMap
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileSaveEps() As Boolean Handles FileSaveEps.Action
		  if mousedispo then
		    Formswindow.close
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
		    Formswindow.close
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
		Function FondEcranConfigurer() As Boolean Handles FondEcranConfigurer.Action
		  PrefFondEcran.ShowModal
		  Return True

		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function HelpAbout() As Boolean Handles HelpAbout.Action
		  if mousedispo then
		    dim md as MessageDialog
		    Dim b as MessageDialogButton
		    Dim mois() as string
		    dim mess as string

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


		    Formswindow.close
		    md = New MessageDialog
		    md.Title = Dico.value("HelpAbout")
		    md.Icon = 0
		    mess = "Apprenti géomètre v."+App.FullVersion
		    md.Message = mess+EndOfLine+EndofLine+"Copyright CREM "+ App.BuildDate.LongDate + EndofLine +EndofLine+ "Programmation: G. Noël et G. Pliez"
		    b = md.ShowModal
		  end if
		  return true


		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function HelpUG() As Boolean Handles HelpUG.Action
		  dim fi as Folderitem

		  'fi = getfolderitem(Dico.Value("UserGuide")) pas utile pour l'instant car un seul guide et en plus pose problème

		  fi = getfolderitem("Guide Utilisateur AG2.pdf")

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
		    Formswindow.close
		    Config.ShowHelp = not Config.ShowHelp
		    can.RefreshBackground
		    MenuBar.Child("HelpMenu").Child("HelpView").HasCheckMark = Config.showhelp
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function HelpVisit() As Boolean Handles HelpVisit.Action
		  if mousedispo then
		    Formswindow.close
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
		    Formswindow.close
		    f=GetOpenFolderItem(FileAGTypes.Image)
		    if f=nil then
		      return true
		    else
		      mycanvas1.setFondEcran(Picture.Open(f), f.Name)
		      PrefFondEcran.ShowModal
		    end if
		  end if

		  Return True

		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function MacrosChoose(index as Integer) As Boolean Handles MacrosChoose.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation = new MacroExe(index)
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
		  Formswindow.close
		  newcontent(true)
		  MenuMacros(true)
		  can.resize
		  WorkWindow.refreshtitle
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

		  Formswindow.close
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
		    Formswindow.close
		    CurrentContent.CurrentOperation=New ChooseFinal
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

		  Formswindow.close
		  currentcontent.currentoperation = nil
		  refreshtitle
		  dlg = new OpenDialog
		  dlg.InitialDirectory = App.MacFolder
		  dlg.Filter = FileAGTypes.MACR
		  f = dlg.ShowModal

		  if f <> nil then
		    Doc = new XmlDocument(f)
		    mac = new Macro(Doc)
		    app.themacros.addmac mac
		    WorkWindow.updatesousmenusmacros
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

		  Formswindow.close
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
		    Formswindow.close
		    NotesWindow.visible = true
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function OperaClone() As Boolean Handles OperaClone.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation=new Duplicate()
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function OperaCreateCenter() As Boolean Handles OperaCreateCenter.Action
		  if mousedispo then
		    Formswindow.close
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
		    Formswindow.close
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
		    Formswindow.close
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
		    Formswindow.close
		    CurrentContent.CurrentOperation=new Identifier()
		    refreshtitle
		  end if
		  return true


		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function OperaMerge() As Boolean Handles OperaMerge.Action

		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation=new Fusion()
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function OperaProl() As Boolean Handles OperaProl.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation=new Prolonger()
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsAjust() As Boolean Handles PrefsAjust.Action
		  MenuBar.Child("PrefsMenu").Child("PrefsAjust").HasCheckMark = not MenuBar.Child("PrefsMenu").Child("PrefsAjust").HasCheckMark
		  Config.Ajust = MenuBar.Child("PrefsMenu").Child("PrefsAjust").HasCheckMark
		  Return True

		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsAreaAlg() As Boolean Handles PrefsAreaAlg.Action
		  MenuBar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaAlg").HasCheckMark = not MenuBar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaAlg").HasCheckMark
		  if  MenuBar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaAlg").HasCheckMark then
		    config.area = 1
		    MenuBar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaArith").HasCheckMark = false
		  else
		    config.area = 0
		    MenuBar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaArith").HasCheckMark = true
		  end if
		  Return True


		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsAreaArith() As Boolean Handles PrefsAreaArith.Action
		  MenuBar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaArith").HasCheckMark = not MenuBar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaArith").HasCheckMark
		  if  MenuBar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaArith").HasCheckMark then
		    config.area = 0
		    MenuBar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaAlg").HasCheckMark = false
		  else
		    config.area = 1
		    MenuBar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaAlg").HasCheckMark = true
		  end if
		  Return True

		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsBiface() As Boolean Handles PrefsBiface.Action
		  MenuBar.Child("PrefsMenu").Child("PrefsBiface").HasCheckMark = not MenuBar.Child("PrefsMenu").Child("PrefsBiface").HasCheckMark
		  Config.Biface = MenuBar.Child("PrefsMenu").Child("PrefsBiface").HasCheckMark
		  Return True

		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsColorBorder() As Boolean Handles PrefsColorBorder.Action
		  Formswindow.close
		  refreshtitle
		  ConfigcolorChange(True)
		  Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsColorFill() As Boolean Handles PrefsColorFill.Action
		  Formswindow.close
		  refreshtitle
		  configcolorChange(False)

		  Return True


		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsColorStdFam() As Boolean Handles PrefsColorStdFam.Action
		  CurrentContent.currentoperation = Nil
		  Formswindow.close
		  refreshtitle
		  drapstdcolor = true
		  return true



		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsFleches() As Boolean Handles PrefsFleches.Action
		  MenuBar.Child("PrefsMenu").Child("PrefsFleches").HasCheckMark = not MenuBar.Child("PrefsMenu").Child("PrefsFleches").HasCheckMark
		  config.PolFleches = MenuBar.Child("PrefsMenu").Child("PrefsFleches").HasCheckMark
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
		  '"Formes pointees dans le menu et PrefsPolyg dans XojoProject
		  MenuBar.Child("PrefsMenu").Child("PrefsPolyg").HasCheckMark = not MenuBar.Child("PrefsMenu").Child("PrefsPolyg").HasCheckMark
		  config.PolPointes = MenuBar.Child("PrefsMenu").Child("PrefsPolyg").HasCheckMark
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsStdForms() As Boolean Handles PrefsStdForms.Action
		  if mousedispo then
		    CurrentContent.CurrentOperation = nil
		    refreshtitle
		    Formswindow.close
		    StdFormsWindow.ShowModal
		    Refresh
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
		  'Le menu correspondant s'appelle "trajectoire"
		  MenuBar.Child("PrefsMenu").Child("PrefsTrace").HasCheckMark = not MenuBar.Child("PrefsMenu").Child("PrefsTrace").HasCheckMark
		  Config.Trace =MenuBar.Child("PrefsMenu").Child("PrefsTrace").HasCheckMark
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsUAChoix() As Boolean Handles PrefsUAChoix.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation=new Unit(1)
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsUADef() As Boolean Handles PrefsUADef.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation=new Unit(3)
		    refreshtitle
		  end if
		  return true




		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsULChoix() As Boolean Handles PrefsULChoix.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation=new Unit(0)
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function PrefsULDef() As Boolean Handles PrefsULDef.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation=new Unit(2)
		    refreshtitle
		  end if
		  return true




		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsARPlan() As Boolean Handles ToolsARPlan.Action
		  if mousedispo then
		    Formswindow.close
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
		    Formswindow.close
		    CurrentContent.CurrentOperation=new ChangePosition(1)
		    ChangePosition(CurrentContent.Currentoperation).ImmediateDoOperation
		    refreshtitle
		  end if
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
		    Formswindow.close
		    CurrentContent.CurrentOperation = new CreateGrid()
		    Refresh
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsHide() As Boolean Handles ToolsHide.Action
		  If mousedispo Then
		    Formswindow.close
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

		  if mousedispo then
		    Formswindow.close
		    MyCanvas1.Mousecursor = system.cursors.wait
		    if not (Config.username = "Enseignant") then
		      OpenHistWindow.ShowModal
		      f = OpenHistWindow.file
		      OpenHistWindow.close
		    else
		      dlg = new OpenDialog
		      dlg.InitialDirectory = App.DocFolder.Child("Historiques")
		      dlg.Filter = FileAGTypes.HIST
		      f = dlg.ShowModal
		    end if

		    if f<>nil  then
		      OpenFile(f)
		    end if

		    MyCanvas1.Mousecursor = System.Cursors.StandardPointer
		  end if
		  return true

		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsLabel() As Boolean Handles ToolsLabel.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation=new AddLabel()
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsOpq() As Boolean Handles ToolsOpq.Action
		  if mousedispo then
		    Formswindow.close
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
		    Formswindow.close
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
		    Formswindow.close
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
		    Formswindow.close
		    CurrentContent.CurrentOperation = new Epaisseur(Config.Thickness)
		    Epaisseur(CurrentContent.CurrentOperation).ImmediateDoOperation
		    MenuBar.Child("ToolsMenu").Child("ToolsThickness").Child("ToolsThick1").HasCheckMark = true
		    MenuBar.Child("ToolsMenu").Child("ToolsThickness").Child("ToolsThick2").HasCheckMark = false
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsThick2() As Boolean Handles ToolsThick2.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation = new Epaisseur(1.5*Config.Thickness)
		    Epaisseur(CurrentContent.CurrentOperation).ImmediateDoOperation
		    MenuBar.Child("ToolsMenu").Child("ToolsThickness").Child("ToolsThick1").HasCheckMark = false
		    MenuBar.Child("ToolsMenu").Child("ToolsThickness").Child("ToolsThick2").HasCheckMark = true
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsTrace() As Boolean Handles ToolsTrace.Action
		  if mousedispo then
		    Formswindow.close
		    MyCanvas1.ClearOffscreen
		    CurrentContent.CurrentOperation = new Tracer()
		    refreshtitle
		  end if
		  return true


		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ToolsTsp() As Boolean Handles ToolsTsp.Action
		  if mousedispo then
		    Formswindow.close
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
		    Formswindow.close
		    CurrentContent.CurrentOperation=new AppliquerTsf()
		    refreshtitle
		  end if
		  return true
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function TransfosFixedPoints() As Boolean Handles TransfosFixedPoints.Action
		  if mousedispo then
		    Formswindow.close
		    CurrentContent.CurrentOperation=new FixPConstruction
		    refreshtitle
		  end if
		  Return True

		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function TransfosHide() As Boolean Handles TransfosHide.Action
		  if mousedispo then
		    Formswindow.close
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
		Function Vieweps() As Boolean Handles Vieweps.Action
		  Dim sh As New shell
		  sh.ExecuteMode = Shell.ExecuteModes.Asynchronous
		  dim f as folderitem
		  dim s, S1 as string

		  f = GetOpenFolderItem(FileAGTypes.eps)
		  if f <> nil then
		    #if targetWindows then
		      sh.execute(f.shellpath)
		    #elseif targetMacOS then
		      sh.execute ("gs",  f.shellpath)
		    #elseif targetlinux then
		    #Endif
		  end if
		  Return True

		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function winitem(index as Integer) As Boolean Handles winitem.Action
		  dim i as integer
		  dim oldOp as Operation

		  if mousedispo then
		    Formswindow.close
		    if index <> GetNumWindow then
		      oldOp = CurrentContent.CurrentOperation
		      MenuBar.Child("Fenetres").MenuAt(GetNumWindow).HasCheckMark = false
		      CurrentContent = wcontent(index)
		      if oldOp isa ReadHisto then
		        if not CurrentContent.CurrentOperation isa ReadHisto then
		          MenuBar = Menu
		          HistCmd.visible = false
		          WorkWindow.draphisto = false
		          WorkWindow.refreshtitle
		        end if
		      elseif CurrentContent.CurrentOperation isa ReadHisto then
		        MenuBar = HistMenu
		        HistCmd.visible = true
		        WorkWindow.draphisto = true
		        WorkWindow.DisableToolBar
		      elseif CurrentContent.Macrocreation then
		        MenuMacros(true)
		      end if
		      MenuBar.Child("Fenetres").MenuAt(index).HasCheckMark = true
		      can.sctxt = nil
		      refresh
		    end if
		  end if
		  return true

		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h0
		Sub Annuler()
		  If dret  = Nil Then
		    if currentcontent.currentoperation <> nil then
		      currentcontent.currentoperation.Annuler
		      currentcontent.currentoperation = nil
		      refreshtitle
		    else
		      currentcontent.undolastoperation
		    end if
		    PushButton1.enabled = CurrentContent.CurrentOp > 0
		  end if
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
		Sub CloseHisto()
		  HistCmd.close
		  menubar = menu
		  draphisto = false
		  Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CloseMacro()
		  Formswindow.close
		  deletecontent
		  MenuMacros(false)

		  MenuBar.Child("MacrosMenu").Child("MacrosCreate").visible = true
		  MenuBar.Child("MacrosMenu").Child("MacrosLoad").visible = true
		  Config.Trace =MenuBar.Child("PrefsMenu").Child("PrefsTrace").HasCheckMark
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CloseSousMenu(mitem as DesktopMenuItem)
		  dim i as integer

		  for i =  mitem.count-1 downto 0
		    mitem.RemoveMenuAt i
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CloseSousMenusMacros()
		  dim mitem as Desktopmenuitem

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
		Sub config()
		  ConfigWindow.showmodal

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub configcolorchange(t as boolean)
		  Formswindow.close
		  CurrentContent.CurrentOperation = Nil
		  refreshtitle
		  Var col As Color



		  If Color.SelectedFromDialog(col,"Choisir une couleur") Then
		    If t  Then
		      config.bordercolor = New couleur(col)
		    Else
		      config.FillColor = New Couleur(col)
		      config.fill = 100
		    End If
		  End If

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CopyCFGMenu()
		  dim mitem,sm as DesktopMenuItem

		  if Config.pwok then
		    mitem = new MenuItem
		    mitem.Name = "Cfg"
		    mitem.Text = Dico.Value("Cfg")
		    sm = new DesktopMenuItem 'sous-menu nécessaire pour fonctionner sur Mac
		    sm.Name = "CfgOpen"
		    sm.Text = Dico.Value("Customize")
		    mitem.AddMenu sm
		    MenuBar.AddMenu mitem
		  end if


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CopyMenuBar()
		  dim i, nmen as integer
		  dim mitem as DesktopMenuItem

		  nmen = MenuMenus.count
		  for i = 0 to nmen-1
		    mitem = CopyMenuItem(MenuMenus.MenuAt(i))
		    if mitem <> nil then
		      MenuBar.AddMenu mitem
		    end if
		  next
		  CopyCFGMenu

		  if config.ajust then
		    menubar.Child("PrefsMenu").Child("PrefsAjust").HasCheckMark = true
		  end if

		  if config.menu = "Menu_C" or config.menu = "Menu_AC" then
		    if config.area = 0  then
		      menubar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaArith").HasCheckMark = true
		    else
		      menubar.Child("PrefsMenu").Child("PrefsArea").Child("PrefsAreaAlg").HasCheckMark = true
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CopyMenuItem(mitem as DesktopMenuItem) As DesktopMenuItem
		  dim item, jtem as DesktopMenuitem
		  dim i, nitem as integer


		  item = new MenuItem
		  item.Name = mitem.Name
		  item.ShortCut = mitem.ShortCut
		  item.index = mitem.index

		  item.Text = Dico.Value(item.Name)

		  if item.Text = item.name then
		    item.Text = mitem.Text
		  end if

		  if item.name = "PrefsFreeForms" then
		    return nil
		  end if

		  nitem = mitem.count

		  if nitem = 0 then
		    if mitem.HasCheckMark then
		      return item
		    else
		      return nil
		    end if
		  else
		    for i = 0 to nitem-1
		      jtem = CopyMenuItem(mitem.MenuAt(i))
		      if jtem <> nil then
		        item.AddMenu jtem
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
		Sub CreateSousMenu(muitem as DesktopMenuItem, nom as string)
		  dim i as integer
		  dim mitem as DesktopMenuItem

		  for i = 0 to app.themacros.count-1
		    mitem = new desktopMenuItem
		    mitem.Name = nom
		    mitem.index  = i
		    mitem.HasCheckMark = true
		    muitem.AddMenu mitem
		    mitem.Text = app.TheMacros.item(i).caption
		  next


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateSousMenusMacros()
		  dim mitem as DesktopMenuItem

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

		    if val = 1 then
		      CurrentContent.Save
		      if CurrentContent.Currentfile = nil then
		        val = -1
		      end if
		    end if

		    if val = -1 then
		      return
		    end if
		  end if

		  n = GetNumWindow

		  wcontent.Remove(n)

		  if n < MenuBar.Child("Fenetres").Count then
		    MenuBar.Child("Fenetres").RemoveMenuAt(n)
		  end if

		  if ubound(wcontent) >= n then
		    for i=n to UBound (wcontent)
		      MenuBar.Child("Fenetres").MenuAt(i).index = i
		    next
		    CurrentContent = wcontent(n)
		  elseif ubound(wcontent) >-1 then
		    currentcontent = wcontent(ubound(wcontent))
		  else
		    CurrentContent = nil
		  end if
		  if CurrentContent <> nil then
		    MenuBar.Child("Fenetres").MenuAt(GetNumWindow).HasCheckMark = true
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
		Sub EraseMenuBar()
		  dim i, n as integer
		  n = menubar.count

		  for i = n-1 downto 2
		    menubar.RemoveMenuAt i
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMenuItem(menu as string, sousmenu as string) As Boolean
		  Return MenuMenus.Child(menu).Child(sousmenu).HasCheckMark
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
		Sub InitParams()
		  can = mycanvas1

		  width = screen(0).width -120
		  height = screen(0).height

		  title = Config.username
		  AcceptFileDrop(FileAGTypes.SAVE)
		  AcceptFileDrop(FileAGTypes.HIST)

		  'Les couleurs sont au départ dans Config

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LibBoxRefresh()
		  LibBox.Visible = (Config.ShowTools and not draphisto) or (CurrentContent <> nil and CurrentContent.TheGrid <>nil)
		  if LibBox.Visible then
		    dim i as integer
		    for i=0 to 6
		      LibOutils(i).Visible =  Config.nlibvis(i) or (i = 6 and CurrentContent <> nil and CurrentContent.TheGrid <> nil)
		    next
		  end if
		  LibBox.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Manageprefs()
		  if menumenus.Child("PrefsMenu").Child("PrefsTrace").HasCheckMark  then
		    MenuBar.Child("PrefsMenu").Child("PrefsTrace").HasCheckMark = config.trace
		  end if
		  if menumenus.Child("PrefsMenu").Child("PrefsPolyg").HasCheckMark  then
		    MenuBar.Child("PrefsMenu").Child("PrefsPolyg").HasCheckMark = config.polpointes
		  end if
		  if menumenus.Child("PrefsMenu").Child("PrefsBiface").HasCheckMark  then
		    MenuBar.Child("PrefsMenu").Child("PrefsBiface").HasCheckMark = config.biface
		  end if
		  if menumenus.Child("PrefsMenu").Child("PrefsAjust").HasCheckMark  then
		    MenuBar.Child("PrefsMenu").Child("PrefsAjust").HasCheckMark = config.Ajust
		  end if
		  if menumenus.Child("HelpMenu").Child("HelpView").HasCheckMark  then
		    MenuBar.Child("HelpMenu").Child("HelpView").HasCheckMark = Config.showhelp
		  end if


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MenuMacros(t as Boolean)
		  dim i as integer

		  MenuMenus.Child("MacrosMenu").Child("MacrosQuit").HasCheckMark = t
		  MenuMenus.Child("MacrosMenu").Child("MacrosFinaux").HasCheckMark = t
		  MenuMenus.Child("MacrosMenu").Child("MacrosSave").HasCheckMark = t
		  MenuMenus.Child("MacrosMenu").Child("MacrosExecute").HasCheckMark = not t
		  MenuMenus.Child("MacrosMenu").Child("MacrosErase").HasCheckMark = not t
		  MenuMenus.Child("MacrosMenu").Child("MacrosDescri").HasCheckMark = not t
		  MenuMenus.Child("MacrosMenu").Child("MacrosClose").HasCheckMark = not t
		  MenuMenus.Child("MacrosMenu").Child("MacrosCopy").HasCheckMark = not t
		  EraseMenuBar
		  CopyMenuBar
		  'MenuBar.Child("FileMenu").Child("FileOpen").visible = not t
		  'MenuBar.Child("FileMenu").Child("FileSave").visible = not t
		  'MenuBar.Child("FileMenu").Child("FileSaveAs").visible = not t
		  'MenuBar.Child("OperaMenu").Child("OperaCut").visible = not t
		  'MenuBar.Child("OperaMenu").Child("OperaMerge").visible = not t
		  '
		  'if MenuBar.Child("OperaMenu").Child("OperaIdentify") <> nil then
		  'MenuBar.Child("OperaMenu").Child("OperaIdentify").visible = not t
		  'end if
		  '
		  'for i = 0 to MenuBar.Child("ToolsMenu").count-1
		  'MenuBar.Child("ToolsMenu").Item(i).visible = not t
		  'next
		  'MenuBar.Child("ToolsMenu").visible = not t
		  '
		  '
		  'for i = 0 to MenuBar.Child("PrefsMenu").count-1
		  'MenuBar.Child("PrefsMenu").Item(i).visible = not t
		  'next
		  'MenuBar.Child("PrefsMenu").visible = not t
		  '
		  'MenuBar.Child("Cfg").visible = false
		  '
		  'for i = 0 to MenuBar.Child("EditMenu").count-2
		  'MenuBar.Child("EditMenu").Item(i).visible = not t
		  'next
		  'MenuBar.Child("EditMenu").visible = not t

		  for i = 1 to 3
		    MouvBut(i).visible = not t
		  next
		  PushButton1.visible = not t
		  stdbox.visible = not t

		  Exception err
		    var d as Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("i",i)
		    err.message = err.message + d.getString
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function mousedispo() As Boolean
		  return  dret = nil and (CurrentContent.currentoperation = nil or CurrentContent.currentoperation.finished = true)
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
		    MenuBar.Child("Fenetres").MenuAt(GetNumWindow).HasCheckMark = false
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
		  MenuBar.Child("Fenetres").AddMenu mitem
		  MenuBar.Child("Fenetres").MenuAt(GetNumWindow).HasCheckMark = true

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OpenFile(f as Folderitem)
		  dim nc as boolean

		  if  CurrentContent.TheObjects.count > 1 then
		    Formswindow.close
		    NewContent(false)
		    nc = true
		  end if

		  if f.Type = "HIST" then
		    CurrentContent.currentoperation = new ReadHisto(f)
		  elseif f.Type = "SAVE" then
		    CurrentContent.CurrentOperation = new Ouvrir(f)
		  else
		    MsgBox Dico.Value("MsgNovalidFile")
		    if nc then
		      deleteContent
		    end if
		  end if




		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PointerPolyg()
		  config.PolPointes = true
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
		    MouvBut(i).Tooltip = MouvBut(i).Caption
		  next
		  PushButton1.Tooltip = PushButton1.caption




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
		    PushButton1.enabled = CurrentContent.CurrentOp > 0
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
		  if BackgroundColor = blanc then
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

		  if specs.family = "Cubes"   then
		    ico(fam) = new Cubeskull(new BasicPoint(3, 0.5*h-6), form,1)
		    taille = 0.5*h
		    ico(fam).x = 3
		    ico(fam).y = h-taille-3
		    Cubeskull(ico(fam)).updatesize(taille)
		    ico(fam).fillcolor = config.stdcolor(fam).col
		    if form = 1 then
		      ico(fam) = new Cubeskull(new BasicPoint (0.5*h-2,h-4), form,1)
		      taille = 0.4*h
		      Cubeskull(ico(fam)).updatesize(taille)
		    end if
		    previousform = form
		  elseif specs.family = "Rods" then
		    ico(fam) = new Cubeskull(new BasicPoint(3,0.5*h-6), 0, 1)
		    taille = 0.5*h
		    ico(fam).x = 3
		    ico(fam).y = h-taille-3
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
		  if specs.family = "Cubes" and form = 2 then
		    ico(fam).fill = 0
		  else
		    ico(fam).fill = 100
		  end if
		  if specs.family <> "Rods" then              'la couleur de fond d'une réglette varie avec la longueur, non la famille
		    ico(fam).fillcolor = config.stdcolor(fam).col
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


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StdBoxRefresh()
		  dim i as integer

		  if  Config.ShowStdTools and not draphisto then
		    for i = 0 to 3
		      if ( i < config.nstdfam ) then
		        setico(i,0)
		        StdOutil(i).visible = true
		      else
		        StdOutil(i).visible = false
		      end if
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
		  if BackgroundColor = blanc then
		    BackgroundColor = noir
		  else
		    BackgroundColor = blanc
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

		  PushButton1.FontSize = Config.TextSize

		  for i = 0 to 4
		    MouvBut(i).FontSize = config.TextSize
		  next

		  MyCanvas1.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateToolBar()
		  dim espace as integer
		  dim st as string

		  espace = min((me.Height-me.MinimumHeight)/3,5)
		  if(me.Height = me.MinimumHeight) then
		    MoveBox.FontSize = 8
		    StdBox.FontSize = 8
		    LibBox.FontSize = 8
		    espace = espace+2
		  else
		    MoveBox.FontSize = 0
		    StdBox.FontSize = 0
		    LibBox.FontSize = 0
		  end if
		  MoveBox.Top = 60+espace
		  StdBox.top = MoveBox.top+MoveBox.Height+espace
		  LibBox.Top = StdBox.top+StdBox.Height+espace
		  st = config.menu
		  if st = "Menu_A" then
		    Tools.FillColor = &cabcdef
		  elseif st = "Menu_B" then
		    Tools.FillColor = &cabefcd
		  elseif st = "Menu_C" then
		    Tools.FillColor = &cefabcd
		  elseif st = "Menu_AB" then
		    Tools.FillColor = &cefefab
		  elseif st = "Menu_AC" then
		    Tools.FillColor = &cefefef
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
		Base As DesktopMenuItem
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Cerc As OvalSkull
	#tag EndProperty

	#tag Property, Flags = &h0
		drapdim As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drapg As boolean
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
		pix As PixmapShape
	#tag EndProperty

	#tag Property, Flags = &h0
		previousform As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		quitting As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		rh As ReadHisto
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
		Sub Opening()
		  MoveBoxRefresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events MouvBut
	#tag Event
		Sub Pressed(index as Integer)
		  If CurrentContent.TheObjects.count = 1 and CurrentContent.thegrid = nil Then
		    return
		  end if

		  If mousedispo Then
		    Formswindow.close
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
		      WorkWindow.setcross
		    end if
		    SetFocus
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events StdBox
	#tag Event
		Sub Opening()
		  StdBoxRefresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events StdOutil
	#tag Event
		Sub MouseUp(index as Integer, x As Integer, y As Integer)
		  dim c as color

		  if app.quitting then
		    return
		  end if

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
		    FormsWindow.setParams(0, SelectedTool, false)
		  end if

		End Sub
	#tag EndEvent
	#tag Event
		Function MouseDown(index as Integer, x As Integer, y As Integer) As Boolean
		  if mousedispo then
		    return true
		  end if
		End Function
	#tag EndEvent
	#tag Event
		Sub Paint(index as Integer, g As Graphics, areas() As Rect)

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
		Sub Opening(index as Integer)
		  setIco(index,0)


		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events LibBox
	#tag Event
		Sub Opening()
		  LibBoxRefresh
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events LibOutils
	#tag Event
		Function MouseDown(index as Integer, x As Integer, y As Integer) As Boolean
		  if mousedispo then
		    return true
		  end if
		End Function
	#tag EndEvent
	#tag Event
		Sub MouseUp(index as Integer, x As Integer, y As Integer)
		  if mousedispo then
		    Me.SetFocus
		    selectedTool = index
		    Kit = "Libre"
		    if selectedtool <> 0 then
		      Formswindow.setParams(1, SelectedTool, false)
		    else
		      Formswindow.close
		      CurrentContent.CurrentOperation = new ShapeConstruction(selectedtool, 0)  'cas du point
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
		Sub Paint(index as Integer, g As Graphics, areas() As Rect)

		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton1
	#tag Event
		Sub Pressed()
		  Annuler

		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseEnter()
		  dim EL, EL1, EL2, EL3 as XMLElement
		  dim Name, Type as string
		  dim op as integer
		  dim n1 as integer
		  dim s as shape

		  if currentcontent = nil then
		    return
		  end if

		  if currentcontent.currentoperation <> nil then
		    me.Tooltip = Dico.Value("Cancel") + " " + currentcontent.currentoperation.GetName
		    if currentcontent.currentoperation.currentshape <> nil then
		      currentcontent.currentoperation.currentshape.side = -1
		      selshape = currentcontent.currentoperation.currentshape
		    end if
		    currentcontent.currentoperation.canceling = true
		    Return
		  end if

		  if currentcontent.currentop = 0  then
		    return
		  end if

		  EL = currentcontent.OpToCancel
		  if  EL = nil then
		    return
		  end if
		  EL1 = XMLElement(EL.firstchild)
		  if  EL1 = nil then
		    return
		  end if

		  op = val(EL.GetAttribute("OpId"))
		  Name = EL.GetAttribute(Dico.Value("Type")) + " "+ EL1.GetAttribute("Type")
		  me.Tooltip = Dico.Value("Cancel") + " " + lowercase(Name)
		  n1 =val(EL1.GetAttribute("Id"))
		  s = currentcontent.TheObjects.GetShape(n1)
		  if s <> nil then
		    s.side = -1
		    selshape = s
		  end if

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
		  if selshape <> nil then
		    selshape.highlight
		    me.Tooltip = me.Tooltip + " "+  lowercase(Dico.value(Type))
		  end if
		  can.refreshbackground
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseExit()
		  if selshape <> nil then
		    selshape.unhighlight
		    'can.refreshbackground
		  end if
		  if currentcontent <> nil and currentcontent.currentoperation <> nil then
		    currentcontent.currentoperation.canceling = false
		  end if
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
		Name="drapdim"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="drapg"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="draphisto"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Drapico"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="drappt"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DrapResel"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Drapshowall"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="drapstdcolor"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Form"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="integer"
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
		Name="hh"
		Visible=false
		Group="Behavior"
		InitialValue=""
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
		Name="nlib"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ntemp"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="numfig"
		Visible=false
		Group="Behavior"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="previousform"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="quitting"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
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
		Name="SelectedTool"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="stdflag"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="boolean"
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
		Name="Version"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="integer"
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
