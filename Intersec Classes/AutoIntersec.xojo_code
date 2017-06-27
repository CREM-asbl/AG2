#tag Class
Protected Class AutoIntersec
Inherits Intersec
	#tag Method, Flags = &h0
		Function combien() As integer
		  dim i, j , n as integer
		  
		  n = 0
		  
		  for i = 0 to nlig - 2
		    for j = i+1 to ncol -1
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
		  dim i, j as integer
		  init
		  drappara = false
		  somevalidpoint = false
		  computeinterlines
		  
		  for i = 0 to nlig
		    for j = i to ncol
		      somevalidpoint = somevalidpoint or val(i,j)
		    next
		  next
		  
		  if not somevalidpoint then
		    return
		  else
		    positionfalseinterpoints
		  end if  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeinterlines()
		  dim i, j,k as integer
		  dim bp as basicpoint
		  dim d1, d2 as droite
		  dim r1,r2 as double
		  
		  
		  for i = 0 to nlig
		    d1 = sh1.getside(i)
		    for j = i+1 to nlig
		      d2 = sh2.getside(j)
		      bp = nil
		      k = d1.inter(d2,bp,r1,r2)
		      if bp <> nil then
		        bptinters(i,j) = bp
		      end if
		      if (k = 0)  or (r1 > 998) then
		        val(i,j) = false
		      end if
		      if r1 > 998 then
		        drappara = true
		      end if
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
		Sub Constructor(s as polygon)
		  Super.Constructor
		  
		  sh1 = s
		  sh2 = s
		  nlig = s.npts-1
		  ncol = nlig
		  
		  redim bptinters(nlig, nlig)
		  redim ids(nlig,nlig)
		  redim val(nlig,nlig)
		  redim pts(-1)
		  
		  computeinter
		  s.autointer = self
		  if combien > 0 then
		    CurrentContent.TheIntersecs.AddObject(self)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreatePoints()
		  dim i, j as integer
		  
		  dim p as point
		  
		  for i = 0 to sh1.npts-1
		    for j = i+1 to sh1.npts-1
		      if  val(i,j) and  not bezet(i,j) then
		        p = new point (objects,bptinters(i,j))
		        p.forme=2
		        p.setconstructedby sh1,45
		        p.numside.append i
		        p.numside.append j
		        p.location.append bptinters(i,j).location(sh1,i)
		        p.location.append bptinters(i,j).location(sh1,j)
		        ids(i,j) =p.id
		        p.endconstruction
		        pts.append p
		      end if
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  currentshape = sh1
		  ComputeInter
		  createpoints
		  polygon(sh1).autointer = self
		  EndOperation
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Replace()
		  dim i, j as integer
		  dim p as point
		  
		  currentshape = sh1
		  ComputeInter
		  for i = 0 to sh1.npts-1
		    for j = i+1 to sh1.npts-1
		      if ids(i,j) <> 0 then
		        p = Point(CurrentContent.TheObjects.Getshape(ids(i,j)))
		        if  val(i,j)  then
		          if p.invalid then
		            p.valider
		          end if
		          p.moveto bptinters(i,j)
		          p.updateshape
		        else
		          p.invalider 
		        end if
		      end if
		    next
		  next
		  
		End Sub
	#tag EndMethod


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
			Name="Std2flag"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
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
