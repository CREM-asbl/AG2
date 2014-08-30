#tag Class
Protected Class Polygon
Inherits Shape
	#tag Method, Flags = &h0
		Function pInShape(p as BasicPoint) As Boolean
		  dim i,j, n as Integer
		  dim q, r as BasicPoint
		  dim c as Boolean
		  
		  if npts = 2 then
		    return p.between(points(0).bpt, points(1).bpt) and p.distance(points(0).bpt, points(1).bpt)  < wnd.mycanvas1.magneticdist
		  else
		    return coord.pInShape(p)
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Polygon(ol as objectslist, d as integer, p as basicpoint)
		  shape(ol,d)
		  Points.append new Point(ol, p)
		  setPoint(Points(0))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateSkull(n as integer, p as Basicpoint)
		  
		  figskull(sk).updatesommet(n,p)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsSide(P1 As Point, P2 As Point) As Boolean
		  
		  dim i, ind1, ind2 As integer
		  
		  
		  for i=0 to npts-1
		    ind1 = getindexpoint(P1)
		    ind2 = getindexpoint(P2)
		    if ind1<>-1 and ind2<>-1 then
		      if abs(ind1-ind2) = 1 or abs(ind1-ind2) = npts-1 then
		        return true
		      else
		        return false
		      end if
		    end if
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As integer
		  dim i, imin as integer
		  dim distmin, dist, delta as double
		  
		  delta = wnd.Mycanvas1.MagneticDist
		  
		  distmin = 1000
		  imin = -1
		  for i=0  to npts-1
		    dist = p.distance(Points(i).bpt,Points((i+1) mod npts).bpt)
		    if dist <= distmin then
		      if dist <  delta and  p.between(Points(i).bpt,Points((i+1) mod npts).bpt) then
		        distmin = dist
		        imin = i
		      end if
		    end if
		  next
		  return imin
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Polygon(ol as objectslist, s as polygon, q as BasicPoint)
		  dim i, j as integer
		  dim M as Matrix
		  
		  Shape(ol,s)
		  redim prol(s.npts-1)
		  Ori=s.Ori
		  liberte = s.liberte
		  M = new TranslationMatrix(q)
		  createskull(s.Points(0).bpt)
		  Move(M)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPointPosition(P as Point) As double
		  dim m as integer
		  dim num as double
		  
		  if P.Pointsur <> nil then
		    m = P.PointSur.GetPosition(self)
		    if m <> -1 then
		      num = P.location(m)+P.numside(m)
		    end if
		  else
		    num=GetIndexPoint(P)
		  end if
		  return num
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextPoint(p as Point) As Point
		  if GetIndexPoint(p) < npts-1 then
		    return Points(GetIndexPoint(p)+1)
		  else
		    return Points(0)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PrecPoint(P as Point) As Point
		  if GetIndexPoint(p) > 0 then
		    return Points(GetIndexPoint(p) - 1)
		  else
		    return Points(npts-1)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSide(i as integer) As Droite
		  dim d as Droite
		  
		  d = new Droite(Points(i),Points((i+1) mod npts))
		  d.nextre = 2
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Polygon(ol as ObjectsList, Temp as XMLElement)
		  Shape(ol,Temp)
		  redim prol(npts-1)
		  redim curved(npts-1)
		  createskull(Points(0).bpt)
		  Updateskull
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos as textoutputstream)
		  dim s as string
		  dim j as integer
		  dim col as color
		  dim seps as SaveEPS
		  
		  seps = SaveEps(CurrentContent.currentoperation)
		  
		  
		  if not hidden then
		    s = "[ "
		    if Ti = nil then
		      for j = 0 to npts-1
		        s = s+ " " + Points(j).etiq+ " "
		      next
		    else
		      for j = 0 to npts-1
		        s = s+ " " + Points(j).etiq+ " " + str(0.5) + " "
		      next
		    end if
		    s = s+"]"
		    
		    if fill > 49 and not tsp then
		      if Ti = nil then
		        tos.writeline s+" polygonerempli"
		      else
		        tos.writeline s + " polygoneorienterempli"
		      end if
		    end if
		    
		    if diffcolcotes then
		      for j = 0 to npts-1
		        seps.adapterparamborder(self, tos, j)
		        if ti = nil then
		          tos.writeline("[ "+Points(j).etiq+" "+ Points((j+1) mod npts).etiq + " ]  segment ")
		        else
		          tos.writeline("[ "+Points(j).etiq+" "+ str(0.5) + " " + Points((j+1) mod npts).etiq + " ]  fleche ")
		        end if
		      next
		    elseif not (fill> 49) then
		      seps.adapterparamborder(self, tos)
		      if ti = nil then
		        tos.writeline s+ " polygone"
		      else
		        tos.writeline s+ " polygoneoriente"
		      end if
		    end if
		    
		    if not nonpointed then
		      for j = 0 to ubound(childs)
		        childs(j).ToEps(tos)
		      next
		    end if
		    
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Polygon(ol as objectslist, fp as point, sp as point, qp as point, tp as point)
		  shape(ol)
		  fam = 3
		  forme = 0
		  npts = 1
		  
		  SubstitutePoint( fp, points(0))
		  
		  Points.append sp
		  setpoint(sp)
		  npts = 2
		  
		  Points.append qp
		  setpoint(qp)
		  npts = npts+1
		  
		  
		  'if fp<> tp and sp <> tp  then
		  Points.Append tp
		  setpoint(tp)
		  npts = npts+1
		  'end if
		  
		  initcolcotes
		  redim  prol(npts-1)
		  
		  endconstruction
		  createskull(Points(0).bpt)
		  updateskull
		  ol.optimize
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(ol as objectslist, p as BasicPoint, s as shape) As shape
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(ol as objectslist, p as basicPoint) As shape
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeOri()
		  dim r as double
		  
		  r = aire
		  
		  if r >= 0 then
		    ori = 1
		  else
		    ori = -1
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Polygon(P as Polygon, M as Matrix)
		  Shape(P, M)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  select case  Npts
		  case 2
		    return Dico.value("Bigon")
		  case 3
		    return Dico.Value("Triang")
		  case 4
		    return Dico.Value("Quadri")
		  case 5
		    Return Dico.value("Penta")
		  case 6
		    return Dico.Value("Hexa")
		  case 7
		    return Dico.Value("Hepta")
		  case 8
		    Return Dico.value("Octo")
		  case 9
		    return Dico.Value("Ennea")
		  case 10
		    return Dico.Value("Deca")
		  case 11
		    Return Dico.value("Undeca")
		  case 12
		    return Dico.Value("Dodeca")
		  else
		    return Dico.Value("GrandPol")
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Aire() As double
		  dim a as double
		  a =  coord.aire
		  if std then
		    a = abs(a)
		  end if
		  return a
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitColcotes()
		  dim i as integer
		  
		  
		  redim colcotes(npts-1)
		  
		  for i = 0 to npts-1
		    colcotes(i) = Config.bordercolor
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics)
		  dim i as integer
		  dim can as mycanvas
		  dim a, b, e, m as basicPoint
		  
		  super.paint(g)
		  
		  if not hidden and Ti <> nil then
		    for i = 0 to npts-1
		      PaintTipOnSide g, i
		    next
		    if constructedby <> nil and constructedby.oper = 9 and constructedby.data(4) = 1 then
		      a = Points(0).bpt
		      b = Points(1).bpt
		      e = b-a
		      e = e*0.05
		      a = a-e
		      b = b-e
		      PaintTipOnSide g, 0
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paintside(g as graphics, cot as integer, ep as double, coul as couleur)
		  dim cs as curveshape
		  
		  cs = figskull(sk).getcote(cot)
		  if cs <> nil then
		    cs.borderwidth = ep*borderwidth
		    cs.bordercolor = coul.col
		    g.drawobject(cs, sk.ref.x, sk.ref.y)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextBorderPoint(P as Point, p2 as point) As Point
		  dim k, k2 as Double
		  
		  k2 = parametre(p2)
		  k = parametre(p)
		  
		  if floor(k) = floor(k2) and k <= k2 then
		    return p2
		  else
		    if k < ceil(k) then
		      k = ceil(k) mod npts
		    else
		      k = (k+1) mod npts
		    end if                                    'k est le numéro du sommet qui suit immédiatement p
		    return points(k)
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function diffcolcotes() As Boolean
		  dim c0, c as couleur
		  dim i as integer
		  
		  c0 = colcotes(0)
		  
		  for i = 1 to npts-1
		    if not c0.equal(colcotes(i)) then
		      return true
		    end if
		  next
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub dejaexporte()
		  dim i as integer
		  
		  for i = 0 to npts-1
		    points(i).dejaexporte = true
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function parametre(p as point) As double
		  dim k as integer
		  dim r as double
		  
		  r = -1
		  k = getindexpoint(p)
		  if k <> -1 then
		    r = k
		  else
		    k = pointonside(p.bpt)
		    if k <> -1 then
		      r =  k + p.bpt.location(points(k).bpt, points((k+1) mod npts).bpt)
		    end if
		  end if
		  return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function paste(ob as objectslist, p as basicpoint, icot as integer) As droite
		  
		  dim d as droite
		  
		  d = new droite(ob, self, icot)
		  d.ComputeExtre
		  d.updateskull
		  
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pointonline(p as basicpoint) As integer
		  dim i, imin as integer
		  dim distmin, dist, delta as double
		  
		  delta = wnd.Mycanvas1.MagneticDist
		  
		  distmin = p.distance(Points(0).bpt,Points(1).bpt)
		  imin = -1
		  for i=0  to npts-1
		    dist = p.distance(Points(i).bpt,Points((i+1) mod npts).bpt)
		    if dist <= distmin then
		      distmin = dist
		      imin = i
		    end if
		  next
		  return imin
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ModifierTriIso1fixe(p() as point, nf as integer, nt as integer) As Matrix
		  dim ep0, np0, ep1, np1, ep2, np2, u, v As Basicpoint
		  dim M as Matrix
		  dim ff as figure
		  dim Bib1 as BiBPoint
		  dim s as shape
		  dim k, i1, j1 as integer
		  dim d as droite
		  dim inter as intersec
		  dim r as double
		  dim q1, q2 as point
		  
		  // p(0) et p(1) sont deux points opposés, p(2) leur est adjacent
		  // nt est le numéro du point sur lequel on tire, nf le numéro du pt fixe
		  
		  
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(p(0),ep0,np0)
		  ff.getoldnewpos(p(1),ep1,np1)
		  ff.getoldnewpos(p(2),ep2,np2)
		  
		  select case nt
		  case 0, 1
		    select case nf
		    case 1-nt
		      u = (np0+np1)/2
		      v = np0-np1
		      v = v.vecnorperp
		      if p(2).pointsur.count = 0 then
		        M = new OrthoProjectionMatrix(u,u+v)
		        np2 = M*np2
		      else
		        s = p(2).pointsur.element(0)
		        q1 = new point(u)
		        q2 = new point (u+v)
		        d = new droite(q1,q2)
		        d.nextre = 0
		        inter = currentcontent.TheIntersecs.Find(d,s)
		        if inter = nil then
		          inter = new intersec(d,s)
		        end if
		        r = inter.nearest(p(2),i1,j1)
		        if inter.val(i1,j1) then
		          np2 = inter.bptinters(i1,j1)
		          p(2).numside(0) = j1
		        end if
		      end if
		    case 2
		      u = ep1-ep0
		      u = u.vecnorperp
		      M = new SymmetryMatrix(np2, np2+u)
		      if nt =0 then
		        np1 = M*np0
		      else
		        np0 = M*np1
		      end if
		    end select
		  case 2
		    u = (ep0+ep1)/2
		    v = ep1-ep0
		    v = v.vecnorperp
		    M = new SymmetryMatrix(np2,np2+v)
		    u = p(nf).bpt
		    v = M*u
		    if not p(1-nf).unmodifiable then
		      p(1-nf).modified = false
		    end if
		    if nf = 0 then
		      np1 = v
		    else
		      np0 = v
		    end if
		  end select
		  
		  return new Affinitymatrix(ep0,ep1,ep2,np0,np1,np2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ModifierTriIso2fixes(p() as point, id as integer) As Matrix
		  // Routine qui modifie le triangle  dans le cas où le point n est seul à pouvoir être déplacé (pas arbitrairement)
		  // Trois cas possibles selon que le point modifiable est entre les deux fixes ou avant ou après.
		  //(Pour le triangle, le point modifiable est LE sommet ou un point de base)
		  // p(0) sera le point modifiable, p(1) et p(2) les deux fixes
		  // id vaudra 0, 1 ou 2 :  0 si c'est le sommet (entre les deux fixes) 1 si les deux fixes le suivent, 2 s'ils le précèdent
		  
		  dim k, n, n1, n2 as integer
		  dim p1, p2 as point
		  dim ep0, np0, np1, np2, u() as BasicPoint
		  dim ff as figure
		  dim Bib1, Bib2 As  BiBPoint
		  dim bq, w as basicpoint
		  
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(p(0),ep0,np0)
		  np1 = p(1).bpt
		  np2 = p(2).bpt
		  
		  select case id
		  case 0 //p(0) est le sommet
		    u.append (np1+np2)/2
		    u.append np1-np2
		    u(1) = u(1).vecnorperp
		    np0 = np0.projection(u(0), u(0)+u(1))
		  case 1, 2
		    if id = 1 then //p(1) est le sommet
		      Bib1 = new BiBPoint(np1,np0)
		      Bib2 = new BibPoint(np1,np2)
		    else   //p(2) est le sommet
		      Bib1 = new BiBPoint(np2,np0)
		      Bib2 = new BibPoint(np2,np1)
		    end if
		    k = Bib1.BibDroiteIntercercle(Bib2,u(),bq,w)
		    if k <> 0 then
		      if np0.distance(u(1)) < np0.distance(u(0)) then
		        np0 = u(1)
		      else
		        np0 = u(0)
		      end if
		    end if
		  end select
		  
		  p(0).moveto np0
		  
		  return new AffinityMatrix(ep0,np1,np2,np0,np1,np2)
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createskull(p as BasicPoint)
		  sk = new Figskull(wnd.mycanvas1.transform(p),npts)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PossibleFusionWith(S as Polygon, byref i0 as integer, byref j0 as integer, byref dir as integer) As boolean
		  dim i, j,k,l as integer
		  dim delta as double
		  dim dr1, dr2 as BiBPoint
		  
		  delta = wnd.Mycanvas1.MagneticDist
		  
		  for i = 0  to npts-1
		    if curved(i) = 0  then
		      dr1 = getBiBside(i)
		      for j = 0 to S.npts-1
		        if s.curved(j) = 0 then
		          dr2 = s.getBiBside(j)
		          if dr1.sufficientlynear(dr2) then
		            i0 = i
		            j0 = j
		            dir = 1                          //les deux côtés ont même direction
		            return true
		          end if
		          if dr1.sufficientlynear(dr2.returned) then
		            i0 = i
		            j0 = j
		            dir = -1                      //les deux côtés sont opposés
		            return true
		          end if
		        end if
		      next
		    end if
		  next
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitConstruction()
		  Super.InitConstruction
		  
		  initcolcotes
		  redim curved(npts-1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PaintTipOnSide(g as graphics, i as integer)
		  
		  dim Bib as BiBPoint
		  dim Trib as TribPoint
		  dim m, a, b, e as BasicPoint
		  
		  a = coord.tab(i)
		  b = coord.tab((i+1)mod npts)
		  
		  Bib = new BibPoint(a,b)
		  m = BiB.Subdiv(2,1)
		  e = (b-a)*0.1
		  a = m-e
		  b = m+e
		  PaintTip(a, b, bordercolor, 0.5, g)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function check() As Boolean
		  
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
		prol() As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		curved(-1) As Integer
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
	#tag EndViewBehavior
End Class
#tag EndClass
