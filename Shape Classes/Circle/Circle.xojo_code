#tag Class
Protected Class Circle
Inherits Shape
	#tag Method, Flags = &h0
		Function aire() As double
		  dim r as double
		  dim tsf as transformation
		  
		  if constructedby <> nil and constructedby.oper = 6 then
		    tsf = transformation(constructedby.data(0))
		    return constructedby.shape.aire * tsf.M.det
		  else
		    r = getradius
		    if r = -1 then
		      return -10000
		    else
		      return PI*Pow(r,2)*ori
		    end if
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeradius()
		  if ubound(points) > 0 then
		    radius = coord.distance01
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(bp1 as BasicPoint, bp2 as BasicPoint)
		  
		  Points.append new Point(bp1)
		  Points.append new Point(bp2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(C as Circle, M as Matrix)
		  Shape.Constructor(C, M)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, d as integer, p As BasicPoint)
		  Shape.Constructor(ol,d,d)
		  Points.append new Point(ol, p)
		  SetPoint(Points(0))
		  angle = 0
		  arcangle = 2*PI
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fixeepaisseurs()
		  
		  nsk.fixeepaisseurs(self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function fp() As BasicPoint
		  return points(0).bpt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBoundingRadius() As double
		  return GetRadius
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGravityCenter() As BasicPoint
		  return coord.tab(0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRadius() As double
		  computeradius
		  return radius
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Inter(c as circle, byref intersec() as basicPoint) As integer
		  dim B1, B2 as BiBPoint
		  dim i as integer
		  dim n as integer
		  dim bq, w as basicpoint
		  redim intersec(-1)
		  
		  B1 = new BibPoint (c.GetGravityCenter, c.GetGravityCenter+ new BasicPoint(0,c.GetRadius))
		  B2 = new BibPoint (GetGravityCenter, GetGravityCenter+ new BasicPoint(0,GetRadius))
		  
		  n = B1.BiBInterCercles(B2,intersec(),bq,w)
		  
		  return n
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsSame(s as Shape) As boolean
		  if s isa Circle and GC = s.GC and Radius = Circle(s).Radius then
		    return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextBorderPoint(P as Point, p2 as point) As Point
		  return p2
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as Graphics)
		  dim i as integer
		  dim b as Boolean
		  
		  b = (dret <> nil) and ( (dret isa RetTimer) or ((dret isa TsfTimer) and ((TsfTimer(dret).type = 6) or  TsfTimer(dret).type = 9 or TsfTimer(dret).type =11)) )
		  if not b and not isaellipse then
		    coord.CreateExtreAndCtrlPoints(ori)
		  end if
		  nsk.update(self)
		  
		  if (nsk= nil ) or ( nsk.item(0).x = 0 and nsk.item(0).y = 0)  or (points(0).bpt = nil) or  (not wnd.drapshowall and hidden) then
		    return
		  end if
		  
		  nsk.fixecouleurs(self)
		  nsk.fixeepaisseurs(self)
		  nsk.paint(g)
		  
		  if not hidden then
		    for i = 0 to labs.count-1
		      Labs.item(i).paint(g)
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics, c As couleur)
		  
		  nsk.updatebordercolor (c.col,100)
		  nsk.paint(g)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(p as BasicPoint) As Boolean
		  return Points(0).bpt.Distance(p)<=GetRadius
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As Integer
		  dim d as double
		  
		  d =  p.distance(points(0).bpt)
		  
		  if d <= GetRadius + epsilon and abs(radius -d)  <  can.MagneticDist then
		    return  0
		  else
		    return  -1
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetRadius(r as double)
		  dim v as BasicPoint
		  
		  v = Points(1).bpt-Points(0).bpt
		  v = v.normer
		  v =v*r
		  Points(1).moveto Points(0).bpt+v
		  
		  radius = r
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StartP() As BasicPoint
		  return Points(1).bpt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos as TextOutputStream)
		  dim i as integer
		  dim s as string
		  
		  s = "[  " + points(0).etiquet + " " + "[ " +points(0).etiquet+ " " +  points(1).etiquet +" ] distance ]  "
		  
		  if fill > 49 and not tsp then
		    if ti <> nil then
		      if ori = 1 then
		        tos.writeline ( s +"disqueorientepos")
		      else
		        tos.writeline ( s +"disqueorienteneg")
		      end if
		    else
		      tos.writeline (s +"disque")
		    end if
		  else
		    if ti <> nil  then
		      if ori = 1 then
		        tos.writeline ( s +"cercleorientepos")
		      else
		        tos.writeline ( s+"cercleorienteneg")
		      end if
		    else
		      tos.writeline ( s+"cercle")
		    end if
		  end if
		  
		  points(0).ToEps(tos)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdatePtsConsted()
		  dim i as integer
		  dim p as point
		  dim TriB as TriBPoint
		  dim fp, sp as point
		  
		  
		  
		  for i = 0 to ubound(constructedshapes)
		    if constructedshapes(i).constructedby.oper = 4 then
		      p = point(constructedshapes(i))
		      fp = point(p.constructedby.data(0))
		      sp = point(p.constructedby.data(1))
		      Trib = new TriBpoint(getgravitycenter,fp.bpt,sp.bpt)
		      p.moveto Trib.subdiv(ori,p.constructedby.data(2),p.constructedby.data(3))
		      p.modified = true
		      p.updateshape
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateUserCoord(M as Matrix)
		  super.UpdateUserCoord(M)
		  radius = getradius*M.v1.x
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		angle As double
	#tag EndProperty

	#tag Property, Flags = &h0
		Radius As double
	#tag EndProperty


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
