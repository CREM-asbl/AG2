#tag Class
Protected Class AffiProjectionMatrix
Inherits AffinityMatrix
	#tag Method, Flags = &h0
		Sub Constructor(Bib1 as BibPoint, Bib2 as BibPoint)
		  //Projection affine sur Bib2 parallèlement à Bib1
		  
		  dim p, u, v, a as BasicPoint
		  dim IdX, IdY as BasicPoint
		  dim r1 as double
		  
		  a = Bib2.first
		  p = Bib2.Second-Bib2.first
		  p = new BasicPoint(p.y,-p.x)
		  u = bib1.second - bib1.first
		  r1= p.Mulp(u)
		  
		  Idx = new BasicPoint (1,0)
		  Idy = new BasicPoint(0,1)
		  
		  if abs (r1) > epsilon*p.norme*u.norme then   // Bibpoints parallèles ou alignés
		    r1 = -(p.Mulp(IdX))/(p.Mulp(u))
		    v = IdX+u
		    v1= IdX.Mulp(1-r1)+v.Mulp(r1)
		    r1 = -(p.Mulp(IdY))/(p.Mulp(u))
		    v = IdY+u
		    v2=IdY.Mulp(1-r1)+v.Mulp(r1)
		    v3= a-v1.Mulp(a.x) -v2.Mulp(a.y)
		  else
		    v1 = nil
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
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
