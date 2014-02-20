#tag Class
Protected Class ObjectsList
	#tag Method, Flags = &h0
		Function element(idx As Integer) As Shape
		  if idx>=0 and idx<=Ubound(objects) then
		    return objects(idx)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function count() As integer
		  return Ubound(objects)+1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub addShape(s as Shape)
		  dim i As integer
		  dim t as shape
		  dim pt as point
		  if s = nil   then
		    return
		  end if
		  
		  if s isa point then
		    pt = point(s)
		    for i = 0 to ubound(pt.parents)
		      t = pt.parents(i)
		      if getposition(t) > -1 and t.getindexpoint(pt) <> -1 then
		        return
		      end if
		    next
		  end if
		  if GetPosition(s)  = -1 then
		    objects.append s
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub unselectAll()
		  dim i As Integer
		  for i=0 to selection.count-1
		    selection.element(i).DoUnselect
		  next
		  selection.removeAll
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function findObject(p as BasicPoint) As ObjectsList
		  
		  dim i As Integer
		  dim S1, s2 as Shape
		  dim Visible as ObjectsList
		  
		  Visible = new objectslist
		  
		  for i=Ubound(currentcontent.Plans) downto 0
		    S1=GetShape(currentcontent.Plans(i))
		    if not s1.deleted then
		      s1=s1.SelectShape(p)
		      if s1 <> nil then
		        if s1 isa bipoint and not (s1 isa droite or s1 isa supphom)  then
		          s1 = findpoint(p).element(0)
		        end if
		        if  s1 <> nil and not s1.invalid and not s1.deleted then
		          Visible.addshape S1
		        end if
		      end if
		    end if
		  next
		  return Visible
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removeShape(s As Shape)
		  dim i as integer
		  
		  if objects.indexof(s) <> -1 then
		    objects.remove objects.indexof(s)
		  end if
		  
		  i = ubound(groupes)
		  while i > -1 and groupes(i).getposition(s) = -1
		    i = i-1
		  wend
		  
		  if i >-1 then
		    groupes(i).removeshape s
		    optimizegroups
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ObjectsList()
		  selection = new ObjectsList(false)
		  prevId = -1
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removeAll()
		  redim objects(-1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ObjectsList(initSelection As Boolean)
		  
		  if initSelection then
		    selection = new ObjectsList(false)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub selectObject(s As Shape)
		  if s <> nil  then
		    selection.addShape s
		    s.doSelect
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub unSelectObject(s As Shape)
		  
		  selection.removeShape s
		  s.doUnSelect
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(id as integer) As shape
		  
		  dim i as Integer
		  dim temp as Shape
		  
		  
		  
		  for i=0 to Ubound(objects)
		    if  not objects(i).deleted then   'not objects(i).invalid and
		      temp=GetShapeIn(objects(i),id)
		      if temp<>nil then
		        return temp
		      end if
		    end if
		  next
		  return nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShapeIn(s as Shape, id as Integer) As shape
		  
		  dim i as Integer
		  dim temp as Shape
		  
		  if s=nil then
		    return nil
		  end if
		  
		  if s.id=id then
		    return s
		  else
		    for i=0 to Ubound(s.Childs)
		      if s.Childs(i).id = id  then
		        return s.childs(i)
		      end if
		    next
		    for i = 0 to ubound(s.constructedshapes)
		      if s.constructedshapes(i).centerordivpoint and s.constructedshapes(i).id = id then
		        return s.ConstructedShapes(i)
		      end if
		    next
		    return nil
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Optimize()
		  
		  //Retire de la liste les points qui ont des parents
		  dim pt as point
		  dim i as Integer
		  
		  for i = UBound(Objects) downto 0
		    if objects(i) isa point then
		      pt = point(objects(i))
		      if Ubound(pt.parents) >-1 and (pt.constructedby = nil or pt.constructedby.oper = 10)  then
		        Objects.remove i
		      end if
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPosition(s As Shape) As Integer
		  return objects.indexof(s)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowAll()
		  
		  dim i as Integer
		  
		  for i=0 to Ubound(Objects)
		    Objects(i).Show
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindPoint(p as BasicPoint) As ObjectsList
		  dim i, j As Integer
		  dim S as Shape
		  dim pt as point
		  dim Visible as ObjectsList
		  
		  Visible = new objectslist
		  
		  for i=Ubound(currentcontent.plans) downto 0
		    S=GetShape(currentcontent.plans(i))
		    if s <> nil   then
		      if s isa point and (not s.invalid) and (not s.deleted) and (not s.Hidden or wnd.DrapShowALL)   and point(s).pinshape(p)  then
		        visible.addshape  point(s)
		      else
		        for j = 0 to ubound(s.childs)
		          pt = s.childs(j)
		          if (not pt.invalid) and not (pt.deleted) and  (not pt.Hidden or wnd.DrapShowALL)   and pt.pinshape(p)  then
		            visible.addshape pt
		          end if
		        next
		      end if
		    end if
		    
		  next
		  
		  return Visible
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NewId() As Integer
		  prevId = prevId + 1
		  return prevId
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CheckId(i as integer)
		  if i>prevId then
		    prevId=i
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updateskull()
		  dim i ,j as Integer
		  
		  for i=0 to Ubound(Objects)
		    for j = 0 to Ubound(Objects(i).Childs)
		      Objects(i).childs(j).updateskull
		    next
		    Objects(i).Updateskull
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetId(n as integer)
		  PrevId = n
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLLoadObject(Temp as XMLElement) As Shape
		  dim  fam, forme, id, pl as Integer
		  dim a as integer
		  dim fstd as String
		  dim s as shape
		  
		  
		  id = Val(Temp.GetAttribute("Id"))
		  s = getshape(id)
		  
		  
		  if s <> nil then
		    return s
		  end if
		  
		  fam = Val(Temp.GetAttribute(Dico.Value("NrFam")))
		  forme = Val(Temp.GetAttribute(Dico.Value("NrForm")))
		  a = Val(Temp.GetAttribute(Dico.Value("Auto")))             // pour d'anciens fichiers de sauvegarde (jusqu'à la version.3.8) qui étaient incorrects
		  select case  fam
		  case -1
		    s = new Repere(self,temp)
		    CurrentContent.OpenOpList                                     // remplacement de la liste d'opérations pour éliminer la création précédente du repère
		    CurrentContent.CreateFigs
		    wnd.MyCanvas1.Setrepere(Repere(s))
		  case 0
		    s = new Point(self,Temp)
		  case 1
		    select case forme
		    case -2
		      s = new SuppHom(self,Temp)
		    case -1
		      s = new BiPoint(self,temp)
		    case 0 to 6
		      s = new Droite(self,  forme , Temp)
		    case 7
		      s = new Bande(self,temp)
		    case 8
		      s = new Secteur(self, temp)
		    end select
		  case 2
		    select case forme
		    case 0
		      s =  new Polyqcq(self, temp)
		    case 1
		      s =  new TriangIso(self, temp)
		    case 2
		      s =  new Polreg(self, temp)
		    case 3
		      s =  new TriangRect(self, temp)
		    case 4
		      s =  new TriangRectIso(self, temp)
		    end select
		  case 3
		    select case forme
		    case 0
		      s = new Polyqcq(self,temp)
		    case 1
		      s = new Trap(self,temp)
		    case 2
		      s = new TrapRect(self,temp)
		    case 3
		      s = new TrapIso(self,temp)
		    case 4
		      s = new Parallelogram(self,temp)
		    case 5
		      s = new Rect(self,temp)
		    case 6
		      s = new Losange(self,temp)
		    case 7
		      s = new Polreg(self,temp)
		    end select
		  case 4
		    s = new Polreg(self,temp)
		  case 5
		    select case forme
		    case 0
		      s = new FreeCircle(self,temp)
		    case 1
		      s = new Arc(self,temp)
		    end select
		  case 6
		    s = new Polyqcq(self,temp)
		  case 7
		    s = new Lacet(self,temp)
		  else
		    fstd = Temp.GetAttribute("StdFile")
		    if fstd <> "" and fstd <> Config.stdfile then
		      Config.setStdFile(fstd)
		    end if
		    s = XMLLoadStdForm (temp)
		  end select
		  
		  s.id = id
		  addshape(s)
		  
		  if  Val(Temp.GetAttribute("Standard"))= 1 then
		    s.std = true
		  else
		    s.std = false
		  end if
		  If Val(Temp.GetAttribute("IdGroupe")) <> -1 then
		    s.IdGroupe = val(Temp.GetAttribute("IdGroupe"))
		    if Ubound(Groupes) < s.IdGroupe then
		      Redim Groupes(s.idGroupe)
		    end if
		    if Groupes(s.IdGroupe) = nil then
		      Groupes(s.IdGroupe) = new ObjectsList
		    end if
		    Groupes(s.IdGroupe).addShape s
		  else
		    s.IdGroupe = -1
		  end if
		  s.signaire = sign(s.aire)
		  
		  return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnableModifyAll()
		  dim i,j as integer
		  
		  for i = 0 to count-1
		    element(i).enablemodify
		    for j = 0 to ubound(element(i).constructedshapes)
		      Element(i).constructedshapes(j).enablemodify
		    next
		    element(i).Modified = false
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateids()
		  dim i,j,n as integer
		  n = 0
		  for i = 0 to Ubound(objects)
		    n = max(n, objects(i).id)
		    for j = 0 to Ubound(objects(i).childs)
		      n = max(n, objects(i).childs(j).id)
		    next
		  next
		  setid(n)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub selectall()
		  dim i , j as integer
		  dim ob as shape
		  
		  
		  for i=1 to Ubound(objects)
		    ob =objects(i)
		    if not ob.invalid  and not ob.deleted then
		      selectobject(ob)
		    end if
		    for j = ob.npts to ubound(ob.childs)
		      if ob.childs(j).isolated then
		        selectobject(ob.childs(j))     //sinon les points "sur" qui sont des sommets seraient sélectionnés deux fois
		      end if
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLLoadStdForm(Temp as XMLElement) As Shape
		  dim nom as string
		  
		  nom = Temp.GetAttribute("Type")
		  
		  select case nom
		  case Dico.Value("PolygStd")
		    return new StandardPolygon(self, temp)
		  case Dico.Value("CercleStd")
		    return new StdCircle(self, temp)
		  case Dico.Value("Cube")
		    return new Cube(self, temp)
		  end select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutIdInContainer(Doc as XMLDocument) As XMLElement
		  Dim Temp as XmlElement
		  dim i as integer
		  
		  
		  if count > 0 then
		    Temp = Doc.CreateElement(Dico.Value("Forms"))
		    for i  = 0 to Ubound(objects)
		      Temp.appendchild objects(i).XMLPutIdinContainer(Doc)
		    next
		    return Temp
		  else
		    return nil
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReverseFindObject(p as BasicPoint) As shape
		  dim i As Integer
		  dim S as Shape
		  for i=0 to Ubound(Objects)
		    if (not Objects(i).Hidden or wnd.DrapShowALL)  and not objects(i).invalid and (not objects(i).deleted) then
		      S=Objects(i).SelectShape(p)
		      if S<>nil then
		        return S
		      end if
		    end if
		  next
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateUserCoord(M as Matrix)
		  dim i  as Integer
		  
		  for i=0 to Ubound(Objects)
		    Objects(i).UpdateUserCoord(M)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsSame(obl as ObjectsList) As Boolean
		  dim i as integer
		  
		  For i = 0 to count-1
		    if element(i) <> obl.element(i) then
		      return false
		    end if
		  next
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLLoadObjects(Shapes as XMLElement)
		  dim Obj As XMLElement
		  dim List as XMLNodeList
		  dim nobj, i, j as integer
		  dim s as shape
		  
		  List = Shapes.XQL(Dico.Value("Objects"))
		  
		  If list.Length > 0 then
		    Obj= XMLElement(List.Item(0))
		    nobj = obj.childcount
		    if nobj >0 then
		      XMLLireobjets(Obj)                                  //ne met pas en cause les figures
		      XMLLirePointsSur(Obj)
		      XMLReadTsf(Obj)                                    //non plus
		      XMLLireCondi(Obj)
		      XMLLireConstructionInfos(Obj)           //non plus
		      XMLLireMacConstructionInfos(Obj)
		      XMLLireIdFigs(Obj)
		      CurrentContent.TheTransfos.CleanConstructedFigs
		      SetFigConstructionInfos(Obj)
		      CurrentContent.optimize
		    end if
		    updateids
		  end if
		  for i = 0 to CurrentContent.TheObjects.count-1
		    s=  CurrentContent.TheObjects.element(i)
		    if s.id =0 and not s isa repere then
		      s.id = newid
		    end if
		    for j = 0 to ubound(s.childs)
		      if s.childs(j).id = 0 then
		        s.childs(j).id = newid
		      end if
		    next
		  next
		  List = Shapes.XQL(Dico.Value("ToolsGrid"))
		  if List.length > 0 then
		    XMLLoadGrille(List)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  dim i  As  integer
		  dim EL as XMLElement
		  dim  MAG as XMLElement
		  
		  optimize
		  
		  EL =  Doc.CreateElement(Dico.Value("Objects"))
		  
		  for i=0 to UBound(Objects)
		    EL.AppendChild(objects(i).XMLPutInContainer(Doc))
		  next
		  
		  return EL
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reselect()
		  dim i as integer
		  dim ob as shape
		  
		  Unselectall
		  
		  for i=0 to Oldselection.count -1
		    ob =Oldselection.element(i)
		    if not ob.Hidden and not ob.invalid and not ob.deleted then
		      selection.addShape ob
		      ob.doSelect
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReAttractingAll()
		  dim i,j as integer
		  
		  for i = 0 to count-1
		    element(i).Attracting = True
		    for j = 0 to ubound (element(i).Childs)
		      element(i).Childs(j).Attracting = true
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SwapObjects(S1 as Shape, S2 as Shape)
		  dim pos1, pos2 as integer
		  
		  pos1 = GetPosition(S1)
		  pos2 = GetPosition(S2)
		  
		  if pos1 <> -1 and pos2 <>-1 then
		    objects(pos1) = S2
		    objects(pos2) = S1
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertShape(S As Shape, n as integer)
		  dim i As integer
		  dim t as shape
		  
		  if GetPosition(s)  = -1 then
		    objects.insert (n,S)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Concat(ol as objectslist)
		  dim i as integer
		  
		  for i = 0 to ol.count-1
		    concat ol.element(i)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub selectfigure(figu as figure)
		  dim i as integer
		  
		  for i = 0 to figu.shapes.count-1
		    selectobject(figu.shapes.element(i))
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub unhighlightall()
		  dim i as integer
		  
		  for i =  ubound(objects) downto 0
		    objects(i).unhighlight
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub concat(s As Shape)
		  if GetPosition(s)  = -1  then
		    objects.append s
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub addconstruction(s As Shape)
		  
		  s.endconstruction             // on met en particulier s dans une figure (ff reste nil)
		  s.setfigconstructioninfos
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLLireObjets(Obj as XMLElement)
		  dim i as integer
		  dim s as shape
		  dim Temp as XMLElement
		  
		  for i=0 to Obj.ChildCount-1
		    Temp = XMLElement(Obj.Child(i))
		    s = XMLLoadObject(Temp)
		  next
		  OptimizeGroups
		  currentcontent.createplans
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLLirePointsSur(Obj as XMLelement)
		  dim i, fam  as integer
		  dim s as shape
		  dim List1 as XMLNodeList
		  dim Temp as XMLelement
		  
		  for i=0 to Obj.ChildCount-1
		    Temp = XMLElement(Obj.Child(i))
		    fam = val(Temp.GetAttribute(Dico.Value("NrFam")))
		    if fam > 0 then
		      s = GetShape(val(Temp.GetAttribute("Id")))
		      s.XMLReadPtsSur(Temp)
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLLireConstructionInfos(Obj as XMLElement)
		  dim i, j as integer
		  dim s as shape
		  dim List1 as XMLNodeList
		  dim Pt as XMLNode
		  dim Temp as XMLElement
		  dim fam as integer
		  
		  for i=0 to Obj.ChildCount-1
		    Temp = XMLElement(Obj.Child(i))
		    fam = val(Temp.GetAttribute(Dico.value("NrFam")))
		    if fam > -1 then
		      s = GetShape(val(Temp.GetAttribute("Id")))
		      s.XMLReadConstructionInfo(Temp)
		      List1 = Temp.XQL("Childs")
		      if List1.length > 0 then
		        Pt = List1.Item(0)
		        for j = 0 to Pt.Childcount-1
		          s.childs(j).XMLReadConstructionInfo(XMLElement(Pt.child(j)))
		          s.childs(j).mobility
		          s.childs(j).updateguides
		        next
		      end if
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLLoadGrille(List as XMLNodeList)
		  dim Obj as XMLElement
		  dim gs as integer
		  
		  
		  Obj= XMLElement(List.Item(0))
		  gs = val(Obj.GetAttribute("PointSize"))
		  select case val(Obj.Getattribute("Type"))
		  case 0
		    CurrentContent.TheGrid= nil
		  case 1
		    CurrentContent.TheGrid = new SquareGrid(gs)
		  case 2
		    CurrentContent.TheGrid = new HexGrid(gs)
		  end select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub inverserordre()
		  dim s1, s2 as shape
		  dim i as integer
		  
		  if count > 1 then
		    for i = 0 to count\2 -1
		      s1 = element(i)
		      s2 = element(count-1-i)
		      CurrentContent.TheObjects.SwapObjects(s1,s2)
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLLireIdFigs(Obj as XMLElement)
		  dim i, idf, fam, n as integer
		  dim s as shape
		  dim Temp as XMLElement
		  dim ff as figure
		  
		  for i=0 to Obj.ChildCount-1
		    Temp = XMLElement(Obj.Child(i))
		    fam = val(Temp.GetAttribute(Dico.value("NrFam")))
		    if fam > -1 then
		      s = GetShape(val(Temp.GetAttribute("Id")))
		      idf = val(Temp.GetAttribute("FigId"))
		      if idf = 0  then
		        addconstruction(s)
		        s.addtofigurecutinfos                          //pour les anciens fichiers
		      else
		        ff = CurrentContent.TheFigs.GetFigure(idf)     //on insère directement dans la figure du bon numéro sans devoir faire tout le travail de structuration
		        s.addtofigure(ff, idf)                                            //il suffit de lister les figures à créer et leur contenu
		      end if
		    end if
		  next
		  
		  n = 0
		  for i = 0 to CurrentContent.TheFigs.Count-1
		    CurrentContent.TheFigs.element(i).ListerPrecedences
		    idf = CurrentContent.Thefigs.element(i).idfig
		    n = max(n, idf)
		  next
		  
		  CurrentContent.TheFigs.setidfig (n)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub canceldejaexporte()
		  dim i, j as integer
		  dim s as shape
		  
		  for i = 0 to count-1
		    s = element(i)
		    for j = 0 to ubound(s.childs)
		      s.childs(j).dejaexporte = false
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatelabels(k as double)
		  dim i as integer
		  
		  for i = 0 to count-1
		    element(i).updatelabel(k)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFigConstructionInfos(Obj as XMLelement)
		  dim i, fam as integer
		  dim Temp as XMLElement
		  dim s as shape
		  
		  for i=0 to Obj.ChildCount-1
		    Temp = XMLElement(Obj.Child(i))
		    fam = val(Temp.GetAttribute(Dico.value("NrFam")))
		    if fam > -1 then
		      s = GetShape(val(Temp.GetAttribute("Id")))
		      s.setfigconstructioninfos
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function findbipoint(p as BasicPoint) As ObjectsList
		  
		  dim n, i As Integer
		  dim Visible as ObjectsList
		  dim ob as shape
		  
		  Visible = new objectslist
		  
		  for i=Ubound(currentcontent.Plans) downto 0
		    ob = GetShape(currentcontent.Plans(i))
		    n = -1
		    if ob isa droite and ob.PinShape(p) then
		      n = 0
		    elseif ob isa polygon then
		      n=Ob.pointonside(p)
		    end if
		    if n <> -1 and not ob.invalid and not ob.deleted  then
		      Visible.addshape ob
		    end if
		  next
		  
		  return Visible
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OptimizeGroups()
		  dim i, j as integer
		  
		  for i = ubound(groupes) downto 0
		    if groupes(i) = nil or groupes(i).count = 0 then
		      groupes.remove i
		    end if
		  next
		  
		  for i = 0 to ubound(groupes)
		    for j = 0 to Groupes(i).count-1
		      Groupes(i).element(j).IdGroupe = i
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub affichergroupe(n as integer, c as color, g as graphics)
		  dim s as shape
		  dim i  as integer
		  dim p as BasicPoint
		  
		  g.forecolor = c
		  
		  if groupes(n) <> nil then
		    for i=0 to Groupes(n).count-1
		      s = Groupes(n).element(i)
		      p = wnd.mycanvas1.transform(s.GetGravitycenter)
		      g.DrawString("Groupe "+str(n),p.x-20, p.y+5)
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndConstruction()
		  dim i as integer //utilisé uniquement par divide
		  
		  for i = 0 to count-1
		    point(element(i)).mobility
		    CurrentContent.addShape element(i)
		  next
		  
		  if  CurrentContent.ForHisto then
		    addtofigure
		  end if
		  Unselectall
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub addtofigure()
		  //Cette méthode ne sert que lors de la création de points de subdivision
		  
		  dim i, j as integer
		  dim  ff, ff1 as figure
		  dim s as shape
		  
		  s = Element(0).constructedby.shape
		  ff = s.fig
		  ff1 = s.getsousfigure(ff)
		  
		  CurrentContent.TheFigs.RemoveFigure s.fig
		  
		  for i =  0 to count-1
		    ff.ptsconsted.addshape element(i)
		    ff1.ptsconsted.addshape element(i)
		    element(i).fig = ff
		  next
		  ff.ListerPrecedences
		  ff.idfig = -1
		  CurrentContent.TheFigs.AddFigure ff
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub tspfalse()
		  dim i as integer
		  
		  for i = 0 to count-1
		    element(i).tsp = false
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub validatefrom(s as shape)
		  dim i as integer
		  
		  
		  for i = 0 to count-1
		    if not element(i).deleted and element(i).invalid and element(i).id > s.id and element(i).hascommonpointwith(s) then
		      element(i).valider
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub invalidatefrom(s as shape)
		  dim i as integer
		  
		  
		  for i = 0 to count-1
		    if not element(i).deleted and not element(i).invalid and element(i).id > s.id and element(i).hascommonpointwith(s) then
		      element(i).invalider
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLLireCondi(Obj as XMLelement)
		  dim i, j as integer
		  dim s as shape
		  dim p as point
		  dim List1 as XMLNodeList
		  dim Pt as XMLNode
		  dim Temp as XMLElement
		  dim fam as integer
		  
		  for i=0 to Obj.ChildCount-1
		    Temp = XMLElement(Obj.Child(i))
		    fam = val(Temp.GetAttribute(Dico.value("NrFam")))
		    if fam > -1 then
		      s = GetShape(val(Temp.GetAttribute("Id")))
		      s.XMLReadCondi(Temp)
		      List1 = Temp.XQL("Childs")
		      if List1.length > 0 then
		        Pt = List1.Item(0)
		        for j = 0 to Pt.Childcount-1
		          s = GetShape(val(XMLElement(Pt.Child(j)).GetAttribute("Id")))
		          s.XMLReadCondi(XMLElement(Pt.Child(j)))
		        next
		      end if
		    end if
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadTsf(Obj as XMLElement)
		  dim i as integer
		  dim s as shape
		  dim Temp as XMLElement
		  
		  for i=1 to Obj.ChildCount-1
		    Temp = XMLElement(Obj.Child(i))
		    s = GetShape(val(Temp.GetAttribute("Id")))
		    s.XMLReadTsf(Temp)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPlan(n as integer) As shape
		  
		  return GetShape(currentcontent.plans(n))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateShape(fa as integer, fo as integer) As Shape
		  dim i as integer
		  dim specs as StdPolygonSpecifications
		  dim currentshape as shape
		  
		  if Fa <10 then
		    select case Fa
		      'case -1
		      'currentshape = new Repere(self)  //Pour mémoire
		    case 0
		      currentshape = new Point(self)
		    case 1
		      select case fo
		      case 0, 1, 2
		        currentshape = new Droite(self, 2)
		      case 3, 4, 5
		        currentshape = new Droite(self, 0)
		      case 6
		        currentshape = new Droite(self, 1)
		      case 7
		        currentshape = new Bande(self)
		      case 8
		        currentshape = new Secteur(self)
		      end select
		    case 2
		      select case fo
		      case 0
		        currentshape = new Polyqcq(self,3)
		      case 1
		        currentshape = new TriangIso(self,3,3)
		      case 2
		        currentshape = new Polreg(self,2,3)
		      case 3
		        currentshape = new TriangRect(self,3,3)
		      case 4
		        CurrentShape = new TriangRectIso(self,2,3)
		      end select
		    case 3
		      select case fo
		      case 0
		        currentshape = new Polyqcq(self,4)
		      case 1
		        currentshape = new Trap(self, 4)
		      case 2
		        currentshape = new TrapRect(self, 3)
		      case 3
		        currentshape = new TrapIso(self, 3)
		      case 4
		        currentshape = new Parallelogram(self, 3,4)
		      case 5
		        currentshape = new Rect(self, 3,4)
		      case 6
		        currentshape = new Losange(self, 3,4)
		      case 7
		        currentshape = new Polreg(self,4)
		      end select
		    case 4
		      currentshape = new Polreg(self, fo+3)
		    case 5
		      select case fo
		      case 0
		        currentshape = new FreeCircle(self)
		      case 1
		        currentshape = new Arc(self)
		      end select
		    case 6
		      currentshape = new Polyqcq(self, fo+3)
		    end select
		  else
		    'fa = fa-10
		    'specs =  wnd.StdFamilies(Fa,Fo)
		    'if ubound(specs.angles) > 0 then
		    'currentShape=new StandardPolygon(self, fa, fo, bp(0))
		    'elseif specs.family = "Cubes" or specs.family = "Rods" then
		    'currentshape = new Cube(self, bp(0), fo)
		    'else
		    'currentshape = new StdCircle(self,fa, fo, bp(0))
		    'end if
		  end if
		  
		  currentshape.fam = fa
		  currentshape.forme = fo
		  
		  return currentshape
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub enabletoupdatelabels()
		  dim i as integer
		  
		  for i = 0 to count-1
		    element(i).enabletoupdatelabel
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindSegment(p as BasicPoint) As objectslist
		  dim i, j As Integer
		  dim S as Shape
		  dim pt as point
		  dim Visible as ObjectsList
		  
		  Visible = new objectslist
		  
		  for i=Ubound(currentcontent.plans) downto 0
		    S=GetShape(currentcontent.plans(i))
		    if s <> nil  and not s.invalid and not s.deleted then
		      if s isa droite and droite(s).nextre = 2 and droite(s).pInShape(p) then
		        visible.addshape s
		      elseif s isa polygon and polygon(s).pointonside(p) > -1 then
		        visible.addshape s
		      end if
		    end if
		  next
		  
		  return Visible
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim i as integer
		  dim o as shape
		  
		  tracept = false
		  for i=0 to count-1
		    o = GetPlan(i)
		    if o <> nil then
		      o.PaintAll(g)
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLLireMacConstructionInfos(Obj as XMLElement)
		  dim i, j as integer
		  dim s as shape
		  dim List1 as XMLNodeList
		  dim Pt as XMLNode
		  dim Temp as XMLElement
		  dim fam as integer
		  
		  for i=0 to Obj.ChildCount-1
		    Temp = XMLElement(Obj.Child(i))
		    fam = val(Temp.GetAttribute(Dico.value("NrFam")))
		    if fam > -1 then
		      s = GetShape(val(Temp.GetAttribute("Id")))
		      s.XMLReadMacConstructionInfo(Temp)
		      List1 = Temp.XQL("Childs")
		      if List1.length > 0 then
		        Pt = List1.Item(0)
		        for j = 0 to Pt.Childcount-1
		          s.childs(j).XMLReadMacConstructionInfo(XMLElement(Pt.child(j)))
		          s.childs(j).mobility
		          s.childs(j).updateguides
		        next
		      end if
		    end if
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
		objects(-1) As Shape
	#tag EndProperty

	#tag Property, Flags = &h0
		selection As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected PrevId As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Groupes(-1) As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		OldSelection As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		drapplan As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		CreerTrace As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		tracept As Boolean
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
			Name="drapplan"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CreerTrace"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tracept"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
