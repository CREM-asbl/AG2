#tag Window
Begin Window WorkWindow
   BackColor       =   16777215
   Backdrop        =   ""
   BalloonHelp     =   ""
   CloseButton     =   "True"
   Composite       =   "True"
   Frame           =   0
   FullScreen      =   "False"
   HasBackColor    =   "True"
   Height          =   595
   ImplicitInstance=   "False"
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   "True"
   MaxWidth        =   32000
   MenuBar         =   -1173617590
   MenuBarVisible  =   "True"
   MinHeight       =   595
   MinimizeButton  =   "True"
   MinWidth        =   800
   Placement       =   0
   Resizeable      =   "True"
   Title           =   "Sans Titre"
   Visible         =   "False"
   Width           =   800
   Begin MyCanvas MyCanvas1
      AcceptFocus     =   "True"
      AcceptTabs      =   "True"
      AutoDeactivate  =   "False"
      Backdrop        =   ""
      Background      =   0
      Bkcol           =   0
      ControlOrder    =   0
      CreerTrace      =   0
      ctxt            =   0
      drapzone        =   0
      Enabled         =   True
      EraseBackground =   "True"
      FondsEcran      =   0
      Height          =   592
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   124
      LockBottom      =   "True"
      LockLeft        =   "True"
      LockRight       =   "True"
      LockTop         =   "True"
      MagneticDist    =   0
      NeedsRefresh    =   0
      OffscreenPicture=   0
      scaling         =   0
      Scope           =   0
      TabPanelIndex   =   0
      Top             =   0
      tracept         =   0
      UseFocusRing    =   "False"
      Visible         =   True
      Width           =   676
      BehaviorIndex   =   0
   End
   Begin Rectangle Tools
      AutoDeactivate  =   "True"
      BorderWidth     =   1
      BottomRightColor=   0
      ControlOrder    =   1
      Enabled         =   True
      FillColor       =   12632256
      Height          =   595
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   "True"
      LockLeft        =   "True"
      LockRight       =   "False"
      LockTop         =   "True"
      Scope           =   0
      TabPanelIndex   =   0
      Top             =   0
      TopLeftColor    =   0
      Visible         =   True
      Width           =   122
      BehaviorIndex   =   1
      Begin PushButton MouvBut
         AutoDeactivate  =   "True"
         Bold            =   "True"
         Cancel          =   ""
         Caption         =   "Modifier"
         ControlOrder    =   3
         Default         =   ""
         Enabled         =   True
         Height          =   30
         HelpTag         =   ""
         Index           =   0
         InitialParent   =   "Tools"
         Italic          =   ""
         Left            =   1
         LockBottom      =   ""
         LockLeft        =   ""
         LockRight       =   ""
         LockTop         =   ""
         Scope           =   0
         TabPanelIndex   =   0
         TextFont        =   "System"
         TextSize        =   0
         Top             =   30
         Underline       =   ""
         Visible         =   True
         Width           =   120
         BehaviorIndex   =   2
      End
      Begin GroupBox MoveBox
         AutoDeactivate  =   "True"
         Bold            =   "True"
         Caption         =   "Mouvements"
         ControlOrder    =   4
         Enabled         =   True
         Height          =   154
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "Tools"
         Italic          =   ""
         Left            =   5
         LockBottom      =   ""
         LockLeft        =   ""
         LockRight       =   ""
         LockTop         =   ""
         Scope           =   0
         TabPanelIndex   =   0
         TextFont        =   "System"
         TextSize        =   0
         Top             =   60
         Underline       =   ""
         Visible         =   True
         Width           =   112
         BehaviorIndex   =   3
         Begin PushButton MouvBut
            AutoDeactivate  =   "True"
            Bold            =   "True"
            Cancel          =   ""
            Caption         =   "Glisser"
            ControlOrder    =   5
            Default         =   ""
            Enabled         =   True
            Height          =   30
            HelpTag         =   ""
            Index           =   1
            InitialParent   =   "MoveBox"
            Italic          =   ""
            Left            =   7
            LockBottom      =   ""
            LockLeft        =   ""
            LockRight       =   ""
            LockTop         =   ""
            Scope           =   0
            TabPanelIndex   =   0
            TextFont        =   "System"
            TextSize        =   0
            Top             =   84
            Underline       =   ""
            Visible         =   True
            Width           =   108
            BehaviorIndex   =   2
         End
         Begin PushButton MouvBut
            AutoDeactivate  =   "True"
            Bold            =   "True"
            Cancel          =   ""
            Caption         =   "Retourner"
            ControlOrder    =   7
            Default         =   ""
            Enabled         =   True
            Height          =   30
            HelpTag         =   ""
            Index           =   3
            InitialParent   =   "MoveBox"
            Italic          =   ""
            Left            =   7
            LockBottom      =   ""
            LockLeft        =   ""
            LockRight       =   ""
            LockTop         =   ""
            Scope           =   0
            TabPanelIndex   =   0
            TextFont        =   "System"
            TextSize        =   0
            Top             =   144
            Underline       =   ""
            Visible         =   True
            Width           =   108
            BehaviorIndex   =   2
         End
         Begin PushButton MouvBut
            AutoDeactivate  =   "True"
            Bold            =   "True"
            Cancel          =   ""
            Caption         =   "Zoomer"
            ControlOrder    =   8
            Default         =   ""
            Enabled         =   True
            Height          =   30
            HelpTag         =   ""
            Index           =   4
            InitialParent   =   "MoveBox"
            Italic          =   ""
            Left            =   7
            LockBottom      =   ""
            LockLeft        =   ""
            LockRight       =   ""
            LockTop         =   ""
            Scope           =   0
            TabPanelIndex   =   0
            TextFont        =   "System"
            TextSize        =   0
            Top             =   174
            Underline       =   ""
            Visible         =   True
            Width           =   108
            BehaviorIndex   =   2
         End
         Begin PushButton MouvBut
            AutoDeactivate  =   "True"
            Bold            =   "True"
            Cancel          =   ""
            Caption         =   "Tourner"
            ControlOrder    =   6
            Default         =   ""
            Enabled         =   True
            Height          =   30
            HelpTag         =   ""
            Index           =   2
            InitialParent   =   "MoveBox"
            Italic          =   ""
            Left            =   5
            LockBottom      =   ""
            LockLeft        =   ""
            LockRight       =   ""
            LockTop         =   ""
            Scope           =   0
            TabPanelIndex   =   0
            TextFont        =   "System"
            TextSize        =   0
            Top             =   112
            Underline       =   ""
            Visible         =   True
            Width           =   108
            BehaviorIndex   =   2
         End
      End
      Begin GroupBox StdBox
         AutoDeactivate  =   "True"
         Bold            =   "True"
         Caption         =   "Formes Standard"
         ControlOrder    =   9
         Enabled         =   True
         Height          =   135
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "Tools"
         Italic          =   ""
         Left            =   5
         LockBottom      =   ""
         LockLeft        =   ""
         LockRight       =   ""
         LockTop         =   ""
         Scope           =   0
         TabPanelIndex   =   0
         TextFont        =   "System"
         TextSize        =   0
         Top             =   214
         Underline       =   ""
         Visible         =   True
         Width           =   112
         BehaviorIndex   =   4
         Begin Canvas StdOutil
            AcceptFocus     =   "True"
            AcceptTabs      =   "False"
            AutoDeactivate  =   "False"
            Backdrop        =   0
            ControlOrder    =   10
            Enabled         =   True
            EraseBackground =   "True"
            Height          =   50
            HelpTag         =   ""
            Index           =   0
            InitialParent   =   "StdBox"
            Left            =   8
            LockBottom      =   "False"
            LockLeft        =   "False"
            LockRight       =   "False"
            LockTop         =   "False"
            Scope           =   0
            TabPanelIndex   =   0
            Top             =   239
            UseFocusRing    =   "True"
            Visible         =   True
            Width           =   50
            BehaviorIndex   =   5
         End
         Begin Canvas StdOutil
            AcceptFocus     =   "False"
            AcceptTabs      =   "False"
            AutoDeactivate  =   "True"
            Backdrop        =   0
            ControlOrder    =   11
            Enabled         =   True
            EraseBackground =   "True"
            Height          =   50
            HelpTag         =   ""
            Index           =   1
            InitialParent   =   "StdBox"
            Left            =   64
            LockBottom      =   "False"
            LockLeft        =   "False"
            LockRight       =   "False"
            LockTop         =   "False"
            Scope           =   0
            TabPanelIndex   =   0
            Top             =   239
            UseFocusRing    =   "True"
            Visible         =   True
            Width           =   50
            BehaviorIndex   =   5
         End
         Begin Canvas StdOutil
            AcceptFocus     =   "False"
            AcceptTabs      =   "False"
            AutoDeactivate  =   "True"
            Backdrop        =   0
            ControlOrder    =   12
            Enabled         =   True
            EraseBackground =   "True"
            Height          =   50
            HelpTag         =   ""
            Index           =   2
            InitialParent   =   "StdBox"
            Left            =   8
            LockBottom      =   "False"
            LockLeft        =   "False"
            LockRight       =   "False"
            LockTop         =   "False"
            Scope           =   0
            TabPanelIndex   =   0
            Top             =   291
            UseFocusRing    =   "True"
            Visible         =   True
            Width           =   50
            BehaviorIndex   =   5
         End
         Begin Canvas StdOutil
            AcceptFocus     =   ""
            AcceptTabs      =   ""
            AutoDeactivate  =   "True"
            Backdrop        =   ""
            ControlOrder    =   13
            Enabled         =   True
            EraseBackground =   "True"
            Height          =   50
            HelpTag         =   ""
            Index           =   3
            InitialParent   =   "StdBox"
            Left            =   64
            LockBottom      =   ""
            LockLeft        =   ""
            LockRight       =   ""
            LockTop         =   ""
            Scope           =   0
            TabPanelIndex   =   0
            Top             =   291
            UseFocusRing    =   "True"
            Visible         =   True
            Width           =   50
            BehaviorIndex   =   5
         End
      End
      Begin GroupBox LibBox
         AutoDeactivate  =   "True"
         Bold            =   "True"
         Caption         =   "Formes Libres"
         ControlOrder    =   14
         Enabled         =   True
         Height          =   238
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "Tools"
         Italic          =   ""
         Left            =   5
         LockBottom      =   ""
         LockLeft        =   ""
         LockRight       =   ""
         LockTop         =   ""
         Scope           =   0
         TabPanelIndex   =   0
         TextFont        =   "System"
         TextSize        =   0
         Top             =   349
         Underline       =   ""
         Visible         =   True
         Width           =   112
         BehaviorIndex   =   6
         Begin Canvas LibOutils
            AcceptFocus     =   "True"
            AcceptTabs      =   "False"
            AutoDeactivate  =   "True"
            Backdrop        =   1344944127
            ControlOrder    =   15
            Enabled         =   True
            EraseBackground =   "True"
            Height          =   50
            HelpTag         =   ""
            Index           =   0
            InitialParent   =   "LibBox"
            Left            =   8
            LockBottom      =   "False"
            LockLeft        =   "False"
            LockRight       =   "False"
            LockTop         =   "False"
            Scope           =   0
            TabPanelIndex   =   0
            Top             =   378
            UseFocusRing    =   "True"
            Visible         =   True
            Width           =   50
            BehaviorIndex   =   7
         End
         Begin Canvas LibOutils
            AcceptFocus     =   "True"
            AcceptTabs      =   "False"
            AutoDeactivate  =   "True"
            Backdrop        =   8007679
            ControlOrder    =   16
            Enabled         =   True
            EraseBackground =   "True"
            Height          =   50
            HelpTag         =   ""
            Index           =   2
            InitialParent   =   "LibBox"
            Left            =   8
            LockBottom      =   "False"
            LockLeft        =   "False"
            LockRight       =   "False"
            LockTop         =   "False"
            Scope           =   0
            TabPanelIndex   =   0
            Top             =   430
            UseFocusRing    =   "True"
            Visible         =   True
            Width           =   50
            BehaviorIndex   =   7
         End
         Begin Canvas LibOutils
            AcceptFocus     =   "True"
            AcceptTabs      =   "False"
            AutoDeactivate  =   "True"
            Backdrop        =   1584048127
            ControlOrder    =   17
            Enabled         =   True
            EraseBackground =   "True"
            Height          =   50
            HelpTag         =   ""
            Index           =   1
            InitialParent   =   "LibBox"
            Left            =   64
            LockBottom      =   "False"
            LockLeft        =   "False"
            LockRight       =   "False"
            LockTop         =   "False"
            Scope           =   0
            TabPanelIndex   =   0
            Top             =   378
            UseFocusRing    =   "True"
            Visible         =   True
            Width           =   50
            BehaviorIndex   =   7
         End
         Begin Canvas LibOutils
            AcceptFocus     =   "True"
            AcceptTabs      =   "False"
            AutoDeactivate  =   "True"
            Backdrop        =   952131583
            ControlOrder    =   18
            Enabled         =   True
            EraseBackground =   "True"
            Height          =   50
            HelpTag         =   ""
            Index           =   3
            InitialParent   =   "LibBox"
            Left            =   64
            LockBottom      =   "False"
            LockLeft        =   "False"
            LockRight       =   "False"
            LockTop         =   "False"
            Scope           =   0
            TabPanelIndex   =   0
            Top             =   430
            UseFocusRing    =   "True"
            Visible         =   True
            Width           =   50
            BehaviorIndex   =   7
         End
         Begin Canvas LibOutils
            AcceptFocus     =   "True"
            AcceptTabs      =   "False"
            AutoDeactivate  =   "True"
            Backdrop        =   115009535
            ControlOrder    =   19
            Enabled         =   True
            EraseBackground =   "True"
            Height          =   50
            HelpTag         =   ""
            Index           =   4
            InitialParent   =   "LibBox"
            Left            =   8
            LockBottom      =   "False"
            LockLeft        =   "False"
            LockRight       =   "False"
            LockTop         =   "False"
            Scope           =   0
            TabPanelIndex   =   0
            Top             =   482
            UseFocusRing    =   "True"
            Visible         =   True
            Width           =   50
            BehaviorIndex   =   7
         End
         Begin Canvas LibOutils
            AcceptFocus     =   "True"
            AcceptTabs      =   "False"
            AutoDeactivate  =   "True"
            Backdrop        =   623656959
            ControlOrder    =   20
            Enabled         =   True
            EraseBackground =   "True"
            Height          =   50
            HelpTag         =   ""
            Index           =   6
            InitialParent   =   "LibBox"
            Left            =   64
            LockBottom      =   "False"
            LockLeft        =   "False"
            LockRight       =   "False"
            LockTop         =   "False"
            Scope           =   0
            TabPanelIndex   =   0
            Top             =   482
            UseFocusRing    =   "True"
            Visible         =   True
            Width           =   50
            BehaviorIndex   =   7
         End
         Begin Canvas LibOutils
            AcceptFocus     =   "True"
            AcceptTabs      =   "False"
            AutoDeactivate  =   "True"
            Backdrop        =   454606847
            ControlOrder    =   21
            Enabled         =   True
            EraseBackground =   "True"
            Height          =   50
            HelpTag         =   ""
            Index           =   5
            InitialParent   =   "LibBox"
            Left            =   8
            LockBottom      =   "False"
            LockLeft        =   "False"
            LockRight       =   "False"
            LockTop         =   "False"
            Scope           =   0
            TabPanelIndex   =   0
            Top             =   534
            UseFocusRing    =   "True"
            Visible         =   True
            Width           =   50
            BehaviorIndex   =   7
         End
      End
      Begin PushButton PushButton1
         AutoDeactivate  =   "False"
         Bold            =   "True"
         Cancel          =   ""
         Caption         =   ""
         ControlOrder    =   2
         Default         =   ""
         Enabled         =   True
         Height          =   30
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "Tools"
         Italic          =   ""
         Left            =   0
         LockBottom      =   ""
         LockLeft        =   ""
         LockRight       =   ""
         LockTop         =   ""
         Scope           =   0
         TabPanelIndex   =   0
         TextFont        =   "System"
         TextSize        =   0
         Top             =   0
         Underline       =   ""
         Visible         =   True
         Width           =   120
         BehaviorIndex   =   8
      End
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Function CancelClose(appQuitting as Boolean) As Boolean
		  dim i as integer
		  
		  for i = ubound(wcontent) downto 0
		    deletecontent
		    if ubound(wcontent) = i then
		      return true
		    end if
		  next
		  
		  app.quitting = true
		  return false
		  
		  
		End Function
	#tag EndEvent

	#tag Event
		Function KeyDown(Key As String) As Boolean
		  dim u(-1), s as integer
		  dim disp, nom as string
		  
		  if CurrentContent.bugfound then
		    return false
		  end if
		  
		  select case asc(Key)
		  case 59    ' ;
		    config
		  case 36 '$
		    stdflag = not stdflag
		  case   163  //shift "µ"
		    if CurrentContent.currentoperation <> nil then
		      CurrentContent.CurrentOperation.std2flag = not CurrentContent.CurrentOperation.std2flag
		    end if
		  case 1 'ctrl-shft a
		    currentcontent.drapaff = not currentcontent.drapaff
		  case 2 'ctrl-shft b
		    drapbug = not drapbug
		  case 5 'ctrl-shft e
		    currentcontent.drapeucli = not currentcontent.drapeucli
		  case  20 ' ctrl-shft t
		    wnd.mycanvas1.sctxt = nil
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
		    'MsgBox "Bug volontaire -- Ne jamais pousser sur la touche 'r'"
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
		  case 43,61 'touche +
		    AugmenteFont
		  case 48,224 'touche 0
		    ResetFont
		  end select
		  
		  return true
		  
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  initParams()
		  
		  updateMenu
		  
		  NewContent
		  
		  DrapShowall = false
		  if MenuMenus.Child("EditMenu").Child("EditCopy").checked  then
		    DrapResel =  MenuBar.Child("EditMenu").Child("EditReselect").checked
		  end if
		  
		  if Config.username = "Tutoriel" then
		    NotesWindow.visible = true
		  end if
		  if app.iw <> nil then
		    app.iw.Close
		  end if
		  
		  
		  maximize
		  
		  if app.currentfile <> nil then
		    OpenFile(app.currentfile)
		    app.currentfile = nil
		  end if
		  
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub EnableMenuItems()
		  if not CurrentContent.currentoperation isa shapeconstruction then
		    MyCanvas1.mousecursor = arrowcursor
		  else
		    setcross
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
		Sub Close()
		  if fw <> nil then
		    fw.close
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Sub Maximize()
		  UpdateToolBar
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resizing()
		  UpdateToolBar
		  MyCanvas1.resize
		  Mycanvas1.refreshbackground
		End Sub
	#tag EndEvent

	#tag Event
		Sub Restore()
		  UpdateToolBar
		End Sub
	#tag EndEvent


#tag MenuHandler
		Function EditUndo() As Boolean Handles EditUndo.Action
			if dret = nil then
			Annuler
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
		Function HelpView() As Boolean Handles HelpView.Action
			if mousedispo then
			closefw
			Config.ShowHelp=not Config.ShowHelp
			wnd.Mycanvas1.RefreshBackground
			MenuBar.Child("HelpMenu").Child("HelpView").checked = Config.showhelp
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
		Function PrefsTrace() As Boolean Handles PrefsTrace.Action
			
			MenuBar.Child("PrefsMenu").Child("PrefsTrace").checked = not MenuBar.Child("PrefsMenu").Child("PrefsTrace").checked
			Config.Trace =MenuBar.Child("PrefsMenu").Child("PrefsTrace").checked
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
			md.Message = "Apprenti géomètre v."+str(App.MajorVersion)+"."+str(App.MinorVersion)+"."+str(App.BugVersion)  +EndOfLine+"Copyright CREM "+mois(App.BuildDate.Month-1)+" "+str(App.BuildDate.Year)+ EndofLine +EndofLine+ "Programmation: G. Noël et G. Pliez"
			b = md.ShowModal
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
		Function OperaDivide() As Boolean Handles OperaDivide.Action
			dim diw as DivideWindow
			dim n as integer
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
		Function ToolsColorStdFam() As Boolean Handles ToolsColorStdFam.Action
			CurrentContent.currentoperation = nil
			closefw
			refreshtitle
			drapstdcolor = true
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
		Function FileNew() As Boolean Handles FileNew.Action
			if mousedispo then
			closefw
			NewContent
			wnd.mycanvas1.refreshBackground
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
		Function FileOpen() As Boolean Handles FileOpen.Action
			Dim f As FolderItem
			dim op As Operation
			
			if mousedispo then
			closefw
			f=GetOpenFolderItem(FileAGTypes.SAVE)
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
		Function FileSaveBitmap() As Boolean Handles FileSaveBitmap.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation = new SaveBitMap
			end if
			return true
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
			end if
			MenuBar.Child("Fenetres").Item(index).checked = true
			wnd.mycanvas1.sctxt = nil
			refresh
			end if
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
		Function CfgOpen() As Boolean Handles CfgOpen.Action
			config
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
		Function PrefsStdForms() As Boolean Handles PrefsStdForms.Action
			dim i,n as integer
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
		Function MacrosCreate() As Boolean Handles MacrosCreate.Action
			closefw
			app.macrocreation = true
			MenuMenus.Child("MacrosMenu").Child("MacrosSave").checked = true
			MenuMenus.Child("MacrosMenu").Child("MacrosQuit").checked = true
			MenuMenus.Child("MacrosMenu").Child("MacrosFinaux").checked = true
			EraseMenuBar
			CopyMenuBar
			mac = new macro
			newcontent
			return true
			
			
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function ToolsColorTransparent() As Boolean Handles ToolsColorTransparent.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new TransparencyChange
			TransparencyChange(CurrentContent.CurrentOperation).ImmediateDoOperation
			refreshtitle
			end if
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
			mac.sauvegarder
			end if
			return true
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
			mac.creermenuitem
			end if
			return true
			
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function MacrosQuit() As Boolean Handles MacrosQuit.Action
			closefw
			app.macrocreation = false
			MenuMenus.Child("MacrosMenu").Child("MacrosSave").checked = false
			MenuMenus.Child("MacrosMenu").Child("MacrosQuit").checked = false
			MenuMenus.Child("MacrosMenu").Child("MacrosFinaux").checked = false
			EraseMenuBar
			CopyMenuBar
			mac = nil
			CloseMacro
			NewContent
			wnd.mycanvas1.refreshbackground
			return true
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function FileClose() As Boolean Handles FileClose.Action
			
			deletecontent
			
			if UBound (wcontent) = -1 then
			NewContent
			end if
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
		Function NotesOpen() As Boolean Handles NotesOpen.Action
			if mousedispo then
			closefw
			NotesWindow.visible = true
			end if
			return true
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function PrintSetUp() As Boolean Handles PrintSetUp.Action
			if mousedispo then
			closefw
			app.prtsetup = New PrinterSetup
			If app.prtsetup.PageSetupDialog then
			return true
			end if
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
		Function ToolsThick1() As Boolean Handles ToolsThick1.Action
			if mousedispo then
			closefw
			Config.Thickness = 1
			CurrentContent.CurrentOperation = new Epaisseur(1)
			Epaisseur(CurrentContent.CurrentOperation).ImmediateDoOperation
			refreshtitle
			end if
			return true
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function ToolsThick2() As Boolean Handles ToolsThick2.Action
			if mousedispo then
			closefw
			Config.Thickness = 2
			CurrentContent.CurrentOperation = new Epaisseur(2)
			Epaisseur(CurrentContent.CurrentOperation).ImmediateDoOperation
			refreshtitle
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
			MyCanvas1.Mousecursor = arrowcursor
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
		Function EditReselect() As Boolean Handles EditReselect.Action
			MenuBar.Child("EditMenu").Child("EditReselect").checked = not MenuBar.Child("EditMenu").Child("EditReselect").checked
			Drapresel = MenuBar.Child("EditMenu").Child("EditReselect").checked
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
		Function PrefsBiface() As Boolean Handles PrefsBiface.Action
			MenuBar.Child("PrefsMenu").Child("PrefsBiface").checked = not MenuBar.Child("PrefsMenu").Child("PrefsBiface").checked
			Config.StdBiface = MenuBar.Child("PrefsMenu").Child("PrefsBiface").checked
			Return True
			
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
		Function HelpUG() As Boolean Handles HelpUG.Action
			dim fi as Folderitem
			
			fi = getfolderitem(Dico.Value("UserGuide"))
			
			if fi.exists then
			fi.launch "25" '? : pourquoi 25
			else
			MsgBox Dico.Value("MsgUnfoundable")
			end if
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
		Function BetaRapport() As Boolean Handles BetaRapport.Action
			dim br as BetaRapport
			br = new BetaRapport
			br.ShowModal
			Return True
			
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
		Function MacrosFinaux() As Boolean Handles MacrosFinaux.Action
			if mousedispo then
			closefw
			CurrentContent.CurrentOperation=new ChooseFinal
			refreshtitle
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
		Function Install() As Boolean Handles Install.Action
			Dim f As FolderItem
			dim jpegType as New FileType
			jpegType.Name = "image/jpeg"
			jpegType.MacType = "JPEG"
			jpegType.Extensions = "jpg;jpeg"
			
			if mousedispo then
			closefw
			f=GetOpenFolderItem(jpegType)
			if f=nil then
			return true
			else
			mycanvas1.FondsEcran = f.OpenAsPicture()
			end if
			end if
			
			Return True
			
		End Function
