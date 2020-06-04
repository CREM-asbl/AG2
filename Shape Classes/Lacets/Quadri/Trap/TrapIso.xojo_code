#tag Class
Protected Class TrapIso
Inherits Trap
	#tag Method, Flags = &h0
		Function check() As Boolean
		  dim t as Boolean
		  if invalid then
		    return true
		  end if
		  
		  t = super.check
		  return  t  and abs(   Points(3).distanceto(Points(0))  - Points(2).distanceto(Points(1)) ) < epsilon
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as Objectslist, p as BasicPoint)
		  super.constructor(ol,3,p)
		  Liberte = 6
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, Temp as XMLElement)
		  Polygon.constructor(ol,Temp)
		  liberte = 6
		  ncpts = 3
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function deplacerpoint1(p as point) As Boolean
		  // méthode utilisée dans le cas où trois points sont modifiés + le point mobile et où le symétrique de celui-ci est "sur"
		  // voir trapupdate4
		  
		  dim np0, np1, np2, np3, ep0, ep1, ep2, ep3 as Basicpoint
		  dim m, n as integer
		  dim ff as figure
		  dim p0, p1, p2, p3, q as point
		  dim M1 as Matrix
		  dim sh as shape
		  
		  n = getindexpoint(p)
		  select case n
		  case 0, 1
		    q = points(1-n)
		  case 2,3
		    q = points(5-n)
		  end select
		  
		  if deplacerpointsur2(p,q) then
		    return deplacerpoint2(q,p)
		  end if
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function deplacerpoint2(p as point, q as point) As Boolean
		  dim np0, np1, np2, np3, ep0, ep1, ep2, ep3 as Basicpoint
		  dim m, n as integer
		  dim ff as figure
		  dim p0, p1, p2, p3 as point
		  dim M1 as Matrix
		  
		  if q.pointsur.count = 1 then
		    return deplacerpointsur2(p,q)
		  end if
		  
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
		    return false
		  end if
		  
		  select case n+m
		  case 1
		    M1 = Symetrie (1)
		    if n = 0 then
		      q.moveto M1*np0
		    else
		      q.moveto M1*np1
		    end if
		  case 5
		    M1 = Symetrie(0)
		    if n = 2 then
		      q.moveto M1*np2
		    else
		      q.moveto M1*np3
		    end if
		  case 2
		    if n = 0 then
		      M1 = Symetrie(0)
		      q.moveto M1*np3
		    else
		      M1 = Symetrie(1)
		      q.moveto M1*np1
		    end if
		  case 4
		    if n = 1 then
		      M1 = Symetrie(0)
		      q.moveto M1*np2
		    else
		      M1 = Symetrie(1)
		      q.moveto M1*np0
		    end if
		  case 3
		    select case n
		    case 0
		      M1 = Symetrie(0)
		      q.moveto M1*np2
		    case 1
		      M1 = Symetrie(0)
		      q.moveto M1*np3
		    case 2
		      M1 = Symetrie(1)
		      q.moveto M1*np0
		    case 3
		      M1 = Symetrie(1)
		      q.moveto M1*np1
		    end select
		  end select
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.value("TrapIso")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function olddeplacerpointsur0(q as point) As Boolean
		  dim np0, np1, np2, np3,  bpt as Basicpoint
		  dim s as shape
		  dim Bib as BiBpoint
		  dim n as integer
		  dim p as point
		  
		  np0 = Points(0).bpt
		  np1 = points(1).bpt
		  np2 = Points(2).bpt
		  np3 = Points(3).bpt
		  
		  
		  
		  n = getindexpoint(q)
		  if n < 2 then
		    p = points(1-n)
		  else
		    p = points(5-n)
		  end if
		  
		  return deplacerpoint2(q,p)
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As TrapIso
		  return new TrapIso(Obl,self,p)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Symetrie(n as integer) As Matrix
		  dim u, v as basicpoint
		  
		  if n = 1 then
		    u = (points(2).bpt+points(3).bpt)/2
		    v = points(2).bpt-points(3).bpt
		    v = v.vecnorperp
		  elseif n = 0 then
		    u = (points(0).bpt+points(1).bpt)/2
		    v = points(0).bpt-points(1).bpt
		    v = v.vecnorperp
		  end if
		  return new SymmetryMatrix(u,u+v)
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
			Name="dist"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
