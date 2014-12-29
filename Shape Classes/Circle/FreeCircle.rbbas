#tag Class
Protected Class FreeCircle
Inherits Circle
	#tag Method, Flags = &h0
		Sub FreeCircle(ol As ObjectsList, p As BasicPoint)
		  Circle(ol,2,p)
		  Npts=2
		  Ori=1
		  createskull(p)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  
		  dim Form, temp As XMLElement
		  
		  
		  Form = Shape.XMLPutInContainer(Doc)
		  Form.SetAttribute("Angle", str(angle))
		  return form
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FreeCircle(ol as ObjectsList, El as XMLElement)
		  
		  Shape(ol,El)
		  ncpts=2
		  Angle=Val(El.GetAttribute("Angle"))
		  createskull(Points(0).bpt)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FreeCircle(ol as ObjectsList, p as Point, PtInCircle as Point)
		  dim i as integer
		  
		  Shape(ol,2,2)
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
		Sub FreeCircle(ol as ObjectsList)
		  FreeCircle(ol,new BasicPoint(0,0))
		  ncpts = 2
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPointOnCircle() As Point
		  return Points(1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsStandAlone() As Boolean
		  
		  dim i as Integer
		  
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
		Sub FreeCircle(other as FreeCircle, NewId as integer)
		  
		  objects = other.GetObjects
		  SetId(NewId)
		  FreeCircle(objects,new Point(Other.Points(0),objects.newId),new Point(Other.Points(1),objects.newId))
		  Ori=other.Ori
		End Sub
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
		Function Paste(Obl as ObjectsList, q as BasicPoint) As shape
		  dim  a, b as shape
		  dim j as integer
		  dim s as FreeCircle
		  
		  s = new FreeCircle(Obl,self,q)
		  s.ori = ori
		  return s
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FreeCircle(Ol as ObjectsList, s as Freecircle, p as BasicPoint)
		  Shape(ol,s)
		  ncpts=2
		  coord.CreateExtreAndCtrlPoints(ori)
		  createskull(p)
		  nsk.updatesize(1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updateskull()
		  radius=coord.distance01
		  if radius <> -1 then
		    super.updateskull
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as Graphics)
		  dim a,b,e as BasicPoint
		  dim can as mycanvas
		  
		  super.Paint(g)
		  
		  if not hidden and Ti <> nil and not dret isa rettimer then
		    can = wnd.mycanvas1
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
		Sub Fixecoord(p as BasicPoint, n as integer)
		  dim i as integer
		  
		  if n = 0 then
		    for i = 0 to 1
		      Points(i).MoveTo(p)
		    next
		  else
		    Points(1).moveto p
		    updatecoord
		    coord.CreateExtreAndCtrlPoints(ori)
		    updateskull
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitConstruction()
		  super.InitConstruction
		  coord.CreateExtreAndCtrlPoints(ori)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextBorderPoint(P as Point, p2 as point) As Point
		  return p2
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createskull(p as BasicPoint)
		  
		  nsk = new CircleSkull(p)
		  if ubound(points) > 0 then
		    computeradius
		    coord.CreateExtreAndCtrlPoints(ori)
		    updateskull
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos as TextOutputStream)
		  dim tsf as transformation
		  dim M as Matrix
		  dim s as Circle
		  dim p2, u as BasicPoint
		  dim r as double
		  
		  
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
		    
		    tos.writeline( "[  " + points(0).etiq + " "  + points(1).etiq + " [ " +  str(p2.x) + " " + str(p2.y) +"]  ] ellipse")
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isaellipse() As Boolean
		  return  (GetType = Dico.value("Ellipse"))
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
			Name="arcangle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Circle"
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
		#tag ViewProperty
			Name="angle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Circle"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Radius"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Circle"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
