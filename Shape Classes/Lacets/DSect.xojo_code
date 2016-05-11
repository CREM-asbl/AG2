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
		  startangle = coord.startangle    'GetAngle(Points(0).bpt, Points(1).bpt)
		  endangle = coord.endangle     'GetAngle(Points(0).bpt, Points(2).bpt)
		  // startangle et endangle  sont toujours entre 0 et 2 pi
		  if  abs(endangle-startangle)  >  0.2 then
		    drapori = true  //on ne peut plus changer l'orientation
		  end if
		  if not drapori then
		    ori = coord.orientation                         'points(0).bpt.orientation(points(1).bpt,points(2).bpt)
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
		  
		  super.constructor(ol,p)
		  ncpts = 3
		  npts = 3
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
		  
		  dim M as Matrix
		  
		  Shape.constructor(ol,s)
		  Ori=s.Ori
		  liberte = s.liberte
		  M = new TranslationMatrix(q)
		  radius = s.radius
		  arcangle = s.arcangle
		  drapori = s.drapori
		  narcs = 1
		  coord.centres(1) = s.coord.centres(1)
		  coord.CreateExtreAndCtrlPoints(ori)
		  updateskull
		  Move(M)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub constructor(ol as ObjectsList, Temp as XMLElement)
		  super.constructor(ol, Temp)
		  coord.CreateExtreAndCtrlPoints(ori)
		  createskull(points(0).bpt)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createskull(p as BasicPoint)
		  dim i as integer
		  
		  nsk = new LSkull(5, p)
		  nsk.item(0).order = 0
		  for i = 1 to 3
		    nsk.item(i).order = 2
		  next
		  nsk.item(4).order = 0
		  
		  nsk.skullof = self
		  
		  '
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndConstruction()
		  updateshape
		  super.endconstruction
		  coord.centres(1) = coord.tab(0)
		  
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
		  'coord.CreateExtreAndCtrlPoints(ori)
		  'updateskull
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Inside(p as basicPoint) As Boolean
		  dim a as double
		  a = computeangle(p)
		  return abs(a) <= abs(arcangle)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier1(n as integer) As Matrix
		  dim  m as integer
		  dim ff as Figure
		  
		  ff = fig.supfig
		  
		  
		  m = ff.NbSommsur(n)
		  
		  
		  select case m
		  case 0
		    return Modifier10(n)
		  case 1
		    return Modifier11(n)
		  case 2
		    return Modifier12(n)
		  end select
		  
		  //Les deux derniers cas ne peuvent normalement pas se présenter (il y aurait plus d'un point modifié)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier10(n as integer) As Matrix
		  ''Le point n° n est le seul point modifié. Il y a 0 points "sur"
		  dim  r as double
		  
		  'select case n
		  'case 0, 1
		  'return new SimilarityMatrix(ep0,ep1,np0,np1)
		  'case 2
		  'r = getradius(1)
		  'points(2).moveto np2.projection(np0,r)
		  'return new AffinityMatrix(ep0,ep1,ep2,np0,np1,points(2).bpt)
		  'end select
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier11(n as integer) As Matrix
		  'Le point n° n est le seul point modifié. Il y a 1 point "sur" différent n° n. Ce point n'a pas été modifié, plus précisément il a éte "replacé".
		  'La méthode succède à Modifier2.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier12(n as integer) As Matrix
		  'Le point n° n est le seul point modifié. Il y a deux points "sur" différent n° n. Ces points ont éte "replacés".
		  'La méthode succède à Modifier3.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as ObjectsList, p as BasicPoint) As DSect
		  
		  return  new DSect(Obl,self,p)
		  
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
		Sub UpdateShape()
		  dim i,j as integer
		  dim s,t as shape
		  dim b as Boolean
		  
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
		arcangle As double
	#tag EndProperty

	#tag Property, Flags = &h0
		endangle As double
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
			Type="double"
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
