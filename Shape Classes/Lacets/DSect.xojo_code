#tag Class
Protected Class DSect
Inherits Lacet
	#tag Method, Flags = &h0
		Function computeangle(q as Basicpoint) As double
		  
		  return coord.computeangle(q,ori)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeArcAngle()
		  startangle = coord.startangle    
		  endangle = coord.endangle    
		  // startangle et endangle  sont toujours entre 0 et 2 pi
		  if not drapori then
		    ori = coord.orientation                         'points(0).bpt.orientation(points(1).bpt,points(2).bpt)
		  end if
		  if  abs(endangle-startangle)  >  0.4 and ori <> 0 then
		    drapori = true  //on ne peut plus changer l'orientation
		  end if
		  
		  arcangle = computeangle(points(2).bpt)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeori()
		  updatecoord
		  if not drapori then
		    ori = coord.orientation
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeradius()
		  if ubound(points) > 0 then
		    radius = GetRadius(1)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist,  p as BasicPoint)
		  
		  super.constructor(ol, 3, p)
		  fam = 5
		  forme = 2
		  auto = 3
		  narcs = 1
		  liberte = 5
		  ori = 1
		  CreateSkull(p)
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub constructor(ol as objectslist, s as DSect, q as BasicPoint)
		  
		  
		  
		  super.constructor(ol,s,q)
		  Ori=s.Ori
		  liberte = s.liberte
		  radius = s.radius
		  arcangle = s.arcangle
		  drapori = s.drapori
		  coord.CreateExtreAndCtrlPoints(ori)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub constructor(ol as ObjectsList, Temp as XMLElement)
		  super.constructor(ol, Temp)
		  coord.CreateExtreAndCtrlPoints(ori)
		  createskull(points(0).bpt)
		  InitCurvesOrders
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndConstruction()
		  'updateshape
		  computearcangle
		  super.endconstruction
		  'coord.centres(1) = coord.tab(0)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as BasicPoint, n as integer)
		  dim i as integer
		  
		  for i = n to 2
		    Points(i).moveto(p)
		  next
		  
		  updatecoord
		  if n > 0 then
		    coord.CreateExtreAndCtrlPoints(ori)
		  end if
		  select case n
		  case 0
		    arcangle = 0
		    coord.centres(1) = p
		  case 1
		    computeori
		    coord.CreateExtreAndCtrlPoints(ori)
		    computeradius
		    startangle = coord.startangle         'GetAngle(Points(0).bpt, Points(1).bpt)
		  case 2
		    constructshape
		    updatecoord
		    coord.CreateExtreAndCtrlPoints(ori)
		  end select
		  
		  
		  
		  Lskull(nsk).item(n).border = 100
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGravityCenter() As BasicPoint
		  dim g as BasicPoint
		  
		  g = coord.tab(0)+coord.tab(1)+coord.tab(2)
		  return g/3
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRadius() As double
		  computeradius
		  return radius
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetType() As string
		  return Dico.value("DSect")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitConstruction()
		  super.InitConstruction
		  coord.curved(1)=1
		  coord.centres(1) = coord.tab(0)
		  InitCurvesOrders
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Inside(p as basicPoint) As Boolean
		  dim a as double
		  computearcangle
		  a = computeangle(p)
		  return abs(a) <= abs(arcangle)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as ObjectsList, p as BasicPoint) As DSect
		  
		  return  new DSect(Obl, DSect(self),p)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(p as basicPoint) As Boolean
		  
		  radius = getRadius(1)
		  if  Points(0).bpt.Distance(p) >  Radius + can.MagneticDist  then
		    return False
		  end if
		  
		  return Inside(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEps(tos as TextOutputStream)
		  dim s as string
		  dim r as double
		  dim i as integer
		  
		  tos.writeline "newpath"
		  s= "[ [ "+points(1).etiquet + "  " + points(0).etiquet  + " " + points(2).etiquet + " ] "
		  r = points(0).bpt.distance(points(1).bpt)
		  r = r*ori
		  s = s +  str(r) +"]"
		  tos.writeline s + "arcsecteur secteurdisque"
		  
		  
		  
		  for i = 0 to 2
		    points(i).ToEPS(tos)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateShape()
		  dim i,j as integer
		  dim s,t as shape
		  dim b as Boolean
		  
		  coord.centres(1) = coord.tab(0)
		  Super.UpdateShape
		  computearcangle
		  
		  for i = 0 to Ubound(ConstructedShapes)   'Pourquoi pas "updateconstructedshapes ?
		    s = ConstructedShapes(i)
		    if s isa droite then
		      s.updateshape
		      for j = 0 to ubound(s.constructedshapes)
		        t = s.constructedshapes(j)
		        if t.constructedby.oper = 1 or t.constructedby.oper = 2 then
		          t.updateshape
		        end if
		      next
		    end if
		  next
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		endangle As double
	#tag EndProperty

	#tag Property, Flags = &h0
		ep0 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ep1 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ep2 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ff As figure
	#tag EndProperty

	#tag Property, Flags = &h0
		np0 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		np1 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		np2 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		radius As double
	#tag EndProperty

	#tag Property, Flags = &h0
		startangle As double
	#tag EndProperty


	#tag ViewBehavior
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
			Name="endangle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
			InitialValue="0"
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
			Name="radius"
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
			Name="startangle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
