#tag Class
Protected Class Arc
Inherits Circle
	#tag Method, Flags = &h0
		Sub Arc(ol as objectslist, p as basicPoint)
		  
		  Circle(ol,3,p)
		  npts = 3
		  liberte = 5
		  createskull(p)
		  
		  
		  
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
		  createskull(p)
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
		  createskull(points(0).bpt)
		  
		  
		  
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
		Function Paste(Obl as Objectslist, p as Basicpoint) As shape
		  dim s as shape
		  dim j as integer
		  dim a, b as point
		  
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
		  updatecoord
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
		  
		  nsk = new ArcSkull(p)
		  if ubound(points)> 0 then
		    computeradius
		    updateangles
		    CreateExtreAndCtrlPoints
		  end if
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
		  'Le point n° n est le seul point modifié. Il y a 1 point "sur" différent n° n. Ce point n'a pas été modifié, plus précisément il a éte "replacé".
		  'La méthode succède à Modifier2.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier12(n as integer) As Matrix
		  'Le point n° n est le seul point modifié. Il y a deux points "sur" différent n° n. Ces points ont éte "replacés".
		  'La méthode succède à Modifier3.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2(n1 as integer, n2 as integer) As Matrix
		  dim n0 as integer
		  dim r as double
		  
		  epnp
		  n0 = TroisiemeIndex(n1,n2)  'Le point n° n0 n'a pas été modifié.
		  
		  select case n0
		  case 0   'On rétablit la figure en déplaçant le centre de l'arc points(0)
		    if points(0).forme  <> 1 then
		      return new SimilarityMatrix(ep1,ep2,np1,np2)
		    else 'si points(0) est un point sur, ce cas relève de Modifier3
		    end if
		  case 1 'On modifie l'amplitude de l'arc
		    if points(1).forme <> 1 then
		      r = getradius
		      points(2).moveto np2.projection(np0,r)
		      return new AffinityMatrix(ep0,ep1,ep2,np0,np1,points(2).bpt)
		    else 'même remarque que ci-dessus
		    end if
		  case 2  'On rétablit la figure en déplaçant l'extrémité  de l'arc points(2)
		    if points(2).forme <> 1 then
		      return new SimilarityMatrix(ep0,ep1,np0,np1)
		    else 'même remarque que ci-dessus
		    end if
		  end select
		  
		  return new Matrix(1)
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
		    Bib = new BiBPoint(np0, np2)
		    np1 = Bib.computefirstintersect(1,sh,p)
		    points(1).moveto np1
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
		    return new AffinityMatrix(ep0,ep1,ep2,np0,np1,np2)
		  else
		    return new Matrix(1)
		  end if
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier30() As Matrix
		  //Trois sommets modifiés, aucun n'est un point "sur"
		  
		  if abs(np0.distance(np1) - np0.distance(np2)) < epsilon then
		    if abs(amplitude(ep1,ep0,ep2) - PI) < epsilon or abs(amplitude(np1,np0,np2) - PI) < epsilon then
		      return new similaritymatrix(ep1,ep2,np1,np2)  // cas des demi-cercles
		    else
		      return  new  affinitymatrix(ep0,ep1,ep2,np0,np1,np2)  // ne convient pas pour les demi-cercles à cause des points alignés
		    end if
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
		  case 0                  'on conserve points(1) et on adapte points(2)
		    Bib = new BiBPoint(np0,np1)
		    if n = 1 then   'alors m = 2
		      np2  = Bib.computefirstintersect(1,shm,points(2))
		    else                  'n = 2, m = 1
		      np2  = Bib.computefirstintersect(1,shn,points(2))
		    end if
		    points(2).moveto np2
		  case 1
		    Bib = new BiBPoint(np0,np1)
		    if n = 0 then   'alors m = 2
		      np2  = Bib.computefirstintersect(1,shm,points(2))
		    else                  'n = 2, m = 0
		      np2  = Bib.computefirstintersect(1,shn,points(2))
		    end if
		    points(2).moveto np2
		  case 2
		    Bib = new BiBPoint(np0,np2)
		    if n = 1 then   'alors m = 0
		      np1  = Bib.computefirstintersect(1,shn,points(1))
		    else                  'n = 0, m = 1
		      np1  = Bib.computefirstintersect(1,shm,points(1))
		    end if
		    points(1).moveto np1
		  end select
		  
		  if k = 2 then
		    p = points(1)
		  else
		    p = points(2)
		  end if
		  if p.bpt  <> nil then
		    p.valider
		    return new AffinityMatrix(ep0,ep1,ep2,np0,np1,np2)
		  else
		    p.invalider
		    return new Matrix(1)
		  end if
		  
		  
		  
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
		Function Modifier33() As Matrix
		  dim M as Matrix
		  
		  M = new SimilarityMatrix(points(1), points(2),ep0,np0)
		  if M <> nil and M.v1 <> nil then
		    np1 = M*ep1
		    points(1).moveto np1
		    np2 = M*ep2
		    points(2).moveto np2
		    
		    if np1 <> nil and np2 <> nil then
		      return new AffinityMatrix(ep0,ep1,ep2,np0,np1,np2)
		    else
		      return new Matrix(1)
		    end if
		  else
		    return new Matrix(1)
		  end if
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		startangle As double
	#tag EndProperty

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
		np0 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		np1 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		np2 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ff As Figure
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
