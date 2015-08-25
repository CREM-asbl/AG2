#tag Window
Begin Window StdFamWindow
   BackColor       =   16777215
   Backdrop        =   ""
   BalloonHelp     =   ""
   CloseButton     =   "True"
   Composite       =   "False"
   Frame           =   1
   FullScreen      =   "False"
   HasBackColor    =   "False"
   Height          =   148
   ImplicitInstance=   "True"
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   "False"
   MaxWidth        =   32000
   MenuBar         =   ""
   MenuBarVisible  =   "False"
   MinHeight       =   64
   MinimizeButton  =   "True"
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   "False"
   Title           =   "Standardiser"
   Visible         =   "True"
   Width           =   263
   Begin StaticText StaticText1
      AutoDeactivate  =   "True"
      Bold            =   ""
      ControlOrder    =   0
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Multiline       =   ""
      Scope           =   0
      TabPanelIndex   =   0
      Text            =   "Nom de la famille :"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   14
      Underline       =   ""
      Visible         =   "True"
      Width           =   100
      BehaviorIndex   =   0
   End
   Begin StaticText StaticText2
      AutoDeactivate  =   "True"
      Bold            =   ""
      ControlOrder    =   1
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Multiline       =   ""
      Scope           =   0
      TabPanelIndex   =   0
      Text            =   "Couleur de la famille :"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   52
      Underline       =   ""
      Visible         =   "True"
      Width           =   121
      BehaviorIndex   =   1
   End
   Begin PushButton CancelButton
      AutoDeactivate  =   "True"
      Bold            =   ""
      Cancel          =   ""
      Caption         =   "Cancel"
      ControlOrder    =   2
      Default         =   ""
      Enabled         =   "True"
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   19
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   97
      Underline       =   ""
      Visible         =   "True"
      Width           =   80
      BehaviorIndex   =   2
   End
   Begin PushButton OKButton
      AutoDeactivate  =   "True"
      Bold            =   ""
      Cancel          =   ""
      Caption         =   "OK"
      ControlOrder    =   3
      Default         =   ""
      Enabled         =   "True"
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   146
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   97
      Underline       =   ""
      Visible         =   "True"
      Width           =   80
      BehaviorIndex   =   3
   End
   Begin EditField EditField1
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   "True"
      BackColor       =   16777215
      Bold            =   "True"
      Border          =   "True"
      ControlOrder    =   4
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Format          =   ""
      Height          =   21
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   140
      LimitText       =   0
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Mask            =   ""
      Multiline       =   ""
      Password        =   ""
      ReadOnly        =   ""
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollbarVertical=   "True"
      Styled          =   ""
      TabPanelIndex   =   0
      Text            =   ""
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   10
      Top             =   13
      Underline       =   ""
      UseFocusRing    =   "True"
      Visible         =   "True"
      Width           =   86
      BehaviorIndex   =   4
   End
   Begin PushButton ChooseColButton
      AutoDeactivate  =   "True"
      Bold            =   ""
      Cancel          =   ""
      Caption         =   "Pousser ici"
      ControlOrder    =   5
      Default         =   ""
      Enabled         =   "True"
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   146
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   10
      Top             =   50
      Underline       =   ""
      Visible         =   "True"
      Width           =   80
      BehaviorIndex   =   5
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  Title = Dico.Value("Standardiser")
		  OKButton.Caption = Dico.Value("OK")
		  CancelButton.Caption = Dico.value("Cancel")
		  if config.langue = "english" then
		    StaticText1.Text = Dico.Value("Family Name")
		    StaticText2.Text = Dico.Value("Family Color")
		  end if
		  curop = SaveStd(currentcontent.currentoperation)
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h0
		result As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		curop As SaveStd
	#tag EndProperty


#tag EndWindowCode

#tag Events CancelButton
	#tag Event
		Sub Action()
		  result = 0
		  close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events OKButton
	#tag Event
		Sub Action()
		  result = 1
		  
		  close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events EditField1
	#tag Event
		Sub TextChange()
		  curop.Nom = me.text
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ChooseColButton
	#tag Event
		Sub Action()
		  dim col as color
		  
		  if selectcolor(col,"Choisis une couleur") then
		    curop.coul  = new couleur(col)
		  end if
		  
		End Sub
	#tag EndEvent
#tag EndEvents
