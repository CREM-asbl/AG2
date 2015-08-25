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
   Height          =   234
   ImplicitInstance=   "False"
   LiveResize      =   "False"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   "False"
   MaxWidth        =   32000
   MenuBar         =   ""
   MenuBarVisible  =   "False"
   MinHeight       =   64
   MinimizeButton  =   "False"
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   "False"
   Title           =   "Sans_titre"
   Visible         =   "True"
   Width           =   420
   Begin EditField EF
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   "True"
      BackColor       =   16777215
      Bold            =   "True"
      Border          =   "True"
      ControlOrder    =   0
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   "True"
      Format          =   ""
      Height          =   200
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
      ReadOnly        =   "True"
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollbarVertical=   "True"
      Styled          =   ""
      TabPanelIndex   =   0
      Text            =   ""
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   14
      Top             =   0
      Underline       =   ""
      UseFocusRing    =   "True"
      Visible         =   "True"
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
      Enabled         =   "True"
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   260
      LockBottom      =   ""
      LockLeft        =   ""
      LockRight       =   ""
      LockTop         =   ""
      Scope           =   0
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      Top             =   205
      Underline       =   ""
      Visible         =   "True"
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
      Enabled         =   "True"
      Height          =   22
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
      Top             =   205
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
		  
		  dim i, n as integer
		  dim s as shape
		  
		  PushButton3.Caption = Dico.Value("FileClose")
		  PushButton3.Visible= true
		  if currentcontent.macrocreation and mac.expli ="" then
		    Title =  Dico.Value("MacroDescription")
		    PushButton2.Caption = Dico.Value("Cancel")
		    PushButton2.visible = true
		    
		    EF.ReadOnly = false
		    EF.Text = "Objets initiaux :" + chr(10)
		    for i = 0 to ubound(mac.ObInit)
		      n = mac.obInit(i)
		      s = currentcontent.TheObjects.getshape(n)
		      EF.Text = EF.Text+str(i+1)+") "+identifier(s.fam, s.forme)+ " "+ chr(10)
		    next
		    EF.Text=EF.Text+chr(13)
		    EF.Text =  EF.Text+ "Objets finaux :" + chr(10)
		    for i = 0 to ubound(mac.ObFinal)
		      n = mac.obFinal(i)
		      s = currentcontent.TheObjects.getshape(n)
		      EF.Text = EF.Text+str(i+1)+") "+identifier(s.fam, s.forme)+ " "+ chr(10)
		    next
		    EF.Text = EF.Text+ chr(10)+  "Commentaires"+chr(10)
		  else
		    EF.ReadOnly = true
		    EF.text = Mac.expli
		    PushButton2.Visible=false
		  end if
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Save()
		  if result = 1 then
		    Mac.expli = EF.text
		  end if
		  close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MacWindow(mac as Macro)
		  self.mac = mac
		  Super.Window
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		result As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		drap As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		mac As macro
	#tag EndProperty


#tag EndWindowCode

#tag Events EF
	#tag Event
		Sub TextChange()
		  
		  if currentcontent.macrocreation then
		    Mac.expli = EF.text
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
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
