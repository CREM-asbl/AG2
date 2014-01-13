#tag Class
Protected Class Intersec
Implements StringProvider
	#tag Method, Flags = &h0
		Sub Intersec(s1 as shape, s2 as shape)
		  
		  sh1 = s1
		  sh2 = s2
		  
		  if s1 isa circle and s2 isa circle then
		    if s1.id > s2.id then
		      sh1 = s2
		      sh2 = s1
		    end if
		  elseif sh1 isa circle and not sh2 isa circle then
		    sh1 = s2
		    sh2 = s1  //le cercle est sh2
		  end if
		  
		  if sh1 isa droite then
		    nlig = 0
		  elseif sh1 isa bande or sh1 isa secteur then
		    nlig = 1
		  elseif sh1 isa circle then
		    nlig = 0
		  else
		    nlig = sh1.npts-1
		  end if
		  
		  if sh2 isa droite then
		    ncol = 0
		  elseif sh2 isa bande or sh2 isa secteur then
		    ncol = 1
		  elseif sh2 isa circle then
		    ncol = 1
		  else
		    ncol = sh2.npts-1
		  end if
		  
		  redim bptinters(nlig, ncol)
		  redim ids(nlig,ncol)
		  redim val(nlig,ncol)
		  redim pts(-1)
		  
		  computeinter
		  
		  ' bptsinter est la liste de tous les points d'inter possibles des droites supports des cotés de sh1 et de sh2
		  ' val indique si ces points appartiennent aux cotes eux-memes et que les points peuvent donc etre validés
		  'points est un tableau de (pointeurs vers les) points d'intersection effectivement présents
		  'pts est la liste de ces points dans leur ordre de construction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Addpoint(p as point)
		  dim n, i1, i2, j1, j2, h, k as integer  //Utilisé dans Point.adjustinter et shape.valider
		  dim bp as BasicPoint
		  dim d as Double
		  
		  if pts.indexof(p) <> -1 then
		    return
		  end if
		  
		  // différent de la version du 19/08/12
		  
		  d = nearest(p,i1,j1)
		  if bezet(i1,j1) or (d > wnd.mycanvas1.magneticdist and currentcontent.currentoperation isa shapeconstruction)  then
		    p.invalider
		    return
		  end if
		  
		  if i1 <> -1 and j1 <> -1 and bptinters(i1,j1) <> nil   then
		    p.puton sh1
		    p.puton sh2
		    pts.append p
		    p.moveto bptinters(i1,j1)
		    bezet(i1,j1) = true
		    ids(i1,j1) = p.id
		    setlocation(p,i1,j1)
		    if val(i1,j1) and (p.conditionedby=nil or not point(p.conditionedby).invalid) then
		      p.valider
		    else
		      p.invalider
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update()
		  dim i,j as integer
		  dim p as shape
		  
		  computeinter
		  
		  for i = 0 to nlig
		    for j = 0 to ncol
		      p = currentcontent.TheObjects.getshape(ids(i,j))
		      if p isa point then
		        replacerphase1(point(p))
		      end if
		    next
		  next
		  
		  
		  for i = 0 to nlig
		    for j = 0 to ncol
		      p = currentcontent.TheObjects.getshape(ids(i,j))
		      if p isa point then
		        replacerphase2(point(p))
		      end if
		    next
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeinter()
		  dim i, j as integer
		  
		  
		  init
		  
		  if not sh1 isa circle then
		    if not sh2 isa circle then
		      computeinterlines
		    else
		      computeinterlines_circle
		      if sh2 isa arc then
		        for i = 0 to nlig
		          for j = 0 to 1
		            if val(i,j) then
		              val(i,j) = arc(sh2).inside(bptinters(i,j) )
		            end if
		          next
		        next
		      end if
		    end if
		  else
		    computeintercercles
		  end if
		  
		  positionfalseinterpoints
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub init()
		  dim i, j as integer
		  
		  redim reset(nlig,ncol)
		  redim bezet(nlig,ncol)
		  redim ids(nlig, ncol)
		  
		  for i = 0 to nlig
		    for j = 0 to ncol
		      bptinters(i,j) = nil
		      val(i,j) = true
		      bezet(i,j) = false
		      reset(i,j) = false
		    next
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub replacerphase1(pt as point)
		  dim   h, k as integer
		  
		  h = pt.numside(0)     'On mémorise l'ancienne position
		  k = pt.numside(1)
		  
		  if val(h,k) then
		    validerpoint(pt,h,k)
		    reset(h,k) = true
		  end if
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeinterlines()
		  dim i, j,k as integer
		  dim bp as basicpoint
		  dim d1, d2 as droite
		  dim r1,r2 as double
		  
		  for i = 0 to nlig
		    d1 = sh1.getside(i)
		    for j = 0 to ncol
		      bp = nil
		      d2 = sh2.getside(j)
		      if not(sh1 isa droite and droite(sh1).parallelto(sh2,j)) and not (sh2 isa droite and droite(sh2).parallelto(sh1,i)) then
		        k = d1.inter(d2,bp,r1,r2)
		        if bp <> nil then
		          bptinters(i,j) = bp
		        end if
		        if k = 0 then
		          val(i,j) = false
		        end if
		      else
		        val(i,j) = false
		      end if
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeinterlines_circle()
		  dim i, j,k as integer
		  dim   b, w, p() as basicpoint
		  dim d1 as droite
		  dim  g2 as circle
		  
		  
		  for i = 0 to nlig
		    d1 = sh1.getside(i)
		    g2 = circle(sh2)
		    redim p(1)
		    b = new BasicPoint(0,0)
		    w = new BasicPoint(0,0)
		    k = d1.inter(g2,p(),b,w)
		    
		    select case k
		    case 0
		      bptinters(i,0) = p(0)
		      bptinters(i,1) = p(1)
		      val(i,0) = false
		      val(i,1) = false
		    case 1
		      if w.norme > epsilon then
		        bptinters(i,0) = b-w
		        bptinters(i,1) = b+w
		        val(i,0) =false
		        val(i,1)= false
		      else
		        bptinters(i,0) = b
		        val(i,1) = false
		      end if
		    case 2
		      bptinters(i,0) = p(0)
		      bptinters(i,1) = p(1)
		      select case  d1.nextre
		      case 1
		        for j = 0 to 1
		          if not p(j).audela(d1.firstp, d1.secondp) then
		            val(i,j) = false
		          end if
		        next
		      case 2
		        for j = 0 to 1
		          if not p(j).between(d1.firstp, d1.secondp) then
		            val(i,j) = false
		          end if
		        next
		      end select
		    end select
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function nbnear(q as Point) As integer
		  dim i, m  as integer
		  dim bp as basicpoint
		  
		  
		  for i = 0 to ubound(pts)
		    if (q <> pts(i)) and (q.bpt.distance(pts(i).bpt) < epsilon) then
		      m = m+1
		    end if
		  next
		  
		  return m //nombre d'autres points d'inter tout proches
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Removepoint(p as point)
		  
		  pts.remove pts.indexof(p)
		  
		  
		  if  ubound(pts) = -1 then
		    CurrentContent.TheIntersecs.removeintersec self
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeintercercles()
		  dim k as integer
		  dim bq() as basicpoint
		  dim t2(-1) as boolean
		  dim g1, g2 as circle
		  
		  g1 = circle(sh1)
		  g2 = circle(sh2)
		  k = g1.inter(g2,bq())
		  
		  if  k = 0 then
		    bq.append nil
		    bq.append nil
		  end if
		  
		  bptinters(0,0) = bq(0)
		  bptinters(0,1) = bq(1)
		  
		  select case k
		  case 0
		    val(0,0) = false
		    val(0,1) = false
		  end select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function nearest(pt as point, byref i1 as integer, byref j1 as integer) As double
		  dim r1, s as double
		  dim i, j, h, k as integer
		  
		  r1 = 10000
		  
		  if pt.pointsur.count = 2 then
		    h = pt.numside(0)
		    k = pt.numside(1)
		    if  val(h,k) and (not bezet(h,k) ) and pt.bpt.distance(bptinters(h,k))  < epsilon then
		      i1 = h
		      j1 = k
		      return 0
		    end if
		  end if
		  
		  i1 = h
		  j1 = k
		  for i = 0 to nlig
		    for j = 0 to ncol
		      if val(i,j) and (not bezet(i,j))  then
		        s = pt.bpt.distance(bptinters(i,j))
		        if abs(s) < r1 then
		          r1 = s
		          i1 = i
		          j1 = j
		        end if
		      end if
		    next
		  next
		  
		  
		  
		  return r1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update(p as point, s1 as shape, n1 as integer, s2 as shape, n2 as integer)
		  dim n as integer
		  
		  if sh1 = s2 then
		    n = n1
		    n1 = n2
		    n2 = n
		  end if
		  
		  //Utilisé par figure.restoreinit
		  computeinter
		  replacerphase1(p)
		  replacerphase2(p)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub positionfalseinterpoints()
		  //Les faux points d'intersection sont les  sommets communs aux deux formes sh1 ou sh2
		  // ou les sommets de l'un qui sont pointsur sur l'autre. Ces points n'ont pas le statut de pointinter mais occupent la place
		  //d'un point inter. Celle-ci doit être mentionnée comme occupée. On les calcule en premier lieu.
		  //Idem pour les points de subdivision
		  
		  dim i,h,k as integer
		  dim p as point
		  
		  for h = 0 to nlig
		    for k = 0 to ncol
		      if bptinters(h,k) <> nil then
		        for i = 0 to ubound(sh1.childs)
		          if   sh2.getindex(sh1.childs(i)) <> -1 and sh1.childs(i).pointsur.count < 2  and  sh1.childs(i).bpt.distance(bptinters(h,k)) < epsilon then
		            bezet(h, k) = true      ' on ne peut placer aucun vrai pt d'inter ici
		          end if
		        next
		        for i = 0 to ubound(sh2.childs)
		          if   sh1.getindex(sh2.childs(i)) <> -1 and sh2.childs(i).pointsur.count < 2  and  sh2.childs(i).bpt.distance(bptinters(h,k)) < epsilon then
		            bezet(h, k) = true      ' ici non plus
		          end if
		        next
		        for i = 0 to ubound(sh1.constructedshapes)
		          if sh1.constructedshapes(i) isa point  then
		            p = point(sh1.constructedshapes(i))
		            if p.constructedby.oper = 4 and sh1.pointonside(p.bpt)= h and  p.bpt.distance (bptinters(h,k)) < epsilon then 'p.constructedby.data(4)
		              bezet(h,k) = true
		            end if
		          end if
		        next
		        for i = 0 to ubound(sh2.constructedshapes)
		          if sh2.constructedshapes(i) isa point  then
		            p = point(sh2.constructedshapes(i))
		            if p.constructedby.oper = 4 and sh2.pointonside(p.bpt) = k and  p.bpt.distance (bptinters(h,k)) < epsilon then ' .constructedby.data(4)
		              bezet(h,k) = true
		            end if
		          end if
		        next
		      end if
		    next
		  next
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setlocation(p as point, i as integer, j as integer)
		  p.numside(0) = i
		  p.numside(1) = j
		  if  not sh1 isa circle then
		    p.location(0) = bptinters(i,j).location(sh1,i)
		  else
		    p.location(0) = bptinters(i,j).location(circle(sh1))
		  end if
		  if  not sh2 isa circle then
		    p.location(1) = bptinters(i,j).location(sh2,j)
		  else
		    p.location(1) = bptinters(i,j).location(circle(sh2))
		  end if
		  
		Exception err
		  dim d As Debug
		  d = new Debug
		  d.setMethod(getString,"setlocation")
		  d.setVariable("p",p)
		  d.setVariable("i",i)
		  d.setVariable("j",j)
		  d.setVariable("sh1",sh1)
		  d.setVariable("sh2",sh2)
		  err.message = err.message+d.getString
		  
		  Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As String
		  return "Intersec"
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToMac(Doc as XMLDocument, EL as XMLElement)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub validerpoint(pt as point, i as integer, j As integer)
		  if bezet(i,j) = false then
		    pt.moveto bptinters(i,j)
		    bezet(i,j) = true
		    if val(i,j) and  not sh1.invalid and not sh2.invalid then
		      setlocation(pt,i,j)
		      pt.modified = true
		      pt.updateshape
		      pt.valider
		    end if
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub replacerphase2(pt as point)
		  dim   i1, j1, h, k as integer
		  dim d as double
		  dim s as shape
		  
		  h = pt.numside(0)     'On mémorise l'ancienne position
		  k = pt.numside(1)
		  
		  if reset(h,k) then
		    return
		  end if
		  
		  d =nearest(pt,i1,j1)
		  if  (not (sh1 isa circle) and not(sh2 isa circle)) or (sh1 isa circle and sh2 isa circle)  then
		    // on ne risque de changer un pt d'inter de côté que s'il n'existe aucun autre pt d'inter dans son voisinage et que pas de probl de parallelisme --ou perp
		    // peut être en défaut si A// B et B//C et que A inter C est calculé // prévoir la transitivité
		    if  ((i1 <> h  or  j1 <> k) and not bezet(h,k) and val(h,k) and nbnear(pt) > 0) or (sh1.isaparaperp(s) and s = sh2) then
		      i1 = h
		      j1 = k
		    end if
		  elseif not (sh1 isa circle) or not (sh2 isa circle) then
		    i1 = h
		    j1 = k
		  end if
		  
		  ids(i1,j1) = pt.id
		  if not val(i1,j1) then
		    pt.invalider
		  else
		    validerpoint(pt,i1,j1)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function locatepoint(p as BasicPoint) As basicPoint
		  dim i, j, i1, j1  as integer
		  dim r1, s as double
		  
		  r1  = 10000
		  for i = 0 to nlig
		    for j = 0 to ncol
		      if val(i,j) and (not bezet(i,j))  then
		        s = p.distance(bptinters(i,j))
		        if abs(s) < r1 then
		          r1 = s
		          i1 = i
		          j1 = j
		        end if
		      end if
		    next
		  next
		  
		  if  bezet(i1,j1) or (r1 > wnd.mycanvas1.magneticdist and currentcontent.currentoperation isa shapeconstruction)  then
		    return nil
		  else
		    return bptinters(i1,j1)
		  end if
		  
		  //détermine la position valide et libre la plus proche
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		sh1 As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		sh2 As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		bptinters(-1,-1) As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		val(-1,-1) As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		nlig As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ncol As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		pts(-1) As point
	#tag EndProperty

	#tag Property, Flags = &h0
		drap As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		bezet(-1,-1) As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ids(-1,-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		reset(-1,-1) As Boolean
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
			Name="nlig"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncol"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drap"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
