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
		  Dim i, j As Integer   'méthode valable uniquement pour autointersec
		  dim d1, d2 as BiBPoint
		  Dim r1,r2 As Double
		  Dim sbpt As nbPoint
		  
		  sbpt = sh1.coord
		  
		  For i = 0 To t-1
		    d1 = sbpt.getbibside(i)
		    For j = i+1 To t
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
		Sub Constructor(s as Shape)
		  
		  
		  Self.s = polygon(s)
		  sh1 = s
		  sh2 = sh1
		  Super.Constructor(sh1,sh1)
		  t = sh1.npts-1
		  DoOperation
		  polygon(sh1).autointer = Self
		  If combien > 0 Then
		    CurrentContent.TheIntersecs.AddObject(Self)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub constructor(Temp as XMLElement)
		  Dim EL, ELL As XMLElement
		  dim n as integer
		  
		  Super.constructor
		  
		  n = CDbl(Temp.GetAttribute("Id"))
		  
		  If n = 0 Then
		    EL = XMLElement(Temp.Child(0))
		    ELL = XMLElement( EL.Child(0))
		    n = CDbl(ELL.GetAttribute("Id"))
		  End If
		  
		  s =  Polygon(Objects.GetShape(n))
		  sh1 = polygon(s)
		  sh2 = polygon(s)
		  Super.Constructor(sh1,sh1)
		  t = sh1.npts-1
		  sbpt = sh1.coord
		  Redim bptinters(t,t)
		  Redim ids(t,t)
		  Redim Val(t,t)
		  Redim pts(-1)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreatePoints(s as polygon)
		  Dim i, j As Integer
		  Dim p As point
		  
		  
		  computeinterlinesbpt
		  For i = 0 To t 
		    bezet(i,i) = True
		    Val(i,i) = True
		    bezet(i, (i+1) Mod t) = True
		    Val(i, (i+1) Mod t) = False
		  Next
		  
		  For i = 0 To t-1
		    For j = i+2 To t
		      If Not ( (i = 0) And (j = t)) Then
		        if  val(i,j) and  not bezet(i,j) and bptinters(i,j) <> nil  then
		          p = new point (objects,bptinters(i,j))
		          p.forme=2
		          p.setconstructedby s,45
		          p.constructedby.data.append i
		          p.constructedby.data.append j
		          'p.numside.append i
		          'p.numside.append j
		          p.location.append bptinters(i,j).location(sh1,i)
		          p.location.append bptinters(i,j).location(sh1,j)
		          p.endconstruction
		          pts.append p
		        End If
		      End If 
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  
		  
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
		    sh1 = s
		    sh2 = s
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
		Sub RedoOperation(Temp as XMLElement)
		  'Temp est le XMLElement de nom "Operation"
		  
		  Dim f, i, j, n As Integer
		  
		  Dim EL , ELL As XMLElement
		  Dim Pt As Point
		  
		  If Temp.GetAttribute("OpId") <> "45" Then
		    Return
		  End If
		  
		  EL = XMLElement(Temp.child(0))   'EL est le XMLElement de nom "intersection"
		  ELL= XMLElement(EL.Child(1))       'ELL devient la liste des points d'autointer du polygone s
		  For i = 0 To ELL.Childcount -1              'On recrée ces points   
		    Pt = Point(s.XMLReadPoint(XMLElement(ELL.Child(i))))
		    Pt.XMLReadConstructionInfo(XMLELement(ELL.Child(i)))
		    Pt.AddToCurrentContent
		    s.autointer.pts.append Pt
		  Next
		  
		  ReDeleteDeletedFigures(Temp)
		  ReCreateCreatedFigures(Temp)
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc As XMLDocument) As XMLElement
		  Dim EL, Temp As XMLElement
		  Dim i As Integer
		  
		  Temp = Doc.CreateElement(GetName)
		  Temp.appendchild s.XMLPutIdInContainer(Doc)
		  EL = Doc.CreateElement(Dico.Value("Pts"))
		  For i = 0 to ubound(pts)
		    EL.AppendChild pts(i).XMLPutINContainer(Doc)
		  Next
		  Temp.appendchild EL
		  Return temp
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  
		  Dim i As Integer
		  Dim EL , ELL As XMLElement
		  Dim Pt As point
		  
		  EL = XMLElement(Temp.Child(0))
		  EL = XMLElement(Temp.child(0))   'EL est le XMLElement de nom "intersection"
		  ELL= XMLElement(EL.Child(1))       'ELL devient la liste des points d'autointer du polygone s
		  For i = 0 To ELL.Childcount -1              'On recrée ces points   
		    Pt = Point(s.XMLReadPoint(XMLElement(ELL.Child(i))))
		    Pt.delete
		  Next
		  ReDeleteCreatedFigures (Temp)
		  ReCreateDeletedFigures(Temp)
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
