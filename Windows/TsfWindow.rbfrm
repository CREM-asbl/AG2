#tag Window
Begin Window TsfWindow
   BackColor       =   &hFFFFFF
   Backdrop        =   ""
   BalloonHelp     =   ""
   CloseButton     =   "True"
   Composite       =   "False"
   Frame           =   3
   FullScreen      =   "False"
   HasBackColor    =   "True"
   Height          =   300
   ImplicitInstance=   "True"
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   "False"
   MaxWidth        =   32000
   MenuBar         =   ""
   MenuBarVisible  =   "True"
   MinHeight       =   64
   MinimizeButton  =   "True"
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   "True"
   Title           =   "Sans_titre"
   Visible         =   "True"
   Width           =   300
   Begin EditField EF
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   "True"
      BackColor       =   &hFFFFFF
      Bold            =   "True"
      Border          =   "True"
      ControlOrder    =   0
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   299
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   1
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
      TextColor       =   &h000000
      TextFont        =   "Arial"
      TextSize        =   15
      Top             =   1
      Underline       =   ""
      UseFocusRing    =   "True"
      Visible         =   True
      Width           =   299
      BehaviorIndex   =   0
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  
		  
		  tsf = wnd.Mycanvas1.tsf
		  Title = tsf.GetType
		  Update
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  EF.height = height
		  EF.width = width
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resizing()
		  EF.height = height
		  EF.width = width
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics)
		  EF.Text = ""
		  
		  select case tsf.type
		    
		    
		  case 1  //Translation
		    
		  case 2 //Rotation
		    
		  case 3 //Demi-tour
		    
		  case 4 //Quart de tour à gauche
		    
		  case 5 //Quart de tour à droite
		    
		  case 6 //Symétrie
		    
		  case 7,  71, 72 // Homothétie
		    
		  case 8, 81, 82 //Similitude
		    EF.Text = EF.Text  + "Centre :  ("  + str(centre.x) +", " + str(centre.y) +")"+ chr(13)
		    EF.Text = EF.Text  + "Angle  (radians) :"  + str(angle) + chr(10)
		    EF.Text = EF.Text  + "Angle  (degrés) :"  + str(angle*180/Pi) + chr(10)
		    EF.Text = EF.Text  + "Rapport :  "  + str(rapport) + chr(10)
		  case 9 //Affinité
		    
		  case 10 //Déplacement
		    
		  end select
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseEnter()
		  Update
		  self.Refresh
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Update()
		  select case tsf.type
		    
		    
		  case 1  //Translation
		    
		  case 2 //Rotation
		    
		  case 3 //Demi-tour
		    
		  case 4 //Quart de tour à gauche
		    
		  case 5 //Quart de tour à droite
		    
		  case 6 //Symétrie
		    
		  case 7,  71, 72 // Homothétie
		    
		  case 8, 81, 82 //Similitude
		    centre = similaritymatrix(tsf.M).centre
		    angle = similaritymatrix(tsf.M).angle
		    rapport = similaritymatrix(tsf.M).rapport
		  case 9 //Affinité
		    
		  case 10 //Déplacement
		    
		  end select
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		tsf As transformation
	#tag EndProperty

	#tag Property, Flags = &h0
		centre As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		vecteur As Basicpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		rapport As double
	#tag EndProperty

	#tag Property, Flags = &h0
		angle As double
	#tag EndProperty


#tag EndWindowCode

