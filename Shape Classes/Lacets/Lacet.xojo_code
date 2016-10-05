#tag Class
Protected Class Lacet
Inherits Shape
	#tag Method, Flags = &h0
		Sub AddPoint(p as BasicPoint)
		  'Sert à introduire les points correspondants aux points de découpe. Les  côtés correspondants sont nécessairement rectilignes sauf ptet le dernier.
		  dim k as integer
		  dim s as shape
		  dim Pt as Point
		  
		  s = constructedby.shape
		  if npts = 0 then
		    Points(0).moveto p
		    Pt = Points(0)
		  else
		    Pt = new Point(objects,p)
		    Points.append Pt
		    SetPoint(Pt)
		  end if
		  npts = npts+1
		  ncpts = ncpts+1
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Aire() As double
		  dim A, r,  alpha, beta as double
		  dim i as integer
		  dim c, p, q as BasicPoint
		  
		  A = 0
		  
		  for i = 0 to npts-1
		    if coord.curved(i) = 0 then
		      A = A +points(i).bpt.Vect(points((i+1) mod npts).bpt)
		    else
		      r = getradius(i)
		      alpha = getarcangle(i)
		      c = coord.centres(i)
		      p = Points(i).bpt
		      p = p-c
		      q = new BasicPoint(p.y,-p.x)
		      
		      A = A+ r^2*alpha
		      A = A + c*(p*sin(alpha)+ q*(cos(alpha) -1))
		    end if
		  next
		  A = A/2
		  return A
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function computeangle(n as integer, q as Basicpoint) As double
		  dim Ag as angle   //position d'un point sur l'arc d'origine en points(n)
		  dim Bib as BiBPoint
		  
		  Bib = new BiBPoint(points(n).bpt, q)
		  Ag = new Angle(Bib, coord.centres(n), ori)
		  return Ag.alpha
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist)
		  Shape.Constructor(ol)
		  fam = 7
		  forme = 0
		  npts = 0
		  ncpts = 0
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, d as integer, p as basicpoint)
		  shape.constructor(ol,d,d)
		  Points.append new Point(ol, p)
		  setPoint(Points(0))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, s as Lacet, q as BasicPoint)
		  dim i as integer
		  dim P As Point
		  dim M as Matrix
		  
		  Shape.constructor(ol,s)
		  PasteCtrlExe(s)
		  CreateSkull(q)
		  InitCurvesOrders
		  M = new TranslationMatrix(q)
		  Move(M)
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createskull(p as BasicPoint)
		  
		  dim i as integer
		  dim ncurv as integer
		  
		  ncurv = 2*narcs + npts  'Chaque côté incurvé comporte trois sous-arcs
		  nsk = new LSkull(ncurv, p)
		  nsk.skullof = self
		  'Il faut préciser la position des côtés incurvés, via le tableau curved, voir "InitConstruction"
		  'createskull peut être placé dès que narcs et npts ont été définis
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndConstruction()
		  super.endconstruction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as BasicPoint, n as integer)
		  dim i as integer
		  
		  
		  if n = ncpts-1 then  ' and not std then
		    points(n).moveto p
		    constructshape
		  else
		    for i = n to npts-1
		      Points(i).MoveTo(p)
		    next
		    if n < ncpts then
		      Lskull(nsk).item(n).border = 100
		    end if
		  end if
		  updatecoord
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetArcAngle(k as integer) As double
		  dim Bib as BiBPoint
		  dim Ag as Angle
		  
		  if coord.curved(k)=0 then
		    return 0
		  end if
		  Bib = new BiBPoint(points(k).bpt, points((k+1) mod npts).bpt)
		  Ag = new Angle(Bib, coord.centres(k), ori)
		  return Ag.alpha
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBoundingRadius() As double
		  dim br As Double
		  dim i as integer
		  dim q as basicpoint
		  
		  q=GetGravitycenter
		  
		  Br = coord.BoundingRadius
		  if not self isa polygon then
		    for i = 0 to ubound(coord.ctrl)
		      if coord.ctrl(i) <> nil then
		        Br = max(Br,q.Distance(coord.ctrl(i)))
		      end if
		    next
		  end if
		  
		  return Br
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCentre(k as integer) As BasicPoint
		  return coord.centres(k)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGravitycenter() As BasicPoint
		  dim g as BasicPoint
		  dim i as integer
		  
		  g = new BasicPoint(0,0)
		  
		  for i = 0 to npts-1
		    g = g + points(i).bpt
		  next
		  
		  if self isa polygon then
		    g = g/npts
		    return g
		  else
		    for i = 0 to ubound(coord.extre)
		      g = g+ coord.extre(i)
		    next
		    g = g/(npts+ubound(coord.extre)+1)
		    return g
		  end if
		  
		  'return coord.getgravitycenter
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRadius(k as integer) As double
		  if coord.curved(k) = 1 then
		    return coord.centres(k).distance(points(k).bpt)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSide(i as integer) As Droite
		  dim d as Droite
		  
		  if coord.curved(i) = 0 then
		    d = new Droite(Points(i),Points((i+1) mod npts))
		    d.nextre = 2
		  end if
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetStartAngle(k as integer) As double
		  dim q as BasicPoint
		  
		  q = Points(k).bpt - coord.centres(k)
		  return q.anglepolaire
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.Value("Compo")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitColcotes()
		  dim i as integer
		  
		  redim colcotes(-1)
		  redim colcotes(npts-1)
		  
		  for i = 0 to npts-1
		    colcotes(i) = Config.bordercolor
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitConstruction()
		  
		  
		  Super.InitConstruction
		  initcolcotes
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitCurvesOrders()
		  dim i, j, k  as integer
		  
		  if nsk = nil then
		    return
		  end if
		  
		  j = 0
		  
		  for i = 0 to npts-1
		    if coord.curved(i) = 0 then
		      nsk.item(j).order = 0
		      j = j+1
		    else 
		      for k = 0 to 2
		        nsk.item(j+k).order = 2
		      next
		      j = j+3
		    end if
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertPoint(k as integer, Pt as Point)
		  dim Q as Point
		  dim s as shape
		  
		  Points.Insert(k,Pt)
		  Childs.Insert(k,Pt)
		  Pt.setParent(self)
		  
		  npts = npts+1
		  '
		  'Q= Point(Pt.Constructedby.shape)
		  's = constructedby.shape
		  
		  'if s.Hybrid then
		  'k = s.getindexpoint(Q)
		  'if k = -1 then
		  'k =Lacet(s).pointoncurvedside(Q.bpt)
		  'end if
		  'end if
		  
		  
		  'if  s.pointonside(Q.bpt) = -1 or (not (s.Hybrid)) or (s.Hybrid and ( (k = -1) or( Lacet(s).coord.curved(k) = 0) ) ) then
		  'coord.curved.append 0
		  'coord.centres.append nil
		  'else
		  'coord.curved.append 1
		  'if s isa circle then
		  'coord.centres.append s.getgravitycenter
		  'elseif s.Hybrid then
		  'coord.centres.append Lacet(s).Getcentre(k)
		  'end if
		  'end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextArc(j as integer) As integer
		  dim k as integer
		  
		  k = j
		  while k <= npts-1 and coord.curved(k) =0
		    k=k+1
		  wend
		  return k
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextBorderPoint(P as Point, p2 as point) As Point
		  dim k, k2 as Double
		  
		  if pointoncurvedside(p2.bpt) = -1 then
		    k2 = parametre(p2)
		  else
		    k2=parametresurlacet(p2)
		  end if
		  
		  if pointoncurvedside(p.bpt) = -1 then
		    k = parametre(p)
		  else
		    k=parametresurlacet(p)
		  end if
		  
		  
		  if floor(k) = floor(k2) and k <= k2 then  //p et p2 sont sur le même côté
		    return p2
		  else
		    if k < ceil(k) then                                   //p n'est pas l'extrémité du côté
		      k = ceil(k) mod npts                          //on passe au premier entier supérieur à k
		    else
		      k = (k+1) mod npts                          //c'est aussi le premeir entier supérieur à k
		    end if                                                      'k est le numéro du sommet qui suit immédiatement p
		    return points(k)
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as Graphics)
		  dim i as integer
		  
		  super.paint(g)
		  
		  if not isinconstruction and  not hidden and Ti <> nil then
		    for i = 0 to npts-1
		      PaintTipOnside(g, i)
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paintside(g as graphics, cot as integer, ep as double, coul as couleur)
		  dim i, n as integer
		  
		  n = 0
		  
		  for i = 0 to cot-1
		    if coord.curved(i)=0 then
		      n=n+1
		    else
		      n = n+3
		    end if
		  next
		  
		  nsk.paintside(g, n, ep, coul)
		  
		  if coord.curved(cot) = 1 then
		    for i = 1 to 2
		      nsk.paintside(g, n+i, ep, coul)
		    next
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PaintTipOnSide(g as graphics, i as integer)
		  
		  dim Bib as BiBPoint
		  dim Trib as TribPoint
		  dim m, a, b, e as BasicPoint
		  
		  a = coord.tab(i)
		  b = coord.tab((i+1)mod npts)
		  
		  if coord.curved(i) = 0 then
		    Bib = new BibPoint(a,b)
		    m = BiB.Subdiv(2,1)
		    e = (b-a)*0.1
		    a = m-e
		    b = m+e
		  else
		    Trib = new TriBPoint(coord.centres(i),a,b)
		    b = Trib.Subdiv(ori,2,1)
		    e = b - coord.centres(i)
		    e = e.vecnorperp
		    e = e*0.1*ori
		    a = b-e
		  end if
		  PaintTip(a, b, bordercolor, 0.5, g)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function parametre(p as point) As double
		  dim k as integer
		  dim r as double
		  
		  r = -1
		  k = getindexpoint(p)
		  if k <> -1 then
		    r = k
		  else
		    k = pointonside(p.bpt)
		    if k <> -1 then
		      r =  k + p.bpt.location(points(k).bpt, points((k+1) mod npts).bpt)
		    end if
		  end if
		  return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function parametresurlacet(p as point) As double
		  dim k as integer
		  dim r as double
		  
		  r = -1
		  k = getindexpoint(p)
		  if k <> -1 then
		    r = k
		  else
		    k = pointonside(p.bpt)
		    r =  k + p.bpt.location(self, k)
		  end if
		  return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As Lacet
		  dim s as Lacet
		  dim M as Matrix
		  
		  s= new Lacet(Obl,self,p)
		  
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(P as BasicPoint) As Boolean
		  dim i, j, n as integer
		  dim bib1, BiB2 as BiBpoint
		  dim q, bq, v, bp(), r as BasicPoint
		  dim c as Boolean
		  dim r1, r2 as double
		  
		  c= false
		  q = new BasicPoint (1,0)
		  BiB1 = new BiBPoint(p,p+q)
		  
		  for i = 0 to npts-1
		    if coord.curved(i) = 1 then
		      BiB2 = new BiBPoint(coord.centres(i),Points(i).bpt)
		      n = BiB1.BiBDemiDroiteInterCercle(BiB2, bp(), bq, v)
		      for j = 1 downto 0
		        if bp(j) = nil then
		          bp.remove j
		        end if
		      next
		      for j = n-1 downto 0
		        if PointOnSide(bp(j)) = i then
		          c = not c
		        end if
		      next
		    else
		      BiB2 = new BiBPoint(Points(i).bpt, Points((i+1) mod npts).bpt)
		      r = BiB1.BiBInterDroites(BiB2,1,2,r1,r2)
		      if r <> nil and PointOnSide(r) = i then
		        c = not c
		      end if
		    end if
		  next
		  return c
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnCurvedSide(P as BasicPoint) As integer
		  dim i, k as integer
		  
		  k=-1
		  for i = 0 to npts-1
		    if p.distance(Points(i).bpt) < epsilon then
		      k = i
		    end if
		  next                                              // Si k <> -1, Le point source de Pt  est le  sommet n°k de la forme découpée
		  
		  if k = -1 then
		    k = PointOnSide(p)               //sinon il  est sur le côté n°k de cette forme.
		  end if                                          //Dans les deux cas, if faut voir si le sommet n°k est à l'origine d'un côté curviligne
		  
		  if k <> -1 and coord.curved(k) = 0 then                     //si ce sommet n'est pas l'origine d'un arc
		    return -1
		  else
		    return k                                  //sinon, on retourne son numéro qui est aussi le numéro du côté issu du point source de Pt
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As integer
		  dim i, n as integer
		  dim delta, cx as double
		  dim Bib as BiBPoint
		  dim A as angle
		  
		  delta = can.MagneticDist
		  
		  for i = 0 to npts-1
		    if coord.curved(i) = 0 then
		      if  p.distance(Points(i).bpt,Points((i+1) mod npts).bpt ) <= delta   and p.between(Points(i).bpt,Points((i+1) mod npts).bpt)  then
		        return i
		      end if
		    else
		      BiB = new BiBpoint(Points(i).bpt,p)
		      A = new Angle(Bib, coord.centres(i), ori)
		      cx = p.distance(coord.centres(i))
		      if abs(cx-coord.centres(i).distance(points(i).bpt))<= delta  and abs(A.alpha) <= abs(GetArcAngle(i))  then
		        return i
		      end if
		    end if
		    
		  next
		  
		  return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Positionner(p as point)
		  dim a,b, q as BasicPoint
		  dim alpha,angle as double
		  dim i, k, n,num as integer
		  dim CutPt as Boolean
		  dim r as double
		  
		  n = p.Pointsur.getposition(self)
		  i=0
		  while (i<= UBound(p.ConstructedShapes) and not Cutpt)   'si c'est un point de découpe, on le maintient sur le même côté
		    if p.ConstructedShapes(i).ConstructedBy.Oper=5 or  point(p.constructedshapes(i)).surseg  or p.surseg then
		      CutPt =true
		    else
		      i=i+1
		    end if
		  wend
		  
		  n = p.Pointsur.getposition(self)
		  
		  if not CutPt and not p.surseg then
		    num = PointonSide(p.bpt)
		    if (num <> -1) and (num <> p.numside(n))  then                                      //on vérifie si le point change de côté
		      p.numside(n) = num
		    end if
		  end if
		  k = p.numside(n)
		  if k < npts and k > -1  then
		    a =Points(k).bpt
		    b =Points((k+1) mod npts).bpt
		    if coord.curved(k) = 0 then
		      p.location(n) = p.bpt.location(a,b)
		      if p.pieddeperp then                            'Pour les pieds de hauteur
		        if p.location(n) <0 or p.location(n) >1 then
		          p.invalider
		        else
		          p.valider
		          p.putonsegment(a,b,p.location(n),n)
		        end if
		      else
		        p.putonsegment(a,b,p.location(n),n)
		      end if
		    else
		      angle = computeangle(k,p.bpt)
		      p.putonarc(a,b,coord.centres(k),angle, GetArcAngle(k),GetStartAngle(k), n)
		    end if
		  end if
		  
		  setpoint p
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrepareSkull(p as BasicPoint)
		  redim coord.extre(-1)
		  redim coord.ctrl(-1)
		  redim coord.extre(2*narcs-1)
		  redim coord.ctrl(6*narcs-1)
		  Createskull(p)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SideLength(n as integer) As double
		  
		  
		  if coord.curved(n) = 0  then
		    return Points(n).bpt.distance(Points((n+1) mod npts).bpt)
		  else
		    return GetArcAngle(n)*GetRadius(n)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SubSectPInShape(i as integer, p as BasicPoint) As Boolean
		  dim BiB as BiBPoint
		  dim cx as double
		  dim A as Angle
		  
		  if coord.curved(i) = 0 then
		    return false
		  end if
		  BiB = new BiBpoint(Points(i).bpt,p)
		  A = new Angle(Bib, coord.centres(i), ori)
		  cx = p.distance(coord.centres(i))
		  if cx <= coord.centres(i).distance(points(i).bpt)  and A.alpha <= GetArcAngle(i)  then
		    return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos as textoutputStream)
		  dim Source as Shape
		  dim M as Matrix
		  dim i as integer
		  dim s as string
		  dim r as double
		  dim support as BasicPoint
		  
		  Source = ConstructedBy.shape
		  
		  if source isa circle and not hidden then
		    
		    support = coord.centres(2)
		    r = support.distance(points(0).bpt)
		    
		    s = "[ "
		    for i = 0 to npts-2
		      s = s+ " " + Points(i).etiquet+ " "
		    next
		    s = s + " [ [ " + points(npts-1).etiquet + " [ "  + str(support.x) + " " + str(support.y) + " ] " + points(0). etiquet + " ] " + str(ori*r) + " ] arcsecteur "
		    
		    s = s+"]"
		    
		    if fill > 49 then
		      tos.writeline  s + " lacetrempli "
		    else
		      tos.writeline s + "lacet"
		    end if
		    
		    s = "[ "
		    for i = 0 to npts-1
		      s = s+ " " + Points(i).etiquet+ " "
		    next
		    s = s + " ] "
		    tos.writeline s + " suitepoints "
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateshape()
		  dim i, k as integer   // Utilisé pour lesmodifications
		  dim s1, s2 As shape
		  dim p as point
		  dim  f2 as figure
		  dim M as Matrix
		  
		  
		  super.updateshape
		  
		  if  constructedby <> nil  then
		    s1 = constructedby.shape
		    select case constructedby.oper
		    case 5
		      M = Matrix(ConstructedBy.Data(0))
		      for i = 0 to npts-1
		        if coord.curved(i) = 1 then
		          if s1 isa circle then
		            coord.centres(i) = M*s1.points(0).bpt
		          else
		            p = point(points(i).constructedby.shape)
		            k = s1.getindexpoint(p)
		            if k = -1 then
		              k = Lacet(s1).PointOnCurvedSide(p.bpt)
		            end if
		            coord.centres(i) = M*Lacet(s1).Getcentre(k)
		          end if
		        end if
		      next
		    case 6
		      M = Transformation(ConstructedBy.Data(0)).M
		      for i = 0 to npts-1
		        if s1.coord.centres(i) <> nil then
		          coord.centres(i) = M*s1.coord.centres(i)
		        end if
		      next
		    end select
		  end if
		  
		  
		  if hybrid then'Lacet(self).
		    coord.CreateExtreAndCtrlPoints(ori)
		  end if
		  'elseif not self isa bipoint then
		  'coord.CreateExtreAndCtrlPoints(ori)
		  'end if
		  
		  modified = true
		  endmove
		  updateMacConstructedShapes
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInfosArcs(Doc as XMLDocument) As XMLElement
		  dim  Form, EL, EL1 as XMLElement
		  dim i as integer
		  
		  Form = Doc.CreateElement("InfosArcs")
		  EL = Doc.CreateElement("Supports")
		  EL.SetAttribute("N",str(narcs))
		  for i = 0 to npts-1
		    if coord.curved(i) = 1 then
		      EL1 = Doc.CreateElement("Centre")
		      EL1.SetAttribute("Nr", str(i))
		      EL1.SetAttribute("CoordX",str(coord.centres(i).x))
		      EL1.SetAttribute("CoordY",str(coord.centres(i).y))
		    end if
		    EL.AppendChild EL1
		  next
		  Form.appendchild EL
		  Return Form
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLReadInfoArcs(Temp as XMLElement)
		  dim List as XMLNodeList
		  dim EL, EL1, EL2 as XMLElement
		  dim i, k as integer
		  
		  List = Temp.Xql("InfosArcs")
		  if List.length > 0 then
		    EL = XMLElement(List.Item(0))
		    EL1= XMLElement(EL.firstchild)
		    narcs = val(EL1.GetAttribute("N"))
		    if narcs = 0 then
		      return
		    end if
		    redim coord.curved(-1)
		    redim coord.centres(-1)
		    redim coord.curved(npts-1)
		    redim coord.centres(npts-1)
		    for i=0 to EL1.ChildCount-1
		      EL2 =  XMLElement(EL1.Child(i))
		      k = val(EL2.GetAttribute("Nr"))
		      coord.curved(k)=1
		      coord.centres(k) = new BasicPoint(val(EL2.GetAttribute("CoordX")), val(EL2.GetAttribute("CoordY")))
		    next
		    PrepareSkull(points(0).bpt)
		    coord.CreateExtreAndCtrlPoints(ori)
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = Avertissement
		
		Avec la version 2.3.7, j'ai supprimé tout ce qui prévoyait la présence de plusieurs arcs. 
		De cette façon l'origine du (seul) arc possible est le points n0 npts-1.
		
		A partir de la version 2.5, on peut de nouveau avoir plusieurs arcs
		
		
	#tag EndNote

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

	#tag Note, Name = Pour les constructions
		
		Une construction commence par un constructor exemple new Polygon(...) 
		
		Le skull doit être créé assez rapidement car la routine de peinture entre en action immédiatement durant la construction du premier point
		
		Donc createskull est appelé très tôt, dès que npts et narcs sont définis (narcs n'intervient pas pour les polygones)
		
		InitConstruction crée tous les points et le tableau de coordonnées, coord. On ne peut donc utiliser celui-ci qu'après InitConstruction
		
		Les renseignements concernant les côtés curvilignes se trouvent dans coord. Donc on ne peut utiliser InitCurvesOrders qu'après que coord ait été créé.
		
		
	#tag EndNote


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
			Name="deleted"
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
			InitialValue="0"
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
			Name="NotPossibleCut"
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
