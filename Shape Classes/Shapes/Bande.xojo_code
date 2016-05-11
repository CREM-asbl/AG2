#tag Class
Protected Class Bande
Inherits Shape
	#tag CompatibilityFlags = ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub computeextre()
		  dim p1,p2,q1,q2 as basicPoint
		  dim D1 as BiBPoint
		  dim mi, ma as double
		  
		  p1 = Points(0).bpt
		  p2 = Points(1).bpt
		  q1 = Points(2).bpt
		  q2 = q1+p2-p1
		  
		  if p1.distance(p2) < epsilon  then
		    extre(0)= p1
		    extre(1)= p2
		    extre(2) = q1
		    extre(3) = q2
		  else
		    D1 = new BiBPoint(p1,p2)
		    D1.Interscreen(mi,ma)
		    extre(0) = D1.BptOnBiBpt(mi-0.1)
		    extre(1) = D1.BptOnBiBpt(ma+0.1)
		    D1 = new BiBPoint(q1,q2)
		    D1.Interscreen(mi,ma)
		    extre(3) = D1.BptOnBiBpt(mi-0.1)
		    extre(2) = D1.BptOnBiBpt(ma+0.2)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(B as Bande, M as Matrix)
		  Super.constructor(B, M)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(obl as objectslist, s as bande, p as basicpoint)
		  dim M as Matrix
		  
		  super.constructor(obl,s)
		  ncpts = 3
		  
		  M = new TranslationMatrix(p)
		  nsk = new Lskull(can.transform(s.Points(0).bpt))
		  computeextre
		  Move(M)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, p as BasicPoint)
		  
		  super.constructor(ol,3,3)
		  Points.append new Point(ol, p)
		  SetPoint(Points(0))
		  nsk = new Lskull(can.transform(Points(0).bpt))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as Objectslist, temp as XMLElement)
		  super.constructor(ol,Temp)
		  npts = 3
		  ncpts = 3
		  nsk = new Lskull(can.transform(Points(0).bpt))
		  computeextre
		  Updateskull
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as BasicPoint, n as integer)
		  dim i as integer
		  
		  
		  select case n
		  case 0
		    for i = 0 to 2
		      Points(i).moveto(p)
		    next
		    'sk.update(can.transform(p))
		  case 1
		    Points(1).moveto(p)
		    Lskull(nsk).Updatesommet(1,can.dtransform(p-Points(0).bpt))
		    Points(2).moveto(p)
		  case 2
		    Points(2).moveto(p)
		    constructshape
		  end select
		  computeextre
		  'updateskull
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBibSide(i as integer) As BiBPoint
		  dim BiB as BiBPoint
		  
		  if i = 0 then
		    BiB = new BiBPoint(coord.tab(0), coord.tab(1))
		  else
		    BiB = new BiBPoint(coord.tab(2),Point3)
		  end if
		  BiB.nextre = 0
		  return Bib
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGravitycenter() As BasicPoint
		  return (Points(2).bpt+ Points(1).bpt)/2
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSide(n as integer) As Droite
		  dim d as Droite
		  dim p as point
		  
		  
		  if n = 0 then
		    d = new Droite(Points(0),Points(1))
		  else
		    p = new point(point3)
		    d = new Droite(Points(2),p)
		  end if
		  d.nextre = 0
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.Value("Bande")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as Graphics)
		  dim op as operation
		  dim i, n as integer
		  
		  computeextre
		  updateskull
		  n = -1
		  op =CurrentContent.currentoperation
		  
		  if op <> nil and op.nobj > 0 and op.visible.item(op.iobj) = self then
		    if op isa transfoconstruction or op isa  paraperpconstruction then
		      n = op.index(op.iobj)
		    end if
		  end if
		  
		  if highlighted and n > -1  then
		    for i = 0 to 1
		      if i <> n then
		        paintside (g, i, 1, bordercolor)
		      else
		        paintside (g, n, 2, Config.highlightcolor)
		      end if
		    next
		  else
		    super.paint(g)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paintside(g as graphics, cot as integer, ep as double, coul as couleur)
		  dim cs as curveshape
		  
		  cs = Lskull(nsk).item(2*cot)
		  cs.borderwidth = ep*borderwidth
		  cs.bordercolor = coul.col
		  g.drawobject(cs, nsk.x, nsk.y)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as objectslist, p as basicpoint) As shape
		  dim s, a, b as shape
		  dim j as integer
		  
		  s = new Bande(Obl,self,p)
		  
		  for j = 3 to Ubound(childs)
		    a = childs(j)
		    b = Point(a.Paste(Obl,p,s))
		  next
		  
		  
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(p as BasicPoint) As Boolean
		  dim d1, d2, d3 as double
		  
		  d1 = p.distance(Points(0).bpt, Points(1).bpt)
		  d2= p.distance(Points(2).bpt, point3)
		  
		  d3= Points(2).bpt.distance(Points(0).bpt, Points(1).bpt)
		  return abs(d1+d2-d3) < epsilon
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Point3() As basicpoint
		  
		  return Points(2).bpt+ Points(1).bpt-Points(0).bpt
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As integer
		  dim  imin as integer
		  dim distmin, dist as double
		  
		  distmin = p.distance(Points(0).bpt,Points(1).bpt)
		  imin = 0
		  dist = p.distance(Points(2).bpt,point3)
		  if dist < distmin then
		    distmin = dist
		    imin = 1
		  end if
		  if distmin < can.MagneticDist  then
		    return imin
		  else
		    return -1
		  end if
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos as TextOutputstream)
		  dim i as integer
		  dim p3 as BasicPoint
		  dim s1, s2 as string
		  
		  p3 = Point3
		  if fill < 50 then
		    if not hidden then
		      tos.writeline ( "[ " + Points(0).etiquet+" "+ Points(1).etiquet+ " ]  droite" )
		      tos.writeline ( "[ " + Points(2).etiquet+" [ " + str(p3.x) + " " + str(p3.y) + " ]  ]  droite" )
		    end if
		  else
		    tos.writeline( str(fill/100) + " .setopacityalpha")
		    s1 = "[ " + Points(0).etiquet+" "+ Points(1).etiquet+ " ]  droiteintercadre decoupler "
		    s2 = "[ " + Points(2).etiquet+" [ " + str(p3.x) + " " + str(p3.y) + " ]  ]  droiteintercadre  decoupler exch " 
		    tos.writeline ("[ " + s1 + s2 +"]" + " polygonerempli")
		  end if
		  for i = 0 to 2
		    points(i).toeps(tos)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateShape()
		  dim i,j as integer
		  dim s,t as shape
		  
		  
		  ConstructShape
		  Shape.UpdateShape
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateskull()
		  dim i as integer
		  
		  'for i=0 to 3
		  'if i=0 then
		  'sk.update(can.transform(extre(0)))
		  'else
		  'figskull(sk).Updatesommet(i,can.dtransform(extre(i)-extre(0)))
		  'end
		  'next
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = Licence
		
		Copyright © Mars 2010 CREM
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
		extre(3) As BasicPoint
	#tag EndProperty


	#tag ViewBehavior
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
			Name="Hybrid"
			Group="Behavior"
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
