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
		  
		  if nbp.curved(i) = 0 then
		    return
		  end if
		  
		  ncurv = 0
		  for j = 0 to i-1
		    if nbp.curved(j)=1 then
		      ncurv = ncurv+1
		    end if
		  next
		  
		  
		  tbp = new TriBPoint(nbp.centres(i), nbp.tab(i), nbp.tab((i+1) mod nbp.taille))
		  tbp.CreateExtreAndCtrlPoints(skullof.ori)
		  
		  m= 2*ncurv
		  for j =0 to 1
		    nbp.extre(m+j) = tbp.extre(j)
		  next
		  
		  m= 6*ncurv
		  for j = 0 to 5
		    nbp.ctrl(m+j) = tbp.ctrl(j)
		  next
		  
		  
		  
		  
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
		Sub Constructor(n as integer, p as BasicPoint)
		  // Calling the overridden superclass constructor.
		  dim i as integer
		  
		  Super.Constructor(p)
		  for i = 0 to n-1
		    append new curveshape
		  next
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
		Sub fixecouleurs(s as shape)
		  dim i, j, n, b, f as integer
		  dim col as color
		  dim sideinsupport as boolean
		  
		  b = s.border
		  f= s.fill
		  if b = 0 then
		    b = 100
		  end if
		  
		  'Concernant le fond
		  
		  if s.hidden or s.tsp or s.isinconstruction then
		    updatefillcolor(s.fillcolor.col,0)
		  else
		    updatefillcolor(s.fillcolor.col,f)
		  end if
		  
		  'Concernant le bord
		  
		  if s.hidden then
		    col = config.HideColor.col
		  elseif s.highlighted then
		    col = config.HighlightColor.col
		  elseif s.isinconstruction then
		    col = config.weightlesscolor.col
		    b = 100
		  elseif s.tracept then
		    col = bleu
		    b = 100
		  end if 
		  ''
		  'if ubound(s.tsfi) > -1 then
		  'sideissupport = true
		  'end if
		  
		  if s isa Bande  then
		    updatesidecolor (s, 0, col, b)
		    updatesidecolor (s, 2, col, b)
		  elseif s isa secteur then
		    updatesidecolor(s,0,col,b)
		    updatesidecolor(s,2,col,b)
		  else
		    for i = 0 to s.npts-1
		      updatesidecolor (s,i,col, b)
		    next
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fixeepaisseurs(s as shape)
		  dim  i as integer
		  dim c as double
		  c = s.borderwidth
		  
		  if (s.isinconstruction  or s.selected ) and not s.tracept then
		    if s isa Bande  then
		      updatecurvewidth (s, 0,1.5*c)
		      updatecurvewidth (s, 2,1.5*c)
		    elseif s isa Secteur then
		      s.nsk.item(0).borderwidth =1.5*c
		      s.nsk.item(4).borderwidth =1.5*c 
		    else
		      for i = 0 to s.npts-1
		        updatecurvewidth(s,i,1.5*c)
		      next
		    end if
		  else
		    if s isa Bande  then
		      updatecurvewidth (s, 0, c)
		      updatecurvewidth (s, 2, c)
		    elseif s  isa Secteur then
		      s.nsk.item(0).borderwidth = c
		      s.nsk.item(4).borderwidth = c 
		    else
		      for i = 0 to s.npts-1
		        updatecurvewidth(s,i,c)
		      next
		    end if
		  end if
		  
		  
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
		  
		  if skullof isa Bande  then
		    return n
		  elseif skullof isa secteur then
		    return 2*n
		  else
		    k = 0
		    for j = 0 to n-1
		      if skullof.coord.curved(j) = 0 then
		        k = k+1
		      else
		        k = k+3
		      end if
		    next
		    
		    return k
		  end if
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
		Sub oldConstructor(n as integer, p as basicPoint, sh as shape)
		  // Calling the overridden superclass constructor.
		  dim i, j, k as integer
		  
		  Super.Constructor(p)
		  for i = 0 to n-1
		    append new curveshape
		  next
		  i = 0
		  for j = 0 to sh.npts-1
		    if sh.coord.curved(j) = 0 then
		      item(i).order = 0
		      i = i+1
		    else
		      for k = 0 to 2
		        item(i+k).order = 2
		      next
		      i = i+3
		    end if
		  next
		  fill = 0
		  'n est ici le nombre de curveshapes, non le nombre de côtés
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics)
		  dim i as integer
		  
		  if fill > 0 then
		    border = 0
		    g.drawobject self, x, y
		  end if
		  
		  if not self.skullof isa Secteur then
		    for i = 0 to count-1
		      g.drawobject item(i), x, y
		    next
		  else
		    g.drawobject item(0),x,y
		    g.drawobject item(4),x,y
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics, i as integer, c as couleur, t as integer)
		  'Utilisé exclusivement pour afficher les transformations
		  
		  dim j as integer
		  
		  
		  if count > 1 then  '1 Translations 6 symétries sur coté lacet 2 Rotations sur Hybrid, 
		    if  t < 7  then
		      if i <> -1 then
		        item(i).bordercolor = c.col 'updatecurvecolor(supp, i, coul.Col, supp.border)
		        g.DrawObject item(i), ref.x, ref.y 'Lskull(supp.nsk).paintside(g,index,1.5,coul)
		      end if
		    else
		      for i = 0 to count -1
		        item(i).borderwidth = 1.5*borderwidth
		        item(i).bordercolor = c.col
		        g.drawobject item(i), ref.x, ref.y
		      next
		    end if
		  end if
		  
		  
		  
		  
		  'if self isa point then
		  'point(self).rsk.updatecolor(c.col,100)
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paintside(g as graphics, i as integer, ep as double, coul as couleur)
		  dim n, j as integer
		  
		  n = getside(i)
		  
		  if skullof.coord.curved(i) = 0 then
		    item(n).borderwidth = ep*borderwidth
		    g.drawobject item(n), ref.x, ref.y
		  else
		    for j = 0 to 2
		      item(n+j).borderwidth = ep*borderwidth
		      g.drawobject item(n+j), ref.x, ref.y
		    next
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PositionnerCotesCourbes()
		  dim n, k as integer
		  
		  
		  for n = 0 to skullof.npts-1
		    if skullof.coord.curved(n) = 1 then
		      k = GetSide(n)
		      item(k).order = 2
		      item(k+1).order = 2
		      item(k+2).order = 2
		    end if
		  next
		  
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
		  elseif s isa Secteur then
		    updateSecteur(Secteur(s))
		  else
		    for i = 0 to s.npts-1
		      if dret = nil then
		        ComputeExtreCtrl(i, s.coord)
		      end if
		      updateside(i, s.coord, p)
		    next
		  end if 
		  
		  'fixecouleurs(s)
		  'fixeepaisseurs(s)
		  
		  
		  
		  
		  
		  
		  
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
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatecurvecolor(s as shape, i as integer, col as color, c as double)
		  
		  dim  m, n as integer
		  
		  n = GetSide(i)
		  if s.coord.curved(i) = 0 then
		    s.nsk.item(n).bordercolor = col
		    s.nsk.item(n).border = c
		  else
		    for m = 0 to 2
		      s.nsk.item(n+m).bordercolor = col
		      s.nsk.item(n+m).border = c
		    next
		    
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatecurvewidth(s as shape, i as integer, c as double)
		  dim j, m, n as integer
		  
		  n = getside(i)
		  
		  if s.coord.curved(i) = 0 then
		    s.nsk.item(n).borderwidth = c
		  else
		    for m = 0 to 2
		      s.nsk.item(n+m).borderwidth = c
		    next
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateSecteur(s as Secteur)
		  dim i, j as integer
		  dim p as BasicPoint
		  
		  p =s.getgravitycenter
		  if dret = nil then
		    ComputeExtreCtrl(1, s.skullcoord)
		  end if
		  for i = 0 to 2
		    updatesideSecteur(i, s.skullcoord, p)
		  next
		  
		  
		  
		  
		  
		  
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
		Sub updatesideBande(i as integer,  nbp as nbpoint, gc as basicpoint)
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
		Sub updatesidecolor(s as shape, i as integer, col as color, b as integer)
		  
		  
		  if s.hidden  or s.isinconstruction or s.tracept Then
		    updatecurvecolor(s,i, col,b)
		  elseif s.highlighted and currentcontent.currentoperation <> nil and not currentcontent.currentoperation.colsep then
		    updatecurvecolor(s,i, col,b)
		  elseif s.highlighted then
		    if s.side = -1  or s.side = i then  'cas des segments sélectionnés par une opération
		      updatecurvecolor(s,i, col,b)
		    else
		      updatecurvecolor(s,i,s.colcotes(i).col,b)
		    end if
		  else
		    updatecurvecolor(s,i, s.colcotes(i).col, b)
		  end if
		  
		  
		  '
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateSideSecteur(i as integer,  nbp as TriBpoint, gc as basicpoint)
		  dim q as BasicPoint
		  
		  if i = 0 then
		    q = can.dtransform(nbp.tab(0)-gc)
		    item(0).x = q.x
		    item(0).y = q.y
		    q = can.dtransform(nbp.tab(1)-gc)
		    item(0).x2 = q.x
		    item(0).y2 = q.y
		  elseif i = 1 then
		    q = can.dtransform(nbp.tab(1)-gc)
		    item(1).x = q.x
		    item(1).y = q.y
		    q = can.dtransform(nbp.extre(0)-gc)
		    item(1).X2=q.x
		    item(1).y2=q.y
		    item(2).x = q.x
		    item(2).y = q.y
		    q = can.dtransform(nbp.extre(1)-gc)
		    item(2).x2 = q.x
		    item(2).y2= q.y
		    item(3).x = q.x
		    item(3).y= q.y
		    q = can.dtransform(nbp.tab(2) -gc)
		    item(4).x2 = q.x
		    item(4).y2 = q.y
		    
		    q = can.dtransform(nbp.ctrl(0) -gc)
		    item(1).controlx(0) = q.x
		    item(1).controly(0) = q.y
		    q = can.dtransform(nbp.ctrl(1) -gc)
		    item(1).controlx(1) = q.x
		    item(1).controly(1) = q.y
		    q = can.dtransform(nbp.ctrl(2) -gc)
		    item(2).controlx(0) = q.x
		    item(2).controly(0) = q.y
		    q = can.dtransform(nbp.ctrl(3) -gc)
		    item(3).controlx(1) = q.x
		    item(3).controly(1) = q.y
		    q = can.dtransform(nbp.ctrl(4) -gc)
		    item(4).controlx(0) = q.x
		    item(4).controly(0) = q.y
		    q = can.dtransform(nbp.ctrl(5) -gc)
		    item(4).controlx(1) = q.x
		    item(4).controly(1) = q.y
		  elseif i=2 then
		    q = can.dtransform(nbp.tab(2)-gc)
		    item(4).x = q.x
		    item(4).y = q.y
		    q = can.dtransform(nbp.tab(0)-gc)
		    item(4).x2 = q.x
		    item(4).y2 = q.y
		  end if
		  
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
