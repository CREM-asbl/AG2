#tag Class
Protected Class Circle
Inherits Shape
	#tag Method, Flags = &h0
		Function aire() As double
		  return PI*Pow(getradius,2)*ori
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Circle(bp1 as BasicPoint, bp2 as BasicPoint)
		  
		  Points.append new Point(bp1)
		  Points.append new Point(bp2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Circle(C as Circle, M as Matrix)
		  Shape(C, M)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Circle(ol as objectslist, s as circle, q as Basicpoint)
		  dim i as integer
		  dim M as Matrix
		  
		  M = new TranslationMatrix(q)
		  Shape(ol,s)
		  ori = s.ori
		  nsk = new Circleskull(wnd.mycanvas1.transform(Points(0).bpt))
		  Move(M)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeradius()
		  radius = points(0).bpt.distance(points(1).bpt)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBoundingRadius() As double
		  return GetRadius
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGravityCenter() As basicPoint
		  return Points(0).bpt
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
		Function pInShape(p as BasicPoint) As Boolean
		  return Points(0).bpt.Distance(p)<=GetRadius
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As Integer
		  if abs(p.distance(Points(0).bpt) - getradius)  < wnd.Mycanvas1.MagneticDist then
		    return 0
		  else
		    return -1
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
		  
		  UpDateSkull
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos as TextOutputStream)
		  dim i as integer
		  
		  if fill > 49 and not tsp then
		    if ti <> nil then
		      if ori = 1 then
		        tos.writeline ( "[  " + points(0).etiq + " " + str(radius)+ " ] disqueorientepos")
		      else
		        tos.writeline ( "[  " + points(0).etiq + " " + str(radius)+ " ] disqueorienteneg")
		      end if
		    else
		      tos.writeline ( "[  " + points(0).etiq + " " + str(radius)+ " ] disque")
		    end if
		  else
		    if ti <> nil  then
		      if ori = 1 then
		        tos.writeline ( "[  " + points(0).etiq +  " " + str(radius)+ " ] cercleorientepos")
		      else
		        tos.writeline ( "[  " + points(0).etiq + " " + str(radius)+ " ] cercleorienteneg")
		      end if
		    else
		      tos.writeline ( "[  " + points(0).etiq + " " + str(radius)+ " ] cercle")
		    end if
		  end if
		  
		  points(0).ToEps(tos)
		  'if self isa FreeCircleB then
		  'points(1).ToEPS(tos)
		  'end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateUserCoord(M as Matrix)
		  super.UpdateUserCoord(M)
		  radius = getradius*M.v1.x
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Circle(ol as ObjectsList, d as integer, p As BasicPoint)
		  Shape(ol,d)
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
		Sub CreateExtreAndCtrlPoints()
		  dim M as RotationMatrix
		  dim p, q as BasicPoint
		  dim bp1, bp2 as BasicPoint
		  dim BiB1, Bib2 as BiBPoint
		  dim r1,r2 as double
		  dim i as integer
		  
		  p = Points(0).bpt
		  M = new RotationMatrix(p,2*Pi/3)
		  
		  extre(0) = M*StartP
		  extre(1) = M*extre(0)
		  
		  bp1 = StartP-p
		  bp1 = bp1.vecnorperp
		  BiB1 = new BiBPoint(StartP, StartP+bp1)
		  bp2 = extre(0)-p
		  bp2 = bp2.VecNorPerp
		  BiB2 = new BiBPoint(extre(0), extre(0)+bp2)
		  q = BiB1.BiBInterDroites(BiB2,0,0,r1,r2)
		  
		  ctrl(0) = Startp*5/9+q*4/9        'Pour un cercle, a=2PI/3, k = 4/9
		  ctrl(1) = extre(0)*5/9 +q*4/9
		  for i = 2 to 5
		    ctrl(i) = M*ctrl(i-2)
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function fp() As BasicPoint
		  return points(0).bpt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StartP() As BasicPoint
		  return Points(1).bpt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateskull()
		  dim i, j as integer
		  dim p As BasicPoint
		  
		  p = points(0).bpt
		  
		  nsk.update(wnd.Mycanvas1.transform(p))
		  nsk.updatesommet(1,wnd.Mycanvas1.dtransform(points(1).bpt-p))
		  for i = 0 to 1
		    nsk.updateextre(i,  wnd.mycanvas1.dtransform(extre(i)-p))
		  next
		  for i = 0 to 5
		    nsk.updatectrl(i, wnd.mycanvas1.dtransform(ctrl(i)-p))
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveExtreCtrl(M as Matrix)
		  dim i as integer
		  
		  for i = 0 to 1
		    extre(i) = M*extre(i)
		  next
		  for i = 0 to 5
		    ctrl(i) = M*ctrl(i)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as Graphics)
		  dim i as integer
		  
		  
		  
		  if nsk= nil  or (points(0).bpt = nil) or  (not wnd.drapshowall and hidden) then
		    return
		  end if
		  
		  
		  updateskull
		  nsk.fixecouleurs(self)
		  nsk.fixeepaisseurs(self)
		  nsk.paint(self, g)
		  
		  if not hidden then
		    for i = 0 to labs.count-1
		      Labs.element(i).paint(g)
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics, c As couleur)
		  updateskull
		  nsk.updatebordercolor (c.col,100)
		  nsk.paint(self, g)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		angle As double
	#tag EndProperty

	#tag Property, Flags = &h0
		Radius As double
	#tag EndProperty

	#tag Property, Flags = &h0
		arcangle As double
	#tag EndProperty

	#tag Property, Flags = &h0
		extre(1) As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ctrl(5) As BasicPoint
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
			Name="Liberte"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="Invalid"
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
			Name="unmodifiable"
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
			Name="TracePt"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="IndexConstructedPoint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="colsw"
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
			Name="drapori"
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
			Name="plan"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="angle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Radius"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="arcangle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
