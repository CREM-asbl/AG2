#tag Class
Protected Class SimilarityMatrix
Inherits AffinityMatrix
	#tag Method, Flags = &h0
		Sub SimilarityMatrix(c as basicpoint, k as double, a as double)
		  if c <> nil then
		    
		    v1 = new BasicPoint(k*cos(a), k*sin(a))
		    v2 = new BasicPoint(-k*sin(a),k*cos(a))
		    v3 = v1*(-c.x) + v2*(-c.y) + c
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SimilarityMatrix(s1 as BasicPoint, s2 as BasicPoint, b1 as BasicPoint, b2 as BasicPoint)
		  dim w, w1, w2, q, a, b, c  as basicpoint
		  dim M as matrix
		  dim d As double
		  
		  
		  if s1 <> nil and s2 <> nil and b1 <> nil and b2 <> nil then
		    w = s2-s1
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

	#tag Method, Flags = &h0
		Function centre() As basicpoint
		  dim cx, cy, delta, k , alpha as double
		  
		  alpha = angle
		  k = rapport
		  delta = det -2*k*cos(alpha) +1
		  
		  cx = (v3.x*(1-k*cos(alpha))- v3.y*k*sin(alpha))/delta
		  cy = (v3.y*(1-k*cos(alpha))+ v3.x*k*sin(alpha))/delta
		  
		  return new BasicPoint(cx, cy)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function rapport() As double
		  return sqrt(det)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function angle() As double
		  return atan2(v1.y, v1.x)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SimilarityMatrix(p1 as Point, p2 as point, ep as Basicpoint, np as basicPoint)
		  // p1 et p2 sont des pointssur, ep, np correspondent au point modifié
		  dim Bip1,  Bip2, Bip3 as BiBPoint
		  dim M as Matrix
		  dim q, q1,  bp1, bp2, bp3,a, b As BasicPoint
		  dim s1, s2 as shape
		  dim r1, r2 as double
		  dim t as boolean
		  
		  
		  if p1 <> nil and p2 <> nil and ep <> nil and np <> nil  then
		    t = true
		    q = nil
		    
		    s2 = p2.pointsur.element(0)
		    bp1= p1.bpt
		    bp2 = p2.bpt
		    bip1 = p1.GetBiBPoint
		    bip2 = p2.GetBiBpoint
		    
		    M = new similarityMatrix(bp1,ep,bp1,np)
		    
		    if M.v1 <> nil then
		      
		      bp3 = M*bp2
		      M = new SimilarityMatrix(np,bp1,np,bp3)
		      
		      if M.v1 <> nil then
		        
		        Bip3 = new BiBpoint (M*Bip1.first, M*Bip1.second)
		        
		        if Bip1.type = 1 then
		          q = Bip3.ComputeCircleFirstIntersect(s2,p2)
		        else
		          q = Bip3.BiBInterdroites(Bip2, bip1.nextre, bip2.nextre,r1,r2)  'n1ComputeDroiteFirstIntersect(s2,p2)
		        end if
		        
		        if  q <> nil   then
		          M = new SimilarityMatrix(ep, bp2, np,q)
		          
		          if M.v1 <> nil then
		            
		            'q1 = M*bp1
		            
		            if t then
		              v1 = M.v1
		              v2 = M.v2
		              v3 = M.v3
		            end if
		          end if
		        end if
		      end if
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub similaritymatrix(ep as Basicpoint, np as basicPoint, p1 as Point, p2 as point)
		  // p1 est un point non modifiable, p2 est un pointsur, ep, np correspondent au point modifié
		  dim M as matrix
		  dim ep1, ep2,  np2 as BasicPoint
		  dim s2 as shape
		  
		  if ep <> nil and np <> nil and p1 <> nil and p2 <> nil then
		    ep1 = p1.bpt
		    
		    s2 = p2.pointsur.element(0)
		    ep2 = p2.bpt
		    
		    M = new SimilarityMatrix(ep1,ep,ep1, np)
		    
		    if M.v1 <> nil then
		      np2 = M*ep2
		      if s2 isa Bipoint then
		        np2 = np2.projection(Bipoint(s2).firstp, Bipoint(s2).secondp)
		      elseif s2 isa circle then
		        np2 = np2.projection(s2.getgravitycenter, circle(s2).getradius)
		      end if
		      M = new SimilarityMatrix(ep1,ep2,ep1,np2)
		      v1 = M.v1
		      v2 = M.v2
		      v3 = M.v3
		      
		    end if
		    
		  end if
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = Licence
		
		Copyright © 2010 CREM
		Noël Guy - Pliez Geoffrey
		
		This file is part of Apprenti Géomètre 2.
		
		Apprenti Géomètre 2 is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.
		
		Apprenti Géomètre 2 is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.
		
		You should have received a copy of the GNU General Public License
		along with Apprenti Géomètre 2.  If not, see <http://www.gnu.org/licenses/>.
	#tag EndNote


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
