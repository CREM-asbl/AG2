#tag Class
Protected Class Arc
Inherits Circle
	#tag Method, Flags = &h0
		Function AffiOrSimili() As Matrix
		  if  (ep2.alignes(ep1,ep0)) or (np2.alignes(np0,np1)) then
		    if abs(amplitude(ep1,ep0,ep2) - PI) < epsilon or abs(amplitude(np1,np0,np2) - PI) < epsilon then
		      return new similaritymatrix(ep1,ep2,np1,np2)  // cas des demi-cercles
		    elseif abs(amplitude(ep1,ep0,ep2)) < 0.2*epsilon or abs(amplitude(np1,np0,np2)) < 0.2*epsilon or abs(amplitude(ep1,ep0,ep2) -2*PI) <0.2* epsilon or abs(amplitude(np1,np0,np2) - 2*PI) < 0.2*epsilon then
		      np2 = np1
		      ep2 = ep1
		      points(2).moveto np2
		      points(2).modified = true
		      computearcangle
		      return new similaritymatrix(ep1,ep0,np1,np0)  // cas des secteurs nuls
		    end if
		  else
		    return  new  affinitymatrix(ep0,ep1,ep2,np0,np1,np2)  // ne convient pas pour les demi-cercles à cause des points alignés
		  end if
		End Function
	#tag EndMethod

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
		  dim r as double
		  dim bq, v as BasicPoint
		  dim dr as droite
		  dim p as point
		  redim q(1)
		  
		  p = points(2)  ' ce point est "sur" s
		  if p.forme <> 1 then
		    return nil
		  end if
		  k = p.numside(0)
		  BiB0 =  new BiBPoint(np0,np1)
		  if S isa Droite or S isa Polygon or S isa Bande or S isa Secteur  then
		    Bib =S.getBiBside(k)
		    select case BiB.nextre
		    case 0
		      n = Bib.BiBDroiteInterCercle(BiB0,q(), bq, v)
		    case 1
		      n = Bib.BiBDemiDroiteInterCercle(Bib0,q(), bq, v)
		    case 2
		      n = Bib.BiBSegmentInterCercle(Bib0,q(), bq, v)
		    end select
		    n = ubound(q)+1
		  end if
		  
		  if S isa Circle then
		    Bib = new BiBpoint(S.Points(0).bpt,  S.Points(1).bpt)
		    n = BiB0.BiBInterCercles(Bib,q(),bq,v)
		    if n = 0 then
		      q.append p.bpt
		    end if
		  end if
		  
		  for i = 1 downto 0
		    if q(i) = nil then
		      q.remove i
		    end if
		  next
		  n = ubound(q)+1
		  
		  if n=2 then
		    if points(1) = fig.pointmobile then
		      if   (amplitude(points(1).bpt, points(0).bpt, q(0)) >  amplitude(points(1).bpt, points(0).bpt, q(1)))    then
		        q(0) = q(1)
		      end if
		    else
		      if ep2.distance(q(0)) > ep2.distance(q(1)) then
		        q(0)=q(1)
		      end if
		    end if
		  end if
		  if n>0 and ubound(q) > -1 then
		    return q(0)
		  else
		    return nil
		  end if
		  
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
		    points(2).puton points(2).pointsur.element(0)
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
		  startangle = coord.startangle    'GetAngle(Points(0).bpt, Points(1).bpt)
		  endangle = coord.endangle     'GetAngle(Points(0).bpt, Points(2).bpt)
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
		  shape.Constructor(ol,s)
		  ncpts = 2
		  arcangle = s.arcangle
		  endangle = s.endangle
		  startangle = s.startangle
		  IndexConstructedPoint = 2   '(clutch)
		  drapori = s.drapori
		  ori =s.ori
		  createskull(p)
		  nsk.updatesize(1)
		  liberte = 5
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, p as basicPoint)
		  
		  Super.Constructor(ol,3,p)
		  npts = 3
		  liberte = 5
		  createskull(p)
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, Temp as XMLElement)
		  Shape.Constructor(ol,Temp)
		  IndexConstructedPoint = 2  '(clutch)
		  ncpts = 3
		  liberte = 5
		  drapori = true
		  createskull(points(0).bpt)
		  nsk.updatesize(1)
		  updateskull
		  
		  
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
		  if ubound(points)> 0 then
		    computeradius
		    computearcangle
		    coord.CreateExtreAndCtrlPoints(ori)
		  end if
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
		Sub epnp()
		  
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(points(0),ep0,np0)
		  ff.getoldnewpos(points(1),ep1,np1)
		  ff.getoldnewpos(points(2),ep2,np2)
		End Sub
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
		    updatecoord
		    coord.CreateExtreAndCtrlPoints(ori)
		    updateskull
		  end select
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.value("Arc")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitConstruction()
		  super.initconstruction
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Inside(p as BasicPoint) As Boolean
		  dim a as double
		  a = computeangle(p)
		  return abs(a) <= abs(arcangle)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier1(n as integer) As Matrix
		  dim  m as integer
		  
		  epnp
		  
		  m = ff.NbSommsur(n)
		  
		  
		  select case m
		  case 0
		    return Modifier10(n)
		  case 1
		    return Modifier11(n)
		  case 2
		    return Modifier12(n)
		  end select
		  
		  //Les deux derniers cas ne peuvent normalement pas se présenter (il y aurait plus d'un point modifié)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier10(n as integer) As Matrix
		  'Le point n° n est le seul point modifié. Il y a 0 points "sur"
		  dim  r as double
		  
		  select case n
		  case 0, 1
		    return new SimilarityMatrix(ep0,ep1,np0,np1)
		  case 2
		    r = getradius
		    points(2).moveto np2.projection(np0,r)
		    return new AffinityMatrix(ep0,ep1,ep2,np0,np1,points(2).bpt)
		  end select
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier11(n as integer) As Matrix
		  dim s as shape
		  dim bp as BasicPoint
		  
		  if points(2).forme <> 1 then
		    return new Matrix(1)
		  end if
		  
		  s = points(2).pointsur.element(0)
		  bp =ArcComputeFirstIntersect(s)
		  
		  
		  return new AffinityMatrix(ep0,ep1,ep2,np0,np1,bp)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier12(n as integer) As Matrix
		  dim s as shape
		  dim bp as BasicPoint
		  
		  if points(2).forme <> 1 then
		    return new Matrix(1)
		  end if
		  
		  s = points(2).pointsur.element(0)
		  bp =ArcComputeFirstIntersect(s)
		  
		  
		  return new AffinityMatrix(ep0,ep1,ep2,np0,np1,bp)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2(n1 as integer, n2 as integer) As Matrix
		  dim n0 as integer
		  dim r as double
		  dim M as Matrix
		  
		  epnp
		  n0 = TroisiemeIndex(n1,n2)  'Le point n° n0 n'a pas été modifié.
		  
		  select case n0
		  case 0   'On rétablit la figure en déplaçant le centre de l'arc points(0)
		    if points(0).forme  <> 1 then
		      return new SimilarityMatrix(ep1,ep2,np1,np2)
		    end if
		  case 1 'On modifie l'amplitude de l'arc
		    if points(1).forme <> 1 then
		      r = getradius
		      points(2).moveto np2.projection(np0,r)
		      return new AffinityMatrix(ep0,ep1,ep2,np0,np1,points(2).bpt)
		    end if
		  case 2  'On rétablit la figure en déplaçant l'extrémité  de l'arc points(2)
		    if points(2).forme <> 1 then
		      M = new RotationMatrix(Points(0).bpt, arcangle)
		      points(2).moveto M*Points(1).bpt
		      return AffiOrSimili
		      'return new SimilarityMatrix(ep0,ep1,np0,np1)
		    end if
		  end select
		  
		  return new Matrix(1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier3() As Matrix
		  dim n as integer
		  
		  epnp
		  n = ff.NbSommSur
		  
		  select case n
		  case 0
		    return Modifier30
		  case 1
		    return Modifier31(ff.listsommsur(0))
		  case 2
		    return modifier32(ff.listsommsur(0),ff.listsommsur(1))
		  case 3
		    return modifier33
		  end select
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier30() As Matrix
		  //Trois sommets modifiés, aucun n'est un point "sur"
		  
		  if fig.pointmobile = points(2) then
		    constructshape
		    'points(2).modified = false
		  end if
		  epnp
		  
		  if abs(np0.distance(np1) - np0.distance(np2)) < epsilon then
		    return AffiOrSimili
		  else
		    return new Matrix(1)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier31(n as integer) As Matrix
		  // Trois sommets modifiés Un seul est un point "sur". C'est le sommet de n° n.
		  dim k, i,  n1, n2 as integer
		  dim ep, np, u, v as BasicPoint
		  
		  dim Bib, Bib2 As  BiBPoint
		  dim sh As shape
		  dim p As point
		  
		  p = points(n)
		  sh = p.pointsur.element(0)
		  
		  select case n
		  case 0
		    u = np1-np2
		    u = u.VecNorPerp
		    v = (np1+np2)/2
		    Bib = new BiBPoint(v, u+v)
		    np0 = Bib.computefirstintersect(0,sh,p)
		    points(0).moveto np0
		  case 1
		    if ff.supfig.pointmobile = points(2) then
		      np2 = np2.projection(np0,np0.distance(np1))
		      points(2).moveto np2
		    else
		      Bib = new BiBPoint(np0, np2)
		      np1 = Bib.computefirstintersect(1,sh,p)
		      points(1).moveto np1
		    end if
		  case 2
		    Bib = new BiBPoint(np0,np1)
		    np2 = Bib.computefirstintersect(1,sh,p)
		    if np2 <> nil and abs (np0.distance(np2) - np0.distance(np1)) < epsilon then
		      points(2).moveto np2
		      points(2).valider
		    else
		      points(2).invalider
		    end if
		  end select
		  
		  
		  
		  if not points(n).invalid  then
		    return AffiOrSimili 'new AffinityMatrix(ep0,ep1,ep2,np0,np1,np2)
		  else
		    return new Matrix(1)
		  end if
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier32(n as integer, m as integer) As Matrix
		  // Trois sommets modifiés Deux sont "sur". Ce sont les sommets de n° n0 et n1.
		  dim k as integer
		  dim p, p0, p1, p2 as point
		  dim shn, shm as shape
		  dim Bib as BiBPoint
		  
		  
		  shn = points(n).pointsur.element(0)
		  shm = points(m).pointsur.element(0)
		  k = TroisiemeIndex(n,m)  'Ce troisième sommet n'est pas "sur"
		  
		  select case k
		  case 0, 1                 'on adapte points(2)
		    if n = 1-k  then   'alors m = 2
		      np2  =Arccomputefirstintersect(shm)
		    else                  'n = 2, m = 1
		      np2  = Arccomputefirstintersect(shn)
		    end if
		    if np2 <> nil then
		      points(2).bpt  = np2
		    end if
		    
		  case 2
		    Bib = new BiBPoint(np0,np2)
		    if n = 1 then   'alors m = 0
		      np1  = Bib.computefirstintersect(1,shn,points(1))
		    else                  'n = 0, m = 1
		      np1  = Bib.computefirstintersect(1,shm,points(1))
		    end if
		    if np1 <> nil then
		      points(1).bpt = np1
		    end if
		  end select
		  
		  if k = 2 then
		    p = points(1)
		  else
		    p = points(2)
		  end if
		  if np1 <> nil and np2 <> nil then
		    p.valider
		    return  AffiOrSimili  'new AffinityMatrix(ep0,ep1,ep2,np0,np1,np2)
		  else
		    p.invalider
		    return new Matrix(1)
		  end if
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier33() As Matrix
		  dim M as Matrix
		  
		  M = new SimilarityMatrix(points(1), points(2),ep0,np0)
		  if M <> nil and M.v1 <> nil then
		    np1 = M*ep1
		    points(1).moveto np1
		    np2 = M*ep2
		    points(2).moveto np2
		    
		    if np1 <> nil and np2 <> nil then
		      return  AffiOrSimili 'new AffinityMatrix(ep0,ep1,ep2,np0,np1,np2)
		    else
		      return new Matrix(1)
		    end if
		  else
		    return new Matrix(1)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as Graphics)
		  if abs(arcangle) < 0.01  then
		    return
		  end if
		  
		  super.paint(g)
		  
		  if (not hidden ) and  (Ti <> nil) and (dret = nil) then
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
		  if  Points(0).bpt.Distance(p) >  Radius + wnd.Mycanvas1.MagneticDist  then
		    return False
		  end if
		  
		  return Inside(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As integer
		  
		  if inside(p) then
		    return  super.pointonside(p)
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
		  
		  for i = 0 to 2
		    points(i).ToEPS(tos)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function TroisiemeIndex(n1 as integer, n2 as integer) As integer
		  dim i, n as integer
		  
		  for i = 0 to 2
		    if i <> n1 and i <> n2 then
		      n = i
		    end if
		  next
		  return n
		End Function
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
		Sub UpDateSkull()
		  dim i, j as integer
		  dim p As BasicPoint
		  
		  p = points(0).bpt
		  nsk.update(wnd.Mycanvas1.transform(p))
		  if IndexConstructedPoint > 0 then
		    for i = 1 to 2
		      nsk.updatesommet(i,wnd.Mycanvas1.dtransform(points(i).bpt-p))
		    next
		    for i = 0 to 1
		      nsk.updateextre(i,  wnd.mycanvas1.dtransform(coord.extre(i)-p))
		    next
		    for i = 0 to 5
		      nsk.updatectrl(i, wnd.mycanvas1.dtransform(coord.ctrl(i)-p))
		    next
		  end if
		  
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


	#tag Property, Flags = &h0
		endangle As double
	#tag EndProperty

	#tag Property, Flags = &h0
		ep0 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ep1 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ep2 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ff As Figure
	#tag EndProperty

	#tag Property, Flags = &h0
		np0 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		np1 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		np2 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		startangle As double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="angle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="arcangle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Attracting"
			Group="Behavior"
			InitialValue="True"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="auto"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Borderwidth"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsw"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="deleted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapori"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="endangle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fam"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="forme"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Highlighted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="id"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IDGroupe"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IndexConstructedPoint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Invalid"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsInConstruction"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="labupdated"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Liberte"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Modified"
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncpts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nonpointed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotPossibleCut"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="npts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ori"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="plan"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Radius"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="selected"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="signaire"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="startangle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="std"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tobereconstructed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TracePt"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tsp"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="unmodifiable"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Validating"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass