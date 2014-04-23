#tag Class
Protected Class Arc
Inherits Circle
	#tag Method, Flags = &h0
		Sub Arc(ol as objectslist, p as basicPoint)
		  
		  Circle(ol,3,p)
		  npts = 3
		  liberte = 5
		  nsk = new ArcSkull(wnd.Mycanvas1.transform(p))
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.value("Arc")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as BasicPoint, n as integer)
		  dim i as Integer
		  
		  for i = n to 2
		    Points(i).moveto(p)
		  next
		  
		  select case n
		  case 0
		    arcangle = 0
		  case 1
		    computeradius
		    startangle = coord.startangle         'GetAngle(Points(0).bpt, Points(1).bpt)
		  case 2
		    constructshape
		    updateangles
		    CreateExtreAndCtrlPoints
		    updateskull
		  end select
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeArcAngle()
		  
		  if  abs(arcangle)  >  0.2 then
		    drapori = true  //on ne peut plus changer l'orientation
		  end if
		  if not drapori then
		    ori = coord.orientation                         'points(0).bpt.orientation(points(1).bpt,points(2).bpt)
		  end if
		  
		  arcangle = computeangle(points(2).bpt)
		  
		  'arcangle a toujours meme signe que l'orientation
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function computeangle(q as Basicpoint) As double
		  
		  return coord.computeangle(q,ori)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function aire() As double
		  return arcangle*Pow(getradius,2)/2
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Arc(Ol as ObjectsList, s as Arc, p as basicPoint)
		  dim i as integer
		  dim q as basicPoint
		  dim M as matrix
		  
		  Circle(ol,s,p)
		  arcangle = s.arcangle
		  endangle = s.endangle
		  startangle = s.startangle
		  CreateExtreAndCtrlPoints
		  nsk = new ArcSkull(wnd.mycanvas1.transform(Points(0).bpt))
		  radius = s.radius
		  drapori = s.drapori
		  liberte = 5
		  
		  
		  
		  
		End Sub
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
		    points(2).puton points(2).pointsur.element(0)
		  end if
		  return true
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Arc(ol as ObjectsList, Temp as XMLElement)
		  Shape(ol,Temp)
		  ncpts = 3
		  liberte = 5
		  drapori = true
		  updateangles
		  radius =  points(1).bpt.distance(points(0).bpt)
		  CreateExtreAndCtrlPoints
		  nsk = new Arcskull(wnd.Mycanvas1.transform(points(0).bpt))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EndP() As BasicPoint
		  return Points(2).bpt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Inside(p as BasicPoint) As Boolean
		  dim a as double
		  a = computeangle(p)
		  return abs(a) <= abs(arcangle)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier10fixe(p as point, p1 as point) As Matrix
		  // Routine qui modifie l'arc  dans le cas où tous les points sont libres. Si possible, on laisse fixe le point p
		  // Trois cas possibles selon le point modifié
		  
		  dim  p2 As  point
		  dim ep, np, ep1, np1, ep2, np2, u, v As Basicpoint
		  dim M as Matrix
		  dim ff as figure
		  dim i, n1, n2, n as integer
		  dim alpha as double
		  
		  n = getindexpoint(p)
		  n1 = getindexpoint(p1)
		  for i = 0 to 2
		    if i <> n and i <> n1 then
		      n2 = i
		    end if
		  next
		  p2 = Points(n2)
		  
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(p,ep,np)
		  ff.getoldnewpos(p1,ep1,np1)
		  ff.getoldnewpos(p2,ep2,np2)
		  
		  
		  
		  select case n
		  case 0 // p est le centre
		    select case n1
		    case 1
		      M = new rotationmatrix (np, arcangle)
		    case 2
		      alpha = amplitude(np1,np,np2)
		      M = new rotationmatrix (np, alpha)
		    end select
		    np2 = M*np1
		  case 1
		    select case n1
		    case 0
		      M = new rotationmatrix (np1, arcangle)
		      np2 = M*np
		    case 2
		      u = np-np1
		      u = u.vecnorperp
		      v = (np+np1)/2
		      np2 = np2.projection(v, v+u)
		    end select
		  case 2
		    select case n1
		    case 0
		      M = new rotationmatrix (np1, -arcangle)
		      np2 = M*np
		    case 1
		      u = np-np1
		      u = u.vecnorperp
		      v = (np+np1)/2
		      np2 = np2.projection(v, v+u)
		    end select
		  end select
		  return new Affinitymatrix(ep,ep1,ep2,np,np1,np2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier12fixe(p as point, p1 as point) As Matrix
		  // Routine qui modifie l'arc  dans le cas où le point p est le candidat point fixe, mais ce n'est pas obligatoire, p1 a déjà été modifié et  p2 s'adapte
		  // Six cas possibles
		  
		  dim  q0, q1, q2 As  point
		  dim eq0, nq0, eq1, nq1, eq2, nq2 As Basicpoint
		  dim M as Matrix
		  dim ff as figure
		  dim  n1, n as integer
		  
		  
		  n = getindexpoint(p)
		  n1 = getindexpoint(p1)
		  
		  q0 = points(0)
		  q1 = points(1)
		  q2 = points(2)
		  
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(q0,eq0,nq0)
		  ff.getoldnewpos(q1,eq1,nq1)
		  ff.getoldnewpos(q2,eq2,nq2)
		  
		  select case n1
		  case 0 ,1
		    M = new rotationmatrix (nq0, arcangle)
		    nq2 = M*nq1
		  case 2
		    nq2 = nq2.projection(nq0,getradius)
		    points(2).moveto nq2
		  end select
		  return new Affinitymatrix(eq0,eq1,eq2,nq0,nq1,nq2)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier1fixe(p as point, p1 as point) As Matrix
		  // Routine qui modifie l'arc  dans le cas où le point p est laissé fixe, p1 est le point qui a été modifié, (il peut encore l'être)   p2 doit s'adapter
		  
		  
		  dim  p2 As  point
		  dim M as Matrix
		  dim i, n1, n2, n as integer
		  
		  n = getindexpoint(p)
		  n1 = getindexpoint(p1)
		  for i = 0 to 2
		    if i <> n and i <> n1 then
		      n2 = i
		    end if
		  next
		  p2 = Points(n2)
		  
		  
		  select case p.liberte
		  case 0,1
		    return Modifier10fixe(p,p1)  //p  restera fixe, p1 sera modifié, p2 s'adapte
		  case 2
		    return Modifier12fixe(p,p1)  // p est libre, p1 sera modifié, p et p2 s'adaptent éventuellement
		  end select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2fixes(p1 as point, p2 as point) As Matrix
		  // Routine qui modifie l'arc  dans le cas où le point p est seul à pouvoir être déplacé (pas arbitrairement)
		  // Trois cas possibles selon l'index de p
		  
		  dim k, i, n, n1, n2 as integer
		  dim ep, np, ep1, np1, ep2, np2, u, v as BasicPoint
		  dim ff as figure
		  dim Bib, Bib2 As  BiBPoint
		  dim sh1, sh2 As shape
		  dim p As point
		  
		  
		  
		  n1 = getindexpoint(p1)
		  if p1.pointsur.count = 1 then
		    sh1 = p1.pointsur.element(0)
		  end if
		  n2 = getindexpoint(p2)
		  if p2.pointsur.count = 1 then
		    sh2 = p2.pointsur.element(0)
		  end if
		  
		  for i = 0 to 2
		    if i <> n1 and i <> n2 then
		      n = i
		    end if
		  next
		  
		  p = points(n)
		  
		  ff = getsousfigure(fig)
		  
		  ff.getoldnewpos(p,ep,np)
		  ff.getoldnewpos(p1,ep1,np1)
		  ff.getoldnewpos(p2,ep2,np2)
		  
		  select case n
		  case 0
		    u = np1-np2
		    u = u.VecNorPerp
		    v = (np1+np2)/2
		    if p.pointsur.count = 0 then
		      np = np.projection(v,v+u)
		    else
		      Bib = new BiBPoint(v, u+v)
		      np = Bib.computefirstintersect(0,p.pointsur.element(0),p)
		    end if
		  case 1
		    if p.pointsur.count = 0 then
		      np = np.projection(points(0).bpt, np2.distance(np1))
		    else
		      u = points(2).bpt
		      Bib = new BiBPoint(points(0).bpt, u)
		      np = Bib.computefirstintersect(1,p.pointsur.element(0),p)
		    end if
		  case 2
		    if p.pointsur.count = 0 then
		      np = np.projection(points(0).bpt,np1.distance(np2))
		    else
		      u = points(1).bpt
		      Bib = new BiBPoint(points(0).bpt,u)
		      np = Bib.computefirstintersect(1,p.pointsur.element(0),p)
		    end if
		  end select
		  
		  if p.modified then
		    p.moveto ep
		  end if
		  return new AffinityMatrix(ep,ep1,ep2,np,np1,np2)
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier3() As Matrix
		  
		  dim  p0, p1, p2 As  point
		  dim ep0, np0, ep1, np1, ep2, np2, u, v As Basicpoint
		  dim ff as figure
		  dim i, n1, n2, n as integer
		  dim M as Matrix
		  dim Bib as bibpoint
		  dim sh as shape
		  dim t as boolean
		  
		  p0 = Points(0)
		  p1 =Points(1)
		  p2 = points(2)
		  
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(p0,ep0,np0)
		  ff.getoldnewpos(p1,ep1,np1)
		  ff.getoldnewpos(p2,ep2,np2)
		  
		  
		  if constructedby <> nil and (constructedby.oper = 6 or constructedby.oper = 3)  then
		    return new  affinitymatrix(ep0,ep1,ep2,np0,np1,np2)
		  end if
		  
		  if p2.pointsur.count = 1 then
		    't = ff.replacerpoint(p2)
		    sh = p2.pointsur.element(0)
		    Bib = new BiBPoint(np0, np1)
		    np2 = Bib.computefirstintersect(1,sh,p2)
		  elseif  p2 = ff.supfig.pointmobile then
		    np2 = np2.projection(np0, getradius)
		  end if
		  
		  if p2.modified then
		    p2.moveto np2
		  end if
		  
		  
		  if np2 <> nil then
		    if abs(amplitude(ep1,ep0,ep2) - PI) < epsilon or abs(amplitude(np1,np0,np2) - PI) < epsilon then
		      M = new similaritymatrix(ep1,ep2,np1,np2)  // cas des demi-cercles
		    else
		      M = new  affinitymatrix(ep0,ep1,ep2,np0,np1,np2)  // ne convient pas pour les demi-cercles
		    end if
		    return M
		  else
		    return nil
		  end if
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modify2(p1 as point, p2 as point) As Matrix
		  dim k, i, n, n1, n2 as integer
		  dim ep, np, ep1, np1, ep2, np2, u, v as BasicPoint
		  dim ff as figure
		  dim Bib, Bib2 As  BiBPoint
		  dim sh1, sh2 As shape
		  dim p As point
		  
		  n1 = getindexpoint(p1)
		  if p1.pointsur.count = 1 then
		    sh1 = p1.pointsur.element(0)
		  end if
		  n2 = getindexpoint(p2)
		  if p2.pointsur.count = 1 then
		    sh2 = p2.pointsur.element(0)
		  end if
		  
		  for i = 0 to 2
		    if i <> n1 and i <> n2 then
		      n = i
		    end if
		  next
		  p = points(n)                                 //p est le point non modifié
		  
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(p,ep,np)
		  ff.getoldnewpos(p1,ep1,np1)
		  ff.getoldnewpos(p2,ep2,np2)
		  
		  select case n
		  case 0
		    return Modify20(p1,p2)
		  case 1
		    if p.pointsur.count = 0 then
		      np = np.projection(points(0).bpt, np2.distance(np1))
		    else
		      u = points(2).bpt
		      Bib = new BiBPoint(points(0).bpt, u)
		      np = Bib.computefirstintersect(1,p.pointsur.element(0),p)
		    end if
		  case 2
		    if p.pointsur.count = 0 then
		      np = np.projection(points(0).bpt,np1.distance(np2))
		    else
		      u = points(1).bpt
		      Bib = new BiBPoint(points(0).bpt,u)
		      np = Bib.computefirstintersect(1,p.pointsur.element(0),p)
		    end if
		  end select
		  
		  if p.modified then
		    p.moveto ep
		  end if
		  return new AffinityMatrix(ep,ep1,ep2,np,np1,np2)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modify20(p1 as point, p2 as point) As Matrix
		  // Le point non modifié est le point 0.
		  // Il peut être sur ou non
		  // S'il est sur, on essaye de le modifier.
		  //Sinon, on essaye de remodifier un des deux autres points
		  
		  dim ep, np, ep1, np1, ep2, np2, u, v as BasicPoint
		  dim ff as figure
		  dim Bib As  BiBPoint
		  dim p As point
		  
		  p = points(0)
		  
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(p,ep,np)
		  ff.getoldnewpos(p1,ep1,np1)
		  ff.getoldnewpos(p2,ep2,np2)
		  
		  if p.pointsur.count = 1 then
		    u = np1-np2
		    u = u.VecNorPerp
		    v = (np1+np2)/2
		    Bib = new BiBPoint(v, u+v)
		    np = Bib.computefirstintersect(0,p.pointsur.element(0),p)
		    if np <> nil then
		      p.moveto np
		      p.modified = true
		      return new AffinityMatrix(ep1, ep2, ep, np1, np2, np)
		    else
		      return new matrix(1)
		    end if
		  else
		    if p1.pointsur.count = 0 and p2.pointsur.count = 0 then
		      return new SimilarityMatrix(ep1,ep2,np1,np2)
		    elseif p1.pointsur.count = 0 then
		      Bib = new bibpoint(p.bpt, np2)
		      p2.moveto Bib.ReporterLongueur(p.bpt,np1)
		      p2.modified = true
		      return new AffinityMatrix(ep1, ep2, ep, np1, np2, np)
		    else
		      Bib = new BibPoint(p.bpt,np1)
		      p1.moveto Bib.ReporterLongueur(p.bpt,np2)
		      p1.modified = true
		      return new AffinityMatrix(ep1, ep2, ep, np1, np2, np)
		      
		    end if
		  end if
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As shape
		  dim s as shape
		  dim j as integer
		  dim a, b as point
		  
		  return  new Arc(Obl,self,p)
		  
		  'for j = 3 to Ubound(childs)
		  'a = childs(j)
		  'b = Point(a.Paste(Obl,p,s))
		  'next
		  'return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PInShape(p as BasicPoint) As Boolean
		  if  Points(0).bpt.Distance(p) >  Radius + wnd.Mycanvas1.MagneticDist  then
		    return False
		  end if
		  
		  return Inside(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As integer
		  dim n as integer
		  
		  if inside(p) then
		    return  super.pointonside(p)
		  end if
		  
		  return -1
		  
		End Function
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
		  s= "[ [ "+points(1).etiq + "  " + points(0).etiq  + " " + points(2).etiq + " ] "
		  r = points(0).bpt.distance(points(1).bpt)*ori
		  s = s + str(r) + " ] "
		  if fill = 0 then
		    tos.writeline s+" arccerclesecteur"
		  elseif fill = 100 then
		    tos.writeline s + "arcsecteur secteurdisque"
		  end if
		  
		  for i = 0 to 2
		    points(i).ToEPS(tos)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updateangles()
		  dim q as basicpoint
		  
		  startangle = coord.startangle    'GetAngle(Points(0).bpt, Points(1).bpt)
		  endangle = coord.endangle     'GetAngle(Points(0).bpt, Points(2).bpt)
		  computearcangle
		  
		  // startangle et endangle  sont toujours entre 0 et 2 pi
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatecenter(p as point, np as basicpoint)
		  dim v, mid as BasicPoint
		  dim M as Matrix
		  
		  mid = (Points(2).bpt+Points(1).bpt)/2
		  v = Points(1).bpt-Points(2).bpt
		  v=v.VecNorPerp
		  M = new OrthoProjectionMatrix(mid, mid+v)
		  v = M*np
		  p.moveto v
		  updateangles
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
		  updateangles
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

	#tag Method, Flags = &h0
		Sub UpDateSkull()
		  dim i, j as integer
		  dim p As BasicPoint
		  
		  p = points(0).bpt
		  
		  nsk.update(wnd.Mycanvas1.transform(p))
		  for i = 1 to 2
		    nsk.updatesommet(i,wnd.Mycanvas1.dtransform(points(i).bpt-p))
		  next
		  for i = 0 to 1
		    nsk.updateextre(i,  wnd.mycanvas1.dtransform(extre(i)-p))
		  next
		  for i = 0 to 5
		    nsk.updatectrl(i, wnd.mycanvas1.dtransform(ctrl(i)-p))
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitConstruction()
		  super.initconstruction
		  CreateExtreAndCtrlPoints
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as Graphics)
		  if abs(arcangle) < 0.01 and not self isa DSect then
		    return
		  end if
		  
		  super.paint(g)
		  
		  if (not hidden ) and  (Ti <> nil) and (dret = nil) then
		    PaintTipOnArc(g, bordercolor)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateExtreAndCtrlPoints()
		  dim Bib as BiBPoint
		  dim alpha as double
		  dim M as RotationMatrix
		  dim i as integer
		  
		  alpha = arcangle/3
		  M = new RotationMatrix(Points(0).bpt,alpha)
		  extre(0) = M*StartP
		  extre(1) = M*extre(0)
		  BiB = new BiBPoint(StartP,extre(0))
		  Bib.computeCtrlPoints(Points(0).bpt, ori,  ctrl)
		  for i = 2 to 5
		    ctrl(i) = M*ctrl(i-2)
		  next
		  
		  
		End Sub
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
		Sub computeori()
		  updatecoord
		  if not drapori then
		    ori = coord.orientation
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
		Sub ConstructShape()
		  super.ConstructShape
		  computeradius
		  updateangles
		  CreateExtreAndCtrlPoints
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createskull(p as BasicPoint)
		  computeradius
		  updateangles
		  CreateExtreAndCtrlPoints
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndConstruction()
		  super.endconstruction
		  
		  'if currentcontent.currentoperation isa macroexe then
		  'computeradius
		  'updateangles
		  'CreateExtreAndCtrlPoints
		  'end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		startangle As double
	#tag EndProperty

	#tag Property, Flags = &h0
		endangle As double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="NotPossibleCut"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="arcangle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Circle"
		#tag EndViewProperty
		#tag ViewProperty
			Name="angle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Circle"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Radius"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Circle"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapori"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="signaire"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="plan"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="deleted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tobereconstructed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="diam"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="id"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="selected"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Highlighted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="npts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Borderwidth"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="std"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ori"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fam"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="forme"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Modified"
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IDGroupe"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tsp"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Liberte"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Attracting"
			Group="Behavior"
			InitialValue="True"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Invalid"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncpts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="unmodifiable"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="auto"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TracePt"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsInConstruction"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IndexConstructedPoint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="labupdated"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsw"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nonpointed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="startangle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="endangle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
