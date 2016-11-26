#tag Class
Protected Class TriangRect
Inherits Triangle
	#tag Method, Flags = &h0
		Sub Constructor(ol as Objectslist, p as BasicPoint)
		  shape.constructor(ol,3,3)
		  redim prol(-1)
		  redim prol(2)
		  liberte = 5
		  createskull(p)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, Temp as XMLElement)
		  Polygon.Constructor(ol,Temp)
		  liberte = 5
		  ncpts = 3
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  Return Dico.value("TriangRect")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier1fixe(p as point, p1 as point) As Matrix
		  // Routine qui modifie le triangle  dans le cas où le point p est laissé fixe, p1 est déplacé arbitrairement et  p2 s'adapte
		  // Six cas possibles
		  
		  dim i, k, n, n1, n2 as integer
		  dim  p2 As  point
		  dim ep, np, ep1, np1, ep2, np2, v, u(1), uu(-1) As Basicpoint
		  dim M as Matrix
		  dim ff as figure
		  dim d as double
		  dim bib1, Bib2 as Bibpoint
		  dim bq, w as basicpoint
		  
		  n = getindexpoint(p)
		  n1 = getindexpoint(p1)
		  for i = 0 to 2
		    if i <> n and i <> n1 then
		      n2 = i
		    end if
		  next
		  p2 = Points(n2)
		  
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(p,ep,np)
		  ff.getoldnewpos(p1,ep1,np1)
		  ff.getoldnewpos(p2,ep2,np2)
		  
		  select case n1
		  case 1
		    v = (ep-ep2)/2
		    d = v.norme
		    v = (ep+ep2)/2
		    np1 = np1.projection(v,d)
		    if not Points(1).unmodifiable then
		      Points(1).moveto np1
		    end if
		  case 0,2
		    M = new SimilarityMatrix(ep,ep1,np,np1)
		    if M <> nil and M.v1 <> nil then
		      np2 = M*ep2
		    end if
		  end select
		  
		  return new Affinitymatrix(ep,ep1,ep2,np,np1,np2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2fixes(p as point) As Matrix
		  // Routine qui modifie le triangle  dans le cas où le point n est seul à pouvoir être déplacé (pas arbitrairement)
		  // Trois cas possibles selon l'index de p
		  
		  dim k, n, n1, n2 as integer
		  dim p1, p2 as point
		  dim ep, np, np1, np2, u, v as BasicPoint
		  dim ff as figure
		  dim Bib1, Bib2 As  BiBPoint
		  dim d as double
		  
		  
		  
		  n = getindexpoint(p)
		  p1 = points((n+1) mod 3)
		  p2 = points((n+2) mod 3)
		  ff = getsousfigure(fig)
		  
		  ff.getoldnewpos(p,ep,np)
		  np1 = p1.bpt
		  np2 = p2.bpt
		  
		  select case n
		  case 0
		    u = np1-np2
		    u = u.vecnorperp
		    np = np.projection(np1, np1+u)
		  case 1
		    u = (np1+np2)/2
		    d = np1.distance(np2)/2
		    np = np.projection(u,d)
		  case 2
		    u = np1-np2
		    u = u.vecnorperp
		    np = np.projection(np2, np2+u)
		  end select
		  
		  p.moveto np
		  
		  return new AffinityMatrix(ep,np1,np2,np,np1,np2)
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As TriangRect
		  dim s as  new TriangRect(Obl,self,p)
		  return s
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
			Name="ArcAngle"
			Group="Behavior"
			Type="Double"
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
