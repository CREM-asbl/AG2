#tag Class
Protected Class LSkull
Inherits NSkull
	#tag Method, Flags = &h0
		Sub addcurve(n as integer)
		  dim cv as curveshape
		  dim i as integer
		  
		  select case n
		  case 0  'pour segments
		    cv = new curveshape
		    cv.Order = 0
		    append cv
		  case 1      'pour cercles et arcs de cercle
		    for i = 0 to 2
		      cv = new curveshape
		      cv.Order = 2
		      append cv
		    next
		  case 2  'Normalement inutile
		    cv = new curveshape
		    cv.Order = 2
		    append cv
		  end select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub addpoint(p as BasicPoint)
		  dim i as integer
		  dim cs as new curveshape
		  
		  cs.order = 0
		  cs.X=p.x
		  cs.Y=p.y
		  append cs
		  i=Count-1
		  
		  if i <> 0 then
		    item(i-1).X2=p.x
		    item(i-1).Y2=p.y
		  else
		    cs.X2=item(0).x     //on referme tjrs le lacet
		    cs.Y2=item(0).y    // si voulait définir un chemin, il faudrait utiliser le paramètre booléen "fin"
		  end if
		  cs.border = 100
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeExtreCtrl(i as integer,  nbp as nbpoint)
		  dim tbp as TriBPoint
		  dim j, ncurv, m as integer
		  
		  ncurv = 0
		  for j = 0 to i-1
		    if nbp.curved(j)=1 then
		      ncurv = ncurv+1
		    end if
		  next
		  
		  if nbp.curved(i) > 0 then
		    tbp = new TriBPoint(nbp.centres(i), nbp.tab(i), nbp.tab((i+1) mod nbp.taille))
		    tbp.CreateExtreAndCtrlPoints(tbp.ori)
		    
		    m= 2*ncurv
		    for j =0 to 1
		      nbp.extre(m+j) = tbp.extre(j)
		    next
		    
		    m= 6*ncurv
		    for j = 0 to 5
		      nbp.ctrl(m+j) = tbp.ctrl(j)
		    next
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeSkull(nbp as nBPoint)
		  dim i, n as integer
		  
		  n = nbp.taille-1
		  
		  for i = 0 to n-1
		    item(i).X=nBP.tab(i).X
		    item(i).Y=nBP.tab(i).Y
		    item(i).X2=nBP.tab((i+1) mod n).X
		    item(i).Y2=nBP.tab((i+1) mod n).Y
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(n as integer, p as basicPoint)
		  // Calling the overridden superclass constructor.
		  dim i as integer
		  
		  Super.Constructor(p)
		  for i = 0 to n-1
		    append new curveshape
		  next
		  fill = 0
		  'n est ici le nombre courbes, non le nombre de côtés
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Curspecs as StdPolygonSpecifications)
		  dim  q as BasicPoint  //utilisé par Workwindow.setico et seulement pour les icones (attention à l'inversion du sens des ordonnées)
		  dim i, n as integer
		  dim cap as double
		  dim nbp as nBPoint
		  
		  
		  ref = new BasicPoint(0,0)
		  q = new BasicPoint(0,0)
		  n = ubound(curspecs.angles)+2
		  x = 0
		  y = 0
		  Rotation  = curspecs.angles(0)
		  Scale = 1
		  nBP = new nBPoint
		  nBP.append q
		  cap = - curspecs.angles(i)
		  for i = 1 to n-1
		    q = new BasicPoint(cos(cap),sin(cap))
		    q = nBP.tab(i-1)+ q * Curspecs.distances(i-1)
		    nBP.append  q  
		    if i < n-1 then
		      cap = cap - curspecs.angles(i)
		    end if
		  next
		  
		  for i = 0 to n-1
		    append new curveshape
		    item(i).X=nBP.tab(i).X
		    item(i).Y=nBP.tab(i).Y
		    item(i).X2=nBP.tab((i+1) mod n).X
		    item(i).Y2=nBP.tab((i+1) mod n).Y
		  next
		  
		  BB = nBP.ComputeBoundingBox
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCurve(n as integer) As curveshape
		  return item(n)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSide(n as integer) As integer
		  'retourne le n° de la seule  ou de la première des curveshapes qui constituent le côté
		  
		  dim j, k as integer
		  
		  k = 0
		  for j = 0 to n-1
		    if skullof.coord.curved(j) = 0 then
		      k = k+1
		    else
		      k = k+3
		    end if
		  next
		  
		  return k
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertPoint(p as basicpoint, n as integer)
		  'cotes.insert (n,new curveshape)
		  'FigureShape(CC).insert (n,cotes(n))
		  '
		  'cotes(n).X=p.x
		  'cotes(n).Y=p.y
		  '
		  'cotes(n-1).X2=p.x
		  'cotes(n-1).Y2=p.y
		  '
		  'cotes(n).X2=cotes(0).x                '(n+1)mod (Ubound(cotes)+1)).X
		  'cotes(n).Y2=cotes(0).y                '(n+1)mod (Ubound(cotes)+1)).Y
		  '
		  '
		  'cotes(n).order = 0
		  'cotes(n).border = 100
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paintside(g as graphics, i as integer, ep as double, coul as couleur)
		  dim n, j as integer
		  
		  n = getside(i)
		  
		  if skullof.coord.curved(i) = 0 then
		    item(n).borderwidth = ep*borderwidth
		    item(n).bordercolor = coul.col
		    g.drawobject item(n), ref.x, ref.y
		  else
		    for j = 0 to 2
		      item(n+j).borderwidth = ep*borderwidth
		      item(n+j).bordercolor = coul.col
		      g.drawobject item(n+j), ref.x, ref.y
		    next
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update(s as shape)
		  dim i, j as integer
		  dim p as BasicPoint
		  
		  p =s.getgravitycenter
		  ref = can.transform(p)
		  x = ref.x
		  y = ref.y
		  
		  if s isa Bande then
		    updateBande(Bande(s))
		    return 
		  end if
		  
		  if s isa Secteur then
		    updateSecteur(Secteur(s))
		    return
		  end if
		  
		  for i = 0 to s.npts-1
		    if dret = nil then
		      ComputeExtreCtrl(i, s.coord)
		    end if
		    updateside(i, s.coord, p)
		  next
		  
		  fixecouleurs(s)
		  fixeepaisseurs(s)
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateBande(s as Bande)
		  dim i as integer
		  dim p as BasicPoint
		  
		  p =s.getgravitycenter
		  
		  
		  for i = 0 to 3
		    updatesideBande(i, s.skullcoord, p)
		  next
		  
		  fixecouleurs(s)
		  fixeepaisseurs(s)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateSecteur(s as Secteur)
		  dim i, j as integer
		  dim p as BasicPoint
		  
		  p =s.getgravitycenter
		  '
		  'for i = 0 to 2
		  'updatesideSecteur(i, s.skullcoord, p)
		  'next
		  
		  for i = 0 to s.npts-1
		    if dret = nil then
		      ComputeExtreCtrl(i, s.skullcoord)
		    end if
		    updateside(i, s.skullcoord, p)
		  next
		  
		  fixecouleurs(s)
		  fixeepaisseurs(s)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateside(i as integer,  nbp as nbpoint, gc as basicpoint)
		  dim q as BasicPoint
		  dim k, j, ncurv, m as integer
		  
		  k = getSide(i)
		  
		  if nbp.curved(i) = 0 then
		    q = can.dtransform(nbp.tab(i)-gc)
		    item(k).x = q.x
		    item(k).y = q.y
		    q = can.dtransform(nbp.tab((i+1) mod nbp.taille)-gc)
		    item(k).x2 = q.x
		    item(k).y2 = q.y
		  else
		    ncurv = 0
		    for j = 0 to i-1
		      if nbp.curved(j)=1 then
		        ncurv = ncurv+1
		      end if
		    next
		    m = 2*ncurv
		    q = can.dtransform(nbp.tab(i)-gc)
		    item(k).x = q.x
		    item(k).y = q.y
		    q = can.dtransform(nbp.extre(m)-gc)
		    item(k).X2=q.x
		    item(k).y2=q.y
		    item(k+1).x = q.x
		    item(k+1).y = q.y
		    q = can.dtransform(nbp.extre(m+1)-gc)
		    item(k+1).x2 = q.x
		    item(k+1).y2= q.y
		    item(k+2).x = q.x
		    item(k+2).y= q.y
		    q = can.dtransform(nbp.tab((i+1) mod nbp.taille)-gc)
		    item(k+2).x2 = q.x
		    item(k+2).y2 = q.y
		    
		    m = 6*ncurv
		    q = can.dtransform(nbp.ctrl(m) -gc)
		    item(k).controlx(0) = q.x
		    item(k).controly(0) = q.y
		    q = can.dtransform(nbp.ctrl(m+1) -gc)
		    item(k).controlx(1) = q.x
		    item(k).controly(1) = q.y
		    q = can.dtransform(nbp.ctrl(m+2) -gc)
		    item(k+1).controlx(0) = q.x
		    item(k+1).controly(0) = q.y
		    q = can.dtransform(nbp.ctrl(m+3) -gc)
		    item(k+1).controlx(1) = q.x
		    item(k+1).controly(1) = q.y
		    q = can.dtransform(nbp.ctrl(m+4) -gc)
		    item(k+2).controlx(0) = q.x
		    item(k+2).controly(0) = q.y
		    q = can.dtransform(nbp.ctrl(m+5) -gc)
		    item(k+2).controlx(1) = q.x
		    item(k+2).controly(1) = q.y
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesidebande(i as integer,  nbp as nbpoint, gc as basicpoint)
		  dim q as BasicPoint
		  
		  q = can.dtransform(nbp.tab(i)-gc)
		  item(i).x = q.x
		  item(i).y = q.y
		  q = can.dtransform(nbp.tab((i+1) mod nbp.taille)-gc)
		  item(i).x2 = q.x
		  item(i).y2 = q.y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateSideSecteur(i as integer,  nbp as TriBpoint, gc as basicpoint)
		  dim q(2) as BasicPoint
		  
		  'q = can.dtransform(nbp.tab()-gc)
		  'item(i).x = q.x
		  'item(i).y = q.y
		  'q = can.dtransform(nbp.tab((i+1) mod nbp.taille)-gc)
		  'item(i).x2 = q.x
		  'item(i).y2 = q.y
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="angle"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderColor"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderWidth"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="currentcurve"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FillColor"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
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
			Name="Rotation"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Scale"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
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
		#tag ViewProperty
			Name="X"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Y"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
