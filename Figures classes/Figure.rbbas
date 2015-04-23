#tag Class
Protected Class Figure
Implements StringProvider
	#tag Method, Flags = &h0
		Sub Figure(s as shape)
		  dim ff as figure
		  
		  Figure
		  
		  ff = new Figure
		  ff.supfig = self
		  ff.shapes.addshape s
		  ff.insererpoints(s)
		  ff.auto = s.auto
		  
		  subs.addfigure ff
		  Shapes.addshape s
		  InsererPoints(s)
		  s.fig = self
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsererPoints(s as shape)
		  dim i as integer
		  
		  if s isa point then
		    somm.addshape s
		    s.fig = self
		  else
		    for i = 0 to ubound(s.points)
		      somm.addshape s.points(i)
		      s.points(i).fig = self
		    next
		  end if
		  
		  for i = s.npts to ubound(s.childs)
		    ptssur.addshape s.childs(i)
		    s.childs(i).fig = self
		  next
		  
		  for i = 0 to ubound(s.constructedshapes)
		    if s.constructedshapes(i).centerordivpoint then
		      ptsconsted.addshape s.constructedshapes(i)
		      s.constructedshapes(i).fig = self
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbPtsCommuns(f as figure) As integer
		  dim i,j,n as integer
		  dim p as point
		  
		  n = NbSommCommuns(f)
		  
		  if supfig <> nil and f.supfig <> nil then
		    for i = 0 to Somm.count-1
		      for j = 0 to f.Ptssur.count -1
		        p = Point(f.ptssur.element(j))
		        if somm.element(i) = p and f.Somm.getposition(p) = -1 and f.PtsConsted.getposition(p) = -1  then
		          if p.pointsur.count =2 and  p.pointsur.element(0).getsousfigure(f.supfig) = f and p.pointsur.element(1).getsousfigure(f.supfig) = f then
		            n = n+1
		          end if
		        end if
		      next
		    next
		    
		    for i = 0 to f.Somm.count-1
		      for j = 0 to Ptssur.count -1
		        p = Point(ptssur.element(j))
		        if f.somm.element(i) = p  and Somm.getposition(p) = -1 and PtsConsted.getposition(p) = -1  then
		          if p.pointsur.count =2 and  p.pointsur.element(0).getsousfigure(supfig) = self and p.pointsur.element(1).getsousfigure(supfig) = self then
		            n = n+1
		          end if
		        end if
		      next
		    next
		  end if
		  
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbPtsModif() As integer
		  dim i as integer
		  Redim ListPtsModifs(-1)
		  //Décompte et liste les sommets de la figure qui ont déjà été modifiés
		  
		  NbModif = 0
		  
		  
		  for i = 0 to Somm.count-1
		    if  somm.element(i).modified   then
		      NbModif = NbModif+1
		      ListPtsModifs.append i
		    end if
		  next
		  
		  return NbModif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbSommSur(n0 as integer) As integer
		  dim i, n as integer
		  Redim ListSommSur(-1)
		  dim p as point
		  
		  // Liste des "sommets sur"  non modifiés  différents du point modifié
		  for i = 0 to Somm.count-1
		    if i <> n0 then
		      p = Point(somm.element(i))
		      if (p.pointsur.count = 1 or (p.guide <> nil and p.guide <> p) ) and P.liberte = 1 and not p.modified then
		        n = n+1
		        ListSommSur.append i
		      end if
		    end if
		  next
		  
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Save()
		  dim i, j as integer
		  dim s as Lacet
		  
		  redim invalidpts(-1)
		  redim invalidptscsted(-1)
		  redim invalidptssur(-1)
		  
		  
		  if ubound(oldbpts) <> -1 then
		    return
		  end if
		  
		  for i = 0 to somm.count-1
		    oldbpts.append point(somm.element(i)).bpt
		    if point(somm.element(i)).invalid then
		      InvalidPts.append i
		    end if
		  next
		  
		  for i = 0 to ptsconsted.count-1
		    oldptscsted.append point(ptsconsted.element(i)).bpt
		    if point(ptsconsted.element(i)).invalid then
		      InvalidPtsCsted.append i
		    end if
		  next
		  
		  
		  for i = 0 to ptssur.count-1
		    oldptssur.append point(ptssur.element(i)).bpt
		    if point(ptssur.element(i)).invalid then
		      InvalidPtssur.append i
		    end if
		  next
		  
		  for i = 0 to shapes.count-1
		    if shapes.element(i) isa Lacet  then
		      s = Lacet(shapes.element(i))
		      for j = 0 to s.npts-1
		        if s.coord.curved(j) = 1 then
		          oldcentres.append s.coord.centres(j)
		        end if
		      next
		    end if
		  next
		  
		  
		  for i = 0 to subs.count - 1
		    subs.element(i).save
		  next
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Restore()
		  dim i as integer
		  dim ori as double
		  dim a as double
		  
		  if ubound(oldbpts) > -1 then
		    Restorebpt
		    RestoreLab
		    Restoretsf
		    for i = 0 to subs.count - 1
		      subs.element(i).restore
		    next
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbSubFig(p as point) As integer
		  dim i, n as integer
		  
		  for i = 0 to subs.count-1
		    if subs.element(i).somm.getposition(p) <> -1 or subs.element(i).PtsConsted.getposition(p) <> - 1 or subs.element(i).PtsSur.getposition(p) <> -1 then
		      n = n+1
		    end if
		  next
		  
		  return n
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasCommonPointWithPreceding(k as integer) As Boolean
		  dim i,j, n as integer
		  dim ff as figure
		  
		  for i = 0 to k
		    n = supfig.index(i)
		    ff = supfig.subs.element(n)
		    
		    if NbPtsCommuns(ff) > 0 then
		      return true
		    end if
		    
		    for j = 0 to ff.PtsSur.count-1
		      if Somm.getposition(ff.PtsSur.element(j)) <> -1 then
		        return true
		      end if
		    next
		    
		    for j = 0 to PtsSur.count-1
		      if ff.somm.getposition(PtsSur.element(j)) <> -1 then
		        return true
		      end if
		      if ff.PtsSur.getposition(PtsSur.element(j)) <> - 1 then
		        return true
		      end if
		    next
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function subfigupdate() As Boolean
		  dim M as Matrix
		  dim s as shape
		  
		  NbUnModif = 0
		  select case auto
		  case 0
		    if standard then
		      M = autosimupdate
		      if M<>nil and M.v1 <> nil and abs (M.det -1) > epsilon then
		        M = new Matrix(1)
		      end if
		    else
		      QQupdateshapes
		      return true
		    end if
		  case 1
		    M = autosimupdate
		  case 2
		    M = autoaffupdate
		  case 3
		    M = autospeupdate
		  case 4
		    QQupdateshapes
		    return true
		  case 5
		    if autotrapupdate then
		      EndTrapupdateshapes
		      return true
		    else
		      return false
		    end if
		  Case 6
		    M = autoprppupdate
		  end select
		  
		  
		  if M = nil or M.v1 = nil then
		    QQupdateshapes
		    return true  'false                                           ////faut-il bloquer plus ?  (arc d'angle 0) OUI (voir SimilarityMatrix(p1,p2,ep, np))
		  else
		    updatesomm(M)
		    updatePtsSur(M)
		    updatePtsConsted(M)
		    updateshapes(M)
		    if not wnd.drapbug then
		      return checksimaff(M)
		    else
		      return true
		    end if
		  end if
		  
		Exception err
		  dim d As Debug
		  d = new Debug
		  d.setMethod("Figure","subfigupdate")
		  d.setVariable("M",M)
		  d.setVariable("auto",auto)
		  d.setVariable("standard",standard)
		  err.message = err.message+d.getString
		  
		  Raise err
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbShapes(p as point) As integer
		  dim i, n as integer
		  
		  for i = 0 to shapes.count-1
		    if shapes.element(i).getindexpoint(p) <> -1 then
		      n = n+1
		    end if
		  next
		  
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Autoaffupdate() As Matrix
		  
		  
		  
		  select case NbPtsModif // Nombre de pointsmodifiés
		  case 0
		    return new Matrix(1)
		  case 1
		    return autoaffupdate1
		  case 2
		    return autoaffupdate2
		  case 3
		    return autoaffupdate3
		  case 4
		    return Autoaffupdate4
		  else
		    return new matrix(1)
		  end select
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Autoaffupdate3() As Matrix
		  
		  dim p, q, r as point
		  dim n1, n2, n3, n4 as integer
		  dim M, MId as Matrix
		  dim s as shape
		  
		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  n3 = ListPtsModifs(2)
		  p = Point(somm.element(n1))
		  q = Point(somm.element(n2))
		  r = Point(somm.element(n3))
		  
		  Choixpointsfixes
		  if NbUnModif > 0 then
		    return new Matrix(1)
		  end if
		  
		  
		  select case NbSommSur(n1,n2,n3)
		  case 0
		    M = DefaultMatrix
		    MId = new Matrix(1)
		    s  = shapes.element(0)
		    if M.Equal(MId) and s.getindexpoint(p) <>-1 and s.getindexpoint(q) <> -1 and s.getindexpoint(r) <> -1 and s isa parallelogram then
		      n4 = parallelogram(s).quatriemepoint(n1,n2,n3)
		      s.points(n4).moveto s.points((n4+1) mod 4).bpt + s.points((n4+3) mod 4).bpt - s.points((n4+2)mod 4).bpt
		      s.points(n4).modified = true
		    end if
		    return M
		  case 1
		    if  replacerpoint(p) or  replacerpoint(q) or   replacerpoint(r) then
		      return autoaffupdate // on passe à 2 pts modif, 2 pts sur ou 2 pts modif, 3 pts sur
		    else
		      return new Matrix(1)
		    end if
		  end select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Autoaffupdate2() As Matrix
		  
		  dim bp1 as basicpoint
		  dim p, q, p1, p2 as point
		  dim ep, eq, np, nq,ep1,np1 as BasicPoint
		  dim n1, n2 as integer
		  
		  if NbUnModif > 2 then
		    return new Matrix(1)
		  end if
		  
		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  p = Point(somm.element(n1))
		  q = Point(somm.element(n2))
		  getoldnewpos(p,ep,np)
		  getoldnewpos(q,eq,nq)
		  
		  Choixpointsfixes
		  
		  select case NbSommSur(n1,n2)
		  case 0
		    if NbUnModif < 2 then
		      if fx1 <> n1 and fx1 <> n2 then
		        bp1 = Point(Somm.element(fx1)).bpt
		      else
		        bp1 = Point(Somm.element(fx2)).bpt
		      end if
		      return new AffinityMatrix (bp1, ep, eq, bp1,np, nq)
		    end if
		  case 1
		    if NbUnModif  = 0 then
		      p1 = Point(somm.element(listsommsur(0)))
		      getoldnewpos(p1,ep1,np1)
		      return new AffinityMatrix(ep,eq,ep1,np,nq,np1)
		    end if
		  case 2
		    if NbUnModif = 0 then
		      p1 = Point(somm.element(listsommsur(0)))
		      p2 = Point(somm.element(listsommsur(1)))
		      return AutoAffUpDate2Bis(p1.pointsur.element(0), p2.pointsur.element(0), p, q, p1, p2)
		    end if
		  end select
		  
		  return new Matrix(1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updateshapes(M as Matrix)
		  dim i as integer
		  
		  for i = 0 to shapes.count-1
		    if shapes.element(i) isa Circle then
		      Circle(shapes.element(i)).UpdatePtsConsted
		    end if
		    shapes.element(i).updateshape(M)
		    shapes.element(i).modified = true
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autosimupdate1() As Matrix
		  dim p, p1,p2 as point
		  dim bp1, ep, np,ep1, np1 as BasicPoint
		  dim n as integer
		  dim M as Matrix
		  
		  n = ListPtsModifs(0)
		  p = Point(somm.element(n))
		  getoldnewpos(p, ep, np)
		  
		  if  NbUnModif > 1 then
		    return new Matrix(1)
		  end if
		  
		  Choixpointsfixes
		  
		  select case NbSommSur(n)  'Détermination des sommets sur modifiables différents du point modifié
		  case 0
		    bp1 = Point(Somm.element(fx1)).bpt
		    M = new SimilarityMatrix (bp1, ep,bp1, np)
		  case 1
		    p1 = Point(Somm.element(ListSommSur(0)))
		    getoldnewpos(p1,ep1,np1)
		    if NbUnmodif = 1 then
		      if replacerpoint(p1) then
		        return AutosimUpdate
		      end if
		    else
		      M= new SimilarityMatrix(ep,ep1,np,ep1)
		    end if
		  case 2
		    p1 = Point(Somm.element(ListSommSur(0)))
		    p2 = Point(Somm.element(ListSommSur(1)))
		    if p1.pointsur.count = 1 and p2.pointsur.count = 1 then
		      M = new similarityMatrix(p1,p2,ep,np)
		      if M = nil or M.v1 = nil then
		        M = new Matrix(1)
		      end if
		    end if
		  end select
		  
		  return M
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autoaffupdate1() As Matrix
		  dim p, p1,p2 as point
		  dim bp1, bp2, ep, np,ep1, np1 as BasicPoint
		  dim i, n, m1, m2, ns as integer
		  
		  n = ListPtsModifs(0)
		  p = Point(somm.element(n))
		  getoldnewpos(p, ep, np)
		  
		  
		  if  NbUnModif > 2 then
		    return new Matrix(1)
		  end if
		  choixpointsfixes
		  
		  select case NbSommSur(n)  'Détermination des sommets sur modifiables différents du point modifié
		  case 0
		    select case NbUnModif
		    case 0
		      ns = somm.count
		      bp1 = Point(somm.element((n+1) mod ns)).bpt
		      bp2 = Point(somm.element((n+2) mod ns)).bpt
		    case 1, 2
		      bp1 = Point(Somm.element(fx1)).bpt
		      bp2 = Point(Somm.element(fx2)).bpt
		    end select
		    return new Affinitymatrix (bp1, bp2, ep,bp1, bp2, np)
		  case 1
		    bp1 = Point(Somm.element(fx1)).bpt
		    if Listsommsur(0) <> fx1 then
		      bp2 = Point(Somm.element(Listsommsur(0))).bpt
		    elseif fx2 <> fx1 then
		      bp2 = point(somm.element(fx2)).bpt
		    end if
		    return new Affinitymatrix (bp1, bp2, ep,bp1, bp2, np)
		  case 2
		    if NbUnModif < 2 then
		      bp1 = Point(Somm.element(fx1)).bpt
		      p1 = Point(Somm.element(Listsommsur(0)))
		      p2 = Point(Somm.element(Listsommsur(1)))
		      return new AffinityMatrix(p1,p2,ep,bp1,np,bp1)
		    end if
		  case 3
		    if NbUnModif < 2 then
		      bp1 = Point(Somm.element(fx1)).bpt
		      for i = 0 to 2
		        if (listsommsur(i) <> n) and (listsommsur(i) <> fx1) then
		          m1 = listsommsur(i)
		        end if
		      next
		      for i = 0 to 2
		        if (listsommsur(i) <> n) and (listsommsur(i) <> fx1) and (listsommsur(i) <> m1) then
		          m2 = listsommsur(i)
		        end if
		      next
		      p1 = Point(somm.element(m1))
		      p2 = Point(somm.element(m2))
		      return new AffinityMatrix(p1,p2,ep,bp1,np,bp1)
		    end if
		  end select
		  
		  return new Matrix(1)
		  
		  //A revoir pour déterminer les sommets qui ne sont ni modifiés, ni "sur" et les utiliser en cas de besoin comme points fixes
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Figure()
		  Shapes = new ObjectsList
		  Somm = new ObjectsList
		  subs = new FigsList
		  PtsConsted = new ObjectsList
		  PtsSur = new ObjectsList
		  figsimages = new FigsList
		  constructedfigs = new Figslist
		  Mmove = new Matrix(1)
		  idfig = -1
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function precede(f as figure) As Boolean
		  dim s1, s2 as shape
		  dim i, j, h, k, m as integer
		  dim p as point
		  dim t as boolean
		  dim op as modifier
		  
		  'if   currentcontent.currentoperation isa modifier then
		  'op = modifier(currentcontent.currentoperation)
		  'if (op.ptguide(op.pointmobile) <> op.pointmobile) and (somm.getposition(op.ptguide(op.pointmobile)) <> -1)   then
		  'return true
		  'end if
		  'end if
		  
		  for i = 0 to ptsconsted.count-1
		    if f.somm.getposition(ptsconsted.element(i)) <> -1 then
		      return true
		    end if
		  next
		  
		  'if (auto <> 4) and not (shapes.element(0) isa droite) and ((not shapes.element(0) isa Polyqcq )or (shapes.element(0).npts > 3)) and (NbTrueSommCommuns(f) >= 2) and (f.auto = 4) then
		  'return true
		  'end if // Commenté à cause de figuretest6.fag Attention à Figuretest2.fag, figuretest3.fag
		  
		  't = false   //introduit pour régler le cas du carré ayant deux sommets communs avec un losange et au moins une autre sommet sur
		  'for i = 0 to somm.count-1  //sans empêcher le fonctionnemen t de la figure de Pythagore
		  't = t or (point(somm.element(i)).pointsur.count > 0 and ptssur.getPosition(somm.element(i)) = -1)
		  'next
		  'if t and NbSommCommuns(f) > 0 then
		  'return true
		  'end if
		  
		  
		  for i = 0 to ptsconsted.count -1
		    s1 = ptsconsted.element(i)
		    for j = 0 to f.somm.count-1
		      s2 = f.somm.element(j)
		      if s2.constructedby <> nil and s2.constructedby.shape = s1 then
		        return true
		      end if
		    next
		  next
		  
		  for i = 0 to shapes.count -1
		    s1 = shapes.element(i)
		    for j = 0 to f.shapes.count-1
		      s2 = f.shapes.element(j)
		      if s1.precede(s2) then
		        return true
		      end if
		    next
		  next
		  
		  if auto = 1 and  f.auto = 4 and NbTrueSommCommuns(f) >= 2 then
		    return true
		  end if
		  
		  if (auto = 2 or auto = 3 or auto = 5) and  f.auto = 4 and NbTrueSommCommuns(f) >= 3 then
		    return true
		  end if
		  
		  
		  'if liberte = 0 and f.liberte <> 0 and not f.precede(self) then
		  'for i = 0 to Somm.count-1
		  'for j = 0 to f.Somm.count-1
		  'if Somm.Element(i) = f.Somm.element(j) then
		  'return true
		  'end if
		  'next
		  'next
		  'end if
		  
		  Return false
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ListerPrecedences()
		  dim i, k, j, n, nc as integer
		  
		  n = subs.count
		  
		  
		  if n <= 1 then
		    return
		  end if
		  
		  CreerMatricePrecedences(n)
		  
		  if not Mat.Null then
		    Bouclesasupprimer
		  end if
		  
		  nc = Mat.nc
		  
		  redim MP(nc)
		  for i = 0 to nc-1
		    MP(i) = new MatrixnD(nc)
		  next
		  
		  MP(0) = Mat
		  for i = 1 to nc-1
		    MP(i) = Mat*MP(i-1)
		  next
		  
		  // MP(k) contient les connexions en k+1 étapes
		  
		  redim Sommes(nc,nc)
		  
		  
		  for k = 0 to nc-2
		    for j = 0 to nc-1
		      Sommes(k,j)=MP(k).SommCol(j)
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub bouclesasupprimer()
		  dim n0 as integer
		  dim t as Boolean
		  
		  t = true
		  while  t
		    M1 = Mat
		    n0 = 2
		    if M1.Null then
		      return
		    end if
		    while n0 <= subs.count and   t
		      M1 = Mat*M1
		      if M1.Trace > 0 then
		        t = not supprimerboucles(n0)
		      end if
		      n0 = n0+1
		    wend
		    t = not t
		  wend
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SupprimerBoucles(n0 as integer) As Boolean
		  dim i, j as integer
		  dim pos(-1), pos2(-1) as integer
		  dim f1, f2  as figure
		  dim s1, s2 as shape
		  dim t as boolean
		  
		  t = false
		  for i = 0 to Mat.nc-1
		    if M1.col(i,i) > 0 Then
		      pos.append i
		    end if
		  next
		  
		  
		  pos2.append pos(0)
		  
		  for i = 1 to n0-1
		    j = 1
		    while  Mat.col(pos2(i-1), pos(j)) = 0
		      j = j+1
		    wend
		    pos2.append pos(j)
		  next
		  
		  if n0 = 2 then
		    f1 = subs.element(pos(0))
		    f2 = subs.element(pos(1))
		    if f1.shapes.count = 1 and f2.shapes.count =1 then
		      s1 = f1.shapes.element(0)
		      s2 = f2.shapes.element(0)
		      t = (s1.constructedby <> nil and s1.constructedby.oper = 3 and s1.constructedby.shape = s2 ) or (s2.constructedby <> nil and s2.constructedby.oper = 3 and s2.constructedby.shape = s1 )
		    else
		      t = false
		    end if
		  end if
		  
		  if not t then
		    FusionnerSubfigs(pos2)
		    CreerMatricePrecedences(subs.count)
		    return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreerMatricePrecedences(n as integer)
		  dim i , j as integer
		  
		  Mat = new MatrixnD(n)
		  
		  for i = 0 to n -2
		    for j = i+1 to n-1
		      if (subs.element(i).auto <> 4) and subs.element(i).precede(subs.element(j)) then
		        mat.col(i,j) = 1
		      end if
		      if (subs.element(i).auto <> 4) and subs.element(j).precede(subs.element(i)) then
		        mat.col(j,i) = 1
		      end if
		    next
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FusionnerSubfigs(pos() as integer)
		  dim f1, sf as figure
		  dim i, j, n as integer
		  dim t, tt as boolean
		  dim sh As shape
		  dim aut() as integer
		  
		  
		  
		  f1 = subs.element(pos(0))
		  
		  for i =  1 to ubound(pos)
		    sf = subs.element(pos(i))
		    f1.shapes.concat sf.shapes
		    f1.somm.concat sf.somm
		    f1.PtsConsted.concat sf.PtsConsted
		    f1.PtsSur.concat sf.PtsSur
		  next
		  
		  pos.remove 0
		  for i =  subs.count-1 downto 0
		    if pos.indexof(i) <> -1 then
		      subs.removefigure subs.element(i)
		    end if
		  next
		  
		  'if f1.shapes.element(0).isaparaperp(sh) then
		  'f1.auto=6
		  'else
		  'for j = 0 to f1.somm.count-1
		  't = t or (f1.somm.element(j).constructedby <> nil and f1.somm.element(j).constructedby.oper = 6)
		  'next
		  '
		  'if not t then
		  'f1.auto = 1
		  'else
		  'f1.auto = 0
		  'end if
		  'end if
		  
		  redim aut(f1.shapes.count-1)
		  for  j = 0 to f1.Shapes.count-1
		    aut(j) = f1.shapes.element(j).auto
		  next
		  
		  for  n = 0 to 6
		    t = true
		    for j = 0 to ubound(aut)
		      t  = t and (aut(j) = n)
		    next
		    if t then
		      select case n
		      case 0, 1, 2, 4, 6
		        f1.auto = n
		        'case 3, 5
		        'f1.auto = 1
		      end select
		      return
		    end if
		  next
		  
		  t = true
		  for j = 0 to ubound(aut)
		    t  = t and ((aut(j) =1 ) or (aut(j) = 2))
		  next
		  if t then
		    tt = true
		    for j = 0 to ubound(aut)
		      if aut(j) = 1 and not ( F1.shapes.element(j) isa droite) then
		        tt = false
		      end if
		    next
		    if tt then
		      f1.auto = 2
		    else
		      f1.auto = 1
		    end if
		  else
		    f1.auto = 1
		  end if
		  
		  
		  return
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CancelfixedPoints()
		  dim i as integer
		  
		  
		  for i = 0 to subs.count-1
		    subs.element(i).fx1 = -1
		    subs.element(i).fx2 = -1
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function update1(p As point) As Boolean
		  dim t  as boolean
		  dim i as integer
		  dim sf as figure
		  
		  
		  pointmobile = p
		  t = true
		  
		  listersubfigs(p)
		  for i = 0 to ubound(index)
		    sf = subs.element(index(i))
		    if currentcontent.drapaff then
		      t = sf.Modifaffine(p)
		    elseif currentcontent.drapeucli then
		      t = sf.Modifeucli(p)
		    else
		      t = sf.subfigupdate and t
		    end if
		  next
		  return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub canceloldbpts()
		  dim i as integer
		  
		  
		  redim oldbpts(-1)
		  redim oldptscsted(-1)
		  redim oldptssur(-1)
		  redim oldcentres(-1)
		  
		  for i = 0 to subs.count -1
		    subs.element(i).canceloldbpts
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesomm(M as Matrix)
		  dim i as integer
		  dim p as Point
		  
		  for i = 0 to somm.count-1
		    p = Point(somm.element(i))
		    p.Transform(M)
		    
		    p.updateshape
		    if  p.pointsur.count = 0 then
		      p.modified = true                //déplacé ici pour un problème avec les macros (extrémité d'un arc placé sur une forme mac-construite)
		      p.unmodifiable = true
		    end if
		  next
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub listerassociatedfigures()
		  dim i , j, k, h, n0, n1 as integer
		  dim ci as constructioninfo
		  dim ff as figure
		  
		  assocfigs = new FigsList
		  
		  assocfigs.appendlist associerfigs
		  
		  n0=-1
		  n1 =  AssocFigs.count-1
		  while n0 < n1
		    for j = n0+1 to n1
		      ff = Assocfigs.element(j)
		      assocfigs.appendlist ff.associerfigs
		    next
		    n0 = n1
		    n1 =AssocFigs.count-1
		  wend
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub restructurer()
		  dim figs , List0  as figslist
		  dim sf, ff, sfig, delfig as figure
		  dim i, j, k, m as integer
		  dim t, t1 as boolean
		  dim s, s1, s2 as shape
		  dim tsf as transformation
		  dim p as point
		  dim dr as Boolean
		  dim ci as figconstructioninfo
		  
		  for i =  subs.count-1 downto 0
		    if subs.element(i).isempty then
		      subs.removefigure subs.element(i)
		    end if
		  next
		  
		  
		  for i =  somm.count-1 downto 0
		    if ubound(point(somm.element(i)).parents) = -1 then
		      p = point(somm.element(i))
		      if p.tsfi.count > 0 or ubound(p.constructedshapes) > -1 or (p.constructedby <> nil and p.constructedby.oper = 6) then
		        shapes.addshape p
		        CurrentContent.Theobjects.addShape p
		      else
		        somm.removeshape p
		      end if
		    end if
		  next
		  
		  if shapes.count = 0 then
		    return
		  end if
		  
		  figs = new figslist
		  if shapes.count = 1  then
		    figs.addfigure self
		  else
		    for i = 0 to shapes.count-1
		      s = shapes.element(i)
		      t = false
		      for j = 0 to figs.count-1
		        if figs.element(j).shapes.getposition(s) <> -1 then
		          t = true
		        end if
		      next
		      
		      if not t then
		        sfig = new Figure(s)
		        List0 = new FigsList
		        List0.addfigure sfig
		        for j =  figs.count-1 downto 0
		          if s.mustbeinfigure(figs.element(j)) then
		            List0.AddFigure figs.element(j)
		            figs.removefigure figs.element(j)
		          end if
		        next
		        ff = List0.concat
		        ff.listerprecedences
		        figs.addfigure ff
		      end if
		    next
		  end if
		  
		  
		  for k = 0 to CurrentContent.TheTransfos.count -1
		    tsf = CurrentContent.TheTransfos.element(k)
		    t = false
		    for i = 0 to tsf.constructedfigs.count -1
		      sfig = tsf.constructedfigs.element(i)
		      for j =  ubound(sfig.Constructioninfos) downto 0
		        ci  = sfig.Constructioninfos(j)
		        if ci.tsf = tsf and  ci.sourcefig = self then
		          sfig.constructioninfos.remove j
		          t = true
		        end if
		      next
		      if sfig = self then
		        tsf.constructedfigs.removefigure self
		        t = true
		      end if
		    next
		    
		    if t then
		      for i = 0 to tsf.constructedshapes.count-1
		        s2 = tsf.constructedshapes.element(i)
		        s1 = s2.constructedby.shape
		        if figs.getposition (s1.fig) <> -1 or figs.getposition(s2.fig) <> -1 then
		          s2.fig.setconstructedby s1.fig, tsf
		          tsf.constructedfigs.addfigure s2.fig
		        end if
		      next
		    end if
		  next
		  
		  for i = 0 to figs.count-1
		    figs.element(i).idfig = -1
		    CurrentContent.TheFigs.AddFigure figs.element(i)
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Figure(sf as figure)
		  Figure
		  dim i as integer
		  
		  if sf.supfig <> nil then
		    subs.addfigure sf
		    sf.supfig = self
		  else
		    for i = 0 to sf.subs.count-1
		      subs.addfigure sf.subs.element(i)
		      sf.subs.element(i).supfig = self
		    next
		  end if
		  
		  for i = 0 to sf.Shapes.count-1
		    shapes.addShape sf.shapes.element(i)
		    sf.shapes.element(i).fig = self
		  next
		  for i = 0 to sf.somm.count-1
		    somm.addShape sf.somm.element(i)
		    sf.somm.element(i).fig = self
		  next
		  for i = 0 to sf.Ptsconsted.count-1
		    Ptsconsted.addShape sf.PtsConsted.element(i)
		    sf.PtsConsted.element(i).fig = self
		  next
		  for i = 0 to sf.PtsSur.count-1
		    PtsSur.addShape sf.PtsSur.element(i)
		    sf.PtsSur.element(i).fig = self
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Detectertsf()
		  dim i as integer
		  
		  redim ListeSupportsTsf(-1)
		  
		  for i = 0 to shapes.count-1
		    if shapes.element(i).tsfi.count > 1 then
		      ListeSupportsTsf.append i
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetConstructedBy(f as figure, tsf as transformation)
		  dim i as integer
		  
		  for i = 0 to ubound(constructioninfos)
		    if constructioninfos(i).sourcefig = f and constructioninfos(i).tsf = tsf then
		      return
		    end if
		  next
		  ConstructionInfos.append  new FigConstructionInfo(f, tsf)
		  f.Constructedfigs.addfigure self
		  
		Exception err
		  dim d As Debug
		  d = new Debug
		  d.setMethod("Figure","SetConstructedBy")
		  d.setVariable("f",f)
		  d.setVariable("tsf",tsf)
		  err.message = err.message+d.getString
		  
		  Raise err
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Move(M as Matrix)
		  dim i, j as integer
		  dim s as shape
		  
		  Movepoints(M)
		  Mmove = M
		  
		  for j = 0 to shapes.count -1
		    s= shapes.element(j)
		    s.Mmove = M
		    if s isa Circle or s isa Lacet  then
		      s.coord.MoveExtreCtrl(M)
		    end if
		    if s isa arc   or s isa cube then
		      s.updateskull
		    end if
		    if (not s isa point)  then ' sinon on effectue deux fois tsf.update quand s est le support d'un demi-tour ou d'un quart de tour
		      s.endmove
		    end if
		    s.updateMacConstructedShapes
		    for i = 0 to ubound(s.childs)
		      s.childs(i).updatemacconstructedshapes
		    next
		    
		  next
		  
		  modified = true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub lierpoint(p as point)
		  dim t as boolean
		  dim i as integer
		  
		  if p.pointsur.count = 0 and p.firstcurrentattractingshape <> nil then
		    t = true
		    for i = 0 to 2
		      t = (p.firstcurrentattractingshape = Point(Somm.element(ListSommSur(i))).pointsur.element(0)) and t
		    next
		    if t then
		      p.puton p.firstcurrentattractingshape
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autospeupdate() As Matrix
		  select case NbPtsModif
		  case 0
		    return new Matrix(1)
		  case 1
		    return  autospeupdate1
		  case 2
		    return autospeupdate2
		  case 3
		    return autospeupdate3
		  case 4
		    return autospeupdate4
		  end select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createState(EL as XMLElement)
		  dim i, j as integer
		  dim EL0, EL1,EL2 As XMLElement
		  dim s as shape
		  dim M as Matrix
		  
		  EL0 = CurrentContent.OpList.createelement("Figure")
		  
		  EL0.setattribute ("FigId", str(idfig))
		  
		  EL1 = CurrentContent.Oplist.CreateElement("Shapes")
		  for i = 0 to shapes.count-1
		    s = shapes.element(i)
		    EL2 = CurrentContent.Oplist.createelement(Dico.Value("Form"))
		    EL2.SetAttribute("Id", str(s.id))
		    EL2.SetAttribute("Npts", str(ubound(s.childs)+1))
		    for j = 0 to ubound(s.childs)
		      EL2.SetAttribute("IdPt"+str(j), str(s.childs(j).id))
		    next
		    if s.duplicateorcut then
		      M = Matrix(s.constructedby.data(0))
		      M.XMLPutAttribute(EL2)
		    end if
		    if s isa Lacet then
		      EL2.SetAttribute("coord.centres",str(1))
		      for j = 0 to ubound(s.coord.centres)
		        if s.coord.centres(j) <> nil then
		          EL2.AppendChild(s.coord.centres(j).XMLPutInContainer(CurrentContent.OpList))
		        end if
		      next
		    end if
		    EL1.appendchild EL2
		  next
		  EL0.appendchild EL1
		  
		  EL1 = CurrentContent.Oplist.createelement("Somm")
		  for i = 0 to somm.count-1
		    EL1.appendchild point(somm.element(i)).PutInState(CurrentContent.OpList)
		  next
		  EL0.appendchild EL1
		  
		  if PtsConsted.count > 0 then
		    EL1 = CurrentContent.Oplist.createelement("PtsConsted")
		    for i = 0 to PtsConsted.count-1
		      EL1.appendchild point(PtsConsted.element(i)).PutInState(CurrentContent.OpList)
		    next
		    EL0.appendchild EL1
		  end if
		  
		  if PtsSur.count > 0 then
		    EL1 = CurrentContent.Oplist.createelement("PtsSur")
		    for i = 0 to PtsSur.count-1
		      EL1.appendchild point(PtsSur.element(i)).PutInstate (CurrentContent.oplist)
		    next
		    EL0.appendchild EL1
		  end if
		  
		  
		  EL.appendchild EL0
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RestoreInit(EL as XMLElement)
		  dim i,j,k, n0, n1 as integer
		  dim EL1, EL2, EL3, Coord as XMLElement
		  dim List as XmlNodeList
		  dim p as point
		  dim tsf as transformation
		  dim Inter as Intersec
		  dim M as Matrix
		  dim a as double
		  dim s as shape
		  
		  List = EL.XQL("Somm")
		  if List.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		    for i = 0 to Somm.count-1
		      Coord = XMLElement(EL1.child(i))
		      point(somm.element(i)).moveto new BasicPoint(val(Coord.GetAttribute("X")), val(Coord.GetAttribute("Y")))
		      if val(Coord.GetAttribute("Invalid")) = 0 then
		        point(somm.element(i)).valider
		      else
		        point(somm.element(i)).invalider
		      end if
		    next
		  end if
		  
		  List = EL.XQL("PtsConsted")
		  if List.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		    for i = 0 to PtsConsted.count-1
		      Coord = XMLElement(EL1.child(i))
		      point(PtsConsted.element(i)).moveto new BasicPoint(Coord)
		      if val(Coord.GetAttribute("Invalid")) = 0 then
		        point(PtsConsted.element(i)).valider
		      else
		        point(PtsConsted.element(i)).invalider
		      end if
		    next
		  end if
		  
		  EL1 = XMLElement(EL.Firstchild)
		  for i = 0 to shapes.count-1
		    EL2 = XMLElement(EL1.Child(i))
		    s = shapes.element(i)
		    s.updatecoord
		    if s isa circle or s isa Lacet then
		      k = 0
		      for j = 0 to ubound(s.coord.centres)
		        if s.coord.centres(j) <>nil then
		          Coord = XmlElement(EL2.child(k))
		          s.coord.centres(j) = new BasicPoint(coord)
		          k = k+1
		        end if
		      next
		      s.coord.CreateExtreAndCtrlPoints(s.ori)
		    end if
		    s.updateskull
		    s.updatelab
		    if s.duplicateorcut then
		      M = new Matrix(EL2)
		      s.constructedby.data(0) = M
		      if not s isa point then
		        for j = 0 to s.npts-1
		          s.childs(j).constructedby.data(0) = M
		        next
		      end if
		    end if
		  next
		  
		  List = EL.XQL("PtsSur")
		  if List.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		    for i = 0 to EL1.Childcount-1
		      Coord = XMLElement(EL1.child(i))
		      p = point(PtsSur.element(i))
		      p.moveto new BasicPoint(val(Coord.GetAttribute("X")), val(Coord.GetAttribute("Y")))
		      if p.pointsur.count = 1 then
		        p.puton(p.pointsur.element(0))
		      elseif p.pointsur.count = 2 then
		        n0 = val(Coord.GetAttribute("Side0"))
		        n1 = val(Coord.GetAttribute("Side1"))
		        inter= CurrentContent.Theintersecs.find(p.pointsur.element(0),p.pointsur.element(1))
		        inter.update(p,(p.pointsur.element(0),n0, p.pointsur.element(1)), n1)
		      end if
		      if val(Coord.GetAttribute("Invalid")) = 0 then
		        point(PtsSur.element(i)).valider
		      else
		        point(PtsSur.element(i)).invalider
		      end if
		    next
		  end if
		  
		  
		  
		  Restoretsf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function checksimaff(M as Matrix) As Boolean
		  dim i as integer
		  dim er, nr, ep, np as basicpoint
		  dim p as point
		  dim t as boolean
		  dim d, d1 as double
		  
		  if shapes.element(0) = nil or  shapes.element(0) isa arc then
		    return true
		  end if
		  
		  if (shapes.element(0).tobereconstructed = true) or (shapes.element(0).macconstructedby <> nil) then
		    return true
		  end if
		  
		  'for i = 0 to shapes.count-1
		  'if not shapes.element(i).check then
		  'return false
		  'end if
		  'next
		  
		  t = true
		  for i = 0 to somm.count-1
		    p = Point(somm.element(i))
		    if (not p.invalid)  and  (p.pointsur.count < 2)  and (p.constructedby = nil or (p.pointsur.count=1 and ( p.duplicateorcut or p.constructedby.oper = 10)))  then
		      ep = oldbpts(i)
		      np = p.bpt
		      d =np.distance(M*ep)
		      t = (d < epsilon) and t
		      if not t then
		        d1 = d
		      end if
		    end if
		  next
		  return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function replacerpoint(p as point) As Boolean
		  dim i as integer
		  
		  if p.pointsur.count = 1 and p.modified and  not p.unmodifiable and p <> supfig.pointmobile then
		    unmodify p
		    return true
		  else
		    return false
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Movepoints(M as Matrix)
		  dim j as integer
		  dim s as shape
		  
		  for j = 0 to somm.count-1
		    s = somm.element(j)
		    Point(s).Move(M)
		  next
		  
		  for j = 0 to PtsConsted.count-1
		    s=PtsConsted.element(j)
		    if somm.getposition(s) = -1 then
		      Point(s).Move(M)
		    end if
		  next
		  
		  for j = 0 to PtsSur.count-1
		    s = PtsSur.element(j)
		    if somm.getposition(s) = - 1 then
		      Point(s).Move(M)
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub concat1(f1 as figure, f2 as figure, n as integer)
		  if f1.nbsommcommuns(f2) >= n then
		    f1.shapes.concat f2.shapes
		    f1.somm.concat f2.somm
		    f1.PtsConsted.concat f2.PtsConsted
		    f1.PtsSur.concat f2.PtsSur
		    subs.removefigure f2
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Magnetisme(Byref d as basicpoint, Byref AttractedShape as Shape, Byref attractingShape as Shape, ByRef nextattractingshape as Shape) As integer
		  dim CurrentMagnetism as Integer
		  dim StrongestMagnetism as Integer
		  dim NextStrongestMagnetism As Integer
		  
		  dim  s,s1,s2,s3  as Shape
		  dim t as BasicPoint
		  dim i as integer
		  
		  
		  StrongestMagnetism=0
		  NextStrongestMagnetism = 0
		  
		  for i = 0 to shapes.count -1
		    s = shapes.element(i)
		    CurrentMagnetism = s.Magnetisme(t,s1,s2,s3)
		    
		    if CurrentMagnetism >= StrongestMagnetism and s2 <> nil and s2.fig <> self  then
		      NextStrongestMagnetism = StrongestMagnetism
		      d=t
		      AttractedShape=s1
		      AttractingShape=s2
		      if s3 <> nil and s3.fig <> self then
		        Nextattractingshape = s3
		      end if
		      StrongestMagnetism=CurrentMagnetism
		    end if
		  next
		  
		  If StrongestMagnetism > 0 then
		    if  attractingShape = nextattractingshape then
		      Nextattractingshape = nil
		    end if
		  end if
		  return StrongestMagnetism
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GridMagnetism(Byref d as BasicPoint, Byref AttractedPoint as Point) As integer
		  
		  dim td As BasicPoint
		  dim i as integer
		  dim currentmagnetism,StrongestMagnetism as integer
		  
		  td = new BasicPoint(0,0)
		  for i=0 to somm.count-1
		    Currentmagnetism=point(somm.element(i)).GridMagnetism(td)
		    if Currentmagnetism>StrongestMagnetism then
		      StrongestMagnetism=Currentmagnetism
		      AttractedPoint=Point(Somm.element(i))
		      d = td
		    end if
		  next
		  return StrongestMagnetism
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fusionnerautosimaff()
		  dim i, j as integer
		  dim f1, f2 as figure
		  
		  
		  for i = 0 to subs.count-2
		    f1 = subs.element(i)
		    for j =  subs.count-1 downto i+1
		      f2 = subs.element(j)
		      if f1.auto = f2.auto then
		        select case f1.auto
		        case 1
		          concat1(f1, f2, 2)
		        case 2
		          concat1(f1, f2, 3)
		        end select
		      end if
		    next
		  next
		  
		  '' Ne pas fusionner de figures de modes de modification différents! (sauf cas particuliers avec une droite et une figure auto=4, par ex)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function associerfigs() As figslist
		  dim i , j, k, h, n0, n1 as integer
		  dim ci as constructioninfo
		  dim ff as figure
		  dim figs as figslist
		  dim s as shape
		  dim p as point
		  
		  figs = new FigsList
		  
		  for i = 0 to shapes.count -1
		    addconstructedfigs(figs, shapes.element(i))
		  next
		  
		  for i = 0 to somm.count-1
		    addconstructedfigs(figs, somm.element(i))
		  next
		  
		  for h = 0 to PtsSur.count-1
		    addconstructedfigs(figs, PtsSur.element(h) )
		    if PtsSur.element(h).constructedby <> nil and Ptssur.element(h).constructedby.oper = 10 then
		      figs.addfigure Ptssur.element(h).constructedby.shape.fig
		    end if
		    for k = 0 to  ubound(Ptssur.element(h).constructedshapes)
		      if Ptssur.element(h).constructedshapes(k).constructedby.oper = 10 then
		        figs.addfigure Ptssur.element(h).constructedshapes(k).fig
		      end if
		    next
		  next
		  
		  for h = 0 to PtsConsted.count-1
		    p = point(PtsConsted.element(h))
		    for k = 0 to  ubound(p.parents)
		      figs.addfigure p.parents(k).fig
		    next
		    for k = 0 to ubound(p.constructedshapes)
		      Figs.addfigure p.constructedshapes(k).fig
		    next
		  next
		  
		  return figs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fusionnerinclusions()
		  dim i, j as integer
		  dim f1, f2 as figure
		  
		  for i = 0 to subs.count-2
		    f1 = subs.element(i)
		    for j =  subs.count-1 downto i+1
		      f2 = subs.element(j)
		      if fusionsubfigs(f2,f1) then
		        subs.removefigure f2
		      end if
		    next
		  next
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Choixpointsfixes()
		  // Modif d'une sous-figure
		  
		  // 0) Par priorité, on choisit comme candidats points fixes les points non modifiables.
		  // 1) Parmi les sommets de la sous-figure différents de p, déterminer les points modifiables qui appartiennent au plus grand nombre de sous-figures
		  // 1bis) les classer par distance décroissante du point mobile
		  // 2) placer ceux qui sont des points sur directement après les non modifiables dans la liste des candidats points fixes.
		  // Mais on exclut tous les points déjà modifiés de la liste des candidats points fixes
		  
		  if fx1 <> - 1 Then
		    return
		  end if
		  
		  
		  
		  
		  Phase0choixpointsfixes
		  Phase1choixpointsfixes
		  Phase2choixpointsfixes
		  
		  if ubound(Pointsfixes) > -1 then
		    fx1 = PointsFixes(0)
		    if ubound(PointsFixes) > 0 then
		      fx2 = PointsFixes(1)
		    else
		      fx2 = fx1
		    end if
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Phase1choixpointsfixes()
		  // On choisit les points appartenant au plus grand nombre de sous-figures en les classant par valeur de distance décroissante
		  //du premier point modifié
		  
		  
		  dim i, n, nf1, nf2 as integer
		  dim np as BasicPoint
		  dim t as boolean
		  dim p as point
		  
		  redim nff(somm.count-1)
		  nf1 = 0
		  nf2 = 0
		  
		  
		  // on recense les points  modifiables absents de la liste précédente
		  
		  
		  for i = 0 to somm.count-1
		    p = point(somm.element(i))
		    if (p <> supfig.pointmobile ) and (PointsFixes.IndexOf(i) = -1) and (ListPtsModifs.indexof(i) = -1) and (PtsConsted.GetPosition(p) = -1) then
		      nff(i)=1
		    end if
		  next
		  
		  redim ptfx0(-1)
		  
		  classementptsfix(1)
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Phase2choixpointsfixes()
		  dim i, j, k, j0, j1 as integer
		  dim t as Boolean
		  dim p as point
		  dim ep, np, bp1, bp2 as BasicPoint
		  
		  // on adjoint aux candidats points fixes les sommets pointssur  modifiables
		  
		  
		  for i = 0  to  ubound(ptfx0)
		    p = point(somm.element(ptfx0(i)))
		    if supfig.ptssur.getposition(p) <> -1 or  (p.guide <>nil and  p.guide <> p) then
		      PointsFixes.append ptfx0(i)
		    end if
		  next
		  
		  
		  //puis  on adjoint aux candidats points fixes les autres sommets  modifiables
		  
		  for i = 0   to  ubound(ptfx0)
		    if point(somm.element(ptfx0(i))).pointsur.count = 0 and pointsfixes.indexof(ptfx0(i)) = -1  then
		      PointsFixes.append ptfx0(i)
		    end if
		  next
		  
		  
		  
		  // on enlève alors les candidats points fixes alignés avec un précédent et un point modifié
		  
		  for j = ubound(pointsfixes) downto NbUnmodif+1
		    j0 = pointsfixes(j)
		    bp1 = Point(somm.element(j0)).bpt
		    i = 0
		    while pointsfixes.indexof(j0) <> -1 and i <= ubound(ListPtsModifs)
		      p = Point(somm.element(ListPtsModifs(i)))
		      getoldnewpos(p,ep,np)
		      k = 0
		      while pointsfixes.indexof(j0) <> -1 and k <j
		        j1 = pointsfixes(k)
		        bp2 = Point(somm.element(j1)).bpt
		        if  p <> somm.element(j1)  and ep.alignes(bp1,bp2)  then
		          pointsfixes.remove j
		        end if
		        k = k+1
		      wend
		      i = i+1
		    wend
		  next
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateoldM()
		  dim i as integer
		  
		  for i = 0 to shapes.count-1
		    shapes.element(i).updateoldM
		  next
		  for i = 0 to somm.count-1
		    somm.element(i).updateoldM
		  next
		  for i = 0 to PtsConsted.count-1
		    PtsConsted.element(i).updateoldM
		  next
		  for i = 0 to PtsSur.count-1
		    PtsSur.element(i).updateoldM
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function gettransfosto(f as figure) As transfoslist
		  dim i as integer
		  dim tsfl as transfoslist
		  
		  for i = 0 to shapes.count-1
		    if shapes.element(i).constructedby <> nil and shapes.element(i).constructedby.oper = 6 then
		      tsfl.addtsf transformation(shapes.element(i).constructedby.data(0))
		    end if
		  next
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removeconstructedby(ff as figure, tsff as transformation)
		  dim i as integer
		  
		  for i =  ubound(constructioninfos) downto 0
		    if constructioninfos(i).sourcefig = ff and constructioninfos(i).tsf = tsff then
		      constructioninfos.remove i
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Restoretsf()
		  dim i, j as integer
		  dim p as point
		  dim tsf as transformation
		  
		  
		  for i = 0 to somm.count-1
		    for j = 0 to somm.element(i).tsfi.count-1
		      somm.element(i).tsfi.element(j).restore
		    next
		  next
		  
		  for i = 0 to PtsConsted.count-1
		    for j = 0 to ptsconsted.element(i).tsfi.count-1
		      ptsconsted.element(i).tsfi.element(j).restore
		    next
		  next
		  
		  for i = 0 to PtsSur.count-1
		    p = point(PtsSur.element(i))
		    for j = 0 to p.tsfi.count-1
		      p.tsfi.element(j).restore
		    next
		  next
		  
		  
		  for i = 0 to shapes.count-1
		    for j = 0 to shapes.element(i).tsfi.count-1
		      tsf = shapes.element(i).tsfi.element(j)
		      if tsf.type > 0 then
		        tsf.restore
		      end if
		    next
		  next
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Restorebpt()
		  dim i, j, i0 as integer
		  dim p as point
		  dim s as Lacet
		  dim sh as shape
		  
		  
		  for i = 0 to somm.count-1
		    p = point(somm.element(i))
		    p.moveto oldbpts(i)
		    if  invalidpts.indexof(i) <> -1 then
		      p.invalider
		    else
		      p.valider
		    end if
		  next
		  
		  i0 = 0
		  for i = 0 to shapes.count-1
		    if shapes.element(i) isa Lacet  then
		      s = Lacet(shapes.element(i))
		      for j = 0 to s.npts-1
		        if s.coord.curved(j) = 1 then
		          s.coord.centres(j) = oldcentres(i0)
		          i0 = i0+1
		        else
		          s.coord.centres(j) = nil
		        end if
		      next
		    end if
		  next
		  
		  for i = 0 to PtsConsted.count-1
		    p = point(PtsConsted.element(i))
		    if somm.getposition(p) = -1 then
		      p.moveto oldptscsted(i)
		    end if
		    if  invalidptscsted.indexof(i) <> -1 then
		      p.invalider
		    else
		      p.valider
		    end if
		  next
		  
		  for i = 0 to PtsSur.count-1
		    p = point(PtsSur.element(i))
		    p.moveto oldptssur(i)
		    p.puton p.pointsur.element(0)
		    if  invalidptssur.indexof(i) <> -1 then
		      p.invalider
		    else
		      p.valider
		    end if
		  next
		  
		  //Problème avec les cercles et calcul des exe et ctrl quand on se limite à exécuter les instructions qui suivent pour les figures et non les sous-figures!
		  //Pas compris pourquoi...
		  for i = 0 to shapes.count-1
		    sh = shapes.element(i)
		    sh.updatecoord
		    if sh isa arc then
		      Arc(sh).computearcangle
		    end if
		    if sh isa circle then
		      sh.coord.CreateExtreAndCtrlPoints(sh.ori)
		    end if
		    if sh isa lacet then
		      Lacet(sh).CreateExtreAndCtrlPoints
		    end if
		    sh.updateskull
		  next
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RestoreMmove()
		  dim i as integer
		  dim M as Matrix
		  
		  M = new Matrix(1)
		  
		  Mmove = M
		  
		  for i = 0 to somm.count-1
		    somm.element(i).Mmove = M
		  next
		  
		  for i = 0 to PtsConsted.count-1
		    ptsconsted.element(i).Mmove = M
		  next
		  
		  for i = 0 to PtsSur.count-1
		    PtsSur.element(i).Mmove = M
		  next
		  
		  
		  for i = 0 to shapes.count-1
		    shapes.element(i).Mmove = M
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AutosimUpdate() As Matrix
		  
		  
		  select case NbPtsModif
		  case 0
		    return new Matrix(1)
		  case 1
		    return autosimupdate1
		  case 2
		    return autosimupdate2
		  else
		    return autosimupdate3
		  end select
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autosimupdate3() As Matrix
		  dim p, p1, p2 As point
		  dim ep,np,ep1,ep2,np1,np2 as BasicPoint
		  dim i, k, n, h as integer
		  dim t as boolean
		  dim M as Matrix
		  dim s as shape
		  
		  s = shapes.element(0)
		  if s isa arc then
		    getoldnewpos(s.points(1),ep1,np1)
		    getoldnewpos(s.points(0),ep,np)
		    t = replacerpoint(s.points(2))
		    return  new similaritymatrix (ep1,ep,np1,np)
		  end if
		  
		  
		  Choixpointsfixes
		  p = supfig.pointmobile
		  getoldnewpos(p,ep,np)
		  k = somm.getposition(p)
		  n = NbSommSur
		  
		  select case n
		  case 0,1
		    return DefaultMatrix
		  case 2
		    p1 = point(somm.element(Listsommsur(0)))
		    p2 = point(somm.element(Listsommsur(1)))
		    if k <> -1 and k <> listsommsur(0) and k <> listsommsur(1) then
		      t = replacerpoint(p1)
		      t = replacerpoint(p2)
		      getoldnewpos(p,ep,np)
		      M = new similarityMatrix(p1,p2,ep,np)
		    elseif Listsommsur.indexof(k) <> -1 then
		      for i = 0 to 1
		        if i <> k then
		          t =replacerpoint (point(somm.element(Listsommsur(i))))
		          return autosimupdate
		        end if
		      next
		    end if
		  case 3
		    if k <> -1 then
		      if listsommsur(0) <> k then
		        p1 = point(somm.element(listsommsur(0)))
		        if listsommsur(1) <> k then
		          p2 = point(somm.element(listsommsur(1)))
		        else
		          p2 = point(somm.element(listsommsur(2)))
		        end if
		      else
		        p1 = point(somm.element(listsommsur(1)))
		        p2 = point(somm.element(listsommsur(2)))
		      end if
		      t = replacerpoint(p1)
		      t = replacerpoint(p2)
		      M = new similarityMatrix(p1,p2,ep,np)
		    end if
		  else
		    p1 = point(somm.element(listsommsur(0)))
		    p2 = point(somm.element(listsommsur(1)))
		    getoldnewpos(p1,ep1,np1)
		    getoldnewpos(p2,ep2,np2)
		    M = new SimilarityMatrix(ep1,ep2,np1,np2)
		  end select
		  
		  
		  if M = nil or M.v1 = nil then
		    M = new Matrix(1)
		  end if
		  return M
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub getoldnewpos(p as point, byref ep as BasicPoint, byref np as basicpoint)
		  dim n as integer
		  
		  n = somm.getposition(p)
		  if n <> -1 then
		    ep = oldbpts(n)
		  else
		    n = ptssur.getposition(p)
		    if n <> -1 then
		      ep = oldptssur(n)
		    else
		      n = ptsconsted.getposition(p)
		      if n <> -1 then
		        ep = oldptscsted(n)
		      end if
		    end if
		  end if
		  
		  np = p.bpt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub QQupdateshapes()
		  dim i as integer
		  dim p as point
		  dim ep, np as basicpoint
		  dim s as shape
		  dim M as Matrix
		  
		  
		  
		  for i = 0 to somm.count-1
		    p = point(somm.element(i))
		    getoldnewpos(p,ep,np)
		    if ep <> nil and np <> nil and ep.distance(np) > epsilon then
		      select case  p.pointsur.count
		      case  1
		        p.puton p.pointsur.element(0)
		        p.unmodifiable = true
		      end select
		    end if
		    if p.isonasupphom(s) = 2 then
		      p.resetonsupphom(s)
		    end if
		    p.updateshape
		    p.modified = true // doit être marqué modifié même s'il n'a pas bougé. (Cas des sommets d'arcs dans un angle de polygone)
		  next
		  
		  'for i = 0 to shapes.count-1
		  'if shapes.element(i) isa Lacet then
		  'Lacet(shapes.element(i)).createextreandctrlpoints
		  'Lacet(shapes.element(i)).updateskull
		  'end if
		  'next
		  
		  EndQQupdateshapes
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Phase0choixpointsfixes()
		  redim PointsFixes(-1)
		  dim i,  k, n as integer
		  dim t as Boolean
		  dim p as point
		  
		  
		  
		  // On dresse la liste des sommets de liberte nulle qui ne sont ni construits  par cette sous-figure ni modifiés
		  // Ces points ne pourront être modifiés, on devra les prendre comme points fixes des matrices à calculer
		  //Points de liberte nulle (routine "mobility") :
		  //points d'intersection,  sommets de formes std ou sommets punaisés,
		  // points construits par division, centre, image tsf, point fixe tsf
		  // points ayant un prédécesseur (oper 3 ou 10) de liberté nulle
		  
		  // Un point sommet de l'angle droit de deux triangles rectangles ne peut être modifiable
		  
		  for i = 0 to somm.count-1
		    p = point(somm.element(i))
		    if p.pointsur.count = 2 and p.pointsur.element(0).modified and p.pointsur.element(1).modified then
		      p.unmodifiable = true
		    end if
		    if ubound(p.parents) >=1 then
		      n = 0
		      for k = 0 to ubound(p.parents)
		        if (p.parents(k) isa triangrect and p.parents(k).getindexpoint(p) = 1) or  (p.parents(k) isa triangiso and p.parents(k).getindexpoint(p) = 2) then
		          n = n+1
		        end if
		      next
		      if n >=2 then
		        p.unmodifiable = true
		      end if
		    end if
		  next
		  
		  NbUnModif = 0
		  
		  for i = 0 to somm.count-1
		    p =point(somm.element(i))
		    if  (p.liberte = 0 or p.unmodifiable) and (p <> supfig.pointmobile )  and PtsConsted.getposition(p) = -1 and ListPtsModifs.indexof(i)=-1 then
		      Pointsfixes.append i
		      if p.pointsur.count <> 2 then
		        NbUnModif = NbUnModif+1
		      end if
		    end if
		  next
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RestoreLab()
		  dim i, j, k as integer
		  
		  for i = 0 to shapes.count-1
		    for j = 0 to shapes.element(i).Labs.count-1
		      if not shapes.element(i).labs.element(j).fixe then
		        shapes.element(i).labs.element(j).setposition
		      end if
		      shapes.element(i).enabletoupdatelabel
		      shapes.element(i).updatelabel(1)
		    next
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function alignement() As boolean
		  // Vérification qu'aucun point modifié n'est  aligné avec deux points fixes ou deux points sur
		  
		  dim i, j, k as integer
		  dim bq1,bq2, ep, np as basicpoint
		  dim p as point
		  
		  dim pfx(-1) As integer
		  
		  for i = 0 to somm.count-1
		    if  ListPtsModifs.IndexOf(i) = -1 then
		      if  ((somm.element(i).liberte = 0) and PtsConsted.getposition(somm.element(i)) = -1) or somm.element(i).liberte = 1 then
		        pfx.append i
		      end if
		    end if
		  next
		  
		  
		  if (auto =2 or auto = 3) then
		    for i = 0 to ubound(ListPtsModifs)
		      p = Point(somm.element(ListPtsModifs(i)))
		      getoldnewpos(p,ep,np)
		      for j =  ubound(pfx) downto 1
		        bq1 = point(somm.element(pfx(j))).bpt
		        for k =  i-1 downto 0
		          bq2 = point(somm.element(pfx(k))).bpt
		          if ep.alignes(bq1, bq2)  then
		            return true
		          end if
		        next
		      next
		    next
		  end if
		  
		  return false
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub classementptsfix(nf as integer)
		  dim i as integer
		  dim ptfx(-1) as integer
		  dim dist(-1) as double
		  dim p as point
		  dim ep, np as basicpoint
		  
		  
		  
		  //classement par rapport à la distance au point mobile ou à défaut au premier point modifié
		  
		  if somm.getposition(supfig.pointmobile) <> -1 then
		    p = supfig.pointmobile
		  else
		    p = Point(somm.element(ListPtsModifs(0)))
		  end if
		  
		  p.fig.getoldnewpos(p,ep,np)
		  
		  for i = 0 to somm.count-1
		    if  point(somm.element(i))  <> p and PointsFixes.IndexOf(i) = -1 and (PtsConsted.GetPosition(somm.element(i)) = -1) and nff(i) = nf and ListPtsModifs.IndexOf(i) = -1 then
		      Ptfx.append i
		      dist.append ubound(point(somm.element(i)).parents)
		    end if
		  next
		  
		  if auto = 3 and shapes.element(0) isa arc then
		    for i = 0 to  ubound(ptfx)
		      ptfx0.append ptfx(i)
		    next
		  else
		    dist.sortwith(ptfx)
		    for i =   ubound(ptfx) downto 0
		      ptfx0.append ptfx(i)
		    next
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autoprppupdate() As Matrix
		  dim s as droite
		  
		  s = droite(shapes.element(0))
		  
		  if s <> nil then
		    select case NbPtsModif
		    case 0
		      return s.prppupdate0
		    case 1
		      return s.prppupdate1
		    case 2
		      return s.prppupdate2
		    end select
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autotrapupdate() As Boolean
		  select case NbPtsModif // Nombre de pointsmodifiés (y compris les sommetssur) Mais il peut exister des sommetssur non modifiés
		  case 0
		    return true
		  case 1
		    return autotrapupdate1
		  case 2
		    return autotrapupdate2
		  case 3
		    return autotrapupdate3
		  case 4
		    return autotrapupdate4
		  end select
		  
		Exception err
		  dim d As Debug
		  d = new Debug
		  d.setMethod("Figure","autotrapupdate")
		  d.setVariable("NbPtsModif ",NbPtsModif )
		  err.message = err.message+d.getString
		  
		  Raise err
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autotrapupdate1() As Boolean
		  dim s as trap
		  dim p, p1, p2 as point
		  
		  choixpointsfixes
		  
		  p = Point(somm.element(ListPtsModifs(0)))
		  s = trap(shapes.element(0))
		  
		  if s isa trapiso and NbUnModif > 2 then
		    return s.check
		  else
		    return s.trapupdate1 (p)
		  end if
		  
		Exception err
		  dim d As Debug
		  d = new Debug
		  d.setMethod("Figure","autotrapupdate1")
		  d.setVariable("s",s)
		  d.setVariable("p",p)
		  d.setVariable("p1",p1)
		  d.setVariable("p2",p2)
		  err.message = err.message+d.getString
		  
		  Raise err
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub allpointsmodified()
		  dim i as integer
		  
		  for i = 0 to somm.count-1
		    somm.element(i).modified = true
		    point(somm.element(i)).markmodifiedallconstructedpoints
		    if point(somm.element(i)).pointsur.count = 1 then
		      point(somm.element(i)).unmodifiable = true
		    end if
		  next
		  
		  for i = 0 to PtsConsted.count-1
		    PtsConsted.element(i).modified = true
		    point(PtsConsted.element(i)).markmodifiedallconstructedpoints
		  next
		  
		  for i = 0 to PtsSur.count-1
		    PtsSur.element(i).modified = true
		    point(PtsSur.element(i)).markmodifiedallconstructedpoints
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autoaffupdate4() As Matrix
		  dim p as point
		  dim k, n, i as integer
		  dim t as Boolean
		  dim s as shape
		  
		  Choixpointsfixes
		  'if NbUnModif > 0 then
		  'return new Matrix(1)
		  'end if
		  
		  n = NbSommSur
		  
		  select case n
		  case 0
		    'if shapes.element(0) isa parallelogram then
		    's = shapes.element(0)
		    's.points(3). moveto s.Points(0).bpt + s.points(2).bpt- s.points(1).bpt
		    return DefaultMatrix
		    'end if
		  case 1
		    if replacerpoint(Point(somm.element(Listsommsur(0)))) then
		      return autoaffupdate
		    end if
		  case 2
		    t = replacerpoint(Point(somm.element(ListSommsur(0))))
		    t = replacerpoint(Point(somm.element(ListSommsur(1))))
		    return autoaffupdate
		  case 3
		    t = replacerpoint(Point(somm.element(ListSommsur(0))))
		    t = replacerpoint(Point(somm.element(ListSommsur(1))))
		    return autoaffupdate
		  else
		    p = supfig.pointmobile
		    k = somm.getposition(p)
		    if Listsommsur.indexof(k) <> -1 then
		      for i = 0 to 3
		        if i <> k then
		          t =replacerpoint (point(somm.element(Listsommsur(i))))
		        end if
		      next
		    else
		      for i = 0 to n-1
		        t = replacerpoint (point(somm.element(Listsommsur(i))))
		      next
		    end if
		  end select
		  
		  if NbPtsModif > 3 then
		    return new matrix(1)
		  else
		    return autoaffupdate
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autospeupdate1() As Matrix
		  dim p, q, p1, p2 as point
		  dim s as shape
		  dim n, n1, n2 as integer
		  dim ep, np as BasicPoint
		  
		  
		  n = ListPtsModifs(0)
		  s = shapes.element(0)
		  
		  if s isa arc then
		    return arc(s).Modifier1(n)
		  end if
		  
		  p = Point(somm.element(n))
		  getoldnewpos(p, ep, np)
		  choixpointsfixes
		  
		  if  NbUnModif > 2 then
		    return new Matrix(1)
		  end if
		  
		  select case NbSommSur(n)
		  case 0
		    q = point(somm.element(fx1))  // q est le point fixe
		    Select case  NbUnModif
		    case 0, 1
		      return s.modifier1fixe(q,p)
		    case 2
		      return s.modifier2fixes(p)
		    end select
		  case 1
		    
		  case 2
		    n = s.Points.indexof(p)
		    p1 = Point(Somm.element(ListSommSur(0)))
		    p2 = Point(Somm.element(ListSommSur(1)))
		    n1 = s.Points.indexof(p1)
		    n2 = s.Points.indexof(p2)
		    if n <> -1 and NbUnModif = 0 then
		      'if s isa quadri then                             '  Modifications introduites le 19 mai 2014 puis supprimées le 8 juillet 2014  Surveiller!!
		      'if abs(n1-n2) = 2 then
		      return new similaritymatrix(p1, p2, ep, np)
		      'elseif n1= (n+2) mod 4 then
		      'return s.Modifier1fixe(p1,p)
		      'else
		      'return  s.Modifier1fixe(p2,p)
		      'else
		      'return s.Modifier1fixe(p1,p)
		      'end if
		      
		    else
		      return nil
		    end if
		  end select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autospeupdate2() As Matrix
		  dim p, q as point
		  dim n1, n2 as integer
		  dim s as shape
		  dim i as integer
		  
		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  s = shapes.element(0)
		  if s isa arc then
		    return arc(s).Modifier2(n1,n2)
		  end if
		  
		  p = Point(somm.element(n1))
		  q = Point(somm.element(n2))
		  
		  if NbSommSur(n1,n2) = 1 then
		    if  (replacerpoint(p) or replacerpoint(q))  then
		      return autospeupdate
		    else
		      return s.Modifier1fixe(p,q)
		    end if                                             //le 3e sommet est sur et on a replacé un des deux autres qui était également sur
		  else
		    return s.Modify2(p,q)
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autospeupdate3() As Matrix
		  dim p, q , r, ps As point
		  dim ep,eq,er,np,nq,nr as BasicPoint
		  dim i, k, n, n1, n2, n3 as integer
		  dim t as boolean
		  dim s as shape
		  dim ar as arc
		  
		  s = shapes.element(0)
		  if s isa arc  then
		    return arc(s).modifier3
		  end if
		  
		  Choixpointsfixes
		  if NbUnModif > 2 then
		    return new Matrix(1)
		  end if
		  
		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  n3 = ListPtsModifs(2)
		  p = Point(somm.element(n1))
		  q = Point(somm.element(n2))
		  r =Point(somm.element(n3))
		  
		  n = NbSommSur
		  
		  select case n
		  case 0
		    if s isa triangle then
		      return new Matrix(1)
		    else
		      return s.Modifier2fixes(r)
		    end if
		  case 1
		    ps =point(somm.element(ListSommSur(0)))
		    if ps <> supfig.pointmobile and not (ps.isextremityofarc(n, ar) and (n = 2) and (ar.fig = supfig)) then
		      t = replacerpoint(point(somm.element(ListSommSur(0))))
		    else
		      getoldnewpos(p,ep,np)
		      getoldnewpos(q,eq,nq)
		      getoldnewpos(r,er,nr)
		      return new affinitymatrix(ep,eq,er,np,nq,nr)
		    end if
		  case 2
		    for i = 0 to 1
		      if point(somm.element(ListSommSur(i))) <> supfig.pointmobile then
		        t =replacerpoint (point(somm.element(Listsommsur(i))))
		      end if
		    next
		  case 3
		    p = supfig.pointmobile
		    k = somm.getposition(p)
		    if Listsommsur.indexof(k) <> -1 then
		      for i = 0 to 2
		        if i <> k then
		          t =replacerpoint (point(somm.element(Listsommsur(i))))
		        end if
		      next
		    else
		      t = replacerpoint (point(somm.element(Listsommsur(0))))
		      t = replacerpoint (point(somm.element(Listsommsur(1))))
		      't = replacerpoint (point(somm.element(Listsommsur(2))))
		    end if
		  end select
		  
		  return autospeupdate
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autospeupdate4() As Matrix
		  dim p As point
		  
		  dim i, k, n as integer
		  dim t as boolean
		  dim s as shape
		  
		  choixpointsfixes
		  'if NbUnModif > 2 then
		  'return new Matrix(1)
		  'end if
		  
		  n = NbSommSur
		  
		  select case n
		  case 0, 1
		    return DefaultMatrix
		  case 2
		    t =replacerpoint (point(somm.element(Listsommsur(0))))
		    t = replacerpoint (point(somm.element(Listsommsur(1))))
		    if shapes.element(0)  isa rect and abs(listsommsur(0)-listsommsur(1)) = 2  then
		      return autoaffupdate
		    end if
		  case 3,4
		    p = supfig.pointmobile
		    k = somm.getposition(p)
		    if Listsommsur.indexof(k) <> -1 then
		      for i = 0 to 2
		        if i <> k then
		          t =replacerpoint (point(somm.element(Listsommsur(i))))
		        end if
		      next
		    else
		      t = replacerpoint (point(somm.element(Listsommsur(0))))
		      t = replacerpoint (point(somm.element(Listsommsur(1))))
		    end if
		  end select
		  
		  return autospeupdate
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autotrapupdate2() As Boolean
		  dim p,  q, r as point
		  dim s as trap
		  dim t as boolean
		  dim n1, n2 as integer
		  
		  if fx1 = -1 then
		    choixpointsfixes
		  end if
		  
		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  p = Point(somm.element(n1))
		  q = Point(somm.element(n2))
		  s = trap(shapes.element(0))
		  
		  return s.trapupdate2(p,q)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autotrapupdate3() As Boolean
		  dim p,  q, r as point
		  dim  n1, n2, n3 as integer
		  
		  dim s as trap
		  
		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  n3 = ListPtsModifs(2)
		  p = Point(somm.element(n1))
		  q = Point(somm.element(n2))
		  r = Point(somm.element(n3))
		  
		  s = trap(shapes.element(0))
		  
		  return s.trapupdate3(p, q, r)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autotrapupdate4() As Boolean
		  dim s as trap
		  dim i as integer
		  dim p as point
		  dim n, m as integer
		  dim t as Boolean
		  
		  s = trap(shapes.element(0))
		  
		  
		  if NbSommSur > 0  and not s isa trapiso and not s isa traprect then
		    for i =0 to 3
		      if replacerpoint(s.points(i)) then
		        return autotrapupdate
		      end if
		    next
		  else
		    if shapes.element(0).duplicateorcut then
		      return true
		    else
		      return s.check
		    end if
		  end if
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isafigprp(byref s as shape) As Boolean
		  dim i, n, m as integer
		  dim sh, sh0 as shape
		  dim ff as figure
		  
		  for i = 0 to shapes.count-1
		    sh = shapes.element(i)
		    if  sh.constructedby <> nil then
		      if sh.constructedby.oper = 6 then
		        m = m +1
		      elseif sh isa droite and sh.constructedby.oper < 3 then
		        if n = 0 then
		          sh0 = sh
		          ff = sh.constructedby.shape.fig
		          n = 1
		        elseif  ff <> sh.constructedby.shape.fig then
		          n = n+1
		        end if
		      end if
		    end if
		  next
		  
		  if m =  0 and  n = 1 then
		    s = sh0
		    return true
		  else
		    s = nil
		    return false
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsaPoint() As point
		  if shapes.count = 1 and shapes.element(0) isa point then
		    return point(shapes.element(0))
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbSommCommuns(f as figure) As integer
		  dim i,j,n as integer
		  dim p as point
		  
		  n = NbTrueSommCommuns(f)
		  
		  for i = 0 to Somm.count-1
		    for j = 0 to f.PtsConsted.count-1
		      if Somm.Element(i) = f.PtsConsted.element(j) and (f.somm.getposition(f.ptsconsted.element(j)) =-1)    then
		        n = n+1
		      end if
		    next
		  next
		  
		  for i = 0 to PtsConsted.count-1
		    for j = 0 to f.Somm.count-1
		      if PtsConsted.Element(i) = f.Somm.element(j) and (somm.getposition(PtsConsted.element(i)) = -1) then
		        n = n+1
		      end if
		    next
		  next
		  
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Canceltrace()
		  dim i As integer
		  
		  for i = 0 to shapes.count -1
		    shapes.element(i).canceltrace
		  next
		  
		  for i = 0 to PtsConsted.count - 1
		    PtsConsted.element(i).tracept = false
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setfigconstructioninfos()
		  dim i as integer
		  dim s as shape
		  dim tsf as transformation
		  
		  for i = 0 to shapes.count-1
		    s = shapes.element(i)
		    if s.constructedby <> nil and s.constructedby.oper = 6 then
		      tsf = transformation(s.constructedby.data(0))
		      tsf.setconstructioninfos2(s.constructedby.shape,s)
		    end if
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isempty() As boolean
		  return (shapes.count = 0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function figduplicateorcut(byref s as shape) As Boolean
		  dim t as Boolean
		  dim i as integer
		  
		  for i = 0 to shapes.count-1
		    s = shapes.element(i)
		    if s.duplicateorcut and s.constructedby.shape.getindexpoint(supfig.pointmobile)<> -1 then
		      return true
		    end if
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub unmodify(p as point)
		  dim i as integer
		  dim ep, np as BasicPoint
		  dim f as figure
		  
		  getoldnewpos(p,ep,np)
		  
		  
		  p.modified = false
		  p.moveto ep
		  for i = 0 to ubound(p.constructedshapes)
		    f = p.constructedshapes(i).fig
		    f.unmodify point(p.constructedshapes(i))
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLPutInContainer(k as integer, Doc As XMLDocument)
		  dim EL, EL1, Temp as XMLElement
		  dim i as integer
		  
		  if k = 0 and currentcontent.drapabort then
		    return
		  end if
		  
		  if k = 0  then
		    EL = CurrentContent.FigsDeleted
		  else
		    EL = CurrentContent.FigsCreated
		  end if
		  
		  if EL.childcount = 0 then
		    Temp =  Doc.CreateElement(Dico.Value("Objects"))
		    EL.appendchild Temp
		  end if
		  
		  EL1 = XMLElement(EL.FirstChild)
		  
		  for i = 0 to shapes.count-1
		    EL1.appendchild shapes.element(i).XMLPutInContainer(Doc)
		  next
		  for i = 0 to PtsConsted.count-1
		    EL1.appendchild PtsConsted.element(i).XMLPutInContainer(Doc)
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PossibleDrag(op as operation) As Boolean
		  dim i, j, k, m as integer
		  dim ffs, ffbut as figure
		  dim tsf as transformation
		  dim sh as shape
		  dim pt as point
		  dim t  as Boolean // Le choix de cette figure est-il valide pour un mouvement?
		  
		  
		  // on ne peut pas déplacer une figure dont une forme est image d'une autre par une transfo
		  // sauf si
		  // la source et le support de la transfo sont dans la même figure que l'image
		  //ou si cette forme est une paraperp et on ne tourne pas ni ne retourne (t1)
		  //ou si la transfo est une translation et le mouvement est glisser (t2)
		  
		  t = true
		  
		  for  i = 0 to ubound(constructioninfos) // on considère toutes les tsf qui appliquent au moins une forme dans self
		    ffs = constructioninfos(i).sourcefig
		    tsf = constructioninfos(i).tsf
		    
		    if  (( ffs <> self)  or (tsf.supp.fig <> self))  then  //on ne s'intéresse qu'aux cas où la figure source ou la figure du support de tsf diffèrent de self
		      // il faut chercher des conditions qui interdisent le mouvement c'est-à-dire tester si on est dans une exception
		      // exception notamment si tsf est une translation, l'oper est un glissement et la source est dans self
		      
		      if not (tsf.type = 1 and op isa glisser and ffs = self) and not (tsf.type = 2 and op isa tourner and tourner(op).c = tsf.supp.points(0).bpt and  ffs = self) then
		        for j = 0 to shapes.count-1
		          // test des formes de self
		          sh = shapes.element(j)
		          // exception si les formes de self sont des paraperp et l'oper est glisser ou redimensionner
		          t = t and (sh.isaparaperp and (op isa Glisser or op isa Redimensionner) )
		        next
		      end if
		    end if
		  next
		  
		  // on ne peut pas non plus déplacer une figure ff contenant une forme qui supporte une tsf dont l'image et la source sont égales
		  // sauf si la figure de l'image coïncide avec ff
		  
		  for i = 0 to shapes.count-1
		    sh = shapes.element(i)
		    t = t and sh.PossibleDrag
		    for j = 0 to ubound(sh.childs)
		      t = t and sh.childs(j).PossibleDrag
		    next
		  next
		  
		  return t
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updateshapes()
		  dim i as integer
		  
		  for i = 0 to shapes.count-1
		    if not shapes.element(i).invalid then
		      shapes.element(i).updateshape
		      shapes.element(i).modified = true
		    end if
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function fusionsubfigs(f1 as figure, f2 as figure) As Boolean
		  dim k as integer
		  dim t, t1 as boolean
		  dim p as point
		  
		  
		  'if ( f1.supfig <> f2.supfig)  and (f1.somm.count >1) then
		  'return false
		  'end if
		  '
		  ' if (f1.auto <> f2.auto) and (f1.somm.count > 2) then
		  'return false
		  'end if
		  
		  if (f1.supfig <> f2.supfig) or (f1.auto <> f2.auto)  or (f1.auto=3) or (f2.auto=3) then
		    return false
		  end if
		  
		  t = true
		  for k = 0 to f1.somm.count-1
		    p = point(f1.somm.element(k))
		    t1 = (p.pointsur.count = 2) and (f2.shapes.getposition(p.pointsur.element(0)) <> -1) and (f2.shapes.getposition(p.pointsur.element(1))<> -1)
		    t = t and((f2.somm.getposition(p)<> -1) or t1)
		  next
		  
		  if t then
		    f2.shapes.concat f1.shapes
		    f2.somm.concat f1.somm
		    f2.PtsSur.concat f1.PtsSur
		    f2.PtsConsted.concat f1.PtsConsted
		  end if
		  
		  return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub enablemodifyall()
		  dim i as integer
		  
		  modified = false
		  for i = 0 to somm.count-1
		    point(somm.element(i)).enablemodify
		  next
		  
		  for i = 0 to ptssur.count-1
		    point(ptssur.element(i)).enablemodify
		  next
		  
		  for i = 0 to ptsconsted.count-1
		    point(ptsconsted.element(i)).enablemodify
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function standard() As Boolean
		  dim i as integer
		  
		  for i = 0 to shapes.count -1
		    if shapes.element(i).std then
		      return true
		    end if
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Autosimupdate2() As Matrix
		  dim p, q as point
		  dim ep, eq, np, nq as basicPoint
		  dim n1, n2 as integer
		  
		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  p = Point(somm.element(n1))
		  q = Point(somm.element(n2))
		  
		  choixpointsfixes
		  
		  select case NBSommSur(n1,n2)
		  case 0, 2
		    if NbUnmodif = 0 then
		      return DefaultMatrix
		    else
		      return new Matrix(1)
		    end if
		  case 1                                       //ce cas apparait
		    'if  replacerpoint(p) or replacerpoint(q) then
		    'return   autosimupdate
		    'else
		    return DefaultMatrix
		    'end if
		  end select
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbSommSur(n1 as integer, n2 as integer) As integer
		  dim i, n as integer
		  Redim ListSommSur(-1)
		  dim p as point
		  
		  // Liste des "sommets sur"  non modifiés  différents des points modifiés
		  for i = 0 to Somm.count-1
		    if i <> n1 and i <> n2 then
		      p = Point(somm.element(i))
		      if p.pointsur.count = 1 and P.liberte = 1 and not p.modified  then
		        n = n+1
		        ListSommSur.append i
		      end if
		    end if
		  next
		  
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbSommSur() As integer
		  dim i, n as integer
		  Redim ListSommSur(-1)
		  dim p as point
		  
		  // Liste des "sommets sur"  modifiables
		  for i = 0 to Somm.count-1
		    p = Point(somm.element(i))
		    if (p.forme = 1  ) and P.liberte = 1 and not p.unmodifiable  then
		      n = n+1
		      ListSommSur.append i
		    end if
		  next
		  
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbSommSur(n1 as integer, n2 as integer, n3 as integer) As integer
		  dim i, n as integer
		  Redim ListSommSur(-1)
		  dim p as point
		  
		  // Liste des "sommets sur"  non modifiés  différents des points modifiés
		  for i = 0 to Somm.count-1
		    if i <> n1 and i <> n2 and i <> n3 then
		      p = Point(somm.element(i))
		      if p.pointsur.count = 1 and P.liberte = 1 and not p.modified  then
		        n = n+1
		        ListSommSur.append i
		      end if
		    end if
		  next
		  
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DefaultMatrix() As Matrix
		  dim ep, eq, er, np, nq, nr as BasicPoint
		  dim p, q, r as point
		  dim n1, n2, n3 as integer
		  
		  
		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  p = Point(somm.element(n1))
		  q = Point(somm.element(n2))
		  getoldnewpos(p,ep,np)
		  getoldnewpos(q,eq,nq)
		  
		  select case auto
		  case 0,1
		    return new SimilarityMatrix(ep,eq,np,nq)
		  case 2,3
		    n3 = ListPtsModifs(2)
		    r = Point(somm.element(n3))
		    getoldnewpos(r,er,nr)
		    return new AffinityMatrix(ep,eq,er,np,nq,nr)
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub addconstructedfigs(figs as figslist, s as shape)
		  dim ci as constructioninfo
		  dim k as integer
		  dim sh as shape
		  
		  ci = s.constructedby
		  if (ci <> nil) and (ci.shape <> nil) and (ci.oper = 3 or ci.oper = 5  or (ci.oper = 9 and  s isa point) )  then
		    Figs.addfigure ci.shape.fig
		  end if
		  if ci <> nil and ci.oper = 9 and not s isa point  then
		    sh = shape(ci.data(0))
		    Figs.addfigure sh.fig
		    sh = shape(ci.data(2))
		    Figs.addfigure sh.fig
		  end if
		  for k = 0 to s.tsfi.count-1
		    figs.appendlist s.tsfi.element(k).constructedfigs
		  next
		  for k = 0 to ubound(s.constructedshapes)
		    'if s.constructedshapes(k).constructedby.oper = 6 then
		    'figs.addfigure Transformation(s.constructedshapes(k).constructedby.data(0)).supp.fig
		    'end if
		    Figs.addfigure s.constructedshapes(k).fig
		  next
		  for k = 0 to ubound(s.MacConstructedshapes)
		    Figs.addfigure s.MacConstructedshapes(k).fig
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndQQupdateshapes()
		  dim i as integer
		  dim p as point
		  
		  
		  for i = 0 to ptssur.count-1
		    p = point(ptssur.element(i))
		    if p.pointsur.count = 1 then
		      P.puton (P.pointsur.element(0), p.location(0))
		      p.modified = true
		      p.updateshape
		    end if
		  next
		  
		  for i = 0 to PtsConsted.count-1
		    p = Point(Ptsconsted.element(i))
		    p.repositioncstedpoint
		    p.modified = true
		    p.updateshape
		  next
		  
		  updateshapes
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndTrapUpdateshapes()
		  dim i as integer
		  dim p as point
		  
		  for i = 0 to somm.count-1
		    p = point(somm.element(i))
		    select case  p.pointsur.count
		    case  1
		      p.puton p.pointsur.element(0)
		      p.unmodifiable = true
		    end select
		    p.modified = true
		    p.updateshape
		  next
		  
		  EndQQupdateshapes
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbTrueSommCommuns(f as figure) As integer
		  dim i, j, n as integer
		  
		  for i = 0 to Somm.count-1
		    for j = 0 to f.Somm.count-1
		      if Somm.Element(i) = f.Somm.element(j) then
		        n = n+1
		      end if
		    next
		  next
		  
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbPtsModifSurDr() As integer
		  dim i as integer
		  dim dr as shape
		  
		  Redim ListPtsModifs(-1)
		  //Décompte et liste les sommets de la forme n°0 qui ont déjà été modifiés
		  
		  NbModif = 0
		  Dr = Shapes.element(0)
		  
		  for i = 0 to ubound(Dr.points)
		    if Dr.Points(i).modified   then
		      NbModif = NbModif+1
		      ListPtsModifs.append i
		    end if
		  next
		  
		  return NbModif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatematrixduplicatedshapes(M as Matrix)
		  dim i as integer
		  
		  
		  for i = 0 to shapes.count-1
		    shapes.element(i).updatematrixduplicatedshapes(M)
		  next
		  for i = 0 to somm.count-1
		    point(somm.element(i)).updatematrixduplicatedshapes(M)
		  next
		  for i = 0 to PtsConsted.count-1
		    point(PtsConsted.element(i)).updatematrixduplicatedshapes(M)
		  next
		  for i = 0 to PtsSur.count-1
		    point(PtsSur.element(i)).updatematrixduplicatedshapes(M)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifaffine(p as point) As Boolean
		  dim M as Matrix
		  
		  M= autoaffupdate
		  if M = nil or M.v1 = nil then
		    return true
		  end if
		  updatesomm(M)
		  updateshapes(M)
		  if not wnd.drapbug then
		    return checksimaff(M)
		  else
		    return true
		  end if
		  
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ModifEucli(p As point) As Boolean
		  dim M as Matrix
		  
		  M= autosimupdate
		  if M = nil or M.v1 = nil then
		    return false
		  else
		    updatesomm(M)
		    updateshapes(M)
		    if not wnd.drapbug then
		      return checksimaff(M)
		    else
		      return true
		    end if
		  end if
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub listersubfigs(p as point)
		  dim i, j, k, n as integer
		  redim index(-1)
		  
		  n =Subs.count-1
		  if n = 0 then
		    index.append 0
		    return
		  end if
		  
		  
		  while ubound(index) < n
		    i = choixsubfig(p) //on choisit une sous fig qui n'est précédée d'aucune autre
		    if  i <> -1  then
		      index.append i
		      for k = 0 to n-1
		        for j = 0 to n
		          if Sommes(k,j) > 0 and index.indexof(j) = -1 and OKToInsert(j) then
		            index.append j
		          end if
		        next
		      next
		    end if
		  wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OKToInsert(j as integer) As Boolean
		  dim i, n as integer
		  dim t as Boolean
		  
		  n = Mat.nc-1 //Toutes les sous-fig qui précèdent sub(j) ont-elles été insérées?
		  
		  t = true
		  
		  for i = 0 to n
		    if  Mat.Col(i,j) = 1 then  // y a-t-il au moins une sous-figure qui précède subs(j) et a déjà été insérée?
		      t = (t and index.indexof(i) <> -1)
		    end if
		  next
		  
		  return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ChoixSubfig(p as point) As integer
		  dim h, i,j,n, imax as integer
		  dim dispo(-1) as integer
		  dim sf as figure
		  
		  
		  n = subs.count -1
		  
		  //1ere étape: Y a-t-il des sous-figures non encore modifiées qui contiennent le point mobile et ne sont précédées d'aucune autre sous-figure ?
		  
		  for i = 0 to n
		    if  index.indexof(i) = -1 then
		      sf = subs.element(i)
		      if (sf.somm.getposition(p) <> -1 or sf.ptssur.getposition(p) <> -1) and (sommes(0,i) = 0) then
		        dispo.append i
		      end if
		    end if
		  next
		  
		  if ubound(dispo) = -1 then  //   2eme étape  Si on n'a trouvé aucune sous-figure contenant le point mobile, on recommence
		    for i = 0 to n
		      if  index.indexof(i) = -1 then
		        if  (sommes(0,i) = 0) then
		          dispo.append i
		        end if
		      end if
		    next
		  end if
		  
		  return choixsubfig2bis(dispo)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ChoixSubfig2(dispo() as integer) As integer
		  'dim h, k, i, n as integer
		  'dim ma, imax, nvois as integer
		  '
		  'n = subs.count-1
		  '
		  'if ubound(dispo) = 0 then
		  'return dispo(0)
		  'elseif ubound(dispo) > -1 then
		  'ma = 0
		  'imax = -1
		  'for i = 0 to ubound(dispo)
		  'k = dispo(i)
		  'nvois = 0
		  'for h = 0 to n
		  'if h <>k and  index.indexof(h) <> -1 and (subs.element(k).NbSommCommuns(subs.element(h)) > 0) then
		  'nvois = nvois+1
		  'end if
		  'next
		  'if nvois > ma then
		  'ma = nvois
		  'imax = k
		  'end if
		  'next
		  'if imax = -1 then
		  'ma = 0
		  'for i = 0 to ubound(dispo)
		  'nvois = subs.element(dispo(i)).somm.count
		  'if nvois > ma then
		  'ma = nvois
		  'imax = dispo(i)
		  'end if
		  'next
		  'end if
		  'return imax
		  'else
		  'return -1
		  'end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As String
		  return "Figure "+str(idfig)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ChoixSubFig2bis(dispo() as integer) As integer
		  dim h, k, i, iret as integer
		  dim n as integer
		  dim ff, ff1 as figure
		  dim p as point
		  dim  libe() as integer
		  dim s as shape
		  dim t as boolean
		  
		  n = subs.count-1
		  
		  if ubound(dispo) = 0 then
		    return dispo(0)
		  elseif ubound(dispo) > -1 then
		    redim libe(ubound(dispo))
		    
		    for i = 0 to ubound(dispo)
		      ff = subs.element(dispo(i))
		      s = ff.shapes.element(0)
		      n = 0
		      for h = 0 to ff.somm.count
		        p = point(ff.somm.element(h))
		        t = false
		        for k = 0 to n
		          t = t or ( (k<> i) and ( index.indexof(k) <> -1) and (subs.element(k).somm.getposition(p) <> -1))
		        next
		        if t then
		          n = n+1
		        end if
		      next
		      select case ff.auto
		      case 0
		        libe(i) = 0
		      case 1
		        libe(i) = 4 - 2*n
		      case 2
		        libe(i) = 6 - 2*n
		      case 3
		        libe(i) = 5 - 2*n
		      case 4
		        libe(i) = 2*s.npts - 2*n
		      case 5
		        if s isa traprect  or s isa trapiso then
		          libe(i) = 6-2*n
		        else
		          libe(i) = 7-2*n
		        end if
		      case 6
		        libe(i) = 3 -2*n
		      end select
		      if libe(i) < 0 then
		        libe(i) = 0
		      end if
		    next
		    
		    for i = 0 to ubound(dispo)
		      if libe(i) > n then
		        n = libe(i)
		        iret = dispo(i)
		      end  if
		    next
		    return iret
		    
		  else
		    return -1
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateptsconsted(M as Matrix)
		  dim i as integer
		  dim p as point
		  
		  if shapes.element(0) isa arc and not shapes.element(0).invalid then
		    arc(shapes.element(0)).computearcangle
		  end if
		  for i = 0 to PtsConsted.count-1
		    p = Point(Ptsconsted.element(i))
		    if p.constructedby.oper = 0 or p.constructedby.oper = 4 then
		      p.repositioncstedpoint
		    else
		      if somm.getposition(p)=-1 then
		        p.transform(M)
		      end if
		    end if
		    p.modified = true
		    p.updateshape
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdatePtsSur(M as Matrix)
		  dim i as integer
		  dim p as point
		  
		  'Les pointssur doivent être considérés comme modifiés même si le déplacement est faible,(pour la mise à jour des formes dont ils sont sommets).
		  for i = 0 to ptssur.count-1
		    p = point(ptssur.element(i))
		    select case  p.pointsur.count
		    case 1
		      if not p.pointsur.element(0) isa arc then
		        p.transform(M)                                  //Pas bon pour les arcs: les affinités ne conservent pas ls angles
		      else
		        p.puton p.pointsur.element(0), p.location(0)
		      end if
		      p.modified = true
		      p.updateshape
		    end select
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fx1cancel()
		  dim i as integer
		  
		  fx1 = -1
		  for i = 0 to subs.count-1
		    subs.element(i).fx1=-1
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AutoAffUpDate2Bis(s1 as shape, s2 as shape, p as point, q As point, p1 as point, p2 as point) As Matrix
		  dim pmob, pq as point
		  dim BiB1, BiB2 as BiBPoint
		  dim ep, np, bp, eq, nq as BasicPoint
		  dim r1, r2 as double
		  dim n1,n2 as integer
		  
		  pmob = supfig.pointmobile
		  if s1 isa droite then
		    n1 = droite(s1).nextre
		  else
		    n1 = 0
		  end if
		  if s2 isa droite then
		    n1 = droite(s2).nextre
		  else
		    n1 = 0
		  end if
		  
		  if pmob <> p and pmob <> q then  'pmob est p ou q
		    return nil
		  elseif pmob <> p then
		    pq = p
		    p = q
		    q = pq
		  end if                                        'le point mobile est tjrs p le point d'inter est tjrs q
		  getoldnewpos(p,ep,np)
		  getoldnewpos(q,eq,nq)
		  
		  BiB1 = p1.GetBiBPoint
		  BiB2 = p2.GetBiBPoint
		  bp = BiB2.first - Bib2.second
		  BiB2 = new BiBPoint(np, np+bp)
		  bp = BiB1.BiBInterdroites(BiB2,n1,n2,r1,r2)
		  
		  if bp <> nil then
		    return new affinitymatrix(eq,p1.bpt,ep,nq,bp,np)
		  else
		    return new matrix(1)
		  end if
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod


	#tag Note, Name = Licence
		
		Copyright © 2010 CREM
		Noël Guy - Pliez Geoffrey
		
		This file is part of Apprenti Géomètre 2.
		
		Apprenti Géomètre 2 is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.
		
		Apprenti Géomètre 2 is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.
		
		You should have received a copy of the GNU General Public License
		along with Apprenti Géomètre 2.  If not, see <http://www.gnu.org/licenses/>.
	#tag EndNote


	#tag Property, Flags = &h0
		Shapes As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		Subs As FigsList
	#tag EndProperty

	#tag Property, Flags = &h0
		Somm As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		Supfig As Figure
	#tag EndProperty

	#tag Property, Flags = &h0
		Oldbpts(-1) As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		index(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		PointsFixes(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		fx1 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		fx2 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ListPtsModifs(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ListSommSur(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Mat As MatrixnD
	#tag EndProperty

	#tag Property, Flags = &h0
		M1 As MatrixnD
	#tag EndProperty

	#tag Property, Flags = &h0
		PtsConsted As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		PtsSur As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		figsimages As figslist
	#tag EndProperty

	#tag Property, Flags = &h0
		AssocFigs As FigsList
	#tag EndProperty

	#tag Property, Flags = &h0
		oldptscsted(-1) As basicpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		oldptssur(-1) As basicpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ListeSupportsTsf(-1) As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Matrice du déplacement précédent
		#tag EndNote
		Mmove As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		oldconstructedby As figconstructioninfo
	#tag EndProperty

	#tag Property, Flags = &h0
		chosen As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		idfig As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Constructioninfos(-1) As FigConstructioninfo
	#tag EndProperty

	#tag Property, Flags = &h0
		constructedfigs As figslist
	#tag EndProperty

	#tag Property, Flags = &h0
		ListSommSurModif(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		NbUnModif As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		NbModifUnmodif As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		pointmobile As point
	#tag EndProperty

	#tag Property, Flags = &h0
		NbModif As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		auto As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		epold As basicpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ptfx0(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		invalidpts(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		invalidptssur(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		invalidptscsted(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Mmodif As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		MP(-1) As MatrixnD
	#tag EndProperty

	#tag Property, Flags = &h0
		oldcentres(-1) As basicpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		nff(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Sommes(-1,-1) As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Modified As Boolean
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
			Name="fx1"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fx2"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="chosen"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="idfig"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NbUnModif"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NbModifUnmodif"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NbModif"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="auto"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Modified"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
