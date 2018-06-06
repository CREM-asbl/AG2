#tag Class
Protected Class TriBPoint
Inherits nBpoint
	#tag Method, Flags = &h0
		Function Angle() As double
		  
		  return Normalize(endangle-startangle, ori)
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
		Sub Constructor(p as BasicPoint, q as BasicPoint, r as BasicPoint)
		  Tab.append p
		  Tab.append q
		  Tab.append r
		  ori = orientation
		  redim extre(-1)
		  redim ctrl(-1)
		  redim extre(1) 'prévu pour le cas d'un seul arc
		  redim ctrl(5)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(s as shape)
		  super.constructor(s) 'renvoie  à new nBPoint lequel tient compte du nombre d'arcs
		  ori = orientation
		  redim extre(1)  'ceci correspond à un trigone comportant un et un seul arc donc contrarie le "super.constructor"
		  redim ctrl(5)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(tbp as TriBPoint)
		  dim i as integer   'Utilisé exclusivement pour le skullcoord de Secteur ( nécessaire du fait que le skull d'un Secteur
		  ' ne repose pas sur les points de ce secteur, mais sur les extrémtés des demi-droites
		  redim tab(2)
		  for i = 0 to 2
		    tab(i) = tbp.tab(i)
		  next
		  redim centres(2)
		  redim curved(2)
		  redim extre(1)
		  redim ctrl(5)
		  centres(1) = tab(0)
		  curved(1)=1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateExtreAndCtrlPoints(orien as integer)
		  dim Bib as BiBPoint
		  dim alpha as double
		  dim M as RotationMatrix
		  dim i as integer
		  
		  alpha = Normalize(endangle-startangle, orien)/3
		  M = new RotationMatrix(tab(0),alpha)
		  extre(0) = M*tab(1)
		  extre(1) = M*extre(0)
		  BiB = new BiBPoint(tab(1),extre(0))
		  Bib.computeCtrlPoints(tab(0), orien,  ctrl)
		  for i = 2 to 5
		    if ctrl(i-2) <> nil then
		      ctrl(i) = M*ctrl(i-2)
		    end if
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EndAngle() As double
		  return getangle(tab(0),tab(2))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HalfDskCreateExtreAndCtrlPoints(orien as integer)
		  dim Bib as BiBPoint
		  dim alpha as double
		  dim M as RotationMatrix
		  dim i as integer
		  
		  orien = 1
		  alpha = PI/3
		  M = new RotationMatrix(tab(0),alpha)
		  extre(0) = M*tab(1)
		  extre(1) = M*extre(0)
		  BiB = new BiBPoint(tab(1),extre(0))
		  Bib.computeCtrlPoints(tab(0), orien,  ctrl)
		  for i = 2 to 5
		    ctrl(i) = M*ctrl(i-2)
		  next
		  
		  
		  
		End Sub
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
		Function PositionOnArc(a as double, orien as integer) As BasicPoint
		  dim p, q as BasicPoint
		  dim r, b as double
		  
		  
		  if abs(ori) = 1 then
		    q = tab(1) - tab(0)
		    r = q.norme
		    b = startangle + a*Angle*orien
		    q = new BasicPoint(cos(b),sin(b))
		    q =  tab(0) + q *r
		  end if             'positionne un basicpoint sur un circle à partir de son abscisse curviligne relative à ce circle
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StartAngle() As double
		  return getangle(tab(0),tab(1))
		End Function
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

	#tag Note, Name = A user prudemment
		
		Les tribpoints ne sont conçus que pour des trigones n'ayant qu'un seul côté courbe
	#tag EndNote


	#tag Property, Flags = &h0
		ori As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="decomp"
			Group="Behavior"
			Type="boolean"
		#tag EndViewProperty
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
			Name="ori"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
