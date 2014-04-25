#tag Class
Protected Class BiBPoint
Inherits nBpoint
	#tag Method, Flags = &h0
		Sub BiBPoint(p as BasicPoint, q as BasicPoint)
		  Tab.append p
		  Tab.append q
		  if p <> nil and  q <> nil then
		    setlongueur
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BibDroiteInterCercle(D as BiBPoint, Byref p() as BasicPoint, byref q as Basicpoint, byref v as basicpoint) As integer
		  dim ray, dist, cot as Double
		  dim i, n as integer
		  
		  q = D.second - D.First                       // D est le cercle
		  ray = q.norme
		  dist = D.first.Distance(First,Second)
		  q = D.First.Projection(First,Second)  // q est le milieu de la corde
		  redim p(-1)
		  
		  cot = sqrt(abs(ray*ray-dist*dist))
		  v = Second-first
		  v = v.normer
		  v = v*cot                                            // L'orientation de v est celle de self (de first vers second)
		  if abs(cot) < epsilon then
		    p.append q
		    p.append q
		    return 1
		  elseif ray> dist + epsilon then
		    p.append q-v                             //p(0) est avant p(1) sur la droite (orientée)
		    p.append q+v
		    return 2
		  elseif ray < dist - epsilon then
		    p.append q-v                             //p(0) est avant p(1) sur la droite (orientée)
		    p.append q+v
		    return 0
		  end if
		  
		  //Il faudrait unifier Bibdroiteintercercle, Bibdemidroiteintercercle et Bibsegmentintercerle
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BibInterCercles(D as BiBPoint, Byref p() as BasicPoint, byref bq as Basicpoint, byref v as basicpoint) As integer
		  dim B as BiBPoint
		  
		  B = AxeRadical(D)
		  
		  if B <> nil then
		    return B.BiBDroiteInterCercle(D, p(), bq, v)
		  else
		    return 0
		  end  if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AxeRadical(D as BiBPoint) As BiBPoint
		  dim r1,r2, dist as Double
		  dim v, w as BasicPoint
		  
		  
		  r1= First.Distance(Second)
		  r2 = D.First.Distance(D.Second)
		  dist = First.Distance(D.First)
		  if dist < epsilon then
		    return nil
		  end if
		  
		  v = First-D.First
		  v=v.normer
		  v = v*((r2*r2-r1*r1+dist*dist)/(2*dist))
		  v = D.first+v
		  w =  first - D.first
		  'w = w.vecnorperp + v
		  w = new BasicPoint(-w.y,w.x)
		  w = v+w
		  return new BiBPoint(v,w)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ComputeFirstIntersect(type as integer, S as Shape, P as Point) As Basicpoint
		  'type = 0  bibpoint d'une droite ou = 1 d'un cercle
		  dim q as BasicPoint
		  
		  
		  select case type
		  case 0
		    q = ComputeDroiteFirstIntersect(S,p)
		  case 1
		    q = ComputeCircleFirstIntersect(S,p)
		  end select
		  
		  return q
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BibSegmentInterCercle(D as BiBPoint, Byref p() as BasicPoint, byref bq as BasicPoint, byref v as basicpoint) As integer
		  dim q() as BasicPoint
		  dim i, n, m as integer
		  
		  n = BiBDroiteInterCercle(D,p(), bq, v)
		  
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BiBpoint(p as point)
		  dim s as shape //Construit le bibpoint sur lequel se trouve un point donné
		  dim n as integer
		  
		  if p.pointsur.count <> 1 then
		    Tab = nil
		  else
		    s = p.pointsur.element(0)
		    if s isa droite then
		      'Tab = Droite(s).coord.Tab
		      BibPoint(droite(s).firstp,droite(s).secondp)
		      nextre = droite(s).nextre
		      type = 0
		    elseif s isa polygon then
		      n = p.numside(0)
		      BibPoint(s.Points(n).bpt, s.Points((n+1) mod s.npts).bpt)
		      nextre = 2
		      type = 0
		    elseif s isa bande then
		      n = p.numside(0)
		      if n = 0 then
		        BibPoint(s.points(0).bpt, s.points(1).bpt)
		      else
		        BibPoint(s.points(2).bpt, Bande(s).Point3)
		      end if
		      nextre = 0
		      type = 0
		    elseif s isa secteur then
		      n = p.numside(0)
		      BibPoint(s.Points(0).bpt, s.Points(n).bpt)
		      nextre = 1
		      type = 0
		    elseif s isa Circle then
		      BibPoint(s.points(0).bpt, s.points(1).bpt)
		      type = 1
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BibDemiDroiteInterCercle(D as BiBPoint, Byref p() as BasicPoint, byref bq as BasicPoint, byref v as basicpoint) As integer
		  
		  dim i, n, m as integer
		  
		  
		  n = BiBDroiteInterCercle(D, p(), bq, v)
		  
		  for i = n-1 downto 0
		    if p(i).audela(first,second) then
		      m = m+1
		    else
		      p.remove i
		    end if
		  next
		  
		  return m
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ComputeDroiteFirstIntersect(S as Shape, P as Point) As Basicpoint
		  dim q() as BasicPoint
		  dim Bib As  BiBPoint
		  dim i,n as integer
		  dim r, r1, r2 as double
		  dim bq, v as Basicpoint
		  dim inter as intersec
		  
		  if S isa Droite then
		    Bib = new BiBpoint(S.Points(0).bpt,  S.Points(1).bpt)
		    if Bib <> nil then
		      q.append BibInterdroites(Bib,0,Droite(S).nextre,r1,r2)
		      if r1 = 1000 then
		        q(0) = P.bpt
		      end if
		    end if
		  end if
		  
		  if S isa Circle then
		    Bib = new BiBpoint(S.Points(0).bpt,  S.Points(1).bpt)
		    n = BiBDroiteInterCercle(Bib,q(), bq, v)
		    if n=2 then
		      if q(0).Distance (P.bpt) >q(1).Distance (P.bpt)  then
		        q(0)=q(1)
		      end if
		    end if
		  end if
		  
		  // Si S est un polygone, on suppose que p reste sur le même côté
		  
		  
		  if S isa Polygon then
		    Bib = new BiBPoint(S.Points(P.Numside(0)).bpt,S.Points((P.Numside(0)+1) mod S.npts).bpt)
		    q.append BibInterdroites(Bib,0,2,r1,r2)
		    if r1 = 1000 then
		      q(0) = P.bpt
		    end if
		  end if
		  
		  //idem
		  if S isa Bande then
		    i = P.PointSur.GetPosition(S)
		    i = P.Numside(i)
		    if i = -1 then
		      q.append nil
		    else
		      if i = 0 then
		        Bib = new BibPoint(S.Points(0).bpt,S.Points(1).bpt)
		      else
		        Bib = new BibPoint(S.Points(2).bpt,Bande(S).Point3)
		      end if
		      q.append BiBInterdroites(Bib,0,0,r1,r2)
		      if r1 = 1000 then
		        q(0)= P.bpt
		      end if
		    end if
		  end if
		  
		  //idem
		  if S isa Secteur then
		    i = P.PointSur.GetPosition(S)
		    i = P.Numside(i)
		    if i = -1 then
		      q.append nil
		    else
		      Bib = new BibPoint(S.Points(0).bpt,S.Points(i).bpt)
		      q.append BiBInterdroites(Bib,0,1,r1,r2)
		      if r = 1000 then
		        q(0) = P.bpt
		      end if
		    end if
		  end if
		  
		  return q(0)
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ComputeCircleFirstIntersect(S as Shape, P as Point) As Basicpoint
		  dim q() as BasicPoint
		  dim Bib As  BiBPoint
		  dim i,n as integer
		  dim r as double
		  dim bq, v as BasicPoint
		  
		  
		  if S isa Droite then
		    Bib = new BiBpoint(S.Points(0).bpt,  S.Points(1).bpt)
		    select case Droite(S).nextre
		    case 0
		      n = Bib.BiBDroiteInterCercle(self,q(), bq, v)
		    case 1
		      n = Bib.BiBDemiDroiteInterCercle(self,q(), bq, v)
		    case 2
		      n = Bib.BiBSegmentInterCercle(self,q(), bq, v)
		    end select
		  end if
		  
		  if S isa Circle then
		    Bib = new BiBpoint(S.Points(0).bpt,  S.Points(1).bpt)
		    n = BiBInterCercles(Bib,q(),bq,v)
		    if n = 0 then
		      q.append p.bpt
		    end if
		  end if
		  
		  if S isa Polygon then
		    Bib = new BiBPoint(S.Points(P.Numside(0)).bpt,S.Points((P.Numside(0)+1) mod S.npts).bpt)
		    n = Bib.BiBSegmentInterCercle(self,q(),bq,v)
		  end if
		  
		  if S isa Bande then
		    i = P.PointSur.GetPosition(S)
		    i = P.Numside(i)
		    if i = -1 then
		      q.append nil
		    else
		      Bib = new BibPoint(S.Points(2*i).bpt,S.Points(2*i+1).bpt)
		      n = Bib.BiBDroiteInterCercle(self,q(), bq, v)
		    end if
		  end if
		  
		  if S isa Secteur then
		    i = P.PointSur.GetPosition(S)
		    i = P.Numside(i)
		    if i = -1 then
		      q.append nil
		    else
		      Bib = new BibPoint(S.Points(0).bpt,S.Points(i+1).bpt)
		      n = Bib.BiBDroiteInterCercle(self,q(), bq, v)
		    end if
		  end if
		  
		  if n=2 and  q(0).Distance (P.bpt) >q(1).Distance (P.bpt)  then
		    q(0)=q(1)
		  end if
		  
		  if ubound(q) > -1 then
		    return q(0)
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Interscreen(Byref mi as double, Byref ma as double)
		  dim csg, csd, cig, cid, ext  as BasicPoint
		  dim BiB As BiBPoint
		  dim r, r1, r2 as double
		  
		  
		  wnd.mycanvas1.coins(csg,csd,cig,cid)
		  
		  if abs(first.x-second.x) < wnd.mycanvas1.magneticdist then
		    r = second.y-first.y
		    if r > 0 then
		      ma = (csg.y-first.y)/r
		      mi =  (cig.y - first.y)/r
		    else
		      ma = (cig.y-first.y)/r
		      mi =  (csg.y - first.y)/r
		    end if
		    
		  else
		    mi = 9999
		    ma = -9999
		    
		    Bib = new BiBPoint(cig, csg)
		    ext = BiBInterdroites(Bib,0,0,r1,r2)
		    
		    if ext <> nil then
		      mi = min (r1, mi)
		      ma =max (r1, ma)
		    end if
		    
		    Bib = new BiBPoint(csg, csd)
		    ext = BiBInterdroites(Bib,0,0,r1,r2)
		    
		    if ext <> nil then
		      mi = min (r1, mi)
		      ma =max (r1, ma)
		    end if
		    
		    Bib = new BiBPoint(csd, cid)
		    ext = BiBInterdroites(Bib,0,0,r1,r2)
		    
		    if ext <> nil then
		      mi = min (r1, mi)
		      ma =max (r1, ma)
		    end if
		    
		    Bib = new BiBPoint(csd, cid)
		    ext = BiBInterdroites(Bib,0,0,r1,r2)
		    
		    if ext <> nil then
		      mi = min (r1, mi)
		      ma =max (r1, ma)
		    end if
		  end if
		  
		  ma = ma +0.1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BptOnBiBpt(r as double) As BasicPoint
		  return First * (1-r) + second * r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ComputeDroiteFirstIntersect(S as Shape, k as integer, P as BasicPoint) As BasicPoint
		  dim q() as BasicPoint
		  dim Bib As  BiBPoint
		  dim n as integer
		  dim r1, r2 as double
		  dim bp, bq, v as Basicpoint
		  dim dr as droite
		  
		  if not S isa circle then
		    dr = s.getside(k)
		    Bib = new BiBpoint(dr.firstp, dr.secondp)
		    if Bib <> nil then
		      bp = BiBInterdroites(Bib, 0, dr.nextre, r1, r2)
		      if r1 = 1000 then
		        bp = P
		      end if
		    end if
		    
		  else
		    
		    Bib = new BiBpoint(S.Points(0).bpt,  S.Points(1).bpt)
		    n = BiBDroiteInterCercle(Bib,q(), bq, v)
		    if n = 0 then
		      bp = nil
		    else
		      bp = q(0)
		      if n=2 then
		        if q(0).Distance (P) >q(1).Distance (P)  then
		          bp =q(1)
		        end if
		      end if
		    end if
		  end if
		  return bp
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ComputeCircleFirstIntersect(S as Shape, k as integer, P as BasicPoint) As Basicpoint
		  dim q() as BasicPoint
		  dim Bib As  BiBPoint
		  dim i,n as integer
		  dim r as double
		  dim bp, bq, v as BasicPoint
		  dim dr as droite
		  
		  if S isa Droite or s isa polygon or s isa bande or s isa secteur then
		    dr = s.getside(k)
		    Bib = new BiBpoint(dr.firstp, dr.secondp)
		    select case dr.nextre
		    case 0
		      n = Bib.BiBDroiteInterCercle(self,q(), bq, v)
		    case 1
		      n = Bib.BiBDemiDroiteInterCercle(self,q(), bq, v)
		    case 2
		      n = Bib.BiBSegmentInterCercle(self,q(), bq,v)
		    end select
		  end if
		  
		  if S isa Circle then
		    Bib = new BiBpoint(S.Points(0).bpt,  S.Points(1).bpt)
		    n = BiBInterCercles(Bib,q(),bq,v)
		  end if
		  
		  if n = 0 then
		    bp = nil
		  else
		    bp = q(0)
		    if n=2 and  q(0).Distance (P) >q(1).Distance (P)  then
		      bp =q(1)
		    end if
		  end if
		  
		  return bp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BibInterdroites(D as BiBPoint, n1 as integer, n2 as integer, Byref r1 as double, byref r2 as double) As BasicPoint
		  dim p, q, u, v as BasicPoint
		  
		  p = D.VecteurDirecteur
		  if p = nil then
		    return nil
		  end if
		  p = p.Vecnorperp
		  u = VecteurDirecteur
		  if u = nil then
		    return nil
		  end if
		  q = D.first-first
		  r1= p*u
		  
		  if abs (r1) < epsilon*u.norme then   // Bibpoints parallèles ou alignés
		    v = D.first-second
		    r2 = q.vect(v)
		    if abs(r2) <= epsilon*v.norme*q.norme then
		      r1 = 1000   // les bipoints sont alignés
		      r2 = 1000
		    else
		      r1 = 999     // les bipoints sont paralleles
		      r2 = 999
		    end if
		    return nil
		  end if
		  
		  r1 = (p*q)/(p*u)   // r = 999: parallelisme r = 1000: alignement  et return = nil sinon r réel  et return <> nil
		  q= BptOnBiBpt(r1) // r1 est la position du point d'intersection sur self
		  r2 = q.location(D.first,D.second)  //Position sur D
		  
		  setlongueur
		  D.setlongueur
		  'if (n1 = 1 and r1 <-epsilon) or(n1 = 2 and (r1<-epsilon or r1>1+epsilon)) then
		  'if (n1 = 1 and r1 <0) or(n1 = 2 and (r1<0 or r1>1)) then
		  
		  if (n1 = 1 and r1 <-epsilon)  or(n1 = 2 and ((r1<0 and abs(r1)*longueur > epsilon) or (r1>1 and (r1-1)*longueur > epsilon)) ) then
		    return nil
		    'elseif (n2 = 1 and r2 <0) or(n2 = 2 and (r2<0 or r2>1)) then
		  elseif (n2 = 1 and r2 <-epsilon) or(n2 = 2 and ((r2<0 and abs(r2)*D.longueur > epsilon) or (r2>1 and (r2-1)*D.longueur > epsilon)) ) then
		    return nil
		  else
		    return q
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Setlongueur()
		  longueur= First.distance(Second)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VecNorPerp() As basicPoint
		  dim v as BasicPoint
		  
		  v = Second - First
		  
		  return v.vecnorperp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function First() As basicPoint
		  return Tab(0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Second() As basicPoint
		  return Tab(1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Vecnorparaperp(n As integer) As BasicPoint
		  
		  dim v as BasicPoint
		  
		  if abs(tab(0).distance(tab(1)) )< epsilon  then
		    return new BasicPoint(0,0)
		  end if
		  
		  v = tab(1)-tab(0)
		  if n = 2 then
		    v = new BasicPoint(-v.y,v.x)
		  end if
		  
		  return v.normer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReporterLongueur(bp1 as BasicPoint, bp2 as BasicPoint) As basicPoint
		  dim d as double
		  dim u as basicPoint
		  
		  d = bp1.distance(bp2)
		  u = second-first
		  u = u.normer
		  return first+u*d
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VecteurDirecteur() As BasicPoint
		  if first <> nil and second <> nil then
		    return second -first
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeCtrlPoints(c as basicpoint, ori as integer, byref ctrl() as BasicPoint)
		  dim A  As Angle
		  dim alpha as double
		  dim M as Matrix
		  dim d, k, r1, r2 as double
		  dim Bib1, BiB2 as BiBPoint
		  dim q,bp1,bp2 as BasicPoint
		  dim i as integer
		  
		  A = new Angle(self, c, ori)
		  alpha = A.alpha
		  if abs(alpha) < epsilon then
		    for i = 0 to 1
		      ctrl(i) =first
		    next
		  else
		    alpha = alpha/2
		    d = cos(alpha)
		    k = 4*d*(1-d)/(3*(1-d*d))
		    bp1 = first-c
		    bp1 = bp1.vecnorperp
		    BiB1 = new BiBPoint(first, first+bp1)
		    bp2 = second-c
		    bp2 = bp2.VecNorPerp
		    BiB2 = new BiBPoint(second, second+bp2)
		    q = BiB1.BiBInterDroites(BiB2,0,0,r1,r2)
		    if q <> nil then
		      ctrl(0) =  first*(1-k)+q*k         'Pour un cercle, a=2PI/3, k = 4/9
		      ctrl(1) = second*(1-k) +q*k
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function subdiv(ndiv as integer, i as integer) As BasicPoint
		  dim n as double
		  
		  if first.distance(second) < epsilon then
		    return first
		  end if
		  
		  n = ndiv
		  return first + (second-first)*(i/n)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function returned() As BiBPoint
		  
		  return new BiBPoint(tab(1), tab(0))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function sufficientlynear(d2 as BiBPoint) As Boolean
		  return ( first.distance(d2.first) <=epsilon) and (second.distance(d2.second) <= epsilon)
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BiBPoint(nBp as nBPoint)
		  tab = nBP.tab
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Anglepolaire() As double
		  dim bp as Basicpoint
		  
		  bp = second - first
		  return bp.anglepolaire
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PositionOnCircle(a as double, orien as integer) As BasicPoint
		  dim p, q as BasicPoint
		  dim r, b as double
		  
		  
		  if abs(orien) = 1 then
		    q = tab(1) - tab(0)
		    r = q.norme
		    b = anglepolaire + a*2*PI*orien
		    q = new BasicPoint(cos(b),sin(b))
		    q =  tab(0) + q *r
		    return q
		  end if             'positionne un basicpoint sur un cercle à partir de son abscisse curviligne relative à ce cercle
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

	#tag Note, Name = Organigramme
		
		Deux méthodes sont à la racine de cette classe:
		
		BibInterdroites  si les deux droites sont parallèles, la méthode retourne nil et r = 999
		                            si elles sont confondues, retour de nil et r = 1000
		                            sinon retour du point d'intersection  et r est l'abscisse de ce point sur la première droite 
		                BibDemiDroiteInterDroite appelle BibInterDroites
		                                 BibInterDemiDroites appelle BibDemiDroiteInterDroite
		                                 BibSegmentInterDroite appelle BibDemidroiteinterdroite
		                                                      BibSegmentInterDemiDroite appelle BibSegmentInterDroite et BibDemiDroiteInterDroite
		                                                       BibInterSegments appelle BibSegmentInterDroite
		               (retours analogues)
		
		BibDroiteInterCercle  retourne le nombre de points d'intersection et ceux-ci dans le tableau p(0,1 ou 2)
		               BibDemiDroiteInterCercle appelle BibDroiteInterCercle
		               BibSegmentInterCercle appelle BibDroiteInterCercle
		               BibInterCercles appelle BibDroiteInterCercle
	#tag EndNote


	#tag Property, Flags = &h0
		nextre As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		type As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		longueur As double
	#tag EndProperty


	#tag ViewBehavior
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
			Name="nextre"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="type"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="longueur"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
