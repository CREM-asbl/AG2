#tag Class
Protected Class Modifier
Inherits SelectAndDragOperation
	#tag Method, Flags = &h0
		Sub AccrocherInitial(p as point, temp as XMLElement)
		  'Dim List As XmlNodeList
		  'DIM MF, MFInit, MFFin, EL, EL1, EL2, EL3 as XMLElement
		  'dim i, j, k, m, n, n0, sid as integer
		  'dim t as Boolean
		  'dim s as shape
		  'dim ff as figure
		  '
		  'List = Temp.XQL("ModifiedFigures")
		  'if List.length >0 then
		  'MF = XMLElement(List.Item(0))
		  'MFInit = XMLElement(MF.Child(0))
		  'MFFin = XMLElement(MF.Child(1))
		  'end if
		  '
		  'List = MFInit.XQL("PtSur")
		  'if List.length > 0 then
		  'EL2 = XMLElement(List.Item(0))
		  'end if
		  'List = MFFin.XQL("PtSur")
		  'if List.length > 0 then
		  'EL3 = XMLElement(List.Item(0))
		  'end if
		  '
		  'if EL2 <> nil then
		  'sid = val(XMLElement(EL2.child(0)).GetAttribute("Id"))
		  's = objects.getshape(sid)
		  'if FormeAbsente(sid, EL3) then
		  'p.pointsur.addshape s
		  'p.location.append val(XMLElement(EL2.child(i)).GetAttribute("Location"))
		  'p.Numside.append val(XMLElement(EL2.child(i)).GetAttribute("Numside"))
		  's.setpoint p
		  'p.mobility
		  'else
		  'p.puton s
		  'end if
		  'end if
		  '
		  'List = MFInit.XQL("Parents")
		  'if List.length > 0 then
		  'EL2 = XMLElement(List.Item(0))
		  'end if
		  '
		  'List = MFFin.XQL("Parents")
		  'if List.length > 0 then
		  'EL3 = XMLElement(List.Item(0))
		  'end if
		  '
		  'if EL2 <> nil then
		  'EL = XMLElement(Temp.child(0))
		  'if EL.childcount > 1 then
		  'EL1 = XMLElement(EL.child(1))
		  'if not (EL1.GetAttribute("Rempl") = "Ini") then
		  'EL1 = nil
		  'end if
		  'else
		  'EL1 = nil
		  'end if
		  '
		  'if EL1 <> nil then
		  'sid = val(EL1.GetAttribute("Id"))
		  'remplini =  point(objects.getshape(sid))
		  'for i = 0 to EL2.childcount-1
		  'sid = val(XMLElement(EL2.child(i)).GetAttribute("Id"))
		  'if FormeAbsente (sid, EL3)  then // Parent à l'initial qui ne l'est plus au final Substituer p au sommet. qui l'a remplacé
		  's = objects.getshape(sid)
		  's.substitutepoint(p, remplini)
		  'end if
		  'next
		  'end if
		  'end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Animer(p as point)
		  dim s as shape
		  dim dep as BasicPoint
		  
		  
		  pointmobile = p
		  currentshape = pointmobile
		  s = p.pointsur.item(0)
		  Initfigs
		  figs.createstate("InitState",pointmobile)
		  
		  figs.enablemodifyall
		  animation = true
		  
		  if s isa droite and droite(s).nextre = 0 then
		    dep = droite(s).extre2 - droite(s).extre1
		  else
		    dep = s.points(1).bpt-s.points(0).bpt
		  end if
		  
		  dep = dep/60
		  
		  if  s isa droite and dep.norme < epsilon  then
		    return
		  else
		    dret = new AnimTimer(self)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function choixvalid(s as shape) As Boolean
		  Dim i, j , ind, n0, n1 As Integer
		  Dim par, sh As shape
		  Dim t As Boolean
		  Dim p As point
		  
		  if s = nil or s.fig = nil  then
		    return false
		  end if
		  
		  p = point(s)
		  p.mobility
		  
		  if   p.liberte = 0 or (p.fused and p.constructedby.shape = nil) then
		    return false
		  end if
		  
		  if p.forme = 1 and p.constructedby <> nil and p.constructedby.oper = 10 and point(p.constructedby.shape).isextremityofaparaperpseg then
		    return false
		  end if
		  
		  if p.forme=1 and p.isextremityofaparaperpseg then
		    return false
		  end if
		  for i = 0 to ubound(p.parents)
		    sh = p.parents(i)
		    if (sh isa arc) then
		      if (sh.getindexpoint(p) = 2) and (p.pointsur.count =1) and  not (p.pointsur.item(0) isa circle and (p.pointsur.item(0).getindex(sh.points(0)) = 0) )  then
		        return false
		      end if
		    end if
		    for j = 0 to ubound(p.parents)
		      if i<> j and  (sh.constructedby <> nil and (sh.constructedby.oper = 3 or sh.constructedby.oper = 5) and sh.constructedby.shape = p.parents(j)) then
		        return false
		      end if
		    next
		  next
		  
		  
		  return true
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CompleteOperation(pc as BasicPoint)
		  if pointmobile = nil or pc.distance(EndPoint) < epsilon  then
		    return
		  end if
		  pointmobile.highlight
		  Endpoint = pc
		  figs.enablemodifyall
		  UpdateFigs(pc)
		  can.refreshBackGround
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  dim i as integer
		  
		  super.constructor
		  OpId = 21
		  CurrentContent.TheObjects.UnselectAll
		  
		  for i = 0 to CurrentContent.TheFigs.count-1
		    CurrentContent.thefigs.item(i).assocfigs = nil
		  next
		  
		  drapchoix = true
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function decal(p as point, bp as Basicpoint) As basicpoint
		  dim M as Matrix
		  
		  
		  if p.guide <> nil and p.guide <> p then
		    M = p.GetComposedMatrix(p.guide)
		    M = M.inv
		    return M*bp
		  Else
		    return bp
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DecrocherInitial(p as point, temp as XMLElement)
		  'dim List as XmlNodeList
		  'DIM MF, MFInit, MFFin, EL, EL1, EL2, EL3 as XMLElement
		  'dim i, j, k, m, n, n0, sid as integer
		  'dim t as Boolean
		  'dim s as shape
		  'dim pt as point
		  '
		  'List = Temp.XQL("ModifiedFigures")
		  'if List.length >0 then
		  'MF = XMLElement(List.Item(0))
		  'MFInit = XMLElement(MF.Child(0))
		  'MFFin = XMLElement(MF.Child(1))
		  'end if
		  '
		  'List = MFInit.XQL("PtSur")
		  'if List.length > 0 then
		  'EL2 = XMLElement(List.Item(0))
		  'end if
		  'List = MFFin.XQL("PtSur")
		  'if List.length > 0 then
		  'EL3 = XMLElement(List.Item(0))
		  'end if
		  '
		  'if EL2 <> nil then
		  'sid = val(XMLElement(EL2.child(0)).GetAttribute("Id"))
		  's = objects.getshape(sid)
		  'if  FormeAbsente(sid, EL3) then
		  'p.removepointsur(p.pointsur.item(0))
		  'end if
		  'end if
		  '
		  'List = MFInit.XQL("Parents")
		  'if List.length > 0 then
		  'EL2 = XMLElement(List.Item(0))
		  'end if
		  'List = MFFin.XQL("Parents")
		  'if List.length > 0 then
		  'EL3 = XMLElement(List.Item(0))
		  'end if
		  '
		  'if EL2 <> nil then
		  'EL = XMLElement(Temp.child(0))
		  'if EL.childcount > 1 then
		  'EL1 = XMLElement(EL.child(1))
		  'if not (EL1.GetAttribute("Rempl") = "Ini") then
		  'EL1 = nil
		  'end if
		  'else
		  'EL1 = nil
		  'end if
		  '
		  'if EL1 <> nil then
		  'remplini = Point(Objects.XMLLoadObject(EL1))
		  'for i = 0 to EL2.childcount-1
		  'sid = val(XMLElement(EL2.child(i)).GetAttribute("Id"))
		  'if FormeAbsente( sid, EL3) then // Parent à l'initial qui ne l'est pas au final
		  's = objects.getshape(sid)
		  's.substitutepoint(remplini, p)
		  'remplini.mobility
		  'p.mobility
		  'end if
		  'next
		  'end if
		  'end if
		  '
		  '
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  Dim i, Magnetism As Integer
		  
		  
		  if pointmobile = nil then
		    return
		  end if
		  
		  
		  MagneticD = new BasicPoint(0,0)
		  Magnetism= testmagnetisme(magneticD)
		  if magnetism > 0 then
		    pointmobile.drapmagn  = testfinal (magneticd)
		    if pointmobile.drapmagn   then
		      updatefigs(magneticd)
		    End If
		  end if
		  
		  pointmobile.drapmagn = false
		  pointmobile.unhighlight
		  figs.createstate("FinalState",pointmobile)
		  figs.updateoldM
		  figs.fx1cancel
		  for i = 0 to figs.count-1
		    figs.item(i).pmobi = nil
		  next
		  super.endoperation
		  pointmobile = nil
		  endpoint = Nil
		  workwindow.setFocus
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  return Dico.Value("Modify")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as basicpoint) As Shape
		  Dim i As Integer
		  dim S As point
		  dim t as boolean
		  
		  dim tableau() as integer
		  redim tableau(-1)
		  
		  nobj = 0
		  iobj = 0
		  
		  drapchoix = false
		  visible = objects.findpoint(p)
		  nobj = visible.count
		  
		  
		  if nobj = 0 then
		    drapchoix = true
		    return nil
		  end if
		  
		  for i = visible.count-1 downto 0
		    s = point(Visible.item(i))
		    if not choixvalid(s) then
		      visible.removeobject(s)
		    end if
		  next
		  
		  nobj = visible.count
		  if nobj = 0 then
		    drapchoix = true
		    return nil
		  end if
		  
		  s = point(visible.item(iobj))
		  
		  if s <> nil then
		    for i = 0 to ubound(point(s).parents)
		      if not point(s).parents(i).pointe then
		        tableau.append i
		        point(s).parents(i).pointe = true
		      end if
		    next
		    currenthighlightedshape = point(s)
		    point(s).highlight
		    drapchoix = test(point(s))
		    for i = 0 to ubound(point(s).parents)
		      if tableau.indexof(i) <> -1 then
		        point(s).parents(i).pointe = false
		      end if
		    next
		    if drapchoix then
		      currentshape = s
		      return s
		    end if
		  end if
		  
		  return nil
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitFigs()
		  Dim i As Integer
		  dim figu as figure
		  
		  cancel = false
		  figs.removeall  'figs est une propriété de SelectOperation
		  
		  figu = pointmobile.fig
		  figu.listerassociatedfigures
		  figs.addobject figu
		  for i = 0 to figu.AssocFigs.count-1
		    figs.addobject figu.assocfigs.item(i)
		  next
		  
		  if figs.ordonner  then
		    figs.cancelfixedpoints
		  else
		    cancel = true
		  end if
		  figs.enablemodifyall
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as basicpoint)
		  Dim i As Integer
		  dim s as point
		  dim a as arc
		  dim M as Matrix
		  
		  CurrentContent.TheObjects.tracept = false
		  can.ClearOffscreen
		  super.MouseDown(p)
		  
		  if currentshape = nil or not testfinished  then
		    return
		  end if
		  
		  // Attention il y a une variable "pointmobile" dans la classe "Modifier" (ici) et une autre dans la classe figure
		  //La deuxième est introduite dans Figure.update1
		  currenthighlightedshape = point(currentshape)
		  pointmobile = point(currentshape)
		  InitFigs
		  figs.createstate("InitState",pointmobile)
		  s = pointmobile
		  for i = 0 to ubound(s.parents)
		    if s.parents(i) isa arc  then
		      a = arc(s.parents(i))
		      if a.getindex(s) = 2 and a.arcangle < PI/180 and s.modified = false then
		        M = new rotationmatrix(a.coord.tab(0),PI/90)
		        s.moveto M*s.bpt
		      end if
		    end if
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDrag(pc as BasicPoint)
		  dim mag as integer
		  dim magneticd as basicpoint
		  
		  
		  
		  if cancel then
		    return
		  else
		    if visi <> nil then
		      visi.tspfalse
		    end if
		    CompleteOperation(pc)
		    mag= testmagnetisme(magneticd)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseUp(p as basicpoint)
		  if cancel then
		    return
		  else
		    super.mouseup(p)
		    WorkWindow.setcross
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseWheel()
		  dim i as integer
		  dim p as point
		  
		  if visible = nil then
		    return
		  end if
		  
		  nobj = visible.count
		  
		  if nobj > 1 then
		    iobj = (iobj+1) mod nobj
		    if CurrentHighlightedShape<>nil then
		      CurrentHighlightedShape.UnHighLight
		      p = point(CurrentHighlightedShape)
		      for i = 0 to ubound (p.parents)
		        p.parents(i).unhighlight
		      next
		    end if
		    
		    CurrentHighlightedShape = visible.item(iobj)
		    CurrentHighlightedShape.HighLight
		    
		    if currenthighlightedshape isa point then
		      p = point(CurrentHighlightedShape)
		      if p.pointsur.count = 0 then
		        for i = 0 to ubound (p.parents)
		          p.parents(i).highlight
		        next
		      end if
		    end if
		    
		    can.refreshbackground
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g As Graphics)
		  
		  super.Paint(g)
		  
		  if drapchoix = true  then
		    if currenthighlightedshape = nil   then
		      display = choose + apoint
		    else
		      currenthighlightedshape.highlight
		      currenthighlightedshape.paint(g)
		      display = thispoint +  " ?"
		    end if
		  else
		    display = dico.value("modifnotposs")
		    pointmobile = nil
		  end if
		  if pointmobile <> nil then
		    display = ""
		    pointmobile.paint(g)
		  end if
		  Help g, display
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ptguide(s as point) As point
		  if s.guide <> nil then
		    return s.Guide
		  else
		    return s
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  
		  dim EL, EL1  as XMLElement
		  dim D, dep as BasicPoint
		  
		  
		  EL = XMLElement(Temp.child(0))
		  EL1 = XMLElement(EL.child(0))
		  
		  if val(EL.GetAttribute("Animation")) = 1 then
		    animation = true
		  end if
		  
		  pointmobile = point(objects.getshape(val(EL1.GetAttribute("Id"))))
		  currentshape = pointmobile
		  'if not animation then
		  'DecrocherInitial(pointmobile, Temp)
		  'end if
		  Initfigs
		  StartPoint = new BasicPoint(val(EL1.GetAttribute("SX")), val(EL1.GetAttribute("SY")))
		  EndPoint = new BasicPoint(val(EL1.GetAttribute("EX")), val(EL1.GetAttribute("EY")))
		  
		  
		  figs.enablemodifyall
		  dep =  EndPoint-StartPoint
		  dep = dep/60
		  
		  if Config.Trace and dep.norme > epsilon  then
		    self.temp = temp
		    dret = new ModifTimer(self)
		  else
		    D = EndPoint
		    EndPoint = StartPoint
		    CompleteOperation(D)
		    ReDeleteDeletedFigures(Temp)
		    RecreateCreatedFigures(Temp)
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function test(p as Point) As Boolean
		  Dim t As Boolean
		  dim s as point
		  dim q1 as BasicPoint
		  
		  testfinished = false
		  can.Mousecursor = system.cursors.wait
		  
		  startpoint = p.bpt
		  pointmobile = p 
		  currentshape = p
		  InitFigs
		  if cancel then
		    return false
		  else
		    s = ptguide(pointmobile)
		    figs.save
		    q1 = new basicpoint(2*rnd()-1,2*rnd()-1) *(2*can.magneticdist)
		    t = figs.update(s, s.bpt+q1)
		    figs.restore
		    figs.canceloldbpts
		    figs.EnableModifyall
		    WorkWindow.setcross
		    testfinished = true
		    pointmobile = nil
		    currentshape = nil
		    return t
		  end if
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function testfinal(p as basicpoint) As Boolean
		  dim t as boolean
		  dim s as point
		  
		  figs.enablemodifyall
		  
		  s = ptguide(pointmobile)
		  figs.save
		  t =  figs.update(s, decal(pointmobile, p))
		  figs.restore
		  figs.canceloldbpts
		  figs.EnableModifyall
		  return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function testmagnetisme(byref magneticD as basicPoint) As integer
		  dim Magnetism As Integer
		  
		  Magnetism= Magnetisme(pointmobile,MagneticD)
		  
		  if cancelattraction(pointmobile)    then
		    magnetism = 0
		  else
		    currentattractedshape = pointmobile
		  end if
		  return magnetism
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  Dim Myself, EL As XMLElement
		  
		  
		  
		  
		  Myself= Doc.CreateElement(GetName)
		  EL = pointmobile.XMLPutINContainer(Doc)
		  EL.SetAttribute("SX", str(StartPoint.x))
		  EL.SetAttribute("SY", str(StartPoint.y))
		  EL.SetAttribute("EX", str(EndPoint.x))
		  EL.SetAttribute("EY", str(EndPoint.y))
		  Myself.appendchild EL
		  if animation then
		    Myself.SetAttribute("Animation","1")
		  end if
		  if remplini <> nil then
		    EL = Remplini.XMLPutInContainer(Doc)
		    EL.SetAttribute("Rempl", "Ini")
		    Myself.appendchild EL
		  end if
		  
		  return Myself
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim EL, EL1, EL3, MF, MFInit  as XMLElement
		  dim List as XmlNodeList
		  dim sid, i as integer
		  dim ff as figure
		  
		  EL = XMLElement(Temp.child(0))
		  EL1 = XMLElement(EL.child(0))
		  
		  if val(EL.GetAttribute("Animation")) = 1 then
		    animation = true
		  end if
		  pointmobile = point(objects.getshape(val(EL1.GetAttribute("Id"))))
		  pointmobile.drapmagn = true
		  
		  RedeleteCreatedFigures(temp)
		  if not animation then
		    AccrocherInitial(pointmobile,temp)
		  end if
		  RecreateDeletedFigures(temp)
		  
		  List = Temp.XQL("ModifiedFigures")
		  if List.length >0 then
		    MF = XMLElement(List.Item(0))
		    MFInit = XMLElement(MF.Child(0))
		  end if
		  
		  List = MFInit.XQL("Figure")
		  if List.length > 0 then
		    for i = 0 to List.length-1
		      EL3 = XMLElement(List.Item(i))
		      sid = val(EL3.GetAttribute("FigId"))
		      ff = CurrentContent.Thefigs.getfigure(sid)
		      if ff <> nil then
		        ff.RestoreInit(EL3)
		        ff.RestoreMmove
		        IF (FF.shapes.getposition(currentcontent.SHUL) <>-1) or (ff.shapes.getposition(currentcontent.shUA) <> -1) then
		          currentcontent.theobjects.updatelabels(1)
		        end if
		        ff.updatemacconstructedshapes
		      end if
		    next
		  end if
		  CurrentContent.optimize
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateFigs(np as BAsicPoint)
		  dim s as point
		  dim bp as basicpoint
		  
		  if pointmobile = nil then
		    return
		  end if
		  
		  s = ptguide(pointmobile)
		  bp = decal(pointmobile, np)
		  
		  figs.save
		  if not figs.update(s, bp)  then
		    figs.restore
		  end if
		  figs.canceloldbpts
		  
		  
		  
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
		animation As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		cancel As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drapchoix As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ep As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		m As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		n As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		pointmobile As point
	#tag EndProperty

	#tag Property, Flags = &h0
		remplini As point
	#tag EndProperty

	#tag Property, Flags = &h0
		Sp As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		Temp As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		testfinished As boolean
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
			Name="animation"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="cancel"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="drapchoix"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
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
			Name="m"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="n"
			Visible=false
			Group="Behavior"
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
			Name="testfinished"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
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