#tag EndMenuHandler

#tag MenuHandler
		Function UnInstall() As Boolean Handles UnInstall.Action
			mycanvas1.FondsEcran = nil
			Return True
			
		End Function
#tag EndMenuHandler


	#tag Method, Flags = &h0
		Sub refreshtitle()
		  if app.macrocreation then
		    Title=Dico.Value("MacrosCreate") + "*"
		  elseif draphisto then
		    Title =  Rh.Histfile.Name
		  else
		    Title=CurrentContent.GetWindTitle
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetStdSpecs(v as integer, sv as integer) As StdPolygonSpecifications
		  
		  return config.StdFamilies(v,sv)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub openformswindow(k as integer, f as integer)
		  closefw
		  CurrentContent.CurrentOperation = nil
		  fw=new FormsWindow(k,f,false)
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetIco(Fam as integer, Form As integer)
		  dim h, taille, bord, haut, larg as double
		  dim specs as StdPolygonSpecifications
		  
		  StdOutil(fam).Visible = fam < Config.nstdfam
		  
		  if not StdOutil(fam).Visible then
		    return
		  end if
		  
		  h = stdoutil(fam).height
		  specs = config.stdfamilies(fam,form)
		  
		  if specs.family = "Cubes"  then
		    ico(fam) = new Cubeskull(new BasicPoint(3,h-8), form,1)
		    taille = 0.5*h
		    if form = 1 then
		      ico(Fam).Update new BasicPoint (h/2,h-6)
		      taille = 0.4*h
		    end if
		  elseif specs.family = "Rods" then
		    ico(fam) = new Cubeskull(new BasicPoint(3,h-8), 0, 1)
		    taille = 0.5*h
		  elseif specs.family="Segments" or ubound(specs.angles) > 0 then
		    ico(Fam) = new Figskull(config.stdfamilies(fam,form))
		    larg = Figskull(ico(Fam)).urx-Figskull(ico(fam)).dlx
		    haut = Figskull(ico(Fam)).ury-Figskull(ico(fam)).dly
		    taille = 0.8*h/max(larg,haut)
		    ico(Fam).Update new BasicPoint (3-Figskull(ico(fam)).dlx*taille,h-5-Figskull(ico(fam)).ury*taille)
		  else
		    ico(fam) = new oldcircleskull(1,new BasicPoint(h/2,h/2))
		    taille = 0.4*h*specs.distances(0)
		  end if
		  ico(fam).updatebordercolor(Config.Bordercolor.col,100)
		  if specs.family = "Rods" then
		    ico(fam).updatefillcolor(specs.coul.col,100)
		  else
		    ico(fam).updatefillcolor(config.stdcolor(fam).col,100)
		  end if
		  if specs.family = "Cubes" and form = 2 then
		    ico(fam).updatefillcolor(config.stdcolor(fam).col,0)
		  end if
		  
		  ico(fam).Updateborderwidth(1/h)
		  ico(fam).UpdateSize(taille)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Refresh()
		  refreshtitle
		  if not draphisto then
		    updatemenu
		  end if
		  Mycanvas1.RefreshBackground
		  MoveBoxRefresh
		  StdBoxRefresh
		  LibBoxRefresh
		  'if CurrentContent.currentoperation isa shapeconstruction and fw <> nil  then
		  'if fw.kit = 0 then
		  'stdoutil(fw.fam).refresh
		  'else
		  'liboutils(fw.fam).refresh
		  'end if
		  'end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub closefw()
		  
		  if fw <> nil then
		    selectedtool = -1
		    if fw.kit = 0 then
		      stdoutil(fw.fam).refresh
		    else
		      liboutils(fw.fam).refresh
		    end if
		    fw.close
		    
		  end if
		  fw = nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMenuItem(menu as string, sousmenu as string) As Boolean
		  Return MenuMenus.Child(menu).Child(sousmenu).checked
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub endselect()
		  if CurrentContent.currentoperation isa selectionner then
		    selectionner(CurrentContent.currentoperation).endoperation
		  end if
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
		Sub choisirformesstandard()
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Annuler()
		  closefw
		  if CurrentContent.CurrentOperation isa ShapeConstruction and  CurrentContent.CurrentOperation.CurrentShape.isinconstruction and Shapeconstruction(CurrentContent.currentoperation).currentitemtoset > 1 then
		    CurrentContent.abortconstruction
		  else
		    CurrentContent.UndoLastOperation
		  end if
		  mycanvas1.refreshBackground
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub config()
		  closefw
		  dim mw as ConfigWindow
		  mw = new ConfigWindow
		  mw.showmodal
		  'CurrentContent.CurrentFileUpToDate=false
		  
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
		Sub updatemenu()
		  EraseMenuBar
		  CopyMenuBar
		  CopyCFGMenu
		  ReadNomsMouvBut
		  ReadStTexts
		  TradMenu
		  if MenuBar.Child("PrefsMenu") <> nil then 'correctif pour annuler dans InitWindow
		    MenuBar.Child("PrefsMenu").Child("PrefsPolyg").checked  = Config.PolPointes
		    MenuBar.Child("PrefsMenu").Child("PrefsTrace").checked  = config.trace
		    MenuBar.Child("PrefsMenu").Child("PrefsAjust").checked = Config.Ajust
		  end if
		  
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
		Sub setcross()
		  if backcolor = blanc then
		    mycanvas1.mousecursor = cross
		  else
		    mycanvas1.mousecursor = whitecross
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Switchcolors()
		  dim i , j, k As integer
		  dim s as shape
		  dim can as mycanvas
		  dim coul as couleur
		  
		  can = wnd.mycanvas1
		  
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
		    coul = new couleur(s.labs.element(i).col)
		    s.labs.element(i).col = coul.comp.col
		  next
		  
		  for i = 1 to CurrentContent.TheObjects.count -1
		    s = CurrentContent.TheObjects.element(i)
		    s.colsw = false
		    for j = 0 to ubound(s.childs)
		      s.childs(j).colsw = false
		    next
		  next
		  
		  for i = 1 to CurrentContent.TheObjects.count -1
		    s = CurrentContent.TheObjects.element(i)
		    if not s.colsw then
		      s.bordercolor = s.bordercolor.comp
		      s.fillcolor = s.fillcolor.comp
		      for j = 0 to s.labs.count-1
		        coul = new couleur(s.labs.element(j).col)
		        s.labs.element(j).col = coul.comp.col
		      next
		      for j = 0 to ubound(s.childs)
		        if not s.childs(j).colsw then
		          s.childs(j).bordercolor = s.childs(j).bordercolor.comp
		          if s.childs(j).labs.count > 0 then
		            for k = 0 to s.childs(j).labs.count-1
		              coul = new couleur(s.childs(j).labs.element(k).col)
		              s.childs(j).labs.element(k).col = coul.comp.col
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
		    ico(i).updatefillcolor(config.stdcolor(i).col,100)
		  next
		  Mycanvas1.RefreshBackground
		End Sub
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
		Function mousedispo() As Boolean
		  return dret = nil and (CurrentContent.currentoperation = nil or CurrentContent.currentoperation.finished = true)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NewContent()
		  dim mitem as MenuItem
		  
		  if (GetNumWindow<>-1) then
		    MenuBar.Child("Fenetres").Item(GetNumWindow).checked = false
		  end if
		  
		  numfig=numfig+1
		  currentContent = new WindContent(numfig)
		  wcontent.Append(currentContent)
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
		Sub deleteContent()
		  dim conf as Confirmation
		  dim i,n,val As integer
		  
		  val = 0
		  
		  if CurrentContent.TheObjects.count > 1 and not CurrentContent.CurrentFileUptoDate then
		    conf = new Confirmation(CurrentContent.id)
		    Conf.ShowModal
		    val = Conf.result      ''Yes
		    conf.close
		  end if
		  
		  if val<>-1 then            '-1: annuler
		    if val = 1 then
		      CurrentContent.Save
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
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CountContent() As integer
		  return UBound(wcontent)+1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OpenFile(f as Folderitem)
		  dim nc as boolean
		  
		  if  CurrentContent.TheObjects.count > 1 then
		    closefw
		    NewContent
		    nc = true
		  end if
		  
		  if f.Type = "HIST" then
		    CurrentContent.currentoperation = new ReadHisto(f)
		  elseif f.Type = "SAVE" then
		    CurrentContent.CurrentOperation = new Ouvrir(f)
		    CurrentContent.CurrentOperation = nil
		  else  'if f.name <> "vss" then
		    MsgBox Dico.Value("MsgUnfoundable")+ ou + Dico.Value("MsgNovalidFile")
		    if nc then
		      deleteContent
		    end if
		  end if
		  
		  
		  
		  
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
		Sub CloseMacro()
		  dim i as integer
		  
		  app.macrocreation = false
		  'if currentcontent.currentoperation <> nil then
		  currentcontent.currentoperation = nil
		  'end if
		  MenuBar.Child("FileMenu").Child("FileNew").visible = true
		  MenuBar.Child("FileMenu").Child("FileOpen").visible=true
		  MenuBar.Child("FileMenu").Child("FileSave").visible = true
		  MenuBar.Child("FileMenu").Child("FileSaveAs").visible = true
		  MenuMenus.Child("OperaMenu").Child("OperaClone").checked=true
		  for i = 0 to 4
		    MouvBut(i).visible =true
		  next
		  MoveBox.visible = true
		  newcontent
		  wnd.refreshtitle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub initParams()
		  title = Config.username
		  AcceptFileDrop(FileAGTypes.SAVE)
		  AcceptFileDrop(FileAGTypes.HIST)
		  wnd = self
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
		  MenuBar.Child("FileMenu").Child("PrintSetUp").Text = Dico.Value("PrintSetUp")
		  MenuBar.Child("FileMenu").Child("FilePrint").Text = Dico.Value("FilePrint")
		  MenuBar.Child("FileMenu").Child("FileQuit").Text = Dico.Value("FileQuit")
		  MenuBar.Child("Fenetres").Text = Dico.Value("Windows")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CopyMenuBar()
		  dim i, nmen as integer
		  
		  nmen = MenuMenus.count
		  for i = 0 to nmen-1
		    MenuBar.append CopyMenuItem(MenuMenus.item(i))
		  next
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
		  if app.StageCode = 2 then
		    mitem = new MenuItem
		    mitem.Name = "Beta"
		    mitem.Text = Dico.Value("Beta")
		    sm = new MenuItem 'sous-menu nécessaire pour fonctionner sur Mac
		    sm.Name = "BetaRapport"
		    sm.Text = Dico.Value("Rapport")
		    mitem.append sm
		    MenuBar.append mitem
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
		Function CopyMenuItem(mitem as menuitem) As menuitem
		  dim item, jtem, ktem as menuitem
		  dim i,j,k, nitem as integer
		  dim Bol as Boolean
		  
		  item = new MenuItem
		  item.Name = mitem.Name
		  item.CommandKey = mitem.CommandKey
		  item.index = mitem.index
		  item.icon = mitem.icon
		  
		  if item.name = "PrefsFreeForms" then
		    return nil
		  end if
		  
		  if item.Name = "MacrosChoose" and app.TheMacros.count >0  then
		    item.Text = app.TheMacros.element(item.index).caption
		  else
		    item.Text = Dico.Value(item.Name)
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
		      item.append CopyMenuItem(mitem.item(i))
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
		Sub StdBoxRefresh()
		  StdBox.Visible = Config.ShowStdTools
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LibBoxRefresh()
		  LibBox.Visible = Config.ShowTools or (CurrentContent <> nil and CurrentContent.TheGrid <>nil)
		  if LibBox.Visible then
		    dim i as integer
		    for i=0 to 6
		      LibOutils(i).Visible =true
		    next
		  end if
		  LibBox.Refresh
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
		Sub DiminueFont()
		  Config.TextSize = Config.TextSize -1
		  updateTextSize
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AugmenteFont()
		  Config.TextSize = Config.TextSize +1
		  updateTextSize
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetFont()
		  Config.TextSize = 12
		  updateTextSize
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DisableToolBar()
		  Tools.Enabled = false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ScreenAdjust()
		  'MyCanvas1.Resize
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnableToolbar()
		  Tools.Enabled = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateToolBar()
		  dim espace as integer
		  
		  espace = min((me.Height-me.MinHeight)/3,50)
		  
		  MoveBox.Top = 60+espace
		  
		  StdBox.top = MoveBox.top+MoveBox.Height+espace
		  
		  LibBox.Top = StdBox.top+StdBox.Height+espace
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveBoxRefresh()
		  dim i as integer
		  for i=0 to 4
		    MouvBut(i) .visible = Config.MvBt(i)
		  next
		  
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

	#tag Note, Name = Sans_titre
	#tag EndNote


	#tag Property, Flags = &h0
		SelectedTool As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Kit As string
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Cerc As circleskull
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Fig2 As Figskull
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Seg As segskull
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Fig4 As Figskull
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Fig5 As figskull
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Fig6 As Figskull
	#tag EndProperty

	#tag Property, Flags = &h0
		stdflag As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		fw As Formswindow
	#tag EndProperty

	#tag Property, Flags = &h0
		Form As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Drapico As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Drapshowall As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ntemp As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Mac As Macro
	#tag EndProperty

	#tag Property, Flags = &h0
		hh As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Base As Menuitem
	#tag EndProperty

	#tag Property, Flags = &h0
		DrapResel As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		draphisto As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		rh As ReadHisto
	#tag EndProperty

	#tag Property, Flags = &h0
		drapdim As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		tw As Textwindow
	#tag EndProperty

	#tag Property, Flags = &h0
		Version As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		dblclic As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drappt As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drapstdcolor As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		wcontent(-1) As WindContent
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Ico(4) As skull
	#tag EndProperty

	#tag Property, Flags = &h0
		numfig As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		drapbug As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		quitting As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		nlib As Integer
	#tag EndProperty


