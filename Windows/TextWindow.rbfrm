#tag Window
Begin Window TextWindow
   BackColor       =   16777215
   Backdrop        =   0
   BalloonHelp     =   ""
   CloseButton     =   "True"
   Composite       =   "True"
   Frame           =   0
   FullScreen      =   "False"
   HasBackColor    =   "True"
   Height          =   607
   ImplicitInstance=   "False"
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   "True"
   MaxWidth        =   32000
   MenuBar         =   0
   MenuBarVisible  =   "True"
   MinHeight       =   64
   MinimizeButton  =   "True"
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   "True"
   Title           =   ""
   Visible         =   "False"
   Width           =   822
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
      Height          =   607
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   0
      LimitText       =   0
      LockBottom      =   ""
      LockLeft        =   "True"
      LockRight       =   ""
      LockTop         =   "True"
      Mask            =   ""
      Multiline       =   "True"
      Password        =   ""
      ReadOnly        =   "True"
      Scope           =   0
      ScrollbarHorizontal=   "True"
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
      Visible         =   "True"
      Width           =   822
      BehaviorIndex   =   0
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  left = 2*wnd.width/3-5
		  width = wnd.width/3
		  height = wnd.height/3
		  objects = CurrentContent.TheObjects
		  figs = CurrentContent.TheFigs
		  EF.height = height
		  EF.ReadOnly = true
		  if wnd.MyCanvas1.sctxt = nil then
		    Title = "Objets"
		  elseif  app.Macrocreation then
		    Title = wnd.Mac.GetName
		    EF.ReadOnly = false
		  else
		    sc = wnd.MyCanvas1.sctxt
		    Title = wnd.MyCanvas1.tit
		  end if
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics)
		  dim  i, j, nc as integer
		  dim s, t as shape
		  dim mess as string
		  dim f , ff as figure
		  dim Doc as XMLDocument
		  dim FAG As XMLElement
		  
		  
		  tab = 0
		  if sc  <> nil then
		    EF.text = messages(sc)
		    return
		  end if
		  
		  if source1 or source2  then
		    
		    if CurrentContent.currentoperation <> nil and CurrentContent.currentoperation isa ReadHisto then
		      if source1 then              'ctrl u
		        Doc = new XMLDocument(ReadHisto(CurrentContent.currentoperation).Histfile)
		      else                                 'ctrl v
		        Doc = CurrentContent.MakeXML
		      end if
		    else
		      Doc = CurrentContent.MakeXML
		    end if
		    
		    if Doc <> nil then
		      FAG = Doc.DocumentElement
		      EF.Text =  ToString(XMLElement(Doc.FirstChild))
		    end if
		    
		  else
		    
		    EF.text = ""
		    
		    for i = 0 to Figs.count-1
		      f = Figs.element(i)
		      messages(f)
		      EF.Text = EF.Text + chr(10)+chr(13)
		      if f.subs.count > 0 then
		        for j=0 to f.subs.count -1
		          ff = f.subs.element(j)
		          messages(ff,j)
		          EF.Text = EF.Text +  chr(10)+chr(13)
		        next
		      end if
		      EF.Text = EF.Text + "---------------------------------------------"+ chr(10) + chr(13)
		    next
		  end if
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resizing()
		  EF.height = height
		  EF.width = width
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  EF.height = height
		  EF.width = width
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Function mess(s As shape) As string
		  
		  dim m as string
		  m = Type(s)
		  if s.std then
		    m = m+ " std"
		  end if
		  if s.hidden then
		    m = m + " caché "
		  end if
		  if s.invalid then
		    m = m + " invalide"
		  end if
		  return m
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function messconstructedby(s As shape) As string
		  dim m as string
		  dim tsf as transformation
		  
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
		    m = m + " , " + tsf.GetType + " " + "Support " +  Type(Tsf.Supp)
		  end select
		  m = m + chr(13)
		  return m
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function messconstructedshapes(s As shape) As string
		  dim i, n as integer
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
		Function messages(s As shape) As string
		  dim m as string
		  dim i as integer
		  
		  m = mess(s) + " Fig. "+ str(s.fig.idfig) +chr(13)
		  if s isa triangle or s isa arc then
		    m = m + "Orientation " + str(s.ori)+chr(13)
		  end if
		  if s.constructedby <> nil or s.conditionedby <> nil or ubound(s.constructedshapes) > -1 then
		    m = m + messlinks(s)+chr(13)
		  end if
		  if not s isa point then
		    m = m + "Sommets"+chr(13)
		    for i = 0 to ubound(s.points)
		      m = m + mess(s.points(i))
		    next
		    if ubound(s.childs) > s.npts-1 then
		      m = m + "Points Sur"+chr(13)
		      for i = s.npts to ubound(s.childs)
		        m = m + mess(s.childs(i))
		      next
		    end if
		  else
		    m = m + mess(point(s))
		  end if
		  
		  return m
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub messages(f as Figure)
		  dim i, k as integer
		  
		  EF.Text = EF.Text + "Figure "+ str(f.idfig)+chr(10)
		  EF.Text = EF.Text + "Formes: "
		  for i = 0 to f.shapes.count-1
		    EF.Text = EF.Text + mess(f.shapes.element(i))+",  "
		  next
		  EF.Text = EF.Text+chr(10)+"Sommets : "
		  for i = 0 to f.somm.count -1
		    EF.Text = EF.Text + mess(f.somm.element(i))+",  "
		  next
		  EF.Text = EF.Text+ chr(10)+"Points Sur : "
		  for i = 0 to f.PtsSur.count -1
		    EF.Text = EF.Text+ mess(f.PtsSur.element(i))+", "
		  next
		  EF.Text = EF.Text+ chr(10)+"Points Construits : "
		  for i = 0 to f.PtsConsted.count -1
		    EF.Text = EF.Text+mess(f.PtsConsted.element(i))+",  "
		  next
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function mess(f as Figure) As string
		  
		  dim i as integer
		  dim m as string
		  m = "Figure nr "+ str(f.idfig)
		  
		  
		  
		  return messauto(f,m)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function mess(p as point) As string
		  dim i as integer
		  dim m as string
		  
		  
		  m = Type(p)
		  m = m +"  (" + str(p.bpt.x) + "," + str(p.bpt.y)+") "+chr(10)
		  
		  if P.PointSur <> Nil then
		    for i = 0 to P.Pointsur.count-1
		      m = m + "Point Sur  " + Type(P.PointSur.element(i)) + " Côté:  N°" + str(P.numside(i)) + ", Abscisse :  " +str(P.location(i))+", " + chr(10)
		    next i
		  end if
		  if p.constructedby <> nil or p.conditionedby<> nil or ubound(p.constructedshapes)>-1 then
		    m = m+ messlinks(p) +chr(10)
		  end if
		  return m
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function mess(f as figure, i as integer) As string
		  dim m as string
		  m = "Sous-Figure nr "+ str(i)
		  return messauto(f,m)
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub messages(f as figure, j as integer)
		  dim s as shape
		  dim i, k as integer
		  EF.Text = EF.Text+mess(f,j)
		  
		  for i = 0 to f.shapes.count -1
		    EF.Text = EF.Text + chr(10)+ "Forme : "
		    s = f.shapes.element(i)
		    EF.Text = EF.Text+ messages(s)
		  next
		  
		End Sub
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
		    s = s + ToString(XMLElement( EL.child(i)))
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
		Sub Tabul(byref s as string, n as integer)
		  dim i as integer
		  
		  
		  for i = 0 to n-1
		    s = s + " "
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function messconditionedby(s As shape) As string
		  dim m as string
		  
		  m = "Conditioned by : " + Type(s.Conditionedby)
		  return m + chr(13)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Type(s as shape) As string
		  return  s.Identifiant + ", N°"+ str(s.id)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function messlinks(s As shape) As string
		  dim m as string
		  
		  if s.constructedby <> nil then
		    m = m  + messconstructedby(s) +chr(10)
		  end if
		  if ubound(s.constructedshapes) <> -1 then
		    m =m + messconstructedshapes(s) + chr(10)
		  end if
		  if s.conditionedby <> nil then
		    m = m + messconditionedby(s) + chr(10)
		  end if
		  
		  return m
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
		Objects As objectslist
	#tag EndProperty

	#tag Property, Flags = &h0
		Figs As FigsList
	#tag EndProperty

	#tag Property, Flags = &h0
		source1 As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		tab As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		source2 As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		sc As shape
	#tag EndProperty


#tag EndWindowCode

#tag Events EF
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  self.refresh
		End Function
	#tag EndEvent
#tag EndEvents
