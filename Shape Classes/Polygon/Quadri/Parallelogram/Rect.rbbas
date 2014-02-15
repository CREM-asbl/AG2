#tag Class
Protected Class Rect
Inherits Parallelogram
	#tag Method, Flags = &h0
		Sub Rect(ol as objectslist, p as basicpoint)
		  Parallelogram(ol, p)
		  liberte = 5
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.value("Rect")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As shape
		  dim s as shape
		  
		  s = new Rect (Obl,self,p)
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Rect(ol as ObjectsList, Temp as XMLElement)
		  Polygon(ol,Temp)
		  liberte = 5
		  ncpts = 3
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndConstruction()
		  
		  
		  
		  'for i = 0 to 3
		  'for j =0 to ubound(points(i).parents)
		  's = points(i).parents(j)
		  'if s isa freecircle and s.points(0) = points(i) then
		  't = true
		  'i0 = i
		  's0 = s
		  'end if
		  'next
		  'next
		  '
		  'if t then
		  'j = 0
		  'for i = 0 to 3
		  'if i <> i0 and s0.getindexpointon(points(i)) <> -1 then
		  'j = j+1
		  'end if
		  'next
		  'end if
		  
		  super.EndConstruction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Ordonner(byref p as point, byref q as point, byref r as point, byref ep as BasicPoint, byref eq as BasicPoint, byref er as Basicpoint)
		  dim  n1, n2, n3 as integer
		  dim pp as point
		  dim epp as basicpoint
		  
		  super.ordonner(p,q,r)
		  n1 = getindexpoint(p)
		  n2 = getindexpoint(q)
		  n3 = getindexpoint(r)
		  
		  if n2 <> (n1+1) mod 4 then
		    
		    pp = p
		    p = q
		    q = r
		    r = pp
		    epp = ep
		    ep = eq
		    eq = er
		    er = epp
		    
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier1fixe(p as point, p1 as point) As Matrix
		  // Routine qui modifie le rectangle  dans le cas où le point p est laissé fixe, p1 est déplacé arbitrairement et  p2 s'adapte
		  // Deux cas possibles
		  
		  dim n, n1, n2, n3 as integer
		  dim  p2, p3 As  point
		  dim ep, np, ep1, np1, ep2, np2, ep3, np3 As Basicpoint
		  dim M as Matrix
		  dim ff as figure
		  dim d as double
		  
		  n = getindexpoint(p)
		  n1 = getindexpoint(p1)
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(p1,ep1,np1)
		  ff.getoldnewpos(p,ep,np)
		  d = amplitude(ep1, np, np1)
		  M = new rotationmatrix(np,d)
		  
		  if abs(n-n1) = 2 then
		    n2 = (n+1) mod 4
		    n3 = (n1+1) mod 4
		  else
		    'n3  = (n+2) mod 4
		    select case n1
		    case (n+1) mod 4
		      n2 = (n+3) mod 4
		    case (n+3) mod 4
		      n2 = (n+1) mod 4
		    end select
		  end if
		  p2 = points(n2)
		  p3 = points(n3)
		  ff.getoldnewpos(p2,ep2,np2)
		  ff.getoldnewpos(p3,ep3,np3)
		  if p2.pointsur.count = 1 and p2.pointsur.element(0) isa droite then
		    np2 = p1.bpt.projection(droite(p2.pointsur.element(0)).firstp, droite( p2.pointsur.element(0)).secondp)
		    return new AffinityMatrix(ep,ep1,ep2,np,np1,np2)
		  elseif p3.pointsur.count = 1 and p3.pointsur.element(0) isa droite then
		    np3 = p1.bpt.projection(droite(p3.pointsur.element(0)).firstp, droite(p3.pointsur.element(0)).secondp)
		    return new AffinityMatrix(ep,ep1,ep3,np,np1,np3)
		  else
		    np2 = M*ep2
		    if abs(n-n1) = 2 then
		      np2 = np.projection(np1,np2)
		    end if
		    return new AffinityMatrix(ep,ep1,ep2,np,np1,np2)
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2fixes(p as point) As Matrix
		  // Routine qui modifie le rectangle  dans le cas où deux points sont fixes et le point n peut  être déplacé (pas arbitrairement)
		  // Deux cas selon la position des points fixes
		  
		  dim k, n, n1, n2 as integer
		  dim p1, p2 as point
		  dim ep, np, np1, np2, u, v as BasicPoint
		  dim ff as figure
		  dim Bib1, Bib2 As  BiBPoint
		  dim d as double
		  
		  
		  
		  n = getindexpoint(p)
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(p,ep,np)
		  
		  p1 = point(ff.somm.element(ff.fx1))
		  p2 = point(ff.somm.element(ff.fx2))
		  n1 = getindexpoint(p1)
		  n2 = getindexpoint(p2)
		  np1 = p1.bpt
		  np2 = p2.bpt
		  
		  //1er cas p1 et p2 sont adjacents
		  
		  if n2 = (n1+1) mod 4 or n2 = (n1+3) mod 4 then
		    u = np1-np2
		    u = u.vecnorperp
		    select case n
		    case (n1+2)  mod 4
		      np = np.projection(np2, np2+u)
		    case (n2+2) mod 4
		      np = np.projection(np1, np1+u)
		    end select
		  else
		    u = (np1+np2)/2
		    d = np1.distance(np2)/2
		    np = np.projection(u,d)
		  end if
		  
		  p.moveto np
		  
		  return new AffinityMatrix(ep,np1,np2,np,np1,np2)
		  
		  
		  
		  
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
	#tag EndViewBehavior
End Class
#tag EndClass
