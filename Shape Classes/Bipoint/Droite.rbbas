#tag Class
Protected Class Droite
Inherits Bipoint
	#tag Method, Flags = &h0
		Sub Droite(ol As ObjectsList, p as BasicPoint, n as integer)
		  'Utilise pour la construction à la souris
		  
		  Shape(ol,2,2)
		  nextre = n
		  if n = 2 then
		    T = new Tip
		  end if
		  Points.append new Point(ol, p)
		  SetPoint(Points(0))
		  createskull(p)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  select case nextre
		  case 0
		    return Dico.Value("Droite")
		  case 1
		    return Dico.Value("DemiDroite")
		  case 2
		    return Dico.value("Segment")
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As shape
		  
		  dim s as droite
		  dim j as integer
		  
		  s = new Droite(Obl,self, p)
		  s.computeextre
		  s.updateskull
		  
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape()
		  
		  if  constructedby <> nil and constructedby.oper < 3  then
		    provis = constructbasis
		    Points(1).moveto firstp +provis*10
		    computeextre
		    if  nextre = 0 then
		      points(1).hide
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Droite(ol as objectslist, fp as point, sp as BasicPoint, n as integer)
		  dim i as integer
		  dim secP as Point
		  
		  Shape(ol,0,2)
		  
		  secP = new Point(ol)
		  secP.MoveTo sp
		  secP.EndConstruction
		  
		  points.append fp
		  points.append secP
		  
		  for i = 0 to 1
		    setpoint(points(i))
		  next
		  nextre = n
		  fam = 1
		  select case n
		  case 0
		    forme = 3
		  case 1
		    forme = 6
		  case 2
		    forme = 0
		  end select
		  createskull(fp.bpt)
		  computeextre
		  EndConstruction
		  Updateskull
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsSame(s As Shape) As Boolean
		  
		  if s isa Circle then
		    return false
		  elseif s isa Droite then
		    return (extre1 = Droite(s).extre1 and extre2 = Droite(s).extre2)
		  elseif s isa Polygon then
		    return false
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Droite(ol as ObjectsList, k as integer, EL as XMLElement)
		  Shape(ol,EL)
		  
		  select case k
		  case 0 to 2
		    nextre = 2
		  case 3 to 5
		    nextre = 0
		  case 6
		    nextre = 1
		  end select
		  'if k <> 0 and k <> 3 and k <> 6 then
		  'auto = 6
		  'liberte = 3
		  'end if
		  createskull(firstp)
		  computeextre
		  Updateskull
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as Basicpoint, n as integer)
		  dim i as integer
		  
		  
		  if n = 0 then
		    if constructedby = nil  then
		      for i = 0 to 1
		        Points(i).moveto(p)
		      next
		    else
		      Points(0).moveto(p)
		      constructshape
		    end if
		    sk.update(wnd.mycanvas1.transform(p))
		    if nextre = 0 and constructedby <> nil then
		      updateskull
		    end if
		  elseif n =1 then
		    if constructedby = nil then
		      Points(1).moveto(p)
		    else
		      Points(1).moveto p.projection(firstp,firstp+provis)
		    end if
		    computeextre
		    Updateskull
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Droite(ol as objectslist, fp as point, sp as point, n as integer)
		  //Constructeur utilisé uniquement par prolonger
		  dim i as integer
		  
		  Shape(ol,0,2)
		  points.append fp
		  points.append sp
		  
		  for i = 0 to 1
		    setpoint(points(i))
		  next
		  nextre = n
		  fam = 1
		  select case n
		  case 0
		    forme = 3
		  case 1
		    forme = 6
		  case 2
		    forme = 0
		  end select
		  createskull(fp.bpt)
		  computeextre
		  Updateskull
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpDateSkull()
		  dim pt As BasicPoint
		  
		  ComputeExtre
		  sk.update(wnd.myCanvas1.transform(Extre1))
		  pt = wnd.myCanvas1.dtransform(Extre2-Extre1)
		  segskull(sk).updatesommet(1,pt)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(p as basicpoint) As Boolean
		  dim r , delta as double
		  dim t as boolean
		  
		  delta = wnd.Mycanvas1.MagneticDist
		  t = p.Distance(FirstP,SecondP) < delta
		  
		  select case nextre
		  case 0
		    return  t
		  case 1
		    return ( t and p.audela(firstp,secondp) ) or (p.distance(firstp) < delta)
		  case 2
		    return  (t and p.between(FirstP,SecondP))  or (p.distance(firstp) < delta)   or (p.distance(secondp) < delta)
		  end select
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Droite(p1 as Point, p2 as Point)
		  'segment servant lors du calcul des intersections (cas des polygones)
		  
		  Points.append p1
		  Points.append p2
		  nextre = 2
		  'coord = new BiBpoint(firstp, secondp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEps(tos as TextOutputstream)
		  dim i as integer
		  dim s as string
		  
		  if ti = nil or nextre < 2  then
		    s =  "[ "+Points(0).etiq+" "+ Points(1).etiq + " ] "
		  else
		    s =  "[ "+Points(0).etiq+" "+ str(0.5) + " " + Points(1).etiq + " ] "
		  end if
		  tos.write(s)
		  
		  
		  select case nextre
		  case 0
		    tos.writeline ("  droite")
		  case 1
		    tos.writeline ("  demidroite")
		  case 2
		    if ti = nil then
		      tos.writeline (" segment")
		    else
		      tos.writeline( " fleche")
		    end if
		  end select
		  
		  for i = 0 to 1
		    points(i).toeps(tos)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as Graphics)
		  dim a,b,e as BasicPoint
		  dim can as mycanvas
		  
		  ComputeExtre
		  UpDateSkull
		  super.Paint(g)
		  
		  if Ti <> nil and not hidden  then
		    can = wnd.mycanvas1
		    e = (secondp-firstp)*0.1
		    a = can.transform(getgravitycenter-e)
		    b = can.transform(getgravitycenter+e)
		    Ti.updatetip(a,b,bordercolor)
		    Ti.scale = 0.5
		    g.DrawObject Ti, b.x, b.y
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function parallele(d as droite) As boolean
		  
		  if (constructedby <> nil and constructedby.oper = 1 and constructedby.shape = d) or (d.constructedby <> nil and d.constructedby.oper = 1 and d.constructedby.shape = self) then
		    return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createtsf()
		  dim tsf as transformation
		  
		  tsf = new Transformation
		  constructedby.data.append tsf
		  
		  tsf.constructedshapes.addshape self
		  tsf.supp = constructedby.shape
		  tsf.supp.tsfi.append tsf
		  tsf.index = constructedby.data(0)
		  'fig.SetConstructedBy(constructedby.shape.fig, tsf)
		  'tsf.constructedfigs.addfigure fig
		  CurrentContent.TheTransfos.addtsf tsf
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Droite(D as Droite, M as Matrix)
		  Shape(D, M)
		  nextre = D.nextre
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as basicpoint) As integer
		  dim delta as double
		  
		  
		  delta = wnd.Mycanvas1.MagneticDist
		  
		  if p.distance(firstp, secondp) < delta then
		    return 0
		  else
		    return -1
		  end if
		  
		  '//Ne vaudrait-il pas mieux if pinshape(p) then
		  'return 0
		  'else
		  'return 1
		  'end if  ?
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub modifiertsf(s1 as shape, s2 as shape, ind as integer)
		  //Une droite paraperp à s1 devient paraperp à s2
		  
		  dim tsf as transformation
		  dim op as integer
		  
		  tsf = Transformation(constructedby.data(1))
		  op = constructedby.oper
		  
		  s1.fig.constructedfigs.removefigure fig
		  s1.removeconstructedshape self
		  tsf.removefigconstructioninfos(self)
		  setconstructedby(s2, op)
		  fig.removeconstructedby(s1.fig,tsf)
		  constructedby.data.append  ind
		  constructedby.data.append tsf
		  fig.SetConstructedBy(s2.fig, tsf)
		  tsf.supp = s2
		  tsf.updatefigconstructioninfos(self)
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function prppupdate1() As Matrix
		  
		  dim sf as figure
		  dim  p, q as Point
		  dim n as integer
		  dim  w, ep, np, eq, nq, u as Basicpoint
		  dim d as double
		  
		  sf = getsousfigure(fig)
		  p = points(0)
		  q = points(1)
		  sf.getoldnewpos(p,ep,np)
		  sf.getoldnewpos(q,eq,nq)
		  'n = getindexpoint(Point(sf.somm.element(sf.ListPtsModifs(0))))
		  
		  u = eq - ep
		  d = u.norme
		  w = constructbasis
		  if u*w < 0 then
		    w = w*(-1)
		  end if
		  
		  if p.modified then
		    nq = np+w*d
		  else
		    if q.pointsur.count = 0 then
		      nq = nq.projection(np, np+w)
		      q.moveto nq
		    else
		      return prpupdate11(q,ep,eq,np,nq)
		    end if
		  end if
		  return new SimilarityMatrix(ep,eq,np,nq)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function prppupdate0() As Matrix
		  dim u, w,ep,  np as BasicPoint
		  dim d as double
		  dim ff as figure
		  
		  ff = getsousfigure(fig)
		  u = Points(1).bpt - Points(0).bpt
		  d = u.norme
		  w = constructbasis
		  
		  if u*w < 0 then
		    w = w*(-1)
		  end if
		  
		  ff.getoldnewpos(Points(1),ep,np)
		  np = firstp +w*d
		  return new Similaritymatrix(points(0).bpt, ep, points(0).bpt, np)
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OtherPoint(p as point) As point
		  dim n as integer
		  
		  n = getindexpoint(p)
		  
		  if n <> -1 then
		    return points(1-n)
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Inter(D as droite, byref p as basicpoint, byref r1 as double, Byref r2 as double) As integer
		  dim B1, B2  as Bibpoint
		  
		  //Intersection de deux "droites". Couvre le cas des segments et des demi-droites
		  
		  B1 = new BiBpoint(firstp, secondp)
		  B2 = new Bibpoint(D.firstp, D.secondp)
		  
		  p = B1.BibInterDroites(B2,nextre,D.nextre,r1,r2)
		  
		  if p <> nil then
		    return 1
		  else
		    p =  B1.BiBInterDroites(B2, 0,0,r1,r2)  // r = 999: parallelisme , 1000: alignement
		    return 0
		  end if
		  // si un point d'inter: return  1 et P <> nil;  sinon return 0  et p = nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Inter(s as circle, byref p() as Basicpoint, byref bq as BasicPoint, Byref w as BasicPoint) As integer
		  dim B1, B2 as BiBpoint
		  dim i, n as integer
		  dim b, v, intersec() as BasicPoint
		  
		  B1 = new Bibpoint(firstp, secondp)
		  B2 = new Bibpoint(s.points(0).bpt, s.points(1).bpt)
		  
		  n = B1.BiBDroiteInterCercle(B2,p(), bq, w)
		  return n
		  
		  
		  'if s isa arc then
		  'for i = 0 to 1
		  't(i) = t(i) and arc(s).Inside(intersec(i))
		  'next
		  'end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function constructbasis() As basicpoint
		  dim dr as droite
		  dim w as Basicpoint
		  
		  dr = constructedby.shape.getside(constructedby.data(0))
		  w0 = dr.secondp-dr.firstp
		  w=w0.normer
		  if constructedby.oper = 2 Then
		    w=w.VecNorPerp
		  end if
		  return w
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function prppupdate2() As Matrix
		  dim sf as figure
		  dim  p, q as Point
		  dim  ep, np, eq, nq as Basicpoint
		  dim t as Boolean
		  dim n as integer
		  
		  sf = getsousfigure(fig)
		  p = points(0)
		  q = points(1)
		  sf.getoldnewpos(p,ep,np)
		  sf.getoldnewpos(q,eq,nq)
		  
		  n = sf.NbSommSur
		  
		  select case n
		  case 0
		    return new Matrix(1)
		  case 1
		    n = sf.ListSommSur(0)
		    t = sf.replacerpoint(points(n))
		    if n = 0 then
		      return prpupdate11(p,eq,ep,nq,np)
		    else
		      return prpupdate11(q,ep,eq,np,nq)
		    end if
		  case 2
		    if check then
		      return new SimilarityMatrix(ep,eq,np,nq)
		    else
		      t = sf.replacerpoint(q)
		      sf.getoldnewpos(p,ep,np)
		      sf.getoldnewpos(q,eq,nq)
		      return prpupdate11(q,ep,eq,np,nq)
		    end if
		  end select
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Droite(Obj as Objectslist, dr as droite, q as Basicpoint)
		  dim i, j as integer
		  dim M as Matrix
		  
		  Shape(obj,dr)
		  if dr.isaparaperp then
		    auto = 1
		    if dr.forme = 1 or dr.forme = 2 then
		      forme  = 0
		    elseif dr.forme = 4 or dr.forme = 5 then
		      forme = 3
		    end if
		  end if
		  nextre = dr.nextre
		  M = new TranslationMatrix(q)
		  createskull(dr.firstp)
		  Move(M)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub positionner(q as point, eq as BasicPoint)
		  dim u,  w, ep,  nq as Basicpoint
		  
		  
		  ep = Points(0).bpt
		  u = eq-ep
		  
		  w = constructbasis
		  if u*w < 0 then
		    w = w*(-1)
		  end if
		  
		  nq = q.bpt.projection(ep, ep+w)
		  q.moveto nq
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Droite(ol as objectslist, s as polygon, n as integer)
		  'utilisé pour dupliquer un cote de polygone
		  
		  Shape(ol,2,2)
		  nextre = 2
		  Points.append new Point(ol, s.points(n).bpt)
		  SetPoint(Points(0))
		  Points.append new point(ol, s.points((n+1) mod s.npts).bpt)
		  setpoint(Points(1))
		  createskull(points(0).bpt)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSide(n as integer) As droite
		  return self
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeExtre()
		  dim D1 as BiBpoint
		  dim mi, ma as double
		  
		  
		  
		  if firstp.distance(secondp) < wnd.mycanvas1.magneticdist  then
		    extre1= firstp
		    extre2= secondp
		  else
		    D1 = new BiBPoint(firstp, secondp)
		    D1.Interscreen(mi,ma)
		    
		    select case nextre
		    case 0
		      extre1 = D1.BptSurBiBpt(mi)
		      extre2 = D1.BptSurBiBpt(ma)
		    case 1
		      extre1 = firstp
		      extre2 = D1.BptSurBiBpt(ma)
		    case 2
		      extre1= firstp
		      extre2 = secondp
		    end select
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function longueur() As double
		  return firstp.distance(secondp)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function parallelto(sh as shape, n as integer) As boolean
		  dim d as droite
		  dim u, v as BasicPoint
		  
		  if constructedby<> nil and constructedby.oper = 1 and constructedby.shape = sh then
		    if sh isa droite then
		      return true
		    elseif sh isa polygon or sh isa bande or sh isa secteur then
		      return  constructedby.data(0) = n
		    end if
		  else
		    d = sh.getside(n)
		    u = vecteurdirecteur.normer
		    v = d.vecteurdirecteur.normer
		    if u = nil or v = nil then
		      return true
		    else
		      return abs(u.vect(v) ) < epsilon
		    end if
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub oldDroite(ol as objectslist, coord as nBPoint, n As integer)
		  Droite(ol,coord.tab(0),n)
		  Points.append new Point(ol,coord.tab(1))
		  setpoint Points(1)
		  nextre = n
		  ComputeExtre
		  updateskull
		  endconstruction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function prpupdate11(q as point, ep as basicpoint, eq as basicPoint, np as basicPoint, nq as basicPoint) As Matrix
		  dim dr1, dr2 as droite
		  dim Bib1, Bib2 as BiBPoint
		  dim w as basicpoint
		  dim M as Matrix
		  dim sh as shape
		  dim n as integer
		  dim r1, r2 as double
		  
		  sh = q.pointsur.element(0)
		  w = constructbasis
		  
		  if not sh isa circle then
		    dr2 = sh.getside(q.numside(0))
		    Bib2 = new BiBPoint(dr2.firstp, dr2.secondp)
		    dr1 = constructedby.shape.getside(constructedby.data(0))
		    Bib1 = new BibPoint(dr1.firstp, dr1.firstp+w)
		    M = new  AffiProjectionMatrix(Bib1, Bib2)
		    if M <> nil and M.v1 <> nil then
		      nq = M*np
		    else
		      nq = nil
		    end if
		  else
		    if w.norme > epsilon then
		      Bib1 = new BibPoint(firstp, firstp+w)
		      nq  = Bib1.ComputeFirstIntersect(0,sh,q)
		    end if
		  end if
		  if q.modified and nq <> nil then
		    q.moveto nq
		  end if
		  if nq <> nil then
		    return new similaritymatrix (ep, eq, np, nq)
		  else
		    return nil
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isaprolongement(byref s as polygon, byref n as integer) As Boolean
		  dim i, m1, m2 as integer
		  
		  
		  for i = 0 to ubound(points(0).parents)
		    if  points(0).parents(i) isa polygon then
		      s = polygon(Points(0).parents(i))
		      n = s.getindexpoint(points(0))
		      if n <> -1 and s isa polygon then
		        m1 = s.getindexpoint(points(1))
		        if (m1 <> -1) and ( (m1 = (n+1) mod s.npts) or (n = (m1+1) mod s.npts)) then
		          m2 = min(n, m1)
		          if m2 > 0 then
		            n = m2
		            return true
		          else
		            if n = 1 then
		              n = 0
		              return true
		            else
		              n = s.npts-1
		              return  true
		            end if
		          end if
		        end if
		      end if
		    end if
		  next
		  
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createskull(p as basicPoint)
		  sk = new SegSkull(wnd.mycanvas1.transform(p))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Droite(ol as objectslist, n as integer)
		  Shape(ol, 2,2)
		  nextre = n
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Vecteurdirecteur() As BasicPoint
		  return secondp - firstp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function check() As Boolean
		  dim v, w as BasicPoint
		  
		  if not self.isaparaperp then
		    return true
		  end if
		  
		  v = vecteurdirecteur
		  v = v.normer
		  w = constructbasis
		  return abs(v.vect(w)) < epsilon
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
		Extre1 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		Extre2 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		nextre As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		provis As basicpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		w0 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		T As Tip
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
			Name="deleted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="final"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="init"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="interm"
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
			Name="drapori"
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
			Name="colsw"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="IndexConstructedPoint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="TracePt"
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
			Name="unmodifiable"
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
			Name="Invalid"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="Liberte"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="Side"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Bipoint"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nextre"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
