#tag Class
Protected Class Prolonger
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  super.Constructor
		  colsep = true
		  OpId = 28
		  WorkWindow.PointerPolyg
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(MExe as MacroExe, EL1 as XMLElement)
		dim n, rid as integer
		
		super.Constructor
		colsep = true
		OpId = 28
		WorkWindow.PointerPolyg
		n = val(EL1.GetAttribute("Id"))
		rid = MExe.GetRealId(n)
		  BaseShape = objects.GetShape(rid)
		  SelectedSide = MExe.GetRealSide(n)
		  DoOperation
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
	Sub deplacerptssur()
		  // Moves points from the base shape to the new line and handles perpendicular adjustments
		  Dim s As shape
		  dim i,j, op as integer
		  dim Bib1, Bib2 as BiBPoint
		  dim r1, r2 as double
		  dim w as BasicPoint
		  dim p as point
		  
		  objects.unselectall
		  
		  for i =  ubound(BaseShape.childs) downto BaseShape.npts
		  p = BaseShape.Childs(i)
		  j = p.PointSur.GetPosition(BaseShape)
		  if p.numside(j) = StartIndex then
		      select case p.forme
		      case 1  // Simple point: just move to new line
		        p.removepointsur BaseShape
		        p.puton NewLine
		      case 2  // Intersection point: adjust parameters and intersection
		        s = p.PointSur.item(1-j)
		        p.removepointsur BaseShape
		        p.puton NewLine
		        p.permuterparam
		        p.adjustinter(NewLine,s)
		      end select
		      End If
		      p.fig = NewLine.fig
		  next
		  
		  
		  for i = 2 to ubound(NewLine.childs)
		  p = NewLine.childs(i)
		  for j = 0 to ubound(p.parents)
		  s = p.parents(j)
		  if s <> NewLine and s.isaparaperp then
		  w = droite(s).constructbasis
		  bib1 = new Bibpoint(droite(s).firstp, droite(s).firstp+w)
		  bib2 = new Bibpoint(NewLine.firstp, NewLine.secondp)
		  w = Bib1.BiBInterdroites(Bib2,droite(s).nextre, NewLine.nextre,r1, r2)
		  if w <> nil then
		  p.valider
		  point(p).moveto w
		  p.puton NewLine
		  end if
		  end if
		  next
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
	Sub DoOperation()
		  // Performs the prolongation operation: creates a new line extending the selected side
		  Dim i, j As Integer
		  
		  BaseShape = currenthighlightedshape
		  if not currentcontent.macrocreation then
		  CurrentContent.TheFigs.Removefigure BaseShape.fig
		  end if
		  GetSide

		  NewLine = New Droite(objects, BaseShape.points(StartIndex), BaseShape.points(EndIndex), 0)
		  deplacerptssur
		  if BaseShape isa Lacet then
		  if Lacet(BaseShape).prol.count = 0 then
		  redim Lacet(BaseShape).prol(BaseShape.npts-1)
		  end if
		  Lacet(BaseShape).prol(StartIndex) = true
		  end if

		  NewLine.endconstruction
		  NewLine.setconstructedby BaseShape, 8
		  NewLine.Constructedby.data.append StartIndex

		  UpdateChildFigures(NewLine)
		  
		  
		  
		  
		  
		End Sub
		#tag EndMethod

		#tag Method, Flags = &h21
		Private Sub UpdateChildFigures(line As Droite)
		  // Updates figure references for all child points of the new line
		  Dim i, j As Integer
		  for i = 2 to ubound(line.childs)
		    line.childs(i).fig = line.fig
		    line.fig.PtsSur.addshape line.childs(i)
		    for j = 0 to line.fig.subs.count - 1
		      if line.fig.subs.item(j).shapes.getposition(line) <> -1 then
		        line.fig.subs.item(j).PtsSur.addshape line.childs(i)
		      End If
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  
		  super.endoperation

		  BaseShape = nil
		  NewLine = nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return   Dico.value("Prolonger")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
	Function GetShape(p as BasicPoint) As shape
		  // Determines if a shape at point p can be prolonged, filtering out invalid shapes
		  Dim s As shape
		  dim i as integer
		  
		  s = operation.GetShape(p)
		  
		  if s = nil then
		  return nil
		  end if
		  dim n as integer
  dim sideIndex as integer
		  
		  for i = visible.count-1 downto 0
		    s = Visible.item(i)
		    // Exclure bandes et secteurs
		    if s isa Bande or s isa Secteur then
		      visible.removeobject(s)
		      continue
		    end if
		    
		    // Segment valide au point p (peut fixer sideIndex)
		    if not s.ValidSegment(p, sideIndex) then
		      visible.removeobject(s)
		      continue
		    end if
		    // Exclure arcs: côté courbe au point (pour les lacets non-cubes)
		    if s isa Lacet then
		      n = s.pointonside(p)
		      if n <> -1 and not s isa cube and s.coord.curved(n) = 1 then
		        visible.removeobject(s)
		        continue
		      end if
		    end if
		    // Exclure droites déjà complètes
		    if s isa droite and droite(s).nextre = 0 then
		      visible.removeobject(s)
		      continue
		    end if
		  next

		  if visible.count = 0 then
		    return nil
		  end if

  nobj = visible.count
  redim index(-1)
  redim index(nobj)
		  
		  iobj = 0
		  
		  For i = 0 To visible.count-1
		    s = visible.item(i)
		    if s isa droite then
		      index(i) = 0
		    else
		      index(i) = Lacet(s).pointonside(p)
		    end if
		  next
		  
		  s = visible.item(iobj)
		  if s = nil then
		    return nil
		  end if
		  SelectedSide = index(iobj)
		  // Prolongation déjà effectuée pour ce côté (formes lacets)
		  if s isa Lacet and Lacet(s).prol.count > 0 and Lacet(s).prol(SelectedSide) then
		  return nil
		  end if
		  return s
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetSide()
		  
		  if BaseShape isa cube then
		  cube(BaseShape).GetIbipJbip(SelectedSide,StartIndex,EndIndex)
		  elseif BaseShape isa Lacet then
		  StartIndex = SelectedSide
		  EndIndex = (SelectedSide+1) mod BaseShape.npts
		  elseif BaseShape isa droite then
		  StartIndex = 0
		  EndIndex = 1
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  Dim sh As shape
		  
		  sh = currenthighlightedshape
		  display = ""
		  if visible  = nil or sh = nil then
		    display = choose + asegment + ou + asideofpoly
		  else
		    super.paint(g)
		    if sh isa Lacet then
		    Lacet(sh).PaintSide(g,SelectedSide,2,config.HighlightColor)
		    if not sh isa cube and sh.coord.curved(SelectedSide)=1 then
		      display = thisarc + "?"
		    else
		    display = thissideofpoly + "?"
		    end if
		    else
		    display = thissegment + "?"
		    end if
		  end if
		  Help g, display
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim  EL1, EL2  as XMLElement
		  dim i as integer
		  dim p as point
		  
		  EL1 = XMLElement(Temp.child(0))
		  EL2 = XMLElement(EL1.child(0))
		  BaseShape = objects.getshape(val(EL2.GetAttribute("Id")))
		  EL2 = XMLElement(EL1.child(1))
		  NewLine = Droite(Objects.XMLLoadObject(EL2))
		  StartIndex = val(EL2.GetAttribute("Ibip"))
		  EndIndex = (StartIndex+1) mod BaseShape.npts
		  if BaseShape isa Lacet then
		  Lacet(BaseShape).prol(StartIndex) = true
		  end if

		  for i =  ubound(BaseShape.childs) downto BaseShape.npts
		  p = BaseShape.Childs(i)
		  if p.numside(0) = StartIndex then
		  p.removepointsur BaseShape
		  p.puton NewLine
		  end if
		  next
		  
		  
		  
		  RedeleteDeletedFigures(temp)
		  RecreateCreatedFigures(temp)
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
	Sub replacerperp()
		  // Moves points back from the new line to the base shape during undo
		  dim j as integer
		  dim p as point
		  
		  
		  
		  
		  for j = ubound(NewLine.childs) downto  NewLine.npts
		  p = NewLine.Childs(j)
		  p.removepointsur NewLine
		  p.puton BaseShape
		  p.numside(0) = StartIndex
		  if BaseShape.pointonside(p.bpt) = -1 then
		  p.invalider
		  end if
		    if p.location(0) < 0 or p.location(0)> 1 then
		      p.invalider
		    end if
		  next
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XmlDocument, EL as XMLElement) As XMLElement
		  dim Temp as XMLElement
		  
		  Temp =  NewLine.XMLPutIdInContainer(Doc)
		  Temp.AppendChild NewLine.XMLPutChildsInContainer(Doc)
		  EL.appendchild Temp
		  EL.AppendChild NewLine.XMLPutConstructionInfoInContainer(Doc)
		  
		  return EL
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  dim Temp, EL as XMLElement
		  
		  Temp=Doc.CreateElement(GetName)
		  Temp.appendChild BaseShape.XMLPutInContainer(Doc)
		  EL = NewLine.XMLPutIncontainer(Doc)
		  EL.SetAttribute("Ibip", str(StartIndex))
		  Temp.Appendchild EL
		  return Temp
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim  EL1, EL2  as XMLElement
		  
		  
		  EL1 = XMLElement(Temp.child(0))
		  EL2 = XMLElement(EL1.child(0))
		  BaseShape = objects.getshape(val(EL2.GetAttribute("Id")))

		  EL2 = XMLElement(EL1.child(1))
		  NewLine = droite(objects.getshape(val(EL2.GetAttribute("Id"))))
		  if BaseShape isa Lacet then
		  StartIndex = val(EL2.GetAttribute("Ibip"))
		  Lacet(BaseShape).prol(StartIndex) = false
		  end if
		  replacerperp

		  NewLine.delete
		  RedeleteCreatedFigures(temp)
		  RecreateDeletedFigures(temp)
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
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
		BaseShape As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		SelectedSide As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		NewLine As Droite
	#tag EndProperty

	#tag Property, Flags = &h0
		StartIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		EndIndex As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="canceling"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsep"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
		Name="SelectedSide"
		Visible=false
		Group="Behavior"
		InitialValue="0"
		Type="Integer"
		EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
		Name="StartIndex"
		Visible=false
		Group="Behavior"
		InitialValue="0"
		Type="Integer"
		EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="info"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
		Name="EndIndex"
		Visible=false
		Group="Behavior"
		InitialValue="0"
		Type="Integer"
		EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
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
			Name="nobj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ntsf"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
