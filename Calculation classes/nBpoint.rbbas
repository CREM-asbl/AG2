#tag Class
Protected Class nBpoint
	#tag Method, Flags = &h0
		Sub nBpoint(ar() as basicpoint)
		  Tab = ar
		End Sub
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
		Function Taille() As integer
		  return ubound(Tab)+1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub nBpoint(s as shape)
		  dim i as integer
		  
		  if not s isa point then
		    for i = 0 to s.npts-1
		      append s.points(i).bpt
		    next
		  else
		    append point(s).bpt
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Aire() As double
		  dim i as integer
		  dim a as double
		  
		  a = 0
		  for i = 0 to Taille-1
		    a = a + Tab(i).Vect( Tab((i+1) mod Taille) )
		  next
		  
		  return a/2
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
		Sub Append(bp as BasicPoint)
		  Tab.append bp
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub nBpoint()
		  redim tab(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape(fa as integer, fo as integer)
		  dim a, b, c as BasicPoint
		  dim d as double
		  dim i, n, ori as integer
		  dim M as matrix
		  
		  for i = 0 to taille-1
		    if tab(i) = nil then
		      return
		    end if
		  next
		  
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
		      append M*tab(1)
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
		      append M*tab(2)
		    case 3
		      a = (tab(0)+tab(1))/2
		      b = tab(1)-tab(0)
		      b = b.vecnorperp
		      M = new SymmetryMatrix(a,a+b)
		      append M*tab(2)
		    case 4
		      append tab(0)-tab(1)+tab(2)
		    case 5
		      a = tab(1)
		      b = tab(1)-tab(0)
		      b = b.vecnorperp
		      M =  new OrthoProjectionMatrix(a,a+b)
		      tab(2) = M*tab(2)
		      append tab(0)-tab(1)+tab(2)
		    case 6
		      d = tab(0).distance(tab(1))
		      b = tab(2)-tab(1)
		      if tab(1).distance(tab(2)) > 0 then
		        tab(2) = tab(1)+(b.normer)*d
		      end if
		      append tab(0)-tab(1)+tab(2)
		    case 7
		      constructshape(4,1)
		    end select
		  case 4 'Polreg
		    n = fo+3
		    a = (tab(0)+tab(1))/2
		    b = tab(1)-tab(0)
		    d = b.norme
		    if d <> 0 then
		      b = b.VecNorPerp
		      c = a + b*(ori*d/(2*tan(PI/n)))
		      M = new RotationMatrix(c,2*ori*PI/n)
		      for i = 2 to n-1
		        append M*tab(i-1)
		      next
		    end if
		  case 5
		    select case  fo
		    case 1
		      d = tab(0).distance(tab(1))
		      tab(2) = tab(2).projection(tab(0),d)
		    end select
		  end select
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub nBPoint(p as BasicPoint)
		  nBPoint
		  Tab.append p
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(p as BasicPoint) As Boolean
		  dim i, n as integer
		  dim c as Boolean
		  dim q,r as basicPoint
		  Dim Bib1, Bib2 as BiBpoint
		  Dim r1,r2 as double
		  
		  q = new Basicpoint(1,0)
		  q = p+q
		  Bib1 = new BiBpoint(p, q)
		  n = Taille
		  c = false
		  
		  for i = 0 to n-1
		    Bib2 = new BibPoint(Tab(i), Tab((i+1) mod n))
		    r = BiB1.BiBInterDroites(BiB2,1,2,r1,r2)
		    if r <> nil then
		      c = not c
		    end if
		  next
		  return c
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape(fa as integer, fo as integer, ref as nBpoint, n as integer)
		  dim  w as BasicPoint
		  dim M as Matrix
		  
		  w = ref.tab(1)-ref.tab(0)
		  w=w.normer
		  if fo = 2 or fo = 5 Then
		    w=w.VecNorPerp
		  end if
		  
		  select case n
		  case 0                           'On appelle la méthode lors du positionnement de l'origine du segment
		    if fo < 4 then
		      tab(1) = tab(0)
		    else
		      tab(1) = tab(0)+w
		    end if
		  case 1                           'Positionnement de l'extrémité du segment
		                                      'Ceci ne préjuge ps de la position finale de l'extrémité (si c'est un point sur , ...)
		                                      'Quand on travaille à la souris, c'est le clic qui indique la position finale
		                                      'Pour les macros, c'est différent
		    if fo = 1 or fo = 2 then
		      M = new OrthoProjectionMatrix(tab(0), tab(0)+w)
		      tab(1)=M*tab(1)
		    else
		      tab(1) = tab(0) +w
		    end if
		  end select
		  
		  
		  
		End Sub
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
		Function RotationMatrix() As Matrix
		  return new SimilarityMatrix(tab(0),tab(1),tab(0),tab(2))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TranslationMatrix() As Matrix
		  return new TranslationMatrix (tab(1)-tab(0))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SimilarityMatrix() As Matrix
		  return new SimilarityMatrix(tab(0),tab(1),tab(3), tab(2))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function startangle() As double
		  return getangle(tab(0),tab(1))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function endangle() As double
		  return getangle(tab(0),tab(2))
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
		Function computeangle(p as basicpoint, orien as integer) As double
		  dim e, a as double
		  
		  
		  
		  e = GetAngle(tab(0),p)
		  a = e - startangle
		  return Normalize(a,orien)
		  'a a toujours meme signe que orien
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
		Function SymmetryMatrix() As Matrix
		  return new SymmetryMatrix(tab(0),tab(1))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsometryMatrix() As Matrix
		  return new IsometryMatrix(tab(0),tab(1),tab(3), tab(2))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AffinityMatrix() As Matrix
		  return new AffinityMatrix(tab(0), tab(1), tab(2), tab(5), tab(4), tab(3))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EtirCisailMatrix() As Matrix
		  return new AffinityMatrix(tab(0),tab(1),tab(2),tab(0),tab(1), tab(3))
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Tab() As BasicPoint
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
