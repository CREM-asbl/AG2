#tag Class
Protected Class AutoIntersec
Inherits Intersec
	#tag Method, Flags = &h0
		Function combien() As integer
		  Dim i, j , n As Integer
		  
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
		Sub computeinter()
		  
		  
		  Dim i, j As Integer
		  
		  
		  init
		  nlig = t
		  ncol = t
		  drappara = False
		  somevalidpoint = False
		  
		  computeinterlines
		  
		  For i = 0 To nlig
		    For j = 0 To ncol
		      somevalidpoint = somevalidpoint Or Val(i,j)
		    Next
		  Next
		  
		  If Not somevalidpoint Then
		    Return
		  Else
		    positionfalseinterpoints
		  End If  
		  
		  
		  
		  
		End Sub
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
		Sub computeinterlines()
		  Dim i, j,k As Integer
		  dim bp as basicpoint
		  dim d1, d2 as droite
		  dim r1,r2 as double
		  
		  
		  for i = 0 to nlig
		    d1 = sh1.getside(i)
		    for j = 0 to ncol
		      If j <> i Then 
		        bp = Nil
		        d2 = sh2.getside(j)
		        k = d1.inter(d2,bp,r1,r2)
		        if bp <> nil then
		          bptinters(i,j) = bp
		        end if
		        if k = 0 or r1 > 998 then
		          val(i,j) = false
		        End If
		      End If
		    Next
		    
		  Next
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
		      d2 = sbpt.getbibside(j)
		      bptinters(i,j) =  d1.BiBInterDroites(d2,2,2,r1,r2)
		      bptinters(j,i) = bptinters(i,j)
		      val(i,j) = (bptinters(i,j) <> nil)
		      val(j,i) = val(i,j)
		    next
		  next
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
		Sub Constructor(s1 as Shape)
		  
		  
		  
		  sh1 = polygon(s1)
		  
		  
		  
		  Super.Constructor(sh1,sh1)
		  
		  t = sh1.npts-1
		  
		  sbpt = sh1.coord
		  
		  'Redim bptinters(t,t)
		  'Redim ids(t,t)
		  'Redim Val(t,t)
		  'Redim pts(-1)
		  
		  DoOperation
		  polygon(sh1).autointer = Self
		  If combien > 0 Then
		    CurrentContent.TheIntersecs.AddObject(Self)
		  End If
		  
		  
		  polygon(s1).autointer.sh1 = polygon(s1)
		  polygon(s1).autointer.sh2 = polygon(s1)
		  
		  polygon(s1).autointer.DoOperation
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub constructor(EL as XMLElement, s as Polygon)
		  
		  
		  sh1 = polygon(s)
		  Super.Constructor(sh1,sh1)
		  t = sh1.npts-1
		  sbpt = sh1.coord
		  
		  Redim bptinters(t,t)
		  Redim ids(t,t)
		  Redim Val(t,t)
		  Redim pts(-1)
		  
		  'DoOperation
		  'polygon(sh1).autointer = Self
		  'If combien > 0 Then
		  'CurrentContent.TheIntersecs.AddObject(Self)
		  'End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreatePoints(s as polygon)
		  Dim i, j As Integer
		  
		  Dim p As point
		  
		  
		  For i = 0 To t 
		    bezet(i,i) = True
		    Val(i,i) = False
		  Next
		  
		  For i = 0 To t-1
		    bezet(i,i+1) = True
		    Val(i,i+1) = False
		  Next
		  bezet(t,0) = True
		  Val(t,0) = False
		  
		  for i = 0 to t
		    for j = i+1 to t
		      if  val(i,j) and  not bezet(i,j) and bptinters(i,j) <> nil  then
		        p = new point (objects,bptinters(i,j))
		        p.forme=2
		        p.setconstructedby s,45
		        p.constructedby.data.append i
		        p.constructedby.data.append j
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
		  'currentshape = polygon(sh1)
		  'sh2 = polygon(sh1)
		  'ComputeInter
		  'createpoints(Polygon(sh1))
		  'polygon(sh1).autointer = Self
		  'EndOperation
		  
		  sh1 = s
		  sh2 = sh1
		  t = sh1.npts
		  
		  Redim bezet(t,t)
		  Redim bptinters(t,t)
		  redim val (t,t)
		  
		  createpoints(polygon(sh1))
		  EndOperation
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  
		  CurrentContent.addoperation(self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub init()
		  Dim i, j As Integer
		  
		  If s <> Nil Then
		    t = s.npts-1
		  Elseif sh1 <> Nil Then
		    t = sh1.npts-1
		  End If
		  
		  Redim bptinters(t,t)
		  Redim Val(t,t)
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
		  
		  for i = 0  to t
		    bezet(i,i) = true
		  next
		  
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

	#tag Method, Flags = &h0
		Function ToXML(Doc As XMLDocument) As XMLElement
		  // Calling the overridden superclass method.
		  // Note that this may need modifications if there are multiple  choices.
		  // Possible calls:
		  // result1 as XMLElement = ToXML(Doc As XMLDocument) -- From SelectOperation
		  // result1 as XMLElement = ToXml(Doc as XMLDocument) -- From Operation
		  
		  Return s.XMLPutInContainer(Doc)
		  
		  
		  
		End Function
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
