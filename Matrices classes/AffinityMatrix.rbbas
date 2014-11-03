#tag Class
Protected Class AffinityMatrix
Inherits Matrix
	#tag Method, Flags = &h0
		Sub AffinityMatrix(u1 as basicpoint, u2 as basicpoint, u3 as basicpoint, p1 as basicpoint, p2 as basicpoint, p3 as basicpoint)
		  dim w1,w2,q1,q2, a, b, c  as basicpoint
		  dim M as matrix
		  dim r as double
		  
		  if u1 <> nil and u2 <> nil and u3 <> nil and p1 <> nil and p2 <> nil and p3 <> nil then
		    w1 = u2-u1
		    w2 = u3-u1
		    q1 = p2-p1
		    q2 = p3-p1
		    
		    if not (u1.alignes(u2,u3)) and not (p1.alignes(p2,p3)) then
		      a = new basicpoint (w1.x, w2.x)
		      b = new basicpoint (w1.y, w2.y)
		      c = new basicpoint(0,0)
		      M = new matrix(a,b,c)
		      M = M.inv
		      a = new BasicPoint(q1.x,q2.x)
		      w1 = M*a
		      a = new BasicPoint(q1.y,q2.y)
		      w2 = M*a
		      v1 = new basicPoint(w1.x, w2.x)
		      v2 = new BasicPoint(w1.y, w2.y)
		      v3=new BasicPoint(p1.x - w1*u1,p1.y-w2*u1)
		    else
		      M = new Matrix(1)
		      v1 = M.v1
		      v2 = M.v2
		      v3=M.v3
		    end if
		    
		  end if
		  
		  //Matrice de l'affinité u1 u2 u3 -> p1 p2 p3
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AffinityMatrix(p1 as point, p2 as point, ep3 as basicpoint, ep4 as Basicpoint, np3 as BasicPoint, np4 as BasicPoint)
		  //Deux pointssur p1 et p2,  et deux points modifiés (ou non) , p3 et p4
		  
		  dim M1, M2, M as  Matrix
		  dim np1, np2 as Basicpoint
		  dim s1, s2 as shape
		  dim bib1, Bib2, BiB3,  Bib11, Bib22 As BiBPoint
		  dim u, v, bp1, bp2, bp3, q as Basicpoint
		  dim r1, r2 as double
		  
		  s1 = p1.pointsur.element(0)
		  s2 = p2.pointsur.element(0)
		  bp1= p1.bpt
		  bp2 = p2.bpt
		  bib1 = p1.GetBiBPoint
		  bib2 = p2.GetBiBpoint
		  
		  if p1 = nil or p2 = nil or ep3 = nil or ep4 = nil or np3 = nil or np4 = nil then
		    return
		  end if
		  
		  //Première étape : construire une similitude appliquant ep3 sur np3 et ep4 sur np4
		  
		  M1 = new SimilarityMatrix (ep3, ep4, np3, np4)
		  
		  if M1 <> nil and M1.v1 <> nil Then
		    
		    //Deuxième étape, on prend les images de p1 et p2 par M1
		    
		    np1 = M1*p1.bpt
		    np2 = M1*p2.bpt
		    
		    //Troisième étape, on ramène np1 et np2 sur les supports de p1 et p2 par un étirement M2 d'axe (np3, np4)
		    
		    Bib1 = new BiBPoint(np1, np2)
		    Bib2 = new BiBPoint(np3, np4)
		    u = Bib1.BibInterdroites(Bib2,0,0,r1, r2)
		    
		    if u <> nil then
		      M2 = new HomothetyMatrix(u, np2,u,np1)
		    else
		      M2 = new TranslationMatrix(np1-np2)
		      
		    end if
		    
		    s1 = p1.pointsur.element(0)
		    s2 = p2.pointsur.element(0)
		    if s1 = s2 and M2 isa TranslationMatrix then
		      v = M2*p1.bpt
		    else
		      Bib2 = p2.GetBiBPoint
		      Bib22 = new BiBPoint(M2*Bib2.first, M2*Bib2.second)
		      if s2 isa circle then
		        v = Bib22.ComputeCirclefirstintersect(s1,p1)
		      else
		        v = Bib22.ComputeDroitefirstintersect(s1,p1)
		      end if
		    end if
		    if v <> nil then
		      M2 = new AffinityMatrix(np3,np4,np1,np3,np4,v)
		      
		      if M2 <> nil and M2.v2 <> nil then
		        M = M2*M1
		        v1 = M.v1
		        v2=M.v2
		        v3=M.v3
		      end if
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
