#tag Class
Protected Class AffiProjectionMatrix
Inherits AffinityMatrix
	#tag Method, Flags = &h0
		Sub AffiProjectionMatrix(Bib1 as BibPoint, Bib2 as BibPoint)
		  //Projection affine sur Bib2 parallèlement à Bib1
		  
		  dim p, u, a as BasicPoint
		  dim IdX, IdY as BasicPoint
		  dim r1 as double
		  
		  a = Bib2.first
		  p = Bib2.Second-Bib2.first
		  p = new BasicPoint(p.y,-p.x)
		  u = bib1.second - bib1.first
		  r1= p*u
		  
		  Idx = new BasicPoint (1,0)
		  Idy = new BasicPoint(0,1)
		  
		  if abs (r1) > epsilon*p.norme*u.norme then   // Bibpoints parallèles ou alignés
		    r1 = -(p*IdX)/(p*u)
		    v1= IdX*(1-r1)+(IdX+u)*r1
		    r1 =- (p*IdY)/(p*u)
		    v2= IdY*(1-r1)+(IdY+u)*r1
		    v3= a-v1*a.x -v2*a.y
		  else
		    v1 = nil
		  end if
		End Sub
	#tag EndMethod


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
