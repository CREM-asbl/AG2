#tag Class
Protected Class AutoIntersec
Inherits Intersec
	#tag Method, Flags = &h0
		Function combien() As integer
		  dim i, j , n as integer
		  
		  n = 0
		  
		  for i = 0 to t
		    for j = i+1 to t
		      if val(i,j) and not bezet(i,j) then
		        n = n+1
		      end if
		    next j
		  next i
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeinterbpt()
		  dim i, j as integer
		  init
		  drappara = false
		  somevalidpoint = false
		  
		  computeinterlinesbpt
		  positionfalseinterpoints
		  for i = 0 to t
		    for j = i+1 to t
		      somevalidpoint = somevalidpoint or val(i,j)
		    next
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeinterlinesbpt()
		  dim i, j as integer
		  dim d1, d2 as BiBPoint
		  dim r1,r2 as double
		  
		  
		  for i = 0 to t
		    d1 = sbpt.getbibside(i)
		    for j = i+1 to t
		      'if (j <> i) and  (j <> ( (i+t-1) mod t )) and ( j<> ((i+1) mod t )) then
		      d2 = sbpt.getbibside(j)
		      bptinters(i,j) =  d1.BiBInterDroites(d2,2,2,r1,r2)
		      bptinters(j,i) = bptinters(i,j)
		      'end if
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  OpId = 45
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(sbpt as nBpoint)
		  
		  Super.Constructor
		  t = sbpt.taille -1
		  self.sbpt = sbpt
		  computeinterbpt
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(s as polygon)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  
		  Super.Constructor
		  
		  t = s.npts-1
		  self.s = s
		  sbpt = s.coord
		  
		  redim bptinters(t,t)
		  redim ids(t,t)
		  redim val(t,t)
		  redim pts(-1)
		  
		  computeinter
		  s.autointer = self
		  'if combien > 0 then
		  'CurrentContent.TheIntersecs.AddObject(self)
		  'end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreatePoints(s as polygon)
		  dim i, j as integer
		  
		  dim p as point
		  
		  for i = 0 to t
		    for j = i+1 to t
		      if  val(i,j) and  not bezet(i,j) and bptinters(i,j) <> nil  then
		        p = new point (objects,bptinters(i,j))
		        p.forme=2
		        p.setconstructedby s,45
		        p.numside.append i
		        p.numside.append j
		        p.location.append bptinters(i,j).location(sh1,i)
		        p.location.append bptinters(i,j).location(sh1,j)
		        'ids(i,j) =p.id
		        p.endconstruction
		        pts.append p
		      end if
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  'currentshape = sh1
		  'ComputeInter
		  'createpoints(sh1)
		  'polygon(sh1).autointer = self
		  'EndOperation
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub init()
		  dim i, j as integer
		  
		  
		  
		  redim bptinters(t,t)
		  redim val(t,t)
		  redim bezet(t,t)
		  
		  for i = 0 to t
		    for j = 0 to t
		      bptinters(i,j) = nil
		      val(i,j) = true
		      bezet(i,j) = false
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub positionfalseinterpoints()
		  //Les faux points d'intersection sont les  sommets de la forme dont on cherche les points d'Autointersection
		  // Ces places seront marquées bezet
		  
		  dim i,j, h as integer
		  dim p as basicpoint
		  
		  
		  for i = 0 to t
		    for j = 0 to t
		      for h = 0 to t
		        p = sbpt.tab(h)
		        if bptinters(i,j) <> nil and p.distance(bptinters(i,j)) < epsilon then
		          bezet(i,j) = true
		        end if
		      next
		    next
		  next
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		s As Polygon
	#tag EndProperty

	#tag Property, Flags = &h0
		sbpt As nbpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		t As integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="canceling"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsep"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drap"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drappara"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
			Group="Behavior"
			InitialValue="0"
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
			Name="info"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncol"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nlig"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ntsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="somevalidpoint"
			Group="Behavior"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="t"
			Group="Behavior"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
