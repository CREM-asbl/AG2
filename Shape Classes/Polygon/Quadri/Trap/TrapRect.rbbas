#tag Class
Protected Class TrapRect
Inherits Trap
	#tag Method, Flags = &h0
		Sub TrapRect(ol as objectslist, p as basicPoint)
		  Quadri(ol,3,p)
		  liberte = 6
		  ori = 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.Value("TrapRect")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As shape
		  dim s as shape
		  
		  s = new TrapRect(Obl,self,p)
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TrapRect(ol as objectslist, Temp as XMLElement)
		  Polygon(ol,Temp)
		  liberte = 6
		  ncpts=3
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function check() As Boolean
		  dim t as Boolean
		  dim u,v as BasicPoint
		  
		  if invalid then
		    return true
		  end if
		  
		  t = super.check
		  u = Points(0).bpt-Points(1).bpt
		  u = u.normer
		  
		  v = Points(0).bpt-Points(3).bpt
		  v = v.normer
		  
		  return  t and abs(u*v) < epsilon
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function trapupdate1(pp as point) As boolean
		  dim u, v, epi, npi as Basicpoint
		  dim Bib1, Bib2 as BiBpoint
		  dim m, m1, m2, n, k, i as integer
		  dim ff as figure
		  dim d as double
		  dim Mat as Matrix
		  
		  
		  ff = getsousfigure(fig)
		  
		  for i = 0 to 3
		    p(i) = points(i)
		    ff.getoldnewpos(p(i),epi,npi)
		    ep(i) = epi
		    np(i) = npi
		  Next
		  
		  n = getindexpoint(pp)  // pp est le point modifié
		  
		  
		  select case ff.NbUnModif
		  case 0, 1
		    m = getindexpoint(point(ff.somm.element(ff.PointsFixes(0))))
		    if m = (n+2) mod 4 then
		      if n = 0 or n = 2 then
		        return deplacersim(0,2,3,1)
		      else
		        return deplacersim(3,1,0,2)
		      end if
		    else
		      Mat = new SimilarityMatrix(ep(n), ep(m), np(n), np(m))
		      Transform(Mat)
		      return true
		    end if
		  case 2
		    m1 = getindexpoint(point(ff.somm.element(ff.PointsFixes(0))))
		    m2 = getindexpoint(point(ff.somm.element(ff.PointsFixes(1))))
		    return deplacer2fixes(n,m1,m2)
		  case 3
		    return false
		  end select
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function trapupdate2(p1 as point, p2 as point) As boolean
		  dim ff as figure
		  dim n, m, n1, n2, i as integer
		  dim epi, npi as BasicPoint
		  dim pp as point
		  dim Mat as Matrix
		  
		  ff = getsousfigure(fig)
		  
		  for i = 0 to 3
		    p(i) = points(i)
		    ff.getoldnewpos(p(i),epi,npi)
		    ep(i) = epi
		    np(i) = npi
		  Next
		  
		  //p1 et p2 sont les deux points modifiés
		  
		  n1 = getindexpoint(p1)
		  n2 = getindexpoint(p2)
		  pp = ff.supfig.pointmobile
		  n = getindexpoint(pp)
		  
		  if n <> n1 and n <> n2 then
		    return deplacer2modifs(n1,n2)
		  end if
		  
		  if n = n1 then
		    m = n2
		  else
		    m = n1
		  end if
		  
		  if m = (n+2) mod 4 then
		    if n = 0 or n = 2 then
		      return deplacersim(0,2,3,1)
		    else
		      return deplacersim(3,1,0,2)
		    end if
		  else
		    Mat = new SimilarityMatrix(ep(n), ep(m), np(n), np(m))
		    Transform(Mat)
		    return true
		  end if
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function trapupdate3(p0 as point, p1 as point, p2 as point) As boolean
		  dim i,m, m1, m2, n0, n1, n2, n3 as integer
		  dim  p3, pp as point
		  dim ff as figure
		  dim u, epi, npi As BasicPoint
		  
		  ff = getsousfigure(fig)
		  
		  for i = 0 to 3
		    p(i) = points(i)
		    ff.getoldnewpos(p(i),epi,npi)
		    ep(i) = epi
		    np(i) = npi
		  Next
		  n0 = getindexpoint(p0)
		  n1 = getindexpoint(p1)
		  n2 = getindexpoint(p2)
		  n3 = quatriemepoint(n0,n1,n2)
		  //p0, p1 et p2 sont les trois points modifiés
		  
		  pp = fig.pointmobile
		  m = getindexpoint(pp)
		  
		  if m<> -1 then
		    select case m
		    case n0
		      return deplacer2fixes(m,n1,n2)
		    case n1
		      return deplacer2fixes(m,n0,n2)
		    case n2
		      return deplacer2fixes(m,n0,n1)
		    end select
		  end if
		  
		  //si le point mobile n'appartient pas au trapèze
		  // p(n3) n'est pas un mpoint sur (il serait modifié)
		  
		  select case n3
		  case 0
		    u = np(3)-np(2)
		    p(0).moveto np(3).projection (np(1), np(1)+u)
		    return true
		  case 1
		    if fairesuivresur(2,3,0) then
		      Return fairesuivre(3,0,1)
		    else
		      return check
		    end if
		  case 2
		    if fairesuivresur(1,0,3) then
		      return fairesuivre(0,3,2)
		    else
		      return check
		    end if
		  case 3
		    u = np(0)-np(1)
		    p(3).moveto np(0).projection (np(2), np(2)+u)
		    return true
		  end select
		  return check
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function fairesuivre(n1 as integer, n2 as integer, n3 as integer) As boolean
		  dim Bib1, Bib2 as Bibpoint
		  dim u as BasicPoint
		  
		  u = np(n2)-np(n1)
		  u = u.vecnorperp
		  Bib1 = new Bibpoint(np(n2), np(n2)+u)
		  if ep(n3).distance(ep(n2)) > epsilon  then
		    Bib2 = new Bibpoint(np(n2), np(n2)+ep(n3)-ep(n2))
		    return fininterbib(Bib1, Bib2, p(n3))
		  else
		    return true
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function fairesuivresur(n1 as integer, n2 as integer, n3 as integer) As Boolean
		  dim n as integer
		  dim Bib1, Bib2 as Bibpoint
		  dim ff as figure
		  dim  p1, p2, p3 as point
		  dim  np1, np2, np3,  ep1, ep2, ep3 as Basicpoint
		  dim u, v as BasicPoint
		  dim sh as shape
		  
		  if p(n3).pointsur.count = 0 then
		    return fairesuivre(n1,n2,n3)
		  end if
		  
		  sh = p(n3).pointsur.element(0)
		  
		  if sh.pointonside(ep(n2)) = 1 then
		    v = ep(n3)
		  else
		    u = np(n2)-np(n1)
		    u = u.vecnorperp
		    Bib1 = new Bibpoint(np(n2), np(n2)+u)
		    v = Bib1.ComputeDroiteFirstIntersect(sh,p(n3))
		  end if
		  if v <> nil then
		    p(n3).moveto v
		    return true
		  else
		    return false
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function deplacersim(n1 as integer, n2 as integer, n3 as integer, n4 as integer) As boolean
		  // n1, n2 sont les numéros de deux points modifiés. n1 est sommet d'angle droit, n2 sommet opposé à n1
		  //n3 et n4 sont les deux autres sommets, n3 deuxième sommet d'angle droit, n4 sommet opposé à n3
		  
		  dim Mat as Matrix
		  
		  Mat = new SimilarityMatrix(ep(n1),ep(n2),np(n1),np(n2))
		  p(n3).moveto Mat*p(n3).bpt
		  return fairesuivre(n3,n1,n4)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function deplacer2fixes(n as integer, m1 as integer, m2 as integer) As boolean
		  // Les points m1 et m2 sont fixes
		  // On tire sur le point n
		  
		  dim u, v as Basicpoint
		  dim d as double
		  dim Mat as Matrix
		  dim m, k, h as integer
		  
		  select case n
		  case 0, 3
		    m = 3-n
		    select case m1+m2
		    case 3
		      if n = 0 then
		        h = 1
		        k = 2
		      elseif n = 3 then
		        h = 2
		        k = 1
		      end if
		      if fairesuivre(h,n,m) then
		        np(m) = p(m).bpt
		        if np(n).distance(np(m)) > epsilon then
		          p(m).moveto np(k).projection(np(n),np(m))
		        end if
		      end if
		    else
		      if (m1+m2 = 2) or (m1+m2=4) then
		        u = (np(m1)+np(m2))/2
		        d = u.distance(np(m1))
		        np(n) = np(n).projection(u,d)
		      elseif (m1+m2 = 1) or (m1+m2=5) then
		        m = 3-n
		        u = np(m1)-np(m2)
		        v = u.vecnorperp
		        np(n) = np(n).projection(np(m),np(m)+v)
		        p(n).moveto ep(n)
		      end if
		      p(n).moveto ep(n)
		      p(n).modified = false
		      Mat = new AffinityMatrix(ep(n),ep(m1),ep(m2),np(n),np(m1),np(m2))
		      Transform(Mat)
		    end select
		  case 1, 2
		    select case m1+m2
		    case 2, 3, 4
		      if n = 1 then
		        m = 0
		      else
		        m=3
		      end if
		      p(n).moveto np(n).projection(ep(m),ep(n))
		    case 1
		      p(3).moveto np(2).projection(ep(0),ep(3))
		    case 5
		      p(0).moveto np(1).projection(ep(0),ep(3))
		    end select
		  end select
		  
		  return check
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function deplacer2modifs(m1 as integer, m2 as integer) As boolean
		  // Les points m1 et m2 sont modifies
		  // Le point mobile n'appartient pas au trapèze
		  
		  dim u, v as Basicpoint
		  dim d as double
		  dim Mat as Matrix
		  dim m, k, h as integer
		  
		  
		  select case m1+m2
		  case 1
		    if fairesuivre(1,0,3) then
		      return fairesuivre  (0,3,2)
		    end if
		  case 2
		    Mat = new Similaritymatrix(ep(0),ep(2),np(0),np(2))
		    Transform(Mat)
		    return  true
		  case 3
		    if m1 = 0 or m1 = 3 then
		      Mat = new Similaritymatrix(ep(0),ep(3),np(0),np(3))
		      Transform(Mat)
		      return true
		    else
		      p(0).moveto np(1).projection(ep(0),ep(3))
		      p(3).moveto np(2).projection(ep(0),ep(3))
		      return true
		    end if
		  case 4
		    Mat =new Similaritymatrix(ep(1),ep(3),np(1),np(3))
		    Transform(Mat)
		    return true
		  case 5
		    if fairesuivre(2,3,0) then
		      return fairesuivre  (3,0,1)
		    end if
		  end select
		  
		  return check
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
		p(3) As point
	#tag EndProperty

	#tag Property, Flags = &h0
		ep(3) As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		np(3) As BasicPoint
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
			Name="dist"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Trap"
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
