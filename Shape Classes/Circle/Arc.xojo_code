#tag Class
Protected Class Arc
Inherits Circle
	#tag CompatibilityFlags = (TargetDesktop and (Target32Bit or Target64Bit))
	#tag Method, Flags = &h0
		Function aire() As double
		  return arcangle*Pow(getradius,2)/2
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ArcComputeFirstIntersect(s as shape) As BasicPoint
		  dim q() as BasicPoint
		  dim Bib, BiB0 As  BiBPoint
		  dim i,n, k as integer
		  dim bq, v, w as BasicPoint
		  dim p as point
		  redim q(-1)
		  redim q(1)
		  dim  b1, b2 as double
		  dim ff as figure
		  dim ep0, ep1, ep2, np0,np1,np2 as BasicPoint
		  
		  epnp(ep0,ep1,ep2,np0,np1,np2)
		  
		  p = points(2)  ' ce point est "sur" s
		  if p.forme <> 1 then
		    return nil
		  end if
		  k = p.numside(0)
		  ff = p.GetSousFigure(fig)
		  
		  BiB0 = new BiBPoint(points(0).bpt, points(1).bpt)
		  if S isa Droite or S isa Lacet  then
		    Bib = S.getBiBside(k)
		    select case BiB.nextre
		    case 0
		      n = Bib.BiBDroiteInterCercle(BiB0, q(), bq, v)
		    case 1
		      n = Bib.BiBDemiDroiteInterCercle(Bib0, q(), bq, v)
		    case 2
		      n = Bib.BiBSegmentInterCercle(Bib0, q(), bq, v)
		    end select
		    'n = ubound(q)+1
		  end if
		  if (n = 0) then
		    return nil
		  end if
		  
		  if S isa Circle then
		    Bib = new BiBpoint(S.Points(0).bpt,  S.Points(1).bpt)
		    n = BiB0.BiBInterCercles(Bib,q(),bq,v)
		    if n = 0 then
		      return p.bpt
		    end if
		  end if
		  
		  for i = 1 downto 0
		    if q(i) = nil then
		      q.remove i
		    end if
		  next
		  n = ubound(q)+1
		  
		  if n = 1 then
		    return q(0)
		  end if
		  
		  if n = 2 then
		    
		    if ff.replacerpoint(p) then
		      b1 = amplitude(np1,np0,q(0))
		      b2 = amplitude(np1,np0,q(1))
		      if ori > 0 then
		        if b1 <= b2 then
		          np2 = q(0)
		        else 
		          np2 = q(1)
		        end if
		      else
		        if b1 <= b2 then
		          np2 = q(1)
		        else 
		          np2 = q(0)
		        end if
		      end if
		      return np2
		    else
		      if ep2.distance(q(0)) > ep2.distance(q(1)) then
		        q(0) = q(1)
		        return q(0)
		      else
		        return nil
		      end if
		    end if
		  end if
		  return p.bpt
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function check() As Boolean
		  dim d as double
		  dim v as BasicPoint
		  
		  if invalid  then
		    return true
		  end if
		  
		  
		  d = Points(0).distanceto(Points(1))
		  v = Points(2).bpt-Points(0).bpt
		  v = v.normer
		  Points(2).moveto Points(0).bpt+ v*d
		  
		  if Points(2).pointsur.count> 0 then
		    points(2).puton points(2).pointsur.item(0)
		  end if
		  return true
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function computeangle(q as Basicpoint) As double
		  return coord.computeangle(q,ori)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeArcAngle()
		  startangle = coord.startangle   
		  endangle = coord.endangle     
		  // startangle et endangle  sont toujours entre 0 et 2 pi
		  
		  if not drapori then
		    ori = coord.orientation                         'points(0).bpt.orientation(points(1).bpt,points(2).bpt)
		  end if
		  if  abs(endangle-startangle)  >  0.4 and ori <> 0 then
		    drapori = true  //on ne peut plus changer l'orientation
		  end if
		  arcangle = computeangle(points(2).bpt)
		  'arcangle a toujours meme signe que l'orientation
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeori()
		  updatecoord
		  if not drapori then
		    ori = coord.orientation
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Ol as ObjectsList, s as Arc, p as basicPoint)
		  dim M as Matrix
		  
		  shape.Constructor(ol,s)
		  ncpts = 2
		  narcs = 1
		  arcangle = s.arcangle
		  endangle = s.endangle
		  startangle = s.startangle
		  IndexConstructedPoint = 2   '(clutch)
		  drapori = s.drapori
		  ori =s.ori
		  PasteCtrlExe(s)
		  createskull(p)
		  liberte = 5
		  M = new TranslationMatrix (p)
		  Move(M)
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, p as basicPoint)
		  
		  Super.Constructor(ol,3,p)
		  liberte = 5
		  narcs = 1
		  createskull(p)
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, Temp as XMLElement)
		  Shape.Constructor(ol,Temp)
		  IndexConstructedPoint = 2  '(clutch)
		  ncpts = 3
		  narcs = 1
		  liberte = 5
		  drapori = true
		  createskull(points(0).bpt)
		  arcangle = computeangle(points(2).bpt)
		  nsk.updatesize(1)
		  coord.CreateExtreAndCtrlPoints(ori)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape()
		  super.ConstructShape
		  computeradius
		  computearcangle
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createskull(p as BasicPoint)
		  
		  nsk = new ArcSkull(p)
		  nsk.skullof = self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndConstruction()
		  drapori = true
		  super.endconstruction
		  'if currentcontent.currentoperation isa macroexe then
		  'computeradius
		  'updateangles
		  'CreateExtreAndCtrlPoints
		  'end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EndP() As BasicPoint
		  return Points(2).bpt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as BasicPoint, n as integer)
		  Dim i As Integer
		  
		  for i = n to 2
		    Points(i).moveto(p)
		  next
		  
		  updatecoord
		  
		  select case n
		  case 0
		    arcangle = 0
		    coord.centres(1) = p
		  case 1
		    coord.curved(1) = 1
		    coord.CreateExtreAndCtrlPoints(ori)
		    computeradius
		    startangle = coord.startangle         
		  case 2
		    constructshape
		    updatecoord
		    coord.CreateExtreAndCtrlPoints(ori)
		  end select
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecouleurtrait(i as integer, c as couleur)
		  BorderColor = c
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.value("Arc")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Inside(p as BasicPoint) As Boolean
		  dim a as double
		  a = computeangle(p)
		  return (abs(a) <= abs(arcangle)) 
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier33() As Matrix
		  dim s as Shape
		  dim np2 as BasicPoint
		  dim p as Point
		  
		  s = points(2).pointsur.item(0)
		  np2 = Arccomputefirstintersect(s)
		  if np2 <> nil then
		    points(2).bpt = np2
		    points(2).modified = true
		    points(2).valider
		    return  AffiOrSimili
		  else
		    points(2).invalider
		    return new Matrix(1)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as Graphics)
		  if abs(arcangle) < 0.01  then
		    return
		  end if
		  
		  
		  dim i as integer
		  
		  if  dret = nil then
		    coord.CreateExtreAndCtrlPoints(ori)
		  end if
		  
		  nsk.update(self)
		  if (nsk= nil ) or ( nsk.item(0).x = 0 and nsk.item(0).y = 0)  or (points(0).bpt = nil) or  (not WorkWindow.drapshowall and hidden) then
		    return
		  end if
		  nsk.fixecouleurs(self)
		  nsk.fixeepaisseurs(self)
		  
		  for i = 0 to nsk.count-1
		    g.drawobject nsk.item(i), nsk.x, nsk.y
		  next
		  
		  
		  if not hidden then
		    for i = 0 to labs.count-1
		      Labs.item(i).paint(g)
		    next
		  end if
		  
		  
		  if (not hidden ) and  (Ti <> nil) and not  dret isa rettimer then
		    PaintTipOnArc(g, bordercolor)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PaintTipOnArc(g as graphics, col as couleur)
		  
		  dim b, e  as BasicPoint
		  dim Trib as TriBPoint
		  
		  Trib = new TriBPoint(self)
		  b = Trib.Subdiv(ori, 2,1)
		  e = b - getgravitycenter
		  e = e.vecnorperp
		  e = e*0.1*ori
		  PaintTip(b-e, b,  bordercolor, 0.5, g)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As shape
		  
		  return  new Arc(Obl,self,p)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PInShape(p as BasicPoint) As Boolean
		  'dim d1,d2 as double
		  '
		  'if inside(p) and   Points(0).bpt.Distance(p) <  Radius + can.MagneticDist  then
		  'd1 = p.distance(coord.tab(0),coord.tab(1))
		  'd2 = p.distance(coord.tab(0),coord.tab(2))
		  'return  min(d1,d2) > can.magneticdist
		  'end if
		  '
		  'return Inside(p)
		  
		  return (PointOnSide(p) = 0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As integer
		  
		  if inside(p) then
		    return super.pointonside(p)
		  end if
		  
		  return -1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Positionner(p as point)
		  dim n as integer
		  dim a as BasicPoint
		  dim alpha as double
		  
		  n = p.Pointsur.getposition(self)
		  a = p.bpt- points(0).bpt
		  if a.norme < epsilon then
		    return
		  end if
		  
		  alpha = computeangle(p.bpt)
		  p.numside(n) = 0
		  if Inside(p.bpt) then
		    p.Moveto p.bpt.projection(points(0).bpt, getradius)
		    p.location(n) = alpha/arcangle
		  else   'Cas qui peut se produire si p est un pointsur l'arc qu'on amène en une position qui n'est plus attirée par l'arc
		    if p.distanceto(points(1)) < p.distanceto(points(2)) then
		      p.moveto points(1).bpt
		    else
		      p.moveto points(2).bpt
		    end if
		  end if
		  
		  setpoint p
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StartP() As BasicPoint
		  return Points(1).bpt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos as TextOutputStream)
		  dim s as string
		  dim r as double
		  dim i as integer
		  
		  tos.writeline "newpath"
		  s= "[ [ "+points(1).etiquet + "  " + points(0).etiquet  + " " + points(2).etiquet + " ] "
		  r = points(0).bpt.distance(points(1).bpt)
		  
		  if ti <> nil then
		    s = s + "0.5 " + str(r) +"]"
		    if ori = 1 then
		      tos.writeline s + "arcoripos"
		    elseif ori = -1 then
		      tos.writeline s + "arcorineg"
		    end if
		  else
		    r = r*ori
		    s = s +  str(r) +"]"
		    if fill = 0 then
		      tos.writeline s+" arccerclesecteur"
		    elseif fill = 100 then
		      tos.writeline s + "arcsecteur secteurdisque"
		    end if
		  end if
		  
		  for i = 0 to ubound(childs)
		    childs(i).ToEPS(tos)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatecenter(p as point, np as basicpoint)
		  dim v, mid as BasicPoint
		  dim M as Matrix
		  
		  mid = (Points(2).bpt+Points(1).bpt)/2.
		  v = Points(1).bpt-Points(2).bpt
		  v=v.VecNorPerp
		  M = new OrthoProjectionMatrix(mid, mid+v)
		  v = M*np
		  p.moveto v
		  computearcangle
		  computeradius
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdatePtsConsted()
		  dim i as integer
		  dim p as point
		  dim TriB as TriBPoint
		  dim fp, sp as point
		  
		  
		  
		  for i = 0 to ubound(constructedshapes)
		    if constructedshapes(i).constructedby.oper = 4 then
		      p = point(constructedshapes(i))
		      fp = point(p.constructedby.data(0))
		      sp = point(p.constructedby.data(1))
		      Trib = new TriBpoint(getgravitycenter,fp.bpt,sp.bpt)
		      p.moveto Trib.subdiv(ori,p.constructedby.data(2),p.constructedby.data(3))
		      p.modified = true
		      p.updateshape
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateShape()
		  updatecoord
		  computearcangle
		  computeradius
		  super.updateshape
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  
		  dim Form, temp As XMLElement
		  dim Att as XMLAttribute
		  dim i as integer
		  
		  Form = Shape.XMLPutInContainer(Doc)
		  Form.SetAttribute("StartAngle", str(startangle))
		  Form.SetAttribute("EndAngle", str(endangle))
		  return form
		  
		End Function
	#tag EndMethod


	#tag Note, Name = Duplications et autres transfos
		
		Arcs: Attention aux copier/coller et aux images par transformation
		L'image du centre ne doit pas être déplacée de l'ampleur de la translation (si c'en est une) 
		VOIR dans Coller/DoOperation les lignes que l'on n'applique pas aux arcs.
		if not (s isa point) and not (s isa arc)  then
		p0 = p0 - s.Points(0).bpt
		elseif s isa point then
		p0 = p0-Point(s).bpt
		end if
		Même problème dans "AppliquerTsf à un arc (voir AppliquerTsf/CreerCopies)
		Essayer d'améliorer cette situation.
		
		
	#tag EndNote


	#tag Property, Flags = &h0
		endangle As double
	#tag EndProperty

	#tag Property, Flags = &h0
		startangle As double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="paraperp"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="angle"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="arcangle"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="area"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Attracting"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="auto"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Biface"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Borderwidth"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsw"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="deleted"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapori"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="endangle"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="fam"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fleche"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="forme"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Highlighted"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="id"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IDGroupe"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
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
			Name="IndexConstructedPoint"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Invalid"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsInConstruction"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="labupdated"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
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
			Name="Liberte"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Modified"
			Visible=false
			Group="Behavior"
			InitialValue="false"
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
			Name="narcs"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncpts"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="npts"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ori"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="plan"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Pointe"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Radius"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="selected"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="signaire"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="startangle"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="std"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
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
			Name="tobereconstructed"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
		#tag ViewProperty
			Name="TracePt"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="tsp"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="unmodifiable"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Validating"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
