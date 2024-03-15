#tag Class
Protected Class Polygon
Inherits Lacet
	#tag CompatibilityFlags = ( TargetDesktop and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Function airealge() As double
		  
		  return coord.airealgepolygon
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function airearith() As double
		  
		  return coord.airearithpolygon
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function check() As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function completesides() As point()
		  dim i, j, k  as integer  'n'intervient que dans Decomposer
		  dim p as point
		  dim arpoints(-1) As Point
		  dim arside(-1) As  Point
		  dim loc(-1) As double
		  
		  if autointer = nil then
		    return nil
		  end if
		  
		  for i = 0 to npts-1
		    arpoints. append points(i)
		    redim arside(-1)
		    redim loc(-1)
		    for j = 0 to ubound(autointer.pts)
		      p = autointer.pts(j)
		      if p.numside(0)= i  then
		        arside.append p
		        loc.Append p.location(0)
		      end if
		      if  p.numside(1) = i then
		        arside.append p
		        loc.Append p.location(1)
		      end if
		    next
		    loc.sortwith(arside)
		    for k = 0 to ubound(arside)
		      arpoints.append arside(k)
		    next
		  next
		  
		  
		  return arpoints
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeOri()
		  dim r as double
		  
		  r = coord.airealgepolygon
		  
		  if r > 0 then
		    ori = 1
		  else
		    ori = -1
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as Objectslist, p as BasicPoint)
		  
		  Shape.constructor(ol)
		  Points(0).MoveTo(p)
		  npts = 1
		  ncpts = 1
		  fam = 6
		  createskull(can.transform(p))
		  Lskull(nsk).addpoint(new BasicPoint(0,0))
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, d as integer, p as basicpoint)
		  shape.constructor(ol,d,d)
		  Points.append new Point(ol, p)
		  setPoint(Points(0))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub constructor(ol as objectslist, nb as nbpoint)
		  dim i as integer
		  dim p as BasicPoint
		  
		  constructor(ol, nb.tab(0))
		  
		  for i = 1 to nb.taille-1
		    p = nb.tab(i)
		    Points.append new Point(ol,p)
		    setpoint points(i)
		  next
		  
		  npts = nb.taille
		  createcoord
		  redim prol(npts-1)
		  initcolcotes
		  createskull(points(0).bpt)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub constructor(ol as objectslist, fp as point, sp as point, qp as point, tp as point)
		  shape.constructor(ol)
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
		  
		  Points.Append tp
		  setpoint(tp)
		  npts = npts+1
		  
		  initcolcotes
		  redim  prol(npts-1)
		  
		  endconstruction
		  createskull(Points(0).bpt)
		  ol.optimize
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, s as polygon, q as BasicPoint)
		  dim M as Matrix
		  
		  Shape.constructor(ol,s)
		  redim prol(s.npts-1)
		  liberte = s.liberte
		  M = new TranslationMatrix(q)
		  createskull(s.Points(0).bpt)
		  Move(M)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, Temp as XMLElement)
		  Shape.constructor(ol,Temp)
		  if Points.Count = 0 then return
		  redim prol(-1)
		  redim prol(Points.count-1)
		  redim coord.curved(-1)
		  redim coord.curved(Points.count-1)
		  createskull(Points(0).bpt)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createcomponents(ars() as point)
		  dim i, i0, j,  n, k, nmax as integer
		  dim pini as point
		  dim comp as polygon
		  dim compos() as polygon
		  dim p as point
		  dim pile() as point
		  
		  
		  nmax  = ubound(ars)+1
		  pile.append ars(0)
		  n = nmax
		  while n >0
		    pini = pile(ubound(pile))
		    i = ars.indexof(pini)
		    pile.remove ubound(pile)
		    comp = new Polygon(objects,pini.bpt)  'insertion du point balise
		    n = n-1
		    i = (i+1) mod nmax
		    while  ars(i).id <> pini.id
		      p = ars(i)
		      comp.addpoint(p.bpt)   'insertion du point i
		      n = n-1
		      if getindexpoint(p) = -1 then 'on a affaire Ã  un point d'intersection
		        k = pile.indexof(p)
		        if k <> -1 then
		          pile.remove k
		        else
		          pile.append p
		        end if
		        for j = 0 to ubound(ars)        'on en recherche la deuxième occurrence
		          if j <> i and ars(j).id = p.id then
		            i0 = j
		          end if
		        next
		        i = (i0+1) mod nmax
		      else
		        i = (i+1) mod nmax
		      end if
		    wend
		    comp.initcolcotes
		    comp.endconstruction
		    compos.append comp
		  wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateSpecs() As StdPolygonSpecifications
		  
		  Dim specs As New StdPolygonSpecifications
		  dim alpha, beta as double
		  dim j as integer
		  dim BiB as BiBPoint
		  
		  alpha = 0
		  for j = 0 to npts-2
		    Bib = GetBiBside(j)
		    specs.Distances.append BiB.longueur
		    beta = BiB.anglepolaire*180/PI
		    specs.Angles.append beta-alpha
		    alpha = beta
		  next
		  specs.coul = fillcolor
		  return specs
		  
		  
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
		Function Fusionner(Fus2 as Lacet, start1 as integer, start2 as integer, dir as integer) As Polygon
		  dim Fus as Polyqcq
		  dim i, j as integer
		  dim dr1, dr2 as BiBPoint
		  dim segments1(), segments2() As BiBPoint
		  dim pts() As BasicPoint
		  
		  for i = 0 to npts-1
		    segments1.Add(getBiBside(i))
		  next
		  
		  for i = 0 to Fus2.npts-1
		    segments2.Add(Fus2.getBiBside(i))
		  next
		  
		  
		  for i = segments1.LastIndex downto 0
		    dr1 = segments1(i)
		    for j = segments2.LastIndex downto 0
		      dr2 = segments2(j)
		      if dr1.sufficientlynear(dr2) then
		        segments1.RemoveAt(i)
		        segments2.RemoveAt(j)
		      elseif dr1.sufficientlynear(dr2.returned) then
		        segments1.RemoveAt(i)
		        segments2.RemoveAt(j)                    
		      end if
		    next
		  next
		  
		  for i = 0 to segments2.LastIndex
		    segments1.Add segments2(i)
		  next 
		  
		  pts.add(segments1(0).First)
		  pts.add(segments1(0).Second)
		  segments1.RemoveAt(0)
		  i = 0 
		  
		  do
		    dim pt as BasicPoint
		    pt = pts(pts.LastIndex)
		    if Segments1(i).First.isSameAs(pt) then
		      pts.add(segments1(i).second)
		      segments1.RemoveAt(i)
		      i = 0
		    elseif Segments1(i).Second.isSameAs(pt) then
		      pts.add(segments1(i).First)
		      segments1.RemoveAt(i)
		      i = 0 
		    else
		      i = i + 1
		    end if
		  loop until segments1.count = 1 or i = segments1.count
		  
		  Fus = new Polyqcq(Objects, pts(0))
		  Fus.npts = 1
		  
		  for i = 1 to pts.LastIndex 
		    Fus.AddPoint pts(i)
		  next
		  
		  
		  'if dir = -1  then
		  'Fus = new Polyqcq(Objects,Points((start1+1)mod npts).bpt)
		  'for i = 2 to npts-1
		  'Fus.AddPoint Points((start1+i) mod npts).bpt
		  'next
		  'for  i = 1 to Fus2.npts-1
		  'Fus.AddPoint Fus2.Points((start2+i) mod fus2.npts).bpt
		  'next
		  'elseif dir = 1 then
		  'Fus = new Polyqcq(Objects, Points(start1).bpt)
		  'for i = 1 to npts-1
		  'Fus.AddPoint Points((start1+i) mod npts).bpt
		  'next
		  'for i = 0 to Fus2.npts-1
		  'Fus.AddPoint Fus2.Points((start2+ i) mod Fus2.npts).bpt
		  'next
		  'Fus.Points(0).Identify1(Fus.Points(npts))
		  'Fus.Points(1).Identify1(Fus.Points(npts+1))
		  'end if
		  Fus.coord = new nBPoint(Fus)
		  return Fus
		End Function
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
		    return str(npts)+"-"+Dico.value("gone")
		  end select
		End Function
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
		        if M <> nil and M.v1 <> nil then
		          np2 = M*np2
		        end if
		      else
		        s = p(2).pointsur.item(0)
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
		Function NextPoint(p as Point) As Point
		  if GetIndexPoint(p) < npts-1 then
		    return Points(GetIndexPoint(p)+1)
		  else
		    return Points(0)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OldInitConstruction()
		  Super.InitConstruction
		  
		  
		  
		  
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
		  
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(p as BasicPoint) As Boolean
		  Dim i, i0, j0 As Integer
		  dim pp(3) as BasicPoint
		  dim r as double
		  
		  if npts = 2 then
		    return p.between(points(0).bpt, points(1).bpt) and p.distance(points(0).bpt, points(1).bpt)  < can.magneticdist
		  Elseif npts = 4 Then  'Pourquoi ce cas particulier des quadrilatères?
		    for i = 1  to 3
		      pp(i) = coord.tab(i) - coord.tab(0)
		      if pp(i).norme < epsilon then
		        return false
		      end if
		    next
		    
		    if (abs(pp(2).Vect(pp(1))) < epsilon) and (abs(pp(3).Vect(pp(1))) <epsilon) then
		      i0 = 0
		      j0 = 1
		      for i = 2 to 3
		        r = coord.tab(i).location(coord.tab(0),coord.tab(1))
		        if r > 1 then
		          j0 = i
		        end if
		        if r < 0 then
		          i0 = i
		        end if
		      next
		      if p.distance(coord.tab(0), coord.tab(1)) <  can.MagneticDist then
		        return p.between(coord.tab(i0), coord.tab(j0))
		      end if
		    end if
		  end if
		  return coord.pInShape(p) 'si 0, p est extérieur au polygone, sinon le résultat est l'indice de Cauchy de p et est à l'interieur
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pinshape1(p as BasicPoint) As integer
		  return coord.pinshape1(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pointonline(p as basicpoint) As integer
		  dim i, imin as integer
		  dim distmin, dist, delta as double
		  
		  delta = can.MagneticDist
		  
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
		Function PointOnSide(p as BasicPoint) As integer
		  Dim i, imin As Integer
		  dim distmin, dist, delta as double
		  
		  delta = can.MagneticDist
		  
		  distmin = 1000
		  imin = -1
		  for i = 0  to npts-1
		    dist = p.distance(Points(i).bpt,Points((i+1) mod npts).bpt)
		    if dist <= distmin then
		      if dist <  delta and  p.between(Points(i).bpt,Points((i+1) mod npts).bpt) then
		        distmin = dist
		        imin = i
		      end if
		    end if
		  next
		  Return imin
		  
		  'Attention pointonside = -1 signifie p n'appartient pas au bord du polygone, alors que pour les changements de couleur, cela signifie est intérieur au polygone
		  'et peut être encore dans d'autres circonstances
		  
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
		Sub ToEPS(tos as textoutputstream)
		  dim s as string
		  dim j as integer
		  dim seps as SaveEPS
		  
		  seps = SaveEps(CurrentContent.currentoperation)
		  
		  
		  if not hidden then
		    s = "[ "
		    if Ti = nil then
		      for j = 0 to npts-1
		        s = s+ " " + Points(j).etiquet+ " "
		      next
		    else
		      for j = 0 to npts-1
		        s = s+ " " + Points(j).etiquet+ " " + str(0.5) + " "
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
		          tos.writeline("[ "+Points(j).etiquet+" "+ Points((j+1) mod npts).etiquet+ " ]  segment ")
		        else
		          tos.writeline("[ "+Points(j).etiquet+" "+ str(0.5) + " " + Points((j+1) mod npts).etiquet + " ]  fleche ")
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
		    
		    if pointe then
		      for j = 0 to childs.count-1
		        childs(j).ToEps(tos)
		      next
		    end if
		    for j = ubound(points) +1 to ubound(childs)
		      childs(j).ToEps(tos)
		    next
		  end if
		  
		  
		  
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
			Name="ArcAngle"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
			InitialValue="0"
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
