#tag Window
Begin Window MacWindow
   BackColor       =   16777215
   Backdrop        =   ""
   BalloonHelp     =   ""
   CloseButton     =   "True"
   Composite       =   "False"
   Frame           =   3
   FullScreen      =   "False"
   HasBackColor    =   "False"
   Height          =   184
   ImplicitInstance=   "True"
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   "True"
   MaxWidth        =   32000
   MenuBar         =   ""
   MenuBarVisible  =   "False"
   MinHeight       =   64
   MinimizeButton  =   "True"
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   "True"
   Title           =   "Sans_titre"
   Visible         =   "True"
   Width           =   420
   Begin EditField EditField1
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   "True"
      BackColor       =   16777215
      Bold            =   ""
      Border          =   "True"
      ControlOrder    =   0
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   143
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   0
      LimitText       =   0
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Mask            =   ""
      Multiline       =   "True"
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
      TextSize        =   0
      Top             =   0
      Underline       =   ""
      UseFocusRing    =   "True"
      Visible         =   True
      Width           =   420
      BehaviorIndex   =   0
   End
   Begin PushButton PushButton2
      AutoDeactivate  =   "True"
      Bold            =   ""
      Cancel          =   ""
      Caption         =   "Cancel"
      ControlOrder    =   1
      Default         =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   275
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   148
      Underline       =   ""
      Visible         =   True
      Width           =   80
      BehaviorIndex   =   1
   End
   Begin PushButton PushButton3
      AutoDeactivate  =   "True"
      Bold            =   ""
      Cancel          =   ""
      Caption         =   "Close"
      ControlOrder    =   2
      Default         =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   60
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   148
      Underline       =   ""
      Visible         =   True
      Width           =   80
      BehaviorIndex   =   2
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  if app.macrocreation then
		    Title =  Dico.Value("MacroDescription")
		    PushButton2.Caption = Dico.Value("Cancel")
		    PushButton3.Caption = Dico.Value("FileClose")
		    PushButton2.visible = true
		    PushButton3.Visible= true
		    EditField1.text = ""
		  else
		    PushButton2.visible = false
		    PushButton3.Visible=false
		  end if
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Save()
		  if result = 1 then
		    wnd.Mac.expli = EditField1.text
		  end if
		  close
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		result As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		drap As Boolean
	#tag EndProperty


#tag EndWindowCode

#tag Events PushButton2
	#tag Event
		Sub Action()
		  result = 0
		  self.close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton3
	#tag Event
		Sub Action()
		  result = 1
		  self.save
		End Sub
	#tag EndEvent
#tag EndEvents
