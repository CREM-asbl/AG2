#tag Class
Protected Class IsometryMatrix
Inherits SimilarityMatrix
	#tag Method, Flags = &h0
		Sub Constructor(s1 as BasicPoint, s2 as BasicPoint, b1 as BasicPoint, b2 as BasicPoint)
		  
		  dim w, w1, w2, q, a, b, c  as basicpoint
		  dim s as double
		  dim M as matrix
		  dim d As double
		  
		  
		  if s1 <> nil and s2 <> nil and b1 <> nil and b2 <> nil then
		    w = s2-s1
		    d = w.norme
		    q = b2-b1
		    s = q.norme
		    if s < epsilon then
		      return
		    end if
		    b2 = b1+q*d/s
		    q = b2-b1
		    
		    if  not (w.norme < epsilon) and not  (q.norme < epsilon) then
		      b = new BasicPoint(-w.y, w.x)
		      c = new BasicPoint(0,0)
		      d = w.norme
		      M = new matrix(w,b,c)
		      M = M*(1/(d*d))
		      
		      a = new BasicPoint(q.x,-q.y)
		      w1 = M*a
		      a = new BasicPoint(q.y,q.x)
		      w2 = M*a
		      v1 = new basicPoint(w1.x, w2.x)
		      v2 = new BasicPoint(w1.y, w2.y)
		      v3=new BasicPoint(b1.x - w1*s1,b1.y-w2*s1)
		    end if
		  end if
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
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
