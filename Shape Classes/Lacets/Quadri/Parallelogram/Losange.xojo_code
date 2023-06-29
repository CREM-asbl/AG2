#tag Class
Protected Class Losange
Inherits Parallelogram
	#tag Method, Flags = &h0
		Sub Constructor(ol as Objectslist, p as BasicPoint)
		  shape.constructor(ol,3,4)
		  redim prol(-1)
		  redim prol(3)
		  liberte = 5
		  createskull(p)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, Temp as XMLElement)
		  Polygon.Constructor(ol,Temp)
		  liberte = 5
		  ncpts=3
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  Return Dico.Value("Losange")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2fixes(p as point) As Matrix
		  // Routine qui modifie le losange  dans le cas où deux points sont fixes et le point n peut être déplacé (pas arbitrairement)
		  // Trois cas selon la position des points fixes
		  
		  dim  n0, n1, n2, n3 as integer
		  dim p1, p2 as point
		  dim ff as figure
		  dim pp(3) as point
		  dim M as Matrix
		  dim ep3, np3 as BasicPoint
		  
		  ff=GetSousFigure(fig)
		  
		  n0 = getindexpoint(p)
		  p1 = point(ff.somm.item(ff.fx1))
		  p2 = point(ff.somm.item(ff.fx2))
		  n1 = getindexpoint(p1)
		  n2 = getindexpoint(p2)
		  n3 = quatriemepoint(n0,n1,n2)
		  
		  if (n0+1) mod 4 <> n1 and (n0+1) mod 4 <> n2 then
		    pp(0) = p
		    pp(1) = points((n0+2) mod 4)
		    pp(2) = points((n0+3) mod 4)
		    M= ModifierTriIso2fixes(pp(), 2)
		    pp(3) = points((n0+1) mod 4)
		    ff.getoldnewpos(pp(3),ep3,np3)
		    pp(3).moveto ep3
		    return M
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
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Modifier2fixes(p as point, q as point)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier3(p as point, q as point, r as point) As Matrix
		  dim  ps, p2, p3 As point
		  dim eps,ep2,ep3,nps,np2,np3, u, v as BasicPoint
		  dim i, k, n, n1, n2, n3 as integer
		  dim t as boolean
		  dim ff as figure
		  dim Bib as BiBpoint
		  
		  ff = GetSousFigure(fig)
		  n = ff.NbSommSur
		  
		  select case n
		  case 0
		    If getindexpoint(ff.supfig.pmobi) <> -1 Then
		      Return Modifier2fixes(ff.supfig.pmobi)
		    elseif  ubound(p.parents) = 0 and p.constructedby = nil then
		      return Modifier2fixes(p)
		    elseif ubound(q.parents) = 0 and q.constructedby = nil then
		      return Modifier2fixes(q)
		    elseif ubound(r.parents) = 0 and r.constructedby = nil then
		      return Modifier2fixes(r)
		    else
		      return new Matrix(1)
		    end if
		    
		  case 1
		    ps = point(ff.somm.item(ff.ListSommSur(0)))
		    n1 = getindexpoint(ps)
		    n2 = (n1+2) mod 4
		    n3 = (n1+3) mod 4
		    p2 = points(n2)
		    p3 = points(n3)
		    ff.getoldnewpos(ps,eps,nps)
		    ff.getoldnewpos(p2,ep2,np2)
		    ff.getoldnewpos(p3,ep3,np3)
		    u = np3-np2
		    v = u.vecnorperp
		    Bib = new BiBPoint(np3, np3+v)
		    nps = np3.ProjectionAffine(BiB,ps.pointsur.item(0), ps.numside(0), nps)
		    ps.moveto nps
		    return new affinitymatrix(eps,ep2,ep3,nps,np2,np3)
		  case 2
		    'for i = 0 to 1
		    'If point(ff.somm.item(ff.ListSommSur(i))) <> ff.supfig.pmobi Then
		    't =ff.replacerpoint (point(ff.somm.item(ff.Listsommsur(i))))
		    'end if
		    'next
		    return new Matrix(1)
		  case 3
		    p = ff.supfig.pmobi
		    k = ff.somm.getposition(p)
		    if ff.Listsommsur.indexof(k) <> -1 then
		      for i = 0 to 2
		        if i <> k then
		          t = ff.replacerpoint(point(ff.somm.item(ff.Listsommsur(i))))
		        end if
		      next
		    else
		      t = ff.replacerpoint(point(ff.somm.item(ff.Listsommsur(0))))
		      t = ff.replacerpoint(point(ff.somm.item(ff.Listsommsur(1))))
		    end if
		  end select
		  return ff.autospeupdate
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As Losange
		  
		  return new Losange(Obl,self,p)
		  
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
