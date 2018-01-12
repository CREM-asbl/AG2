#tag Class
Protected Class Trap
Inherits Quadri
	#tag Method, Flags = &h0
		Function check() As Boolean
		  dim u, v as basicpoint
		  dim t as boolean
		  
		  if invalid then
		    return true
		  end if
		  
		  v = Points(2).bpt -Points(3).bpt
		  if  v.norme > epsilon then
		    v = v.normer
		  else
		    return true
		  end if
		  u = Points(1).bpt-Points(0).bpt
		  if u.norme > epsilon then
		    u= u.normer
		  else
		    return true
		  end if
		  
		  t = abs(v.vect (u) ) < epsilon
		  return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, p as basicPoint)
		  super.constructor(ol,4,p)
		  liberte = 7
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, fp as point, sp as point, qp as point, tp as point)
		  
		  Polygon.constructor(ol, fp , sp , qp , tp)
		  ncpts = 4
		  forme = 1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, Temp as XMLElement)
		  Polygon.constructor(ol,Temp)
		  Liberte = 7
		  ncpts=4
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function deplacerpoint2(p as point, q as point) As Boolean
		  dim np, ep, np0, np1, np2, np3, ep0, ep1, ep2, ep3, u, v1, v2, e, f as Basicpoint
		  dim Bib1, Bib2 as BiBpoint
		  dim m, n, k as integer
		  dim ff as figure
		  dim p0, p1, p2, p3 as point
		  
		  if q.pointsur.count = 1 then
		    return deplacerpointsur2(p,q)
		  end if
		  
		  n = getindexpoint(p)  // p est le point modifié
		  m = getindexpoint(q) // q est le point qui doit "suivre"
		  ff = getsousfigure(fig)
		  
		  if q.liberte = 0 then
		    ff.getoldnewpos(p,ep,np)
		    p.moveto np.projection(q.bpt , ep)
		    return true
		  end if
		  
		  p0 = points(0)
		  p1 = points(1)
		  p2 = points(2)
		  p3 = points(3)
		  
		  if n = 0 or n=1  then
		    if Stability(p,points(1-n)) then
		      return true
		    end if
		  end if
		  
		  if n = 2 or n = 3 then
		    if stability(p,points(5-n)) then
		      return true
		    end if
		  end if
		  
		  
		  ff.getoldnewpos(p0,ep0,np0)
		  ff.getoldnewpos(p1,ep1,np1)
		  ff.getoldnewpos(p2,ep2,np2)
		  ff.getoldnewpos(p3,ep3,np3)
		  
		  select case n+m
		  case 1
		    Bib1 = new BibPoint(p.bpt, p.bpt+np2-np3)
		    Bib2 = new BiBPoint(p.bpt, p.bpt+ep1-ep0)
		    p.bpt = p.bpt.projection(BiB1)
		  case 5
		    Bib1 = new BibPoint(q.bpt, q.bpt+np1-np0)
		    Bib2 = new BiBPoint(p.bpt, p.bpt+ep2-ep3)
		    p.bpt = p.bpt.projection(BiB1)
		    return true
		  case 2
		    if n = 0 then
		      Bib1 = new BibPoint(np3, np3+np1-np0)
		      Bib2 = new BiBPoint(np3, np3+ep2-ep3)
		    else
		      Bib1 = new BibPoint(np1, np1+np2-np3)
		      Bib2 = new BiBPoint(np1, np1+ep1-ep0)
		    end if
		  case 4
		    if n = 1 then
		      Bib1 = new BibPoint(np2, np2+np1-np0)
		      Bib2 = new BiBPoint(np2, np2+ep2-ep3)
		    else
		      Bib1 = new BibPoint(np0, np0+np2-np3)
		      Bib2 = new BiBPoint(np0, np0+ep1-ep0)
		    end if
		  case 3
		    select case n
		    case 0
		      Bib1 = new BibPoint(np2, np2+np1-np0)
		      Bib2 = new BiBPoint(np2, np2+ep2-ep3)
		    case 1
		      Bib1 = new BibPoint(np3, np3+np1-np0)
		      Bib2 = new BiBPoint(np3, np3+ep2-ep3)
		    case 2
		      Bib1 = new BibPoint(np0, np0+np2-np3)
		      Bib2 = new BiBPoint(np0, np0+ep1-ep0)
		    case 3
		      Bib1 = new BibPoint(np1, np1+np2-np3)
		      Bib2 = new BiBPoint(np1, np1+ep1-ep0)
		    end select
		  end select
		  
		  
		  return fininterbib(Bib1, bib2,q)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function deplacerpointsur2(p as point, q as point) As Boolean
		  dim np, ep, np0, np1, np2, np3, ep0, ep1, ep2, ep3, u, v1, v2 as Basicpoint
		  dim Bib1 as BiBpoint
		  dim m, n, k as integer
		  dim ff as figure
		  dim p0, p1, p2, p3 as point
		  dim sh as shape
		  
		  p0 = points(0)
		  p1 = points(1)
		  p2 = points(2)
		  p3 = points(3)
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(p0,ep0,np0)
		  ff.getoldnewpos(p1,ep1,np1)
		  ff.getoldnewpos(p2,ep2,np2)
		  ff.getoldnewpos(p3,ep3,np3)
		  
		  n = getindexpoint(p)  // p est le point modifié
		  m = getindexpoint(q) // q est le point qui doit "suivre"
		  
		  if q.liberte = 0 then
		    ff.getoldnewpos(p,ep,np)
		    p.moveto np.projection(q.bpt , ep)
		    return true
		  end if
		  
		  
		  select case n+m
		  case 1
		    Bib1 = new BibPoint(p.bpt, p.bpt+np2-np3)
		  case 5
		    Bib1 = new BibPoint(p.bpt, p.bpt+np1-np0)
		  case 2
		    if n = 0 then
		      Bib1 = new BibPoint(np3, np3+np1-np0)
		    else
		      Bib1 = new BibPoint(np1, np1+np2-np3)
		    end if
		  case 4
		    if n = 1 then
		      Bib1 = new BibPoint(np2, np2+np1-np0)
		    else
		      Bib1 = new BibPoint(np0, np0+np2-np3)
		    end if
		  case 3
		    select case n
		    case 0
		      Bib1 = new BibPoint(np2, np2+np1-np0)
		    case 1
		      Bib1 = new BibPoint(np3, np3+np1-np0)
		    case 2
		      Bib1 = new BibPoint(np0, np0+np2-np3)
		    case 3
		      Bib1 = new BibPoint(np1, np1+np2-np3)
		    end select
		  end select
		  
		  sh = q.pointsur.item(0)
		  v1 = Bib1.ComputeDroiteFirstIntersect(sh, q)
		  
		  if v1 <> nil then
		    q.moveto v1
		    return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function fininterbib(Bib1 as Bibpoint, bib2 as BibPoint, q As point) As Boolean
		  dim k as integer
		  dim v() as BasicPoint
		  dim bq, w as Basicpoint
		  
		  k = Bib1.BibDroiteInterCercle(Bib2, v(),bq,w)
		  
		  if k = 0 then
		    return false
		  end if
		  
		  if ubound(v) > 0 and v(1) <> nil and q.bpt.distance(v(1)) < q.bpt.distance(v(0)) then
		    v(0) = v(1)
		  end if
		  
		  if v(0) <> nil then
		    q.moveto v(0)
		    return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.value("Trap")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As Trap
		  return new Trap(Obl,self,p)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Stability(Byref Pt as Point, Q as point) As Boolean
		  dim v as BasicPoint
		  
		  dist = pt.bpt.distance(q.bpt)
		  if dist < can.MagneticDist*2 then
		    if Stab1 = nil then
		      Stab1 = Pt.bpt
		      Stab2 = Q.bpt*2-Pt.bpt
		    end if
		    v = Pt.bpt.projection(Stab1,Stab2)
		    Pt.moveto v
		    return true
		  else
		    Stab1 = nil
		    Stab2 = nil
		    return false
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function trapupdate1(p as point) As Boolean
		  dim ff as figure
		  dim ep, np as  BasicPoint
		  dim n, nn, m, n1, n2 as integer
		  dim p1,  p2, q as point
		  
		  
		  ff = getsousfigure(fig)
		  n = getindexpoint(p)
		  nn =ff.somm.getposition(p)
		  
		  'p1 = point(ff.somm.item(ff.fx1))
		  'n1 = getindexpoint(p1)
		  'p2 = point(ff.somm.item(ff.fx2))
		  'n2 = getindexpoint(p2)
		  
		  p1 = point(ff.somm.item((nn+2)mod 4))
		  n1 = getindexpoint(p1)
		  p2 = point(ff.somm.item((nn+3)mod 4))
		  n2 = getindexpoint(p2)
		  
		  m = quatriemepoint(n,n1,n2)
		  q = points(m)
		  
		  
		  return deplacerpoint2(p,q)
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function trapupdate2(p1 as point, p2 as point) As Boolean
		  dim i,m, n, n1, n2, n3 as integer
		  dim  p, p3, q as point
		  dim ff as figure
		  
		  ff = getsousfigure(fig)
		  ff.choixpointsfixes
		  
		  n1 = getindexpoint(p1)
		  n2 = getindexpoint(p2)
		  p = point(ff.somm.item(ff.fx1))
		  n = getindexpoint(p)
		  // p est le point fixe
		  //p1 et p2 sont les deux points modifiés
		  
		  n3 = quatriemepoint(n,n1,n2)
		  p3 = points(n3)
		  q = fig.pointmobile
		  m = getindexpoint(q)
		  
		  select case m
		  case n1
		    return deplacerpoint2(p1,p3)
		  case n2
		    return deplacerpoint2(p2,p3)
		  case -1
		    return deplacerpoint2(p,p3)
		  end select
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function trapupdate3(p0 as point, p1 as point, p2 as point) As Boolean
		  dim i,m, n0, n1, n2, n3 as integer
		  dim  p3, q as point
		  dim ff As  figure
		  
		  n0 = getindexpoint(p0)
		  n1 = getindexpoint(p1)
		  n2 = getindexpoint(p2)
		  //p0, p1 et p2 sont les trois points modifiés
		  
		  ff = getsousfigure(fig)
		  
		  if self isa trapiso and ff.NbSommSur(n0, n1, n2) > 0 then
		    if ff.replacerpoint(p0) or ff.replacerpoint(p1) or ff.replacerpoint(p2) then
		      return ff.autotrapupdate
		    else
		      return false
		    end if
		  end if
		  
		  n3 = quatriemepoint(n0,n1,n2)
		  p3 = points(n3)
		  q = fig.pointmobile
		  m = getindexpoint(q)
		  
		  select case m
		  case n0
		    return deplacerpoint2(p0,p3)
		  case n1
		    return deplacerpoint2(p1,p3)
		  case n2
		    return deplacerpoint2(p2,p3)
		  case -1
		    return deplacerpoint2(points((n3+1)mod 4), p3)
		  end select
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
		dist As double
	#tag EndProperty

	#tag Property, Flags = &h0
		Stab1 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		Stab2 As BasicPoint
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ArcAngle"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="area"
			Group="Behavior"
			Type="Integer"
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
			Name="Biface"
			Group="Behavior"
			Type="Boolean"
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
			Name="dist"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapori"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="Fleche"
			Group="Behavior"
			Type="Boolean"
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
			Name="narcs"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncpts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
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
			Name="Pointe"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="selected"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="signaire"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
