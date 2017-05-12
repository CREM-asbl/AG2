#tag Class
Protected Class Point
Inherits Shape
	#tag Method, Flags = &h0
		Sub AddToFigure()
		  dim List0, list1 as figslist
		  dim i as integer
		  dim figu, ff, ff1 as figure
		  dim tsf as transformation
		  
		  if fig <> nil then
		    return
		  end if
		  
		  List0 = listerfigsparents
		  CurrentContent.Thefigs.Removefigures List0
		  
		  figu = new Figure(self)
		  select case List0.count
		  case 0
		    fig = figu
		  else
		    ff = List0.concat
		    if pointsur.count > 0 then
		      ff.ptssur.addshape self
		      for i=0 to pointsur.count-1
		        ff1 = pointsur.item(i).getsousfigure(ff)
		        ff1.ptssur.addshape self
		      next
		    elseif centerordivpoint then  // les centerordivpoint ne sont pas repris dans fig.shapes mais uniquement dans fig.ptsconsted
		      ff.ptsconsted.addshape self
		      ff1 = constructedby.shape.getsousfigure(ff)
		      ff1.ptsconsted.addshape self
		    else
		      list1 = new figslist
		      list1.addobject ff
		      list1.addobject figu
		      ff = list1.concat
		    end if
		    fig = ff
		  end select
		  if Constructedby <> nil and constructedby.oper = 6 then
		    tsf = transformation(constructedby.data(0))
		    fig.setconstructedby constructedby.shape.fig, tsf
		    tsf.updateconstructioninfos self
		  end if
		  
		  fig.ListerPrecedences
		  fig.idfig = -1
		  CurrentContent.TheFigs.addobject fig
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub adjustinter(s1 as shape, s2 as shape)
		  dim inter as intersec
		  
		  if s2 = nil then
		    PutOn S1
		    forme = 1
		    drapmagn = false
		    mobility
		    return
		  end if
		  
		  
		  inter = CurrentContent.TheIntersecs.find(s1, s2)
		  
		  if inter = nil then
		    inter = new Intersec(s1,s2)
		    CurrentContent.TheIntersecs.AddObject(inter)
		    inter.computeinter
		  end if
		  
		  inter.addpoint self
		  
		  if s1.invalid or s2.invalid then
		    invalider
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function admitsduplicate(byref s as point) As Boolean
		  dim i as integer
		  dim sh as shape
		  
		  for i = 0 to ubound(constructedshapes)
		    sh = ConstructedShapes(i)
		    if sh isa point and sh.constructedby.oper = 10 then
		      s = Point(sh)
		      return true
		    end if
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ajuster(d1 as droite, d2 as droite) As basicPoint
		  'd1 est une paraperp, self est d1.points(1) et est une extrémité de d2
		  'd2 est aussi une paraperp (généralement le deuxième point de d2 a déjà été modifié)
		  
		  dim Bib1, bib2 as BiBpoint
		  dim n as integer
		  dim w as BasicPoint
		  dim r1, r2 as double
		  
		  Bib1 = new BiBPoint(d1.points(0).bpt, self.bpt)
		  n = d2.getindexpoint(self)
		  n = 1-n
		  w = droite(d2).constructbasis
		  Bib2 = new BibPoint(d2.points(n).bpt, d2.points(n).bpt+w)
		  
		  return bib1.BibInterdroites(Bib2,d1.nextre, d2.nextre,r1,r2)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function allparentsinvalid() As boolean
		  dim i as integer
		  dim b as boolean
		  
		  b = true
		  
		  for i = 0 to ubound(parents)
		    b = b and parents(i).invalid
		  next
		  
		  return b
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function allparentsnonpointed() As Boolean
		  dim t as Boolean
		  dim i, n as integer
		  
		  t = true
		  n = 0
		  
		  for i = 0 to ubound(parents)
		    if parents(i).getindexpoint(self) <> -1 then
		      n = n + 1
		      t = t and  parents(i).nonpointed
		    end if
		  next
		  
		  if n = 0 then
		    return false
		  else
		    return t
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function allparentsqcq() As boolean
		  dim i as integer
		  dim b as boolean
		  
		  b = true
		  
		  for i = 0 to ubound(parents)
		    if parents(i).getindexpoint(self) <> -1 then
		      b = b and parents(i).auto=4
		    end if
		  next
		  
		  return b
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function allparentsyounger() As boolean
		  dim i as integer
		  dim t as boolean
		  
		  t = true
		  
		  for i = 0 to ubound(parents)
		    t = t and id < parents(i).id
		  next
		  
		  return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function authorisedputon(s as shape) As boolean
		  dim i, j  as integer
		  dim par  as shape
		  
		  if pointsur.getposition(s) <> -1 then
		    return true
		  end if
		  
		  if s isa point or s isa repere then
		    return false
		  end if
		  
		  for i = 0 to ubound(parents)
		    par = parents(i)
		    if par.getindexpoint(self) <> -1 then
		      for j = 0 to s.npts-1
		        if par.getindexpointon(s.points(j)) <> -1 then
		          return false
		        end if
		      next
		    end if
		  next
		  
		  return true
		  
		  'for k = 0 to par.npts-1
		  'p = par.points(k)
		  'for h = 0 to ubound(p.parents)
		  'parr = p.parents(h)
		  'for j = 0 to s.npts-1
		  'if (s.points(j) <> self) and (s.points(j).pointsur.getposition(parr) <> -1) then
		  'return false
		  'end if
		  'next
		  'next
		  'next
		  'next
		  'return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BelongTo(s as Shape) As boolean
		  dim i as integer
		  
		  for i = 0 to Ubound(parents)
		    if parents(i) = s then
		      return true
		    end if
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub canceltrace()
		  tracept = false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(p as Basicpoint)
		  bpt =  p
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectsList)
		  Constructor(ol,new BasicPoint(0,0))
		  fam = 0
		  forme = 0
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol As ObjectsList, a as BasicPoint)
		  
		  'Utilisé pour la construction à la souris (notamment)
		  
		  super.constructor(ol,0,0)
		  fam = 0
		  forme = 0
		  auto = 4
		  Bpt =  a
		  Hidden = false
		  createskull(can.transform(Bpt))
		  pointsur = new objectslist
		  conditioned = new objectslist
		  drapmagn = true
		  fillcolor = bordercolor
		  fill = 100
		  Liberte = 2
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, El as XMLElement)
		  
		  
		  Shape.Constructor(ol,El)
		  pointsur = new objectslist
		  conditioned = new objectslist
		  createskull(can.transform(Bpt))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(other as point, NewId as Integer)
		  Constructor(other.GetObjects,other.bpt)
		  SetId(NewId)
		  fam = 0
		  forme = 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateSkull(bp as BasicPoint)
		  rsk = new ovalskull(2, bp)
		  rsk.skullof = self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub delete()
		  dim i, j as integer
		  dim s as shape
		  dim tsf as transformation
		  dim inter as intersec
		  dim macinfo as macconstructioninfo
		  
		  if constructedby <> nil then
		    select case  constructedby.oper
		    case 0, 3, 4,  5,10
		      constructedby.shape.removeconstructedshape self
		    case 6
		      tsf = transformation (constructedby.data(0))
		      if tsf <> nil then
		        tsf.removeconstructioninfos(self)
		      end if
		    case 9
		      if constructedby.shape = nil then
		        for j = 0 to 2 step 2
		          point(constructedby.data(j)).removeconstructedshape self
		        next
		      else
		        constructedby.shape.removeconstructedshape self
		      end if
		    end  select
		    constructedby = nil
		  end if
		  
		  if macconstructedby <> nil then
		    macinfo = macConstructedby
		    for i = 0 to ubound(macinfo.realinit)
		      s = currentcontent.theobjects.getshape(macinfo.realinit(i))
		      s.macconstructedshapes.remove s.macconstructedshapes.IndexOf(self)
		    next
		  end if
		  
		  
		  if tsfi.count > 0 then
		    for i =tsfi.count-1 downto 0
		      CurrentContent.Thetransfos.RemoveObject  tsfi.item(i)
		    next
		  end if
		  
		  if conditioned.count > 0 then
		    for i = 0 to conditioned.count-1
		      conditioned.item(i).conditionedby = nil
		    next
		  end if
		  
		  if conditionedby <> nil then
		    conditionedby.conditioned.removeobject self
		  end if
		  
		  if forme > 0 then
		    if forme = 2 then
		      inter = GetInter 'CurrentContent.TheIntersecs.find(pointsur.item(0), pointsur.item(1))
		      inter.removepoint self
		    end if
		    for j = pointsur.count-1 downto 0
		      RemovePointSur pointsur.item(j)
		    next
		  end if
		  
		  if isolated then
		    removefromfigure
		    currentcontent.removeobject self
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DistanceTo(q as BasicPoint) As double
		  
		  return bpt.Distance(q)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DistanceTo(P2 as Point) As double
		  return Bpt.Distance(P2.Bpt)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoUnselect()
		  Selected = false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnableAllCstedShapesModify()
		  
		  guide.EnableCstedShapesModify
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnableCstedShapesModify()
		  dim i as integer
		  
		  unmodifiable = false
		  
		  for i=0 to UBound(ConstructedShapes)
		    if constructedshapes(i).constructedby.oper = 3 or constructedshapes(i).constructedby.oper = 5 Then
		      Point(ConstructedShapes(i)).EnableCstedShapesModify
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub enablemodify()
		  unmodifiable = false
		  modified = false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub endconstruction()
		  
		  isinconstruction = false
		  updatecoord
		  
		  mobility
		  
		  Currentcontent.addShape self
		  if CurrentContent.ForHisto then
		    if macconstructedby <> nil and forme <> 1 then
		      super.addtofigure
		    else
		      addtofigure
		    end if
		  end if
		  
		  dounselect
		  currentcontent.optimize
		  currentcontent.RemettreTsfAvantPlan
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function etiquet() As string
		  dim et as string
		  
		  if labs.count = 1  and labs.item(0).text <> "" then
		    et = labs.item(0).text
		  else
		    et = "p"+str(id)+ " "
		  end if
		  return et
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fixcouleurtrait(c as couleur, b as integer)
		  bordercolor = c
		  border = 100
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as basicpoint, n as integer)
		  if n = 0 then
		    Moveto(p)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBiBPoint() As BiBPoint
		  dim s as shape
		  dim n as integer
		  
		  
		  if pointsur.count <> 1 then
		    return  nil
		  else
		    s = pointsur.item(0)
		    n = numside(0)
		    return  s.getBiBside(n)
		  end  if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBoundingRadius() As Double
		  return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetComposedMatrix(q as point) As Matrix
		  // self et q sont deux sommets qui se correspondent  dans une chaine de formes dupliquées. On calcule la matrice qui applique
		  // q sur self // On n'est pas sûr que q  précède self dans la chaîne ou l'inverse.
		  //utilisé uniquement dans Modifier.decal
		  
		  dim p1, p2 as point
		  dim M, M1 as Matrix
		  
		  // On vérifie d'abord que q précède self
		  
		  p1 = self
		  p2 = point(p1.predecesseur)
		  
		  While p2 <> nil and p2 <> q
		    p2 =point(p2.predecesseur)
		  wend
		  
		  if p2 = nil       then            // Si q précède self, on parcourt la chaîne une deuxième fois en multipliant les matrices
		    return nil                       // Sinon, on retourne nil
		  end if
		  
		  M = new Matrix(1)
		  
		  if p2 = q  then
		    p2 = point(p1.predecesseur)
		    while p2 <> q
		      if p1.constructedby.shape <> nil then
		        M1 = Matrix(p1.constructedby.data(0))
		      else
		        M1 = Matrix(p1.constructedby.data(1))
		      end if
		      M = M*M1
		      p1 = p2
		      p2 = point(p1.predecesseur)
		    wend
		    if p1.constructedby.shape <> nil then
		      M1 = Matrix(p1.constructedby.data(0))
		    else
		      M1 = Matrix(p1.constructedby.data(1))
		    end if
		    M = M*M1
		  else  //on suppose que q est précédé par self. On ne fait cela que pour oper = 3 (duplicate)
		    p2 = p1.successeur3
		    while p2 <> q
		      M1 = Matrix(p2.constructedby.data(0))
		      M = M1*M
		      p1 = p2
		      p2 = p1.successeur3
		    wend
		    M1 = Matrix(p2.constructedby.data(0))
		    M = M1*M
		    M=M.inv
		  end if
		  
		  return M
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGravityCenter() As BasicPoint
		  return bpt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetInter() As intersec
		  dim s1, s2 as shape
		  
		  if forme <> 2 then
		    return nil
		  end if
		  
		  s1 = pointsur.item(0)
		  s2 = pointsur.item(1)
		  return CurrentContent.TheIntersecs.Find(s1,s2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLab() As string
		  if labs.count > 0 then
		    return labs.item(0).text
		  else
		    return ""
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetSucceedingPointOn(byref p as point, byref q as point, n as integer)
		  dim i as integer
		  
		  if pointsur.count = 1 then
		    if p = nil then
		      p = self
		      if n = 1  then
		        return
		      end if
		    else
		      q =self
		      Return
		    end if
		  end if
		  
		  for i = 0 to ubound(constructedshapes)
		    point(constructedshapes(i)).Getsucceedingpointon(p,q,n)
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.Value("Point")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GridMagnetism(Byref d as BasicPoint) As integer
		  
		  dim td As BasicPoint
		  dim Gm as Integer
		  
		  
		  if CurrentContent.TheGrid <> nil then
		    td = new BasicPoint(bpt.x,bpt.y)
		    Gm=CurrentContent.TheGrid.GridMagnetism(td)
		    d=td
		  end if
		  
		  return Gm
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function hasduplicate() As Boolean
		  dim i As  integer
		  dim pt as Point
		  
		  for i = 0 to Ubound(ConstructedShapes)
		    pt = Point(ConstructedShapes(i))
		    if pt.ConstructedBy.Oper = 5 or pt.constructedby.oper = 3 then
		      return true
		    end if
		  next
		  
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasParents() As boolean
		  return Ubound(Parents)>=0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasStdParent() As Boolean
		  dim i as integer
		  
		  for i = 0 to ubound(parents)
		    if parents(i).std then
		      return true
		    end if
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Hide()
		  
		  hidden = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Identify1(p as point)
		  dim i as integer  // p se substitue aux sommets des parents de self avec lesquels il coïncide
		  
		  if  ((not hasstdparent) and (not p.hasstdparent)) or (( hasstdparent) and ( p.hasstdparent)) and gGetspecialkey <> 4 then
		    for i =  ubound(parents) downto 0
		      Parents(i).SubstitutePoint(P,self)
		    next
		    P.Mobility
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Identify2(p as point)
		  //Méthode utilisée uniquement dans le dooperation de identifier
		  dim i, j as integer
		  dim s as shape
		  dim ol as objectslist
		  
		  // p est le Point  "remplacement" qui doit remplacer self (qui est le "remplacé")
		  
		  if  P = self or gGetSpecialkey = 4 or p.hasstdparent then
		    return
		  end if
		  
		  
		  if labs.count = 1 and p.labs.count = 0 then
		    labs.item(0).chape = p
		    p.labs. addobject  labs.item(0)
		    if not (p.labs.item(0).LockRight and p.labs.item(0).LockBottom) then
		      p.labs.item(0).setposition
		    end if
		  end if
		  
		  ol = isInvolvedInSubdivPoints //cas des points de subdivision (voir plus bas)
		  Identify1(p)    //le remplacement est effectué chez les parents
		  
		  if pointsur.count > 0 then   //cas où remplacé est un point sur
		    p.drapmagn = true
		    select case pointsur.count
		    case 1
		      p.puton pointsur.item(0)
		    case 2
		      p.adjustinter(pointsur.item(0),pointsur.item(1))
		    end select
		  end if
		  
		  if constructedby <> nil then   //cas où remplacé est un point construit
		    s = constructedby.shape                    // valable pour les transfos, duplicata, découpes  ...
		    if s isa point then
		      if point(s) <> p then
		        s.RemoveConstructedShape(self)
		        s.AddConstructedshape(p)
		        p.constructedby = constructedby
		      else
		        p.removeconstructedshape(self)
		      end if
		    end if
		  end if
		  
		  for i =  ubound(constructedshapes) downto 0  //ceci ne s'applique pas au cas ou remplacé est un des deux points utilisés pour une subdivision
		    s = constructedshapes(i)
		    s.constructedby.shape = p
		    p.constructedshapes.append s
		    RemoveConstructedShape(s)
		  next
		  
		  if ol.count>0 then
		    for i = 0 to ol.count-1
		      s = point(ol.item(i))
		      for j = 0 to 1
		        if s.constructedby.data(j)= self then
		          s.constructedby.data(j) = p
		        end if
		      next
		    next
		  end if
		  
		  
		  // Adaptation des figures
		  
		  if fig <> nil and fig.somm.getposition(self) <> -1 then
		    removesommfromfigure
		    p.placersommsurfigure
		  end if
		  
		  if pointsur.count > 0 then
		    p.placerptsursurfigure
		    for i =  pointsur.count -1 downto 0
		      removepointsurfromfigure(pointsur.item(i))
		      removepointsur(pointsur.item(i))
		    next
		  end if
		  
		  
		  if constructedby <> nil  then                    // p remplace les ptsconsted avec lesquels il coïncide
		    if fig.ptsconsted.getposition(self) <> -1 then
		      removeptconstedfromfigure(s)
		      P.PlacerPtconstedsurfigure(s)
		    end if
		  end if
		  
		  P.Mobility
		  CurrentContent.removeobject self   // self est retiré du  jeu
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Invalider()
		  dim i,j as integer
		  dim s as shape
		  dim inter as intersec
		  
		  if currentcontent.currentoperation isa modifier and self = modifier(currentcontent.currentoperation).pointmobile then
		    return
		  end if
		  
		  if not invalid  then
		    invalid = true
		    
		    if forme = 2 then
		      inter = GetInter
		      if inter <> nil then
		        inter.bezet(numside(0), numside(1)) = false
		      end if
		      for i = 0 to conditioned.count -1
		        conditioned.item(i).invalider
		      next
		    end if
		    
		    for i = 0 to ubound(parents)
		      if parents(i).getindexpoint(self) <> -1 then
		        parents(i).invalider
		      end if
		    next
		    
		    for i = 0  to Ubound(ConstructedShapes)
		      ConstructedShapes(i).Invalider
		    next
		    
		    for i = 0 to tsfi.count-1
		      for j = 0 to tsfi.item(i).constructedshapes.count -1
		        s = tsfi.item(i).constructedshapes.item(j)
		        s.invalider
		      next
		    next
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsCenterOfACircle() As Circle
		  dim i as integer
		  
		  for i = 0 to ubound(parents)
		    if parents(i) isa Circle and parents(i).getindex(self) = 0 then
		      return Circle(parents(i))
		    end if
		  next
		  return nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsChildOf(S as shape) As boolean
		  dim i as integer
		  
		  for i = 0 to ubound(parents)
		    if parents(i)  = S then
		      return true
		    end if
		  next
		  
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsCommonPoint() As Boolean
		  dim i,n as integer
		  
		  for i = 0 to Ubound (parents)
		    if parents(i).GetIndexPoint(self) > -1 then
		      n=n+1
		    end if
		    if n >1 then
		      return true
		    end if
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isduplicated() As Boolean
		  return constructedby <> nil and constructedby.oper = 10
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isextremityofarc(byref n as integer, byref ar as arc) As boolean
		  dim i as integer
		  
		  for i = 0 to ubound(parents)
		    if parents(i) isa arc then
		      n = parents(i).getindexpoint(self)
		      if n > 0 and n<3 then
		        ar = arc(parents(i))
		        return true
		      else
		        n = -1
		      end if
		    end if
		  next
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsInvolvedInSubdivPoints() As objectslist
		  dim ol as objectslist
		  dim i, j as integer
		  dim s, sc as shape
		  
		  
		  ol = new ObjectsList
		  
		  for i = 0 to ubound(parents)
		    s = parents(i)
		    for j = 0 to ubound(s.constructedshapes)
		      sc = s.constructedshapes(j)
		      if sc.constructedby.oper = 4 then
		        if (point(sc.constructedby.data(0)) = self) or (point(sc.constructedby.data(1)) = self) then
		          ol.addshape point(sc)
		        end if
		      end if
		    next
		  next
		  
		  return ol
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isolated() As boolean
		  dim i as integer
		  
		  if pointsur.count = 2 then
		    return false
		  end if
		  
		  for i = 0 to ubound(parents)
		    if parents(i).getindexpoint(self) <> -1 then
		      return false     //Le point est sommet d'un de ses parents
		    end if
		  next
		  
		  return true   //Le point n'est sommet d'aucun de ses parents
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isonasupphom(byref s as shape) As integer
		  dim i as integer
		  
		  for i = 0 to ubound(parents)
		    if parents(i) isa supphom then
		      s = parents(i)
		      return parents(i).getindexpoint(self)
		    end if
		  next
		  return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ispointofarc() As Boolean
		  dim i as integer
		  
		  for i = 0 to ubound(parents)
		    if parents(i) isa arc and parents(i).getindexpoint(self) <> -1 then
		      return true
		    end if
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isPointOn(S as Shape, byref k as integer) As boolean
		  
		  
		  for k=0 to pointsur.count-1
		    if pointsur.item(k).id = s.id then
		      return true
		    end if
		  next
		  k = -1
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsPointOnCube() As Boolean
		  dim i as integer
		  
		  for i = 0 to ubound(parents)
		    if parents(i) isa cube then
		      return true
		    end if
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Listerfigsparents() As figslist
		  dim List0 as figslist
		  dim j as integer
		  
		  List0 = new FigsList
		  // Création de la liste (List0) des figures comprenant le point
		  for j = 0 to ubound(parents)
		    List0.addobject parents(j).fig
		  next
		  
		  if centerordivpoint then
		    List0.addobject constructedby.shape.fig
		  end if
		  
		  return list0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Magnetism2(s as Shape, Byref d as BasicPoint, Byref AttractingShape as Shape) As integer
		  //Méthode appelée par Magnetisme, Shape.Magnetism2 et SelectAndDragOperation.AjusterMagnetisme
		  dim i, j as integer
		  dim CurrentMagnetism  as Integer
		  dim StrongestMagnetism as Integer
		  dim  td,q as BasicPoint
		  dim cx,cy, delta as double
		  dim p3 as Basicpoint
		  dim BiB as BiBPoint
		  
		  if not PossibleAttractionWith(s)  then
		    return 0
		  end if
		  
		  delta = can.MagneticDist
		  StrongestMagnetism=0
		  
		  for i=0 to Ubound(s.Childs)
		    if s.childs(i).attracting and  s.childs(i)<> self and (not s.childs(i).hidden or s.std)  and not s.Childs(i).invalid  and not s.childs(i).deleted then
		      CurrentMagnetism=Magnetism3(s.Childs(i),td)
		      if CurrentMagnetism>StrongestMagnetism then
		        StrongestMagnetism=CurrentMagnetism
		        d=td
		        attractingShape=s.childs(i)
		      end if
		    end if
		  next
		  
		  if StrongestMagnetism>0 then
		    return StrongestMagnetism
		  end if
		  
		  d = nil
		  
		  if s isa point then
		    CurrentMagnetism = Magnetism3(Point(s),d)
		    if point(s) <> self then
		      attractingShape=point(s)
		    else
		      attractingshape = nil
		      d = nil
		    end if
		  elseif s isa droite then
		    if s isa Droite and droite(s). nextre = 0   then
		      d= ProjectionOnAttractingDroite(Droite(S))
		    elseif s isa droite and droite(s).nextre = 2 then
		      d= ProjectionOnAttractingSegment(Droite(S).firstp, droite(s).secondp)
		    elseif s isa droite and droite(s).nextre = 1 then
		      d= ProjectionOnAttractingDemidroite(Droite(S).firstp, droite(s).secondp)
		    end if
		  elseif s isa Bande then
		    i = Bande(s).pointonside(bpt)
		    if d = nil and i <> -1 then
		      BiB =  s.GetBibSide(i)
		      'if i = 0 then
		      'p3 = Bande(s).points(1).bpt
		      'else
		      'p3 = Bande(s).point3
		      'end if
		      d =  bpt.projection(BiB) 'Bande(s).points(i).bpt, p3)
		    end if
		  elseif s isa secteur then
		    i = Secteur(s).pointonside(bpt)
		    if d = nil  and i <> -1 then
		      BiB =  s.GetBibSide(i)
		      'if i = 0 then
		      'p3 = Secteur(s).points(1).bpt
		      'else
		      'p3 = Secteur(s).points(2).bpt
		      'end if
		      d = bpt.projection(BiB) 'Secteur(s).points(0).bpt, p3) '  Secteur(s).PointMagnetism2(bpt) 
		    end if
		  elseif s isa polygon and not s isa cube then
		    i = Polygon(S).PointOnSide(bpt)
		    if d = nil and i <> -1 then
		      d = ProjectionOnAttractingSide(Polygon(s),i)
		    end if
		  elseif s isa cube  then
		    for i = 0 to 5
		      if d = nil and bpt.distance (s.Points(i).bpt,s.Points((i+1) mod 6).bpt) < delta  then
		        d = ProjectionOnAttractingSegment(s.Points(i).bpt,s.Points((i+1) mod 6).bpt)
		      end if
		    next
		    j = Cube(s).forme
		    if j > 1 then
		      j = 0
		    end if
		    for i = 1 to 5 step 2
		      if d = nil and bpt.distance(s.Points(6).bpt,s.Points(i-j).bpt) < delta then
		        d = ProjectionOnAttractingSegment(s.Points(6).bpt,s.Points(i-j).bpt)
		      end if
		    next
		  elseif s isa Lacet then
		    i = Lacet(s).pointonside(bpt)
		    if d = nil and i <> -1 then
		      d = ProjectionOnAttractingSide(Lacet(s), i)
		    end if
		  end if
		  if d <> nil and d.distance(bpt) < delta then
		    attractingShape=s
		    return 10
		  end if
		  
		  if s isa Circle then
		    q=Circle(s).GetGravityCenter
		    cx=bpt.Distance(q)
		    cy=Circle(s).getRadius
		    if abs(cx-cy)<= delta then
		      d= bpt.projection(q,cy)
		      if not s isa Arc or (s isa Arc and Arc(s).pInShape(bpt) ) then
		        attractingShape=s
		        return 10
		      end if
		    end if
		  end if
		  return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Magnetism3(s as point, Byref d as BasicPoint) As integer
		  dim delta, dist as double  //Méthode appelée uniquement par Magnetism2
		  
		  
		  delta = can.MagneticDist
		  dist = bpt.distance(s.bpt)
		  if s <> self and dist < delta then
		    d = s.bpt
		    return pointpriority- dist*can.scaling
		  else
		    return 0
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Magnetisme(Byref d as basicpoint, Byref attractingShape as Shape, ByRef nextattractingshape as Shape) As integer
		  //Méthode appelée uniquement par Operation.magnetisme(shape,basicpoint)
		  dim CurrentMagnetism as Integer
		  dim StrongestMagnetism as Integer
		  dim NextStrongestMagnetism As Integer
		  dim obj,  s2  as Shape
		  dim t as BasicPoint
		  dim i as integer
		  
		  StrongestMagnetism=0
		  NextStrongestMagnetism = 0
		  
		  for i=1 to Ubound(currentcontent.plans)
		    obj = Objects.GetShape(currentcontent.plans(i))
		    s2 = nil
		    currentmagnetism = 0
		    
		    if parents.indexof(obj) = -1   then
		      if obj isa point then
		        currentmagnetism = magnetism3(point(obj),t)
		        if currentmagnetism > 0 then
		          s2 = obj
		        end if
		      else
		        CurrentMagnetism = Magnetism2(obj,t,s2)
		      end if
		      
		      if s2 <> nil and s2.attracting and not s2.isinconstruction  and not s2.invalid and not s2.hidden then
		        if CurrentMagnetism >= StrongestMagnetism then
		          NextStrongestMagnetism = StrongestMagnetism
		          d=t
		          Nextattractingshape = attractingshape
		          AttractingShape=s2
		          StrongestMagnetism=CurrentMagnetism
		        end if
		      end if
		    end if
		  next
		  
		  if  attractingShape = nextattractingshape then
		    Nextattractingshape = nil
		  end if
		  
		  return StrongestMagnetism
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Mobility()
		  dim i as integer
		  dim p, p1 as point
		  
		  liberte = 2
		  liberte = liberte-forme 'pointsur.count
		  if std then
		    liberte = 0
		  end if
		  if constructedby <> nil then
		    select case constructedby.oper
		    case 0, 4, 6, 7
		      liberte = 0
		      return
		    case 3, 5
		      if guide <> nil and guide.pointsur.count = 1  and guide <> self then
		        liberte = liberte-1
		      end if
		      p = point(predecesseur)
		      liberte = min(liberte, p.liberte)
		      if p.predecesseur <> nil then
		        p1 =point(p.predecesseur)
		        if p1.predecesseur = p then
		          liberte = 0
		          return
		        end if
		      end if
		      while p.predecesseur <> nil
		        p = point(p.predecesseur)
		      wend
		      p.liberte = liberte
		      p.updatemobilitysucceeding
		    case 10
		      liberte = constructedby.shape.liberte
		    end select
		  end if
		  if (forme <> 1) and (  (MacConstructedBy <>  nil )  or ( (ubound(parents) > -1) and (parents(0).macconstructedby <> nil)  and (parents(0).macconstructedby.RealInit.indexof(id) =-1) )   )   then
		    liberte = 0
		  end if
		  
		  for i = 0 to ubound(parents)
		    if parents(i).std  then
		      liberte = 0
		    end if
		  next
		  'if s isa arc and s.getindexpoint(self) = 2 and pointsur.count = 1 then
		  'sh = pointsur.item(0)
		  '''if (not sh isa circle or (sh.points(0) <> s.points(0))) and (not sh isa Lacet or  s.points(0).bpt.distance (Lacet(sh).support) > epsilon)   then
		  ''liberte = 0
		  ''end if
		  'end if
		  
		  if liberte<0 then
		    liberte=0
		  end if
		  
		  updatemobilitysucceeding
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Move(M as Matrix)
		  Moveto (M*bpt)
		  Mmove = M
		  endmove
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveTo(d as BasicPoint)
		  // Surtout ne pas tester si  (bpt.distance(d) > epsilon)
		  if d <> nil then
		    bpt = d                       'On déplace même les points modifiés
		    if labs.count = 1 and not(labs.item(0).LockRight and labs.item(0).LockBottom) then
		      labs.item(0).SetPosition
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function multassomm() As integer
		  dim i, n as integer
		  
		  for i = 0 to ubound(parents)
		    if parents(i).getindexpoint(self) <> -1 and not parents(i).invalid then
		      n = n+1
		    end if
		  next
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OnSameShape(Q as Point, Byref s as shape) As boolean
		  dim i,j,n as integer
		  dim num1,num2 as double
		  dim sh(-1) as shape
		  dim t as Boolean
		  
		  t = sameparent(q, sh)    // self  et Q ont-ils un parent commun? si oui, le tableau sh les contient tous
		  // rechercher si des points construits sont ok
		  if not t then
		    if Q.ConstructedBy <> nil and Q.ConstructedBy.Oper <> 0 then // si Q est un point construit sans être un centre
		      for i=0 to Ubound(parents)
		        if parents(i)=Q.ConstructedBy.shape then //et si un parent de P est le constructeur de Q
		          sh.append parents(i)                                             // sh est ce parent
		          t = true
		        end if
		      next
		      if ConstructedBy <> nil  and ConstructedBy.Oper <> 0  then
		        if constructedby.shape = Q.constructedby.shape then  // si P et Q ont un même constructeur, on choisit celui-ci
		          sh.append constructedby.shape
		          t = true
		        end if
		      end if
		      
		    end if
		  end if
		  
		  if not t and ConstructedBy <> nil and ConstructedBy.Oper <> 0  then // si self est construit sans être un centre
		    for j=0 to Ubound(Q.parents)
		      if ConstructedBy.shape =Q.parents(j) then // et que le Constructeur de self est un parent de Q
		        t = true
		        sh .append Q.parents(j) // on choisit cette forme
		      end if
		    next
		  end if
		  
		  if not t then   // si on n'a toujours rien choisi, on sort
		    s = nil
		    return false
		  end if
		  if ubound(sh) = -1 then
		    return false
		  end if
		  
		  t = false
		  i = 0
		  
		  while i <=  ubound(sh) and not t
		    num1 = sh(i).getindex(self)
		    num2 = sh(i).getindex(q)
		    if num1 <> -1 and  num2 <> -1 then
		      t = true
		    end if
		    i = i+1
		  wend
		  
		  if not t then
		    return false
		  else
		    s = sh(i-1)
		  end if
		  
		  
		  's = sh(0)
		  if s isa BiPoint  then  // même si s est un bipoint, P et Q n'en sont pas nécessairement les extrémités
		    if abs(num1-num2) = 1 then
		      return true
		    end if
		  elseif  s isa polygon then
		    n = s.npts
		    if abs(num1-num2) = 1 or abs(num1-num2) = s.npts-1 then
		      return true
		    end if
		  elseif  s isa circle and (self <> s.points(0) and  Q <>  s.points(0))  then
		    return true
		  end if
		  
		  return false
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g As Graphics)
		  dim op as operation
		  dim pt as point
		  
		  if bpt = nil then
		    return
		  end if
		  
		  op = currentcontent.currentoperation
		  
		  if  op <> nil and (op  isa shapeconstruction) and (op.currentattractedshape = self) and (not op.currentattractingshape isa repere ) then
		    can.drawzone(can.transform(bpt))
		  end
		  
		  if nonpointed then
		    return
		  end if
		  
		  if ubound(parents) = 0 and parents(0).std then
		    rsk.update(bpt,1)
		  else
		    rsk.update(bpt,2)
		  end if
		  if   (wnd.drapshowall or not hidden)  and (not invalid)  and (not deleted)  then
		    if highlighted or not allparentsnonpointed then
		      if tracept   then
		        rsk.updateborderwidth(borderwidth)
		        rsk.updatecolor(bleu,100)
		      elseif highlighted then
		        if  gGetSpecialkey = 4 and (pointsur.count = 0  or multassomm < 2) then
		          drapmagn = not drapmagn
		          rsk.updatecolor(Config.Transfocolor.col,100)
		        else
		          rsk.updatecolor(Config.highlightcolor.col,100)
		        end if
		        rsk.updateborderwidth(2)
		      elseif selected then
		        rsk.updatecolor(BorderColor.col,100)
		      elseif isinconstruction then
		        rsk.updatecolor(Config.Weightlesscolor.col,100)
		        rsk.updateborderwidth(2.25)
		      elseif hidden then
		        rsk.updatecolor(cyan,100)
		        rsk.updateborderwidth(2)
		      else
		        rsk.updatecolor(BorderColor.col,100)
		        rsk.updateborderwidth(borderwidth)
		      end if
		    elseif  highlighted and currentcontent.currentoperation <> nil and currentcontent.currentoperation isa modifier then
		      rsk.updatecolor(Config.highlightcolor.col,100)
		    end if
		    rsk.paint(g)
		  end if
		  
		  if tracept and currentcontent.theobjects.creertrace then
		    pt=new point(currentcontent.theobjects,bpt)
		    pt.EndConstruction
		  end if
		  
		  if tracept  and (modified or currentcontent.currentoperation isa appliquertsf)  then
		    rsk.paint(can.OffscreenPicture.Graphics)
		    currentcontent.theobjects.tracept = true
		  end if
		  
		  if  (not hidden) and  Labs.count = 1 and (not invalid) and (not deleted) and (g <> can.OffscreenPicture.graphics) then
		    Labs.item(0).Paint(g)
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(obl as objectslist, p as basicpoint) As shape
		  return new Point(Obl,p)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint, sh as shape) As shape
		  dim s as Point
		  dim elem As shape
		  
		  s = new Point(Obl, bpt)
		  
		  if pointsur.count = 1 and sh <> nil then
		    elem = pointsur.item(0)
		    if elem.sametype(sh) then
		      s.puton(sh, location(0))
		    end if
		  else
		    s.moveto p
		  end if
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub permuterparam()
		  dim n as integer
		  dim loc as double
		  dim p as variant
		  
		  if pointsur.count = 2 then
		    n = numside(0)
		    numside(0) = numside(1)
		    numside(1) = n
		    loc = location(0)
		    location(0) = location(1)
		    location(1) = loc
		    p = pointsur.element(0)
		    pointsur.objects(0) = pointsur.objects(1)
		    pointsur.objects(1) = p
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pieddeperp() As boolean
		  dim d, dp as shape   'dp perp à d
		  
		  
		  if ubound(parents) <> 1 or forme <> 1 then
		    return false
		  end if
		  
		  d = pointsur.item(0)
		  
		  if d = parents(0) then
		    dp = parents(1)
		  else
		    dp = parents(0)
		  end if
		  
		  if dp.constructedby <> nil and dp.constructedby.shape = d and dp.constructedby.oper = 2 then
		    return true
		  else
		    return false
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(p as BasicPoint) As Boolean
		  
		  
		  return bpt.distance(p) <= can.MagneticDist
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PlacerPtConstedsurfigure(s As Shape)
		  dim ff0 as figure
		  dim figs as figslist
		  dim i as integer
		  figs = new Figslist
		  
		  
		  
		  s.fig.PtsConsted.addshape self
		  ff0 = s.getsousfigure(s.fig)
		  ff0.PtsConsted.addshape self
		  
		  for i = 0 to ubound(parents)
		    figs.addobject parents(i).fig
		  next
		  figs.addobject s.fig
		  
		  if CurrentContent.ForHisto then
		    CurrentContent.TheFigs.RemoveFigures figs
		  end if
		  
		  fig = figs.concat
		  fig.ListerPrecedences
		  fig.idfig = -1
		  
		  if CurrentContent.ForHisto then
		    CurrentContent.TheFigs.addobject fig
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub placerptsursurfigure()
		  dim figs as figslist
		  dim i as integer
		  dim ff0, ff1 as figure
		  dim s as shape
		  
		  figs = new FigsList
		  
		  if ubound(parents) = 0 then
		    figs.addobject fig
		  end if
		  for i = 0 to ubound(parents)
		    figs.addobject parents(i).fig
		  next
		  
		  if CurrentContent.ForHisto then
		    CurrentContent.TheFigs.RemoveFigures figs
		  end if
		  if figs.count = 1 then
		    ff0 = new figure(figs.item(0))
		    figs.removefigure figs.item(0)
		    figs.addobject ff0
		  end if
		  
		  for i = 0 to pointsur.count-1
		    s = pointsur.item(i)
		    ff0 = s.fig
		    ff0.PtsSur.addshape self
		    ff1 = s.GetSousFigure(ff0)
		    ff1.PtsSur.addshape self
		    figs.addobject ff0
		  next
		  fig = figs.concat
		  fig.ListerPrecedences
		  if CurrentContent.ForHisto then
		    CurrentContent.TheFigs.addobject fig
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub placersommsurfigure()
		  dim figs as figslist
		  dim i as integer
		  dim ff0 as figure
		  
		  figs = new FigsList
		  
		  for i = 0 to ubound(parents)
		    ff0 = parents(i).getsousfigure(parents(i).fig)
		    ff0.somm.addobject self
		    figs.addobject parents(i).fig
		  next
		  
		  
		  if CurrentContent.ForHisto then
		    CurrentContent.TheFigs.RemoveFigures figs
		  end if
		  
		  if figs.count = 1 then
		    ff0 = new figure(figs.item(0))
		    figs.removefigure figs.item(0)
		    figs.addobject ff0
		  end if
		  
		  fig = figs.concat
		  fig.ListerPrecedences
		  if CurrentContent.ForHisto then
		    CurrentContent.TheFigs.addobject fig
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pointoncube() As boolean
		  dim i as integer
		  
		  for i = 0 to ubound(parents)
		    if parents(i) isa cube then
		      return true
		    end if
		  next
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSameSide(q as point) As Boolean
		  if pointsur.count = 1 and q.pointsur.count = 1 then
		    return pointsur.item(0) = q.pointsur.item(0)  and  numside(0) = q.numside(0)
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As integer
		  if pinshape(p) then
		    return 0
		  else
		    return -1
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PossibleAttractionWith(other as Shape) As Boolean
		  
		  dim gc1,gc2,bp as basicpoint
		  dim dist,b1,b2 as double
		  dim magdist as double
		  magdist = can.MagneticDist
		  
		  
		  bp = Point(self).bpt
		  
		  if other isa point and point(other).bpt <> nil then
		    dist = bp.distance(point(other).bpt)
		    if dist <= magdist then
		      return true
		    end if
		  elseif  other isa droite then
		    return Droite(other).PInshape(bp)
		  elseif  other isa bande then
		    return not (Bande(other).PointOnSide(bp) = -1)
		  elseif   other isa secteur then
		    return not (Secteur(other).PointOnSide(bp) = -1)
		  elseif other <> nil then
		    gc2 = other.getgravityCenter
		    if  gc2 <> nil then
		      dist=bp.Distance(gc2)
		      b2=other.getBoundingRadius()
		      if dist < b2+magdist then
		        return true
		      else
		        return false
		      end if
		    else
		      return false
		    end if
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function predecesseur() As point
		  if duplicateorcut then
		    return point(constructedby.shape)
		  end if
		  if fused then
		    if constructedby.shape <> nil then
		      return point(constructedby.shape)
		    else
		      return point(constructedby.data(0))
		    end if
		  end if
		  
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub print(g as Graphics, sc As Double)
		  dim i as integer
		  
		  rsk.Scale = rsk.Scale*sc
		  rsk.X = rsk.X * sc
		  rsk.Y = rsk.Y * sc
		  rsk.paint(g)
		  rsk.Scale = rsk.Scale/sc
		  rsk.X = rsk.X/sc
		  rsk.Y = rsk.Y/sc
		  
		  for i = 0 to labs.count-1
		    Labs.item(i).print(g, sc)
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProjectionOnAttractingDemidroite(p1 as BasicPoint, p2 as BasicPoint) As BasicPoint
		  dim td As BasicPoint
		  
		  td = bpt.Projection(p1,p2)
		  if not td.audela(p1,p2) then
		    td = p1
		  end if
		  if td <> nil then
		    return td
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProjectionOnAttractingDroite(D as Droite) As BasicPoint
		  dim p1,p2 as BasicPoint
		  dim td As BasicPoint
		  
		  p1 = D.firstp
		  p2 = D.secondp
		  
		  td = bpt.Projection(p1,p2)
		  select case D.nextre
		  case 1
		    if not td.audela(p1,p2) then
		      td = nil
		    end if
		  case 2
		    if not td.between(p1,p2) then
		      td = nil
		    end if
		  end select
		  return td
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProjectionOnAttractingSegment(p1 as BasicPoint, p2 as BasicPoint) As BasicPoint
		  dim td As BasicPoint
		  dim d as double
		  
		  td = bpt.Projection(p1,p2)
		  if not td .between(p1,p2) then
		    d = bpt.distance(p1)
		    if d > bpt.distance(p2) then
		      td = p2
		    else
		      td = p1
		    end if
		  end if
		  if td <> nil then
		    return td
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ProjectionOnAttractingSide(s as Lacet, i as integer) As basicpoint
		  
		  
		  if not s isa cube and  s.coord.curved(i) = 1 then
		    return bpt.projection(s.coord.centres(i), s.getradius(i))
		  else
		    return ProjectionOnAttractingSegment(s.Points(i).bpt,s.Points((i+1) mod s.npts).bpt)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PutDuplicateOn(s as shape, q as point)
		  dim sh as shape
		  dim s1, s2 as point
		  dim r as double
		  dim k As integer
		  
		  
		  sh = pointsur.item(0)
		  
		  if (sh isa polygon and s isa droite and droite(s).nextre = 2)  or (sh isa droite and droite(sh).nextre = 2 and s isa polygon) or surseg then
		    q.surseg = true
		  end if
		  
		  r = location(0)
		  
		  q.puton s,r
		  s1 = self
		  if sh = s and q.numside(0) = numside(0) then
		    q.puton s, 1-r
		    q.SetConstructedBy self,10
		  else
		    while s1.admitsduplicate(s2) and s2.location(0) = s1.location(0) and s2 <> q
		      s1 = s2
		    wend
		    q.setconstructedby s1, 10
		  end if
		  k =q.numside(0) - s1.numside(0)
		  if k < 0 and  s isa polygon then
		    k =  k+ s.npts
		  end if
		  q.constructedby.data.append k
		  q.mobility
		  'q.updateguides
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PutInState(Doc as XMLDocument) As XMLElement
		  dim EL as XMLElement
		  
		  EL = Doc.CreateElement("Coord")
		  EL.SetAttribute("X", str(bpt.x))
		  EL.SetAttribute("Y", str(bpt.y))
		  if invalid then
		    EL.setattribute("Invalid", str(1))
		  end if
		  if pointsur.count = 2 then
		    EL.SetAttribute("Side0", str(numside(0)))
		    EL.SetAttribute("Side1",str(numside(1)))
		  end if
		  return EL
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PutOn(s as shape)
		  // Formes risquant d'être déformées à la construction du dernier sommet
		  // TriangIso, Triangrect, Trap, Rect, Arc, paraperp
		  //D'où le specialputon
		  dim sh as shape
		  dim n, k, m as integer
		  dim d as double
		  dim dr as droite
		  dim Bib as BiBPoint
		  dim ar as arc
		  
		  if bpt = nil or S = nil or not authorisedputon(s)  then
		    return
		  end if
		  
		  if currentcontent.currentoperation isa shapeconstruction then
		    sh=shapeconstruction(CurrentContent.currentoperation).currentshape
		    n = sh.indexconstructedpoint
		    if (sh.isaparaperp and n = 1 and s <> sh.constructedby.shape) or (( (sh isa triangiso) or (sh isa triangrect) or (sh isa rect) or (sh isa arc)) and (n = 2)) or    (sh isa trap and (not sh isa traprect) and (not sh isa trapiso)  and (n = 3)) then
		      if not s isa circle then
		        k = s.pointonside(bpt)
		        dr = s.getside(k)
		        Bib = new BibPoint(dr.firstp,dr.secondp)
		        d = bpt.distance(bib)
		      else
		        d = abs(bpt.distance(s.points(0).bpt)-circle(s).getradius)
		      end if
		      specialputon(sh,n,s,k)
		    end if
		  end if
		  
		  if  PointSur.GetPosition(s) = -1 then
		    PointSur.addshape s
		    location.append 0
		    numside.append -1
		    forme = PointSur.count
		  end if
		  
		  if isextremityofarc(n, ar) then  
		    if s isa Lacet then
		      k = s.getindexpoint(ar.points(0))
		      m = Lacet(s).pointonside(bpt)
		      if m = k or k = (m+1) mod s.npts then
		        surseg = true
		      end if
		    end if
		  end if
		  
		  if  s isa bande then
		    PutOnBande(Bande(s))
		  elseif S isa secteur then
		    PutOnSecteur (secteur(s))
		  elseif S isa polygon then
		    PutOnPolyg(Polygon(s))
		  elseif S isa Lacet then                        
		    Lacet(S).Positionner(self)
		  elseif S isa Bipoint then
		    PutOnBipoint (Bipoint(s))
		  elseif  S isa  circle and not S isa Arc then
		    PutOnCircle(circle(s))
		  elseif S isa Arc then
		    Arc(S).Positionner(self) 'PutOnArc(arc(s)) selon le principe que chaque classe doit se gérer elle-même
		  end if
		  
		  mobility
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PutOn(s as shape, r as double)
		  dim ar as Arc
		  dim q as BasicPoint
		  dim k , n as integer
		  dim Bib as BibPoint
		  dim angle as double
		  
		  if  not ispointon(s,k)  then
		    PointSur.addshape s
		    location.append  r
		    S.setpoint(self)
		    numside.append s.PointOnSide(self.bpt)
		    k = PointSur.Count-1
		  end if
		  
		  if (numside(k) < 0 ) or (numside(k) > s.npts-1) then
		    return
		  end if
		  location(k)=r
		  
		  if s isa Bipoint  then
		    Bib = s.getBiBside(numside(k))
		    q = BiB.BptOnBiBpt(r)
		  elseif s isa polygon or s isa Bande or s isa Secteur then
		    BiB = s.GetBibSide(numside(k))
		    q = BiB.BptOnBiBpt(r)
		  elseif S isa Arc then
		    ar = Arc(S)
		    r = r*ar.arcangle+ar.startangle
		    q = new BasicPoint(cos(r),sin(r))
		    q =  ar.GetGravityCenter + q * ar.GetRadius
		  elseif S isa circle then
		    q=s.coord.positionOnCircle(r,s.ori)
		  elseif s isa Lacet then
		    n = numside(k)
		    if Lacet(s).coord.curved(n) = 0 then
		      q = (s.Points(n).bpt)*(1-r) + (s.Points( (n+1) mod s.npts).bpt) *r
		    else
		      angle = r*Lacet(s).GetArcAngle(n) +Lacet(s).GetStartAngle(n)
		      q = new BasicPoint(cos(angle),sin(angle))
		      q = Lacet(s).coord.centres(n)+ q * Lacet(s).GetRadius(n)
		    end if
		  end if
		  Moveto q
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub putonarc(a as basicpoint, b as basicPoint, c as BasicPoint, angle as double, ampliarc as double, startangle as double, n as integer)
		  dim r as double
		  dim q as basicPoint
		  
		  r = angle/ampliarc
		  
		  if r <= 0 then
		    MoveTo a
		    location(n)=0
		  elseif r>=1 then
		    MoveTo b
		    location(n)=1
		  else
		    angle = angle+startangle
		    q = new BasicPoint (cos(angle), sin(angle))
		    q = c+q*(c.distance(a))
		    Moveto q
		    location(n) = r
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PutOnBande(s as Bande)
		  dim  n as integer
		  dim BiB as BiBPoint
		  
		  n = Pointsur.getposition(s)
		  
		  if numside(n) = -1 then
		    numside(n) = S.PointonSide(bpt)
		  end if
		  BiB = s.GetBibSide(numside(n))
		  location(n) = bpt.location(BiB)
		  Moveto(bpt.projection(BiB))
		  
		  S.setpoint self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PutOnBiPoint(s as Bipoint)
		  dim a,b as BasicPoint
		  dim  n as integer
		  dim r as double
		  
		  n = Pointsur.getposition(s)
		  a =  s.firstp
		  b =  s.secondp
		  r = bpt.location(a,b)
		  numside(n) = 0
		  location(n) =r
		  if not s isa droite then
		    moveto (bpt.projection(a,b))
		  else
		    select case droite(s).nextre
		    case 0
		      Moveto(bpt.projection(a,b))
		    case 1
		      if r < 0 then
		        location(n) = 0
		        moveto a
		      else
		        moveto(bpt.projection(a,b))
		      end if
		    case 2
		      putonsegment(a,b,r,n)
		      surseg = true
		    end select
		  end if
		  
		  S.setpoint self
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PutOnCircle(s as circle)
		  
		  
		  dim  n as integer
		  
		  
		  n = Pointsur.getposition(s)
		  
		  location(n) = bpt.location(s)
		  numside(n) = 0
		  Moveto bpt.projection(s.getgravitycenter, s.getradius)
		  
		  S.setpoint self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PutOnPolyg(pol as Polygon)
		  dim a,b as BasicPoint
		  dim n,num as integer
		  dim i as integer
		  dim CutPt as Boolean
		  
		  n = Pointsur.getposition(pol)
		  i=0
		  while (i<= UBound(ConstructedShapes) and not Cutpt)   'si c'est un point de découpe, on le maintient sur le même côté
		    if ConstructedShapes(i).ConstructedBy.Oper=5 or  point(constructedshapes(i)).surseg  or surseg then
		      CutPt =true
		    else
		      i=i+1
		    end if
		  wend
		  
		  num = pol.PointonSide(bpt)
		  
		  if num <> -1 and IsInConstruction  then
		    numside(n) = num
		  elseif not CutPt and not surseg and  (num <> -1) and (num <> numside(n))  then         //on change le pointsur de côté
		    numside(n) = num
		  end if
		  
		  if numside(n) < Pol.npts and numside(n) > -1  then
		    a = Pol.Points(numside(n)).bpt
		    b = Pol.Points((numside(n)+1) mod Pol.npts).bpt
		    location(n) = bpt.location(a,b)
		    if pieddeperp then                            'Pour les pieds de hauteur
		      if location(n) <0 or location(n) >1 then
		        invalider
		      else
		        valider
		        putonsegment(a,b,location(n),n)
		      end if
		    else
		      putonsegment(a,b,location(n),n)
		    end if
		  end if
		  
		  pol.setpoint self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PutOnSecteur(s as secteur)
		  dim a,b as BasicPoint
		  dim n as integer
		  
		  
		  n = Pointsur.getposition(s)
		  if Numside(n) = -1 then
		    numside(n) = S.PointonSide(bpt)
		  end if
		  a = S.Points(0).bpt
		  b = S.Points(numside(n)/2+1).bpt
		  location(n) = bpt.location(a,b)
		  if location(n) < 0 then
		    location(n) = 0
		    moveto a
		  else
		    Moveto(bpt.projection(a,b))
		  end if
		  
		  S.setpoint self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PutOnSegment(a as BasicPoint, b as BasicPoint, r as double, n as integer)
		  'location(n) = r
		  'moveto bpt.projection(a,b)
		  '
		  'if r <0 or r > 1 then
		  'invalider
		  'else
		  'valider
		  'end if
		  
		  if r <= 0 then
		    moveto a
		    location(n) = 0
		  elseif r>= 1 then
		    moveto b
		    location(n) = 1
		  else
		    moveto bpt.projection(a,b)
		    location(n) = r
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PutOnSide(s as shape)
		  dim n, k as integer
		  
		  n = Pointsur.getposition(s)
		  
		  if n = -1 then
		    return
		  end if
		  
		  if invalid then
		    k = numside(n)
		    if s.pointonside(bpt) = k then
		      puton(s)
		    end if
		  else
		    puton s
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveParent(s as Shape)
		  if parents.indexof(s) <> -1 then
		    Parents.remove Parents.indexof(s)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemovePointSur(s as shape)
		  dim k as integer
		  
		  k = pointsur.getposition(s)
		  if k <> -1 then
		    location.remove k
		    numside.Remove k
		    pointsur.removeobject s
		    forme = forme-1
		  end if
		  s.removechild self
		  removeparent s
		  mobility
		  removefromfigure
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removepointsurfromfigure(s as shape)
		  dim ff0 as figure
		  
		  s.fig.PtsSur.removeobject self
		  ff0 = s.getsousfigure(s.fig)
		  ff0.PtsSur.removeobject self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemovePtConstedFromFigure(s as shape)
		  dim ff0 as figure
		  
		  s.fig.PtsConsted.removeobject self
		  ff0 = s.getsousfigure(s.fig)
		  ff0.PtsConsted.removeobject self
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removesommfromfigure()
		  dim i as integer
		  
		  fig.somm.removeobject self
		  for i = 0 to fig.subs.count-1
		    fig.subs.item(i).somm.removeobject self
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub repositioncstedpoint()
		  dim s as shape
		  dim a, b,bp as BasicPoint
		  dim Bib as BiBPoint
		  dim Trib as TriBPoint
		  dim side as integer
		  
		  s = constructedby.shape
		  select case ConstructedBy.oper
		  case 0
		    MoveTo s.getgravitycenter
		  case 4
		    a = Point(ConstructedBy.data(0)).bpt
		    b = Point(ConstructedBy.data(1)).bpt
		    if s isa circle then
		      Trib = new TriBPoint(s.getgravitycenter,a,b)
		      bp = Trib.subdiv(s.ori,ConstructedBy.data(2), ConstructedBy.data(3))
		    elseif s isa lacet then
		      side = constructedby.data(4)
		      if lacet(s).coord.curved(side) = 0 then
		        Bib = new BiBpoint(a,b)
		        bp = Bib.subdiv(ConstructedBy.data(2), ConstructedBy.data(3))
		      else
		        Trib = new TribPoint(lacet(s).getcentre(side),a,b)
		        bp = Trib.subdiv(s.ori,ConstructedBy.data(2), ConstructedBy.data(3))
		      end if
		    else
		      BiB = new BiBPoint(a,b)
		      bp = Bib.subdiv(ConstructedBy.data(2), ConstructedBy.data(3))
		    end if
		    moveto bp
		  end select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub resetonsupphom(s as shape)
		  dim n as integer
		  dim ff as figure
		  dim ep, eq, np, nq as BasicPoint
		  dim r as double
		  
		  if s isa supphom then
		    n = s.getindexpoint(self)
		    if n <> 2 then
		      ff = s.GetSousFigure(s.fig)
		      ff.getoldnewpos(s.points(0),ep,np)
		      ff.getoldnewpos(s.points(1),eq,nq)
		      r = s.points(2).bpt.location(ep,eq)
		      moveto np*(1-r)+nq*r
		    else
		      moveto bpt.projection(s.points(0).bpt,s.points(1).bpt)
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SameParent(Q as Point, Byref s() as shape) As boolean
		  dim i,j as integer
		  
		  for i = 0 to ubound(parents)
		    for j=0 to Ubound(Q.parents)
		      if parents(i)=Q.parents(j) and not parents(i).hidden then
		        s.append Parents(i)
		      end if
		    next
		  next
		  
		  
		  if ubound(s) > -1 then
		    return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function searchfollowingpointon() As point
		  dim i as integer
		  dim t as boolean
		  
		  // on recherche le premier pointsur dans l'arbre des descendants (éventuellement le point lui-même)
		  
		  t = duplicateorcut or fused
		  
		  for i = 0 to ubound(constructedshapes)
		    t = t or ConstructedShapes(i).duplicateorcut or constructedshapes(i).fused
		  next
		  
		  if t then
		    
		    if pointsur.count = 1 then
		      return self
		    end if
		    
		    for i = 0 to ubound(constructedshapes)
		      if point(constructedshapes(i)) = self then
		        return self
		      else
		        return  point(constructedshapes(i)).searchfollowingpointon
		      end if
		    next
		    
		  else
		    return nil
		    
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectShape(p as BasicPoint) As Shape
		  
		  if  bpt.distance(p) <= abs(can.MagneticDist) and not invalid and not deleted then
		    return self
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setguide(p as point)
		  dim i as integer
		  
		  guide = p
		  
		  for i = 0 to ubound(constructedshapes)
		    if (point(constructedshapes(i)).duplicateorcut or point(constructedshapes(i)).fused ) and point(constructedshapes(i))<> self then
		      point(constructedshapes(i)).setguide(p)
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setParent(s as Shape)
		  dim i As Integer
		  
		  for i=0 to Ubound(parents)
		    if parents(i).id = s.id then
		      return
		    end if
		  next
		  
		  parents.append s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SimulInter(s1 as shape, s2 as shape) As BasicPoint
		  dim inter as intersec
		  
		  inter = GetInter  'CurrentContent.TheIntersecs.find(s1, s2)
		  
		  if inter = nil then
		    inter = new Intersec(s1,s2)
		  end if
		  
		  inter.computeinter
		  if not inter.somevalidpoint then
		    return nil
		  else
		    return inter.locatepoint(bpt)
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SpecialPuton(sh as shape, n as integer, s as shape, k as integer)
		  // n est le numéro du point de sh à placer sur s
		  
		  dim p, q as basicpoint
		  dim Bib1 as BiBPoint
		  dim bp As BasicPoint
		  
		  //sh peut être un paraperp, avec n = 1 ou un triangiso (n=2), un triangrect (n=2), un trap  (mais ni traprect, ni trapiso, n=3), un rect (n = 2), ou un arc avec n = 2
		  
		  if sh.isaparaperp then
		    p = droite(sh).firstp
		    q = droite(sh).secondp
		  elseif sh isa triangiso then
		    p = (sh.points(0).bpt+sh.points(1).bpt)/2
		    q = sh.points(2).bpt
		  elseif sh isa triangrect or sh isa rect then
		    p = sh.points(1).bpt
		    q = sh.points(2).bpt
		  elseif sh isa trap then
		    p = sh.points(2).bpt
		    q = sh.points(3).bpt
		  elseif sh isa arc then
		    p = sh.points(0).bpt
		    q = sh.points(1).bpt
		  end if
		  
		  Bib1 = new BibPoint(p,q)
		  
		  if  not sh isa circle  then
		    bp = bib1.ComputeDroiteFirstIntersect(s,k,bpt)
		  else
		    bp = Bib1.ComputeCircleFirstIntersect(s,k, bpt)
		  end if
		  
		  if bp <> nil then
		    sh.points(n).moveto bp
		  end if
		  
		  
		  
		  // a compléter
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function sqrDistanceTo(x as double, y as double) As double
		  dim q as BasicPoint
		  dim dist as double
		  
		  q = new BasicPoint(x,y)
		  dist = bpt.distance(q)
		  return dist*dist
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SqrDistanceTo(Seg as Droite) As double
		  dim dist as double
		  
		  dist = bpt.distance(seg.firstp, seg.secondp)    'bibpoint(seg.coord))
		  return dist*dist
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SqrDistanceTo(P2 as Point) As double
		  dim dist as double
		  
		  dist = bpt.distance(p2.bpt)
		  return dist*dist
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function successeur3() As point
		  dim s as point
		  dim i as integer
		  
		  for i = 0 to ubound (constructedshapes)
		    s = point(constructedshapes(i))
		    if s.constructedby.oper = 3  then
		      return s
		    end if
		  next
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Swap()
		  Hidden = not Hidden
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEps(tos As TextOutputStream)
		  dim seps as SaveEps
		  
		  seps = SaveEps(CurrentContent.currentoperation)
		  
		  if not nonpointed and not hidden and not invalid  and not deleted  then
		    seps.adapterparamdessin(self,tos)
		    tos.writeline etiquet + " point"
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Transform(M as Matrix)
		  
		  
		  if (not modified)  or (pointsur.count =1 and  allparentsqcq)  then
		    Move (M)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateconstructedpoints()
		  dim s as Point
		  dim M1 as Matrix
		  dim i,j, side as integer
		  dim tsf as Transformation
		  dim sh as Point
		  
		  for i=0 to UBound(ConstructedShapes)
		    s = Point(ConstructedShapes(i))
		    if not s.modified  then
		      select case s.constructedby.Oper
		      case 3, 5 'duplication et découpage
		        if (not currentcontent.currentoperation isa retourner) and (not currentcontent.currentoperation isa selectanddragoperation) or  (currentcontent.currentoperation isa modifier)  then
		          M1 = Matrix(s.constructedby.data(0))
		          s.Moveto M1*bpt
		        end if
		      case 6 'image par transfo
		        tsf = Transformation(s.constructedby.data(0))
		        M1 = tsf.M
		        if M1 <> nil and M1.v1 <> nil then
		          s.Moveto M1*bpt
		        end if
		      case 9  ' fusion
		        if s.constructedby.shape <> nil then
		          M1 = Matrix(s.constructedby.data(0))
		          s.MoveTo M1*bpt
		        else
		          for j = 0 to 2 step 2
		            sh = Point(s.constructedby.data(j))
		            if sh = self then
		              M1 = Matrix(s.constructedby.data(j+1))
		              s.MoveTo M1*bpt
		            end if
		          next
		        end if
		      case 10 'duplication de pointsur
		        side = s.Numside(0)
		        s.numside(0) = (numside(0)+s.ConstructedBy.data(0)) mod s.pointsur.item(0).npts
		        if s.pointsur.item(0) = pointsur.item(0) and s.numside(0) = numside(0) then
		          s.puton(s.pointsur.item(0),1-location(0))
		        else
		          s.puton(s.pointsur.item(0),location(0))
		        end if
		      end select
		      
		      s.modified = true
		      s.updateshape
		    end if
		  next
		  
		  
		  if constructedby <> nil and not centerordivpoint and constructedby.oper <> 9  then
		    s = Point(ConstructedBy.Shape)
		    if not s.modified then
		      select case constructedby.Oper
		      case 3, 5
		        M1 = Matrix(constructedby.data(0))
		        M1 = M1.inv
		        s.Moveto M1*(self.bpt)
		      case 10
		        side = s.Numside(0)
		        s.numside(0) = (numside(0)-ConstructedBy.data(0)+s.pointsur.item(0).npts) mod s.pointsur.item(0).npts
		        if s.pointsur.item(0) = pointsur.item(0) and s.numside(0) = numside(0) then
		          s.puton(s.pointsur.item(0),1-location(0))
		        else
		          s.puton(s.pointsur.item(0),location(0))
		        end if
		      end select
		      s.modified = true
		      s.updateshape
		    end if
		  elseif constructedby <> nil and constructedby.oper = 9 then
		    if constructedby.shape <> nil then
		      s = Point(ConstructedBy.Shape)
		      M1 = Matrix(constructedby.data(0))
		      M1 = M1.inv
		      s.Moveto M1*bpt
		      s.modified = true
		      s.updateshape
		    else
		      for i = 0 to 2 step 2
		        s = Point(Constructedby.data(i))
		        if not s.modified then
		          M1 = Matrix(constructedby.data(i+1))
		          M1= M1.inv
		          s.Moveto M1*bpt
		          s.modified = true
		          s.updateshape
		        end if
		      next
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatefirstpoint(np as BasicPoint)
		  dim delta as BasicPoint
		  dim d as double
		  dim sh as shape
		  
		  
		  delta = np-bpt
		  d = delta.norme
		  if pointsur.count = 1 and (constructedby <> nil or ubound(constructedshapes) > 0) then
		    if d > 0.1 and dret = nil then
		      np = bpt+ (delta.normer)*0.2 
		    end if                   'On évite de faire des pas trop grands
		  end if
		  Moveto np  
		  if  forme =1  then
		    sh = pointsur.item(0)
		    if not sh isa arc then
		      puton sh
		    else
		      arc(sh).positionner(self)   //Voir remarque dans Figure.updatePtssur
		    end if
		  end if
		  modified = true
		  if parents(0).getsousfigure(fig).auto = 3 then
		    return
		  end if
		  updateshape
		  
		  //Si le point mobile possède un ou des duplicata, ceux-ci  sont modifiés dès le départ; 
		  //on initialise ainsi la modification de toutes les figures
		  // ... et ce n'est pas une bonne idée car le point mobile peut à ce moment être déplacé en un endroit 
		  // où il ne peut aller! exemple: sommet de l'angle droit d'un triangle rectangle
		  // mais cela entraîne d'autres problèmes (fusion de deux formes dupliquées)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateguides()
		  dim s, s1 as point
		  
		  // Inutile d'attribuer un guide à un point qui n'est pas dans un arbre de duplication (duplicateorcut ou hasduplicate) or fusion
		  
		  if (not duplicateorcut) and (not hasduplicate) and (not fused) then
		    return
		  end if
		  
		  //on remonte à la racine de l'arbre (oper = 3 ou 5 ou 9)
		  s = self
		  
		  while s.predecesseur <> nil and s.Predecesseur <> s
		    s = s.predecesseur
		  wend
		  
		  // s est la racine de l'arbre
		  // on redescend dans l'arbre à la recherche du premier point sur
		  
		  s1 = s.searchfollowingpointon
		  
		  // si on en trouve un, ce point sert de guide pour tous les points de l'arbre
		  
		  if s1 <> nil then
		    s.setguide(s1)
		  else
		    s.setguide(s)
		  end if
		  
		  // si aucun pointsur dans  l'arbre, le guide est la racine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateInter()
		  dim inter as intersec
		  
		  if forme = 2 then
		    's1 = pointsur.item(0)
		    's2 = pointsur.item(1)
		    inter = GetInter 'CurrentContent.TheIntersecs.Find(s1,s2)
		    if inter <> nil then
		      inter.update (self)      //Le point est éventuellement re-validé
		      if not invalid then
		        ValiderCondiEtConstruc
		      end if
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateMatrixDuplicatedshapes(M as Matrix)
		  dim i,j as integer
		  dim pt as shape
		  dim M1, M2 as Matrix
		  dim op as operation
		  
		  op = currentcontent.currentoperation
		  if( (not op isa Retourner) and  (not op isa selectanddragoperation) ) or (op isa duplicate) then   'op isa modifier or
		    return
		  end if
		  
		  if  (duplicateorcut) and not modified then
		    M1 = Matrix(constructedby.data(0))
		    M1 = M*M1
		    constructedby.data(0) = M1
		    modified = true
		  elseif fused and not modified then
		    if constructedby.shape = nil then
		      for i = 1 to 3 step 2
		        M1 = Matrix(constructedby.data(i))
		        M1 = M*M1
		        constructedby.data(i) = M1
		      next
		    else
		      M1 = Matrix(constructedby.data(0))
		      M1 = M*M1
		      constructedby.data(0) = M1
		    end if
		    modified = true
		  end if
		  
		  if  ubound(constructedshapes) > -1 then
		    M2 = M.inv
		    for j = 0 to ubound(constructedshapes)
		      pt = point(ConstructedShapes(j))
		      if pt.duplicateorcut and not pt.modified then
		        M1 = Matrix(pt.constructedby.data(0))
		        if selectoperation(op).figs.getposition(pt.fig) = -1 then
		          M1 = M1*M2
		        else
		          M1 = M*M1*M2
		        end if
		        pt.constructedby.data(0) = M1
		      elseif pt.fused then
		        if pt.constructedby.shape = nil then
		          for j = 0 to 2 step 2
		            if point(pt.constructedby.data(j)) = self then
		              M1 = Matrix(pt.constructedby.data(j+1))
		              if selectoperation(op).figs.getposition(pt.fig) = -1 then
		                M1 = M1*M2
		              else
		                M1 = M*M1*M2
		              end if
		              pt.constructedby.data(j+1) = M1
		            end if
		          next
		        else
		          M1 = Matrix(pt.constructedby.data(0))
		          if selectoperation(op).figs.getposition(pt.fig) = -1 then
		            M1 = M1*M2
		          else
		            M1 = M*M1*M2
		          end if
		          pt.constructedby.data(0) = M1
		        end if
		      end if
		      pt.modified = true
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatemobilitysucceeding()
		  dim s as point
		  dim i as integer
		  
		  for i = 0 to ubound(ConstructedShapes)
		    s = point(constructedshapes(i))
		    if s.duplicateorcut or s.fused then
		      s.liberte = liberte
		      s.updatemobilitysucceeding
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateShape()
		  dim sh  as shape
		  dim i as integer
		  dim ff as figure
		  dim t as Boolean
		  
		  if bpt = nil then
		    return
		  end if
		  
		  'if (invalid and ((conditionedby=nil)  or (not conditionedby.invalid)) )or deleted then   'l'invalidité éventuelle ne peut être due à un conditionnement
		  'return                                    'controler d'éventuels effets pervers (recalculer des points invalides et trouver 'nil')
		  'end if
		  
		  if  forme =1  then
		    sh = pointsur.item(0)
		    if not sh isa arc then
		      puton sh
		    elseif not modified then
		      Arc(sh).Positionner(self)  //Voir remarque dans Figure.updatePtssur
		    end if
		  end if
		  
		  
		  for i = 0 to ubound(parents)
		    parents(i).updatecoord
		    if parents(i) isa circle  or parents(i) isa DSect then
		      parents(i).coord.CreateExtreAndCtrlPoints(parents(i).ori)
		    end if
		  next
		  if ifmac <>nil and forme = 1 then
		    ifmac.location = location(0)
		  end if
		  modified = true   //ajouté le 24 février 2014 pour éviter des blocages de figure (macro PtFixHomo puis joindre le ptfix à un sommet du trap)
		  
		  'ff = parents(0).getsousfigure(fig)
		  'if ff.auto = 3 and first then
		  'fig.pointmobile = self
		  't = ff.subfigupdate
		  'end if
		  
		  if ubound(constructedshapes) > -1 or constructedby <> nil then
		    updateconstructedpoints
		  end if
		  
		  if ubound(MacConstructedshapes) > -1 then
		    updateMacConstructedShapes
		  end if
		  endmove
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateshape(M as Matrix)
		  dim s1, s2 as shape
		  
		  if pointsur.count = 2 then
		    s1 = pointsur.item(0)
		    s2 = pointsur.item(1)
		    
		    if s1.getsousfigure(s1.fig) = s2.getsousfigure(s2.fig) then
		      transform(M)
		      modified = true
		      updateconstructedpoints
		      updateMacConstructedShapes
		      endmove
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Valider()
		  
		  if validating or not invalid then
		    return
		  end if
		  if (conditionedby <> nil and conditionedby.invalid)   or (constructedby <> nil and (constructedby.shape <> nil) and constructedby.shape.invalid) then
		    return
		  end if
		  invalid = false
		  validating = true
		  ValiderCondiEtConstruc
		  validating = false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub valider(tovalid() as shape)
		  dim s as shape
		  
		  if ubound(tovalid)=-1 then
		    return
		  end if
		  
		  s = tovalid(0)
		  
		  tovalid.remove 0
		  if not (s.constructedby<>nil and tovalid.indexof(s.constructedby.shape)<> -1) then
		    s.valider
		  else
		    tovalid.append s
		  end if
		  valider(tovalid)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ValiderCondiEtConstruc()
		  dim i, j as integer
		  dim s, tovalid(-1) as shape
		  
		  if conditioned.count > 1 then
		    redim tovalid(-1)
		    redim tovalid(conditioned.count-1)
		    for i = 0 to conditioned.count-1
		      tovalid(i)=conditioned.item(i)
		    next
		    valider(tovalid())
		  elseif conditioned.count = 1 then
		    s = conditioned.item(0)
		    if (not s isa point) or ( point(s).pointsur.count < 2 )   then
		      s.valider
		    else
		      point(s).updateinter
		    end if
		  end if
		  
		  for i = 0 to UBound (parents)
		    if parents(i).invalid and not parents(i).validating and (parents(i).conditionedby=nil or not point(parents(i).conditionedby).invalid)  then
		      parents(i).Valider
		    end if
		  next
		  for i = 0  to Ubound(ConstructedShapes)
		    ConstructedShapes(i).Valider
		  next
		  
		  for i = 0 to tsfi.count-1
		    tsfi.item(i).ModifyImages
		    for j = 0 to tsfi.item(i).constructedshapes.count -1
		      tsfi.item(i).constructedshapes.item(j).valider
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutConstructionInfoInContainer(Doc as XMLDocument) As XMLElement
		  dim  Temp, EL as XMLElement
		  dim i as integer
		  dim M as Matrix
		  dim tsf as Transformation
		  
		  Temp = Doc.CreateElement("ConstructedBy")
		  if constructedby.shape <> nil then
		    Temp.setattribute("Id", str(ConstructedBy.shape.id))   //redondance par souci de compatibilité deux lignes a supprimer un jour
		  end if
		  Temp.Setattribute("Oper",str(ConstructedBy.oper))
		  
		  select case Constructedby.oper
		  case 3, 5
		    M = matrix(constructedby.data(0))
		    M.XMLPutAttribute(Temp)
		  case 4
		    Temp.SetAttribute("Id0",str(shape(ConstructedBy.data(0)).id))
		    Temp.SetAttribute("Id1",str(shape(ConstructedBy.data(1)).id))
		    Temp.SetAttribute("NDivP",str(ConstructedBy.data(2)))
		    Temp.SetAttribute("DivP",str(ConstructedBy.data(3)))
		    if ubound(constructedby.data) > 3 then
		      Temp.SetAttribute("Side",str(ConstructedBy.data(4)))
		    end if
		  case 6, 7
		    tsf = Transformation(ConstructedBy.data(0))
		    Temp.SetAttribute("SuppTsf", str(tsf.supp.id))
		    i = tsf.supp.GetIndexTsf(tsf)
		    Temp.SetAttribute("Nr", str(i))
		    Temp.SetAttribute("NumSide", str(tsf.index))
		  case 9
		    Temp.SetAttribute("IdParent", str(Parents(0).Id))
		    if constructedby.shape <> nil then
		      Temp.SetAttribute ("Constructedby", str(constructedby.shape.id))
		      Matrix(constructedby.data(0)).XMLPutAttribute(Temp)
		    else
		      Temp.SetAttribute ("ConstructedbyId1", str(shape(constructedby.data(0)).id))
		      Temp.SetAttribute ("ConstructedbyId2", str(shape(constructedby.data(2)).id))
		    end if
		    Temp.appendchild EL
		  case 10
		    Temp.setattribute(Dico.value("Data0"), str(ConstructedBy.data(0)))
		  end select
		  
		  Return Temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutCoordinContainer(Doc as XMLDocument) As XMLElement
		  'dim Temp as XMLElement
		  '
		  'Temp = Doc.CreateElement("Coord")
		  'Temp.SetAttribute("X", str(Bpt.x))
		  'Temp.SetAttribute("Y", str(Bpt.y))
		  return Bpt.XMLPutInContainer(Doc)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutIdINContainer(Doc as XMLDocument, EL as XMLElement) As XMLElement
		  //Utilisé uniquement dans le cadre des macros
		  dim Form, Temp as XMLElement
		  
		  if currentcontent.macrocreation  then
		    Form = XMLPutIdInContainer(Doc)
		    EL.appendchild Form
		    
		    if pointsur.count > 0 then
		      temp = pointsur.XMLPutIdInContainer(Doc)
		      select case pointsur.count
		      case 1
		        temp.setAttribute("NumSide0",str(numside(0)))
		        temp.setattribute("Location",str(location(0)))
		        if surseg then
		          temp.SetAttribute("Surseg","1")
		        end if
		      case 2
		        temp.setAttribute("NumSide0",str(numside(0)))
		        temp.setAttribute("NumSide1",str(numside(1)))
		      end select
		    end if
		    EL.AppendChild Temp
		    
		    return EL
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  dim Form, Temp as XMLElement
		  
		  Form = XMLPutIdInContainer(Doc)
		  
		  if not currentcontent.macrocreation then
		    if fig <> nil then
		      Form.SetAttribute("FigId",str(fig.idfig))
		    end if
		    Form.AppendChild Bpt.XMLPutInContainer(Doc)
		    Form.AppendChild Bordercolor.XMLPutInContainer(Doc, Dico.Value("ToolsColorBorder"))
		    Temp = Doc.CreateElement(Dico.Value("Thickness"))
		    Temp.SetAttribute("Value", str(borderwidth))
		    Form.AppendChild Temp
		    if Hidden then
		      Form.AppendChild(Doc.CreateElement(Dico.Value("Hidden")))
		    end if
		    if Invalid then
		      Form.AppendChild(Doc.CreateElement(Dico.Value("Invalid")))
		    end if
		    
		  end if
		  
		  if labs.count = 1 then
		    form.appendchild labs.item(0).toXML(Doc)
		  end if
		  
		  if pointsur.count > 0 then
		    Form.AppendChild  XMLPutPointSur(Doc)
		  end if
		  
		  if constructedby <> nil  and constructedby.oper <> 5 then 'and constructedby.oper <> 3
		    form.appendchild XMLPutConstructionInfoInContainer(Doc)
		  end if
		  
		  if Macconstructedby <> nil  then
		    form.appendchild XMLPutMacConstructionInfoInContainer(Doc)
		  end if
		  
		  Form.AppendChild XMLPutTsfInContainer(Doc)
		  
		  Return Form
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutPointSur(Doc as XMLDocument) As XMLElement
		  
		  dim Temp, Temp2 as XMLElement
		  dim i, n as integer
		  
		  Temp =  Doc.CreateElement("PointSur")
		  n = PointSur.Count-1
		  for i = 0 to n
		    Temp2 = Doc.CreateElement(Dico.Value("Form"))
		    Temp2.Setattribute("Id", str(shape(PointSur.objects(i)).Id))
		    Temp2.Setattribute("NrCote", str(numside(i)))
		    Temp2.SetAttribute("Location",str(location(i)))
		    Temp.AppendChild Temp2
		  next
		  if surseg then
		    temp.SetAttribute("Surseg","1")
		  end if
		  
		  return Temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadCarac(EL1 as XMLElement)
		  dim List as  XMLNodeList
		  dim EL2 as XMLElement
		  dim j, old as integer
		  dim loc, r as double
		  dim sh as shape
		  
		  List = EL1.XQL("PointSur")
		  if List.length > 0 then
		    EL2=XMLElement(List.Item(0))
		    if val(EL2.GetAttribute("Surseg")) =1 then
		      surseg = true
		    end if
		    for j = 0 to EL2.Childcount-1
		      old = Val(EL2.Child(j).GetAttribute("Id"))
		      sh = CurrentContent.theobjects.GetShape(old)
		      pointsur.addshape sh
		      loc = Val(El2.Child(j).GetAttribute("Location"))
		      location.append loc
		      r = Val(EL2.Child(j).GetAttribute("NrCote"))
		      if r = -1 then
		        numside.append sh.pointonside(bpt)
		      else
		        numside.append r
		      end if
		      sh.setpoint(self)
		    next
		    mobility
		  end if
		  forme = pointsur.count
		  if forme = 2 then
		    adjustinter(pointsur.item(0),pointsur.item(1))
		  end if
		End Sub
	#tag EndMethod


	#tag Note, Name = Licence
		
		Copyright © Mars 2010 CREM
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
		Bpt As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		conditioned As objectslist
	#tag EndProperty

	#tag Property, Flags = &h0
		dejaexporte As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drapmagn As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		DrapUpdCutShape As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		first As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Guide As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		location(-1) As double
	#tag EndProperty

	#tag Property, Flags = &h0
		notest As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Numside(-1) As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		OldNumside(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		parents(-1) As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		PointSur As Objectslist
	#tag EndProperty

	#tag Property, Flags = &h0
		rsk As OvalSkull
	#tag EndProperty

	#tag Property, Flags = &h0
		Surseg As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Trace(-1) As BasicPoint
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ArcAngle"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Attracting"
			Group="Behavior"
			InitialValue="True"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="auto"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Borderwidth"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsw"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="dejaexporte"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="deleted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapmagn"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapori"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DrapUpdCutShape"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fam"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="first"
			Group="Behavior"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="forme"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Highlighted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="id"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IDGroupe"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IndexConstructedPoint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Invalid"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsInConstruction"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="labupdated"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Liberte"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Modified"
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="narcs"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncpts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nonpointed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="notest"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="npts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ori"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="plan"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="selected"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="signaire"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="std"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Surseg"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tobereconstructed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TracePt"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tsp"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="unmodifiable"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Validating"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
