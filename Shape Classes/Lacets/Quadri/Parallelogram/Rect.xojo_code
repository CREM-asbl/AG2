#tag Class
Protected Class Rect
Inherits Parallelogram
	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, p as basicpoint)
		  shape.constructor(ol,3,4)
		  redim prol(-1)
		  redim prol(3)
		  liberte = 5
		  createskull(p)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, Temp as XMLElement)
		  Polygon.constructor(ol,Temp)
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
		Function GetType() As string
		  return Dico.value("Rect")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier1fixe(p as point, p1 as point) As Matrix
		  // Routine qui modifie le rectangle  dans le cas où on ne touche plus à p, p1 est déplacé arbitrairement et  p2 s'adapte
		  // Deux cas possibles
		  
		  dim n, n1, n2, n3 as integer
		  dim  p2, p3 As  point
		  dim ep, np, ep1, np1, ep2, np2, ep3, np3, w As Basicpoint
		  dim M as Matrix
		  dim ff as figure
		  dim d as double
		  dim s as shape
		  dim dr as droite
		  
		  ori = coord.orientation
		  n = getindexpoint(p) 'numero du point qui doit rester fixe
		  n1 = getindexpoint(p1)
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(p1,ep1,np1)
		  ff.getoldnewpos(p,ep,np)
		  if abs(n-n1) = 2 then
		    n2 = (n+1) mod 4
		    n3 = (n1+1) mod 4
		  else
		    select case n1
		    case (n+1) mod 4
		      n2 = (n+3) mod 4
		    case (n+3) mod 4
		      n2 = (n+1) mod 4
		    end select
		    n3 = (n+2) mod 4
		  end if
		  p2 = points(n2)
		  p3 = points(n3)
		  ff.getoldnewpos(p2,ep2,np2)
		  ff.getoldnewpos(p3,ep3,np3)
		  if p2.pointsur.count = 1 and not p2.pointsur.item(0) isa circle  then
		    s =  p2.pointsur.item(0)
		    dr = s.getside(p2.numside(0))
		    np2 = p.bpt.projection(dr.firstp, dr.secondp)
		    M = new AffinityMatrix(ep,ep1,ep2,np,np1,np2)
		    'p3.moveto np2+np1-np
		    'p3.modified = true
		  elseif p3.pointsur.count = 1 and not p3.pointsur.item(0) isa circle then
		    s =  p3.pointsur.item(0)
		    dr = s.getside(p3.numside(0))
		    np3 = p1.bpt.projection(dr.firstp, dr.secondp)
		    M = new AffinityMatrix(ep,ep1,ep3,np,np1,np3)
		    'p2.moveto np3+np-np1
		    'p3.modified = true
		  else
		    if abs(n-n1) <> 2 then
		      if n = (n1+1) mod 4 then
		        w = np - np1  
		      else
		        w = np1-np
		      end if
		      w = w.vecnorperp
		      d = ep1.distance(ep3)
		      np3 = np1+w*d*ori
		      M = new AffinityMatrix(ep,ep1,ep3,np,np1,np3)
		    else
		      M = new SimilarityMatrix(ep, ep1, np, np1)
		    end if
		  end if
		  return M
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2fixes(p as point) As Matrix
		  // Routine qui modifie le rectangle  dans le cas où deux points sont fixes et le point n peut  être déplacé (pas arbitrairement)
		  // Deux cas selon la position des points fixes
		  
		  dim  n as integer
		  dim p1, p2,  p0 as point
		  dim ep, np,  np1, np2,np0, u as BasicPoint
		  dim ff as figure
		  dim d as double
		  
		  
		  
		  n = getindexpoint(p)
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(p,ep,np)
		  
		  if not points((n+2) mod 4).modified then
		    p1 = points((n+1) mod 4)
		    p2 = points((n+3) mod 4)
		    np1 = p1.bpt
		    np2 = p2.bpt
		    u = (np1+np2)/2
		    d = np1.distance(np2)/2
		    np = np.projection(u,d)
		  else
		    p2 = points((n+2) mod 4)
		    
		    if points((n+1) mod 4).modified then
		      p1 = points((n+1) mod 4)
		      p0 = points((n+3) mod 4)
		    else
		      p1 = points((n+3) mod 4)
		      p0 = points((n+1) mod 4)
		    end if      // p,  p1 et p2 sont modifiés, p est adjacent à p1 et p2 est adjacent à p1
		    'ff.getoldnewpos(p1,ep1,np1)
		    'ff.getoldnewpos(p2,ep2,np2)
		    'ff.getoldnewpos(p3,ep3,np3)
		    np1 = p1.bpt
		    np2 = p2.bpt
		    np0 = p0.bpt
		    u = np1-np2
		    u = u.vecnorperp
		    np = np0.projection(np1, np1+u)
		  end if
		  
		  p.moveto np
		  
		  return new AffinityMatrix(ep,np1,np2,np,np1,np2)
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier3(p as point, q as point, r as point) As Matrix
		  dim  p1, p2, p3 As point 'Dans bcp de cas, p et q doivent rester fixes, r est modifiable
		  dim ep1,ep2,ep3,np1,np2,np3, u, v, pp as BasicPoint
		  dim ep, eq, er , np, nq, nr as BasicPoint
		  dim i, k, n, n1, n2, n3 as integer
		  dim t as boolean
		  dim ff as figure
		  dim Bib as BiBpoint
		  
		  dim dist as double
		  
		  ff= GetSousFigure(fig)
		  ff.getoldnewpos(p,ep,np)
		  ff.getoldnewpos(q,eq,nq)
		  ff.getoldnewpos(r,er,nr)
		  n =ff. NbSommSur
		  n1 = getindexpoint(p)
		  n2 = getindexpoint(q)
		  n3 = getindexpoint(r)
		  
		  select case n
		  case 0   'convient pour deux points fixes p et q et un point mobile r
		    if abs(n1-n2) = 1 then
		      u = np-nq
		      v = u.VecNorPerp
		      if abs(n1-n3) = 1 or abs(n1-n3) = 3 then 
		        nr = nr.projection(np,np+v)
		      else
		        nr = nr.projection(nq,nq+v)
		      end if
		      r.moveto nr
		    else
		      pp = (np+nq)/2
		      dist = pp.distance(np)
		      nr = nr.projection(pp,dist)
		    end if
		    return new AffinityMatrix(ep,eq,er,np,nq,nr)
		  case 1
		    p1 =point(ff.somm.item(ff.ListSommSur(0)))
		    'if p1 <> ff.supfig.pointmobile and not (p1.isextremityofarc(n, ar) and (n = 2) and (ar.fig = ff.supfig)) then
		    't =ff.replacerpoint(p1)
		    'else
		    n1 = getindexpoint(p1)
		    if n1 = getindexpoint(p) then
		      p2 = q
		      p3 = r
		    elseif n1 = getindexpoint(q) then
		      p2 = p
		      p3 =r
		    elseif n1 = getindexpoint(r) then
		      p2 = p
		      p3 = q
		    end if
		    n2 = getindexpoint(p2)
		    n3 = getindexpoint(p3)
		    ff.getoldnewpos(p1,ep1,np1)
		    ff.getoldnewpos(p2,ep2,np2)
		    ff.getoldnewpos(p3,ep3,np3)
		    
		    if abs(n2-n1) <> 2 then
		      u = np2-np1
		      v = u.vecnorperp
		      if abs(n1-n3) = 2 then
		        Bib = new BiBPoint(np2, np2+v)
		      else
		        BiB = new BiBPoint(np1,np1+v)
		      end if
		      np3 = np3.Projection(BiB)
		    else
		      u = np3-np1
		      v = u.vecnorperp
		      if abs(n1-n2) = 2 then
		        Bib = new BiBPoint(np3, np3+v)
		      else
		        BiB = new BiBPoint(np1,np1+v)
		      end if
		      np2 = np2.Projection(BiB)
		    end if
		    return new affinitymatrix(ep1,ep2,ep3,np1,np2,np3)
		    'end if
		  case 2
		    for i = 0 to 1
		      If point(ff.somm.item(ff.ListSommSur(i))) <> ff.supfig.pmobi Then
		        t =ff.replacerpoint (point(ff.somm.item(ff.Listsommsur(i))))
		      end if
		    next
		  case 3
		    p = ff.supfig.pmobi
		    k = ff.somm.getposition(p)
		    if ff.Listsommsur.indexof(k) <> -1 then
		      for i = 0 to 2
		        if i <> k then
		          t =ff.replacerpoint (point(ff.somm.item(ff.Listsommsur(i))))
		        end if
		      next
		    else
		      t = ff.replacerpoint (point(ff.somm.item(ff.Listsommsur(0))))
		      t = ff.replacerpoint (point(ff.somm.item(ff.Listsommsur(1))))
		    end if
		  end select
		  return ff.autospeupdate
		  
		End Function
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
		Function Paste(Obl as Objectslist, p as Basicpoint) As Rect
		  
		  return new Rect (Obl,self,p)
		  
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
