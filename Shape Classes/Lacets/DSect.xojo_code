#tag Class
Protected Class DSect
Inherits Lacet
	#tag Method, Flags = &h0
		Function airealge() As double
		  return coord.airealgeDSect
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function airearith() As double
		  return abs(airealge)
		End Function
	#tag EndMethod

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
		  
		  arcangle = computeangle(1,points(2).bpt)
		  
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
		  super.constructor(ol,3, p)
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
		  drapori = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape()
		  super.ConstructShape
		  computeradius
		  computearcangle
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndConstruction()
		  
		  computearcangle
		  super.endconstruction
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as BasicPoint, n as integer)
		  dim i as integer
		  
		  for i = n to 2
		    Points(i).moveto(p)
		  next
		  
		  updatecoord
		  
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
		  
		  return  new DSect(Obl, self ,p)
		  
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
		  dim i as integer
		  dim tbp as tribpoint
		  dim q as BasicPoint
		  dim s as string
		  
		  tbp =  new TriBPoint(coord.tab(0), coord.tab(1), coord.tab(2))
		  q = tbp.subdiv(ori,2,1)
		  tos.writeline "/milieuarc  [ " + str(q.x) + " " + str(q.y) +" ] store"
		  
		  
		  s= "[ "  +points(2).etiquet + "  " + points(0).etiquet  + " " + points(1).etiquet + " [ " + points(1).etiquet + " milieuarc "+ points(2).etiquet  +" ] ]"
		  
		  if fill > 50 then
		    tos.writeline s + "lacetrempli"
		  else
		    tos.writeline s + "lacet"
		  end if
		  
		  
		  
		  
		  
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
		  computearcangle
		  Super.UpdateShape
		  
		  for i = 0 to Ubound(ConstructedShapes) 
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
			Visible=false
			Group="Behavior"
			InitialValue="0"
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
			Name="endangle"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
			Name="radius"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
			Name="startangle"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
