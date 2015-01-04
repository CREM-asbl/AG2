#tag Class
Protected Class BasicPoint
Implements StringProvider
	#tag Method, Flags = &h0
		Sub BasicPoint(pX as Double, pY as Double)
		  x=pX
		  y=pY
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BasicPoint(P as Point)
		  x=P.Bpt.x
		  y=P.Bpt.y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Basicpoint(P as BasicPoint)
		  x=P.x
		  y=P.y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Add(v as basicpoint) As basicpoint
		  return new basicpoint (x+v.x,y+v.y)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Multiply(v as basicpoint) As double
		  return x*v.x + y*v.y
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function norme() As double
		  return sqrt(x*x+y*y)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function normer() As basicpoint
		  dim r as double
		  r= norme
		  if r > Epsilon  then
		    return new basicpoint (x/r,y/r)
		  else
		    return self
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Subtract(u as basicpoint) As basicpoint
		  return new basicpoint (x-u.x,y-u.y)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Multiply(r as double) As basicpoint
		  return new basicpoint(x*r,y*r)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Distance(a as BasicPoint) As double
		  dim b as BasicPoint
		  
		  b = self-a
		  return b.norme
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Distance(u as BasicPoint, v As BasicPoint) As double
		  dim  q as basicpoint
		  
		  if u.Distance(v) = 0 then 'cas où u et v confondus => distance à un seul point
		    return distance(u)
		  else
		    q = projection(u,v)
		    return distance(q)
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Divide(r as double) As basicpoint
		  return new BasicPoint (x/r,y/r)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Sqrdistance(q As basicpoint) As double
		  return (self-q)*(self-q)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VecNorPerp() As basicpoint
		  
		  dim v as BasicPoint
		  
		  if x =0 and y = 0 then
		    return new BasicPoint(0,0)
		  end if
		  
		  v = new BasicPoint(-y,x)
		  return v.normer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Projection(a as basicpoint, b as basicpoint) As basicpoint
		  // projection sur un segment
		  
		  dim M as Matrix
		  
		  M=new OrthoProjectionMatrix(a,b)
		  if M <> nil and M.v1 <> nil then
		    return M*self
		  else
		    return self
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Vect(bp As BasicPoint) As double
		  return x*bp.y-y*bp.x
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Between(a as BasicPoint, b as BasicPoint) As Boolean
		  dim r as double
		  
		  r = location(a,b)
		  return (r>= 0) and (r<=1)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Rotation(angle as double, c as basicpoint) As basicpoint
		  dim M as Rotationmatrix
		  
		  M = new RotationMatrix (c, angle)
		  
		  if (c <> self) and Angle<>0 then
		    return M*self
		  end if
		  
		  return self
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Location(a as BasicPoint, b as BasicPoint) As double
		  dim r,d as double
		  
		  d = b.sqrdistance(a)
		  r = ((b-a)*(self-a))/d
		  return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Anglepolaire() As double
		  dim a as double
		  
		  a = atan2(y,x)
		  if a >= 0 then
		    return a
		  else
		    return a+2*PI
		  end if
		  
		  // Les  angles polaires sont toujours entre 0 et 2 pi
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AuDela(a as BasicPoint, b as BasicPoint) As Boolean
		  dim r as double
		  
		  r = location(a,b)
		  return (r>= 0)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim sk as oldcircleskull
		  
		  sk = new oldcircleskull(1,wnd.Mycanvas1.transform(self))
		  sk.updatefillcolor(bleu,100)
		  sk.updatebordercolor(bleu,100)
		  sk.paint(g)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Orientation(q1 as basicPoint, q2 as BasicPoint) As double
		  dim v1 , v2 as basicPoint
		  
		  v1 = q1 -self
		  v2 = q2 - self
		  
		  return sign(v1.vect(v2))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ismidof(d as bibpoint) As boolean
		  dim r as double
		  
		  r = Location(d.first, d.second)
		  
		  if (abs(r-0.5) < Epsilon) then
		    Return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function location(c as circle) As double
		  dim a,b as BasicPoint
		  dim alpha as double
		  
		  if c isa StdCircle then
		    b = new BasicPoint(c.Radius,0)
		  else
		    b = c.Points(1).bpt-c.getgravitycenter
		  end if
		  a = self- c.getgravitycenter
		  alpha = a.anglepolaire-b.Anglepolaire
		  if c.ori = -1 then
		    alpha = -alpha
		  end if
		  if alpha < 0 then
		    alpha = alpha + 2*Pi
		  end if
		  return  alpha/(2*PI)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function alignes(u2 as Basicpoint, u3 as basicpoint) As boolean
		  dim u1 as BasicPoint
		  dim w1,w2  as basicpoint
		  dim r as double
		  
		  u1 = self
		  
		  w1 = u2-u1
		  w2 = u3-u1
		  
		  
		  return  w1.norme < epsilon or w2.norme < epsilon or abs(w1.vect(w2)) < epsilon *(w1.norme*w2.norme)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function projection(p as basicpoint, r as double) As basicpoint
		  // projection sur un Cercle
		  
		  dim q as basicpoint
		  
		  if distance(p) > Epsilon then
		    q = p + (self -p)*(r/distance(p))
		    return q
		  else
		    return self
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function insidescreen() As Boolean
		  dim csg, cig, csd, cid as BasicPoint
		  wnd.mycanvas1.coins(csg,csd,cig,cid)
		  if x > cig.x and x < cid.x and y > cig.y and y < csg.y then
		    return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function location(d as shape, k as integer) As double
		  dim a, b as BasicPoint
		  dim Bib as BiBPoint
		  dim Ag as angle
		  
		  if d isa droite then
		    a =  droite(d).firstp
		    b =  droite(d).secondp
		  elseif d isa bande then
		    a = d.points(k).bpt
		    if k = 0 then
		      b = d.points(1).bpt
		    else
		      b = bande(d).point3
		    end if
		  elseif d isa secteur then
		    a = d.points(0).bpt
		    b = d.points(k+1).bpt
		  elseif d isa polygon then
		    a = d.points(k).bpt
		    b = d.points((k+1) mod d.npts).bpt
		  end if
		  
		  if d isa droite or d isa bande or d isa secteur or d isa polygon  then
		    return location(a,b)
		  elseif d isa circle then
		    return location(circle(d))
		  elseif d isa lacet then
		    a = d.points(k).bpt
		    b = d.points((k+1) mod d.npts).bpt
		    if lacet(d).coord.curved(k)=0 then
		      return location(a,b)
		    else
		      Bib = new BiBPoint(d.points(k).bpt,self)
		      Ag = new Angle(Bib, lacet(d).coord.centres(k),d.ori)
		      return (Ag.alpha/Lacet(d).GetArcAngle(k))
		    end if
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DemiPlanDroit(D as BiBpoint) As Boolean
		  dim Bib as BiBPoint
		  dim u,v,w,q as BasicPoint
		  dim r1, r2 as double
		  
		  v = D.vecnorperp
		  u = D.Second
		  w = u+v    //w est toujours dans le demi-plan de gauche par rapport à D
		  
		  Bib = new BibPoint(self,w)
		  q = Bib.BibInterdroites(D, 2, 0,r1,r2)
		  
		  Return q <> nil    //si true, self est dans le demi-plan de droite
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Location(Bib as BiBPoint) As double
		  dim r,d as double
		  
		  d = Bib.second.sqrdistance(Bib.first)
		  r = ((Bib.second-Bib.First)*(self-Bib.First))/d
		  return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function distance(Bib as BiBPoint) As double
		  dim  q as basicpoint
		  
		  q = projection(Bib.first,bib.second)
		  return distance(q)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As String
		  return "("+str(x)+","+str(y)+")"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function location(bip as biPoint) As double
		  dim Bib as BiBPoint
		  
		  Bib = new BiBPoint(bip.firstp, bip.secondp)
		  return location(Bib)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  
		  dim temp as XMLElement
		  Temp = Doc.CreateElement("Coord")
		  Temp.SetAttribute("X", str(x))
		  Temp.SetAttribute("Y", str(y))
		  return temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function projection(Bib as BiBPoint) As basicpoint
		  return projection(BiB.first, Bib.Second)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BasicPoint(EL as XMLElement)
		  x = val(EL.GetAttribute("X"))
		  y = val(EL.GetAttribute("Y"))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(p as basicpoint)
		  x = p.x
		  y = p.y
		End Sub
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
		x As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		y As Double
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
			Name="x"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="y"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
