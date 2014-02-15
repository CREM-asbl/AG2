#tag Class
Protected Class Parallelogram
Inherits Quadri
	#tag Method, Flags = &h0
		Sub Parallelogram(ol as objectslist, p as BasicPoint)
		  Quadri(ol, 3, p)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  Return Dico.Value("Parallelogram")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As shape
		  dim s as shape
		  s = new Parallelogram(Obl,self,p)
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Parallelogram(ol as ObjectsList, Temp as XMLElement)
		  Polygon(ol,Temp)
		  ncpts = 3
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier1fixe(p as point, p1 as point) As Matrix
		  // Routine qui modifie le losange  dans le cas où le point p est laissé fixe, p1 est déplacé arbitrairement et  p2 s'adapte
		  
		  
		  dim i, n, n1, n2 as integer
		  dim  p2 As  point
		  dim ep, np, ep1, np1, ep2, np2, ep3, np3, u As Basicpoint
		  dim M as Matrix
		  dim ff as figure
		  dim d as double
		  
		  dim pp(2) As point
		  
		  n = getindexpoint(p)
		  n1 = getindexpoint(p1)
		  
		  pp(0) = p
		  
		  if abs (n-n1) = 2 then
		    pp(1) = p1
		    pp(2) = points((n1+1) mod 4)
		    return ModifierTriIso1fixe(pp(),0,1)
		  else
		    pp(1) = points((n+2) mod 4)
		    pp(2) = p1
		    return ModifierTriIso1fixe(pp(),0,2)
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2fixes(p as point) As Matrix
		  // Routine qui modifie le losange  dans le cas où deux points sont fixes et le point n peut  être déplacé (pas arbitrairement)
		  // Trois cas selon la position des points fixes
		  
		  dim  n0, n1, n2 as integer
		  dim p1, p2 as point
		  dim ff as figure
		  dim pp(2) as point
		  
		  ff=GetSousFigure(fig)
		  
		  n0 = getindexpoint(p)
		  p1 = point(ff.somm.element(ff.fx1))
		  p2 = point(ff.somm.element(ff.fx2))
		  n1 = getindexpoint(p1)
		  n2 = getindexpoint(p2)
		  
		  if (n0+1) mod 4 <> n1 and (n0+1) mod 4 <> n2 then
		    pp(0) = p
		    pp(1) = points((n0+2) mod 4)
		    pp(2) = points((n0+3) mod 4)
		    return ModifierTriIso2fixes(pp(), 2)
		  elseif (n0+3) mod 4 <> n1 and (n0+3) mod 4 <> n2 then
		    pp(0) = p
		    pp(1) = points((n0+1) mod 4)
		    pp(2) = points((n0+2) mod 4)
		    return ModifierTriIso2fixes(pp(), 1)
		  else
		    pp(0) = p
		    pp(1) = points((n0+1) mod 4)
		    pp(2) = points((n0+3) mod 4)
		    return ModifierTriIso2fixes(pp(),0)
		  end if
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  'case (n1+2)  mod 4
		  'Bib1 = new BiBPoint(np2,np)
		  'Bib2 = new BibPoint(np2,np1)
		  'case (n2+2) mod 4
		  'Bib1 = new BiBPoint(np1,np)
		  'Bib2 = new BibPoint(np1,np2)
		  'end select
		  'k = Bib1.BiBDroiteIntercercle(Bib2,u(),bq,w)
		  'if k <> 0 then
		  'if np.distance(u(1)) < np.distance(u(0)) then
		  'u(0) = u(1)
		  'end if
		  'np = u(0)
		  'end if
		  'else
		  'u(0) = (np1+np2)/2
		  'u(1) = np1-np2
		  'u(1) = u(1).vecnorperp
		  'np = np.projection(u(0),u(0)+u(1))
		  '
		  'p.moveto np
		  'return new AffinityMatrix(ep,np1,np2,np,np1,np2)
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
