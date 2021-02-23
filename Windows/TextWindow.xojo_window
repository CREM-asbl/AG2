#tag Window
Begin Window TextWindow
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Composite       =   True
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   True
   Height          =   607
   ImplicitInstance=   False
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   0
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   ""
   Visible         =   False
   Width           =   822
   Begin TextArea EF
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   &c00FFFFFF
      Bold            =   False
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   607
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   0
      LimitText       =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      ScrollbarHorizontal=   True
      ScrollbarVertical=   True
      Styled          =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   0
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   "0"
      UseFocusRing    =   False
      Visible         =   True
      Width           =   822
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  left = 2*WorkWindow.width/3-5
		  width = WorkWindow.width/3
		  height = WorkWindow.height/3
		  objects = CurrentContent.TheObjects
		  Figs = CurrentContent.TheFigs
		  Macs = app.TheMacros
		  EF.height = height
		  EF.ReadOnly = true
		  EF.Backcolor=&cFFFFFF
		  if can.sctxt = nil then
		    Title = "Objets"
		  elseif  currentcontent.Macrocreation then
		    Title =currentcontent.Mac.GetName
		    EF.ReadOnly = false
		  else
		    sc = can.sctxt
		    Title = can.tit
		  end if
		  
		  Afficher
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


	#tag Method, Flags = &h0
		Sub Afficher()
		  dim  i, j as integer
		  dim f , ff as figure
		  dim Doc as XMLDocument
		  dim FAG As XMLElement
		  
		  tab = 0
		  if sc  <> nil then
		    EF.text = messages(sc)
		    return
		  end if
		  
		  
		  
		  EF.Text = "Largeur du fonds d'écran: "
		  EF.Text = EF.Text+ str(can.width) + chr(10)
		  EF.Text =  EF.Text+ "Hauteur du fonds d'écran: " +str(can.height) + chr(10)+chr(13)
		  
		  for i = 0 to Figs.count-1
		    f = Figs.item(i)
		    messages(f)
		    if f.subs.count > 0 then
		      for j=0 to f.subs.count -1
		        EF.Text =  EF.Text +chr(10)+chr(13)
		        ff = f.subs.item(j)
		        messages(ff,j)
		      next
		    end if
		    EF.Text = EF.Text + "---------------------------------------------"+chr(10)+chr(13)
		  next
		  
		  
		  for i = 0 to Macs.count-1
		    EF.Text = EF.Text + Macs.item(i).caption +chr(10)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function mess(f as Figure) As string
		  
		  dim m as string
		  m = "Figure nr "+ str(f.idfig)
		  
		  
		  
		  return messauto(f,m)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function mess(f as figure, i as integer) As string
		  dim m as string
		  
		  m = chr(13)+"Sous-Figure nr "+ str(i)
		  return messauto(f,m) + chr(10)
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function mess(p as point) As string
		  dim i as integer
		  dim m as string
		  
		  
		  m = Type(p)
		  m = m +"  (" + str(p.bpt.x) + "," + str(p.bpt.y)+") "+ ", forme = "+ str(p.forme)+ ", "
		  if p.invalid then
		    m = m + "invalid"
		  end if
		  if P.PointSur <> Nil then
		    for i = 0 to P.Pointsur.count-1
		      m = m + "Point Sur  " + Type(P.PointSur.item(i)) + " Côté:  N°" + str(P.numside(i)) + ", Abscisse :  " +str(P.location(i))+", "
		    next i
		  end if
		  if p.constructedby <> nil or p.conditionedby<> nil or ubound(p.constructedshapes)>-1 then
		    m = m+ messlinks(p)
		  end if
		  return m
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function mess(s As shape) As string
		  dim i as integer
		  dim m as string
		  m = Type(s)
		  if s.std then
		    m = m+ ", std"
		  end if
		  if s.hidden then
		    m = m + ", caché "
		  end if
		  if s.invalid then
		    m = m + ", invalide"
		  end if
		  if s.constructedby <> nil and s.constructedby.shape <> nil then
		    m = m + ", construit par forme " + str(s.constructedby.shape.id)
		  end if
		  if s.macconstructedby <> nil then
		    m = m+", mac-construit par formes ("
		    for i = 0 to ubound(s.MacConstructedby.RealInit)
		      m = m +"," + str(s.MacConstructedby.RealInit(i))
		    next
		    m = m+ ")"
		  end if
		  
		  return m + chr(10)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub messages(f as Figure)
		  Dim i As Integer
		  
		  EF.Text = EF.Text + "Figure "+ Str(f.idfig) + Chr(10)
		  EF.Text = EF.Text + "Formes: "
		  For i = 0 To f.shapes.count-1
		    EF.Text = EF.Text + mess(f.shapes.item(i))+",  "
		  next
		  EF.Text = EF.Text + Chr(10)
		  EF.Text = EF.Text+"Sommets : "
		  For i = 0 To f.somm.count -2
		    EF.Text = EF.Text + mess(f.somm.item(i))+", "
		  Next
		  EF.Text = EF.Text + mess(f.somm.item(f.somm.count-1))+"."+Chr(10)
		  If  f.PtsSur.count > 0 Then
		    EF.Text = EF.Text+ Chr(10)+"Points Sur : "
		    For i = 0 To f.PtsSur.count -2
		      EF.Text = EF.Text+ mess(f.PtsSur.item(i))+", "
		    Next
		    EF.Text = EF.Text + mess(f.PtsSur.item(f.PtsSur.count-1))+"."+Chr(10)
		  End If
		  If f.PtsConsted.count > 0 Then
		    EF.Text = EF.Text+ Chr(10)+"Points Construits : "
		    For i = 0 To f.PtsConsted.count -2
		      EF.Text = EF.Text+mess(f.PtsConsted.item(i))+",  "
		    Next
		    EF.Text = EF.Text+mess(f.PtsConsted.item(f.PtsConsted.count-1))+"."
		  end if
		  EF.Text = EF.Text + chr(10)+chr(13)
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub messages(f as figure, j as integer)
		  dim s as shape
		  dim i as integer
		  EF.Text = EF.Text+mess(f,j)
		  
		  for i = 0 to f.shapes.count -1
		    EF.Text = EF.Text + chr(10)+ "Forme : "
		    s = f.shapes.item(i)
		    EF.Text = EF.Text+ messages(s) +chr(10)
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function messages(s As shape) As string
		  dim m as string
		  dim i as integer
		  
		  m = mess(s) + " Plan " + str(s.plan)+ " Fig. "+ str(s.fig.idfig) + " "
		  if s isa triangle or s isa arc then
		    m = m + "Orientation " + str(s.ori)+chr(10)
		  end if
		  if s isa arc then
		    m = m+"Angle: " + str((Arc(s).arcangle)*180/PI)+"°"
		  end if
		  m = m+chr(10)
		  if s.constructedby <> nil or s.conditionedby <> nil  then
		    m = m + messlinks(s)
		  end if
		  if not s isa point then
		    m = m + "Sommets"+chr(13)
		    for i = 0 to ubound(s.points)
		      m = m + mess(s.points(i))+chr(10)
		    next
		    if ubound(s.childs) > s.npts-1 then
		      m = m + "Points Sur"+chr(13)
		      for i = s.npts to ubound(s.childs)
		        m = m + mess(s.childs(i)) + chr(10)
		      next
		    end if
		    if ubound(s.constructedshapes)> -1 then
		      m = m + "Formes Construites"+chr(10)
		      for i = 0 to ubound(s.constructedshapes)
		        if s.ConstructedShapes(i) isa point then
		          m = m+ mess(point(s.constructedshapes(i)))
		        else
		          m = m + mess(s.constructedshapes(i))
		        end if
		      next
		    end if
		  else
		    m = m + mess(point(s))
		  end if
		  
		  return m+ chr(10)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function messauto(f as figure, m as string) As string
		  select case  f.auto
		  case 0
		    m = m + " image or std"
		  case 1
		    m = m + " autosim"
		  case 2
		    m = m + " autoaff"
		  case 3
		    m = m+" autospe"
		  case 4
		    m = m + " qcq"
		  case 5
		    m = m + " autotrap"
		  case 6
		    m = m+" autoprpp"
		  end select
		  return m
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function messconditionedby(s As shape) As string
		  dim m as string
		  
		  m = "Conditioned by : " + Type(s.Conditionedby)
		  return m + chr(13)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function messconstructedby(s As shape) As string
		  Dim m As String
		  dim tsf as transformation
		  
		  if s.constructedby.oper <> 9 then
		    m = "Construit par : "  +  Type(s.constructedby.shape)
		    select case s.constructedby.oper
		    case 0
		      m = m + ",  Centre"
		    case 3
		      m = m + ",  Duplication"
		    case 4
		      m = m+ ", Point de division"
		    case 6
		      tsf =  Transformation(s.constructedby.data(0))
		      m = m + ", " + tsf.GetType + " " + "Support " +  Type(Tsf.Supp)
		    Case 45
		      m = m+ ", AutoIntersection"
		    end select
		    m = m + chr(13)
		    return m
		  elseif s isa polygon then
		    m = "Construit par fusion "  +  Type(shape(s.constructedby.data(0))) + " et " + Type(shape(s.constructedby.data(2)))
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function messconstructedshapes(s As shape) As string
		  dim i as integer
		  dim m as string
		  dim tsf as transformation
		  
		  m ="Formes construites : "+ chr(13)
		  for i = 0 to  ubound(s.constructedshapes)
		    select case s.constructedshapes(i).constructedby.oper
		    case 0
		      m = m + "Centre "
		    case 3
		      m = m + "Duplication "
		    case 4
		      m = m + "Point de division "
		    case 6
		      tsf =  Transformation(s.constructedshapes(i).constructedby.data(0))
		      m = m +  tsf.GetType + " " + "Support " +  Tsf.Supp.GetType + " " + str(tsf.supp.id) +" "
		    end select
		    m = m + Type(s.ConstructedShapes(i)) +chr(13)
		  next
		  
		  return m
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function messlinks(s As shape) As string
		  dim m as string
		  
		  if s.constructedby <> nil then
		    m = m  + messconstructedby(s) +chr(10)
		  end if
		  
		  if s.conditionedby <> nil then
		    m = m + messconditionedby(s) + chr(10)
		  end if
		  
		  return m
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Tabul(byref s as string, n as integer)
		  dim i as integer
		  
		  
		  for i = 0 to n-1
		    s = s + " "
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(EL as XMLElement) As string
		  dim s, name as string
		  dim i, k, n as integer
		  
		  
		  Name = EL.Name
		  k = Instr(EL.ToString, ">")
		  
		  s = left(EL.ToString, k) +chr(13)
		  tab = tab+6
		  n = EL.ChildCount-1
		  for i = 0 to n
		    tabul(s, tab)
		    s = s + XMLElement( EL.child(i)).ToString
		  next
		  tab = tab-6
		  if n>-1 then
		    tabul(s,tab)
		    s = s+ "</"+Name+">"+chr(13)
		  end if
		  
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Type(s as shape) As string
		  return  s.Identifiant + ", N°"+ str(s.id)
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


	#tag Property, Flags = &h0
		Figs As FigsList
	#tag EndProperty

	#tag Property, Flags = &h0
		Macs As MacrosList
	#tag EndProperty

	#tag Property, Flags = &h0
		Objects As objectslist
	#tag EndProperty

	#tag Property, Flags = &h0
		sc As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		tab As Integer
	#tag EndProperty


#tag EndWindowCode

#tag Events EF
	#tag Event
		Sub TextChange()
		  self.Afficher
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
		Type="Color"
		EditorType="Color"
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
		Type="MenuBar"
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
		Name="tab"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
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
