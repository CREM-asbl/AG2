#tag Class
Protected Class Droite
Inherits Bipoint
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

	#tag Method, Flags = &h0
		Sub ComputeExtre()
		  dim D1 as BiBpoint
		  dim mi, ma as double
		  
		  if firstp = nil or secondp = nil then
		    return
		  end if
		  
		  if firstp.distance(secondp) < can.magneticdist  then
		    extre1= firstp
		    extre2= secondp
		  else
		    D1 = new BiBPoint(firstp, secondp)
		    D1.Interscreen(mi,ma)
		    
		    select case nextre
		    case 0
		      extre1 = D1.BptOnBiBpt(mi)
		      extre2 = D1.BptOnBiBpt(ma)
		    case 1
		      extre1 = firstp
		      extre2 = D1.BptOnBiBpt(ma)
		    case 2
		      extre1= firstp
		      extre2 = secondp
		    end select
		  end if
		  
		End Sub
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
		Sub Constructor(ol As ObjectsList, p as BasicPoint, n as integer)
		  'Utilise pour la construction à la souris
		  
		  Super.Constructor(ol,2,2)
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
		Sub Constructor(Obj as Objectslist, dr as droite, q as Basicpoint)
		  dim i, j as integer
		  dim M as Matrix
		  
		  Super.Constructor(obj,dr)
		  ncpts = 2
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
		Sub Constructor(ol as objectslist, n as integer)
		  Super.constructor(ol, 2,2)
		  nextre = n
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, k as integer, temp as XMLElement)
		  Shape.Constructor(ol , temp)
		  ncpts = 2
		  select case k
		  case 0 to 2
		    nextre = 2
		  case 3 to 5
		    nextre = 0
		  case 6
		    nextre = 1
		  end select
		  createskull(firstp)
		  computeextre
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, fp as point, sp as BasicPoint, n as integer)
		  dim i as integer
		  dim secP as Point
		  
		  Super.Constructor(ol,2,2)
		  
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
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, fp as point, sp as point, n as integer)
		  //Constructeur utilisé uniquement par prolonger
		  dim i as integer
		  
		  Super.Constructor(ol,2,2)
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
		  endconstruction
		  createskull(fp.bpt)
		  computeextre
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, s as polygon, n as integer)
		  'utilisé pour dupliquer un cote de polygone
		  
		  Super.Constructor(ol,2,2)
		  nextre = 2
		  Points.append new Point(ol, s.points(n).bpt)
		  SetPoint(Points(0))
		  Points.append new point(ol, s.points((n+1) mod s.npts).bpt)
		  setpoint(Points(1))
		  createskull(points(0).bpt)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(p1 as Point, p2 as Point)
		  'segment servant lors du calcul des intersections (cas des polygones)
		  
		  Points.append p1
		  Points.append p2
		  nextre = 2
		  coord = new BiBpoint(firstp, secondp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape()
		  dim i, index, ori as integer
		  dim s as shape
		  
		  'Ne concerne que les paraperp
		  
		  if constructedby <> nil and (constructedby.oper < 3) then
		    updatecoord
		    if ubound(constructedby.data) >  -1 then
		      index = constructedby.data(0)
		      if ubound(constructedby.data) = 2 then
		        ori = constructedby.data(2)
		      end if
		      s = constructedby.shape
		      coord.constructparaperp(forme, s.getbibside(index), indexconstructedpoint, ori)
		      repositionnerpoints
		      computeextre
		    end if
		    if  nextre = 0 then
		      points(1).hide
		    end if
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createskull(p as basicPoint)
		  nsk = new SegSkull(can.transform(p))
		  nsk.skullof = self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createtsf()
		  dim tsf as transformation
		  
		  tsf = new Transformation (self, 0,  constructedby.data(0), 0)
		  constructedby.data.append tsf
		  
		  tsf.constructedshapes.addshape self
		  'tsf.supp = constructedby.shape
		  tsf.supp.tsfi.addObject tsf
		  'tsf.index =constructedby.data(0)
		  CurrentContent.TheTransfos.addObject tsf
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CShape(ol as ObjectsList, k as integer, EL as XMLElement)
		  Super.Constructor(ol,EL)
		  ncpts = 2
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
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndConstruction()
		  dim p0, p1 as point
		  dim sh(-1) as shape
		  dim i as integer
		  dim n0, n1, m as integer
		  dim t as boolean
		  
		  if currentcontent.currentoperation isa prolonger then
		    p0 = points(0)
		    p1 = points(1)
		    
		    if p0.sameparent(p1,sh) then
		      t = false
		      i = 0
		      while t = false and i <= ubound(sh)
		        n0 = sh(i).getindexpoint(p0)
		        n1 = sh(i).getindexpoint(p1)
		        if sh(i) isa Lacet and ( (n1 = (n0+1) mod sh(i).npts) or  (n0 = (n1+1) mod sh(i).npts))    then
		          m = min(n0,n1)
		          if m = 0 and (n0 <> 1) and (n1 <> 1) then
		            m = sh(i).npts-1
		          end if
		          setconstructedby sh(i), 8
		          Constructedby.data.append m
		          t = true
		        end if
		        i = i+1
		      wend
		    end if
		  end if
		  super.endconstruction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as Basicpoint, n as integer)
		  dim i as integer
		  
		  for i = n to 1
		    Points(i).MoveTo(p)
		  next
		  if (forme mod 3) <> 0 then
		    constructshape
		    segskull(nsk).update(self)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FixeCouleurTrait(i as integer, coul as couleur)
		  
		  BorderColor = coul
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSide(n as integer) As droite
		  return self
		End Function
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
		Function Inter(s as circle, byref p() as Basicpoint, byref bq as BasicPoint, Byref w as BasicPoint) As integer
		  dim B1, B2 as BiBpoint
		  dim k as integer
		  
		  if  ubound(p) = 1 then
		    B1 = new BiBPoint(coord.tab(0), coord.tab(1))
		    B2 = new BiBpoint(s.coord.tab(0),s.coord.tab(1))
		    k = B1.BiBDroiteInterCercle(B2,p(), bq, w)
		  else
		    k = 0
		  end if
		  return k
		  
		  
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
		Function longueur() As double
		  return firstp.distance(secondp)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub oldConstructor(D as Droite, M as Matrix)
		  Super.Constructor(D, M)
		  nextre = D.nextre
		  
		  
		End Sub
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
		Sub Paint(g as Graphics)
		  dim e, m as BasicPoint
		  
		  
		  ComputeExtre
		  super.Paint(g)
		  e = (coord.tab(1)-coord.tab(0))*0.1
		  m =(coord.tab(0)+coord.tab(1))/2
		  if  e.norme>0 and Ti <> nil and not hidden  then
		    PaintTip(m-e,m+e,Bordercolor,0.5,g)
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
		Function parallelto(sh as shape, n as integer) As boolean
		  dim d as droite
		  dim u, v as BasicPoint
		  
		  if constructedby<> nil and constructedby.oper = 1 and constructedby.shape = sh then
		    if sh isa droite then
		      return true
		    elseif sh isa Lacet and constructedby.data(0) = n  then
		      return  true
		    end if
		  end if
		  d = sh.getside(n)
		  u = vecteurdirecteur.normer
		  v = d.vecteurdirecteur.normer
		  if u = nil or v = nil then
		    return true
		  else
		    return abs(u.vect(v) ) < epsilon
		  end if
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As shape
		  
		  dim s as droite
		  dim j as integer
		  
		  s = new Droite(Obl,self, p)
		  s.computeextre
		  
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(p as basicpoint) As Boolean
		  dim r , delta as double
		  dim t as boolean
		  
		  delta = can.MagneticDist
		  
		  if firstp <> nil and secondp <> nil then
		    t = p.Distance(FirstP,SecondP) < delta
		    
		    select case nextre
		    case 0
		      return  t
		    case 1
		      return ( t and p.audela(firstp,secondp) ) or (p.distance(firstp) < delta)
		    case 2
		      return  (t and p.between(FirstP,SecondP))  or (p.distance(firstp) < delta)   or (p.distance(secondp) < delta)
		    end select
		  end if
		  
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as basicpoint) As integer
		  dim delta as double
		  
		  
		  delta = can.MagneticDist
		  
		  'if p.distance(firstp, secondp) < delta then
		  'return 0
		  'else
		  'return -1
		  'end if
		  
		  '//Ne vaudrait-il pas mieux 
		  if pinshape(p) then
		    return 0
		  else
		    return -1
		  end if  
		End Function
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
		Function prppupdate0() As boolean
		  Dim u, w,ep,  np As BasicPoint
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
		  points(1).moveto np
		  Return True 'New Similaritymatrix(points(0).bpt, ep, points(0).bpt, np)
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function prppupdate1() As boolean
		  Dim Bib1, BiB2 As BiBPoint
		  dim sf as figure
		  dim  p, q as Point
		  dim n as integer
		  dim  w, ep, np, eq, nq, u as Basicpoint
		  dim d as double
		  dim dr as droite
		  dim M as Matrix
		  
		  sf = getsousfigure(fig)
		  p = points(0)
		  q = points(1)
		  sf.getoldnewpos(p,ep,np)
		  sf.getoldnewpos(q,eq,nq)
		  
		  u = eq - ep
		  d = u.norme
		  w = constructbasis
		  if u*w < 0 then
		    w = w*(-1)
		  end if
		  
		  if p.modified and q.forme = 1 then
		    BiB1 = new BiBPoint(ep, ep+w)
		    if q.pointsur.item(0) isa droite or q.pointsur.item(0) isa polygon then
		      dr =  q.pointsur.item(0).getside(q.numside(0))
		      Bib2 = new BiBPoint(dr.firstp,dr.secondp)
		      M = new AffiProjectionMatrix(BiB1,Bib2)
		      nq = M*np
		    elseif q.pointsur.item(0) isa circle then
		      nq = BiB1.ComputeFirstIntersect(1,q.pointsur.item(0),points(1))
		    end if
		  else
		    if q.forme = 0 then
		      w = w.normer
		      u = nq-np
		      d = u.norme
		      nq = np+w*d
		      q.moveto nq
		      q.modified = True
		      'else
		      'Return prpupdate11(q,ep,eq,np,nq)
		    End If
		  end if
		  return true 'new SimilarityMatrix(ep,eq,np,nq)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function prppupdate2() As boolean
		  Dim sf As figure
		  dim  p, q as Point
		  dim  ep, np, eq, nq, w as Basicpoint
		  dim t as Boolean
		  dim n as integer
		  dim d as double
		  
		  sf = getsousfigure(fig)
		  p = points(0)
		  q = points(1)
		  sf.getoldnewpos(p,ep,np)
		  sf.getoldnewpos(q,eq,nq)
		  
		  n = sf.NbSommSur
		  w = constructbasis
		  
		  select case n
		  case 0
		    nq = nq.Projection(np,np+w)
		    q.moveto nq
		    Return True 'new SimilarityMatrix(ep,eq,np,nq)
		  case 1
		    n = sf.ListSommSur(0)
		    t = sf.replacerpoint(points(n))
		    if n = 0 then
		      if  q.forme = 0 then
		        nq = nq.Projection(np,np+w)
		        q.moveto nq
		        Return True 'new SimilarityMatrix(ep,eq,np,nq)
		      else
		        Return prpupdate11(p,eq,ep,nq,np)
		      end if
		    else
		      Return  prpupdate11(q,ep,eq,np,nq)
		    end if
		  case 2
		    if check then
		      Return True 'new SimilarityMatrix(ep,eq,np,nq)
		    else
		      t = sf.replacerpoint(q)
		      sf.getoldnewpos(p,ep,np)
		      sf.getoldnewpos(q,eq,nq)
		      Return  prpupdate11(q,ep,eq,np,nq)
		    end if
		  end select
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function prpupdate11(q as point, ep as basicpoint, eq as basicPoint, np as basicPoint, nq as basicPoint) As Boolean
		  Dim dr1, dr2 As droite
		  dim Bib1, Bib2 as BiBPoint
		  dim w as basicpoint
		  dim M as Matrix
		  dim sh as shape
		  dim n as integer
		  dim r1, r2 as double
		  
		  sh = q.pointsur.item(0)
		  w = constructbasis
		  
		  if not sh isa circle then
		    dr2 = sh.getside(q.numside(0))
		    Bib2 = new BiBPoint(dr2.firstp, dr2.secondp)
		    dr1 = constructedby.shape.getside(constructedby.data(0))
		    Bib1 = new BibPoint(dr1.firstp, dr1.firstp+w)
		    M = new  AffiProjectionMatrix(Bib1, Bib2)
		    if M <> nil and M.v1 <> nil then
		      nq = M*np
		      q.moveto nq
		      if q.ProjectionOnAttractingDroite(dr2) = nil then
		        q.invalider
		      else
		        q.moveto eq
		        q.valider
		      end if
		    else
		      nq = nil
		    end if
		  else
		    if w.norme > epsilon then
		      Bib1 = new BibPoint(firstp, firstp+w)
		      nq  = Bib1.ComputeFirstIntersect(0,sh,q)
		      if (nq = nil) or (sh.pointonside(nq) = -1) then
		        q.invalider
		      else
		        q.valider
		      end if
		    end if
		  end if
		  q.modified = true
		  if  nq <> nil then
		    q.moveto nq
		  end if
		  return true 'new similaritymatrix (ep, eq, np, nq)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEps(tos as TextOutputstream)
		  dim i as integer
		  dim s as string
		  
		  if ti = nil or nextre < 2  then
		    s =  "[ "+Points(0).etiquet+" "+ Points(1).etiquet + " ] "
		  else
		    s =  "[ "+Points(0).etiquet+" "+ str(0.5) + " " + Points(1).etiquet+ " ] "
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
		  
		  for i = 0 to ubound(childs)
		    childs(i).toeps(tos)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Vecteurdirecteur() As BasicPoint
		  return secondp - firstp
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

	#tag Note, Name = Suggestion
		
		Créer une sous-classe de roite our les paraperp 
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
		T As Tip
	#tag EndProperty

	#tag Property, Flags = &h0
		w0 As BasicPoint
	#tag EndProperty


	#tag ViewBehavior
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
			Name="nextre"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="Side"
			Visible=false
			Group="Behavior"
			InitialValue="0"
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
