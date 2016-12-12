#tag Class
Protected Class FreeCircle
Inherits Circle
	#tag Method, Flags = &h0
		Sub Constructor(other as FreeCircle, NewId as integer)
		  
		  objects = other.GetObjects
		  SetId(NewId)
		  Constructor(objects,new Point(Other.Points(0),objects.newId),new Point(Other.Points(1),objects.newId))
		  Ori=other.Ori
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList)
		  Constructor(ol,new BasicPoint(0,0))
		  ncpts = 2
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol As ObjectsList, p As BasicPoint)
		  Super.Constructor(ol,2,p)
		  
		  Ori=1
		  createskull(p)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Ol as ObjectsList, s as Freecircle, p as BasicPoint)
		  Shape.Constructor(ol,s)
		  ncpts=2
		  createskull(p)
		  nsk.updatesize(1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, p as Point, PtInCircle as Point)
		  dim i as integer
		  
		  Shape.Constructor(ol,2,2)
		  Points.append p
		  Points.append  PtInCircle
		  fam = 5
		  forme = 0
		  for i =0 to 1
		    setpoint(Points(i))
		  next
		  
		  Npts=2
		  Ori=1
		  createskull(p.bpt)
		  nsk.updatefillcolor(Config.Fillcolor.col,0)
		  endconstruction
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, El as XMLElement)
		  
		  Shape.Constructor(ol,El)
		  ncpts=2
		  Angle=Val(El.GetAttribute("Angle"))
		  createskull(Points(0).bpt)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createskull(p as BasicPoint)
		  
		  nsk = new ArcSkull(p)
		  if ubound(points) > 0 then
		    computeradius
		  end if
		  nsk.skullof = self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as BasicPoint, n as integer)
		  dim i as integer
		  
		  if n = 0 then
		    for i = 0 to 1
		      Points(i).MoveTo(p)
		    next
		    
		  else
		    Points(1).moveto p
		    updatecoord
		    coord.centres(0) = points(0).bpt
		    coord.curved(0) = 1
		    coord.CreateExtreAndCtrlPoints(ori)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPointOnCircle() As Point
		  return Points(1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  if constructedby <> nil and constructedby.oper = 6 and ((transformation(constructedby.data(0)).type = 9) or (transformation(constructedby.data(0)).type = 11 )) then
		    return Dico.value("Ellipse")
		  else
		    return Dico.value("FreeCircle")
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitConstruction()
		  super.InitConstruction
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isaellipse() As Boolean
		  return  (GetType = Dico.value("Ellipse"))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsStandAlone() As Boolean
		  
		  
		  
		  if Ubound(ConstructedShapes)<>-1 then
		    return false
		  end if
		  If GC.ConstructedBy<>nil or Points(1).ConstructedBy<>nil then
		    return false
		  end if
		  if Ubound(GC.ConstructedShapes)>0 or  Ubound(Points(1).ConstructedShapes)>0 then
		    return false
		  end if
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextBorderPoint(P as Point, p2 as point) As Point
		  return p2
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as Graphics)
		  dim a,b,e as BasicPoint
		  
		  
		  
		  super.Paint(g)
		  
		  if not Isinconstruction and  not hidden and Ti <> nil and not dret isa rettimer then
		    b = points(0).bpt * 2 - points(1).bpt
		    e = b - points(0).bpt
		    e = (e.vecnorperp)*ori
		    e = e*0.1
		    a = can.transform(b-e)
		    b = can.transform(b)
		    Ti.updatetip(a,b,bordercolor)
		    Ti.scale = 0.5
		    g.DrawObject Ti, b.x, b.y
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as ObjectsList, q as BasicPoint) As shape
		  
		  dim i as integer
		  dim s as FreeCircle
		  
		  s = new FreeCircle(Obl,self,q)
		  for i = 0 to 1
		    s.coord.extre(i) = coord.extre(i)
		  next
		  for i = 0 to 5
		    s.coord.ctrl(i) = coord.ctrl(i)
		  next
		  s.ori = ori
		  return s
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos as TextOutputStream)
		  
		  dim M as Matrix
		  dim s as Circle
		  dim p2, u as BasicPoint
		  dim r as double
		  dim i as integer
		  
		  
		  if not isaellipse then
		    super.ToEps(tos)
		  else
		    s = circle(constructedby.shape)
		    r = s.getradius
		    u = s.coord.tab(1) - s.coord.tab(0)
		    u = u.vecnorperp
		    p2 = s.coord.tab(0) + u*r
		    M = transformation(constructedby.data(0)).M
		    p2 = M*p2
		    
		    tos.writeline( "[  " + points(0).etiquet + " "  + points(1).etiquet + " [ " +  str(p2.x) + " " + str(p2.y) +"]  ] ellipse")
		  end if
		  for i = 0 to ubound(childs)
		    childs(i).ToEPS(tos)
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  
		  dim Form As XMLElement
		  
		  
		  Form = Shape.XMLPutInContainer(Doc)
		  Form.SetAttribute("Angle", str(angle))
		  return form
		  
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
			Name="angle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="arcangle"
			Group="Behavior"
			InitialValue="0"
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
			Name="Radius"
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