#tag EndWindowCode

#tag Events PushButton1
	#tag Event
		Sub Action()
		  if dret = nil then
		    Annuler
		    if CurrentContent.CurrentOp = 0 then
		      me.Enabled = false
		    end if
		  end if
		  
		  setfocus
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseEnter()
		  dim EL, EL1, EL2, EL3 as XMLElement
		  dim Name, Type as string
		  dim op, op1 as integer
		  
		  EL = currentcontent.OpToCancel
		  
		  if EL = nil then
		    return
		  end if
		  
		  op = val(EL.GetAttribute("OpId"))
		  Name = EL.GetAttribute(Dico.Value("Type"))
		  me.Helptag = Dico.Value("Cancel") + " " + lowercase(Name)
		  EL1 = XMLElement(EL.firstchild)
		  
		  select case op
		  case 0  //Construction
		    Type = EL1.GetAttribute("Type") + " n°" + EL1.GetAttribute("Id")
		  case 1  //ParaperpConstruction
		    Type = EL1.GetAttribute("Type") + " n°" + EL1.GetAttribute("Id")
		    EL2 = XMLElement(EL1.Child(1))
		    op1 = val(EL2.GetAttribute("Oper"))
		    if op1 = 1 then
		      Type = Type+ " parallèle"
		    else
		      Type = Type + " perpendiculaire"
		    end if
		    Type = Type + "à l'objet n°" + EL2.GetAttribute("Id")
		  case 19 //Dupliquer
		    EL2 = XMLElement(EL1.firstchild)
		    EL3 = XMLElement(EL2.firstchild)
		    Type = EL3.GetAttribute("Type") + " n°" + EL3.GetAttribute("Id")
		  end select
		  me.Helptag = me.Helptag + " "+  lowercase(Type)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events MouvBut
	#tag Event
		Sub Action(index as Integer)
		  if mousedispo then
		    closefw
		    select case index
		    case 0
		      CurrentContent.CurrentOperation = new modifier()
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
		      mycanvas1.mousecursor = arrowcursor
		    else
		      wnd.setcross
		    end if
		    SetFocus
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events MoveBox
	#tag Event
		Sub Open()
		  MoveBoxRefresh
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
		    StdOutil(index).refresh
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
		Sub Paint(index as Integer, g As Graphics)
		  if index < Config.nstdfam then
		    g.ForeColor = RGB(255,255,255)
		    g.FillRect(0,0,g.Width,g.Height)
		    self.ico(Index).paint(g)
		    if index=selectedTool and Kit = "Standard"  then
		      g.forecolor = rouge
		      g.penwidth = 2.5
		      g.DrawRect(0,0,g.Width,g.Height)
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
		  dim i As Integer
		  
		  if mousedispo then
		    selectedTool = index
		    Kit = "Libre"
		    LibOutils(selectedtool).refresh
		    
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
		Sub Paint(index as Integer, g As Graphics)
		  dim Visible as Boolean
		  me.Visible = Config.nlibvis(index) or (index = 6 and CurrentContent <> nil and CurrentContent.TheGrid <> nil)
		  if  me.Visible then
		    g.ForeColor = RGB(255,255,255)
		    g.FillRect(0,0,g.Width,g.Height)
		    
		    if (me.Backdrop.Height>g.Height or me.Backdrop.Width>g.Width) then
		      g.DrawPicture(me.Backdrop,0,0,g.Width,g.Height,0,0,me.Backdrop.Width,me.Backdrop.Height)
		    else
		      g.DrawPicture(me.Backdrop,(g.Width-me.Backdrop.Width)/2,(g.height-me.Backdrop.Height)/2)
		    end if
		    
		    if index=selectedTool and Kit = "Libre"  then
		      g.forecolor = rouge
		      g.penwidth = 2.5
		      g.DrawRect(0,0,g.Width,g.Height)
		    end if
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
