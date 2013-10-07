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
		  dim i, n as integer
		  dim a as double
		  
		  a = 0
		  for i = 0 to Taille-1
		    a = a + Tab(i).Vect( Tab((i+1) mod Taille) )
		  next
		  
		  return a
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
		Function ComputeMatrix(t as integer, index as integer, npts as integer, ori as integer) As Matrix
		  dim k as double
		  dim u,v,w as BasicPoint
		  dim M as Matrix
		  
		  select case t
		  case 1
		    v = tab((index+1)mod npts)- tab(index)
		    M = new translationmatrix (v*ori)
		    'case 2
		    'M = new rotationmatrix (tab(0).bpt, arc(supp).arcangle)
		    'case 3
		    'M = new rotationmatrix(tab(0).bpt, PI)
		    'case 4
		    'M = new rotationmatrix(tab(0).bpt,PIDEMI)
		    'case 5
		    'M = new rotationmatrix(tab(0).bpt, -PIDEMI)
		    'case 6
		    'if  supp isa droite then
		    'M = new SymmetryMatrix(tab(0),tab(1))
		    'elseif supp isa bande then
		    'if index = 0 then
		    'v = tab(1)
		    'else
		    'v = Bande(supp).Point3
		    'end if
		    'M = new SymmetryMatrix(tab(2*index), v)
		    'elseif supp isa polygon then
		    'M = new SymmetryMatrix(tab(index), tab((index+1) mod supp.npts))
		    'elseif supp isa secteur then
		    'M = new SymmetryMatrix(tab(0), tab(index))
		    'end if
		    'case 7, 72
		    'M = new HomothetyMatrix(tab(0),tab(1),tab(3), tab(2))
		    'case 71
		    'u = tab(0)
		    'v = tab(1)
		    'w = supphom(supp).tab(3)
		    'k = w.location(u,v)
		    'M = new HomothetyMatrix(u, k)
		    'case 8
		    'M = new SimilarityMatrix(tab(0),tab(1),tab(3), tab(2))
		    'case 81
		    'M = new SimilarityMatrix(tab(0),tab(1),tab(0), tab(2))
		    'case 82
		    'M = new SimilarityMatrix(tab(0),tab(1),tab(1), tab(2))
		    'case 9
		    'M = new AffinityMatrix(tab(0),tab(1),tab(2), tab(0),tab(1),tab(3))
		    'case 10
		    'M = new IsometryMatrix(tab(0),tab(1),tab(3), tab(2))
		  end select
		  return M
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape(fa as integer, fo as integer)
		  dim a, b,  p,v,c as BasicPoint
		  dim d as double
		  dim i, n, ori as integer
		  dim M as matrix
		  
		  ori = 1
		  
		  select case fa
		  case 2 'Triangles
		    select case  fo
		    case 1 'TriIso
		      a = (tab(0)+tab(1))/2
		      b = tab(1)-tab(0)
		      b = b.vecnorperp
		      M = new OrthoProjectionMatrix(a,a+b)
		      tab(2) = M*tab(2)
		    case 2 'TriEqui
		    case 3 'TriRect
		    case 4 'TroRectIso
		    end select
		    
		  case 3 'Quadris
		    select case fo
		    case 7
		      constructshape(4,1)
		    end select
		  case 4 'Polreg
		    n = fo+3
		    p = (tab(0)+tab(1))/2
		    v = tab(1)-tab(0)
		    d = v.norme
		    if d <> 0 then
		      v = v.VecNorPerp
		      c = p + v*(ori*d/(2*tan(PI/n)))
		      M = new RotationMatrix(c,2*ori*PI/n)
		      v = tab(1)
		      for i = 2 to n-1
		        append M*tab(i-1)
		      next
		    end if
		  end select
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub nBPoint(p as BasicPoint)
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
		Function orientation() As integer
		  return 0
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
