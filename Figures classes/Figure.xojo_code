#tag Class
Protected Class Figure
	#tag Method, Flags = &h0
		Sub AdapterAutos(f1 as figure)
		  ' Adapte le mode de modification automatique d'une figure fusionnée.
		  ' Détermine le mode le plus approprié pour éviter déformations et blocages.
		  ' @param f1 La figure dont on doit adapter le mode auto
		  const AUTO_FIXED = 0         // Formes fixes (standard)
		  const AUTO_SIMILARITY = 1    // Transformations par similarité
		  const AUTO_AFFINITY = 2      // Transformations affines
		  const AUTO_SPECIAL = 3       // Formes spéciales (arcs, triangles particuliers)
		  const AUTO_FREEFORM = 4      // Formes quelconques (tous points libres)
		  const AUTO_TRAPEZOID = 5     // Trapèzes
		  const AUTO_ISOMETRY = 6      // Isométries
		  const AUTO_PERPENDICULAR = 7 // Droites perpendiculaires/parallèles

		  dim t, tt as boolean
		  dim k, h, j, n, amin as integer
		  dim aut(-1) as integer
		  Dim s As shape

		  For n = 0 To f1.shapes.count-1
		    s = f1.shapes.item(n)
		    If s.constructedby <> Nil And s.isaparaperp Then
		      f1.Auto = AUTO_PERPENDICULAR
		      Return
		    End If
		  Next

		  if f1.shapes.count = 1 then
		    f1.auto = f1.shapes.item(0).auto
		    return
		  end if

		  Redim aut(f1.shapes.count-1)


		  for  j = 0 to f1.Shapes.count-1
		    aut(j) = f1.shapes.item(j).auto
		  next

		  'D'abord un cas simple: toutes les formes ont même auto (différent de 3 (autospe) et 5 (autotrap)
		  'On attribue cet auto à la figure.
		  For  n = 0 To 7
		    t = True
		    for j = 0 to ubound(aut)
		      t  = t and (aut(j) = n)
		    next
		    if t then
		      select case n
		      Case AUTO_FIXED, AUTO_SIMILARITY, AUTO_AFFINITY, AUTO_FREEFORM, AUTO_ISOMETRY, AUTO_PERPENDICULAR
		        f1.auto = n
		      end select
		      return
		    end if
		  next

		  ''Deuxième cas: toutes les formes sont autosim ou autoaff
		  t = true
		  for j = 0 to ubound(aut)
		    t  = t and ((aut(j) = AUTO_SIMILARITY) or (aut(j) = AUTO_AFFINITY))
		  next
		  if t then
		    tt = true
		    for j = 0 to f1.shapes.count -1
		      if aut(j) = AUTO_SIMILARITY then
		        tt = tt and ( (F1.shapes.item(j) isa BiPoint) or (F1.shapes.item(j) isa FreeCircle) or (F1.shapes.item(j) isa polyqcq and f1.shapes.item(j).npts = 3) )
		      else
		        tt = false
		      end if
		    next

		    if tt then 'tout point peut être modifié indépendamment des autres
		      f1.Auto = AUTO_FREEFORM
		      return
		    end if

		    tt = true
		    for j = 0 to f1.shapes.count -1
		      tt = tt and (aut(j) = AUTO_AFFINITY or  (F1.shapes.item(j) isa BiPoint) or (F1.shapes.item(j) isa FreeCircle) or (F1.shapes.item(j) isa polyqcq and f1.shapes.item(j).npts = 3) )
		    next
		    if tt then
		      f1.auto = AUTO_AFFINITY
		    else 'Sinon, on choisit autosim (les autoaff ne seront pas déformées)
		      f1.auto = AUTO_SIMILARITY
		    end if
		    return

		  end if

		  'Troisième cas: toutes les formes sont autosim ou paraperp
		  t = true
		  for j = 0 to ubound(aut)
		    t  = t And ((aut(j) = AUTO_SIMILARITY) Or (aut(j) = AUTO_PERPENDICULAR))
		  next
		  if t then
		    f1.Auto = AUTO_PERPENDICULAR
		    return
		  end if

		  'Quatrième cas toutes les formes sont autosim sauf une qcq dont tous les points sont sur les autres

		  t = true
		  for j = 0 to ubound(aut)
		    t  = t and ((aut(j) = AUTO_SIMILARITY) or (aut(j) = AUTO_FREEFORM))
		  next
		  if t then
		    'tt = true
		    for j = 0 to ubound(aut)
		      if aut(j) = AUTO_FREEFORM then
		        s = f1.shapes.element(j)
		        k = -1
		        for h = 0 to s.npts-1
		          s.points(h).HasAutosimParent(k)
		        next
		      end if
		      'if tt then
		      If k <> -1 Then
		        f1.auto = AUTO_SIMILARITY
		      end if
		    next
		    Return
		  end if

		  'Cinquième: s'il y a un mélange de droites avec des formes de même auto

		  For n = 1 To 7
		    If n <> 4 Then 'On élimine les droites
		      t = true
		      For j = 0 To ubound(aut)
		        s = f1.shapes.item(j)
		        t  = t And ( (s IsA BiPoint and not s.isaparaperp ) Or aut(j) = n)
		      Next
		      If t Then
		        f1.Auto = n
		        Return
		      End If
		    End If
		  Next


		  'Sixième: si la variété est plus grande, on prend pour auto 1 si une des formes est autosim, sinon 2 si
		  'une des formes est autoaff, etc
		  for j = 0 to ubound(aut)
		    if aut(j)<>0 then
		      amin = aut(j)
		    end if
		  next
		  for j = 0 to ubound(aut)
		    if aut(j) <> 0 then
		      amin = min(amin,aut(j))
		    end if
		  next
		  if amin <> 4 then
		    f1.auto = amin
		  end if
		  return


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub addconstructedfigs(figs as figslist, s as shape)
		  ' Ajoute récursivement les figures qui ont servi à construire une forme.
		  ' @param figs Liste des figures à compléter
		  ' @param s La forme dont on cherche les figures de construction
		  const OPER_DERIVE = 3        // Opération de dérivation
		  const OPER_INTERSECT = 5     // Opération d'intersection
		  const OPER_TRANSFORM = 6     // Opération de transformation
		  const OPER_COPY = 9          // Opération de copie
		  const OPER_PROJECT = 10      // Opération de projection

		  Dim ci As constructioninfo
		  dim k as integer
		  Dim sh As shape


		  ci = s.constructedby
		  if (ci <> nil) and (ci.shape <> nil) and (ci.oper = OPER_DERIVE or ci.oper = OPER_INTERSECT or (ci.oper = OPER_COPY and s isa point) )  then
		    Figs.addobject ci.shape.fig
		  end if
		  if ci <> nil and ci.oper = OPER_COPY and not s isa point  then
		    sh = shape(ci.data(0))
		    Figs.addobject sh.fig
		    sh = shape(ci.data(2))
		    Figs.addobject sh.fig
		  end if
		  for k = 0 to s.tsfi.count-1
		    figs.appendlist s.tsfi.item(k).constructedfigs
		  next
		  For k = 0 To ubound(s.constructedshapes)
		    'if s.constructedshapes(k).constructedby.oper = 6 then
		    'figs.addfigure Transformation(s.constructedshapes(k).constructedby.data(0)).supp.fig
		    'end if
		    Figs.addobject s.constructedshapes(k).fig
		  Next

		  for k = 0 to ubound(s.MacConstructedshapes)
		    Figs.addobject s.MacConstructedshapes(k).fig
		  next

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function alignement() As boolean
		  ' Vérifie qu'aucun point modifié n'est aligné avec deux points fixes
		  ' ou deux points contraints sur une forme.
		  ' @return True si un alignement problématique est détecté
		  dim i, j, k as integer
		  dim bq1,bq2, ep, np as basicpoint
		  dim p as point

		  dim pfx(-1) As integer

		  for i = 0 to somm.count-1
		    if  ListPtsModifs.IndexOf(i) = -1 then
		      if  ((somm.item(i).liberte = 0) and PtsConsted.getposition(somm.item(i)) = -1) or somm.item(i).liberte = 1 then
		        pfx.append i
		      end if
		    end if
		  next


		  if (auto =2 or auto = 3) then
		    for i = 0 to ubound(ListPtsModifs)
		      p = somm.item(ListPtsModifs(i))
		      getoldnewpos(p,ep,np)
		      for j =  ubound(pfx) downto 1
		        bq1 = somm.item(pfx(j)).bpt
		        for k =  i-1 downto 0
		          bq2 = somm.item(pfx(k)).bpt
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
		Function associerfigs() As figslist
		  dim i , k, h as integer
		  dim figs as figslist
		  dim p as point

		  figs = new FigsList

		  for i = 0 to shapes.count -1
		    addconstructedfigs(figs, shapes.item(i))
		  next

		  for i = 0 to somm.count-1
		    addconstructedfigs(figs, somm.item(i))
		  next

		  const OPER_PROJECT = 10  // Opération de projection

		  for h = 0 to PtsSur.count-1
		    addconstructedfigs(figs, PtsSur.item(h) )
		    if PtsSur.item(h).constructedby <> nil and Ptssur.item(h).constructedby.oper = OPER_PROJECT then
		      figs.addobject Ptssur.item(h).constructedby.shape.fig
		    end if
		    for k = 0 to  ubound(Ptssur.item(h).constructedshapes)
		      if Ptssur.item(h).constructedshapes(k).constructedby.oper = 10 then
		        figs.addobject Ptssur.item(h).constructedshapes(k).fig
		      end if
		    next
		  next

		  for h = 0 to PtsConsted.count-1
		    p = point(PtsConsted.item(h))
		    for k = 0 to  ubound(p.parents)
		      figs.addobject p.parents(k).fig
		    next
		    for k = 0 to ubound(p.constructedshapes)
		      Figs.addobject p.constructedshapes(k).fig
		    next
		  next

		  return figs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Autoaffupdate() As Matrix
		  ' Dispatcher pour le calcul de matrice affine selon le nombre de points modifiés.
		  ' @return Matrice affine appropriée (jusqu'à 4 points pour détermination complète)
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
		Function autoaffupdate1() As Matrix
		  ' Calcule matrice affine avec 1 point modifié.
		  ' Point sur forme ou libre - constrain l'une des 6 degrés de liberté
		  ' @return Matrice affine ou neutre si conflit
		  dim p, p1, p2 as point                    ' points d'appui pour l'affinité
		  dim bp1, bp2 as BasicPoint                ' positions de base pour calcul affinité
		  dim ep, np as BasicPoint                  ' old/new position du point modifié
		  dim i, n, m1, m2, ns as integer           ' indices: n=point modifié, m1/m2=supports

		  n = ListPtsModifs(0)
		  p = somm.item(n)
		  getoldnewpos(p, ep, np)

		  choixpointsfixes

		  if  NbUnModif > 2 then
		    return new Matrix(1)
		  end if


		  select case NbSommSur(n)  'Détermination des sommets sur modifiables différents du point modifié
		  case 0
		    select case NbUnModif
		    case 0
		      ns = somm.count
		      bp1 = somm.item((n+1) mod ns).bpt
		      bp2 = somm.item((n+2) mod ns).bpt
		    case 1, 2
		      bp1 = Somm.item(fx1).bpt
		      bp2 = Somm.item(fx2).bpt
		    end select
		    return new Affinitymatrix (bp1, bp2, ep, bp1, bp2, np)
		  case 1
		    bp1 = Point(Somm.item(fx1)).bpt
		    if Listsommsur(0) <> fx1 then
		      bp2 = Somm.item(Listsommsur(0)).bpt
		    elseif fx2 <> fx1 then
		      bp2 = somm.item(fx2).bpt
		    end if
		    return new Affinitymatrix (bp1, bp2, ep, bp1, bp2, np)
		  case 2
		    if NbUnModif < 2 then
		      bp1 = Somm.item(fx1).bpt
		      p1 = Somm.item(Listsommsur(0))
		      p2 = Somm.item(Listsommsur(1))
		      return new AffinityMatrix(p1,p2,ep,bp1,np,bp1)
		    end if
		  case 3
		    if NbUnModif < 2 then
		      bp1 = Somm.item(fx1).bpt
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
		      p1 = somm.item(m1)
		      p2 = somm.item(m2)
		      return new AffinityMatrix(p1,p2,ep,bp1,np,bp1)
		    end if
		  end select

		  return new Matrix(1)

		  //A revoir pour déterminer les sommets qui ne sont ni modifiés, ni "sur" et les utiliser en cas de besoin comme points fixes



		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Autoaffupdate2() As Matrix
		  ' Calcule matrice affine avec 2 points modifiés.
		  ' 2 points contraignent 4 degrés de liberté (2 translations, 2 angles/échelles)
		  ' @return Matrice affine calculée à partir de 2 points

		  dim p, q, r, p1, p2 as point              ' p,q=points modifiés, r,p1,p2=points supports
		  dim ep, eq, np, nq, ep1, np1, er, nr as BasicPoint  ' old/new positions
		  dim i, n1, n2, n3 as integer               ' indices des points modifiés

		  if NbUnModif > 2 then
		    return new Matrix(1)
		  end if

		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  p = Point(somm.item(n1))
		  q = Point(somm.item(n2))
		  getoldnewpos(p,ep,np)
		  getoldnewpos(q,eq,nq)

		  Choixpointsfixes

		  select case NbSommSur(n1,n2)
		  case 0
		    if NbUnModif < 2 then
		      n3 = -1
		      for i = 0 to somm.count-1
		        if i <> n1 and i <> n2 and (somm.item(i).constructedby <> nil or somm.item(i).macconstructedby <> nil)  then
		          n3 = i
		        end if
		      next
		      if n3 = -1 then
		        if fx1 <> n1 and fx1 <> n2 then
		          n3 = fx1
		        else
		          n3 = fx2
		        end if
		      end if
		      r = somm.item(n3)
		      getoldnewpos(r,er,nr)
		      return new AffinityMatrix (ep, er, eq, np, nr, nq)
		    end if
		  case 1
		    if NbUnModif = 0 then
		      p1 = Point(somm.item(listsommsur(0)))
		      getoldnewpos(p1,ep1,np1)
		      return new AffinityMatrix(ep,eq,ep1,np,nq,np1)
		    end if
		  case 2
		    if NbUnModif = 0 then
		      p1 = Point(somm.item(listsommsur(0)))
		      p2 = Point(somm.item(listsommsur(1)))
		      return AutoAffUpDate2Bis(p1.pointsur.item(0), p2.pointsur.item(0), p, q, p1, p2)
		    end if
		  end select

		  return new Matrix(1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AutoAffUpDate2Bis(s1 as shape, s2 as shape, p as point, q As point, p1 as point, p2 as point) As Matrix
		  dim pmob, pq as point
		  dim BiB1, BiB2 as BiBPoint
		  dim ep, np, bp, eq, nq as BasicPoint
		  dim r1, r2 as double
		  dim n1,n2 as integer

		  pmob = supfig.pmobi
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

	#tag Method, Flags = &h0
		Function Autoaffupdate3() As Matrix
		  ' Calcule matrice affine avec 3 points modifiés.
		  ' Surdétermination : 3 points contraignent les 6 degrés de liberté affins (surcontraint)
		  ' @return Matrice affine calculée par moindres carrés ou tri de points prioritaires

		  dim p, q, r as point                      ' les 3 points modifiés (surcontraint pour affinité)
		  dim ep, eq, er, np, nq, nr As BasicPoint  ' old/new positions des 3 points
		  dim n1, n2, n3, n4 as integer              ' indices des points modifiés
		  dim s as shape                             ' forme d'appui si nécessaire

		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  n3 = ListPtsModifs(2)
		  p = Point(somm.item(n1))
		  q = Point(somm.item(n2))
		  r = Point(somm.item(n3))
		  getoldnewpos(p,ep,np)
		  getoldnewpos(q,eq,nq)
		  getoldnewpos(r,er,nr)

		  Choixpointsfixes
		  if NbUnModif > 0 then
		    return DefaultMatrix
		  end if


		  select case NbSommSur(n1,n2,n3)
		  case 0
		    s  = shapes.item(0)
		    if s.getindexpoint(p) <>-1 and s.getindexpoint(q) <> -1 and s.getindexpoint(r) <> -1 and s isa parallelogram then
		      n4 = parallelogram(s).quatriemepoint(n1,n2,n3)
		      s.points(n4).moveto s.points((n4+1) mod 4).bpt + s.points((n4+3) mod 4).bpt - s.points((n4+2)mod 4).bpt
		      s.points(n4).modified = true
		    end if
		    return new AffinityMatrix(ep,eq,er,np,nq,nr)
		  case 1
		    if replacerpoint(p) or replacerpoint(q) or replacerpoint(r) then
		      return autoaffupdate // on passe à 2 pts modif, 2 pts sur ou 2 pts modif, 3 pts sur
		    else
		      return new Matrix(1)
		    end if
		  end select


		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autoaffupdate4() As Matrix
		  ' Calcule matrice affine avec 4+ points modifiés (cas surdéterminé).
		  ' Nécessite heuristique pour sélectionner les points prioritaires ou utiliser régression
		  ' @return Matrice affine calculée avec gestion des surcontraintes
		  ' Note: Peut retourner matrice neutre si conflit irrésoluble
		  dim p as point
		  dim k, n, i as integer
		  dim t as Boolean

		  Choixpointsfixes
		  'if NbUnModif > 0 then
		  'return new Matrix(1)
		  'end if

		  n = NbSommSur

		  select case n
		  case 0
		    'if shapes.item(0) isa parallelogram then
		    's = shapes.item(0)
		    's.points(3). moveto s.Points(0).bpt + s.points(2).bpt- s.points(1).bpt
		    return DefaultMatrix
		    'end if
		  case 1
		    if replacerpoint(Point(somm.item(Listsommsur(0)))) then
		      return autoaffupdate
		    end if
		  case 2
		    t = replacerpoint(Point(somm.item(ListSommsur(0))))
		    t = replacerpoint(Point(somm.item(ListSommsur(1))))
		    return autoaffupdate
		  case 3
		    t = replacerpoint(Point(somm.item(ListSommsur(0))))
		    t = replacerpoint(Point(somm.item(ListSommsur(1))))
		    return autoaffupdate
		  else
		    p = supfig.pmobi
		    k = somm.getposition(p)
		    if Listsommsur.indexof(k) <> -1 then
		      for i = 0 to 3
		        if i <> k then
		          t =replacerpoint (point(somm.item(Listsommsur(i))))
		        end if
		      next
		    else
		      for i = 0 to n-1
		        t = replacerpoint (point(somm.item(Listsommsur(i))))
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
		Function autoprppupdate() As boolean
		  Dim s As droite
		  Dim i As Integer
		  Dim t As Boolean

		  i = 0

		  t = true
		  For i = 0 To shapes.count-1
		    If shapes.item(i).isaparaperp Then
		      s = droite(shapes.item(i))
		      dim n, j as Integer
		      n = 0
		      For j = 0 To 1
		        If s.points(j).modified Then
		          n = n+1
		        End If
		        if n = 0 and s.points(j).pointSur.count > 0 then
		          n = n+1
		        end if
		      Next
		      Select Case n
		      Case 0
		        t = t And s.prppupdate0
		      Case 1
		        t = t And s.prppupdate1
		      Case 2
		        t = t And s.prppupdate2
		      End Select
		    End If
		  Next

		  Return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AutosimUpdate() As Matrix
		  ' Dispatcher pour le calcul de matrice de similarité selon le nombre de points modifiés.
		  ' @return Matrice de similarité appropriée (Identité si NbPtsModif=0, Autosimupdate1/2/3 sinon)

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
		Function Autosimupdate1() As Matrix
		  ' Calcule matrice de similarité avec 1 point modifié.
		  ' Gère les cas : point libre ou point sur une ou plusieurs formes.
		  ' @return Matrice de similarité (ou matrice neutre en cas de conflit)
		  ' Complexité: O(NbUnModif) - recherche des points fixes indépendants
		  dim p, p1, p2 as point                     ' p=point modifié, p1/p2=points de contrainte
		  dim bp1 as BasicPoint                      ' point de base pour similarité
		  dim ep, np as BasicPoint                   ' old/newPosition du point modifié
		  dim ep1, np1 as BasicPoint                 ' old/newPosition du point de contrainte
		  dim n as integer                           ' index du point modifié
		  dim M as Matrix

		  n = ListPtsModifs(0)
		  p = Point(somm.item(n))
		  getoldnewpos(p, ep, np)

		  Choixpointsfixes

		  if  NbUnModif > 1 then
		    return new Matrix(1)
		  end if

		  select case NbSommSur(n)  'Détermination des sommets sur modifiables différents du point modifié
		  case 0
		    bp1 = Point(Somm.item(fx1)).bpt
		    M = new SimilarityMatrix (bp1, ep,bp1, np)
		  case 1
		    p1 = Point(Somm.item(ListSommSur(0)))
		    getoldnewpos(p1,ep1,np1)
		    if NbUnmodif = 1 then
		      if replacerpoint(p1) then
		        return AutosimUpdate
		      end if
		    else
		      M= new SimilarityMatrix(ep,ep1,np,ep1)
		    end if
		  case 2
		    p1 = Point(Somm.item(ListSommSur(0)))
		    p2 = Point(Somm.item(ListSommSur(1)))
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
		Function Autosimupdate2() As Matrix
		  ' Calcule matrice de similarité avec 2 points modifiés.
		  ' Gère les cas de points sur formes avec contraintes particulières.
		  ' @return Matrice de similarité (ou neutre si 2 points créent un conflit)
		  dim p, q, pmob, p3 as point              ' p, q = points modifiés, pmob = point mobile du parent
		  dim n1, n2, npmob as integer              ' indices des 2 points modifiés et du point mobile
		  dim M as Matrix                           ' matrice résultante
		  dim k as double                           ' coefficient d'homothétie ou scalaire
		  dim s as shape                            ' forme d'appui
		  dim ep, eq, np, nq As BasicPoint          ' old/new positions des points p, q

		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  p = Point(somm.item(n1))
		  q = Point(somm.item(n2))

		  choixpointsfixes

		  select case NBSommSur(n1,n2)
		  case 0, 2
		    return DefaultMatrix
		  case 1
		    M = DefaultMatrix
		    pmob = supfig.pmobi
		    npmob=  Somm.GetPosition(pmob)
		    if npmob= -1 then
		      return M
		    end if
		    p3 = Point(Somm.item(ListSommSur(Ubound(ListSommSur))))
		    s = p3.pointsur.item(0)
		    if not s isa droite then
		      return M
		    end if
		    getoldnewpos(p,ep,np)
		    getoldnewpos(q,eq,nq)
		    k = M.rapport
		    if npmob = n2 then
		      M = new SimilarityMatrix(ep,k,0)
		    else
		      M = new SimilarityMatrix(eq,k,0)
		    end if
		    q.moveto M*eq
		    q.modified = true
		    return M
		  end select







		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autosimupdate3() As Matrix
		  ' Calcule matrice de similarité avec 3+ points modifiés.
		  ' Cas complexe avec gestion des points sur multiples formes.
		  ' @return Matrice de similarité calculée à partir de 3+ points de contrainte
		  ' Note: Cette méthode contient une logique imbriquée complexe (110 lignes)
		  ' TODO: Extraire les cas select/case en sous-méthodes spécialisées
		  const CASE_NONE = 0
		  const CASE_ONE = 1
		  const CASE_TWO = 2
		  const CASE_THREE = 3
		  const INVALID_INDEX = -1
		  dim p, p1, p2 As point
		  dim ep,np,ep1,ep2,np1,np2 as BasicPoint
		  dim i, k, n as integer
		  dim t as boolean
		  dim M as Matrix
		  dim s as shape

		  s = shapes.item(0)
		  if s isa arc then
		    getoldnewpos(s.points(1),ep1,np1)
		    getoldnewpos(s.points(0),ep,np)
		    t = replacerpoint(s.points(2))
		    return  new similaritymatrix (ep1,ep,np1,np)
		  end if


		  Choixpointsfixes
		  p = supfig.pmobi
		  getoldnewpos(p,ep,np)
		  k = somm.getposition(p)
		  n = NbSommSur

		  select case n
		  case 0
		    return DefaultMatrix
		  case 1
		    p1 = point(somm.item(Listsommsur(0)))
		    if replacerpoint(p1) then
		      return autosimupdate
		    end if
		  case 2
		    p1 = point(somm.item(Listsommsur(0)))
		    p2 = point(somm.item(Listsommsur(1)))
		    if k <> -1 and k <> listsommsur(0) and k <> listsommsur(1) then
		      t = replacerpoint(p1)
		      t = replacerpoint(p2)
		      getoldnewpos(p,ep,np)
		      M = new similarityMatrix(p1,p2,ep,np)
		    elseif Listsommsur.indexof(k) <> -1 then
		      for i = 0 to 1
		        if i <> k then
		          t =replacerpoint (point(somm.item(Listsommsur(i))))
		          return autosimupdate
		        end if
		      next
		    end if
		  case 3
		    if k <> -1 then
		      if listsommsur(0) <> k then
		        p1 = point(somm.item(listsommsur(0)))
		        if listsommsur(1) <> k then
		          p2 = point(somm.item(listsommsur(1)))
		        else
		          p2 = point(somm.item(listsommsur(2)))
		        end if
		      else
		        p1 = point(somm.item(listsommsur(1)))
		        p2 = point(somm.item(listsommsur(2)))
		      end if
		      t = replacerpoint(p1)
		      t = replacerpoint(p2)
		      M = new similarityMatrix(p1,p2,ep,np)
		    end if
		  else
		    p1 = point(somm.item(listsommsur(0)))
		    p2 = point(somm.item(listsommsur(1)))
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
		Function autospeupdate() As Matrix
		  ' Dispatcher pour formes spéciales (arcs, triangles isocèles, etc.)
		  ' @return Matrice de transformation adaptée aux contraintes géométriques de la forme
		  select case NbPtsModif
		  case 1
		    return  autospeupdate1
		  case 2
		    return autospeupdate2
		  case 3
		    return autospeupdate3
		  case 4
		    return autospeupdate4
		  end select

		  return new Matrix(1)


		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autospeupdate1() As Matrix
		  ' Modifie forme spéciale avec 1 point modifié.
		  ' Maintient propriétés de la forme (rayon d'arc, isoscélité, etc.)
		  ' @return Matrice spéciale ou neutre si modification invalide
		  dim p, q, p1, p2 as point
		  dim s as shape
		  dim n, n1, n2 as integer
		  dim ep, np as BasicPoint

		  n = ListPtsModifs(0)
		  p = Point(somm.item(n))
		  s = p.parents(0)

		  if s isa arc or s isa DSect then
		    if (n > 1) then
		      lockBoucleArcs
		    end if
		    return s.Modifier1(s.GetIndexPoint(p))
		  end if

		  if s isa TriangRect then
		    return s.Modifier2fixes(p)
		  end if


		  getoldnewpos(p, ep, np)

		  choixpointsfixes

		  if NbUnModif > 2 then
		    return new Matrix(1)
		  end if

		  select case NbSommSur(n)
		  case 0
		    q = point(somm.item(fx1))  // q est le point fixe
		    Select case  NbUnModif
		    case 0, 1
		      return s.modifier1fixe(q,p)
		    case 2
		      return s.modifier2fixes(p)
		    end select
		  case 1
		    q = point(somm.item(fx1))
		    if s isa rect then
		      if q.forme = 0 then
		        return s.modifier1fixe(q,p)
		      elseif fx2 <> -1 then
		        return s.modifier1fixe(point(somm.item(fx2)),p)
		      end if
		    end if

		  case 2
		    n = s.Points.indexof(p)
		    p1 = Point(Somm.item(ListSommSur(0)))
		    p2 = Point(Somm.item(ListSommSur(1)))
		    n1 = s.Points.indexof(p1)
		    n2 = s.Points.indexof(p2)
		    if n <> -1 and NbUnModif = 0 then
		      return new similaritymatrix(p1, p2, ep, np)
		    else
		      return nil
		    end if
		  end select

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autospeupdate2() As Matrix
		  dim p, q, r as point
		  dim ep, eq, er, np, nq, nr As BasicPoint
		  dim n1, n2 as integer
		  dim s as shape

		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  s = shapes.item(0)
		  if s isa arc  or s isa DSect  then
		    return s.Modifier2(n1,n2)
		  elseif s isa Triangiso then
		    return s.Modifier2(n1,n2)
		  end if

		  p = somm.item(n1)
		  q = somm.item(n2)
		  getoldnewpos(p,ep,np)
		  getoldnewpos(q,eq,nq)

		  select case  NbSommSur(n1,n2)
		  case 0
		    if p.guide = supfig.pmobi then
		      return s.modifier1fixe(q,p)
		    else
		      return s.Modifier1fixe(p,q)
		    end if
		  case 1
		    if  (replacerpoint(p) or replacerpoint(q))  then
		      return autospeupdate            //le 3e sommet est sur et on a replacé un des deux autres qui était également sur
		    elseif s isa rect then
		      return rect(s).modifier2fixes(p,q)
		    elseif s isa losange then
		      r = somm.item(Listsommsur(0))
		      getoldnewpos(r,er,nr)
		      return new AffinityMatrix(ep,eq,er,np,nq,nr)
		    end if
		  else
		    return s.Modify2(p,q)
		  end select

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autospeupdate3() As Matrix
		  ' Modifie forme spéciale complexe avec 3+ points modifiés.
		  ' Complexité élevée : 100+ lignes avec multiples select/case imbriqués
		  ' TODO: Refactoriser en 5-6 sous-méthodes par type de forme spéciale
		  ' @return Matrice spéciale calculée avec conservation des contraintes
		  dim p, q , r As point
		  dim ep,eq,er,np,nq,nr as BasicPoint
		  dim i, k, n, n1, n2, n3 as integer
		  dim t as boolean
		  dim s as shape

		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  n3 = ListPtsModifs(2)
		  p = Point(somm.item(n1))
		  q = Point(somm.item(n2))
		  r = Point(somm.item(n3))

		  s = shapes.item(0)
		  if s isa arc  or s isa DSect or s isa Triangiso  then
		    return s.modifier3
		  end if

		  if s isa rect then
		    return rect(s).modifier3(p,q,r)
		  end if

		  if s isa Losange then
		    return Losange(s).Modifier3(p,q,r)
		  end if

		  Choixpointsfixes
		  if NbUnModif > 2 then
		    return new Matrix(1)
		  end if



		  n = NbSommSur

		  select case n
		  case 0
		    if s isa triangle then
		      return new Matrix(1)
		    elseif s isa rect then
		      return rect(s).Modifier3(p,q,r)
		    elseif s isa Losange then
		      return Losange(s).Modifier3(p,q,r)
		    end if
		  case 1
		    'ps =point(somm.item(ListSommSur(0)))
		    'if ps <> supfig.pointmobile and not (ps.isextremityofarc(n, ar) and (n = 2) and (ar.fig = supfig)) then
		    't = replacerpoint(ps)
		    'else
		    getoldnewpos(p,ep,np)
		    getoldnewpos(q,eq,nq)
		    getoldnewpos(r,er,nr)
		    return new affinitymatrix(ep,eq,er,np,nq,nr)
		    'end if
		  case 2
		    for i = 0 to 1
		      If point(somm.item(ListSommSur(i))) <> supfig.pmobi Then
		        t =replacerpoint (point(somm.item(Listsommsur(i))))
		      end if
		    next
		  case 3
		    p = supfig.pmobi
		    k = somm.getposition(p)
		    if Listsommsur.indexof(k) <> -1 then
		      for i = 0 to 2
		        if i <> k then
		          t =replacerpoint (point(somm.item(Listsommsur(i))))
		        end if
		      next
		    else
		      t = replacerpoint (point(somm.item(Listsommsur(0))))
		      t = replacerpoint (point(somm.item(Listsommsur(1))))
		      't = replacerpoint (point(somm.item(Listsommsur(2))))
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
		  dim M as Matrix

		  choixpointsfixes
		  s = shapes.item(0)
		  n = NbSommSur

		  if(s.Points.count < 4) then
		    return new Matrix(1)
		  end if
		  select case n
		  case 0, 1
		    M = s.modifier4
		    if M <> nil then
		      return s.modifier4
		    else
		      return autospeupdate3
		    end if
		  case 2
		    t = replacerpoint (point(somm.item(Listsommsur(0))))
		    t = replacerpoint (point(somm.item(Listsommsur(1))))
		    if shapes.item(0)  isa rect and abs(listsommsur(0)-listsommsur(1)) = 2  then
		      return autoaffupdate
		    end if
		  case 3,4
		    p = supfig.pmobi
		    k = somm.getposition(p)
		    if Listsommsur.indexof(k) <> -1 then
		      for i = 0 to 2
		        if i <> k then
		          t = replacerpoint (point(somm.item(Listsommsur(i))))
		        end if
		      next
		    else
		      t = replacerpoint (point(somm.item(Listsommsur(0))))
		      t = replacerpoint (point(somm.item(Listsommsur(1))))
		    end if
		  end select

		  return autospeupdate
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autotrapupdate() As Boolean
		  ' Dispatcher pour mise à jour de trapèze selon nombre de points modifiés.
		  ' Maintient la propriété : "une paire de côtés parallèles"
		  ' @return True si mise à jour réussie, False si conflit sur parallélisme
		  ' Met à jour une figure de type trapèze selon le nombre de points modifiés.
		  ' @return True si la mise à jour a réussi
		  select case NbPtsModif // Nombre de points modifiés (y compris les sommets sur) Mais il peut exister des sommets sur non modifiés
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
		    d.setMessage(CurrentMethodName)
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

		  p = Point(somm.item(ListPtsModifs(0)))
		  s = trap(shapes.item(0))

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
		Function autotrapupdate2() As Boolean
		  dim p,  q as point
		  dim s as trap

		  dim n1, n2 as integer

		  if fx1 = -1 then
		    choixpointsfixes
		  end if

		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  p = Point(somm.item(n1))
		  q = Point(somm.item(n2))
		  s = trap(shapes.item(0))

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
		  p = Point(somm.item(n1))
		  q = Point(somm.item(n2))
		  r = Point(somm.item(n3))

		  s = trap(shapes.item(0))

		  return s.trapupdate3(p, q, r)

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function autotrapupdate4() As Boolean
		  dim s as trap
		  dim i, n as integer
		  dim u as BasicPoint

		  s = trap(shapes.item(0))

		  if NbSommSur > 0  and not s isa trapiso and not s isa traprect then
		    i = ListSommSur(0)
		    select case i
		    case 0, 1
		      u = s.points(2).bpt-s.points(3).bpt
		      n = 1-i
		    case 2, 3
		      u = s.points(0).bpt-s.points(1).bpt
		      n=5-i
		    end select
		    s.points(i).moveto s.points(i).bpt.projection(s.points(n).bpt,s.points(n).bpt+u)
		    return true
		  else
		    if shapes.item(0).duplicateorcut then
		      return true
		    else
		      return s.check
		    end if
		  end if



		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub bouclesasupprimer()
		  dim n0 as integer
		  dim t as Boolean

		  t = true
		  while t
		    M1 = Mat
		    n0 = 2
		    if M1.Null then
		      return
		    end if
		    while n0 <= subs.count and t
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
		Sub CancelfixedPoints()
		  dim i as integer


		  for i = 0 to subs.count-1
		    figure(subs.item(i)).fx1 = -1
		    figure(subs.item(i)).fx2 = -1
		  next


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub canceloldbpts()
		  dim i as integer


		  redim oldbpts(-1)
		  redim oldptscsted(-1)
		  redim oldptssur(-1)
		  redim oldcentres(-1)

		  for i = 0 to subs.count -1
		    Figure(subs.item(i)).canceloldbpts
		  next


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Canceltrace()
		  dim i As integer

		  for i = 0 to shapes.count -1
		    shapes.item(i).canceltrace
		  next

		  for i = 0 to PtsConsted.count - 1
		    PtsConsted.item(i).tracept = false
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function checksimaff(M as Matrix) As Boolean
		  ' Vérifie si la matrice M transforme correctement les points de la figure
		  ' selon les contraintes de similarité/affinité.
		  ' @param M La matrice de transformation à valider
		  ' @return True si tous les points valides sont correctement transformés
		  const NUMERIC_TOLERANCE = 1.0e-6  // Tolérance pour comparaisons numériques
		  const OPER_PROJECT = 10           // Opération de projection

		  dim i as integer
		  dim ep, np as basicpoint
		  dim p as point
		  dim t, tt as boolean
		  dim d as double

		  if shapes.item(0) = nil or shapes.item(0) isa arc then
		    return true
		  end if

		  t = true
		  for i = 0 to somm.count-1
		    p = Point(somm.item(i))
		    tt = true
		    tt = tt and (not p.invalid) and (p.pointsur.count < 2)
		    tt = tt and (p.constructedby = nil or (p.pointsur.count=1 and (p.duplicateorcut or p.constructedby.oper = OPER_PROJECT)))
		    tt = tt and not ((p.parents(0).isaparaperp) and (p.forme = 0))
		    if tt then
		      ep = oldbpts(i)
		      np = p.bpt
		      d = np.distance(M*ep)
		      t = (d < NUMERIC_TOLERANCE) and t
		    end if
		  next

		  return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Choixpointsfixes()
		  ' Sélectionne les points fixes à utiliser pour calculer les matrices de transformation.
		  ' Algorithme en 3 phases : non-modifiables, points sur formes, autres points.
		  // Modif d'une sous-figure

		  // 0) Par priorité, on choisit comme candidats points fixes les points non modifiables.
		  // 1) Parmi les sommets de la sous-figure différents de p, déterminer les points modifiables qui appartiennent au plus grand nombre de sous-figures
		  // 1bis) les classer par distance décroissante du point mobile
		  // 2) placer ceux qui sont des points sur directement après les non modifiables dans la liste des candidats points fixes.
		  // Mais on exclut tous les points déjà modifiés de la liste des candidats points fixes

		  redim pointsfixes(-1)
		  redim ptfx0(-1)

		  Phase0choixpointsfixes
		  Phase1choixpointsfixes
		  Phase2choixpointsfixes

		  if ubound(Pointsfixes) > -1 then
		    fx1 = PointsFixes(0)
		    if ubound(PointsFixes) > 0 then
		      fx2 = PointsFixes(1)
		    else
		      fx2 = -1
		    end if
		  end if



		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChoixSubfig(p as point, byref h0 As integer)
		  Dim h, i, n, m, m0, i0 As Integer
		  dim sf as figure

		  n = subs.count-1

		  //1ere étape: Insérer toutes les sous-figures contenant le point mobile plus celles qui les précèdent
		  m0 = -2
		  m = -1

		  Do Until  m = m0 or m = n
		    m0 = m
		    h0 = 0
		    i0 = -1
		    for i = 0 to n
		      sf = subs.item(i)
		      if  GetRang(i) = -1 and ((sf.somm.getposition(p) <> -1 ) or (sf.ptssur.getposition(p) <> -1)) then
		        h = 0
		        if i0 = -1 then
		          i0 = i
		        end if
		        while h < n and sommes(h,i) <> 0
		          h=h+1
		        wend
		        if h > h0 then  'h est la longueur de la connexion la plus longue d'une subfig située à la racine du graphe vers sub(i)
		          h0 = h          'sub(i) est à la racine du graphe si h = 0
		          i0 = i
		        end if
		      end if
		    next

		    if i0 <> -1 then
		      if h0 <> 0  then
		        InsertPreceding(i0)
		      end if
		      rang.append i0
		    end if
		    m = rang.Count-1
		  Loop


		  if m = n then
		    return
		  end if


		  //2eme etape: insérer les sous-figures ne contenant pas le point mobile et précédées par au moins une autre sous-figure
		  m0 = -2

		  Do Until  m = m0 or m = n
		    m0 = m
		    h0 = 0
		    i0 = -1
		    for i = 0 to n
		      sf = subs.item(i)
		      if  GetRang(i) = -1  then
		        h = 0
		        while h < n and sommes(h,i) <> 0
		          h=h+1
		        wend
		        if h >= h0 then  'h est la longueur de la connexion la plus longue d'une subfig située à la racine du graphe vers sub(i)
		          h0 = h          'sub(i) est à la racine du graphe si h = 0
		          i0 = i
		        end if
		      end if
		    next
		    if i0 <> -1 then
		      if h0 <> 0 then
		        InsertPreceding(i0)
		      end if
		      rang.append i0
		    end if
		    m = ubound (rang)
		  Loop

		  if m = n then
		    return
		  end if





		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChoixSubfig2()
		  'dim h, k, i, n as integer
		  'dim ma, imax, nvois as integer
		  'dim dispo() as integer
		  '
		  '' 2eme étape: Insérer les sous-figures ne contenant pas le point mobile
		  '
		  'n = subs.count-1
		  'redim dispo(-1)
		  '
		  'for i = 0 to n
		  'if index.indexof(i) = -1 then
		  'dispo.append i
		  'end if
		  'next
		  '
		  'while ubound(index) < n
		  'ma = 0
		  'imax = -1
		  'for i = 0 to ubound(dispo)
		  'k = dispo(i)
		  'nvois = 0
		  'for h = 0 to n
		  'if h <>k and  index.indexof(h) <> -1 and (subs.item(k).NbSommCommuns(subs.item(h)) > 0) then
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
		  'nvois = subs.item(dispo(i)).somm.count
		  'if nvois > ma then
		  'ma = nvois
		  'imax = dispo(i)
		  'end if
		  'next
		  'end if
		  'InsertPreceding(imax)
		  'index.append imax
		  'wend

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ChoixSubFig2bis() As integer
		  'dim h, k, i, iret as integer
		  'dim n, m as integer
		  'dim ff, ff1 as figure
		  'dim p as point
		  'dim  libe() as integer
		  'dim s as shape
		  'dim t as boolean
		  'dim dispo() as integer
		  'n = subs.count-1
		  '
		  'redim libe(ubound(dispo))
		  '
		  'for i = 0 to ubound(dispo)
		  'ff = subs.item(dispo(i))
		  's = ff.shapes.item(0)
		  'm = 0
		  'for h = 0 to ff.somm.count-1
		  'p = point(ff.somm.item(h))
		  't = false
		  'for k = 0 to n       //a-t-on déjà inséré uns subfig différente de sub(i) contenant le point p
		  't = t or ( (k<> i) and ( index.indexof(k) <> -1) and (subs.item(k).somm.getposition(p) <> -1))
		  'next
		  'if t then
		  'm = m+1  // n est le nombre de subfig différentes de sub(i) déjà insérées contenant le point p
		  'end if
		  'next
		  '
		  'select case ff.auto  //On calcule le nombre de degrés de liberté dont on dispose dans le cas du choix de sub(i)
		  'case 0
		  'libe(i) = 0
		  'case 1
		  'libe(i) = 4 - 2*m
		  'case 2
		  'libe(i) = 6 - 2*m
		  'case 3
		  'libe(i) = 5 - 2*m
		  'case 4
		  'libe(i) = 2*s.npts - 2*m
		  'case 5
		  'if s isa traprect  or s isa trapiso then
		  'libe(i) = 6-2*m
		  'else
		  'libe(i) = 7-2*m
		  'end if
		  'case 6
		  'libe(i) = 3 -2*m
		  'end select
		  'if libe(i) < 0 then
		  'libe(i) = 0
		  'end if
		  'next
		  '
		  'for i = 0 to ubound(dispo)  //Faut-il choisir la subfig qui a conservé le plus de degrés de libertés ou le moins?
		  'if libe(i) > n then
		  'n = libe(i)
		  'iret = dispo(i)
		  'end  if
		  'next
		  'return iret
		  '

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub classementptsfix(nf as integer)
		  dim i as integer
		  dim ptfx(-1) as integer
		  dim dist(-1) as double
		  dim p as point
		  dim ep, np as basicpoint



		  //classement par rapport au nombre de parents

		  If somm.getposition(supfig.pmobi) <> -1 Then
		    p = supfig.pmobi
		  else
		    p = Point(somm.item(ListPtsModifs(0)))
		  end if

		  p.fig.getoldnewpos(p,ep,np)

		  for i = 0 to somm.count-1
		    if  nff(i) = nf then 'point(somm.item(i)).id  <> p.id and PointsFixes.IndexOf(i) = -1 and (PtsConsted.GetPosition(somm.item(i)) = -1) and nff(i) = nf and ListPtsModifs.IndexOf(i) = -1 then
		      Ptfx.append i
		      dist.append ubound(point(somm.item(i)).parents)
		    end if
		  next

		  if auto = 3 and shapes.item(0) isa arc then
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
		Sub concat1(f1 as figure, f2 as figure, n as integer)
		  If f1.nbsommcommuns(f2) >= n Then
		    f1.shapes.concat f2.shapes
		    f1.somm.concat f2.somm
		    f1.PtsConsted.concat f2.PtsConsted
		    f1.PtsSur.concat f2.PtsSur
		    subs.removefigure f2
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Shapes = new ObjectsList
		  Somm = new PointsList
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
		Sub Constructor(sf as figure)
		  Constructor
		  dim i as integer

		  if sf.supfig <> nil then
		    subs.addobject sf
		    sf.supfig = self
		  else
		    for i = 0 to sf.subs.count-1
		      subs.addobject sf.subs.item(i)
		      Figure(sf.subs.item(i)).supfig = self
		    next
		  end if

		  for i = 0 to sf.Shapes.count-1
		    shapes.addShape sf.shapes.item(i)
		    sf.shapes.item(i).fig = self
		  next
		  for i = 0 to sf.somm.count-1
		    somm.addObject sf.somm.item(i)
		    sf.somm.item(i).fig = self
		  next
		  for i = 0 to sf.Ptsconsted.count-1
		    Ptsconsted.addShape sf.PtsConsted.item(i)
		    sf.PtsConsted.item(i).fig = self
		  next
		  for i = 0 to sf.PtsSur.count-1
		    PtsSur.addShape sf.PtsSur.item(i)
		    sf.PtsSur.item(i).fig = self
		  next



		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(s as shape)
		  Dim ff As figure

		  Constructor

		  ff = new Figure
		  ff.supfig = self
		  ff.shapes.addshape s
		  ff.insererpoints(s)
		  ff.Auto = s.Auto
		  subs.addobject ff
		  Shapes.addshape s
		  InsererPoints(s)
		  s.fig = self


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub constructshapes()
		  dim i as integer

		  for i = 0 to shapes.count-1
		    shapes.item(i).constructshape
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function containsmaccstedshapewithoutinitobjects() As Boolean
		  dim s, sh as shape
		  dim i,j as integer


		  for i = 0 to shapes.count-1
		    s = shapes.item(i)
		    if s.macconstructedby <> nil then
		      for  j = 0 to ubound(s.macconstructedby.realinit)
		        sh = currentcontent.theobjects.getshape(s.MacConstructedby.realinit(j))
		        if sh.fig <> self then
		          return false
		        end if
		      next
		    end if
		  next
		  return true


		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createState(EL as XMLElement)
		  dim i, j as integer
		  dim EL0, EL1,EL2 As XMLElement
		  dim s as shape
		  dim M as Matrix

		  EL0 = CurrentContent.OpList.CreateElement("Figure")

		  EL0.setattribute ("FigId", str(idfig))

		  EL1 = CurrentContent.Oplist.CreateElement("Shapes")
		  for i = 0 to shapes.count-1
		    s = shapes.item(i)
		    EL2 = CurrentContent.Oplist.CreateElement(Dico.Value("NrForm"))
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

		  EL1 = CurrentContent.Oplist.CreateElement("Somm")
		  for i = 0 to somm.count-1
		    EL1.appendchild point(somm.item(i)).PutInState(CurrentContent.OpList)
		  next
		  EL0.appendchild EL1

		  if PtsConsted.count > 0 then
		    EL1 = CurrentContent.Oplist.CreateElement("PtsConsted")
		    for i = 0 to PtsConsted.count-1
		      EL1.appendchild point(PtsConsted.item(i)).PutInState(CurrentContent.OpList)
		    next
		    EL0.appendchild EL1
		  end if

		  if PtsSur.count > 0 then
		    EL1 = CurrentContent.Oplist.CreateElement("PtsSur")
		    for i = 0 to PtsSur.count-1
		      EL1.appendchild point(PtsSur.item(i)).PutInstate (CurrentContent.oplist)
		    next
		    EL0.appendchild EL1
		  end if


		  EL.appendchild EL0


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreerMatricePrecedences(n as integer)
		  dim i , j as integer
		  dim f1, f2 as figure

		  Mat = new MatrixnD(n)

		  for i = 0 to n-2
		    f1 = Figure(subs.item(i))
		    for j = i+1 to n-1
		      f2 = Figure(subs.item(j))
		      if f1.precede(f2) then
		        mat.col(i,j) = 1
		      end if
		      if f2.precede(f1) then
		        mat.col(j,i) = 1
		      end if
		    next
		  next


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DefaultMatrix() As Matrix
		  dim ep, eq, er, np, nq, nr as BasicPoint
		  dim p, q, r as point
		  dim  n1, n2, n3 as integer


		  n1 = ListPtsModifs(0)
		  n2 = ListPtsModifs(1)
		  p = Point(somm.item(n1))
		  q = Point(somm.item(n2))
		  getoldnewpos(p,ep,np)
		  getoldnewpos(q,eq,nq)



		  select case auto
		  case 0,1
		    return new SimilarityMatrix(ep,eq,np,nq)
		  case 2,3
		    n3 = ListPtsModifs(2)
		    r = Point(somm.item(n3))
		    getoldnewpos(r,er,nr)
		    return new AffinityMatrix(ep,eq,er,np,nq,nr)
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Detectertsf()
		  dim i as integer

		  redim ListeSupportsTsf(-1)

		  for i = 0 to shapes.count-1
		    if shapes.item(i).tsfi.count > 1 then
		      ListeSupportsTsf.append i
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub enablemodifyall()
		  dim i as integer

		  modified = false
		  for i = 0 to somm.count-1
		    point(somm.item(i)).enablemodify
		  next

		  for i = 0 to ptssur.count-1
		    point(ptssur.item(i)).enablemodify
		  next

		  for i = 0 to ptsconsted.count-1
		    point(ptsconsted.item(i)).enablemodify
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndQQupdateshapes()
		  dim i as integer
		  dim p as point
		  dim inter as intersec

		  for i = 0 to Somm.count - 1
		    p = point(Somm.item(i))
		    p.updateShape
		  next

		  for i = 0 to ptssur.count-1
		    p = point(ptssur.item(i))
		    if p.forme = 1 then
		      P.puton (P.pointsur.item(0), p.location(0))
		      p.modified = true
		      p.updateshape
		    elseif p.forme = 2 then
		      inter = p.GetInter
		      if inter <> nil then
		        inter.update(p)
		      end if
		    end if
		  next

		  for i = 0 to PtsConsted.count-1
		    p = Point(Ptsconsted.item(i))
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
		    p = point(somm.item(i))
		    select case  p.pointsur.count
		    case  1
		      p.puton p.pointsur.item(0)
		      'p.unmodifiable = true
		    end select
		    p.modified = true
		    p.updateshape
		  next

		  EndQQupdateshapes
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function figduplicateorcut(byref s as shape) As Boolean
		  dim i as integer

		  for i = 0 to shapes.count-1
		    s = shapes.item(i)
		    if s.duplicateorcut and s.constructedby.shape.getindexpoint(supfig.pmobi)<> -1 then
		      return true
		    end if
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fusionnerautosimaff()
		  dim i, j as integer
		  dim f1, f2 as figure


		  for i = 0 to subs.count-2
		    f1 = subs.item(i)
		    for j =  subs.count-1 downto i+1
		      f2 = subs.item(j)
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
		Sub fusionnerinclusions()
		  dim i, j as integer
		  dim f1, f2 as figure

		  for i = 0 to subs.count-2
		    f1 = subs.item(i)
		    for j = subs.count-1 downto i+1
		      f2 = subs.item(j)
		      if fusionsubfigs(f1,f2) then
		        subs.removefigure f2
		      elseif fusionsubfigs(f2,f1) then
		        subs.removefigure f1
		        Exit
		      end if
		    next
		  next




		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FusionnerSubfigs(pos() as integer)
		  dim f1, sf as figure
		  dim i as integer

		  f1 = subs.item(pos(0))

		  for i = 1 to ubound(pos)
		    sf = subs.item(pos(i))
		    f1.shapes.concat sf.shapes
		    f1.somm.concat sf.somm
		    f1.PtsConsted.concat sf.PtsConsted
		    f1.PtsSur.concat sf.PtsSur
		  next

		  pos.remove 0
		  for i = subs.count-1 downto 0
		    if pos.indexof(i) <> -1 then
		      subs.removefigure subs.item(i)
		    end if
		  next

		  Adapterautos(f1)

		  return




		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function fusionsubfigs(f1 as figure, f2 as figure) As Boolean
		  Dim k As Integer
		  dim t, t1 as boolean
		  Dim p As point


		  if f1.auto = 1 and f2.auto = 3  then
		    concat1(f1,f2,3)
		    return false 'false parce qu'on a déjà fait un remove de f2
		  end if

		  If f1.Auto = 6 Or f2.Auto = 6 Then
		    Return False
		  End If

		  If f1.Auto = 7 Or f2.Auto = 7 Then
		    Return False
		  End If


		  if ((f1.supfig <> f2.supfig) or (f1.auto <> f2.auto)  or (f1.auto = 3) or (f2.auto = 3)) and not (f1.auto = 1 ) then
		    return false
		  end if

		  t = true
		  for k = 0 to f1.somm.count-1
		    p = f1.somm.item(k)
		    t1 = (p.forme = 2) and (f2.shapes.getposition(p.pointsur.item(0)) <> -1) and (f2.shapes.getposition(p.pointsur.item(1))<> -1)
		    t = t and((f2.somm.getposition(p)<> -1) or t1)
		  next



		  'On fusionne f1 et f2 si tous les sommets de f1 sont soit des sommets de f2 soit des points d'inter de  deux formes de f2
		  if f1.NbSommCommuns(f2) = f1.Somm.count or f2.NbSommCommuns(f1) = f2.Somm.count then
		    t = true
		  end if

		  If t Then
		    f1.shapes.concat f2.shapes
		    f1.somm.concat f2.somm
		    f1.PtsSur.concat f2.PtsSur
		    f1.PtsConsted.concat f2.PtsConsted
		    Adapterautos(f1)
		  end if

		  return t

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fx1cancel()
		  dim i as integer

		  fx1 = -1
		  for i = 0 to subs.count-1
		    Figure(subs.item(i)).fx1=-1
		  next
		End Sub
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
		Function GetRang(n as integer) As integer
		  dim i as integer

		  for i=0 to ubound(Rang)
		    if Rang(i) = n then
		      return i
		    end if
		  next
		  return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As String
		  return "Figure "+str(idfig)


		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function validateTransformationMatrix(M as Matrix, checkDeterminant as Boolean = false) As Matrix
		  ' Helper pour valider une matrice de transformation calculée.
		  ' Retourne la matrice si valide, sinon retourne une matrice neutre (identité).
		  ' @param M Matrice candidat
		  ' @param checkDeterminant Si True, vérifie que |det(M) - 1| < EPSILON pour similarités
		  ' @return Matrice validée ou matrice neutre
		  const NUMERIC_TOLERANCE = 1.0e-6
		  const IDENTITY_DET_MAX_DEVIATION = 1.0e-3  ' Tolérance plus large pour déterminant

		  if M = nil or M.v1 = nil then
		    return new Matrix(1)  ' Retourne matrice neutre
		  end if

		  if checkDeterminant and abs(M.det - 1) > IDENTITY_DET_MAX_DEVIATION then
		    return new Matrix(1)  ' Déterminant incorrect pour similarité → matrice neutre
		  end if

		  return M
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub getPointPositions(pt as Point, ByRef oldPos as BasicPoint, ByRef newPos as BasicPoint)
		  ' Surcharge lisible pour getoldnewpos - extraction des positions ancienne/nouvelle d'un point.
		  ' Alias améliorant la lisibilité du code dans les gros algorithmes de transformation.
		  ' @param pt Point source
		  ' @param oldPos Position ancienne (sortie)
		  ' @param newPos Position nouvelle (sortie)
		  getoldnewpos(pt, oldPos, newPos)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function gettransfosto() As transfoslist
		  dim i as integer
		  dim tsfl as transfoslist

		  for i = 0 to shapes.count-1
		    if shapes.item(i).constructedby <> nil and shapes.item(i).constructedby.oper = 6 then
		      tsfl.addobject transformation(shapes.item(i).constructedby.data(0))
		    end if
		  next

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GridMagnetism(Byref d as BasicPoint, Byref AttractedPoint as Point) As integer

		  dim td As BasicPoint
		  dim i as integer
		  dim currentmagnetism,StrongestMagnetism as integer

		  td = new BasicPoint(0,0)
		  for i=0 to somm.count-1
		    Currentmagnetism=point(somm.item(i)).GridMagnetism(td)
		    if Currentmagnetism>StrongestMagnetism then
		      StrongestMagnetism=Currentmagnetism
		      AttractedPoint=Point(Somm.item(i))
		      d = td
		    end if
		  next
		  return StrongestMagnetism


		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasCommonPointWithPreceding(k as integer) As Boolean
		  dim i,j, n as integer
		  dim ff as figure

		  for i = 0 to k
		    n = supfig.rang(i)
		    ff = supfig.subs.item(n)

		    if NbPtsCommuns(ff) > 0 then
		      return true
		    end if

		    for j = 0 to ff.PtsSur.count-1
		      if Somm.getposition(ff.PtsSur.item(j)) <> -1 then
		        return true
		      end if
		    next

		    for j = 0 to PtsSur.count-1
		      if ff.somm.getposition(PtsSur.item(j)) <> -1 then
		        return true
		      end if
		      if ff.PtsSur.getposition(PtsSur.item(j)) <> - 1 then
		        return true
		      end if
		    next
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasPointOnConstructedShape(f as figure) As Boolean
		  dim t as Boolean
		  dim i as integer
		  dim p as point

		  t = true
		  for i = 0 to somm.count-1
		    p = point(somm.item(i))
		    if p.forme = 1 and p.pointsur.count > 0 and p.pointsur.item(0).constructedby <> nil and f.shapes.getposition(p.pointsur.item(0).constructedby.shape ) = -1 then
		      t = false
		    end if
		  next
		  return t

		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("t", t)
		    d.setVariable("i", i)
		    d.setVariable("p", p)
		    err.message = err.message+d.getString

		    Raise err
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsererPoints(s as shape)
		  dim i as integer

		  if s isa point then
		    somm.addobject s
		    s.fig = self
		  else
		    for i = 0 to ubound(s.points)
		      somm.addobject s.points(i)
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
		Sub InsertPreceding(i as integer)
		  //i est un numéro de sous-figure,
		  // la méthode doit insérer dans l'index toutes les sous-figures qui précèdent subfig(i), en respectant les relations de précédence
		  // on insérera d'abord celles pour lesquelles MP(1).Col(j,i) >0 et MP(2).Col(j,i) = MP(3).Col(j,i)= ... = 0
		  //Puis celles pour lesquelles MP(2).Col(j,i) > 0  etc... On procède par récursivité

		  dim j, h, n, s as integer
		  dim f1, f2  as figure

		  n = Mat.nc-1
		  f1 = subs.item(i)

		  for h = 0 to n
		    f2 = subs.item(h)

		    if rang.indexof(h)=-1 and Mat.Col(h,i) = 1 then
		      if not( (f1.auto=2 ) and (f2.auto=1) and f1.NbTrueSommCommuns(f2) >= 2) then
		        s = 0
		        for j = 1 to n
		          s = s + MP(j).Col(h,i)
		        next
		        if s = 0 then
		          InsertPreceding(h)
		        end if
		        rang.append h
		      end if
		    end if
		  next


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub invalider()
		  dim i as integer

		  for i = 0 to shapes.count -1
		    shapes.item(i).invalider
		  next

		  invalid = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isafigprp(byref s as shape) As Boolean
		  dim i, n, m as integer
		  dim sh, sh0 as shape
		  dim ff as figure

		  for i = 0 to shapes.count-1
		    sh = shapes.item(i)
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
		  if shapes.count = 1 and shapes.item(0) isa point then
		    return point(shapes.item(0))
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isempty() As boolean
		  return (shapes.count = 0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub lierpoint(p as point)
		  dim t as boolean
		  dim i as integer

		  if p.pointsur.count = 0 and p.firstcurrentattractingshape <> nil then
		    t = true
		    for i = 0 to 2
		      t = (p.firstcurrentattractingshape = Point(Somm.item(ListSommSur(i))).pointsur.item(0)) and t
		    next
		    if t then
		      p.puton p.firstcurrentattractingshape
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub listerassociatedfigures()
		  dim j,  n0, n1 as integer
		  dim ff as figure

		  assocfigs = new FigsList

		  assocfigs.appendlist associerfigs

		  n0=-1
		  n1 =  AssocFigs.count-1
		  while n0 < n1
		    for j = n0+1 to n1
		      ff = Assocfigs.item(j)
		      assocfigs.appendlist ff.associerfigs
		    next
		    n0 = n1
		    n1 =AssocFigs.count-1
		  wend


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ListerPrecedences()
		  Dim i, k, j, n, nc As Integer

		  n = subs.count

		  if n <= 1 then
		    return
		  End If

		  CreerMatricePrecedences(n)

		  if not Mat.Null then
		    Bouclesasupprimer
		  end if

		  nc = Mat.nc
		  redim MP(-1)
		  redim MP(nc-1)
		  for i = 0 to nc-1
		    MP(i) = new MatrixnD(nc)
		  next

		  MP(0) = Mat
		  for i = 1 to nc-1
		    MP(i) = Mat*MP(i-1)
		  next

		  // MP(k) contient les connexions en k+1 étapes
		  redim Sommes(-1,-1)
		  redim Sommes(nc-1,nc-1)


		  for k = 0 to nc-1
		    for j = 0 to nc-1
		      Sommes(k,j) = MP(k).SommCol(j)  //Sommes(k,j) est le nombre de connexions en k+1 étapes aboutissant en sub(j)
		    next                                                        //Pour une subfig(j) à la racine du graphe, toutes les sommes(k,j) valent 0
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub listersubfigs(p as point)
		  dim n, h0 as integer

		  redim rang(-1)

		  n = Subs.count-1
		  if n = 0 then
		    rang.append 0
		    return
		  end if

		  choixsubfig(p, h0)    //on choisit une sous fig de départ Toutes les sous-fig qui la précèdent doivent ...

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub lockBoucleArcs()
		  dim i,n As integer

		  n = shapes.count
		  if shapes.count = 1 then
		    return
		  end if
		  i = 0
		  Do
		    if not Shapes.item(i) isa Arc then
		      return
		    end if
		    i = i + 1
		  Loop until i < Shapes.count

		  for i = 0 to Somm.count-1
		    somm.item(i).modified = true
		  next
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
		    s = shapes.item(i)
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
		Sub Move(M as Matrix)
		  dim i, j as integer
		  dim s as shape

		  Movepoints(M)
		  Mmove = M

		  for j = 0 to shapes.count -1
		    s = shapes.item(j)
		    s.Mmove = M
		    'if s isa StdCircle then
		    'continue
		    'end if
		    if (s isa Circle or s.Hybrid) and not s isa secteur then
		      s.coord.MoveExtreCtrl(M)
		    end if
		    if s isa secteur then
		      secteur(s).ComputeExtre
		      secteur(s).skullcoord.CreateExtreAndCtrlPoints(s.ori)
		      secteur(s).skullcoord.MoveExtreCtrl(M)
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
		Sub Movepoints(M as Matrix)
		  dim j as integer
		  dim s as shape

		  for j = 0 to somm.count-1
		    s = somm.item(j)
		    Point(s).Move(M)
		  next

		  for j = 0 to PtsConsted.count-1
		    s=PtsConsted.item(j)
		    if somm.getposition(s) = -1 then
		      Point(s).Move(M)
		    end if
		  next

		  for j = 0 to PtsSur.count-1
		    s = PtsSur.item(j)
		    if somm.getposition(s) = - 1 then
		      Point(s).Move(M)
		    end if
		  next

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbPointsLimites() As integer
		  dim i, n As Integer
		  dim p as point

		  for i = 0 to Somm.count-1
		    p = Point(somm.item(i))
		    if p.liberte < 2 then
		      n = n+1
		    end if
		  next

		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbPtsCommuns(f as figure) As integer
		  dim i,j,n as integer
		  dim p as point

		  n = NbSommCommuns(f)

		  if supfig <> nil and f.supfig <> nil then
		    for i = 0 to Somm.count-1
		      for j = 0 to f.Ptssur.count -1
		        p = Point(f.ptssur.item(j))
		        if somm.item(i) = p and f.Somm.getposition(p) = -1 and f.PtsConsted.getposition(p) = -1  then
		          if p.pointsur.count =2 and  p.pointsur.item(0).getsousfigure(f.supfig) = f and p.pointsur.item(1).getsousfigure(f.supfig) = f then
		            n = n+1
		          end if
		        end if
		      next
		    next

		    for i = 0 to f.Somm.count-1
		      for j = 0 to Ptssur.count -1
		        p = Point(ptssur.item(j))
		        if f.somm.item(i) = p  and Somm.getposition(p) = -1 and PtsConsted.getposition(p) = -1  then
		          if p.pointsur.count =2 and  p.pointsur.item(0).getsousfigure(supfig) = self and p.pointsur.item(1).getsousfigure(supfig) = self then
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
		  dim p as point
		  Redim ListPtsModifs(-1)
		  //Décompte et liste les sommets de la figure qui ont déjà été modifiés

		  NbModif = 0

		  for i = 0 to Somm.count-1
		    p = point(somm.item(i))
		    if p.modified then
		      NbModif = NbModif+1
		      ListPtsModifs.append i
		    end if
		  next

		  return NbModif

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbPtsModifSurDr() As integer
		  dim i as integer
		  dim dr as shape

		  Redim ListPtsModifs(-1)
		  //Décompte et liste les sommets de la forme n°0 qui ont déjà été modifiés

		  NbModif = 0
		  Dr = Shapes.item(0)

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
		Function NbShapes(p as point) As integer
		  dim i, n as integer

		  for i = 0 to shapes.count-1
		    if shapes.item(i).getindexpoint(p) <> -1 then
		      n = n+1
		    end if
		  next

		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbSommCommuns(f as figure) As integer
		  dim i,j,n as integer


		  n = NbTrueSommCommuns(f)

		  for i = 0 to Somm.count-1
		    for j = 0 to f.PtsConsted.count-1
		      if Somm.item(i) = f.PtsConsted.item(j) then 'and (f.somm.getposition(f.ptsconsted.item(j)) =-1)    then
		        n = n+1
		      end if
		    next
		  next

		  for i = 0 to PtsConsted.count-1
		    for j = 0 to f.Somm.count-1
		      if PtsConsted.item(i) = f.Somm.item(j) then 'and (somm.getposition(PtsConsted.item(i)) = -1) then
		        n = n+1
		      end if
		    next
		  next

		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbSommSur() As integer
		  dim i, n as integer
		  Redim ListSommSur(-1)
		  dim p as point

		  // Liste des "sommets sur" modifiables
		  for i = 0 to Somm.count-1
		    p = Point(somm.item(i))
		    if (p.forme = 1) and P.liberte = 1 and not p.unmodifiable then
		      n = n+1
		      ListSommSur.append i
		    end if
		  next

		  return n
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
		      p = Point(somm.item(i))
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
		Function NbSommSur(n1 as integer, n2 as integer) As integer
		  dim i, n as integer
		  Redim ListSommSur(-1)
		  dim p as point

		  // Liste des "sommets sur"  non modifiés  différents des points modifiés
		  for i = 0 to Somm.count-1
		    if i <> n1 and i <> n2 then
		      p = Point(somm.item(i))
		      if p.forme = 1 and P.liberte = 1 and not p.modified  then
		        n = n+1
		        ListSommSur.append i
		      end if
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
		      p = Point(somm.item(i))
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
		Function NbSubFig(p as point) As integer
		  dim i, n as integer
		  dim f as figure

		  for i = 0 to subs.count-1
		    f = Figure(subs.item(i))
		    if f.somm.getposition(p) <> -1 or f.PtsConsted.getposition(p) <> - 1 or f.PtsSur.getposition(p) <> -1 then
		      n = n+1
		    end if
		  next

		  return n


		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbTrueSommCommuns(f as figure) As integer
		  Dim i, j, n As Integer

		  for i = 0 to Somm.count-1
		    For j = 0 To f.Somm.count-1
		      If (somm.item(i).forme < 2) And (Somm.item(i) = f.Somm.item(j)) And (f.somm.item(j).constructedby = Nil) Then
		        n = n+1
		      end if
		    Next
		  next

		  Return n

		  'La condition f.somm.item(j).constructedby = Nil  a été ajoutée le 8-4-2022
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OKToInsert(j as integer) As Boolean
		  dim i as integer
		  dim t as Boolean



		  t = true

		  for i = 0 to Mat.nc-1                              //Toutes les sous-fig qui précèdent sub(j) ont-elles été insérées?
		    if  Mat.Col(i,j) = 1 then
		      t = (t and rang.indexof(i) <> -1)
		    end if
		  next

		  return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Phase0choixpointsfixes()

		  dim i,  k, n as integer
		  dim p as point

		  // On dresse la liste des sommets de liberte nulle qui ne sont ni construits  par cette sous-figure ni modifiés
		  // Ces points ne pourront être modifiés, on devra les prendre comme points fixes des matrices à calculer
		  //Points de liberte nulle (routine "mobility") :
		  //points d'intersection,  sommets de formes std ou sommets punaisés,
		  // points construits par division, centre, image tsf, point fixe tsf
		  // points ayant un prédécesseur (oper 3 ou 10) de liberté nulle

		  // Un point sommet de l'angle droit de deux triangles rectangles ne peut être modifiable

		  for i = 0 to somm.count-1
		    p = somm.item(i)
		    if p.forme = 2 and p.pointsur.item(0).modified and p.pointsur.item(1).modified then
		      p.unmodifiable = true
		    end if
		    if p.constructedby <> nil and p.constructedby.oper <> 10  then
		      p.unmodifiable = true
		    end if
		    if ubound(p.parents) >=1 then
		      n = 0
		      for k = 0 to ubound(p.parents)
		        if (p.parents(k) isa triangrect and p.parents(k).getindexpoint(p) = 1) or (p.parents(k) isa triangiso and p.parents(k).getindexpoint(p) = 2) or p.parents(k) isa Arc then
		          n = n+1
		        end if
		      next
		      if n >= 2 then
		        p.unmodifiable = true
		      end if
		    end if
		  next

		  NbUnModif = 0

		  for i = 0 to somm.count-1
		    p = somm.item(i)
		    if  (p.liberte = 0 or p.unmodifiable)  and (p <> supfig.pmobi ) and not p.modified and PtsConsted.getposition(p) = -1 and ListPtsModifs.indexof(i)=-1 then
		      Pointsfixes.append i
		      NbUnModif = NbUnModif+1
		    end if
		  next






		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Phase1choixpointsfixes()
		  // On choisit les points appartenant au plus grand nombre de sous-figures en les classant par valeur de distance décroissante
		  //du premier point modifié


		  dim i as integer
		  dim p, pmob as point

		  redim nff(-1)
		  redim nff(somm.count-1)



		  // on recense les points  non modifiés et modifiables absents de la liste précédente et les points modifiés qui ne sont pas des pointssur
		  pmob = supfig.pmobi

		  for i = 0 to somm.count-1
		    p = point(somm.item(i))
		    if (p.id <> pmob.id) and (PointsFixes.IndexOf(i) = -1) and  (PtsConsted.GetPosition(p) = -1) and (ListPtsModifs.indexof(i)=-1) then
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
		  dim p as point
		  dim ep, np, bp1, bp2 as BasicPoint

		  // on adjoint aux candidats points fixes les sommets pointssur  modifiables


		  for i = 0  to  ubound(ptfx0)
		    p = point(somm.item(ptfx0(i)))
		    if supfig.ptssur.getposition(p) <> -1 or  (p.guide <>nil and  p.guide <> p) then
		      PointsFixes.append ptfx0(i)
		    end if
		  next


		  //puis  on adjoint aux candidats points fixes les autres sommets  modifiables

		  for i = 0   to  ubound(ptfx0)
		    if point(somm.item(ptfx0(i))).pointsur.count = 0 and pointsfixes.indexof(ptfx0(i)) = -1  then
		      PointsFixes.append ptfx0(i)
		    end if
		  next



		  // on enlève alors les candidats points fixes alignés avec un précédent et un point modifié

		  for j = ubound(pointsfixes) downto NbUnmodif+1
		    j0 = pointsfixes(j)
		    bp1 = Point(somm.item(j0)).bpt
		    i = 0
		    while pointsfixes.indexof(j0) <> -1 and i <= ubound(ListPtsModifs)
		      p = Point(somm.item(ListPtsModifs(i)))
		      getoldnewpos(p,ep,np)
		      k = 0
		      while pointsfixes.indexof(j0) <> -1 and k <j
		        j1 = pointsfixes(k)
		        bp2 = Point(somm.item(j1)).bpt
		        if  p <> somm.item(j1)  and ep.alignes(bp1,bp2)  then
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
		Function PossibleDrag(op as operation) As Boolean
		  dim i, j as integer
		  dim ffs as figure
		  dim tsf as transformation
		  dim sh as shape
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
		          sh = shapes.item(j)
		          // exception si les formes de self sont des paraperp et l'oper est glisser ou redimensionner
		          t = t and (sh.isaparaperp and (op isa Glisser or op isa Redimensionner) )
		        next
		      end if
		    end if
		  next

		  // on ne peut pas non plus déplacer une figure ff contenant une forme qui supporte une tsf dont l'image et la source sont égales
		  // sauf si la figure de l'image coïncide avec ff

		  for i = 0 to shapes.count-1
		    sh = shapes.item(i)
		    t = t and sh.PossibleDrag
		    for j = 0 to ubound(sh.childs)
		      t = t and sh.childs(j).PossibleDrag
		    next
		  next

		  return t




		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function precede(f as figure) As Boolean
		  Dim s1, s2 As shape
		  dim i, j as integer

		  If f.Auto = 6 and self.auto <> 6 Then
		    Return True
		  end if

		  for i = 0 to ptsconsted.count-1
		    if f.somm.getposition(ptsconsted.item(i)) <> -1 then
		      return true
		    end if
		  Next

		  for i = 0 to ptsconsted.count-1
		    s1 = ptsconsted.item(i)
		    for j = 0 to f.somm.count-1
		      s2 = f.somm.item(j)
		      if s2.constructedby <> nil and s2.constructedby.shape = s1 then
		        return true
		      end if
		    next
		  next

		  for i = 0 to shapes.count -1
		    s1 = shapes.item(i)
		    for j = 0 to f.shapes.count-1
		      s2 = f.shapes.item(j)
		      if s1.precede(s2) then
		        return true
		      end if
		    next
		  next

		  if (auto = 2 or auto = 3 or auto = 5) and f.auto = 4 and NbTrueSommCommuns(f) >= 3 then
		    return true
		  end if

		  if auto = 1 and f.auto <> 3 and NbTrueSommCommuns(f) >= 2  then
		    return true
		  end if

		  if auto = 3 and f.auto = 1 and NbTrueSommCommuns(f) >= 2  then
		    return not HasPointOnConstructedshape (f)
		  end if

		  if auto = 1 and f.auto = 3 and NbTrueSommCommuns(f) >= 2  then
		    return not  f.HasPointOnConstructedShape(self)
		  end if

		  Return false


		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub QQupdateshapes()
		  Dim i As Integer
		  dim p as point
		  dim ep, np as basicpoint
		  dim s as shape

		  for i = 0 to somm.count-1
		    p = point(somm.item(i))
		    If Not p.modified Then
		      getoldnewpos(p,ep,np)
		      If ep <> Nil And np <> Nil And ep.distance(np) > epsilon Then
		        Select Case  p.pointsur.count
		        case  1
		          p.puton p.pointsur.item(0)
		        end select
		      end if
		      if p.isonasupphom(s) = 2 then
		        p.resetonsupphom(s)
		      end if
		      p.updateshape
		      p.modified = True // doit être marqué modifié même s'il n'a pas bougé. (Cas des sommets d'arcs dans un angle de polygone)
		    End If
		  next


		  EndQQupdateshapes

		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("i", i)
		    d.setVariable("p",p)
		    d.setVariable("ep",ep)
		    d.setVariable("np",np)
		    d.setVariable("s", s)
		    err.message = err.message+d.getString

		    Raise err

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub reconstruct()
		  dim i, j  as integer
		  dim diam as double

		  for i = 0 to shapes.count-1
		    diam = shapes.item(i).computediam
		    if diam <= epsilon then
		      for j = 2 to ubound(shapes.item(i).points)
		        shapes.item(i).points(j).moveto shapes.item(i).points(0).bpt
		      next
		      return
		    end if
		    Shapes.item(i).constructshape
		    for j = 0 to ubound(shapes.item(i).points)
		      shapes.item(i).points(j).modified = true   //Pour empêcher updatesomm de déplacer les points qui ont été remis en place
		    next
		  next
		End Sub
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
		Function replacerpoint(p as point) As Boolean

		  if p.forme = 1 and p.modified and not p.unmodifiable and p <> supfig.pmobi then
		    unmodify p
		    return true
		  else
		    return false
		  end if


		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Restore()
		  dim i as integer


		  if ubound(oldbpts) > -1 then
		    Restorebpt
		    RestoreLab
		    Restoretsf
		    UpdateMacConstructedshapes
		    for i = 0 to subs.count - 1
		      Figure(subs.item(i)).restore
		    next
		  end if



		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Restorebpt()
		  dim i, j, i0 as integer
		  dim p as point
		  dim sh as shape


		  for i = 0 to somm.count-1
		    p = point(somm.item(i))
		    p.moveto oldbpts(i)
		    if  invalidpts.indexof(i) <> -1 then
		      p.invalider
		    else
		      p.valider
		    end if
		  next

		  i0 = 0
		  for i = 0 to shapes.count-1
		    if shapes.item(i) isa Lacet  then
		      sh = shapes.item(i)
		      for j = 0 to sh.npts-1
		        if sh.coord.curved(j) = 1 then
		          sh.coord.centres(j) = oldcentres(i0)
		          i0 = i0+1
		        else
		          sh.coord.centres(j) = nil
		        end if
		      next
		      if sh isa secteur then
		        secteur(sh).computeextre
		      end if
		    end if
		  next

		  for i = 0 to PtsConsted.count-1
		    p = point(PtsConsted.item(i))
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
		    p = point(PtsSur.item(i))
		    p.moveto oldptssur(i)
		    if p.forme = 1 then
		      p.puton p.pointsur.item(0)
		    end if
		    if  invalidptssur.indexof(i) <> -1 then
		      p.invalider
		    else
		      p.valider
		    end if
		  next

		  //Problème avec les cercles et calcul des exe et ctrl quand on se limite à exécuter les instructions qui suivent pour les figures et non les sous-figures!
		  //Pas compris pourquoi...
		  for i = 0 to shapes.count-1
		    sh = shapes.item(i)
		    sh.updatecoord
		    if sh isa arc then
		      Arc(sh).computearcangle
		    end if
		    if sh.hybrid then
		      sh.coord.CreateExtreAndCtrlPoints(sh.ori)
		    end if
		  next




		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RestoreInit(EL as XMLElement)
		  Dim i,j, n0, n1 As Integer
		  Dim EL1, EL2, EL3 As XMLElement
		  dim List as XmlNodeList
		  dim p as point
		  dim Inter as Intersec
		  dim M as Matrix
		  dim s as shape

		  List = EL.XQL("Somm")
		  if List.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		    for i = 0 to Somm.count-1
		      p = point(somm.item(i))
		      EL3 = XMLElement(EL1.child(i))
		      p.moveto New BasicPoint(Val(EL3.GetAttribute("X")), Val(EL3.GetAttribute("Y")))
		      If Val(EL3.GetAttribute("Invalid")) = 0 Then
		        p.valider
		      else
		        p.invalider
		      end if
		    next
		  end if

		  List = EL.XQL("PtsConsted")
		  if List.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		    for i = 0 to PtsConsted.count-1
		      p = point(PtsConsted.item(i))
		      EL3 = XMLElement(EL1.child(i))
		      p.moveto New BasicPoint(Val(EL3.GetAttribute("X")), Val(EL3.GetAttribute("Y")))
		      if val(EL3.GetAttribute("Invalid")) = 0 then
		        p.valider
		      else
		        p.invalider
		      end if
		    next
		  end if

		  EL1 = XMLElement(EL.Firstchild)
		  for i = 0 to shapes.count-1
		    EL2 = XMLElement(EL1.Child(i))
		    s = shapes.item(i)
		    s.updatecoord 'La reconstruction des données extre et ctrl est prise en charge par la routine de peinture
		    If s IsA DSect Then
		      s.coord.centres(1) = s.coord.tab(0)
		    end if
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
		      EL3 = XMLElement(EL1.child(i))
		      p = point(PtsSur.item(i))
		      p.moveto New BasicPoint(Val(EL3.GetAttribute("X")), Val(EL3.GetAttribute("Y")))
		      If Val(EL3.GetAttribute("Invalid")) = 0 Then
		        p.valider
		      else
		        p.invalider
		      end if
		    next
		  End If

		  Restoretsf

		  List = EL.XQL("PtsSur")
		  if List.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		    for i = 0 to EL1.Childcount-1
		      p = point(PtsSur.item(i))
		      if p.pointsur.count = 1 then
		        p.puton(p.pointsur.item(0))
		      elseif p.pointsur.count = 2 then
		        n0 = Val(EL3.GetAttribute("Side0"))
		        n1 = Val(EL3.GetAttribute("Side1"))
		        inter= p.GetInter
		        inter.update(p)
		      end if
		    next
		  end if


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RestoreLab()
		  dim i, j as integer
		  dim la as Etiq

		  for i = 0 to shapes.count-1
		    for j = 0 to shapes.item(i).Labs.count-1
		      la =shapes.item(i).labs.item(j)
		      if la.LockRight and la.LockBottom  then
		        la.setposition
		      end if
		      shapes.item(i).enabletoupdatelabel
		      shapes.item(i).updatelabel(1)
		    next
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
		    somm.item(i).Mmove = M
		  next

		  for i = 0 to PtsConsted.count-1
		    ptsconsted.item(i).Mmove = M
		  next

		  for i = 0 to PtsSur.count-1
		    PtsSur.item(i).Mmove = M
		  next


		  for i = 0 to shapes.count-1
		    shapes.item(i).Mmove = M
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Restoretsf()
		  dim i, j as integer
		  dim p as point
		  dim tsf as transformation


		  for i = 0 to somm.count-1
		    for j = 0 to somm.item(i).tsfi.count-1
		      somm.item(i).tsfi.item(j).restore
		    next
		  next

		  for i = 0 to PtsConsted.count-1
		    for j = 0 to ptsconsted.item(i).tsfi.count-1
		      ptsconsted.item(i).tsfi.item(j).restore
		    next
		  next

		  for i = 0 to PtsSur.count-1
		    p = point(PtsSur.item(i))
		    for j = 0 to p.tsfi.count-1
		      p.tsfi.item(j).restore
		    next
		  next


		  for i = 0 to shapes.count-1
		    for j = 0 to shapes.item(i).tsfi.count-1
		      tsf = shapes.item(i).tsfi.item(j)
		      if tsf.type > 0 then
		        tsf.restore
		      end if
		    next
		  next





		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub restructurer()
		  dim figs , List0  as figslist
		  dim ff, sfig as figure
		  dim i, j, k as integer
		  dim t as boolean
		  dim s, s1, s2 as shape
		  dim tsf as transformation
		  dim p as point
		  dim ci as figconstructioninfo
		  dim f as figure

		  for i =  subs.count-1 downto 0
		    f = Figure(subs.item(i))
		    if f <> nil and f.isempty then
		      subs.removeobject subs.item(i)
		    end if
		  next


		  for i = somm.count-1 downto 0
		    if ubound(point(somm.item(i)).parents) = -1 then
		      p = point(somm.item(i))
		      if p.tsfi.count > 0 or ubound(p.constructedshapes) > -1 or (p.constructedby <> nil and p.constructedby.oper = 6) then
		        shapes.addshape p
		        CurrentContent.addShape p
		      else
		        somm.removeobject p
		      end if
		    end if
		  next

		  if shapes.count = 0 then
		    return
		  end if

		  figs = new figslist
		  if shapes.count = 1  then
		    figs.addobject self
		  else
		    for i = 0 to shapes.count-1
		      s = shapes.item(i)
		      t = false
		      for j = 0 to figs.count-1
		        if Figure(figs.item(j)).shapes.getposition(s) <> -1 then
		          t = true
		        end if
		      next

		      if not t then
		        sfig = new Figure(s)
		        List0 = new FigsList
		        List0.addobject sfig
		        for j =  figs.count-1 downto 0
		          if s.mustbeinfigure(figs.item(j)) then
		            List0.addobject figs.item(j)
		            figs.removefigure figs.item(j)
		          end if
		        next
		        ff = List0.concat
		        ff.listerprecedences
		        figs.addobject ff
		      end if
		    next
		  end if


		  for k = 0 to CurrentContent.TheTransfos.count -1
		    tsf = CurrentContent.TheTransfos.item(k)
		    t = false
		    for i = 0 to tsf.constructedfigs.count -1
		      sfig = tsf.constructedfigs.item(i)
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
		        s2 = tsf.constructedshapes.item(i)
		        s1 = s2.constructedby.shape
		        if figs.getposition (s1.fig) <> -1 or figs.getposition(s2.fig) <> -1 then
		          s2.fig.setconstructedby s1.fig, tsf
		          tsf.constructedfigs.addobject s2.fig
		        end if
		      next
		    end if
		  next

		  for i = 0 to figs.count-1
		    Figure(figs.item(i)).idfig = -1
		    CurrentContent.TheFigs.addobject figs.item(i)
		  next


		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("figs", figs)
		    d.setVariable("i",i)
		    d.setVariable("t", t)
		    d.setVariable("tsf", tsf)
		    err.message = err.message+d.getString+EndOfLine+app.ObjectToJSON(self)

		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Save()
		  dim i, j as integer
		  dim s as shape

		  redim invalidpts(-1)
		  redim invalidptscsted(-1)
		  redim invalidptssur(-1)


		  if ubound(oldbpts) <> -1 then
		    return
		  end if

		  for i = 0 to somm.count-1
		    oldbpts.append point(somm.item(i)).bpt
		    if point(somm.item(i)).invalid then
		      InvalidPts.append i
		    end if
		  next

		  for i = 0 to ptsconsted.count-1
		    oldptscsted.append point(ptsconsted.item(i)).bpt
		    if point(ptsconsted.item(i)).invalid then
		      InvalidPtsCsted.append i
		    end if
		  next


		  for i = 0 to ptssur.count-1
		    oldptssur.append point(ptssur.item(i)).bpt
		    if point(ptssur.item(i)).invalid then
		      InvalidPtssur.append i
		    end if
		  next

		  for i = 0 to shapes.count-1
		    if shapes.item(i) isa Lacet  or shapes.item(i) isa secteur  then
		      s = shapes.item(i)
		      for j = 0 to s.npts-1
		        if s.coord.curved(j) = 1 then
		          oldcentres.append s.coord.centres(j)
		        end if
		      next
		    end if
		  next


		  for i = 0 to subs.count - 1
		    Figure(subs.item(i)).save
		  next




		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetConstructedBy(f as figure, tsf as transformation)
		  dim i as integer

		  if f = Nil then
		    return
		  end if

		  for i = 0 to ubound(constructioninfos)
		    if constructioninfos(i).sourcefig = f and constructioninfos(i).tsf = tsf then
		      return
		    end if
		  next
		  ConstructionInfos.append  new FigConstructionInfo(f, tsf)
		  f.Constructedfigs.addobject self

		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("f",f)
		    d.setVariable("tsf",tsf)
		    err.message = err.message+d.getString

		    Raise err

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setfigconstructioninfos()
		  dim i as integer
		  dim s as shape
		  dim tsf as transformation

		  for i = 0 to shapes.count-1
		    s = shapes.item(i)
		    if s.constructedby <> nil and s.constructedby.oper = 6 then
		      tsf = transformation(s.constructedby.data(0))
		      tsf.setconstructioninfos2(s.constructedby.shape,s)
		    end if
		  next


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function standard() As Boolean
		  dim i as integer

		  for i = 0 to shapes.count -1
		    if shapes.item(i).std then
		      return true
		    end if
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function subfigupdate() As Boolean
		  ' DISPATCH PRINCIPAL : Met à jour une sous-figure suite à une modification de point.
		  ' Applique la transformation appropriée selon le mode auto (similarité, affinité, spéciale, etc.).
		  ' Gère aussi les cas dégénérés (pas de modification, formes libres, trapèzes, perpendiculaires).
		  '
		  ' Algorithme :
		  ' 1. Sélectionne matrice de transformation selon le mode auto (7 cas)
		  ' 2. Valide la matrice (non-dégénérée, déterminant proche de 1 pour similarité)
		  ' 3. Applique la transformation à tous les points, formes et points construits
		  ' 4. Vérifie la cohérence finale via checksimaff()
		  '
		  ' @return True si la mise à jour a réussi, False si la configuration est invalide
		  ' Complexité : O(NbPoints + NbShapes + NbConstructedPoints) - linéaire
		  '
		  const AUTO_FIXED = 0         // Formes fixes (standard)
		  const AUTO_SIMILARITY = 1    // Transformations par similarité
		  const AUTO_AFFINITY = 2      // Transformations affines
		  const AUTO_SPECIAL = 3       // Formes spéciales
		  const AUTO_FREEFORM = 4      // Formes quelconques
		  const AUTO_TRAPEZOID = 5     // Trapèzes
		  const AUTO_PERPENDICULAR = 7 // Droites perpendiculaires

		  Dim M As Matrix

		  NbUnModif = 0

			select case auto
			case -1
				return false
			case AUTO_FIXED
				if standard then
					M = autosimupdate
					if M <> nil and M.v1 <> nil and abs (M.det -1) > epsilon then
						M = new Matrix(1)
					end if
				else
					QQupdateshapes
					return true
				end if
			case AUTO_SIMILARITY
				M = autosimupdate
			case AUTO_AFFINITY
				M = autoaffupdate
			case AUTO_SPECIAL
				M = autospeupdate
			case AUTO_FREEFORM
				QQupdateshapes
				return true
			case AUTO_TRAPEZOID
				if autotrapupdate then
					EndTrapupdateshapes
					return true
				else
					return false
				end if
			Case AUTO_PERPENDICULAR
				If Autoprppupdate Then
					EndQQupdateshapes
					Return True
				Else
					Return False
				End If
			end select


			if M = nil or M.v1 = nil then
				if auto = AUTO_FIXED or auto > AUTO_SPECIAL then
					QQupdateshapes
				else
					tobereconstructed = true
				end if
				return true
			else
				if tobereconstructed then
					reconstruct
				end if
				updatesomm(M)
				updatePtsSur(M)
				updatePtsConsted(M)
				updateshapes(M)
				if tobereconstructed then
					tobereconstructed = false
					return true
				end if
				return checksimaff(M)
			end if

		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("auto", auto)
		    d.setVariable("M",M)
		    d.setVariable("tobereconstructed", tobereconstructed)
		    err.message = err.message+d.getString

		    Raise err


		End Function
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
		    while Mat.col(pos2(i-1), pos(j)) = 0
		      j = j+1
		    wend
		    pos2.append pos(j)
		  next

		  if n0 = 2 then
		    f1 = subs.item(pos(0))
		    f2 = subs.item(pos(1))
		    if f1.shapes.count = 1 and f2.shapes.count = 1 then
		      s1 = f1.shapes.item(0)
		      s2 = f2.shapes.item(0)
		      t = (s1.constructedby <> nil and s1.constructedby.oper = 3 and s1.constructedby.shape = s2 ) or (s2.constructedby <> nil and s2.constructedby.oper = 3 and s2.constructedby.shape = s1)
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
		Function update1(p As point) As Boolean
		  Dim t  As Boolean
		  dim i as integer
		  dim sf as figure

		  if p = nil then
		    return false
		  end if

		  pmobi = p  'p est le point guide du point sur lequel on a cliqué
		  t = true

		  listersubfigs(p)
		  for i = 0 to ubound(rang)
		    sf = subs.item(rang(i))
		    dim subfigResult as Boolean
		    subfigResult = sf.subfigupdate
		    t = subfigResult and t
		    if p <> nil and p.id = 17 and not subfigResult then
		    end if
		  next
		  return t

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatemacconstructedshapes()
		  dim i as integer

		  for i = 0 to shapes.count-1
		    shapes.item(i).updatemacconstructedshapes
		  next
		  for i = 0 to somm.count-1
		    somm.item(i).updatemacconstructedshapes
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatematrixduplicatedshapes(M as Matrix)
		  dim i as integer


		  for i = 0 to shapes.count-1
		    shapes.item(i).updatematrixduplicatedshapes(M)
		  next
		  for i = 0 to somm.count-1
		    point(somm.item(i)).updatematrixduplicatedshapes(M)
		  next
		  for i = 0 to PtsConsted.count-1
		    point(PtsConsted.item(i)).updatematrixduplicatedshapes(M)
		  next
		  for i = 0 to PtsSur.count-1
		    point(PtsSur.item(i)).updatematrixduplicatedshapes(M)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateoldM()
		  dim i as integer

		  for i = 0 to shapes.count-1
		    shapes.item(i).updateoldM
		  next
		  for i = 0 to somm.count-1
		    somm.item(i).updateoldM
		  next
		  for i = 0 to PtsConsted.count-1
		    PtsConsted.item(i).updateoldM
		  next
		  for i = 0 to PtsSur.count-1
		    PtsSur.item(i).updateoldM
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateptsconsted(M as Matrix)
		  Dim i As Integer
		  dim p as point

		  if shapes.item(0) isa arc and not shapes.item(0).invalid then
		    arc(shapes.item(0)).computearcangle
		  end if
		  for i = 0 to PtsConsted.count-1
		    p = Point(Ptsconsted.item(i))
		    if p.constructedby.oper = 0 or p.constructedby.oper = 4 or p.constructedby.oper = 45 then
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
		  Dim i As Integer
		  dim p as point

		  'Les pointssur doivent être considérés comme modifiés même si le déplacement est faible,(pour la mise à jour des formes dont ils sont sommets).
		  for i = 0 to ptssur.count-1
		    p = point(ptssur.item(i))
		    select case  p.forme
		    case 1
		      if not p.pointsur.item(0) isa circle then
		        p.transform(M)                                  //Pas bon pour les arcs: les affinités ne conservent pas ls angles
		      else
		        p.puton p.pointsur.item(0), p.location(0)
		      end if
		      p.modified = true
		      p.updateshape
		    end select
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updateshapes()
		  dim i as integer
		  dim s as shape

		  for i = 0 to shapes.count-1
		    s = shapes.item(i)
		    if not s.invalid then
		      s.updateshape
		      s.modified = true
		    end if

		  next



		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updateshapes(M as Matrix)
		  dim i as integer

		  for i = 0 to shapes.count-1
		    if shapes.item(i) isa Circle  then
		      Circle(shapes.item(i)).UpdatePtsConsted
		    end if
		    shapes.item(i).updateshape(M)
		    shapes.item(i).modified = true
		  next



		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesomm(M as Matrix)
		  dim i as integer
		  dim p as Point


		  for i = 0 to somm.count-1
		    p = Point(somm.item(i))
		    p.Transform(M)
		    p.updateshape
		    if  p.forme = 0 then
		      p.modified = true    //déplacé ici pour un problème avec les macros (extrémité d'un arc placé sur une forme mac-construite)
		    end if
		  next







		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub valider()
		  dim i as integer

		  for i = 0 to shapes.count -1
		    shapes.item(i).valider
		  next

		  invalid = false

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
		    Temp =  Doc.CreateElement(Dico.Value("Forms"))
		    EL.appendchild Temp
		  end if

		  EL1 = XMLElement(EL.FirstChild)

		  for i = 0 to shapes.count-1
		    EL1.appendchild shapes.item(i).XMLPutInContainer(Doc)
		  next
		  for i = 0 to PtsConsted.count-1
		    EL1.appendchild PtsConsted.item(i).XMLPutInContainer(Doc)
		  next


		End Sub
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
		AssocFigs As FigsList
	#tag EndProperty

	#tag Property, Flags = &h0
		auto As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		chosen As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		constructedfigs As figslist
	#tag EndProperty

	#tag Property, Flags = &h0
		Constructioninfos(-1) As FigConstructioninfo
	#tag EndProperty

	#tag Property, Flags = &h0
		epold As basicpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		figsimages As figslist
	#tag EndProperty

	#tag Property, Flags = &h0
		fx1 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		fx2 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		idfig As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		invalid As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		invalidpts(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		invalidptscsted(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		invalidptssur(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ListeSupportsTsf(-1) As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ListPtsModifs(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ListSommSur(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ListSommSurModif(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		M1 As MatrixnD
	#tag EndProperty

	#tag Property, Flags = &h0
		Mat As MatrixnD
	#tag EndProperty

	#tag Property, Flags = &h0
		Mmodif As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Matrice du déplacement précédent
		#tag EndNote
		Mmove As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		Modified As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		MP(-1) As MatrixnD
	#tag EndProperty

	#tag Property, Flags = &h0
		NbModif As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		NbModifUnmodif As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		NbUnModif As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		nff(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Oldbpts(-1) As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		oldcentres(-1) As basicpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		oldconstructedby As figconstructioninfo
	#tag EndProperty

	#tag Property, Flags = &h0
		oldptscsted(-1) As basicpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		oldptssur(-1) As basicpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		pmobi As point
	#tag EndProperty

	#tag Property, Flags = &h0
		PointsFixes(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ptfx0(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		PtsConsted As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		PtsSur As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		Rang(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Shapes As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		Somm As PointsList
	#tag EndProperty

	#tag Property, Flags = &h0
		Sommes(-1,-1) As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Subs As FigsList
	#tag EndProperty

	#tag Property, Flags = &h0
		Supfig As Figure
	#tag EndProperty

	#tag Property, Flags = &h0
		tobereconstructed As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="auto"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="chosen"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="fx1"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="fx2"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="idfig"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="invalid"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
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
			Name="Modified"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="NbModif"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NbModifUnmodif"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NbUnModif"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="tobereconstructed"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
' ============================================================================
' REFACTORING ROADMAP - Patterns de duplication identifiés pour Phase 3
' ============================================================================
'
' 1. DUPLICATION AUTOSIMUPDATE / AUTOAFFUPDATE / AUTOSPEUPDATE
'    -----------------------------------------------------------
'    Pattern: chaque famille (sim/aff/spe) possède 3-4 variantes numérotées:
'    - Autoxx1() : 1 point modifié     (~25-35 lignes, select case sur NbSommSur)
'    - Autoxx2() : 2 points modifiés   (~30-40 lignes, sélection points prioritaires)
'    - Autoxx3() : 3+ points modifiés  (~100 lignes, logique complexe imbriquée)
'    - Autoxx4() : (affinity/special seulement, surcontraint) (~60+ lignes)
'
'    Observations communes:
'    - Chaque case du select/case sur NbSommSur (0,1,2,3,else) se répète
'    - getoldnewpos() appelé récursivement pour extraire points anciens/nouveaux
'    - replacerpoint() teste si remplacement simple possible
'    - Chaque variante return new Matrix(1) en cas de conflit
'
'    Opportunité de refactoring:
'    → Créer classe de base AbstractAutoUpdate avec logique commune
'    → Extraire select/case NbSommSur en helper SimilarityMatrix.createFromConstraints()
'    → Consolider validations de matrice (nil check, determinant vérification)
'
' 2. AUTOTRAPUPDATE1/2/3/4 - Trapèze
'    ----------------------------------
'    Tous les 4 retournent Boolean et partagent la même logique:
'    1. Sélectionner les points fixes/mobiles
'    2. Déterminer la paire de côtés parallèles
'    3. Appliquer transformation tout en maintenant parallélisme
'    4. Retourner False si parallélisme est violé
'
'    Consolidation: Extraire logique parallélisme dans SimilarityMatrix/TransformationMatrix
'
' 3. GETOLDNEWPOS() - Appelée ~200+ fois
'    -----------------------------------------------
'    Actuellement: parcourt Point.forme pour récupérer ancienne/nouvelle position
'    Opportunité: Cacher le détail dans Point class pour meilleure encapsulation
'    Considérer: Point.getOldNewPositions() retourne (BasicPoint, BasicPoint)
'
' 4. VARIABLE NAMING - Clarification recommandée
'    -----------------------------------------------
'    somm        → points ou vertices (liste des points de la figure)
'    bpt         → basicPoint ou bptValue
'    nff         → numberOfFigures ou figuresCount
'    ptfx0, ptfx1 → fixedPointsPhase0, fixedPointsPhase1
'    tsf         → transformation (déjà utilisé partiellement)
'    ep, np      → startPoint, endPoint ou oldPosition, newPosition
'    M           → transformationMatrix ou resultMatrix (plus explicite)
'
' 5. LONG METHODS - Candidates pour décomposition
'    -----------------------------------------------
'    • subfigupdate()       : 100 lignes → Dispatcher OK, mais select/case pourrait être polymorphe
'    • autosimupdate3()     : 110 lignes → 5 cases select imbriqués → extraire en sous-méthodes
'    • autospeupdate3()     : 100+ lignes → Très complexe (types de formes spéciales variées)
'    • autoaffupdate3/4()   : 90+ lignes → Surdétermination → extraire logique moindres carrés
'    • subfigupdate()       : 75 lignes (dispatcher) → OK mais pourrait utiliser pattern Strategy
'
' 6. PERFORMANCE OPPORTUNITIES
'    --------------------------
'    • ListSommSur.item(i) vs NbSommSur() appelés multiples fois → cacher dans boucle
'    • Multiple indexOf() sur somm, fxs → pré-calculer indices
'    • Point(somm.item(n)) → wrapper inefficace → direct access en propriété
'    • Recursive calls Autosimupdate/Autoaffupdate dans replacerpoint() → Tail recursion OK
'
' ============================================================================