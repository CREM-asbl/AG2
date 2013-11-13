#tag Class
Protected Class Shape
Implements StringProvider
	#tag Method, Flags = &h0
		Function pInShape(p as Basicpoint) As boolean
		  
		  return false
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Shape(ol As ObjectsList, ncp as Integer, np as integer)
		  Shape(ol,ncp)
		  Npts = np
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub doSelect()
		  
		  selected = true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub doUnselect()
		  
		  dim i as integer
		  
		  
		  selected = false
		  
		  
		  for i = 0 to Ubound(Childs)
		    childs(i).DoUnSelect
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectShape(p as BasicPoint) As Shape
		  dim i as Integer
		  dim S as Shape
		  
		  
		  for i=0 to Ubound(Childs)
		    if not Childs(i).Hidden or wnd.DrapShowALL  then
		      S=Childs(i).SelectShape(p)
		      if S<>nil then
		        return S
		      end if
		    end if
		  next
		  
		  for i = 0 to ubound(constructedshapes)
		    if  constructedshapes(i).centerordivpoint and (not Constructedshapes(i).hidden or wnd.Drapshowall) then
		      s = constructedshapes(i).selectshape(p)
		      if S<>nil then
		        return S
		      end if
		    end if
		  next
		  
		  
		  if pInShape(p) and (not hidden or wnd.DrapShowALL)  then
		    return self
		  else
		    return nil
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBoundingRadius() As Double
		  dim q as basicpoint
		  dim i as Integer
		  dim Br as double
		  
		  q = getgravitycenter
		  Br=0
		  for i=0 to Npts-1
		    Br = max(Br,Points(i).bpt.Distance(q))
		  next
		  
		  return Br
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Magnetism2(s as Shape, Byref d as basicpoint, Byref AttractedShape as Shape, Byref AttractingShape as Shape) As integer
		  dim s1,s2 as shape
		  dim td as BasicPoint
		  dim i as Integer
		  dim StrongestMagnetism,CurrentMagnetism as Integer
		  
		  if not PossibleAttractionWith(s)  or self = s then
		    return 0
		  end if
		  
		  StrongestMagnetism=0
		  
		  for i=0 to Ubound(Points)
		    CurrentMagnetism=Points(i).Magnetism2(s,td,s2)
		    if CurrentMagnetism>StrongestMagnetism then
		      StrongestMagnetism=CurrentMagnetism
		      d=td
		      attractedShape=Points(i)
		      attractingShape=s2
		    end if
		  next
		  
		  if StrongestMagnetism>0 then
		    return StrongestMagnetism
		  end if
		  
		  
		  'for i=0 to Ubound(s.Childs)
		  'CurrentMagnetism=Magnetism2(s.Childs(i),td,s1,s2)
		  'if CurrentMagnetism>StrongestMagnetism then
		  'StrongestMagnetism=CurrentMagnetism
		  'd=td
		  'attractedShape=s1
		  'attractingShape=s2
		  'end if
		  'next
		  '
		  '
		  'if StrongestMagnetism>0 then
		  'return StrongestMagnetism
		  'end if
		  return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetChild(s as Shape)
		  dim i as Integer
		  
		  for i=0 to Ubound(Childs)
		    if Childs(i)=s then
		      return
		    end if
		  next
		  
		  Childs.append Point(s)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveChild(s as shape)
		  dim p as point
		  
		  p = point(s)
		  
		  if childs.indexof(p) <> -1  then
		    Childs.remove childs.indexof(p)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitConstruction()
		  dim i as integer
		  dim p as BasicPoint
		  
		  if fam > 0 and ubound(points) = -1 then
		    p = new BasicPoint(0,0)
		    points.append new point(objects,p)
		    setpoint(points(0))
		  end if
		  
		  if npts>1 then
		    for i = 1 to Npts-1
		      Points.append new point(objects, Points(0).bpt)
		      SetPoint(Points(i))
		      points(i).isinconstruction = true
		    next
		  end if
		  
		  updatecoord
		  isinconstruction = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as BasicPoint, n as integer)
		  dim i,j as integer
		  dim cs as curveshape
		  
		  if n <= ncpts-1 then
		    for i = n to npts-1
		      Points(i).MoveTo(p)
		    next
		    
		    if self isa polyqcq then
		      if n <= npts then
		        cs = figskull(sk).getcote(n)
		        cs.border = 100
		      end if
		    end if
		    'if n = 0 then
		    'sk.update(wnd.mycanvas1.transform(p))
		    'else
		    'for j = n to npts-1
		    'Updateskull(j,wnd.mycanvas1.dtransform(p-Points(0).bpt))
		    'next
		    'end if
		  end if
		  
		  
		  if n = ncpts-1  then
		    constructshape
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveToBack()
		  Currentcontent.MoveBack id
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SameSegment(P1 as point, P2 as Point) As Boolean
		  
		  dim i,j as integer
		  
		  for i=0 to Ubound(P1.parents)
		    for j=0 to Ubound(P2.parents)
		      if P1.parents(i)=P2.parents(j) then
		        if P1.Parents(i) isa Droite and droite(P1.Parents(i)).nextre = 2  then
		          return true
		        elseif  P1.Parents(i) isa polygon then
		          return Polygon(P1.Parents(i)).IsSide(P1,P2)
		        end if
		      end if
		    next
		  next
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetId(i as Integer)
		  self.id=i
		  objects.CheckId(i)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetId() As Integer
		  return Id
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Hide()
		  
		  
		  Hidden = true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Show()
		  
		  dim i as integer
		  
		  Hidden = false
		  'for i = 0 to Ubound(childs)
		  'childs(i).Show
		  'next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HighLight()
		  dim i as integer
		  dim s as shape
		  dim op as Operation
		  
		  
		  Highlighted = true
		  
		  if not CurrentContent.currentoperation isa delete Then
		    if not self isa point then
		      for i = 0 to Ubound(childs)
		        childs(i).Highlight
		      next
		    end if
		  end if
		  
		  op = CurrentContent.currentoperation
		  if IdGroupe <> -1 and ((not op isa Modifier  and  op isa selectanddragoperation) or op isa retourner or op isa appliquertsf) then
		    for i = 0 to objects.groupes(idgroupe).count -1
		      objects.groupes(idgroupe).element(i).highlighted = true
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UnHighLight()
		  dim i as integer
		  
		  Highlighted = false
		  
		  if not self isa point then
		    for i = 0 to Ubound(childs)
		      childs(i).UnHighlight
		    next
		  end if
		  
		  for i = 0 to ubound(constructedshapes)
		    if constructedshapes(i).highlighted then
		      constructedshapes(i).unhighlight
		    end if
		  next
		  
		  if IdGroupe <> -1  then
		    for i = 0 to objects.groupes(idgroupe).count -1
		      objects.groupes(idgroupe).element(i).highlighted = false
		    next
		  end if
		  
		Exception err
		  dim d As Debug
		  d = new Debug
		  d.setMethod("Shape","UnHighLight")
		  d.setVariable("i",i)
		  d.setVariable("Ubound(childs)",Ubound(childs))
		  d.setVariable("Ubound(constructedshapes)",Ubound(constructedshapes))
		  d.setVariable("IdGroupe",IDGroupe)
		  if IdGroupe <> -1  then
		    d.setVariable("objects.groupes(idgroupe).count",objects.groupes(idgroupe).count)
		  end if
		  err.message = err.message+d.getString
		  
		  Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveToFront()
		  Currentcontent.Movefront id
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPositionInObjectsList() As integer
		  return Objects.getPosition(self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveConstructedShape(s as shape)
		  
		  if Constructedshapes.IndexOf(s) <> -1 then
		    ConstructedShapes.remove Constructedshapes.IndexOf(s)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetObjects() As ObjectsList
		  return Objects
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddConstructedShape(s as Shape)
		  dim i as Integer
		  
		  for i=0 to UBound(ConstructedShapes)
		    if ConstructedShapes(i) = s then
		      return
		    end if
		  next
		  
		  ConstructedShapes.Append s
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsStandAlone() As boolean
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsConstructing(s as Shape) As Boolean
		  
		  dim i as Integer
		  
		  for i=0 to Ubound(ConstructedShapes)
		    if ConstructedShapes(i)=s then
		      return true
		    end if
		  next
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BelongsToBorder(P as Point) As Boolean
		  //return false
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FixeCouleurFond(c as couleur, f as integer)
		  Fillcolor = c
		  Fill = f
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFillColor() As Couleur
		  return FillColor
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBorderColor() As Couleur
		  return BorderColor
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GridMagnetism(Byref d as BasicPoint, Byref AttractedPoint as Point) As integer
		  
		  dim td As BasicPoint
		  dim Gm as Integer
		  dim i as integer
		  dim currentmagnetism,StrongestMagnetism as integer
		  dim CurAttractedPoint as Point
		  
		  for i=0 to Ubound(Childs)
		    Currentmagnetism=Childs(i).GridMagnetism(td,CurAttractedPoint)
		    if Currentmagnetism>StrongestMagnetism then
		      StrongestMagnetism=Currentmagnetism
		      d=td
		      AttractedPoint=CurAttractedPoint
		    end if
		  next
		  return StrongestMagnetism
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGravitycenter() As basicpoint
		  dim i as integer
		  dim g as BasicPoint
		  
		  g = new BasicPoint(0,0)
		  
		  for i = 0 to npts-1
		    g = g + points(i).bpt
		  next
		  
		  g = g/npts
		  return g
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PaintAll(g as Graphics)
		  dim i,j as Integer
		  
		  if not invalid and not deleted  then
		    Paint(g)
		    for i = 0 to tsfi.count-1
		      if not hidden then
		        tsfi.element(i).paint(g)
		      end if
		    next
		    for i = 0 to ubound(constructedshapes)
		      if constructedshapes(i).centerordivpoint then
		        point(constructedshapes(i)).paintall(g)
		      end if
		    next
		    if not hidden then
		      for i = 0 to labs.count-1
		        labs.element(i).paint(g)
		      next
		    end if
		  end if
		  
		  if tracept and (modified or CurrentContent.currentoperation isa appliquertsf)  then
		    paint(wnd.Mycanvas1.offscreenpicture.graphics)
		    currentcontent.theobjects.tracept = true
		  end if
		  
		  if not nonpointed then
		    for i=0 to Ubound(childs)
		      childs(i).Paint(g)
		      for j = 0 to childs(i).tsfi.count-1
		        childs(i).tsfi.element(j).paint(g)
		      next
		    next
		  else
		    for i=npts to Ubound(childs)
		      childs(i).Paint(g)
		      for j = 0 to childs(i).tsfi.count-1
		        childs(i).tsfi.element(j).paint(g)
		      next
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGC() As Point
		  dim i as integer
		  dim GC as point
		  
		  if self isa Point then
		    return Point(self)
		  elseif self isa circle then
		    return Points(0)
		  else
		    for i = 0 to Ubound(constructedshapes)
		      if constructedshapes(i).constructedby.oper = 0 then
		        return Point(constructedshapes(i))
		      end if
		    next
		    GC = new Point(objects, getgravitycenter)
		    GC.setconstructedby(self,0)
		    GC.endconstruction
		    return GC
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FixeCouleurtrait(c as couleur, b as integer)
		  dim i as integer
		  
		  Bordercolor = c
		  Border = b
		  
		  if self isa polygon then
		    for i = 0 to npts-1
		      colcotes(i) = c
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Shape(ol as objectslist, ncp as integer)
		  if currentcontent.currentoperation isa shapeconstruction then
		    fam = shapeconstruction(currentcontent.currentoperation).famille
		    forme = shapeconstruction(currentcontent.currentoperation).forme
		  end if
		  if id=0 then
		    id = ol.newId
		  end if
		  objects = ol
		  labs = new LabList
		  tsfi = new transfoslist
		  Autos
		  Ncpts = ncp
		  IdGroupe = -1
		  Fixecouleurtrait(Config.bordercolor,Config.Border)
		  FixeCouleurFond(Config.Fillcolor,0)
		  Borderwidth = Config.Thickness
		  std = false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SubstitutePoint(P as Point, Q as Point)
		  dim k, index as integer
		  
		  
		  // self est la forme à laquelle Q appartient. On y remplace Q par P
		  
		  if P <> Q then
		    index =GetIndexpoint(Q)
		    if index <> -1 then
		      Points(index)= P
		      Childs(index)= P
		      P.setParent(self)
		      Q.RemoveParent self
		    else
		      for k = 0 to ubound(constructedshapes)
		        if constructedshapes(k).constructedby.oper = 4 then
		          index = ConstructedShapes(k).Constructedby.data.IndexOf(q)
		          if index = 0 or index = 1 then
		            constructedshapes(k).Constructedby.data(index) = p
		          end if
		        end if
		      next
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetPoint(P as Point)
		  P.setParent(self)
		  SetChild P
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemovePoint(Q as Point)
		  RemoveChild Q
		  Q.removeParent self
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpDateSkull(p as BasicPoint)
		  sk.ref = p
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndConstruction()
		  dim i as integer
		  
		  
		  isinconstruction = false
		  updatecoord
		  
		  for i = 0 to npts-1
		    points(i).isinconstruction = false
		  next
		  
		  if self isa arc or self isa secteur then
		    drapori = true
		  end if
		  
		  if currentcontent.PolygFleches and not self isa Lacet then
		    Ti = new Tip
		  end if
		  
		  
		  if not self isa cube and not currentcontent.currentoperation isa duplicate and not currentcontent.currentoperation isa appliquertsf then
		    nonpointed = not currentcontent.PolygPointes
		  elseif constructedby <> nil and constructedby.shape.nonpointed = true then
		    nonpointed = true
		  end if
		  
		  Currentcontent.addShape self
		  if CurrentContent.ForHisto then
		    addtofigure
		  end if
		  
		  signaire = sign(aire)
		  computeori
		  
		  dounselect
		  currentcontent.optimize
		  currentcontent.RemettreTsfAvantPlan
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Swap()
		  dim i, j as integer
		  dim t as boolean
		  
		  Hidden = not Hidden
		  
		  for i = 0 to ubound(childs)
		    t = true
		    for j = 0 to ubound(childs(i).parents)
		      if childs(i).pointsur.getposition(childs(i).parents(j)) = -1 then
		        t = t and childs(i).parents(j).hidden
		      end if
		    next
		    childs(i).hidden = t
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLColorElement(Doc as XMLDocument, namecol as string, col as color) As XMLElement
		  dim coul as couleur = new couleur(col)
		  return coul.XMLPutIncontainer(Doc,Namecol)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutIdINContainer(Doc as XMLDocument) As XMLElement
		  dim Form as XMLElement
		  dim n as integer
		  
		  Form = Doc.CreateElement(Dico.value("Form"))
		  Form.SetAttribute("Id",str(id))
		  
		  Form.SetAttribute("Type",GetType)
		  Form.SetAttribute(Dico.Value("NrFam"), str(fam))
		  Form.SetAttribute(Dico.Value("NrForm"),str(forme))
		  if fam <> 0 then
		    Form.SetAttribute(Dico.value("Npts"),Str(Npts))
		    Form.SetAttribute(Dico.value("Ncpts"),Str(Ncpts))
		    'end if
		    'if not self isa point then
		    Form.SetAttribute("Ori", str(ori))
		  end if
		  if nonpointed then
		    Form.SetAttribute("NonPointed","1")
		  end if
		  if conditionedby <> nil then
		    Form.SetAttribute("Condby", str(conditionedby.id))
		  end if
		  if Ti <> Nil then
		    Form.setattribute("TiP","1")
		  end if
		  if not app.macrocreation then
		    Form.SetAttribute("Auto",str(auto))
		    Form.SetAttribute(Dico.Value("IdGroupe"), str(IdGroupe))
		    plan = CurrentContent.plans.IndexOf(id)
		    Form.SetAttribute("Plan",str(plan))
		    if std then
		      Form.SetAttribute("Standard", str(1))
		    else
		      Form.setattribute("Standard", str(0))
		    end if
		  end if
		  
		  return Form
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpDateSkull()
		  dim i as integer
		  
		  
		  for i=0 to npts-1
		    if i=0 then
		      if self isa circle or self isa Lacet then
		        nsk.update(wnd.myCanvas1.transform(Points(0).bpt))
		      else
		        sk.update(wnd.myCanvas1.transform(Points(0).bpt))
		      end if
		    else
		      UpdateSkull(i,wnd.myCanvas1.dtransform(Points(i).bpt-Points(0).bpt))
		    end
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetIndexPoint(Pt as Point) As integer
		  
		  if not self isa point then
		    return points.indexof(pt)
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub shape(ol as objectslist)
		  id = ol.newId
		  IdGroupe = -1
		  objects = ol
		  labs = new lablist
		  tsfi = new transfoslist
		  Autos
		  Fixecouleurtrait(Config.bordercolor,Config.Border)
		  FixeCouleurFond(Config.Fillcolor,Config.Fill)
		  Borderwidth = 1
		  Border = 100
		  Fill = 0
		  Points.append new Point(ol, new Basicpoint(0,0))
		  setpoint(Points(0))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(ol as objectslist, p as basicPoint) As shape
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(ol as objectslist, p as BasicPoint, s as shape) As shape
		  // Paste est utilisé pour les Copier-coller, duplicate, image par translation en vue de créer des figures-images. Celles-ci devront être insérées dans la liste des objets
		  //du currentcontent. Cela se fait lors du passage par endconstruction, qui ne doit être réalisé qu'une fois !
		  // Les méthodes CreerCopies de AppliquerTSF, SetCopies de Dupliquer et DoOperation de Coller s'en chargent (essayer de les unifier).  Donc à ne pas insérer dans les routines de création des copies.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Magnetisme(Byref d as basicpoint, Byref AttractedShape as Shape, Byref attractingShape as Shape, ByRef nextattractingshape as Shape) As integer
		  //Méthode utilisée uniquement par Figure.Magnetisme(BasicPoint,shape,shape,shape)
		  
		  dim CurrentMagnetism as Integer
		  dim StrongestMagnetism as Integer
		  dim NextStrongestMagnetism As Integer
		  dim obj,  s1,s2  as Shape
		  dim t as BasicPoint
		  dim i as integer
		  
		  StrongestMagnetism=0
		  NextStrongestMagnetism = 0
		  
		  for i=1 to objects.count-1
		    obj = objects.element(i)
		    if self <> obj  and  (obj.idgroupe <> idgroupe or idgroupe = -1) and not obj.hidden then
		      CurrentMagnetism = Magnetism2(obj,t,s1,s2)
		      if s2 <> nil and s2.attracting and not s2.invalid and not s2.deleted then
		        if CurrentMagnetism >= StrongestMagnetism then
		          NextStrongestMagnetism = StrongestMagnetism
		          d=t
		          Nextattractingshape = attractingshape
		          AttractedShape=s1
		          AttractingShape=s2
		          StrongestMagnetism=CurrentMagnetism
		        end if
		      end if
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
		Function PossibleAttractionWith(other as Shape) As Boolean
		  
		  dim gc1,gc2,bp as basicpoint
		  dim dist,b1,b2 as double
		  dim magdist as double
		  magdist = wnd.mycanvas1.MagneticDist
		  
		  
		  if self isa point then
		    bp = Point(self).bpt
		  end if
		  
		  if self isa point and other isa droite then
		    return Droite(other).PInshape(bp)
		  elseif  self isa point and other isa bande then
		    return not (Bande(other).PointOnSide(bp) = -1)
		  elseif  self isa point and other isa secteur then
		    return not (Secteur(other).PointOnSide(bp) = -1)
		  elseif other <> nil then
		    gc1 = getGravityCenter
		    gc2 = other.getgravityCenter
		    if gc1 <> nil and gc2 <> nil then
		      dist=gc1.Distance(gc2)
		      b1=getBoundingRadius()
		      b2=other.getBoundingRadius()
		      if dist < b1+b2+magdist then
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
		Function IsSame(s as Shape) As Boolean
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLReadColorelement(S as string, EL as XMLElement, Byref c as couleur, Byref Temp as XMLElement) As Boolean
		  dim List as XmlNodeList
		  
		  List = EL.XQL(Dico.Value(S))
		  if List.length > 0 then
		    temp  = XMLElement(List.Item(0))
		    c = new couleur(temp)
		    return true
		  else
		    return false
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SelectNeighboor()
		  dim i As  integer
		  
		  if self isa point then
		    for i = 0 to ubound(point(self).parents)
		      if point(self).parents(i).idGroupe <> -1 then
		        point(self).parents(i).selectgroup
		      end if
		    next
		  elseif IDGroupe <> -1 then
		    selectgroup
		  end if
		  
		  
		  if not CurrentContent.currentoperation  isa duplicate and not CurrentContent.currentoperation isa copier then
		    for i = 0 to objects.selection.count-1
		      Objects.selectfigure(objects.selection.element(i).fig)
		      if objects.selection.element(i).centerordivpoint and not  objects.selection.element(i).ConstructedBy.Shape.selected then
		        Objects.selectobject(objects.selection.element(i).ConstructedBy.Shape)
		        ConstructedBy.Shape.SelectNeighboor
		      end if
		    next
		    
		    
		    for i = 0 to UBound(ConstructedShapes)
		      if  ConstructedShapes(i).Centerordivpoint  and not constructedshapes(i).selected then
		        Objects.selectobject(ConstructedShapes(i))
		        ConstructedShapes(i).SelectNeighboor
		      end if
		    next
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadPoints(Temp as XMLElement)
		  dim i as integer
		  dim s as point
		  
		  
		  for i = 0 to npts-1
		    s = XMLreadpoint(XMLElement(Temp.Child(i)))
		    setpoint(s)
		    Points.append s
		  next
		  updatecoord
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UnselectNeighBoor()
		  dim i,j As  integer
		  
		  for i = 0 to ubound(Childs)
		    for j= 0 to UBound(Childs(i).parents)
		      if childs(i).parents(j).selected then
		        Objects.unselectobject(childs(i).parents(j))
		        childs(i).parents(j).UnSelectNeighboor
		      end if
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetConstructedBy(S as shape, Op as integer)
		  if constructedby <> nil and constructedby.shape <> nil then
		    constructedby.shape.RemoveConstructedShape self
		  end if
		  Constructedby = new ConstructionInfo(S, Op)
		  if op <> 9 or s isa point then
		    S.AddConstructedShape self
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutChildsInContainer(Doc as XMLDocument) As XMLElement
		  dim Temp as XMLElement
		  dim i as integer
		  
		  Temp = Doc.CreateElement("Childs")
		  for i = 0 to  Ubound(childs)
		    Temp.AppendChild Childs(i).XMLPutInContainer(Doc)
		  next
		  return Temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateSkull(n as integer, p as Basicpoint)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As integer
		  return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paintside(g as graphics, cot as integer, ep as double, col as couleur)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateUserCoord(M as Matrix)
		  dim i As  Integer
		  
		  for i = 0 to Ubound(Childs)
		    Childs(i).Transform(M)
		  next
		  if self isa droite  then
		    droite(self).computeextre
		  elseif self isa bande  then
		    bande(self).computeextre
		  elseif self isa secteur then
		    secteur(self).computeextre
		  end if
		  Updateskull
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateMatrixDuplicatedshapes(M as Matrix)
		  
		  dim j, k as integer
		  dim s as shape
		  dim M1, M2 as matrix
		  dim op as operation
		  
		  op = currentcontent.currentoperation
		  if  duplicateorcut  then
		    M1 = Matrix(constructedby.data(0))
		    M1 = M*M1
		    constructedby.data(0) = M1
		  elseif fused then
		    for j = 1 to 3 step 2
		      M1 = Matrix(constructedby.data(j))
		      M1 = M*M1
		      constructedby.data(j) = M1
		    next
		  end if
		  
		  if  ubound(constructedshapes) > -1 then
		    M2 = M.inv
		    for j = 0 to ubound(constructedshapes)
		      s = ConstructedShapes(j)
		      if s.duplicateorcut  then
		        M1 = Matrix(s.constructedby.data(0))
		        if selectoperation(op).figs.getposition(s.fig) = -1 then
		          M1 = M1*M2
		        else
		          M1 = M*M1*M2
		        end if
		        s.constructedby.data(0) = M1
		      elseif s.fused then
		        for j = 0 to 2 step 2
		          if shape(s.constructedby.data(j))= self then
		            M1 = Matrix(s.constructedby.data(j+1))
		            if selectoperation(op).figs.getposition(s.fig) = -1 then
		              M1 = M1*M2
		            else
		              M1 = M*M1*M2
		            end if
		            s.constructedby.data(j+1) = M1
		          end if
		        next
		      end if
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Shape(ol as objectslist, s as shape)
		  dim i, n as integer
		  
		  Shape(ol)
		  Npts=s.Npts
		  fam =s.fam
		  forme = s.forme
		  auto = s.auto
		  labs = new Lablist
		  if s isa cube then
		    n = 11
		  elseif s isa polygon then
		    n = npts-1
		  else
		    n = -1
		  end if
		  redim colcotes(n)
		  for i = 0 to n
		    colcotes(i) = s.colcotes(i)
		  next
		  
		  border = s.border
		  borderwidth = s.borderwidth
		  bordercolor = s.bordercolor
		  Fixecouleurfond s.Getfillcolor, s.Fill
		  std = s.std
		  ori = s.ori
		  hidden = s.hidden
		  InitConstruction
		  for i = 0 to npts-1
		    points(i).borderwidth = s.points(i).borderwidth
		    Points(i).moveto (s.Points(i).bpt)
		    points(i).hidden = s.points(i).hidden
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetIndexPointOn(Pt as Point) As integer
		  dim i as integer
		  
		  if not self isa point then
		    for i = npts to UBound(Childs)
		      if Childs(i) = Pt then
		        return i
		      end if
		    next
		  end if
		  
		  return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutTsfInContainer(Doc as XMLDocument) As XMLElement
		  dim i as integer
		  dim Form as XMLElement
		  
		  if tsfi.count = 0 then
		    return nil
		  end if
		  
		  Form = Doc.CreateElement(Dico.value("TransfosMenu"))
		  
		  for i = 0 to tsfi.count-1
		    Form.appendchild tsfi.element(i).XMLPutInContainer(Doc)
		  next
		  
		  return Form
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadTsf(Temp as XMLElement)
		  dim i as integer                                'Ici on crée les transformations, on connait leurs supports mais pas encore leurs images.
		  dim List as XmlNodeList                 'Les images seront créées dans XMLReadConstructionInfo
		  dim EL as XMLElement
		  
		  tsfi.RemoveAll
		  
		  List = Temp.XQL(Dico.value("TransfosMenu"))
		  if list.length > 0 then
		    EL = XMLElement(List.Item(0))
		    for i = 0 to EL.Childcount-1
		      tsfi.addtsf new Transformation(self, XMLElement(EL.child(i)))
		    next
		  end if
		  
		  List = Temp.XQL("Childs")
		  if list.length > 0 then
		    EL =  XMLElement(List.Item(0))
		    for i = 0 to EL.ChildCount-1
		      childs(i).XMLReadTsf(XMLElement(EL.child(i)))
		    next
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateShape()
		  dim i, k as integer   // Utilisé pour lesmodifications
		  dim s1, s2 As shape
		  dim inter as intersec
		  dim p as point
		  dim f1, f2 as figure
		  dim bp as BasicPoint
		  dim M as Matrix
		  dim a as double
		  
		  updatecoord
		  computeori
		  a = aire
		  if a = -10000 then
		    return
		  end if
		  if signaire*sign(a) <0  and Ti <> nil and (fillcolor.equal(poscolor) or fillcolor.equal(negcolor))  then
		    signaire = sign(a)
		    if signaire > 0 then
		      fillcolor = poscolor
		    else
		      fillcolor = negcolor
		    end if
		  end if
		  
		  if ubound(childs) >= npts then
		    for i = npts to ubound(childs)
		      p = childs(i)
		      if p.pointsur.count = 2 then
		        s1 = p.pointsur.element(0)
		        s2 = p.pointsur.element(1)
		        f1 = s1.getsousfigure(s1.fig)
		        f2 = s2.getsousfigure(s2.fig)
		        if f1 <> f2 or f1.auto = 4 or f1.auto = 5 then  'polyqcq ou trap
		          inter = CurrentContent.TheIntersecs.find(s1,s2)
		          inter.update
		        end if
		        p.modified = true
		        p.updateshape
		      end if
		    next
		  end if
		  
		  if self isa Lacet and constructedby <> nil and constructedby.oper = 5 then
		    s1 = constructedby.shape
		    M = Matrix(ConstructedBy.Data(0))
		    for i = 0 to npts-1
		      if Lacet(self).curved(i) = 1 then
		        if s1 isa circle then
		          Lacet(self).centre(i) = M*s1.points(0).bpt
		        else
		          p = point(points(i).constructedby.shape)
		          k = s1.getindexpoint(p)
		          if k = -1 then
		            k = Lacet(s1).PointOnCurvedSide(p.bpt)
		          end if
		          Lacet(self).centre(i) = M*Lacet(s1).GetCentre(k)
		        end if
		      end if
		    next
		  end if
		  
		  CreateExtreAndCtrlPoints
		  
		  modified = true  '?
		  endmove
		  updateMacConstructedShapes
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutConstructionInfoInContainer(Doc as XMLDocument) As XMLElement
		  dim  Temp, Form, EL as XMLElement
		  dim i as integer
		  dim M as Matrix
		  dim tsf as Transformation
		  dim n as integer
		  dim s as shape
		  
		  // Exists routine speciale pour les points
		  
		  Temp = Doc.CreateElement("ConstructedBy")
		  if constructedby.oper <> 9 then
		    Temp.setattribute("Id", str(ConstructedBy.shape.id))
		  end if
		  Temp.Setattribute("Oper",str(ConstructedBy.oper))
		  if not app.macrocreation and constructedby.oper <> 9 then
		    Temp.appendchild constructedby.shape.XMLPutIdInContainer(Doc)  //redondance par souci de compatibilité
		  end if
		  // Id ou pas Id ? sans Id, peut devenir atroce
		  select case Constructedby.oper
		  case 1,2
		    Temp.SetAttribute("Index", str(constructedby.data(0)))
		  case 3
		    M = matrix(constructedby.data(0))
		    M.XMLPutAttribute(Temp)
		  case 5
		    Form = Doc.CreateElement("CutPoints")
		    Form.setAttribute("Ncpts",str(ncpts))
		    for i = 0 to npts-1
		      if Points(i).constructedby <> nil then
		        EL= Points(i).XMLPutIdIncontainer(Doc)
		        EL.SetAttribute ("Constructedby", str(Points(i).constructedby.shape.id))
		        Form.appendchild EL
		      end if
		    next
		    Temp.appendchild(Form)
		    M = matrix(constructedby.data(0))
		    M.XMLPutAttribute(Temp)
		  case 6, 7
		    tsf = Transformation(ConstructedBy.data(0))
		    Temp.SetAttribute("SuppTsf", str(tsf.supp.id))
		    i = tsf.supp.GetIndexTsf(tsf)
		    Temp.SetAttribute("Nr", str(i))
		  case 8
		    if ubound(constructedby.data)= 0 then
		      Temp.SetAttribute("Index", str(constructedby.data(0)))
		    end if
		  case 9
		    for i = 0 to 2 step 2
		      Form = Shape(constructedby.data(i)).XMLPutIdInContainer(Doc)
		      Matrix(constructedby.data(i+1)).XMLPutAttribute(Form)
		      Temp.appendchild Form
		    next
		  case 10
		    Temp.setattribute(Dico.value("Data0"), str(ConstructedBy.data(0)))
		  end select
		  
		  Return Temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadPtsSur(Temp as XMLElement)
		  dim i , IdPoint3 as integer
		  dim EL,  EL1 as XmlElement
		  dim List As XMLNodelist
		  dim pt, pt3 as point
		  
		  List = Temp.XQL("Childs")
		  if List.Length  > 0 then
		    EL = XMLElement(List.Item(0))
		    for i = npts to EL.Childcount-1
		      EL1 =  XMLElement(EL.Child(i))
		      pt = XMLReadPoint(EL1)  //pt est un point
		      if pt.pointsur.count = 0 then //si on a déjà lu les caractéristiques de ce pointsur, on saute
		        pt.XMLReadCarac(EL1)
		      end if
		    next
		  end if
		  
		  'if self isa supphom then
		  'IdPoint3 = val(EL.GetAttribute("IdPoint3"))
		  'if IdPoint3 <> 0 then
		  'pt3 = Point(currentcontent.theobjects.getshape(IdPoint3))
		  'if pt3.pointsur.count<> 1 then
		  'return
		  'end if
		  'if pt3.pointsur.element(0) = self then
		  'supphom(self).DRAP = false
		  'supphom(self).Bip = nil
		  'else
		  'supphom(self).DRAP = true
		  'supphom(self).Bip = BiPoint(pt3.pointsur.element(0))
		  'end if
		  'supphom(self).Point3 = pt3
		  'end if
		  'end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Valider()
		  dim i, j as integer
		  dim t, t2 as Boolean
		  dim inter as intersec
		  dim s1, s2 as shape
		  
		  
		  if  (conditionedby<>nil and conditionedby.invalid)  or (constructedby <> nil and (constructedby.shape.invalid or (constructedby.oper = 6 and (transformation(constructedby.data(0)).supp.invalid)) )) then
		    return
		  end if
		  
		  t = true
		  t2 = true
		  for i = 0 to npts-1
		    if  points(i).pointsur.count = 2 then
		      points(i).updateinter
		    elseif points(i).id > id then
		      points(i).valider
		    end if
		    t = t and not(points(i).invalid) and not (points(i).deleted)
		  next
		  for i = 0 to ncpts-1
		    t2 = t2 and points(i).modified
		  next
		  if not t then
		    return
		  end if
		  
		  invalid = false
		  
		  for i = npts to ubound(childs)
		    if childs(i).invalid then
		      if childs(i).pointsur.count < 2 then
		        childs(i).valider
		      else
		        childs(i).updateinter
		      end if
		    end if
		  next
		  
		  CurrentContent.Theobjects.validatefrom(self)
		  
		  for j = 0 to ubound(ConstructedShapes)
		    ConstructedShapes(j).valider
		  next
		  
		  for i = 0 to tsfi.count-1
		    tsfi.element(i).ModifyImages
		    for j = 0 to tsfi.element(i).constructedshapes.count -1
		      tsfi.element(i).constructedshapes.element(j).valider
		    next
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AllPtValid() As boolean
		  dim  i As integer
		  
		  for i=0 to Ubound(Points)
		    if  Points(i).invalid then
		      return false
		    end if
		  next
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetIndex(Pt as Point) As integer
		  dim n as integer
		  
		  n = GetIndexPoint(Pt)
		  if n = -1 then
		    n = GetIndexPointOn(Pt)
		  end if
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetIndexTsf(tsf as transformation) As integer
		  dim i as integer
		  
		  for i = 0 to tsfi.count-1
		    if tsfi.element(i) = tsf then
		      return i
		    end if
		  next
		  return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertPoint(index as integer, P as Point)
		  Points.Insert(index,P)
		  Childs.Insert(index,P)
		  P.setParent(self)
		  Sk.InsertPoint(P.bpt,index)
		  npts = npts+1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemovePoint(index as integer)
		  dim s as shape
		  dim i as integer
		  
		  RemovePoint(Points(index))
		  Points.Remove(index)
		  sk.RemovePoint
		  npts = npts-1
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddToFigure()
		  dim List0 as figslist
		  dim i as integer
		  
		  if fig <> nil then
		    return
		  end if
		  
		  // Création de la liste (List0) des figures comprenant un sommet ou un point sur de la forme (self)
		  
		  List0 = Listerfigsneighbour
		  'for i = List0.count -1 downto 0
		  'if List0.element(i).isapoint <> nil then
		  'CurrentContent.TheFigs.Removefigure List0.element(i)
		  'end if
		  'next
		  List0.addfigure new Figure(self)
		  if List0.count > 1 then
		    CurrentContent.Thefigs.Removefigures List0
		  end if
		  fig = List0.concat
		  fig.ListerPrecedences
		  fig.idfig = -1
		  CurrentContent.TheFigs.AddFigure fig
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Autos()
		  if (constructedby <> nil and constructedby.oper = 6) or std then
		    auto = 0
		  elseif self  isa polreg or self isa triangrectiso or  (self isa Bipoint and not self.isaparaperp)  or self isa Freecircle then
		    auto = 1
		  elseif (self isa polyqcq and npts = 3 and not self isa Lacet) or (self isa parallelogram and not self isa rect and not self isa losange) or self isa bande or self isa secteur  then
		    auto = 2
		  elseif self isa triangiso or self isa triangrect or self isa rect or self isa losange or self isa arc  then
		    auto = 3
		  elseif self isa trap then
		    auto = 5
		  elseif self.isaparaperp then
		    auto = 6
		  else
		    auto = 4 // Points isolés,  Polyqcq (npts > 3), y compris Lacets
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbSomCommuns(f as figure) As integer
		  dim i, j, n, n0 as integer
		  
		  n0 = 0
		  
		  if not self isa point then
		    for i = 0 to npts-1
		      if f.somm.getposition(points(i)) <> -1 or f.PtsConsted.getposition(points(i)) <> -1 then
		        n0 = n0+1
		      end if
		    next
		  else
		    if f.somm.getposition(self) <> -1 or f.ptsconsted.getposition(self) <> -1 then
		      n0 = 1
		    end if
		  end if
		  
		  return n0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as Graphics)
		  dim i, n as integer
		  dim cs as Object2D
		  
		  
		  if (self isa Bipoint and not self isa droite) or (not wnd.drapshowall and hidden) or not noinvalidpoints then
		    return
		  end if
		  
		  updateskull
		  
		  if tracept then
		    sk.updateborderwidth(borderwidth)
		    paint(g,blue)
		  else
		    fixecouleurs
		    fixeepaisseurs
		    sk.paint(g)
		  end if
		  
		  if not hidden then
		    for i = 0 to labs.count-1
		      Labs.element(i).paint(g)
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Transform(M as Matrix)
		  dim i As  Integer      // Utilisé pour les  mouvements
		  
		  if M <> nil and M.v1 <> nil then
		    'UpdateMatrixDuplicatedshapes(M)
		    
		    for i = 0 to npts-1 'Ubound(Childs)
		      Childs(i).Transform(M)
		      'childs(i).updatematrixduplicatedshapes(M)
		    next
		    
		    EndMove
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function check() As boolean
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSousFigure(Figu as Figure) As Figure
		  dim i,j as integer
		  dim ff as figure
		  
		  for i = 0 to Figu.subs.count-1
		    ff = figu.subs.element(i)
		    if ff.shapes.getposition (self) <> -1 or ff.somm.getposition(self) <> -1 or ff.ptssur.getposition(self) <> -1 or ff.ptsconsted.getposition(self) <> -1  then
		      return figu.subs.element(i)
		    end if
		  next
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateconstructedpoints()
		  dim i, j as integer
		  dim s as shape
		  dim p as BasicPoint
		  dim M as Matrix
		  dim tsf as Transformation
		  dim t as Boolean
		  
		  
		  
		  for i = 0 to npts-1
		    points(i).updateconstructedpoints
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Move(M as Matrix)
		  dim i As  Integer      // Utilisé pour les  mouvements de formes images par des transfos
		  
		  for i = 0 to Ubound(Childs)
		    Childs(i). Move(M)
		  next
		  if self isa circle or self isa Lacet then
		    MoveExtreCtrl(M)
		  end if
		  Mmove = M
		  EndMove
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndMove()
		  dim i as integer
		  
		  updatecoord
		  if tsfi.count > 0 then
		    for i=0 to tsfi.count-1
		      tsfi.element(i).update
		    next
		  end  if
		  updatelab
		  updateskull
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub addpoint(p as BasicPoint)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeori()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbInterPts(s as shape, byref interpts() as point, q as point) As integer
		  dim i, j, n , nn as integer
		  dim cote1, cote2 as integer
		  dim p1, p2 as point
		  
		  cote1 = -1
		  cote2 = -1
		  
		  for i = npts to ubound(childs)
		    p1 = childs(i)
		    for j = s.npts to ubound(s.childs)
		      p2 = s.childs(j)
		      if p1 = p2 then
		        nn = nn+1
		        interpts.append p1
		      end if
		    next
		  next
		  
		  return nn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLReadPoint(EL as XMLElement) As point
		  dim  i, num as integer
		  dim s as point
		  dim sh as shape
		  dim List as XMLNodeList
		  dim lab as label
		  
		  num = Val(EL.GetAttribute("Id"))
		  sh = CurrentContent.theobjects.GetShape(num)
		  if sh = nil then
		    s = new Point(objects,EL)
		  elseif sh isa point then
		    s = Point(sh)
		  end if
		  if  Val(EL.GetAttribute("Standard"))= 1 then
		    s.std = true
		  end if
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub rigidifier()
		  dim s as shape
		  
		  
		  s = self
		  
		  while s.constructedby <> nil and (s.constructedby.oper = 3 or s.constructedby.oper = 5)
		    s = s.constructedby.shape
		  wend
		  
		  s.rigidifier1
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub selectgroup()
		  dim i as integer
		  
		  Objects.unselectobject self
		  for i = 0 to Objects.count-1
		    if objects.element(i).IdGroupe = IdGroupe  then
		      Objects.SelectObject(Objects.element(i))
		    end if
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getPointOfSource(id as integer) As Point
		  'dim i as integer
		  '
		  'for i=0 to Ubound(PtsOfSource)
		  'if PtsOfSource(i).id = id then
		  'return PtsOfSource(i)
		  'end if
		  'next
		  'return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Shape(ol as ObjectsList, El as XMLElement)
		  dim  EL1, Temp as XMLElement
		  dim i, n as integer
		  dim num as integer
		  dim List as XMLNodelist
		  dim s as shape
		  dim c as couleur
		  dim pos as string
		  dim lab as label
		  
		  objects=ol
		  id = Val(EL.GetAttribute("Id"))
		  Npts= Val(EL.GetAttribute(Dico.value("Npts")))
		  fam = Val(EL.GetAttribute(Dico.value("Nrfam")))
		  forme = Val(EL.GetAttribute(Dico.value("Nrform")))
		  Ori = val(EL.GetAttribute(Dico.value("Ori")))
		  tsfi = new transfosList
		  autos
		  
		  if val(EL.GetAttribute("Auto")) <> 0 then
		    auto = val(EL.GetAttribute("Auto"))
		  end if
		  
		  if val(EL.GetAttribute("NonPointed")) = 1 then
		    nonpointed = true
		  end if
		  if val(EL.GetAttribute("TiP")) = 1 then
		    Ti = new Tip
		  end if
		  
		  if fam = 0 then
		    List = EL.XQL("Coord")
		    if List.length > 0 then
		      EL1 = XMLElement(List.Item(0))
		      point(self).bpt = new BasicPoint(Val(El1.GetAttribute("X")), Val(El1.GetAttribute("Y")))
		    else
		      point(self).bpt = new BasicPoint(0,0)
		    end if
		    liberte = 2
		  end if
		  
		  if self isa polygon then
		    polygon(self).initcolcotes
		  end if
		  
		  List = EL.XQL("Childs")
		  if List.length > 0 then
		    XMLReadPoints XMLElement(List.Item(0))   // ne lit pas les points sur
		  end if
		  
		  Labs = new LabList
		  
		  List = EL.XQL("Label")
		  if List.length > 0 then
		    for i = 0 to List.length-1
		      lab = labs.newlab(XMLElement(List.Item(i)), self )
		      if lab <> nil then
		        lab.shape = self
		        lab.setposition
		        labs.addlab lab
		      end if
		    next
		  end if
		  
		  List = EL.XQL(Dico.Value("ToolsColorBorder"))
		  if list.length = 1 then
		    if XMLReadcolorelement (Dico.Value("ToolsColorBorder"),EL,c, Temp) then
		      FixeCouleurTrait(c,Config.Border)
		    end if
		  elseif self isa polygon then
		    if List.length = npts or List.length = 9 then
		      for i = 0 to min(list.length-1, UBound(colcotes))
		        EL1 =  XMLElement(List.Item(i))
		        colcotes(i) = new Couleur(EL1)
		      next
		      bordercolor = colcotes(0)
		    elseif List.length = npts+1 then     'compatibilité avec version < 2.2.4
		      EL1 =  XMLElement(List.Item(0))
		      bordercolor = new couleur(EL1)
		      for i = 1 to list.length-1
		        EL1 =  XMLElement(List.Item(i))
		        colcotes(i-1) = new Couleur(EL1)
		      next
		    end if
		  end if
		  
		  if XMLReadcolorelement (Dico.Value("ToolsColorFill"),EL,c,Temp) then
		    fill = Val(Temp.GetAttribute("Opacity"))
		  end if
		  FixeCouleurFond(c,Fill)
		  
		  List = EL.XQL(Dico.Value("Thickness"))
		  if list.length = 0 then
		    Borderwidth = 1
		  else
		    Borderwidth = val(XMLElement(List.Item(0)).GetAttribute("Value"))
		  end if
		  List = EL.XQL(Dico.Value("Hidden"))
		  if List.length > 0 then
		    Hide
		  end if
		  
		  List = EL.XQL(Dico.Value("Invalid"))
		  if List.length > 0 then
		    Invalid = true
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Invalider()
		  dim i, j, k as integer
		  dim t as boolean
		  dim s as shape
		  
		  if not invalid then
		    invalid = true
		    
		    for i = 0 to npts-1
		      if childs(i).id > id then
		        childs(i).invalider
		      end if
		    next
		    
		    for i = npts to ubound(childs)
		      childs(i).invalider
		    next
		    
		    CurrentContent.Theobjects.invalidatefrom(self)
		    
		    for j = 0 to ubound(ConstructedShapes)        //on invalide les images
		      s = ConstructedShapes(j)
		      s.invalider
		    next
		    
		    for i = 0 to tsfi.count-1                                   // on invalide les objets images par un tsf de support self
		      for j = 0 to tsfi.element(i).constructedshapes.count -1
		        s = tsfi.element(i).constructedshapes.element(j)
		        s.invalider
		      next
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function successeur3(Byref s1 as shape) As boolean
		  dim i as integer
		  
		  for i = 0 to ubound(constructedshapes)
		    if constructedshapes(i).constructedby.oper = 3   then
		      s1 = constructedshapes(i)
		      return true
		    end if
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function samefigure(s as shape) As Boolean
		  dim i as integer
		  
		  if self isa point then
		    return (s.getindex(point(self))<> -1 ) or (constructedby <> nil and constructedby.shape = s and not s isa point)
		  else
		    for i = 0 to ubound(childs)
		      if (s.getindex(childs(i)) <> -1) or (childs(i).constructedby<> nil and childs(i).constructedby.shape = s and not s isa point)  then
		        return true
		      end if
		    next
		    for i = 0 to ubound(s.childs)
		      if (getindex(s.childs(i)) <> -1) or (s.childs(i).constructedby<> nil and s.childs(i).constructedby.shape = self)  then
		        return true
		      end if
		    next
		  end if
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfo(Temp as XMLElement)
		  dim m, oper as integer
		  dim  Tmp, EL as XmlElement
		  dim s as shape
		  dim List As XMLNodelist
		  dim p as point
		  
		  
		  List = Temp.XQL("ConstructedBy")
		  if List.Length > 0 then
		    Tmp = XMLElement(List.Item(0))
		    m = val(Tmp.GetAttribute("Id"))
		    if m <> 0 then
		      s = objects.getshape(m)
		    else
		      s = nil
		    end if
		    oper = Val(Tmp.GetAttribute("Oper"))
		    setconstructedby s,oper
		    select case oper //lecture des infos supplémentaires (data)
		    case 1,2
		      XMLReadConstructionInfoParaperp(Tmp)
		    case 3
		      XMLReadConstructionInfoDuplicate(Tmp)
		    case 4
		      XMLReadConstructionInfoDivPoint(Tmp)
		    case 5
		      XMLReadConstructionInfoCutPoints(Tmp)
		    case 6
		      XMLReadConstructionInfoImgPt(Tmp)
		    case 7
		      XMLReadConstructionInfoPtFix(Tmp)
		    case 9
		      XMLReadConstructionInfoMerge(Tmp)
		    case 10
		      XMLReadConstructionInfoDuplPoint(Tmp)
		    end select
		    if self isa point then
		      point(self).mobility
		      point(self).updateguides
		    end if
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  dim Form, Temp as XMLElement
		  dim i, n as integer
		  
		  Form = XMLPutIdInContainer(Doc)
		  
		  if fig <> nil and not self isa repere then
		    Form.SetAttribute("FigId",str(fig.idfig))
		  end if
		  
		  for i = 0 to labs.count-1
		    form.appendchild labs.element(i).toXML(Doc)
		  next
		  
		  Form.AppendChild  XMLPutChildsInContainer(Doc)
		  
		  if  NbPtsConsted > 0 then
		    Form.appendchild XMLPutPtsConstedInContainer(Doc)
		  end if
		  
		  if self isa Lacet then
		    form.AppendChild (Lacet(self).XMLPutInfosArcs(Doc))
		  end if
		  if constructedby <> nil then
		    form.appendchild XMLPutConstructionInfoInContainer(Doc)
		  end if
		  if Macconstructedby <> nil then
		    form.appendchild XMLPutMacConstructionInfoInContainer(Doc)
		  end if
		  if not app.macrocreation then
		    if self isa polygon and not self isa Lacet then
		      if self isa cube then
		        n = 8
		      else
		        n = npts-1
		      end if
		      for i = 0 to n
		        Form.AppendChild  colcotes(i).XMLPutIncontainer(Doc, Dico.Value("ToolsColorBorder"))
		      next
		    else
		      Form.AppendChild  BorderColor.XMLPutIncontainer(Doc, Dico.Value("ToolsColorBorder"))
		    end if
		    
		    if not self isa bipoint  then
		      Temp = fillcolor.XMLPutInContainer(Doc, Dico.Value("ToolsColorFill"))
		      Temp.SetAttribute("Opacity", str(fill))
		      Form.AppendChild  Temp
		    end if
		    Temp = Doc.CreateElement(Dico.Value("Thickness"))
		    Temp.SetAttribute("Value", str(borderwidth))
		    Form.AppendChild Temp
		  end if
		  
		  if Hidden then
		    Form.AppendChild(Doc.CreateElement(Dico.Value("Hidden")))
		  end if
		  
		  if Invalid then
		    Form.AppendChild(Doc.CreateElement(Dico.Value("Invalid")))
		  end if
		  Form.AppendChild XMLPutTsfInContainer(Doc)
		  
		  return Form
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setfigconstructioninfos()
		  dim s as shape
		  dim i as integer
		  dim tsf as transformation
		  
		  if Constructedby <> nil then
		    s = constructedby.shape
		    select case constructedby.oper
		    case 6
		      tsf = transformation(constructedby.data(0))
		      tsf.setconstructioninfos2(s,self)
		    case 1, 2
		      tsf = transformation(constructedby.data(1))
		      fig.SetConstructedBy(s.fig, tsf)
		      tsf.constructedfigs.addfigure fig
		    end select
		  end if
		  
		  for i = 0 to ubound(childs)
		    if childs(i).constructedby <> nil and childs(i).constructedby.oper = 6 then
		      tsf = transformation(childs(i).constructedby.data(0))
		      tsf.updateconstructioninfos childs(i)
		      childs(i).fig.setconstructedby childs(i).constructedby.shape.fig, tsf
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub rigidifier1()
		  dim i as integer
		  
		  std = not std
		  
		  if self isa point then
		    point(self).mobility
		  else
		    for i = 0 to npts-1
		      points(i).mobility
		    next
		  end if
		  
		  for i = 0 to ubound(constructedshapes)
		    if constructedshapes(i).constructedby.oper = 3 or  constructedshapes(i).constructedby.oper = 5 then
		      constructedshapes(i).rigidifier1
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatelab()
		  dim i as integer
		  dim pos as basicPoint
		  
		  for i = 0 to labs.count-1
		    if not labs.element(i).fixe then
		      labs.element(i).SetPosition
		    end if
		  next
		  if not (currentcontent.currentoperation isa modifier) or  modifier(currentcontent.currentoperation).testfinished then
		    if self = currentcontent.SHUL and modified then
		      currentcontent.UL = currentcontent.SHUL.longueur(currentcontent.IcotUL)
		    elseif self = currentcontent.SHUA and modified  then
		      currentcontent.UA = currentcontent.SHUA.aire
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function precede(s2 as shape) As boolean
		  dim h, k, m, i, j  as integer
		  dim ff as figure
		  dim p, q as point
		  dim s, sh as shape
		  dim t as Boolean
		  dim s2ci As constructioninfo
		  
		  ff = s2.getsousfigure(s2.fig)
		  s2ci = s2.constructedby
		  if s2ci <> nil and (s2ci.shape = self or (s2ci.shape = nil and s2ci.oper = 9 and (s2ci.data(0) = self or s2ci.data(2) =self))  ) then
		    select case  s2.constructedby.oper
		    case 1, 2
		      if not haspointon(s2,p) then
		        return true
		      end if
		    case 3, 5, 6, 9
		      return true
		      'case 3
		      'if isaparaperp then
		      'return true
		      'end if
		      'if   not self isa point then
		      'for i = 0 to npts-1
		      'if points(i).pointsur.count = 2 then
		      'return true
		      'end if
		      'next
		      'end if
		    end select
		  elseif constructedby <> nil and constructedby.oper = 6 then
		    if constructedby.shape.fig <> s2.fig and NbSomCommuns(ff) > 0 then
		      return true
		    end if
		  end if
		  
		  if not s2 isa point then
		    for i = 0 to s2.npts-1
		      if (s2.points(i).constructedby <> nil) and (s2.points(i).constructedby.shape isa point) then  //un point de s2 est image d'un point de self
		        p = point(s2.points(i).constructedby.shape)
		        if  getindexpoint(p) <> -1  and  p.id >  id  then  //si p.id < id, le point source a été construit avant self, il appartient à une autre forme
		          //que self et c'est celle-là qui doit précéder s2
		          k = s2.points(i).constructedby.oper
		          if (k=5) or (k=6) then
		            return  true
		          end if
		        end if
		      end if
		    next
		  end if
		  
		  for k = 0 to tsfi.count-1
		    if s2.constructedby<> nil and s2.constructedby.oper = 6 and Transformation(s2.constructedby.data(0)) = tsfi.element(k) then
		      return true
		    end if
		  next
		  
		  'for k = 0 to ubound(tsfi)
		  'if not s2 isa point then
		  'for h = 0 to s2.npts-1
		  'if s2.points(h).constructedby <> nil and s2.points(h).constructedby.oper = 6 and Transformation(s2.points(h).constructedby.data(0)) = tsfi(k) then
		  'return true
		  'end if
		  'next
		  'end if
		  'next
		  
		  if not s2 isa point then
		    for h = 0 to s2.npts-1
		      if s2.points(h).constructedby <> nil and s2.points(h).constructedby.oper = 6  then
		        sh = Transformation(s2.points(h).constructedby.data(0)).supp
		        if sh = self or (sh isa point and  sh.id > id and (( getindex(point(sh)) <> -1) or  (sh.constructedby <> nil and sh.constructedby.shape = self )  ) ) then
		          return true
		        end if
		      end if
		    next
		  end if
		  
		  
		  if self isa arc and s2 isa arc and points(2)=s2.points(1) then
		    return true
		  end if
		  
		  
		  if s2.haspointon(self, p)  and not (isaparaperp(sh)  and sh.NbPtsCommuns(s2) >= 2 and haspointsimages(s2))   then
		    t =  (constructedby = nil or constructedby.shape <> s2)   ''si un sommet de s2 est pointsur self (sans que self soit construit par s2)
		    for k = 0 to npts-1
		      t = t or ( (points(k).constructedby = nil) or (points(k).constructedby.shape isa point and s2.getindex(point(points(k).constructedby.shape)) <> -1) )
		    next
		    if t then
		      return true
		    end if
		  end if
		  
		  'if self isa bipoint then   //Ennuyeux si le bipoint est commun à deux polygones de figures différentes BH F15_3.fag
		  'if s2 isa polygon and s2.getindexpoint(points(0)) <> -1 and s2.getindexpoint(points(1)) <> -1 then
		  'return true
		  'end if
		  'end if
		  
		  if s2 isa polygon then
		    for i = 0 to s2.npts-1
		      p = s2.points(i)
		      q = s2.points((i+1) mod s2.npts)
		      for k = 0 to ubound(P.parents)
		        s = p.parents(k)
		        if s <> s2 and s.getindexpoint(q) <> -1 and s isa droite then
		          if s.isaparaperp and s.constructedby.shape = self then
		            return true
		          end if
		        end if
		      next
		    next
		  end if
		  
		  if isaparaperp and s2.getindexpoint(points(1)) <> -1 then
		    return true
		  end if
		  
		  '''''''''''''''''''' Voir figurestest 1 et 2 : la méthode qui suit est un compromis pour satisfaire les deux (!?), les trois avec Varignon
		  if not self isa point and  NbTrueSomCommuns(ff) = ubound(points)+1  and s2.auto = 4  then
		    t = True
		    for i = 0 to ubound(points)
		      if points(i).pointsur.count = 1 and points(i).pointsur.element(0).isaparaperp then
		        t = false
		      end if
		    next
		    return t
		  end if
		  
		  for i = 0 to ubound(childs)    // double emploi avec une autre condition ci-dessus
		    if childs(i).id > id then
		      for j = 0 to ubound (childs(i).constructedshapes)
		        if s2.getindex(point(childs(i).constructedshapes(j))) <>-1 and childs(i).constructedshapes(j).constructedby.oper = 6 then
		          return true
		        end if
		      next
		    end if
		  next
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateoldM()
		  dim i as integer
		  
		  for i = 0 to tsfi.count-1
		    tsfi.element(i).oldM = tsfi.element(i).M
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function hasimageby(s as shape) As boolean
		  dim k as integer
		  
		  for k = 0 to ubound(constructedshapes)
		    if constructedshapes(k).constructedby.oper = 6 and transformation(constructedshapes(k).constructedby.data(0)).supp = s then
		      return true
		    end if
		  next
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Listerfigsneighbour() As figslist
		  dim i, j as integer
		  dim List0 as FigsList
		  dim macinf as MacConstructionInfo
		  dim ifm as InfoMac
		  
		  list0 = new figslist
		  
		  for i = 0 to ubound(childs)
		    if childs(i).fig <>nil  then
		      List0.addfigure childs(i).fig
		    else
		      for j = 0 to ubound(childs(i).parents)
		        if self <> childs(i).parents(j)  then
		          List0.addfigure childs(i).parents(j).fig
		        end if
		      next
		    end if
		    
		    if childs(i).centerordivpoint then
		      List0.addfigure childs(i).constructedby.shape.fig
		    end if
		  next
		  
		  for i = 0 to ubound(constructedshapes)
		    if constructedshapes(i).centerordivpoint then
		      list0.addfigure constructedshapes(i).fig
		    end if
		  next
		  
		  if macconstructedby <> nil then
		    for i = 0 to ubound(macconstructedby.ifmacs)
		      ifm = macconstructedby.ifmacs(i)
		      if ifm.init then
		        list0.addfigure currentcontent.theobjects.getshape(ifm.realid).fig
		      end if
		    next
		  end if
		  return list0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function centerordivpoint() As Boolean
		  if not self isa point then
		    return false
		  elseif constructedby <> nil then
		    return constructedby.oper =0 or constructedby.oper = 4 or constructedby.oper = 7
		  end if
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function iscircumcircle(s as triangle) As Boolean
		  dim r as double
		  dim p as basicpoint
		  dim t as boolean
		  dim i as integer
		  
		  if not self isa freecircle then
		    return false
		  end if
		  
		  p = circle(self).getgravitycenter
		  r = circle(self).getradius
		  t = true
		  
		  for i = 0 to 2
		    t = (abs(r-p.distance(s.points(i).bpt)) < epsilon) and t
		  next
		  
		  return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbSommSur() As integer
		  // Nombre et liste des sommets qui sont des "pointssur" (non lié  à une quelconque modification) (différence par rapport à la méthode NbSommSur de figure)
		  
		  dim i, n as integer
		  
		  Redim ListSommSur(-1)
		  for i = 0 to npts-1
		    if points(i).pointsur.count = 1 then
		      n = n+1
		      ListSommSur.append i
		    end if
		  next
		  
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Ordonner(Byref p as point, byref q as point, byref r as point)
		  dim m, n(3) ,i,j as integer
		  
		  
		  n(0) = getindexpoint(p)
		  n(1) = getindexpoint(q)
		  n(2) = getindexpoint(r)
		  
		  if n(0) = -1 or n(1) = -1 or n(2) = -1 then
		    return
		  end if
		  
		  for i = 1 to 2
		    for j = 0 to 2-i
		      if n(j) > n(j+1) then
		        m=n(j)
		        n(j) = n(j+1)
		        n(j+1) = m
		      end if
		    next
		  next
		  
		  p = points(n(0))
		  q = points(n(1))
		  r = points(n(2))
		  
		  return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isaparaperp(Byref sh as shape) As Boolean
		  if (constructedby <> nil) and (constructedby.oper  = 1 or constructedby.oper = 2) then
		    sh = constructedby.shape
		    return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetOldBpt(p as point) As BasicPoint
		  dim sf as figure
		  dim i as integer
		  
		  
		  sf = getsousfigure(fig)
		  
		  
		  
		  i = sf.somm.getposition(p)
		  if i <> -1 then
		    return sf.oldbpts(i)
		  else
		    i = sf.ptssur.getposition(p)
		    if i <> -1 then
		      return sf.oldptssur(i)
		    else
		      i = sf.ptsconsted.getposition(p)
		      if i <> -1 then
		        return sf.oldptscsted(i)
		      else
		        return nil
		      end if
		    end if
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function inispeupdate1(Byref n as integer) As point
		  dim ff as figure
		  dim p as point
		  
		  ff = getsousfigure(fig)
		  p = Point(ff.somm.element(ff.ListPtsModifs(0)))
		  n = getindex(p)
		  
		  return p
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function haspointon(s as shape, byref p as point) As Boolean
		  dim i,j as integer
		  
		  if self isa point then
		    return false
		  end if
		  
		  for i = 0 to npts-1
		    if points(i).pointsur.count >0 and  points(i).pointsur.getposition(s) <> -1 then
		      p = points(i)
		      return true
		    end if
		  next
		  
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEps(tos as TextOutputStream)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isptsur() As boolean
		  
		  return (self isa point) and (point(self).pointsur.count = 1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Shape(s as shape, M as Matrix)
		  dim i as integer
		  dim p as BasicPoint
		  
		  npts = s.npts
		  
		  for i = 0 to npts-1
		    p = M*(s.points(i).bpt)
		    Points.append new Point(p)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadPtsConsted(Temp as XMLElement)
		  dim i as integer
		  dim EL,  EL1 as XmlElement
		  dim p as point
		  dim List As XMLNodelist
		  
		  List = Temp.XQL("PtsConsted")
		  if List.Length > 0 then
		    EL = XMLElement(List.Item(0))
		    for i = 0 to EL.Childcount-1
		      EL1 = XmlElement(EL.Child(i))
		      p = XMLReadPoint(EL1)
		      p.XMLReadConstructionInfo(El1)
		      objects.addshape p
		      p.liberte = 0
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutPtsConstedInContainer(Doc as XMLDocument) As XMLElement
		  dim Temp as XMLElement
		  dim i as integer
		  
		  Temp = Doc.CreateElement("PtsConsted")
		  
		  for i = 0 to ubound(constructedshapes)
		    if constructedshapes(i).centerordivpoint then
		      Temp.appendchild constructedshapes(i).XMLPutInContainer(Doc)
		    end if
		  next
		  
		  return Temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbPtsConsted() As integer
		  dim i, n as integer
		  
		  for i = 0 to ubound(constructedshapes)
		    if constructedshapes(i).centerordivpoint then
		      n = n+1
		    end if
		  next
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier1fixe(p as point, q as point) As Matrix
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2fixes(p as point) As Matrix
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modify2(p1 as point, p2 as point) As Matrix
		  dim m as integer
		  dim  ep1, np1, ep2, np2  as BasicPoint
		  dim ff as figure
		  
		  
		  ff = getsousfigure(fig)
		  m = getindexpoint(fig.pointmobile)
		  
		  select case ff.NbUnModif
		  case 0
		    ff.getoldnewpos(p1,ep1,np1)
		    ff.getoldnewpos(p2,ep2,np2)
		    return new SimilarityMatrix(ep1,ep2,np1,np2)
		  case 1
		    if m = -1 then
		      return new Matrix(1)
		    else
		      return modifier2fixes(fig.pointmobile)
		    end if
		  end select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub pastelabs(s as shape)
		  dim i as integer
		  
		  for i = 0 to s.labs.count-1
		    labs.addlab new label(s.labs.element(i))
		    labs.element(i).shape = self
		    labs.element(i).setposition
		  next
		  
		  for i = 0 to ubound(childs)
		    Childs(i).pastelabs(s.childs(i))
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function duplicateorcut() As Boolean
		  return constructedby <> nil and (constructedby.oper = 3 or constructedby.oper = 5)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoParaperp(Tmp as XMLelement)
		  constructedby.data.append val(Tmp.GetAttribute("Index"))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoDuplicate(Tmp as XMLElement)
		  dim x, y as double
		  dim Mat as Matrix
		  dim j as integer
		  
		  Mat = new Matrix(Tmp)
		  
		  constructedby.data.append Mat
		  if not self isa point then
		    for j = 0 to npts-1
		      points(j).setconstructedby constructedby.shape.points(j), 3
		      points(j).constructedby.data.append Mat
		      points(j).mobility
		      points(j).updateguides
		    next
		  end if
		  if self isa droite then
		    if forme = 1 or forme = 2 then
		      forme = 0
		    elseif forme = 4 or forme = 5 then
		      forme = 3
		    end if
		    auto = 1
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoDivPoint(Tmp as XMLElement)
		  dim n as integer
		  
		  n = Val(Tmp.GetAttribute("Id0"))
		  constructedBy.data.append Point(objects.getshape(n))
		  n = Val(Tmp.GetAttribute("Id1"))
		  constructedBy.data.append Point(objects.getshape(n))
		  constructedBy.data.append Val(Tmp.GetAttribute("NDivP"))
		  constructedBy.data.append Val(Tmp.GetAttribute("DivP"))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoCutPoints(Tmp as XMLElement)
		  dim Mat as Matrix
		  dim EL3 as XMLElement
		  dim List3 as XmlNodeList
		  dim j, num as integer
		  dim s1, s2 as shape
		  
		  
		  Mat = new Matrix(Tmp)
		  constructedBy.data.append Mat
		  constructedby.data.append  val(Tmp.GetAttribute("Ncut"))
		  
		  List3 = Tmp.XQL("CutPoints")
		  if List3.Length > 0 then
		    EL3=XMLElement(List3.Item(0))
		    ncpts = val(EL3.GetAttribute("Ncpts"))
		    npts = EL3.childcount
		    for j = 0 to npts-1
		      num = Val(EL3.Child(j).GetAttribute("Id"))
		      s1 = LoadObject(num, XMLElement(EL3.Child(j)))
		      num = Val(EL3.Child(j).GetAttribute("Constructedby"))
		      s2 = objects.getshape(num)
		      s1.setconstructedby s2,5
		      s1.constructedby.data.append Mat
		      Point(s1).mobility
		    next
		  end if
		  
		  
		  if not self  isa Lacet then
		    List3 = Tmp.XQL("SourcePoints")
		    if List3.length > 0 then
		      EL3=XMLElement(List3.Item(0))
		      for j = 0 to EL3.ChildCount-1
		        num = val(EL3.Child(j).GetAttribute("Id"))
		        s1 = LoadObject(num, XMLElement(EL3.Child(j)))
		        num = Val(EL3.Child(j).GetAttribute("Constructedby"))
		        s2 = objects.getshape(num)
		        if s2 =  nil then
		          s2 = constructedby.shape.getPointOfSource(num)
		        end if
		        s1.setconstructedby s2,5
		        s1.constructedby.data.append Mat
		        if not Point(s1).IsChildOf(self) then
		          s1.invalider
		          currentcontent.removeshape s1
		        else
		          Point(s1).mobility
		        end if
		      next
		    end if
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoImgPt(Tmp as XMLElement)
		  dim j, n as integer
		  dim s1 as shape
		  dim tsf as Transformation
		  
		  n = val(Tmp.GetAttribute("SuppTsf"))
		  if n<> 0 then
		    s1 =objects.getshape(n)
		    j = val(Tmp.GetAttribute("Nr"))
		    if j = -1 then
		      j = 0
		    end if
		    tsf = s1.tsfi.element(j)
		  elseif self isa point and ubound(point(self).parents) > -1 then
		    s1 = point(self).parents(0)
		    if  s1.constructedby <> nil and s1.constructedby.oper = 6 then
		      tsf = Transformation(s1.constructedby.data(0))
		    end if
		  else
		    app.abortread
		  end if
		  tsf.setconstructioninfos1(constructedby.shape,self)
		  auto = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoDuplPoint(Tmp as XMLElement)
		  ConstructedBy.data.append val(Tmp.Getattribute("Data0"))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Canceltrace()
		  dim i As integer
		  tracept = false
		  for i = 0 to ubound(childs)
		    childs(i).canceltrace
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoPtFix(Tmp as XMLElement)
		  dim j, n as integer
		  dim s1 as shape
		  dim tsf as Transformation
		  
		  n = val(Tmp.GetAttribute("SuppTsf"))
		  s1 = Objects.GetShape(n)
		  j = val(Tmp.GetAttribute("Nr"))
		  tsf = s1.tsfi.element(j)
		  constructedby.data.append tsf
		  tsf.Fixpt = point(self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isaparaperp() As Boolean
		  if (constructedby <> nil) and (constructedby.oper = 1 or constructedby.oper =2) then
		    return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddToFigure(ff as figure, idf as integer)
		  dim List0 as figslist
		  dim figu as figure
		  dim o as shapeconstruction
		  dim i, j, op as integer
		  dim sh as shape
		  dim tsf as transformation
		  
		  if fig <> nil and ff <> nil and fig = ff then
		    return
		  end if
		  
		  figu = new Figure(self)
		  if ff <> nil then
		    List0 = new FigsList
		    List0.addfigure ff
		    List0.addfigure figu
		    fig = List0.concat
		    CurrentContent.TheFigs.Removefigure ff
		  else
		    fig = figu
		  end if
		  
		  fig.idfig = idf
		  CurrentContent.TheFigs.AddFigure fig
		  
		  
		  if Constructedby <> nil and isaparaperp and constructedby.shape.fig <> nil then //si constructedby.shape.fig a déjà été chargé
		    sh = constructedby.shape
		    for i = 0 to sh.tsfi.count-1
		      tsf = sh.tsfi.element(i)
		      if tsf.type = 0 then 'and tsf.constructedshapes.count = 0 then
		        tsf.constructedshapes.addshape self
		        constructedby.data.append tsf
		      end if
		    next
		  end if
		  'droite(self).createtsf
		  'end if
		  
		  if ubound(ConstructedShapes) > -1 then  // sinon on fait la même chose au moment ou on charge constructedby.shape.fig
		    for  i = 0 to ubound(constructedshapes)
		      sh= constructedshapes(i)
		      if sh.isaparaperp and sh.fig <> nil and ubound(sh.constructedby.data) = 0 then
		        for j = 0 to tsfi.count-1
		          tsf = tsfi.element(j)
		          if tsf.type = 0 and tsf.constructedshapes.count = 0 then
		            tsf.constructedshapes.addshape sh
		            sh.constructedby.data.append tsf
		          end if
		        next
		        'droite(sh).createtsf
		      end if
		    next
		  end if
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddToFigureCutInfos()
		  dim s as shape
		  dim p as point
		  dim i as integer
		  dim List1 as figslist
		  
		  if Constructedby <> nil and  constructedby.oper  = 5 then
		    s = constructedby.shape
		    for i = 0 to ncpts-1
		      p = point(points(i).constructedby.shape)
		      if s.fig.somm.getposition(p) = -1 and s.fig.ptssur.getposition(p) = -1 and s.fig.ptsconsted.getposition(p) = -1 then
		        CurrentContent.Thefigs.Removefigure s.fig
		        CurrentContent.Thefigs.Removefigure p.fig
		        List1 = new figslist
		        list1.addfigure s.fig
		        list1.addfigure p.fig
		        s.fig = list1.concat
		        s.fig.ListerPrecedences
		        CurrentContent.TheFigs.AddFigure s.fig
		      end if
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatelabel(k as double)
		  dim i as integer
		  dim r as double
		  
		  if labupdated then
		    return
		  end if
		  
		  
		  for i = 0 to labs.count-1
		    labs.element(i).setsize round(labs.element(i).size * k)
		    labs.element(i).setposition
		  next
		  
		  labupdated = true
		  if not self isa point then
		    for i = 0 to ubound(childs)
		      childs(i).updatelabel(k)
		    next
		  end if
		  
		  for i = 0 to ubound(constructedshapes)
		    constructedshapes(i).updatelabel(k)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetImgPtOfSource(P as Point) As Point
		  'dim i as integer
		  '
		  'for i = 0 to Ubound(PtsOfSource)
		  'if PtsOfSource(i).ConstructedBy.Shape = P then
		  'return PtsOfSource(i)
		  'end if
		  'next
		  '
		  'return nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LoadObject(m as integer, Tmp as XMLElement) As shape
		  
		  dim s as shape
		  
		  s= objects.getshape(m)
		  if s = nil then
		    s = objects.XMLLoadObject(Tmp)
		  end if
		  
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub delete()
		  dim i, j, n as integer
		  dim s as shape
		  dim tsf as transformation
		  dim p as point
		  dim inter as intersec
		  dim pol as polygon
		  dim MacInfo as MacConstructionInfo
		  
		  if constructedby <> nil then
		    select case  constructedby.oper
		    case 1, 2
		      constructedby.shape.removeconstructedshape self
		      if ubound(constructedby.data) = 1 and constructedby.data(1) <> nil then
		        tsf = transformation (constructedby.data(1))
		        tsf.constructedshapes.removeshape self                        'en cas d'avortement tsf n'est pas encore définie
		        tsf.supp.tsfi.removetsf tsf
		        currentcontent.TheTransfos.removetsf  tsf
		      end if
		    case 3
		      constructedby.shape.removeconstructedshape self
		    case 5
		      constructedby.shape.removeconstructedshape self
		      for i =  ncpts-1 to 0
		        s = points(i).constructedby.shape
		        s.removeconstructedshape points(i)
		      next
		    case  6
		      tsf = transformation (constructedby.data(0))
		      if tsf <> nil then
		        tsf.removeconstructioninfos(self)    'idem
		      end if
		    case 9
		      shape(constructedby.data(0)).removeconstructedshape self
		      shape(constructedby.data(2)).removeconstructedshape self
		    case 5
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
		      CurrentContent.Thetransfos.RemoveTsF tsfi.element(i)
		    next
		  end if
		  
		  if conditionedby <> nil then
		    conditionedby.conditioned.removeshape self
		  end if
		  
		  for i = ubound(childs) downto npts
		    p = childs(i)
		    p.removepointsur(self)
		  next
		  
		  for i = npts-1 downto 0
		    p = points(i)
		    if p.pointsur.count = 2 and p.id > id then
		      inter = CurrentContent.TheIntersecs.find(p.pointsur.element(0), p.pointsur.element(1))
		      inter.removepoint p
		    end if
		    for j =  p.pointsur.count-1 downto 0
		      if p.id > id then
		        p.removepointsur(p.pointsur.element(j))
		      end if
		    next
		    removepoint p
		    if p.id < id and p.isolated and p.pointsur.count = 0  then
		      currentcontent.addshape(p)
		      p.addtofigure
		    end if
		  next
		  
		  if conditionedby <> nil then
		    conditionedby.conditioned.removeshape self
		  end if
		  removefromfigure
		  
		  if self isa droite and droite(self).isaprolongement(pol,n) then
		    pol.prol(n) = false
		  end if
		  
		  if currentcontent.SHUA = self then
		    currentcontent.SHUA = nil
		  end if
		  
		  if currentcontent.SHUL = self then
		    currentcontent.SHUL = nil
		  end if
		  
		  
		  
		  currentcontent.removeshape self
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveFromFigure()
		  dim ff as figure
		  dim i as integer
		  
		  
		  if fig = nil then
		    return
		  end if
		  
		  ff = getsousfigure(fig)
		  
		  if ff <> nil then
		    ff.shapes.removeshape self
		    if self isa point then
		      ff.somm.removeshape self
		      ff.ptssur.removeshape self
		      ff.ptsconsted.removeShape self
		    end if
		  end if
		  
		  fig.shapes.removeshape self
		  if self isa point then
		    fig.somm.removeshape self
		    fig.ptssur.removeshape self
		    fig.ptsconsted.removeShape self
		  end if
		  
		  fig = nil
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function mustbeinfigure(ff as figure) As boolean
		  dim k as integer
		  
		  for k = 0 to ff.shapes.count-1
		    if samefigure(ff.shapes.element(k))  then
		      return true
		    end if
		  next
		  
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetIndexSide() As integer
		  dim op as operation
		  dim i, n as integer
		  
		  n=-1
		  
		  op =CurrentContent.currentoperation
		  if op <> nil and op.nobj > 0 and op.visible.element(op.iobj) = self then
		    if (op isa transfoconstruction and (transfoconstruction(op).type < 7))  then ' or op isa prolonger then
		      n = op.index(op.iobj)
		    elseif  op isa  paraperpconstruction then
		      n = op.index(op.iobj)
		    elseif op isa colorchange and colorchange(op).bord then
		      n = op.index(op.iobj)
		    elseif op isa Divide then
		      n = Divide(op).side
		    end if
		  end if
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics, c as couleur)
		  if noinvalidpoints then
		    sk.updatebordercolor (c.col,100)
		    sk.paint(g)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCoteOfPts(P1 as Point, P2 As Point) As integer
		  dim side1,side2,diff as Integer
		  dim som1,som2 as Boolean
		  
		  side1 = GetIndexPoint(P1)
		  som1=true
		  if side1=-1 then
		    side1= PointOnSide(P1.bpt)
		    som1=false
		  end if
		  
		  side2 = GetIndexPoint(P2)
		  som2=true
		  if side2=-1 then
		    side2= PointOnSide(P2.bpt)
		    som2=false
		  end if
		  
		  if(side1<>-1 and side2<>-1) then
		    if (side1=side2) then
		      return side1
		    elseif not som1 and not som2 then
		      return -1
		    else
		      diff = (abs(side1-side2)) mod (npts-1)
		      if diff = 1 then
		        if som1 and som2 then
		          return min(side1,side2)
		        elseif som1 and  side1>side2 then
		          return side2
		        elseif som2 and  side2>side1 then
		          return side1
		        else
		          return -1
		        end if
		      elseif diff =0 then
		        return max(side1,side2)
		      else
		        return -1
		      end if
		    end if
		  else
		    return -1
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextBorderPoint(P as Point, p2 as point) As Point
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PrecBorderPoint(P as Point, p2 as point) As Point
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateshape(M as Matrix)
		  dim i as integer
		  dim s1, s2 As shape
		  dim p as point
		  
		  
		  if not self isa point then
		    computediam
		    if diam < 10*epsilon then
		      tobereconstructed = true
		    end if
		    
		    if tobereconstructed then
		      constructshape
		      if check then
		        tobereconstructed = false
		      end if
		    end if
		  end if
		  
		  if ubound(childs) >= npts then
		    for i = npts to ubound(childs)
		      childs(i).updateshape(M)
		    next
		  end if
		  
		  
		  updateshape
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ptsinter(s as shape, byref interpts() as point) As integer
		  dim i, j, m as integer
		  dim p1, p2 as point
		  
		  for i = npts to ubound(childs)
		    p1 = childs(i)
		    for j = s.npts to ubound(s.childs)
		      p2 = s.childs(j)
		      if p1 = p2 then
		        m = m+1
		        interpts.append p1
		      end if
		    next
		  next
		  
		  return m
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pointonline(p as Basicpoint) As integer
		  return pointonside(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSide(n as integer) As droite
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function hascommonpointwith(s as shape) As Boolean
		  dim i as integer  //sert pour l'invalidation des objets plus jeunes qu'un objet invalidé et ayant un point commun avec cet objet
		  
		  if not self isa point then
		    for i = 0 to npts-1
		      if s.getindexpoint(points(i)) <> -1 and points(i).id > s.id then
		        return true
		      end if
		    next
		  elseif s.getindexpoint(point(self)) <> -1 then
		    return true
		  end if
		  
		  
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub enablemodify()
		  dim i as integer
		  
		  for i = 0 to ubound(childs)
		    childs(i).enablemodify
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function predecesseur() As shape
		  if duplicateorcut then
		    return constructedby.shape
		  end if
		  
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Flecher()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fixecouleurs()
		  dim i, n as integer
		  dim cs as Object2D
		  
		  if (self isa  polygon or self isa bande ) and not self isa Lacet then
		    if hidden or tsp or (self.std and self.isinconstruction and wnd.stdflag) then
		      sk.updatefillcolor(fillcolor.col,0)
		    else
		      sk.updatefillcolor(fillcolor.col,fill)
		    end if
		    
		    for i = 0 to FigSkull(sk).Nbcotes
		      cs = figskull(sk).getcote(i)
		      if hidden and highlighted then
		        cs.bordercolor = Config.highlightcolor.col
		        cs.border = 100
		        cs.fill = 0
		      elseif hidden Then
		        cs.bordercolor = Config.HideColor.col
		        cs.border = 100
		      elseif highlighted then
		        n = getindexside
		        if n = -1 or n = i then
		          cs.bordercolor = Config.highlightcolor.col
		          cs.border = 100
		        else
		          cs.bordercolor = colcotes(i).col
		          cs.border = 100
		        end if
		        cs.fill = 0
		      elseif isinconstruction  then
		        cs.bordercolor = Config.Weightlesscolor.col
		        cs.border = 100
		      elseif selected then
		        cs.bordercolor = Config.bordercolor.col
		        cs.border = 100
		      else
		        if self isa polygon  then
		          cs.bordercolor = colcotes(i).col
		        elseif self isa bande then
		          cs.bordercolor = self.bordercolor.col
		        else
		          cs.bordercolor = Config.bordercolor.col
		        end if
		        cs.border = 100
		      end if
		    next
		    
		  else
		    if hidden and highlighted Then
		      sk.updatebordercolor(Config.highlightcolor.col, 100)
		      sk.updatefillcolor(fillcolor.col,0)
		    elseif hidden Then
		      sk.updatebordercolor(cyan, 100)
		      sk.updatefillcolor(fillcolor.col,0)
		    elseif tsp and Highlighted then
		      sk.updatefillcolor(fillColor.col,0)
		      sk.updatebordercolor(Config.highlightcolor.col,100)
		    elseif tsp then
		      sk.updatefillcolor(fillColor.col,0)
		      sk.updatebordercolor(BorderColor.col,100)
		    elseif highlighted and selected then
		      sk.updatebordercolor(Config.highlightcolor.col,100)
		      'sk.updatefillcolor(grey.col,100)
		    elseif highlighted  then
		      sk.updatefillcolor(fillColor.col,fill)
		      sk.updatebordercolor(Config.highlightcolor.col,100)
		    elseif selected and fillcolor.equal(white) then
		      sk.updatebordercolor(BorderColor.col, 100)
		      'sk.updatefillcolor(grey.col,100)
		    elseif isinconstruction then
		      sk.updatefillcolor(Config.Weightlesscolor.col,0)
		      sk.updatebordercolor(Config.Weightlesscolor.col,100)
		    else
		      sk.updatefillcolor(Fillcolor.col,fill)
		      sk.updatebordercolor(BorderColor.col,border)
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fixeepaisseurs()
		  
		  if highlighted or isinconstruction  or selected then
		    sk.updateborderwidth(2*borderwidth)
		  else
		    sk.updateborderwidth(borderwidth)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SameType(s as shape) As Boolean
		  return (gettype = s.gettype) or (self isa polygon and s isa polygon and s.npts = npts)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadCondi(Temp as XMLElement)
		  dim s as shape
		  dim m as integer
		  dim p as point
		  
		  s = Currentcontent.TheObjects.GetShape(val(Temp.GetAttribute("Id")))
		  m = val(Temp.GetAttribute("Condby"))
		  if m >0 then
		    p = point(currentcontent.TheObjects.GetShape(m))
		    s.conditionedby = p
		    p.conditioned.addshape s
		    if p.invalid then
		      s.invalider
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function aire() As double
		  return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbPtsCommuns(sh As shape) As integer
		  dim i, n as integer
		  
		  for i = 0 to ubound(childs)
		    if sh.getindexpoint(childs(i)) <> -1 then
		      n = n+1
		    end if
		  next
		  
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub enabletoupdatelabel()
		  dim i as integer
		  
		  labupdated = false
		  for i = 0 to ubound(childs)
		    childs(i).enabletoupdatelabel
		  next
		  
		  for i = 0 to ubound(constructedshapes)
		    constructedshapes(i).enabletoupdatelabel
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbTrueSomCommuns(f as figure) As integer
		  dim i, j, n, n0 as integer
		  
		  n0 = 0
		  
		  if not self isa point then
		    for i = 0 to npts-1
		      if f.somm.getposition(points(i)) <> -1  then
		        n0 = n0+1
		      end if
		    next
		  else
		    if f.somm.getposition(self) <> -1  then
		      n0 = 1
		    end if
		  end if
		  
		  return n0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function haspointsimages(sh as shape) As boolean
		  dim t as Boolean
		  dim i as integer
		  
		  for i = 0 to ubound(points)
		    t = t or (points(i).constructedby <> nil and points(i).constructedby.oper = 6 and sh.getindexpoint(point(points(i).constructedby.shape)) <> -1)
		  next
		  return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function longueur(n as integer) As double
		  dim dr as droite
		  
		  if self isa polygon then
		    dr = polygon(self).getside(n)
		    return dr.longueur
		  elseif self isa droite then
		    return droite(self).longueur
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddMacConstructedShape(s as shape)
		  dim i as Integer
		  
		  for i=0 to UBound(MacConstructedShapes)
		    if MacConstructedShapes(i) = s then
		      return
		    end if
		  next
		  
		  MacConstructedShapes.Append s
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutIdChildsInContainer(Doc as XMLDocument) As XMLElement
		  dim Temp as XMLElement
		  dim i as integer
		  
		  Temp = Doc.CreateElement("Childs")
		  for i = 0 to  Ubound(childs)
		    Temp.AppendChild Childs(i).XMLPutIdInContainer(Doc)
		  next
		  return Temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatecoord()
		  //updatecoord doit appara^tre dans endmove (à l'issue des mouvements) et updateshape (à l'issue des modifications)
		  
		  select case npts
		  case 2
		    coord = new BiBPoint(self)
		  case 3
		    coord = new TriBPoint(self)
		  else
		    coord = new nBPoint(self)
		  end select
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddToCurrentcontent()
		  CurrentContent.addshape self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As string
		  dim s as String
		  
		  s = "{id : "+str(id)+", IDGroupe : "+str(IDGroupe)+"}"
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createskull(p as BasicPoint)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Identifiant() As string
		  dim m as string
		  dim i as integer
		  
		  m = gettype + " "
		  
		  if self isa point then
		    if point(self).getlab <> "" then
		      m = m+ point(self).getlab
		    else
		      m = m + "*"
		    end if
		  else
		    for i = 0 to npts-1
		      if points(i).getlab <> "" then
		        m  = m + points(i).getlab
		      else
		        m = m +"*"
		      end if
		    next
		  end if
		  
		  return m
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateMacConstructedShapes()
		  dim Mac as Macro
		  dim MacInfo as MacConstructionInfo
		  dim i, j as integer
		  dim s1 as shape
		  
		  for i = 0 to ubound(MacConstructedShapes)
		    s1 = MacConstructedShapes(i)
		    MacInfo = s1.MacConstructedby
		    Mac = Macinfo.Mac
		    Mac.Macexe(MacInfo)
		    
		    for j = 0 to ubound(s1.childs)
		      if not s1.childs(j).modified and  s1.childs(j).macconstructedby = nil then
		        s1.childs(j).updateshape
		        s1.childs(j).modified = true
		      end if
		    next
		    s1.updateshape
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computediam()
		  dim i , j as integer
		  
		  diam = 0
		  
		  for i = 0 to npts-2
		    for j = i+1 to npts-1
		      diam= max(diam, points(i).bpt.distance(points(j).bpt))
		    next
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computearcangle()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveExtreCtrl(M as Matrix)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateExtreAndCtrlPoints()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetIndexPoint(p as BasicPoint) As integer
		  dim i as integer
		  
		  if not self isa point then
		    for i = 0 to npts-1
		      if points(i).bpt = p then
		        return i
		      end if
		    next
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function fused() As boolean
		  return constructedby <> nil and (constructedby.oper = 9)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoMerge(Temp as XMLElement)
		  dim EL0, EL1, EL2 as XMLElement
		  dim Fus1, Fus2, Fus as shape
		  dim pt, q as point
		  dim n, i as integer
		  dim M1, M2 as Matrix
		  
		  //Temp est le "constructedby", Deux "childs", de 0 à 1
		  //EL0 est l'identifiant de Fus1, etc..
		  
		  if not self isa point then
		    EL0 = XMLElement(Temp.child(0))
		    Fus1 = Polygon(Objects.Getshape(val(EL0.GetAttribute("Id"))))
		    constructedby.data.append Fus1
		    M1 =new Matrix(EL0)
		    constructedby.data.append M1
		    Fus1.AddConstructedShape self
		    
		    EL0 = XMLElement(Temp.child(1))
		    Fus2 = Polygon(Objects.Getshape(val(EL0.GetAttribute("Id"))))
		    constructedby.data.append Fus2
		    M2 = new Matrix(EL0)
		    constructedby.data.append new Matrix(EL0)
		    Fus2.AddConstructedShape self
		    
		  else
		    
		    Fus =  Polygon(Objects.Getshape(val(Temp.GetAttribute("IdParent"))))
		    M1 = Matrix(Fus.Constructedby.data(1))
		    M2 = Matrix(Fus.Constructedby.data(3))
		    n = val(Temp.GetAttribute("Constructedby"))
		    if n <> 0 then
		      q = Point(Objects.Getshape(n))
		      SetConstructedBy q, 9
		      constructedby.data.append M1
		    else
		      SetConstructedBy nil, 9
		      n = val(Temp.GetAttribute("ConstructedbyId1"))
		      q = Point(Objects.Getshape(n))
		      constructedby.data.append q
		      constructedby.data.append M1
		      q.AddConstructedShape self
		      n = val(Temp.GetAttribute("ConstructedbyId2"))
		      q = Point(Objects.Getshape(n))
		      constructedby.data.append q
		      constructedby.data.append M2
		      q.AddConstructedShape self
		    end if
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PossibleDrag() As Boolean
		  dim j, k, m as integer
		  dim ffbut as figure
		  
		  for j = 0 to tsfi.count-1
		    for k = 0 to tsfi.element(j).constructedfigs.count -1
		      if  tsfi.element(j).type <> 1 then
		        ffbut = tsfi.element(j).constructedfigs.element(k)
		        for m = 0 to  ubound(ffbut.Constructioninfos)
		          if (ffbut.ConstructionInfos(m).tsf = tsfi.element(j)) and (ffbut = ffbut.ConstructionInfos(m).Sourcefig) and (ffbut <> fig) then
		            return false
		          end if
		        next
		      end if
		    next
		  next
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function noinvalidpoints() As boolean
		  dim i as integer
		  dim t as Boolean
		  
		  t = true
		  
		  if not self isa point then
		    for i = 0 to npts-1
		      t = t and not points(i).invalid
		    next
		  else
		    t = not invalid
		  end if
		  return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PaintTip(u as BasicPoint, v as BasicPoint, col as couleur, sc as double, g as graphics)
		  dim a, b as BasicPoint
		  dim can as Mycanvas
		  
		  can = wnd.MyCanvas1
		  a = can.transform(u)
		  b = can.transform(v)
		  Ti.updatetip(a,b,col)
		  Ti.scale = sc
		  g.DrawObject Ti, b.x, b.y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValidSegment(p as BasicPoint, byref side as integer) As Boolean
		  if self isa droite and droite(self).nextre = 2 then
		    side = 0
		    return true
		  elseif self isa polygon then
		    side = polygon(self).pointonside(p)
		    if side <> -1 then
		      return true
		    end if
		  end if
		  side = -1
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub highlightsegment(g as graphics, cot as integer)
		  if self isa polygon and cot <> -1   then
		    unhighlight
		    paintside(g,cot,2,Config.highlightcolor)
		  elseif self isa droite then
		    highlight
		    paintall(g)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub increasedecimals()
		  dim i as integer
		  dim lab as label
		  
		  for i = 0 to labs.count-1
		    Lab = labs.element(i)
		    lab.p =Lab.p +1
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub decreasedecimals()
		  dim i as integer
		  dim lab as label
		  
		  for i = 0 to labs.count-1
		    Lab = labs.element(i)
		    if lab.p >= 1 then
		      lab.p =Lab.p -1
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub repositionnerpoints()
		  dim j as integer
		  
		  if self isa point then
		    point(self).moveto coord.tab(0)
		  else                  //On va rechercher la forme
		    for j = 0 to ubound(points)
		      points(j).moveto coord.tab(j)   //On repositionne les sommets
		      points(j).modified = true
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape()
		  dim i as integer
		  dim d as double
		  
		  d = Points(0).bpt.distance(Points(1).bpt)
		  
		  if d > 0 then
		    coord = new nBPoint
		    for i = 0 to ncpts-1
		      coord.append Points(i).bpt
		    next
		    coord.constructshape(fam,forme)
		    repositionnerpoints
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBibSide(i as integer) As BiBPoint
		  
		  
		  return new BiBPoint(coord.tab(i), coord.tab((i+1) mod npts))
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutMacConstructionInfoInContainer(Doc as XMLDocument) As XMLElement
		  dim Temp as XMLElement
		  
		  Temp = Doc.CreateElement("MacConstructedBy")
		  Temp.SetAttribute("Macro",MacConstructedby.Mac.Caption)
		  Temp.AppendChild MacConstructedBy.XMLPutInContainer(Doc)
		  
		  return Temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadMacConstructionInfo(Temp as XMLElement)
		  dim List as XmlNodeList
		  dim Tmp as XmlElement
		  dim m as integer
		  dim s as shape
		  dim cap as string
		  dim MacInfo as MacConstructionInfo
		  dim Mac as Macro
		  
		  List = Temp.XQL("MacConstructedBy")
		  if List.Length > 0 then
		    Tmp = XMLElement(List.Item(0))
		    cap = TMP.GetAttribute("Macro")
		    Mac =app.TheMacros.GetMacro(cap)
		    MacInfo = new MacConstructionInfo(Mac,Tmp)
		    SetMacConstructedBy MacInfo
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetMacConstructedBy(MacInfo as MacConstructionInfo)
		  dim i as integer
		  dim s as shape
		  
		  MacConstructedBy = MacInfo
		  for i = 0 to ubound(MacInfo.RealInit)
		    s = currentcontent.TheObjects.getshape(macinfo.RealInit(i))
		    s.AddMacConstructedShape self
		  next
		End Sub
	#tag EndMethod


	#tag Note, Name = Formes
		
		
		Premier constructeur: utilisé pour la définition d'une forme "au clavier"
		
		a) Attribution d'une Id
		b) Définition de la liste d'objets qui comprendra le nouvel objet.
		c) fixation de la couleur du trait et de la couleur du fond
		d) La variable "degree" devient le   Ncpts
		                       
		                           C'est la seule information requise pour construire une forme
	#tag EndNote

	#tag Note, Name = Npts et Ncpts
		
		Npts est le nombre de points d'une forme. 
		Par exemple: le nombre de sommets d'un polygone.
		Pour un segment, une droite ou un cercle libre : 2
		Pour un cercle standard: 1
		
		Ncpts est le nombre de points à fixer par l'utilisateur
		lors d'une construction à la souris.
	#tag EndNote

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
		id As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		selected As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected objects As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		Childs(-1) As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		Hidden As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Highlighted As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ConstructedBy As ConstructionInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		ConstructedShapes(-1) As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		GC As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		sk As skull
	#tag EndProperty

	#tag Property, Flags = &h0
		Bordercolor As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		Fillcolor As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		Points(-1) As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		npts As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ncpts As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Borderwidth As double
	#tag EndProperty

	#tag Property, Flags = &h0
		Border As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Fill As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		std As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Ori As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		fam As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		forme As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Modified As Boolean = false
	#tag EndProperty

	#tag Property, Flags = &h0
		IDGroupe As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		tsp As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		tsfi As TransfosList
	#tag EndProperty

	#tag Property, Flags = &h0
		Liberte As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Attracting As boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Invalid As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Fig As Figure
	#tag EndProperty

	#tag Property, Flags = &h0
		Labs As Lablist
	#tag EndProperty

	#tag Property, Flags = &h0
		firstcurrentattractingshape As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		Mmove As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		OldIdGroupes(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ListSommSur(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		unmodifiable As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		auto As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		TracePt As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		PtsofSource() As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		colcotes(-1) As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		IsInConstruction As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		IndexConstructedPoint As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		labupdated As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		colsw As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		nonpointed As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Ti As Tip
	#tag EndProperty

	#tag Property, Flags = &h0
		conditionedby As point
	#tag EndProperty

	#tag Property, Flags = &h0
		drapori As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		signaire As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		final As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		init As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		interm As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		coord As nBPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		MacConstructedby As MacConstructionInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		MacConstructedShapes() As Shape
	#tag EndProperty

	#tag Property, Flags = &h0
		plan As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		deleted As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		tobereconstructed As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		diam As double
	#tag EndProperty

	#tag Property, Flags = &h0
		nsk As nskull
	#tag EndProperty

	#tag Property, Flags = &h0
		NotPossibleCut As Boolean
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
			Name="id"
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
			Name="npts"
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
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="std"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ori"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fam"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="forme"
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
			Name="IDGroupe"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tsp"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Liberte"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Attracting"
			Group="Behavior"
			InitialValue="True"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Invalid"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncpts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="unmodifiable"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="auto"
			Group="Behavior"
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
			Name="IsInConstruction"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IndexConstructedPoint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="labupdated"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsw"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nonpointed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapori"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="signaire"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="final"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="init"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="interm"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="plan"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="deleted"
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
			Name="diam"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotPossibleCut"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
