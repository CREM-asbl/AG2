#tag Class
Protected Class TriBPoint
Inherits nBpoint
	#tag Method, Flags = &h0
		Sub TriBPoint(p as BasicPoint, q as BasicPoint, r as BasicPoint)
		  Tab.append p
		  Tab.append q
		  Tab.append r
		  ori = orientation
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Subdiv(orien as integer, n As integer, i as integer) As basicpoint
		  
		  dim r as double
		  dim  a2, a as double
		  
		  r = tab(1).distance(tab(0))
		  a2 = Normalize(endangle-startangle,orien)   //Ne pas utiliser Angle qui tient compte de l'orientation du TriB et non de celle de l'arc qu'on veut diviser
		  if tab(1) = tab(2) then
		    a2=2*PI
		  end if
		  a = startangle +i*a2/n
		  return tab(0) + new BasicPoint(r*cos(a), r*sin(a))
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Angle() As double
		  
		  return Normalize(endangle-startangle, ori)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Normalize(alpha as double, orien as integer) As double
		  if orien >0 then
		    if alpha < 0 then
		      alpha = alpha + 2*PI
		    end if
		  elseif orien <0 then
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
		  ori = orientation
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function orientation() As integer
		  dim u, v as BasicPoint
		  
		  u = tab(1)-tab(0)
		  v = tab(2)-tab(0)
		  return sign(u.vect(v))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PositionOnArc(a as double, orien as integer) As BasicPoint
		  dim p, q as BasicPoint
		  dim r, b as double
		  
		  
		  if abs(ori) = 1 then
		    q = tab(1) - tab(0)
		    r = q.norme
		    b = startangle + a*Angle*orien
		    q = new BasicPoint(cos(b),sin(b))
		    q =  tab(0) + q *r
		    return q
		  end if             'positionne un basicpoint sur un circle à partir de son abscisse curviligne relative à ce circle
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Computeangle(p as BasicPoint, orien as integer) As double
		  dim e, a as double
		  
		  
		  
		  e = GetAngle(tab(0),p)
		  a = e - startangle
		  return Normalize(a,orien)
		  'a a toujours meme signe que orien
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StartAngle() As double
		  return getangle(tab(0),tab(1))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EndAngle() As double
		  return getangle(tab(0),tab(2))
		End Function
	#tag EndMethod


	#tag Note, Name = A propos de l 'orientation
		A propos de l'orientation
		
		La méthode Orientation calcule l'orientation (positive ou négative) du triplet: positive si tab(3) est dans le demi-plan de gauche par rapport 
		à la droite tab(0)-tab(1). Négative dans le cas contraire.
		En pratique le calcul utilise le produit vectoriel (tab(1)-tab(0)) x (tab(2)-tab(1)) qui est d'ailleurs égal à  (tab(1)-tab(0)) x (tab(2)-tab(1) +tab(1)-tab(0)) soit 
		 (tab(1)-tab(0)) x (tab(2)-tab(0))
		
		Lorsque le triplet est associé à un arc, ses éléments sont toujours points(0).bpt, points(1).bpt, points(2).bpt dans cet ordre. Si on retourne l'arc par symétrie orthogonale,
		son orientation doit changer. Il importe donc qu'elle soit recalculée lors d'une telle symétrie. Par contre la routine "modifier" ne doit pas provoquer de changement d'orientation. 
		 
		L'angle du triplet, c-à-d l'angle tab(1)-tab(0)-tab(2) doit toujours avoir le même signe que l'orientation. D'où la méthode Normalize
		
		On n'utilise guère l'orientation du triplet qui ne coincide pas nécessairement avec celle de l'arc. D'où le paramètre orien dans Normalize
	#tag EndNote


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
		#tag ViewProperty
			Name="ori"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
