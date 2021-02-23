#tag Class
Protected Class SelectAndDragOperation
Inherits SelectOperation
	#tag Method, Flags = &h0
		Function Ajustement() As Matrix
		  dim q, MagneticD as BasicPoint
		  dim FirstAttractedPoint, SecondAttractedPoint, Pt, p as Point
		  dim i,j, Magnetism as Integer
		  dim M as SimilarityMatrix
		  dim Pol, s, s0 as Shape
		  
		  if (not  CurrentAttractedShape isa point) or (not CurrentAttractingshape isa point) or (CurrentAttractedshape.fig = Currentattractingshape.fig)  then
		    return nil
		  end if
		  
		  FirstAttractedPoint = Point(CurrentAttractedShape)
		  p = point(CurrentAttractingShape)
		  s0 = nil
		  
		  for i = 0 to Ubound(p.parents)
		    for j = 0 to Ubound(FirstAttractedPoint.parents)
		      Pol = FirstAttractedPoint.parents(j)
		      if Pol.getindexpoint(FirstAttractedPoint) <> -1 then
		        s = p.parents(i)
		        if  Pol isa Polygon and not Pol isa cube  then
		          Pt = Polygon(Pol).PrecPoint(FirstAttractedPoint)
		          ajustermagnetisme(s, s0, Pt, SecondAttractedPoint, Magnetism, MagneticD)
		          Pt = Polygon(Pol).NextPoint(FirstAttractedPoint)
		          ajustermagnetisme(s, s0,  Pt, SecondAttractedPoint, Magnetism, MagneticD)
		        elseif Pol isa Droite then
		          Pt = Droite(Pol).otherpoint(FirstAttractedPoint)
		          ajustermagnetisme(s, s0,Pt, SecondAttractedPoint, Magnetism, MagneticD)
		        end if
		      end if
		    next
		  next
		  
		  if (Magnetism = 0) or (s0=nil) or (secondattractedpoint <> nil and (s0.fig = SecondAttractedPoint.fig)) then
		    return nil
		  end if
		  
		  q = magneticD
		  if q.distance(Pt.bpt) <= can.magneticdist then '4*epsilon then
		    q = Pt.bpt
		  end if
		  M = new SimilarityMatrix(FirstAttractedPoint.bpt,SecondAttractedPoint.bpt, Firstattractedpoint.bpt,q)
		  if Pol.std then
		    M = new RotationMatrix(FirstAttractedPoint.bpt, M.angle)
		  end if
		  if M <> nil and M.v1 <> nil then
		    figs.Bouger(M)
		    RotationPoint=FirstAttractedPoint
		    'updateangles(M.angle)
		    return M
		  end if
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ajuster()
		  dim p as point
		  dim M as Matrix
		  
		  if Config.Ajust and angle <> 0 then
		    p = Point(Objects.GetShape(fid))
		    M = new RotationMatrix(p.bpt, angle)
		    figs.Bouger(M)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ajustermagnetisme(s as shape, Byref s0 as shape, Pt as Point, byref SP as point, byref Mag as integer, byref MagD as Basicpoint)
		  
		  dim  ts as shape
		  dim tp1 as integer
		  dim mp as basicpoint
		  
		  
		  tp1 = Pt.Magnetism2(s,mp,Ts)
		  if tp1 > Mag then
		    SP = Pt
		    Mag = tp1
		    MagD = mp
		    s0 = s
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CompleteOperation(NewPoint as BasicPoint)
		  can.refreshBackGround
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor()
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOper(NewPoint as BasicPoint)
		  NewPoint = EndPoint+NewPoint
		  CompleteOperation(NewPoint)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Glissement(NewPoint as BasicPoint)
		  dim AttractedShape,AttractingShape,NextAttractingShape as Shape
		  dim Magnetism,tempm As  Integer
		  dim Mp as BasicPoint
		  dim i as integer
		  dim M as Matrix
		  
		  
		  Magnetism = 0
		  
		  M = new Translationmatrix(NewPoint-EndPoint)
		  
		  if self isa Duplicate then
		    figs.move(M)
		  else
		    figs.Bouger(M)
		  end if
		  endpoint = newpoint
		  
		  if dret = nil then
		    for i = 0 to figs.count-1
		      tempM =  Magnetisme(MagneticD, figs.item(i))
		      if tempM > Magnetism then
		        Magnetism = tempm
		        Mp =  MagneticD
		        AttractedShape = CurrentAttractedShape
		        AttractingShape = CurrentAttractingShape
		        NextAttractingShape = NextCurrentAttractingShape
		      end if
		    next
		    CurrentAttractedShape = AttractedShape
		    CurrentAttractingShape = AttractingShape
		    NextCurrentAttractingShape = NextAttractingShape
		    MagneticD = Mp
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p As BasicPoint)
		  // Sert à établir la liste des formes sélectionnées
		  dim i,j as integer
		  dim pt as Point
		  
		  drapUA = false
		  drapUL = false
		  figs.removeall
		  
		  StartPoint = p
		  EndPoint = p
		  
		  if (CurrentHighlightedShape = nil) and (self isa modifier)    then
		    return
		  end if
		  
		  if currenthighlightedshape = nil and  objects.findobject(p).count = 0  then
		    Objects.unselectall
		    CurrentShape = can.getrepere
		    StartPoint = can.MouseCan
		    EndPoint = StartPoint
		    objects.selectobject(currentshape)
		    
		  elseif currenthighlightedshape <> nil then
		    selection
		    currentshape = currenthighlightedshape
		    objects.tspfalse
		    finished = false
		    WorkWindow.refreshtitle
		    
		    if not self isa modifier    then
		      CurrentShape.SelectNeighboor //sélectionne  toute la figure  et les formes  liées
		      for i = 0 to tempshape.count-1
		        figs.addobject tempshape.item(i).fig
		      next
		      figs.creerlistesfigures
		      figs.figs0.createstate("FigsMoved", nil)
		    end if
		    
		    if self isa redimensionner then
		      for i = 0 to figs.count -1
		        if figs.item(i).shapes.getposition(currentcontent.SHUL) <> -1 then
		          drapUL = true
		        end if
		        if figs.item(i).shapes.getposition(currentcontent.SHUA) <> -1 then
		          drapUA = true
		        end if
		      next
		    end if
		    
		  end if
		  nobj = 1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDrag(pc As BasicPoint)
		  
		  dim i as integer
		  
		  if  tempshape.count = 0 or currentshape = nil  then
		    return
		  end if
		  ReinitAttraction
		  
		  if CurrentShape isa repere then
		    pc = can.transform(pc)
		  end if
		  
		  if visi <> nil then
		    visi.tspfalse
		  end if
		  
		  if not self isa modifier then
		    visi = objects.findobject(pc)
		    for i = 0 to visi.count-1
		      if objects.getposition(currentshape) < objects.getposition(visi.item(i)) then
		        visi.item(i).tsp = true
		      else
		        visi.item(i).tsp = false
		      end if
		    next
		  end if
		  
		  
		  CompleteOperation(pc)
		  ShowAttraction
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseUp(p As BasicPoint)
		  
		  if  tempshape.count > 0 then
		    can.MouseCursor = system.cursors.wait
		    endoperation
		  else
		    super.mouseup(p)
		  end if
		  if visi <> nil then
		    visi.tspfalse
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim i, idf as integer
		  dim EL as XMLNode
		  dim EL1, EL2 as XMLElement
		  dim ff as figure
		  dim List as XmlNodeList
		  
		  List = Temp.Xql("MovedFigures")
		  if List.Length > 0 then
		    EL = List.Item(0)
		    EL1 = XMLElement(EL.child(0))
		    for i = 0 to EL1.childcount-1
		      EL2 = XMLElement(EL1.child(i))
		      idf = val(EL2.GetAttribute("FigId"))
		      ff = CurrentContent.Thefigs.getfigure(idf)
		      if (ff <> nil) then
		        ff.RestoreInit(EL2)
		        ff.updatemacconstructedshapes
		      end if
		    next
		  end if
		  WorkWindow.refresh
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("List",List)
		    d.setVariable("EL",EL)
		    d.setVariable("EL1",EL1)
		    d.setVariable("EL2",EL2)
		    d.setVariable("ff",ff)
		    err.message = err.message+d.getString
		    
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateangles(a as double)
		  dim i as integer
		  dim s as shape
		  
		  for i = 0 to tempshape.count-1
		    s = tempshape.item(i)
		    if s isa StandardPolygon  then
		      StandardPolygon(s).angles(0) = StandardPolygon(s).angles(0) - a
		    end if
		    if s isa StdCircle  then
		      StdCircle(s).angles(0) = StdCircle(s).angles(0) - a
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VectInter(n as integer) As BasicPoint
		  dim p as BasicPoint
		  p = EndPoint-StartPoint
		  EndPoint = StartPoint
		  return p/n
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
		Angle As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		drapUA As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drapUL As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		EndPoint As basicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		fid As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		MagneticD As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		RotationPoint As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		StartPoint As Basicpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		visi As Objectslist
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Angle"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
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
			Name="display"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapUA"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapUL"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="fid"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
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
