#tag Class
Protected Class TriBPoint
Inherits nBpoint
	#tag Method, Flags = &h0
		Sub TriBPoint(p as BasicPoint, q as BasicPoint, r as BasicPoint)
		  Tab.append p
		  Tab.append q
		  Tab.append r
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Subdiv(ori as integer, n As integer, i as integer) As basicpoint
		  dim c, o, e as basicpoint
		  dim r as double
		  dim a1, a2, a as double
		  dim Bib as BiBPoint
		  
		  
		  c = tab(0)   //centre
		  o = tab(1)  //origine
		  e = tab(2)  //extremite
		  r = c.distance(o)
		  a1 = getangle(c,o)
		  a2= Angle
		  if o = e then
		    a2=2*PI
		  end if
		  a = a1+(i/n)*a2
		  a = Normalize(a)
		  return c + new BasicPoint(r*cos(a), r*sin(a))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Angle() As double
		  dim bpf, bps as BasicPoint
		  dim fa, sa as double
		  
		  
		  bpf = tab(1)-tab(0)
		  fa  = bpf.anglepolaire
		  bps = tab(2)-tab(0)
		  sa = bps.anglepolaire
		  return Normalize(sa-fa)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Normalize(alpha as double) As double
		  if ori >0 then
		    if alpha < 0 then
		      alpha = alpha + 2*PI
		    end if
		  elseif ori <0 then
		    if alpha >0 then
		      alpha = alpha -2*PI
		    end if
		  end if
		  
		  return alpha
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TriBPoint(nBp as nBPoint)
		  
		  Tab = nBp.Tab
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function orientation() As integer
		  dim u, v as BasicPoint
		  
		  u = tab(0)-tab(1)
		  v = tab(2)-tab(0)
		  return sign(u.vect(v))
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		ori As Integer
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
	#tag EndViewBehavior
End Class
#tag EndClass
