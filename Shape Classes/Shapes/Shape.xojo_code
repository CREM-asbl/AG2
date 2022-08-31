#tag Class
Protected Class Shape
	#tag CompatibilityFlags = ( TargetDesktop and ( Target32Bit or Target64Bit ) )
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
		Sub AddPoint(p As BasicPoint)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddToCurrentcontent()
		  CurrentContent.addshape self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddToFigure()
		  Dim List0 As figslist
		  Dim i, j, n As Integer
		  Var s, s0, sh  As shape
		  Var pt As point
		  Var t As Boolean
		  Var tsf As transformation
		  Var Constru As ConstructionInfo
		  
		  If fig <> Nil And Not CurrentContent.currentoperation IsA prolonger Then
		    return
		  end if
		  
		  If CurrentContent.currentoperation IsA prolonger Then
		    fig = Nil
		  end if
		  // Création de la liste (List0) des figures comprenant un sommet ou un point sur de la forme (self)
		  
		  List0 = Listerfigsneighbour
		  CurrentContent.Thefigs.Removefigures List0
		  
		  n = Self.npts-1
		  
		  For i = 0 To n
		    pt = points(n)
		    For j = 0 To pt.parents.ubound
		      s = pt.parents(j)
		      If s.constructedby <> Nil And s.isaparaperp Then
		        t = True
		        s0 = s
		      End If
		    Next
		  Next
		  
		  If t  Then
		    sh = s0.constructedby.shape
		    For i = 0 To sh.tsfi.count-1
		      tsf = sh.tsfi.item(i)
		      If tsf.type = 0 Then
		        Constru = New ConstructionInfo(Self, 0)
		        Constru.data.append tsf
		        tsf.constructedshapes.addshape Self
		        sh.addconstructedshape Self
		      End If
		    Next
		  End If
		  
		  List0.addobject New Figure(Self)
		  fig = List0.concat
		  for i = 0 to fig.subs.count-1
		    Fig.AdapterAutos(fig.subs.item(i))
		  next
		  fig.ListerPrecedences
		  fig.idfig = -1
		  CurrentContent.TheFigs.addobject fig
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("fig", fig)
		    err.message = err.message+d.getString
		    
		    Raise err
		    
		    
		    
		    
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddToFigure(ff as figure, idf as integer)
		  Dim List0 As figslist                                 //N'est utilisé que par ObjectsList.XMLLireIdFigs
		  dim figu as figure
		  Dim o As shapeconstruction
		  dim i, j, op as integer
		  dim sh as shape
		  dim tsf as transformation
		  
		  if fig <> nil and ff <> nil and fig = ff then
		    return
		  end if
		  
		  figu = new Figure(self)
		  If ff <> Nil Then
		    List0 = new FigsList
		    List0.addobject ff
		    List0.addobject figu
		    fig = List0.concat
		    CurrentContent.TheFigs.Removefigure ff
		  else
		    fig = figu
		  end if
		  
		  fig.idfig = idf
		  for i = 0 to fig.subs.count-1
		    Fig.AdapterAutos(fig.subs.item(i))
		  next
		  CurrentContent.TheFigs.addobject fig
		  
		  
		  'If Constructedby <> Nil And isaparaperp And constructedby.shape.fig <> Nil Then   //si constructedby.shape.fig a déjà été chargé
		  'sh = constructedby.shape
		  'For i = 0 To sh.tsfi.count-1
		  'tsf = sh.tsfi.item(i)
		  'If tsf.type = 0 Then
		  'tsf.constructedshapes.addshape Self
		  'constructedby.data.append tsf'
		  'End If
		  'Next
		  'End If
		  '
		  'If ubound(ConstructedShapes) > -1 Then  // sinon on fait la même chose au moment ou on charge constructedby.shape.fig
		  'For  i = 0 To ubound(constructedshapes)
		  'sh= constructedshapes(i)
		  'If sh.isaparaperp And sh.fig <> Nil And ubound(sh.constructedby.data) = 0 Then
		  'For j = 0 To tsfi.count-1
		  'tsf = tsfi.item(j)
		  'If tsf.type = 0 And tsf.constructedshapes.count = 0 Then
		  'tsf.constructedshapes.addshape sh
		  'sh.constructedby.data.append tsf
		  'End If
		  'Next
		  ''droite(sh).createtsf
		  'End If
		  'Next
		  'end if
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("ff", ff)
		    d.setVariable("fig", fig)
		    d.setVariable("idf",idf)
		    d.setVariable("list0", List0)
		    err.message = err.message+d.getString
		    
		    Raise err
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
		        list1.addobject s.fig
		        list1.addobject p.fig
		        s.fig = list1.concat
		        s.fig.ListerPrecedences
		        CurrentContent.TheFigs.addobject s.fig
		      end if
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AffiOrSimili() As Matrix
		  
		  dim ep0, ep1, ep2, np0,np1,np2 as BasicPoint
		  epnp(ep0,ep1,ep2,np0,np1,np2)
		  
		  if  (ep2.alignes(ep1,ep0)) or (np2.alignes(np0,np1)) then
		    if abs(amplitude(ep1,ep0,ep2) - PI) < epsilon or abs(amplitude(np1,np0,np2) - PI) < epsilon then
		      return new similaritymatrix(ep1,ep2,np1,np2)  // cas des demi-cercles
		    elseif abs(amplitude(ep1,ep0,ep2)) < 0.2*epsilon or abs(amplitude(np1,np0,np2)) < 0.2*epsilon or abs(amplitude(ep1,ep0,ep2) -2*PI) <0.2* epsilon or abs(amplitude(np1,np0,np2) - 2*PI) < 0.2*epsilon then
		      np2 = np1
		      ep2 = ep1
		      points(2).moveto np2
		      points(2).modified = true
		      computearcangle
		      return new similaritymatrix(ep1,ep0,np1,np0)  // cas des secteurs nuls
		    end if
		  else
		    return  new  affinitymatrix(ep0,ep1,ep2,np0,np1,np2)  // ne convient pas pour les demi-cercles à cause des points alignés
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function aire() As double
		  if config.area = 1 then
		    return airealge
		  else
		    return airearith
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function airealge() As double
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function airearith() As double
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AllPtValid() As Boolean
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
		Function ArcComputeFirstIntersect(s as shape) As BasicPoint
		  dim q() as BasicPoint
		  dim Bib, BiB0 As  BiBPoint
		  dim i,n, k as integer
		  dim bq, v as BasicPoint
		  dim p as point
		  redim q(-1)
		  redim q(1)
		  
		  dim ep0, ep1, ep2, np0,np1,np2 as BasicPoint
		  epnp(ep0,ep1,ep2,np0,np1,np2)
		  
		  p = points(2)  ' ce point est "sur" s
		  if p.forme <> 1 then
		    return nil
		  end if
		  k = p.numside(0)
		  BiB0 =  new BiBPoint(points(0).bpt, points(1).bpt)
		  if S isa Droite or S isa Polygon or S isa Bande or S isa Secteur  then
		    Bib =S.getBiBside(k)
		    select case BiB.nextre
		    case 0
		      n = Bib.BiBDroiteInterCercle(BiB0,q(), bq, v)
		    case 1
		      n = Bib.BiBDemiDroiteInterCercle(Bib0,q(), bq, v)
		    case 2
		      n = Bib.BiBSegmentInterCercle(Bib0,q(), bq, v)
		    end select
		    n = ubound(q)+1
		  end if
		  
		  if S isa Circle then
		    Bib = new BiBpoint(S.Points(0).bpt,  S.Points(1).bpt)
		    n = BiB0.BiBInterCercles(Bib,q(),bq,v)
		    if n = 0 then
		      q.append p.bpt
		    end if
		  end if
		  
		  for i = 1 downto 0
		    if q(i) = nil then
		      q.remove i
		    end if
		  next
		  n = ubound(q)+1
		  
		  if n=2 then
		    if points(1) = fig.pmobi then
		      if   (amplitude(points(1).bpt, points(0).bpt, q(0)) >  amplitude(points(1).bpt, points(0).bpt, q(1)))    then
		        q(0) = q(1)
		      end if
		    else
		      if ep2.distance(q(0)) > ep2.distance(q(1)) then
		        q(0)=q(1)
		      end if
		    end if
		  end if
		  if n>0 and ubound(q) > -1 then
		    return q(0)
		  else
		    return nil
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AugmenteFont()
		  dim i, j as integer
		  
		  for i = 0 to labs.count-1
		    labs.item(i).augmentefont
		  next
		  
		  for i = 0 to ubound(childs)
		    for j = 0 to childs(i).labs.count-1
		      childs(i).labs.item(j).augmentefont
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Autos()
		  If Self IsA repere Then
		    Auto =-1
		  ElseIf  std  Or (macconstructedby <> Nil) Then
		    auto = 0
		  Elseif Self  IsA polreg Or Self IsA triangrectiso Or (Self IsA HalfDsk) Then
		    auto = 1
		  elseif  (self isa parallelogram and not self isa rect and not self isa losange) or self isa bande or self isa secteur  then '((self isa polyqcq and npts = 3) and (not Hybrid)) or
		    auto = 2
		  elseif self  isa triangrect or self isa triangiso or self isa rect or self isa losange or self isa arc or self isa DSect then '
		    auto = 3
		  elseif self isa trap then
		    auto = 5
		  ElseIf constructedby <> Nil And constructedby.oper = 6  Then
		    Auto = 6
		  ElseIf   constructedby <> Nil And (constructedby.oper = 1 Or constructedby.oper = 2)  Then
		    Auto = 7
		  Else
		    Auto = 4 // Points isolés, BiP, Polyqcq, Triangles qcq, Droites , FreeCircles y compris Lacets
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BelongsToBorder(P as Point) As Boolean
		  //return false
		  
		  
		End Function
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
		Function centerordivpoint() As Boolean
		  if not self isa point then
		    return false
		  elseif constructedby <> nil then
		    return constructedby.oper =0 or constructedby.oper = 4 or constructedby.oper = 7 or constructedby.oper = 45
		  end if
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChargerParam()
		  Fixecouleurtrait(Config.bordercolor,Config.Border)
		  FixeCouleurFond(Config.Fillcolor,Config.Fill)
		  Borderwidth = config.thickness
		  
		  'On charge les paramètres pointe, fleche, biface et area à partir des paramètres correspondants de la configuration
		  'NonPointed ne devrait plus servir à rien
		  
		  Pointe = config.polpointes
		  Fleche = config.polfleches
		  biface= config.biface
		  area = config.area
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function check() As boolean
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computearcangle()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function computediam() As double
		  dim i , j as integer
		  dim diam as double
		  
		  diam = 0
		  'if ncpts<3 then
		  'diam =999
		  'else
		  
		  for i = 0 to ncpts-2
		    for j = i+1 to ncpts-1
		      diam= max(diam, points(i).bpt.distance(points(j).bpt))
		    next
		  next
		  'end if
		  
		  return diam
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeori()
		  signaire = sign(aire)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist)
		  id = ol.newId
		  IdGroupe = -1
		  objects = ol
		  labs = new lablist
		  tsfi = new transfoslist
		  drapori = false
		  Autos
		  ChargerParam
		  Border = 100
		  Fill = 0
		  Points.append new Point(ol, new Basicpoint(0,0))
		  setpoint(Points(0))
		  plan = -1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol As ObjectsList, ncp as Integer, np as integer)
		  
		  if id=0 then
		    id = ol.newId
		  end if
		  objects = ol
		  labs = new LabList
		  tsfi = new transfoslist
		  Ncpts = ncp
		  Npts = np
		  Autos
		  IdGroupe = -1
		  ChargerParam
		  plan = -1
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, s as shape)
		  constructor(ol)
		  Npts=s.Npts
		  Ncpts = s.Ncpts
		  fam =s.fam
		  forme = s.forme
		  narcs = s.narcs
		  auto = s.auto
		  labs = new Lablist
		  InitConstruction
		  CopierParams(s)
		  updatecoord
		  plan = -1
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, El as XMLElement)
		  dim  EL1, Temp as XMLElement
		  dim i, n as integer
		  dim num as integer
		  dim List as XMLNodelist
		  dim s as shape
		  dim c as couleur
		  dim pos as string
		  dim lab as etiq
		  
		  objects=ol
		  id = Val(EL.GetAttribute("Id"))
		  Npts= Val(EL.GetAttribute(Dico.value("Npts")))
		  fam = Val(EL.GetAttribute(Dico.value("Nrfam")))
		  forme = Val(EL.GetAttribute(Dico.value("Nrform")))
		  TracePt = (val(EL.GetAttribute("BlueTrace")) = 1)
		  Ori = val(EL.GetAttribute(Dico.value("Ori")))
		  tsfi = new transfosList
		  plan = val(EL.GetAttribute("Plan"))
		  autos
		  
		  if val(EL.GetAttribute("Auto")) <> 0 then 'Ne pas tenir compte des "autos enregistrés"
		    auto = val(EL.GetAttribute("Auto"))
		  end if
		  
		  if val(EL.GetAttribute("NonPointed")) = 1 then
		    pointe = false
		  else
		    pointe = true
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
		  
		  if self isa lacet or self isa bande then
		    initcolcotes
		  end if
		  
		  List = EL.XQL("Childs")
		  if List.length > 0 then
		    XMLReadPoints XMLElement(List.Item(0))   // ne lit pas les points sur
		  end if
		  
		  List = EL.Xql("InfosArcs")
		  if List.length > 0 then
		    XMLReadInfoArcs(EL)
		  end if
		  
		  Labs = new LabList
		  
		  List = EL.XQL("Label")
		  if List.length > 0 then
		    for i = 0 to List.length-1
		      lab = labs.newlab(XMLElement(List.Item(i)), self )
		      if lab <> nil then
		        lab.chape = self
		        lab.setposition
		        labs.addobject lab
		      end if
		    next
		  end if
		  
		  List = EL.XQL(Dico.Value("ToolsColorBorder"))
		  if list.length = 1 then
		    if XMLReadcoloritem (Dico.Value("ToolsColorBorder"),EL,c, Temp) then
		      FixeCouleurTrait(c,Config.Border)
		    end if
		  elseif self isa lacet then
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
		  
		  if XMLReadcoloritem (Dico.Value("ToolsColorFill"),EL,c,Temp) then
		    fill = Val(Temp.GetAttribute("Opacity"))
		    border=Val(Temp.GetAttribute("OpacityBorder"))
		  end if
		  FixeCouleurFond(c,Fill)
		  
		  List = EL.XQL(Dico.Value("Thickness"))
		  if list.length = 0 then
		    Borderwidth = config.thickness
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
		Sub Constructor(s as shape, M as Matrix)
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
		Sub ConstructShape()
		  dim i as integer
		  
		  
		  for i = 0 to ncpts-1
		    coord.tab(i) = Points(i).bpt
		  next
		  if fam > 1 then
		    coord.constructshape(fam,forme)
		    repositionnerpoints
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CopierParams(s as shape)
		  dim i,n as integer
		  
		  if s isa cube then
		    n = 11
		  elseif s isa Lacet then
		    n = npts-1
		  elseif s isa bande or s isa secteur  then
		    n = 1
		  else
		    n = -1
		  end if
		  for i = 0 to n
		    colcotes(i) = s.colcotes(i)
		  next
		  border = s.border
		  borderwidth = s.borderwidth
		  bordercolor = s.bordercolor
		  Fixecouleurfond s.Getfillcolor, s.Fill
		  Ti = s.Ti
		  std = s.std
		  ori = s.ori
		  hidden = s.hidden
		  fleche = s.fleche
		  pointe = s.pointe
		  area = s.area
		  biface = s.biface
		  for i = 0 to npts-1
		    points(i).moveto s.points(i).bpt
		    points(i).borderwidth = s.points(i).borderwidth
		    points(i).hidden = s.points(i).hidden
		    points(i).forme = s.points(i).forme
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createcoord()
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
		Sub createskull(p as BasicPoint)
		  
		End Sub
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
		      if ubound(constructedby.data) > 0 and constructedby.data(1) <> nil then
		        tsf = transformation (constructedby.data(1))
		        tsf.constructedshapes.removeobject self                        'en cas d'avortement tsf n'est pas encore définie
		        tsf.supp.tsfi.removeObject tsf
		        currentcontent.TheTransfos.removeObject  tsf
		      end if
		    case 3, 8
		      constructedby.shape.removeconstructedshape self
		    case 5
		      constructedby.shape.removeconstructedshape self
		      for i =  Ubound(points) to 0
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
		      CurrentContent.Thetransfos.RemoveObject tsfi.item(i)
		    next
		    tsfi.removeall
		  end if
		  
		  for i = 0 to ubound(childs)
		    if childs(i).tsfi.count >0 then
		      for j = 0 to childs(i).tsfi.count -1
		        CurrentContent.Thetransfos.RemoveObject childs(i).tsfi.item(j)
		      next
		      childs(i).tsfi.removeall
		    end if
		  next
		  
		  
		  
		  if conditionedby <> nil then
		    conditionedby.conditioned.removeobject self
		  end if
		  
		  for i = ubound(childs) downto npts
		    p = childs(i)
		    p.removepointsur(self)
		  next
		  
		  for i = Ubound(points) downto 0
		    p = points(i)
		    if p.forme = 2 and p.id > id then
		      inter = p.GetInter
		      if inter <> nil then
		        inter.removepoint p
		      end if
		    end if
		    for j =  p.pointsur.count-1 downto 0
		      if p.id > id then ' p.pointsur.item(j).id then
		        p.removepointsur(p.pointsur.item(j))
		      end if
		    next
		    removepoint p
		    if p.id < id and p.isolated and p.pointsur.count = 0  then
		      currentcontent.addshape(p)
		      p.addtofigure
		    end if
		  next
		  
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
		  
		  currentcontent.removeobject self
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMethod("Shape","delete")
		    d.setVariable("constructedby",constructedby)
		    d.setVariable("macconstructedby",macconstructedby)
		    d.setVariable("points",UBound(points))
		    err.message = err.message+d.getString
		    
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub depointer()
		  dim i as integer
		  pointe = false
		  for i = 0 to ubound(points)
		    points(i).pointe = false
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DiminueFont()
		  dim i, j as integer
		  
		  for i = 0 to labs.count-1
		    labs.item(i).diminuefont
		  next
		  
		  for i = 0 to ubound(childs)
		    for j = 0 to childs(i).labs.count-1
		      childs(i).labs.item(j).diminuefont
		    next
		  next
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
		Function duplicateorcut() As Boolean
		  return constructedby <> nil and (constructedby.oper = 3 or constructedby.oper = 5)
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
		Sub EndConstruction()
		  Dim i As Integer
		  
		  
		  isinconstruction = false
		  updatecoord
		  
		  for i = 0 to npts-1
		    points(i).isinconstruction = false
		  next
		  
		  if constructedby <> nil then
		    pointe = constructedby.shape.pointe
		  else 'if not self isa cube then
		    pointe =  config.PolPointes
		  end if
		  if not (currentcontent.currentoperation isa ouvrir) or not (self isa stdcircle) then  //::Béquille pour le cas des stdcircles
		    Currentcontent.addShape self
		    if CurrentContent.ForHisto or currentcontent.currentoperation isa macroexe then
		      addtofigure
		    end if
		  End If
		  
		  signaire = Sign(aire)
		  computeori
		  dounselect
		  'If Self IsA polygon Then
		  'polygon(self).autoInter = coord.autointer
		  'End If
		  currentcontent.optimize
		  currentcontent.RemettreTsfAvantPlan
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndMove()
		  dim i as integer
		  
		  updatecoord
		  if tsfi <> nil and tsfi.count > 0 then
		    for i=0 to tsfi.count-1
		      tsfi.item(i).update
		    next
		  end  if
		  updatelab
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub epnp(byref ep0 as Basicpoint, byref ep1 as BasicPoint, byref ep2 as Basicpoint, byref np0 as BasicPoint, byref np1 as BasicPoint, byref np2 As BasicPoint)
		  dim ff as figure
		  
		  ff = getsousfigure(fig)
		  ff.getoldnewpos(points(0),ep0,np0)
		  ff.getoldnewpos(points(1),ep1,np1)
		  ff.getoldnewpos(points(2),ep2,np2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExistAutoInterPoints()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as BasicPoint, n as integer)
		  dim i as integer
		  
		  
		  if n = ncpts-1 then  ' and not std then
		    points(n).moveto p
		    constructshape
		  elseif n < ncpts-1 then
		    for i = n to npts-1
		      Points(i).MoveTo(p)
		    next
		    updatecoord
		    if self isa Lacet and not std then
		      if n < ncpts then
		        Lskull(nsk).item(n).border = 100
		      end if
		    end if
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FixeCouleurFond(c as couleur, f as integer)
		  Fillcolor = c
		  Fill = f
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FixeCouleurtrait(c as couleur, b as integer)
		  Bordercolor = c
		  Border = b
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecouleurtrait(i as integer, c as couleur)
		  colcotes(i) = c
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Flecher()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function fused() As boolean
		  return constructedby <> nil and (constructedby.oper = 9)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBibSide(i as integer) As BiBPoint
		  dim Bib as BiBPoint
		  
		  BiB = new BiBPoint(coord.tab(i), coord.tab((i+1) mod npts))
		  
		  if self isa circle then
		    BiB.type = 1
		  else
		    BiB.type = 0
		  end if
		  if self isa droite then
		    BiB.nextre = droite(self).nextre
		  elseif  (self isa lacet and coord.curved(i)=0) then
		    BiB.nextre = 2
		  end if
		  
		  return BiB
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBorderColor() As Couleur
		  return BorderColor
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
		Function GetCoord() As nBPoint
		  updatecoord
		  return coord
		End Function
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
		Function GetFillColor() As Couleur
		  return FillColor
		End Function
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
		Function GetGravityCenter() As BasicPoint
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetId() As Integer
		  return Id
		End Function
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
		Function GetIndexPoint(Pt as Point) As integer
		  
		  if not self isa point then
		    return points.indexof(pt)
		  end if
		  
		End Function
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
		Function GetIndexTsf(tsf as transformation) As integer
		  dim i as integer
		  
		  for i = 0 to tsfi.count-1
		    if tsfi.item(i) = tsf then
		      return i
		    end if
		  next
		  return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetInters() As intersec()
		  return currentcontent.theintersecs.find(self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetObjects() As ObjectsList
		  return Objects
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
		Function GetPositionInObjectsList() As integer
		  return Objects.getPosition(self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRadius() As double
		  if ubound(points) > 0 then
		    return coord.distance01
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSide(n as integer) As droite
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSousFigure(Figu as Figure) As Figure
		  dim i as integer
		  dim ff as figure
		  
		  if Figu <> nil then
		    for i = 0 to Figu.subs.count-1
		      ff = figu.subs.item(i)
		      if ff.shapes.getposition (self) <> -1 or ff.somm.getposition(self) <> -1 or ff.ptssur.getposition(self) <> -1 or ff.ptsconsted.getposition(self) <> -1  then
		        return figu.subs.item(i)
		      end if
		    next
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As string
		  dim s as String
		  
		  s = "{id : "+str(id)+", IDGroupe : "+str(IDGroupe)+"}"
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetTsf(n as integer, m as integer) As transformation
		  dim tsf as transformation
		  dim i as integer
		  
		  for i = 0 to tsfi.count-1
		    if tsfi.item(i).type = n and tsfi.item(i).index = m  then
		      return tsfi.item(i)
		    end if
		  next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As String
		  
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
		Function haspointon(s as shape, byref p as point) As Boolean
		  dim i,j as integer
		  
		  if self isa point then
		    return false
		  end if
		  
		  for i = 0 to Points.Count-1
		    if points(i).pointsur.count >0 and  points(i).pointsur.getposition(s) <> -1 then
		      p = points(i)
		      return true
		    end if
		  next
		  
		  return false
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
		Sub Hide()
		  
		  
		  Hidden = true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HighLight()
		  Dim i As Integer
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
		  if IdGroupe <> -1 and ((not op isa Modifier)  and ( ( op isa selectanddragoperation) or (op isa retourner) or (op isa appliquertsf) ) ) then
		    For i = 0 To objects.groupes(idgroupe).count -1
		      objects.groupes(idgroupe).item(i).highlighted = true
		    next
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Hybrid() As Boolean
		  if self isa lacet and narcs >0 then
		    return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Identifiant() As string
		  Dim m As String
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
		        m = m + "*"
		      end if
		    next
		  end if
		  
		  return m
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function inispeupdate1(Byref n as integer) As point
		  dim ff as figure
		  dim p as point
		  
		  ff = getsousfigure(fig)
		  p = Point(ff.somm.item(ff.ListPtsModifs(0)))
		  n = getindex(p)
		  
		  return p
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub initcolcotes()
		  
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
		  end
		  if config.PolFleches  then
		    Ti = new Tip
		  end if
		  
		  isinconstruction = true
		  createcoord
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitCurvesOrders()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertPoint(index as integer, P as Point)
		  Points.Insert(index,P)
		  Childs.Insert(index,P)
		  P.setParent(self)
		  nsk.InsertPoint(P.bpt,index)
		  npts = npts+1
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
		    
		    for j = 0 to ubound(ConstructedShapes)        //on invalide les images
		      s = ConstructedShapes(j)
		      s.invalider
		    next
		    
		    for i = 0 to tsfi.count-1                                   // on invalide les objets images par un tsf de support self
		      for j = 0 to tsfi.item(i).constructedshapes.count -1
		        s = tsfi.item(i).constructedshapes.item(j)
		        s.invalider
		      next
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isaellipse() As boolean
		  return false
		End Function
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
		Function isptsur() As boolean
		  
		  return (self isa point) and (point(self).pointsur.count = 1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsSame(s as Shape) As Boolean
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsStandAlone() As boolean
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
		      List0.addobject childs(i).fig
		    else
		      for j = 0 to ubound(childs(i).parents)
		        if self <> childs(i).parents(j)  then
		          List0.addobject childs(i).parents(j).fig
		        end if
		      next
		    end if
		    
		    if childs(i).centerordivpoint then
		      List0.addobject childs(i).constructedby.shape.fig
		    end if
		  next
		  
		  for i = 0 to ubound(constructedshapes)
		    if constructedshapes(i).centerordivpoint then
		      list0.addobject constructedshapes(i).fig
		    end if
		  next
		  return list0
		  
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
		    obj = objects.item(i)
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
		Function Modifier1(n as integer) As Matrix
		  'Méthode utilisée uniquement pour des formes autospe : Arc et DSect
		  
		  dim  m as integer
		  dim ff as Figure
		  
		  ff = getsousfigure(fig)
		  
		  m = ff.NbSommsur(n)
		  
		  select case m
		  case 0
		    return Modifier10(n)
		  case 1
		    return Modifier11(n)
		  case 2
		    return Modifier11(n)
		  end select
		  
		  //Les deux derniers cas ne peuvent normalement pas se présenter (il y aurait plus d'un point modifié)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier10(n as integer) As Matrix
		  'Le point n° n est le seul point modifié. Il y a 0 points "sur"
		  dim  r as double
		  dim ep0, ep1, ep2, np0,np1,np2 as BasicPoint
		  epnp(ep0,ep1,ep2,np0,np1,np2)
		  
		  select case n
		  case 0, 1
		    return new SimilarityMatrix(ep0,ep1,np0,np1)
		  case 2
		    if self isa arc then
		      r = arc(self).getradius
		    elseif self isa DSect then
		      r = DSect(self).getradius(1)
		    end if
		    points(2).moveto np2.projection(np0,r)
		    return new AffinityMatrix(ep0,ep1,ep2,np0,np1,points(2).bpt)
		  end select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier11(n as integer) As Matrix
		  dim s as shape
		  dim bp as BasicPoint
		  
		  dim ep0, ep1, ep2, np0, np1, np2 as BasicPoint
		  epnp(ep0,ep1,ep2,np0,np1,np2)
		  
		  
		  if points(2).forme <> 1 then
		    return new Matrix(1)
		  end if
		  
		  s = points(2).pointsur.item(0)
		  
		  if self isa arc or self isa DSect then
		    bp = arc(self).ArcComputeFirstIntersect(s)
		  end if
		  
		  return new AffinityMatrix(ep0,ep1,ep2,np0,np1,bp)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier1fixe(p as point, q as point) As Matrix
		  'Le point p doit resterfixe, le point q est déplacé plus ou moins arbitrairement, les autres points suivent.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2(n1 as integer, n2 as integer) As Matrix
		  dim n0 as integer
		  dim r as double
		  dim M as Matrix
		  dim arcangle As double
		  
		  dim ep0, ep1, ep2, np0,np1,np2 as BasicPoint
		  epnp(ep0,ep1,ep2,np0,np1,np2)
		  
		  n0 = TroisiemeIndex(n1,n2)  'Le point n° n0 n'a pas été modifié.
		  
		  select case n0
		  case 0   'On rétablit la figure en déplaçant le centre de l'arc points(0)
		    if points(0).forme  <> 1 then
		      return new SimilarityMatrix(ep1,ep2,np1,np2)
		    end if
		  case 1 'On modifie l'amplitude de l'arc
		    if points(1).forme <> 1 then
		      r = getradius
		      points(2).moveto np2.projection(np0,r)
		      return new AffinityMatrix(ep0,ep1,ep2,np0,np1,points(2).bpt)
		    end if
		  case 2  'On rétablit la figure en déplaçant l'extrémité  de l'arc points(2)
		    self.computearcangle
		    M = new RotationMatrix(Points(0).bpt, self.arcangle)
		    if points(2).forme <> 1 then
		      points(2).moveto points(2).bpt.projection(Points(1).bpt, M*Points(1).bpt)
		      return AffiOrSimili
		    else
		      points(2).moveto M*Points(1).bpt
		      points(2).modified = true
		      return AffiOrSimili
		    end if
		  end select
		  
		  return new Matrix(1)
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("self", self)
		    d.setVariable("n0", n0)
		    err.message = err.message+d.getString
		    
		    Raise err
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2fixes(p as point) As Matrix
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2fixes(p as point, q as point) As Matrix
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier3() As Matrix
		  dim n as integer
		  dim ff as figure
		  dim ep0, ep1, ep2, np0,np1,np2 as BasicPoint
		  
		  ff = getsousfigure(fig)
		  epnp(ep0,ep1,ep2,np0,np1,np2)
		  
		  n = ff.NbSommSur
		  
		  select case n
		  case 0
		    return Modifier30
		  case 1
		    return Modifier31(ff.listsommsur(0))
		  case 2
		    return modifier32(ff.listsommsur(0),ff.listsommsur(1))
		  case 3
		    return modifier33
		  end select
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier30() As Matrix
		  //Trois sommets modifiés, aucun n'est un point "sur"
		  
		  
		  constructshape
		  
		  dim ep0, ep1, ep2, np0,np1,np2 as BasicPoint
		  epnp(ep0,ep1,ep2,np0,np1,np2)
		  
		  if abs(np0.distance(np1) - np0.distance(np2)) < epsilon then
		    return AffiOrSimili
		  else
		    return new Matrix(1)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier31(n as integer) As Matrix
		  // Trois sommets modifiés Un seul est un point "sur". C'est le sommet de n° n.
		  dim k, i,  n1, n2 as integer
		  dim ep, np, u, v as BasicPoint
		  dim Bib, Bib2 As  BiBPoint
		  dim sh As shape
		  dim p As point
		  dim ep0, ep1, ep2, np0,np1,np2 as BasicPoint
		  dim ff as figure
		  
		  ff = getsousfigure(fig)
		  epnp(ep0,ep1,ep2,np0,np1,np2)
		  
		  
		  p = points(n)
		  sh = p.pointsur.item(0)
		  
		  select case n
		  case 0
		    u = np1-np2
		    u = u.VecNorPerp
		    v = (np1+np2)/2
		    Bib = new BiBPoint(v, u+v)
		    np0 = Bib.computefirstintersect(0,sh,p)
		    points(0).moveto np0
		  case 1
		    if ff.supfig.pmobi = points(2) then
		      np2 = np2.projection(np0,np0.distance(np1))
		      points(2).moveto np2
		    else
		      Bib = new BiBPoint(np0, np2)
		      np1 = Bib.computefirstintersect(1,sh,p)
		      points(1).moveto np1
		    end if
		  case 2
		    Bib = new BiBPoint(np0,np1)
		    np2 = Bib.computefirstintersect(1,sh,p)
		    if np2 <> nil and abs (np0.distance(np2) - np0.distance(np1)) < epsilon then
		      points(2).moveto np2
		      points(2).valider
		    else
		      points(2).invalider
		    end if
		  end select
		  
		  
		  
		  if not points(n).invalid  then
		    return AffiOrSimili 'new AffinityMatrix(ep0,ep1,ep2,np0,np1,np2)
		  else
		    return new Matrix(1)
		  end if
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier32(n as integer, m as integer) As Matrix
		  // Trois sommets modifiés Deux sont "sur". Ce sont les sommets de n° n0 et n1.
		  dim k as integer
		  dim p, p0, p1, p2 as point
		  dim shn, shm as shape
		  dim Bib as BiBPoint
		  
		  dim ep0, ep1, ep2, np0,np1,np2 as BasicPoint
		  epnp(ep0,ep1,ep2,np0,np1,np2)
		  
		  shn = points(n).pointsur.item(0)
		  shm = points(m).pointsur.item(0)
		  k = TroisiemeIndex(n,m)  'Ce troisième sommet n'est pas "sur"
		  
		  select case k
		  case 0, 1                 'on adapte points(2)
		    if n = 1-k  then   'alors m = 2
		      np2  =Arccomputefirstintersect(shm)
		    else                  'n = 2, m = 1
		      np2  = Arccomputefirstintersect(shn)
		    end if
		    if np2 <> nil then
		      points(2).bpt  = np2
		      points(2).modified = true
		    end if
		    
		  case 2
		    Bib = new BiBPoint(np0,np2)
		    if n = 1 then   'alors m = 0
		      np1  = Bib.computefirstintersect(1,shn,points(1))
		    else                  'n = 0, m = 1
		      np1  = Bib.computefirstintersect(1,shm,points(1))
		    end if
		    if np1 <> nil then
		      points(1).bpt = np1
		      points(1).modified = true
		    end if
		  end select
		  
		  if k = 2 then
		    p = points(1)
		  else
		    p = points(2)
		  end if
		  if np1 <> nil and np2 <> nil then
		    p.valider
		    return  AffiOrSimili  'new AffinityMatrix(ep0,ep1,ep2,np0,np1,np2)
		  else
		    p.invalider
		    return new Matrix(1)
		  end if
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier33() As Matrix
		  dim M as Matrix
		  dim ep0, ep1, ep2, np0,np1,np2 as BasicPoint
		  epnp(ep0,ep1,ep2,np0,np1,np2)
		  dim ff as Figure
		  
		  M = new SimilarityMatrix(points(1), points(2),ep0,np0)
		  if M <> nil and M.v1 <> nil then
		    np1 = M*ep1
		    points(1).moveto np1
		    np2 = M*ep2
		    points(2).moveto np2
		    
		    if np1 <> nil and np2 <> nil then
		      return  AffiOrSimili 'new AffinityMatrix(ep0,ep1,ep2,np0,np1,np2)
		    else
		      return new Matrix(1)
		    end if
		  else
		    ff =  Getsousfigure(fig)
		    if ff.replacerpoint(points(2)) then
		      return ff.autospeupdate
		    else
		      return new Matrix(1)
		    end if
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modify2(p1 as point, p2 as point) As Matrix
		  dim m as integer
		  dim  ep1, np1, ep2, np2  as BasicPoint
		  dim ff as figure
		  
		  
		  ff = getsousfigure(fig)
		  m = getindexpoint(fig.pmobi)
		  
		  select case ff.NbUnModif
		  case 0
		    ff.getoldnewpos(p1,ep1,np1)
		    ff.getoldnewpos(p2,ep2,np2)
		    return new SimilarityMatrix(ep1,ep2,np1,np2)
		  case 1
		    if m = -1 then
		      return new Matrix(1)
		    else
		      return modifier2fixes(fig.pmobi)
		    end if
		  end select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Move(M as Matrix)
		  dim i As  Integer      // Utilisé pour les  mouvements de formes images par des transfos
		  
		  for i = 0 to Ubound(Childs)
		    Childs(i). Move(M)
		  next
		  Mmove = M
		  EndMove
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveToBack()
		  Currentcontent.MoveBack id
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveToFront()
		  Currentcontent.Movefront id
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function mustbeinfigure(ff as figure) As boolean
		  dim k as integer
		  
		  for k = 0 to ff.shapes.count-1
		    if samefigure(ff.shapes.item(k))  then
		      return true
		    end if
		  next
		  
		  return false
		End Function
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
		Function NbTrueSomCommuns(s as shape) As integer
		  Dim i, j, n, n0 As Integer  //Méthode utilisée uniquement par shape.precede(autre shape)
		  //Précédemment  s'appelait NbTrueSomCommuns(ff as figure) Pas logique pour tester si une forme précède une autre forme!
		  //Par prudence les j'ai simplement mis en commentaire les expressions utlisées auparavant.
		  
		  
		  For i = 0 To Points.count-1
		    For j = 0 To s.Points.count-1
		      If (Points(i).forme < 2) And (Points(i) = s.Points(j) ) And (s.Points(j).constructedby = Nil) Then
		        n = n+1
		      End If
		    Next
		  Next
		  
		  Return n
		  
		  
		  if not self isa point then
		    for i = 0 to Points.count-1
		      If s.getindexpoint(points(i)) <> -1 Then
		        n0 = n0+1
		      end if
		    next
		  else
		    If s.getindexpoint(Point(Self)) <> -1 Then
		      n0 = 1
		    end if
		  end if
		  
		  
		  Return n0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NewCoord(s as shape) As nBPoint
		  'select case s.npts
		  'case 2
		  'return new BiBPoint
		  'case 3
		  'return new TriBPoint
		  'else
		  'return new nBPoint
		  'end select
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextBorderPoint(P as Point, p2 as point) As Point
		  
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
		Sub nskupdate()
		  nsk.update(self)
		  
		  if tracept then
		    nsk.updateborderwidth(borderwidth)
		    nsk.updatebordercolor(bleu,100)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub oldConstructor(s as shape, M as Matrix)
		  Dim i As Integer
		  dim p as BasicPoint
		  
		  npts = s.npts
		  
		  for i = 0 to npts-1
		    p = M*(s.points(i).bpt)
		    Points.append new Point(p)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function oldGetIndexSide() As integer
		  dim op as operation
		  dim i, n as integer
		  
		  n=-1
		  
		  op =CurrentContent.currentoperation
		  if op <> nil and op.nobj > 0 and op.visible.item(op.iobj) = self then
		    if (op isa transfoconstruction and (transfoconstruction(op).type < 7))  or op isa prolonger then
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
		Sub paint(g as Graphics)
		  Dim i As Integer
		  
		  
		  if (self isa Bipoint and not self isa droite) or (not WorkWindow.drapshowall and hidden) or not noinvalidpoints then
		    return
		  end if
		  
		  if nsk <> nil then
		    nsk.update(Self)
		    nsk.fixecouleurs(self)
		    nsk.fixeepaisseurs(self)
		    nsk.paint(g)
		  end if
		  
		  if not hidden then
		    for i = 0 to labs.count-1
		      Labs.item(i).paint(g)
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PaintAll(g as Graphics)
		  dim i,j as Integer
		  
		  if not invalid and not deleted  then
		    Paint(g)
		  end if
		  if not hidden and tsfi.count > 0 then
		    for i = 0 to tsfi.count-1
		      tsfi.item(i).paint(g)
		    next
		  end if
		  
		  if tracept and (modified or CurrentContent.currentoperation isa appliquertsf)  then
		    paint(can.offscreenpicture.graphics)
		    currentcontent.theobjects.tracept = true
		  end if
		  
		  if pointe then
		    for i=0 to Ubound(childs)
		      childs(i).Paint(g)
		      for j = 0 to childs(i).tsfi.count-1
		        childs(i).tsfi.item(j).paint(g)
		      next
		    next
		  else
		    for i=npts to Ubound(childs)
		      childs(i).Paint(g)
		      for j = 0 to childs(i).tsfi.count-1
		        childs(i).tsfi.item(j).paint(g)
		      next
		    next
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PaintSegment(g as graphics, cot as integer)
		  if self isa Lacet and cot <> -1   then
		    unhighlight
		    paintside(g,cot,2,Config.highlightcolor)
		  elseif self isa droite then
		    highlight
		    paintall(g)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paintside(g as graphics, cot as integer, ep as double, col as couleur)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PaintTip(u as BasicPoint, v as BasicPoint, col as couleur, sc as double, g as graphics)
		  dim a, b as BasicPoint
		  
		  a = can.transform(u)
		  b = can.transform(v)
		  Ti.updatetip(a,b,col.col)
		  Ti.scale = sc
		  g.DrawObject Ti, b.x, b.y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PassePar(p() as point) As Boolean
		  dim i as integer 'utilise uniquement par  divide
		  dim t as Boolean
		  
		  t = true
		  
		  if self isa circle then 'on élimine le centre du cercle
		    for i = 0 to ubound(p)
		      t = t and (getindex(p(i)) <> 0)
		    next
		  end if
		  
		  for i = 0 to ubound(p)
		    t = t and ((getindex(p(i)) <> -1) or (p(i).constructedby <>nil and p(i).constructedby.oper = 4 and p(i).constructedby.shape = self))
		  next
		  return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(ol as objectslist, p as basicPoint) As shape
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(ol as objectslist, p as BasicPoint, s as shape) As shape
		  // Paste est utilisé pour les Copier-coller, duplicate, image par translation en vue de créer des figures-images. Celles-ci devront être insérées dans la liste
		  //des objets du currentcontent. Cela se fait lors du passage par endconstruction, qui ne doit être réalisé qu'une fois !
		  // Les méthodes CreerCopies de AppliquerTSF, SetCopies de Dupliquer et DoOperation de Coller s'en chargent (essayer de les unifier).
		  //Donc à ne pas insérer dans les routines de création des copies.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PasteCtrlExe(s as shape)
		  dim i as integer
		  
		  redim coord.centres(ubound(s.coord.centres))
		  redim coord.curved(ubound(s.coord.curved))
		  narcs = s.narcs
		  for i = 0 to ubound(s.coord.centres)
		    coord.centres(i) = s.coord.centres(i)
		  next
		  for i = 0 to ubound(s.coord.ctrl)
		    coord.ctrl(i) =  s.coord.ctrl(i)
		  next
		  for i = 0 to ubound(s.coord.extre)
		    coord.extre(i) = s.coord.extre(i)
		  next
		  for i = 0 to ubound(s.coord.curved)
		    coord.curved(i) = s.coord.curved(i)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub pastelabs(s as shape)
		  dim i as integer
		  
		  for i = 0 to s.labs.count-1
		    labs.addobject new etiq(s.labs.item(i))
		    labs.item(i).chape = self
		    labs.item(i).setposition
		  next
		  
		  for i = 0 to ubound(childs)
		    Childs(i).pastelabs(s.childs(i))
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(p as Basicpoint) As boolean
		  
		  return false
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub pointer()
		  dim i, n as integer
		  pointe = true
		  for i = 0 to ubound(points)
		    points(i).pointe = true
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pointonline(p as Basicpoint) As integer
		  return pointonside(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As integer
		  return -1
		  
		  
		  //PointOnSide vaut 0 ou -1 pour un cercle ou une droite ou un segment
		  //                               un numéro ou -1 pour un polygone ou un lacet ou une bande ou un secteur
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PossibleAttractionWith(other as Shape) As Boolean
		  
		  dim gc1,gc2,bp as basicpoint
		  dim dist,b1,b2 as double
		  dim magdist as double
		  magdist = can.MagneticDist
		  
		  if other = nil then
		    return false
		  end if
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
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PossibleDrag() As Boolean
		  dim j, k, m as integer
		  dim ffbut as figure
		  
		  for j = 0 to tsfi.count-1
		    for k = 0 to tsfi.item(j).constructedfigs.count -1
		      if  tsfi.item(j).type <> 1 then
		        ffbut = tsfi.item(j).constructedfigs.item(k)
		        for m = 0 to  ubound(ffbut.Constructioninfos)
		          if (ffbut.ConstructionInfos(m).tsf = tsfi.item(j)) and (ffbut = ffbut.ConstructionInfos(m).Sourcefig) and (ffbut <> fig) then
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
		Function PrecBorderPoint(P as Point, p2 as point) As Point
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function precede(s2 as shape) As boolean
		  Dim h, k, m, i, j  As Integer
		  Dim ff As figure
		  dim p, q as point
		  Dim s, sh As shape
		  dim t as Boolean
		  dim s2ci As constructioninfo
		  Dim tsf As transformation
		  
		  'Un paraperp ne peut pas être modifié avant  son générateur
		  If auto=7 And  Self  = constructedby.shape Then
		    Return  False
		  End If
		  
		  
		  ff = s2.getsousfigure(s2.fig)
		  s2ci = s2.constructedby
		  
		  if s2ci <> nil and (s2ci.shape = self or (s2ci.shape = nil and s2ci.oper = 9 and (s2ci.data(0) = self or s2ci.data(2) =self))  ) then
		    select case  s2ci.oper
		    case 1, 2
		      if not haspointon(s2,p) then
		        return true
		      end if
		    case 3, 5, 6, 8, 9
		      return true
		    end select
		  elseif constructedby <> nil and constructedby.oper = 6 then
		    If constructedby.shape.fig <> s2.fig And NbSomCommuns(ff) > 0 Then
		      return true
		    end if
		  end if
		  
		  if not s2 isa point then
		    for i = 0 to s2.Points.count-1
		      if (s2.points(i).constructedby <> nil) and (s2.points(i).constructedby.shape isa point) then
		        //un point de s2 est image d'un point de self
		        p = point(s2.points(i).constructedby.shape)
		        k = s2.points(i).constructedby.oper
		        if  getindexpoint(p) <> -1  and  p.id >  id  then  //si p.id < id, le point source a été construit avant self, il appartient à une autre forme
		          //que self et c'est celle-là qui doit précéder s2
		          if (k=5) or (k=6) then
		            return  true
		          end if
		        else
		          if k = 6 then
		            tsf = transformation(s2.points(i).constructedby.data(0))
		            if tsf.supp =self then
		              return true
		            end if
		          end if
		        end if
		      end if
		    next
		  end if
		  
		  for k = 0 to tsfi.count-1
		    if s2.constructedby<> nil and s2.constructedby.oper = 6 and Transformation(s2.constructedby.data(0)) = tsfi.item(k) then
		      return true
		    end if
		  next
		  
		  if not s2 isa point then
		    for h = 0 to s2.Points.Count-1
		      if s2.points(h).constructedby <> nil and s2.points(h).constructedby.oper = 6  then
		        sh = Transformation(s2.points(h).constructedby.data(0)).supp
		        if sh = self or (sh isa point and  sh.id > id and (( getindex(point(sh)) <> -1) or  (sh.constructedby <> nil and sh.constructedby.shape = self )  ) ) then
		          return true
		        end if
		      end if
		      'if s2.points(h).pointsur.count = 2 and s2.points(h).pointsur.getposition(self) <> -1 then
		      'return true
		      'end if
		    next
		  end if
		  
		  
		  if self isa arc and s2 isa arc and points(2)=s2.points(1) then
		    return true
		  end if
		  
		  
		  if s2.haspointon(self, p) then ' and (not (s2.auto = 4)) then 'and not (isaparaperp(sh)  and sh.NbPtsCommuns(s2) >= 2 and haspointsimages(s2))   then
		    t =  (constructedby = nil or constructedby.shape <> s2)   ''si un sommet de s2 est pointsur self (sans que self soit construit par s2)
		    for k = 0 to npts-1
		      t = t or ( (points(k).constructedby = nil) or (points(k).constructedby.shape isa point and s2.getindex(point(points(k).constructedby.shape)) <> -1) )
		    next
		    if t then
		      return true
		    end if
		  end if
		  
		  if s2 isa polygon then
		    for i = 0 to s2.Points.count-1
		      p = s2.points(i)
		      q = s2.points((i+1) mod s2.Points.count)
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
		  
		  '
		  If isaparaperp And (s2.getindexpoint(points(1)) <> -1) And ( constructedby.shape <> s2 ) Then
		    Return True
		  end if
		  
		  if not (self isa arc) and  (self.auto = 3 or self.auto = 5) and s2.auto = 1 and NbPtsCommuns(s2) >= 2 then
		    return true
		  end if
		  
		  '''''''''''''''''''' Voir figurestest 1 et 2 : la méthode qui suit est un compromis pour satisfaire les deux (!?), les trois avec Varignon
		  If Not Self IsA point And  NbTrueSomCommuns(s2) = ubound(points)+1  And s2.Auto = 4  Then
		    t = True
		    for i = 0 to ubound(points)
		      if points(i).forme = 1 and points(i).pointsur.item(0).isaparaperp then
		        t = false
		      end if
		    next
		    return t
		  end if
		  
		  If Not Self IsA arc And Auto <>4 And NbTrueSomCommuns(s2) > 0 And  s2.Auto = 4 Then   'Décommentarizé pour le cas d'un quadri inscrit à un cercle avec un sommet qui définit le cercle
		    Return True
		  end if  'la contrainte not self isa arc correspond à une figure du Type "carré abcd + pt p sur bc + segment ap + arc (dap)
		  'Recommentarizé le 20 juillet 2019  : le cas du quadri n'apparaît plus mais d'autres problèmes montrent que cette possibilité est inopportune
		  'Exemple: parallèle à un côté d'un triangle passant par un sommet
		  
		  For i = 0 To ubound(childs)    // double emploi avec une autre condition ci-dessus
		    If childs(i).id > id Then
		      For j = 0 To ubound (childs(i).constructedshapes)
		        if s2.getindex(point(childs(i).constructedshapes(j))) <>-1 and childs(i).constructedshapes(j).constructedby.oper = 6 then
		          return true
		        end if
		      next
		    end if
		  next
		  
		  if s2.macconstructedby <> nil then
		    for i = 0 to ubound(s2.macconstructedby.RealInit)
		      h = s2.macconstructedby.RealInit(i)
		      sh = Objects.GetShape(h)
		      if self = sh or (sh isa point and (getindex(point(sh)) <> -1) and (sh.id > id)) then
		        return true
		      end if
		    next
		  end if
		  
		End Function
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
		Sub print(g as Graphics, sc As Double)
		  dim i as integer
		  dim cs as CurveShape
		  
		  if nsk <> nil then
		    nsk.updatefillcolor(fillcolor.col,fill)
		    if self isa polygon and not Hybrid then
		      for i = 0 to LSkull(nsk).count-1
		        cs = Lskull(nsk).item(i)
		        cs.bordercolor = colcotes(i).col
		      next
		    elseif self isa Bande then
		      nsk.item(0).bordercolor = colcotes(0).col
		      nsk.item(2).bordercolor = colcotes(1).col
		    else
		      nsk.updatebordercolor(bordercolor.col,border)
		    end if
		    nsk.Scale = nsk.Scale*sc
		    nsk.X = nsk.X * sc
		    nsk.Y = nsk.Y * sc
		    nsk.paint(g)
		    nsk.Scale = nsk.Scale/sc
		    nsk.X = nsk.X/sc
		    nsk.Y = nsk.Y/sc
		  end if
		  
		  for i = 0 to labs.count-1
		    Labs.item(i).print(g, sc)
		  next
		  
		  for i = 0 to ubound(childs)
		    childs(i).print(g, sc)
		  next
		  
		  
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
		Sub RemoveChild(s as shape)
		  dim p as point
		  
		  p = point(s)
		  
		  if childs.indexof(p) <> -1  then
		    Childs.remove childs.indexof(p)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveConstructedShape(s as shape)
		  
		  if Constructedshapes.IndexOf(s) <> -1 then
		    ConstructedShapes.remove Constructedshapes.IndexOf(s)
		  end if
		  
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
		    ff.shapes.removeobject self
		    if self isa point then
		      ff.somm.removeobject self
		      ff.ptssur.removeobject self
		      ff.ptsconsted.removeobject self
		    end if
		  end if
		  
		  fig.shapes.removeobject self
		  if self isa point then
		    fig.somm.removeobject self
		    fig.ptssur.removeobject self
		    fig.ptsconsted.removeobject self
		  end if
		  
		  fig = nil
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemovePoint(index as integer)
		  dim s as shape
		  dim i as integer
		  
		  RemovePoint(Points(index))
		  Points.Remove(index)
		  nsk.RemovePoint(index)
		  npts = npts-1
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemovePoint(Q as Point)
		  RemoveChild Q
		  Q.removeParent self
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub repositionnerpoints()
		  dim j as integer
		  
		  if self isa point and coord.tab(0) <> nil then
		    point(self).moveto coord.tab(0)
		  else
		    for j = 0 to npts-1
		      if coord.tab(j) = nil then
		        return
		      else
		        points(j).moveto coord.tab(j)   //On repositionne les sommets
		      end if
		    next
		  end if
		End Sub
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
		Function SameType(s as shape) As Boolean
		  return (gettype = s.gettype) or (self isa polygon and s isa polygon and s.npts = npts)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub selectgroup()
		  dim i as integer
		  
		  Objects.unselectobject self
		  for i = 0 to Objects.count-1
		    if objects.item(i).IdGroupe = IdGroupe  then
		      Objects.SelectObject(Objects.item(i))
		    end if
		  next
		  
		  
		End Sub
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
		      Objects.selectfigure(objects.selection.item(i).fig)
		      if objects.selection.item(i).centerordivpoint and not  objects.selection.item(i).ConstructedBy.Shape.selected then
		        Objects.selectobject(objects.selection.item(i).ConstructedBy.Shape)
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
		Function SelectShape(p as Basicpoint) As Shape
		  Dim i As Integer
		  dim S as Shape
		  'La forme est sélectionnée si p est à l'intérieur
		  
		  for i=0 to Ubound(Childs)
		    if not Childs(i).Hidden or WorkWindow.DrapShowALL  then
		      S=Childs(i).SelectShape(p)
		      if S<>nil then
		        return S
		      end if
		    end if
		  next
		  
		  for i = 0 to ubound(constructedshapes)
		    if  constructedshapes(i).centerordivpoint and (not Constructedshapes(i).hidden or WorkWindow.Drapshowall) then
		      s = constructedshapes(i).selectshape(p)
		      if S<>nil then
		        return S
		      end if
		    end if
		  next
		  
		  
		  if pInShape(p) and (not hidden or WorkWindow.DrapShowALL)  then
		    return self
		  else
		    return nil
		  end if
		  
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
		Sub SetConstructedBy(S as shape, Op as integer)
		  if constructedby <> nil and constructedby.shape <> nil then  'Inséré à cause des doites paraperp
		    constructedby.shape.RemoveConstructedShape self
		  end if
		  Constructedby = new ConstructionInfo(S, Op)
		  
		  if op <> 9 or s isa point then
		    S.AddConstructedShape self
		  end if
		End Sub
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
		      if  ubound(constructedby.data) = 0 then
		        tsf = new Transformation(constructedby.shape,0,constructedby.data(0), 0)
		        constructedby.data.append tsf
		      end if
		      tsf = transformation(constructedby.data(1))
		      fig.SetConstructedBy(s.fig, tsf)
		      tsf.constructedfigs.addobject fig
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
		Sub SetId(i as Integer)
		  self.id=i
		  objects.CheckId(i)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetMacConstructedBy(MacInfo as MacConstructionInfo)
		  dim i as integer
		  dim s as shape
		  
		  MacConstructedBy = MacInfo
		  for i = 0 to ubound(childs)
		    if childs(i).forme = 2 and childs(i).macconstructedby <> nil then
		      childs(i).forme = 3
		    end if
		  next
		  for i = 0 to ubound(MacInfo.RealInit)
		    s = currentcontent.TheObjects.getshape(macinfo.RealInit(i))
		    s.AddMacConstructedShape self
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetPoint(P as Point)
		  if p <> nil then
		    P.setParent(self)
		    SetChild P
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Show()
		  
		  
		  Hidden = false
		  
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
		Sub Swap()
		  dim i, j as integer
		  dim t as boolean
		  dim s as shape
		  
		  Hidden = not Hidden
		  
		  for i = 0 to ubound(childs)
		    t =true
		    
		    for j = 0 to ubound(childs(i).parents)
		      s = childs(i).parents(j)
		      if s.getindexpoint(childs(i)) <> -1 then
		        if not s.hidden or ubound(s.constructedshapes) <> -1 or ubound(s.macconstructedshapes) <> -1 then
		          t = false
		        end if
		      end if
		    next
		    
		    if  t then
		      for j = 0 to childs(i).pointsur.count-1
		        s = childs(i).pointsur.item(j)
		        t = t and s.hidden
		      next
		    end if
		    
		    childs(i).hidden = t
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEps(tos as TextOutputStream)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Transform(M as Matrix)
		  dim i As  Integer      // Utilisé pour les  mouvements Transform ne déplace pas les points qui sont "modified"
		  
		  if M <> nil and M.v1 <> nil then
		    for i = 0 to npts-1
		      Childs(i).Transform(M)
		    next
		    EndMove
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function TroisiemeIndex(n1 as integer, n2 as integer) As integer
		  dim i, n as integer
		  
		  for i = 0 to 2
		    if i <> n1 and i <> n2 then
		      n = i
		    end if
		  next
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UnHighLight()
		  dim i as integer
		  dim gr as ObjectsList
		  
		  if  self isa point then
		    highlighted = false
		  else
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
		    gr = objects.groupes(0)
		    for i = 0 to gr.count-1
		      gr.item(i).highlighted = false
		    next
		  end if
		  
		  if highlighted then
		    highlighted = false
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
		Sub updateconstructedpoints()
		  dim i as integer
		  
		  for i = 0 to npts-1
		    points(i).updateconstructedpoints
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateconstructedshapes()
		  Dim i As Integer
		  dim s2 as shape
		  dim tsf as Transformation
		  
		  If Self IsA circle Then
		    
		    For i = 0 To ubound(constructedshapes)
		      s2 = constructedshapes(i)
		      If s2. constructedby.oper = 6 Then
		        tsf = s2.constructedby.data(0)
		        tsf.modifyimages
		      End If
		    Next
		    
		  end if
		  
		  'updateshape
		  'For i = 0 To ubound(constructedshapes)
		  'constructedshapes(i).updateshape
		  'Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatecoord()
		  //updatecoord doit appara^tre dans endmove (à l'issue des mouvements) et updateshape (à l'issue des modifications)
		  dim i  as integer
		  
		  if coord = nil then
		    createcoord
		    return
		  end if
		  
		  if self isa point then
		    coord.tab(0) = point(self).bpt
		  else
		    for i = 0 to npts-1
		      coord.tab(i) = points(i).bpt
		    next
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatelab()
		  dim i as integer
		  dim pos as basicPoint
		  
		  if labs <> nil then
		    for i = 0 to labs.count-1
		      if not (labs.item(i).LockRight and labs.item(i).LockBottom) then
		        labs.item(i).SetPosition
		      end if
		    next
		  end if
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
		Sub updatelabel(k as double)
		  dim i as integer
		  dim r as double
		  
		  if labupdated then
		    return
		  end if
		  
		  
		  for i = 0 to labs.count-1
		    labs.item(i).setsize round(labs.item(i).Textsize * k)
		    labs.item(i).setposition
		    labs.item(i).correction = labs.item(i).correction*k
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
		Sub updateMacConstructedShapes()
		  dim Mac as Macro
		  dim MacInfo as MacConstructionInfo
		  dim i, j as integer
		  dim s1, s2 as shape
		  
		  
		  for i = 0 to ubound(MacConstructedShapes)
		    s1 = MacConstructedShapes(i)
		    MacInfo = s1.MacConstructedby
		    
		    Mac = Macinfo.Mac
		    if Mac = nil then
		      msgbox "La macro utilisée pour cette action est indisponible"
		      return
		    end if
		    Mac.Macexe(MacInfo)
		    for j = 0 to s1.npts-1
		      if s1.childs(j).MacConstructedShapes.indexof(s1) = -1 then
		        's1.childs(j).modified = true    //on ne peut pas marquer les points comme modifiés car ils dépendent éventuellement de plusieurs objets initiaux
		        s1.childs(j).updateshape
		      end if
		    next
		    'for j = 0 to ubound(MacInfo.RealInit)
		    's2 = objects.Getshape(MacInfo.RealInit(j))
		    ''s2.modified = true
		    'next
		    s1.updateshape
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateMatrixDuplicatedshapes(M as Matrix)
		  
		  dim j, k as integer
		  dim s as shape
		  dim M1, M2 as matrix
		  dim op as operation
		  
		  
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
		  op = currentcontent.currentoperation
		  if op = nil then
		    return
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
		Sub updateoldM()
		  dim i as integer
		  
		  for i = 0 to tsfi.count-1
		    tsfi.item(i).oldM = tsfi.item(i).M
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateShape()
		  Dim i As Integer   // Utilisé pour lesmodifications
		  dim s1, s2 As shape
		  dim inter as intersec
		  dim p as point
		  dim f1, f2 as figure
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
		      if p.forme = 2  then
		        s1 = p.pointsur.item(0)
		        s2 = p.pointsur.item(1)
		        f1 = s1.getsousfigure(s1.fig)
		        f2 = s2.getsousfigure(s2.fig)
		        if f1 <> f2 or f1.auto = 4 or f1.auto = 5 then  'polyqcq ou trap
		          inter = p.GetInter
		          inter.update(p)
		          p.updateconstructedpoints
		          p.UpdateMacConstructedshapes
		        end if
		      end if
		    next
		  end if
		  
		  if not hybrid then
		    modified = true
		    endmove
		    updateconstructedshapes
		    updateMacConstructedShapes
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateshape(M as Matrix)
		  dim i as integer    //Ici on s'occupe des points autres que les sommets
		  
		  if ubound(childs) >= npts then
		    for i = npts to ubound(childs)
		      childs(i).updateshape(M)
		    next
		  end if
		  updateshape
		  
		  
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
		  
		  if validating or not invalid then
		    return
		  end if
		  
		  validating = true
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
		  if not t then
		    validating = false
		    return
		  end if
		  
		  'for i = 0 to ncpts-1
		  't2 = t2 and points(i).modified
		  'next
		  'if t2 then
		  'end if
		  
		  
		  if self isa circle or self.hybrid then
		    coord.CreateExtreAndCtrlPoints(ori)
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
		  
		  'CurrentContent.Theobjects.validatefrom(self)
		  
		  for j = 0 to ubound(ConstructedShapes)
		    ConstructedShapes(j).valider
		  next
		  
		  for i = 0 to tsfi.count-1
		    if tsfi.item(i).type <> 0 then
		      tsfi.item(i).computematrix
		      tsfi.item(i).ModifyImages
		      for j = 0 to tsfi.item(i).constructedshapes.count -1
		        tsfi.item(i).constructedshapes.item(j).valider
		      next
		    end if
		  next
		  
		  validating = false
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValidSegment(p as BasicPoint, byref side as integer) As Boolean
		  if self isa droite and droite(self).nextre = 2 then
		    side = 0
		    return true
		  elseif self isa Lacet then
		    side = pointonside(p)
		    if side <> -1 then
		      return true
		    end if
		  end if
		  side = -1
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLColoritem(Doc as XMLDocument, namecol as string, col as color) As XMLElement
		  dim coul as couleur = new couleur(col)
		  return coul.XMLPutIncontainer(Doc,Namecol)
		  
		End Function
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
		  if not currentcontent.macrocreation and constructedby.oper <> 9 then
		    Temp.appendchild constructedby.shape.XMLPutIdInContainer(Doc)  //redondance par souci de compatibilité
		  end if
		  // Id ou pas Id ? sans Id, peut devenir atroce
		  select case Constructedby.oper
		  case 1,2
		    Temp.SetAttribute("Index", str(constructedby.data(0)))
		    Temp.SetAttribute("Ori", str(constructedby.data(2)))
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
		    i = tsf.GetNum                                              'pour le cas ou une forme supporte plusieurs tsf
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
		    Form.SetAttribute("Ori", str(ori))
		  end if
		  if not pointe then
		    Form.SetAttribute("NonPointed","1")
		  end if
		  if conditionedby <> nil then
		    Form.SetAttribute("Condby", str(conditionedby.id))
		  end if
		  if Ti <> Nil then
		    Form.setattribute("TiP","1")
		  end if
		  if not currentcontent.macrocreation then
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
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  Dim Form, Temp As XMLElement
		  dim i, n as integer
		  
		  Form = XMLPutIdInContainer(Doc)
		  if fig <> nil and not self isa repere then
		    Form.SetAttribute("FigId",str(fig.idfig))
		  End If
		  If Self IsA lacet And lacet(self).autointer <> Nil Then
		    Form.SetAttribute("AutoInter",Str(1))
		  end if
		  if labs <> nil then
		    for i = 0 to labs.count-1
		      form.appendchild labs.item(i).toXML(Doc)
		    next
		  end if
		  Form.AppendChild  XMLPutChildsInContainer(Doc)
		  if  NbPtsConsted > 0 then
		    Form.appendchild XMLPutPtsConstedInContainer(Doc)
		  end if
		  if self.hybrid and not self isa arc then
		    form.AppendChild (Lacet(self).XMLPutInfosArcs(Doc))
		  End If
		  'If Self IsA Lacet And lacet(Self).autointer <> Nil Then
		  
		  if constructedby <> nil then
		    form.appendchild XMLPutConstructionInfoInContainer(Doc)
		  end if
		  if Macconstructedby <> nil then
		    form.appendchild XMLPutMacConstructionInfoInContainer(Doc)
		  end if
		  if not currentcontent.macrocreation then
		    if self isa Lacet then
		      if self isa cube then
		        n = 8
		      elseif self isa Bande or self isa secteur  then
		        n = 1
		      else
		        n = npts-1
		      end if
		      for i = 0 to n
		        Form.AppendChild  colcotes(i).XMLPutIncontainer(Doc, Dico.Value("ToolsColorBorder"))
		      next
		    else
		      Form.AppendChild BorderColor.XMLPutIncontainer(Doc, Dico.Value("ToolsColorBorder"))
		    end if
		    if not self isa bipoint  then
		      Temp = fillcolor.XMLPutInContainer(Doc, Dico.Value("ToolsColorFill"))
		      Temp.SetAttribute("Opacity", str(fill))
		      Temp.SetAttribute("OpacityBorder", str(border))
		      Form.AppendChild  Temp
		    end if
		    Temp = Doc.CreateElement(Dico.Value("Thickness"))
		    Temp.SetAttribute("Value", str(borderwidth))
		    Form.AppendChild Temp
		    Temp = Doc.CreateElement(Dico.Value("Pointed"))
		    if pointe then
		      Temp.SetAttribute("Value", str(1))
		    else
		      Temp.SetAttribute("Value", str(0))
		    end if
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
		Function XMLPutMacConstructionInfoInContainer(Doc as XMLDocument) As XMLElement
		  dim Temp as XMLElement
		  
		  Temp = Doc.CreateElement("MacConstructedBy")
		  if MacConstructedby.Mac <> nil then
		    Temp.SetAttribute("Macro", MacConstructedBy.Mac.Caption)
		  end if
		  Temp.AppendChild MacConstructedBy.XMLPutInContainer(Doc)
		  
		  return Temp
		End Function
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
		Function XMLPutTsfInContainer(Doc as XMLDocument) As XMLElement
		  dim i as integer
		  dim Form as XMLElement
		  
		  if tsfi.count = 0 then
		    return nil
		  end if
		  
		  Form = Doc.CreateElement(Dico.value("TransfosMenu"))
		  
		  for i = 0 to tsfi.count-1
		    Form.appendchild tsfi.item(i).XMLPutInContainer(Doc)
		  next
		  
		  return Form
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLReadColoritem(S as string, EL as XMLElement, Byref c as couleur, Byref Temp as XMLElement) As Boolean
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
		Sub XMLReadConstructionInfo(Temp as XMLElement)
		  Dim m, oper As Integer
		  dim  Tmp, EL as XMLElement
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
		      XMLReadConstructionInfoDivPoint(Tmp, s)
		    case 5
		      XMLReadConstructionInfoCutPoints(Tmp)
		    case 6
		      XMLReadConstructionInfoImgPt(Tmp)
		    case 7
		      XMLReadConstructionInfoPtFix(Tmp)
		    case 8
		      XMLReadConstructionInfoProl(Tmp)
		    case 9
		      XMLReadConstructionInfoMerge(Tmp)
		    case 10
		      XMLReadConstructionInfoDuplPoint(Tmp)
		    Case 45
		      XMLReadConstructionInfoAutoInter(Tmp)
		      
		    end select
		    if self isa point then
		      point(self).mobility
		      point(self).updateguides
		    end if
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoAutoInter(Tmp as XMLElement)
		  
		  If ubound(constructedby.data) = -1 Then
		    constructedBy.data.append Val(Tmp.GetAttribute("Side1"))
		    constructedBy.data.append Val(Tmp.GetAttribute("Side2"))
		  End If
		  
		  
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
		  
		  if self isa Lacet then
		    Lacet(self).coord.CreateExtreAndCtrlPoints(ori)
		  else
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
		          currentcontent.removeobject s1
		        else
		          Point(s1).mobility
		        end if
		      next
		    end if
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoDivPoint(Tmp as XMLElement, s as shape)
		  Dim n As Integer
		  
		  if ubound(constructedby.data) = -1 then
		    n = Val(Tmp.GetAttribute("Id0"))
		    constructedBy.data.append Point(objects.getshape(n))
		    n = Val(Tmp.GetAttribute("Id1"))
		    constructedBy.data.append Point(objects.getshape(n))
		    constructedBy.data.append Val(Tmp.GetAttribute("NDivP"))
		    constructedBy.data.append Val(Tmp.GetAttribute("DivP"))
		    if s isa Lacet then
		      constructedBy.data.append val(Tmp.GetAttribute("Side"))
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoDuplicate(Tmp as XMLElement)
		  dim x, y as double
		  dim Mat as Matrix
		  dim j as integer
		  
		  Mat = new Matrix(Tmp)
		  
		  constructedby.data.append Mat
		  'if not self isa point then
		  'for j = 0 to npts-1
		  'points(j).setconstructedby constructedby.shape.points(j), 3
		  'points(j).constructedby.data.append Mat
		  'points(j).mobility
		  'points(j).updateguides
		  'next
		  'end if
		  if self isa droite then
		    if forme = 1 or forme = 2 then
		      forme = 0
		    elseif forme = 4 or forme = 5 then
		      forme = 3
		    end if
		    auto = 1  'Eventuellement 4 Si les bipoints sont assimilés à des polyqcq
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoDuplPoint(Tmp as XMLElement)
		  ConstructedBy.data.append val(Tmp.Getattribute("Data0"))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoImgPt(Tmp as XMLElement)
		  dim j, n as integer
		  dim s1 as shape
		  dim tsf as Transformation
		  
		  n = val(Tmp.GetAttribute("SuppTsf"))
		  if n <> 0 then
		    s1 = objects.getshape(n)
		    j = val(Tmp.GetAttribute("Nr"))
		    if j = -1 then
		      j = 0
		    end if
		    if s1 <> nil then
		      tsf = s1.tsfi.item(j)
		    else
		      return
		    end if
		  elseif self isa point and ubound(point(self).parents) > -1 then
		    s1 = point(self).parents(0)
		    if s1.constructedby <> nil and s1.constructedby.oper = 6 then
		      tsf = Transformation(s1.constructedby.data(0))
		    end if
		  else
		    app.abortread
		  end if
		  
		  if tsf <> nil then
		    tsf.setconstructioninfos1(constructedby.shape,self)
		    if (tsf.type = 9 or tsf.type = 11) and self isa freecircle then
		      coord.CreateExtreAndCtrlPoints(ori)
		    end if
		  end if
		  auto = 0
		  
		  Exception err
		    var d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("Tmp", Tmp)
		    d.setVariable("n", n)
		    d.setVariable("j", j)
		    d.setVariable("tsf", tsf)
		    err.message = err.message+d.getString
		    
		    Raise err
		End Sub
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
		    Fus1 = Objects.Getshape(val(EL0.GetAttribute("Id")))
		    constructedby.data.append Fus1
		    M1 =new Matrix(EL0)
		    constructedby.data.append M1
		    Fus1.AddConstructedShape self
		    
		    EL0 = XMLElement(Temp.child(1))
		    Fus2 = Objects.Getshape(val(EL0.GetAttribute("Id")))
		    constructedby.data.append Fus2
		    M2 = new Matrix(EL0)
		    constructedby.data.append new Matrix(EL0)
		    Fus2.AddConstructedShape self
		    
		  else
		    
		    Fus = Polygon(Objects.Getshape(val(Temp.GetAttribute("IdParent"))))
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
		  
		  
		  Exception err
		    var d as Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("Fus", Fus)
		    d.setVariable("Fus1", Fus1)
		    d.setVariable("Fus2", Fus2)
		    err.message = err.message + d.getString
		    raise err
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoParaperp(Tmp as XMLElement)
		  dim m,o as integer
		  dim tsf as transformation
		  
		  m = val(Tmp.GetAttribute("Index"))
		  o = val(Tmp.GetAttribute("Ori"))
		  constructedby.data.append m
		  tsf = constructedby.shape.gettsf(0,m)
		  if tsf = nil then
		    tsf = new Transformation(constructedby.shape,0,m,o)
		  end if
		  constructedby.data.append tsf
		  constructedby.data.append o  //15 juin 2014
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadConstructionInfoProl(Tmp as XMLElement)
		  constructedby.data.append val(Tmp.GetAttribute("Index"))
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
		  tsf = s1.tsfi.item(j)
		  constructedby.data.append tsf
		  tsf.Fixpt = point(self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadInfoArcs(EL as XMLElement)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadMacConstructionInfo(Temp as XMLElement)
		  dim List as XmlNodeList
		  dim Tmp as XMLElement
		  dim cap as string
		  dim MacInfo as MacConstructionInfo
		  dim Mac as Macro
		  
		  List = Temp.XQL("MacConstructedBy")
		  if List.Length > 0 then
		    Tmp = XMLElement(List.Item(0))
		    cap = TMP.GetAttribute("Macro")
		    Mac =app.TheMacros.GetMacro(cap)
		    Tmp = XMLElement(Tmp.Child(0))
		    MacInfo = new MacConstructionInfo(Mac,Tmp)
		    SetMacConstructedBy MacInfo
		    auto = 0
		  end if
		End Sub
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
		Sub XMLReadPtsConsted(Temp as XMLElement)
		  dim i as integer
		  dim EL,  EL1 as XMLElement
		  dim p as point
		  dim List As XMLNodelist
		  
		  List = Temp.XQL("PtsConsted")
		  if List.Length > 0 then
		    EL = XMLElement(List.Item(0))
		    for i = 0 to EL.Childcount-1
		      EL1 = XMLElement(EL.Child(i))
		      p = XMLReadPoint(EL1)
		      p.XMLReadConstructionInfo(El1)
		      objects.addshape p
		      p.liberte = 0
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadPtsSur(Temp as XMLElement)
		  dim i , IdPoint3 as integer
		  dim EL,  EL1 as XMLElement
		  dim List As XMLNodelist
		  dim pt, pt3 as point
		  
		  List = Temp.XQL("Childs")
		  if List.Length  > 0 then
		    EL = XMLElement(List.Item(0))
		    for i = npts to EL.Childcount-1
		      EL1 =  XMLElement(EL.Child(i))
		      pt = XMLReadPoint(EL1)  //pt est un point
		      if pt.pointsur.count = 0 then //si on n'a pas encore lu  les caractéristiques de ce pointsur, on les lit; NE PAS REMPLACER par pt.forme
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
		  'if pt3.pointsur.item(0) = self then
		  'supphom(self).DRAP = false
		  'supphom(self).Bip = nil
		  'else
		  'supphom(self).DRAP = true
		  'supphom(self).Bip = BiPoint(pt3.pointsur.item(0))
		  'end if
		  'supphom(self).Point3 = pt3
		  'end if
		  'end if
		End Sub
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
		      tsfi.addObject new Transformation(self, XMLElement(EL.child(i)))
		    next
		  end if
		  
		  if not self isa point then
		    List = Temp.XQL("Childs")
		    if list.length > 0 then
		      EL =  XMLElement(List.Item(0))
		      for i = 0 to min(EL.ChildCount-1, childs.Count-1)
		        childs(i).XMLReadTsf(XMLElement(EL.child(i)))
		      next
		    end if
		  end if
		  
		  
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

	#tag Note, Name = Npts et Ncpts
		
		Npts est le nombre de points d'une forme.
		Par exemple: le nombre de sommets d'un polygone.
		Pour un segment, une droite ou un cercle libre : 2
		Pour un cercle standard: 1
		
		Ncpts est le nombre de points à fixer par l'utilisateur
		lors d'une construction à la souris.
	#tag EndNote


	#tag Property, Flags = &h0
		ArcAngle As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		area As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Attracting As boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		auto As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Biface As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Border As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Bordercolor As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		Borderwidth As double
	#tag EndProperty

	#tag Property, Flags = &h0
		Childs(-1) As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		colcotes(-1) As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		colsw As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		conditionedby As point
	#tag EndProperty

	#tag Property, Flags = &h0
		ConstructedBy As ConstructionInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		ConstructedShapes(-1) As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		coord As nBPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		deleted As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drapori As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		fam As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Fig As Figure
	#tag EndProperty

	#tag Property, Flags = &h0
		Fill As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Fillcolor As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		firstcurrentattractingshape As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		Fleche As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		forme As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		GC As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		Hidden As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Highlighted As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		id As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		IDGroupe As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		ifmac As InfoMac
	#tag EndProperty

	#tag Property, Flags = &h0
		IndexConstructedPoint As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Invalid As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		IsInConstruction As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Labs As Lablist
	#tag EndProperty

	#tag Property, Flags = &h0
		labupdated As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Liberte As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ListSommSur(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		MacConstructedby As MacConstructionInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		MacConstructedShapes() As Shape
	#tag EndProperty

	#tag Property, Flags = &h0
		Mmove As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		Modified As Boolean = false
	#tag EndProperty

	#tag Property, Flags = &h0
		narcs As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ncpts As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		npts As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		nsk As nskull
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected objects As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		OldIdGroupes(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Ori As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		paraperp As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		plan As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Pointe As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Points(-1) As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		selected As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		side As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		signaire As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		std As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Ti As Tip
	#tag EndProperty

	#tag Property, Flags = &h0
		tobereconstructed As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		TracePt As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		tsfi As TransfosList
	#tag EndProperty

	#tag Property, Flags = &h0
		tsp As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		unmodifiable As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Validating As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ArcAngle"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="area"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Attracting"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="auto"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Biface"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Borderwidth"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsw"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="deleted"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapori"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="fam"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fleche"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="forme"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Highlighted"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="id"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IDGroupe"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
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
			Name="IndexConstructedPoint"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Invalid"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsInConstruction"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="labupdated"
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
			Name="Liberte"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Modified"
			Visible=false
			Group="Behavior"
			InitialValue="false"
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
			Name="narcs"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncpts"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="npts"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ori"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="plan"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Pointe"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="selected"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="signaire"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="std"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
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
		#tag ViewProperty
			Name="TracePt"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="tsp"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="unmodifiable"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Validating"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="paraperp"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
