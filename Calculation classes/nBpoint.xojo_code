#tag Class
Protected Class nBpoint
	#tag Method, Flags = &h0
		Function AffinityMatrix() As Matrix
		  return new AffinityMatrix(tab(0), tab(1), tab(2), tab(5), tab(4), tab(3))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Append(bp as BasicPoint)
		  Tab.append bp
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BoundingRadius() As double
		  dim g as BasicPoint
		  dim i as integer
		  dim br as double
		  
		  g = centre
		  br = 0
		  
		  if taille > 0 then
		    for i = 0 to Taille-1
		      br = max(br, g.distance(tab(i)))
		    next
		  end if
		  
		  return br
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Centre() As BasicPoint
		  dim p as BasicPoint
		  dim i as integer
		  
		  if taille > 0 then
		    p = new basicpoint(0,0)
		    for i = 0 to Taille-1
		      p = p+Tab(i)
		    next
		    return p/Taille
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function computeangle(p as basicpoint, orien as integer) As double
		  dim e, a as double
		  
		  
		  
		  e = GetAngle(tab(0),p)
		  a = e - startangle
		  return Normalize(a,orien)
		  'a a toujours meme signe que orien
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ComputeBoundingBox() As BiBPoint
		  dim dlx, dly, urx, ury as double
		  dim i as integer
		  
		  
		  dlx = tab(0).x
		  dly = tab(0).y
		  urx = tab(0).x
		  ury = tab(0).y
		  for i = 1 to taille-1
		    dlx = Min(dlx,tab(i).x)
		    dly = Min(dly,tab(i).y)
		    urx = Max(urx,tab(i).x)
		    ury = Max(ury,tab(i).y)
		  next
		  
		  dim dl as new BasicPoint(dlx,dly)
		  dim ur as new BasicPoint(urx,ury)
		  return new BiBPoint(dl,ur)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  redim tab(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ar() as basicpoint)
		  Tab = ar
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(p as BasicPoint)
		  Constructor()
		  Tab.append p
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(s as shape)
		  dim i as integer
		  
		  if not s isa point then
		    for i = 0 to s.npts-1
		      append s.points(i).bpt
		    next
		  else
		    append point(s).bpt
		  end if
		  
		  redim curved(-1)
		  redim curved(taille-1)
		  for i = 0 to taille-1
		    curved(i) = 0
		  next
		  
		  'Le tableau indique quels sont les côtés de la forme qui sont curvilignes.
		  'Il doit y en avoir exactement narcs.
		  'Pour les  ("arc"), narcs vaut 1 et le côté courbe est toujours le côté n°1.
		  'Pour les stdcircle et freecircle, narcs vaut 0 sinon ils seraient considérés comme hybrides
		  'Pour simplifier la lecture des centres des côtés courbes, on en crée également narcs même si certains ne seront pas utilisés. 
		  'Le centre du côté n°i est le basicpoint centres(i).
		  
		  redim centres(-1)
		  redim centres(taille-1)
		  
		  'Les extrémités et points de contrôles des sous-arcs ne seront, par contre, crées qu'exactement dans le nombre nécessaire 
		  'soit 2*narcs-1 pour les extre et 6*narcs-1 pour les ctrl
		  if s.narcs > 0 then
		    redim extre(-1)
		    redim extre(2*s.narcs-1)
		    redim ctrl(-1)
		    redim ctrl(6*s.narcs-1) 
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape(fa as integer, fo as integer)
		  dim a, b, c as BasicPoint
		  dim d as double
		  dim i, n, ori as integer
		  dim M as matrix
		  
		  ori = 1
		  
		  select case fa
		  case 1
		  case 2 'Triangles
		    select case  fo
		    case 1 'TriIso
		      a = (tab(0)+tab(1))/2
		      b = tab(1)-tab(0)
		      b = b.vecnorperp
		      M = new OrthoProjectionMatrix(a,a+b)
		      tab(2) = M*tab(2)
		    case 2 'TriEqui
		      constructshape(4,0)
		    case 3 'TriRect
		      a = tab(1)
		      b = a-tab(0)
		      b = b.vecnorperp
		      M = new OrthoProjectionMatrix(a,a+b)
		      tab(2) = M*tab(2)
		    case 4 'TriRectIso
		      a = (tab(0)+tab(1))/2
		      M = new RotationMatrix(a,ori*PIDEMI)
		      tab(2) = M*tab(1)
		    end select
		  case 3 'Quadris
		    select case fo
		    case 1
		      a = tab(2)
		      b =  tab(0)-tab(1)
		      M =  new OrthoProjectionMatrix(a,a+b)
		      tab(3) = M*tab(3)
		    case 2
		      a = tab(0)
		      b = tab(1)-tab(0)
		      b = b.vecnorperp
		      M = new OrthoProjectionMatrix(a,a+b)
		      tab(3) = M*tab(2)
		    case 3
		      a = (tab(0)+tab(1))/2
		      b = tab(1)-tab(0)
		      b = b.vecnorperp
		      M = new SymmetryMatrix(a,a+b)
		      tab(3) = M*tab(2)
		    case 4
		      tab(3) = tab(0)-tab(1)+tab(2)
		    case 5
		      a = tab(1)
		      b = tab(1)-tab(0)
		      b = b.vecnorperp
		      M =  new OrthoProjectionMatrix(a,a+b)
		      tab(2) = M*tab(2)
		      tab(3) = tab(0)-tab(1)+tab(2)
		    case 6      'Losanges
		      d = tab(0).distance(tab(1))
		      b = tab(2)-tab(1)
		      if tab(1).distance(tab(2)) > 0 then
		        tab(2) = tab(1)+(b.normer)*d
		      end if
		      tab(3) = tab(0)-tab(1)+tab(2)
		    case 7
		      constructshape(4,1)
		    end select
		  case 4 'Polreg
		    if tab(0) = nil or tab(1) = nil then
		      return
		    end if
		    n = fo+3
		    a = (tab(0)+tab(1))/2
		    b = tab(1)-tab(0)
		    d = b.norme
		    b = b.VecNorPerp
		    c = a + b*(ori*d/(2*tan(PI/n)))
		    M = new RotationMatrix(c,2*ori*PI/n)
		    for i = 2 to n-1
		      tab(i) = M*tab(i-1)
		    next
		  case 5
		    select case  fo
		    case 1, 2 'arcs et secteurs de disque
		      d = tab(0).distance(tab(1))
		      tab(2) = tab(2).projection(tab(0),d)
		    end select
		  end select
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape(fa as integer, fo as integer, ref as nBpoint, n as integer, ori as integer)
		  dim  w as BasicPoint
		  dim M as Matrix
		  
		  w = ref.tab(1)-ref.tab(0)
		  w=w.normer
		  if fo = 2 or fo = 5 Then
		    w=w.VecNorPerp
		  end if
		  
		  select case n
		  case 0                           'On appelle la méthode lors du positionnement de l'origine du segment
		    if ori <> 0 then
		      tab(1) = tab(0)+w*ori
		    else
		      tab(1) = tab(0) +w
		    end if
		  case 1                           'Positionnement de l'extrémité du segment
		    'Ceci ne préjuge ps de la position finale de l'extrémité (si c'est un point sur , ...)
		    'Quand on travaille à la souris, c'est le clic qui indique la position finale
		    'Pour les macros, c'est différent
		    if fo = 1 or fo = 2 then
		      M = new OrthoProjectionMatrix(tab(0), tab(0)+w)
		      tab(1)=M*tab(1)
		    elseif ori <> 0 then
		      tab(1) = tab(0) +w*ori
		    else
		      tab(1)=tab(0)
		    end if
		  end select
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateExtreAndCtrlPoints(orien as integer)
		  dim Mat as RotationMatrix
		  dim BiB as BiBPoint
		  dim m, n ,i as integer
		  dim temp(1) as BasicPoint
		  dim A as Angle
		  dim alpha as double
		  
		  n = 0
		  m=0
		  for i = 0 to taille-1
		    if curved(i) = 1 then
		      Bib = new BiBPoint(tab(i), tab((i+1) mod taille))
		      A = new Angle(Bib,centres(i), orien)
		      alpha = A.alpha/3
		      
		      Mat = new RotationMatrix(centres(i),alpha)
		      
		      extre(n) = Mat*tab(i)
		      extre(n+1) = Mat*extre(n)
		      BiB = new BiBPoint(tab(i),extre(n))
		      Bib.computeCtrlPoints(centres(i), orien,  temp)
		      if temp(0) <> nil and temp(1) <> nil then
		        ctrl(m) = temp(0)
		        ctrl(m+1) = temp(1)
		        for i = 2 to 5
		          ctrl(m+i) = Mat*ctrl(m+i-2)
		        next
		        n = n+2
		        m=m+6
		      end if
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function distance01() As double
		  if tab(0) <> nil and tab(1) <> nil then
		    return tab(0).distance(tab(1))
		  else
		    return -1
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function endangle() As double
		  return getangle(tab(0),tab(2))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EtirCisailMatrix() As Matrix
		  return new AffinityMatrix(tab(0),tab(1),tab(2),tab(0),tab(1), tab(3))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBibSide(i as integer) As nBPoint
		  
		  if i > -1 and i < taille then
		    return new BiBPoint (tab(i),tab((i+1) mod taille))
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HomothetyMatrix() As HomothetyMatrix
		  return new HomothetyMatrix(tab(0),tab(1),tab(3), tab(2))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsometryMatrix() As Matrix
		  return new IsometryMatrix(tab(0),tab(1),tab(3), tab(2))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveExtreCtrl(M as Matrix)
		  dim i as integer
		  
		  for i = 0 to ubound(extre)
		    extre(i) = M*extre(i)
		  next
		  for i = 0 to ubound(ctrl)
		    ctrl(i) = M*ctrl(i)
		  next
		  
		  for i = 0 to ubound(centres)
		    if centres(i)<> nil then
		      centres(i)=M*centres(i)
		    end if
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
		Function orientation() As integer
		  dim u, v as BasicPoint
		  
		  u = tab(1)-tab(0)
		  v = tab(2)-tab(0)
		  return sign(u.vect(v))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Perimetre() As double
		  dim i, n as integer
		  dim p as double
		  
		  n = Taille-1
		  p = 0
		  for i = 0 to n-1
		    p = p + tab(i+1).distance(Tab(i))
		  next
		  p = p+ Tab(n).distance(Tab(0))
		  return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(p as BasicPoint) As Boolean
		  'dim i  as integer
		  'dim c as Boolean
		  'dim q,r as basicPoint
		  
		  
		  'c = false
		  'for  i = 0  to Taille -1
		  'q = Tab(i)
		  'r =  Tab((i+1) mod Taille)
		  'if ( ((q.y<=p.y) and (p.y <r.y)) or ((r.y <= p.y) and (p.y < q.y)) ) and (p.x < (r.x - q.x) * (p.y - q.y) / (r.y - q.y) + q.x) then
		  'c =not c
		  'end if
		  'next
		  'return c
		  
		  dim n as integer
		  
		  n = p.indice(self)
		  return n <> 0
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape1(p as BasicPoint) As integer
		  dim i  as integer
		  dim c as integer
		  dim q,r as basicPoint
		  
		  
		  c = 0
		  for  i = 0  to Taille -1
		    q = Tab(i)
		    r =  Tab((i+1) mod Taille)
		    if ( ((q.y<=p.y) and (p.y <r.y)) or ((r.y <= p.y) and (p.y < q.y)) )  and (p.x < (r.x - q.x) * (p.y - q.y) / (r.y - q.y) + q.x) then
		      c = c+1
		    end if
		  next
		  return c
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PositionOnCircle(a as double, ori as integer) As BasicPoint
		  dim p, q as BasicPoint   'positionne un basicpoint sur un cercle à partir de son abscisse curviligne relative à ce cercle
		  dim r, b as double
		  
		  if abs(ori) = 1 then
		    q = tab(1) - tab(0)
		    r = q.norme
		    b = q.Anglepolaire+ a*2*Pi*ori
		    q = new BasicPoint(cos(b),sin(b))
		    q = tab(0) + q *r
		    return q
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PseudoTrap() As Boolean
		  dim u, v as basicPoint
		  
		  if Taille <> 4 then
		    return false
		  end if
		  u = tab(1) - tab(0)
		  v = tab(2) - tab(3)
		  
		  u = u.normer
		  v = v.normer
		  if u = nil or v = nil then
		    return true
		  else
		    return abs(u.vect(v) ) < epsilon
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RotationMatrix() As Matrix
		  return new SimilarityMatrix(tab(0),tab(1),tab(0),tab(2))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SimilarityMatrix() As SimilarityMatrix
		  return new SimilarityMatrix(tab(0),tab(1),tab(3), tab(2))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function startangle() As double
		  return getangle(tab(0),tab(1))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SymmetryMatrix() As Matrix
		  return new SymmetryMatrix(tab(0),tab(1))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Taille() As integer
		  return ubound(Tab)+1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TranslationMatrix() As Matrix
		  return new TranslationMatrix (tab(1)-tab(0))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  dim temp as XMLElement
		  dim i as integer
		  
		  Temp = Doc.CreateElement("Coords")
		  for i = 0 to taille-1
		    Temp.appendchild tab(i).XMLPutInContainer(Doc)
		  next
		  return temp
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim i as integer
			  dim a as double
			  
			  a = 0
			  for i = 0 to Taille-1
			    a = a + Tab(i).Vect( Tab((i+1) mod Taille) )
			  next
			  
			  return a/2
			End Get
		#tag EndGetter
		Aire As double
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		centres() As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ctrl() As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		curved() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		extre() As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		Tab() As BasicPoint
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Aire"
			Group="Behavior"
			Type="double"
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
