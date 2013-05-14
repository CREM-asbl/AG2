#tag Class
Protected Class Lacet
Inherits Polyqcq
	#tag Method, Flags = &h0
		Sub Lacet(ol as Objectslist, P as BasicPoint)
		  Lacet(ol)
		  Points.append new point(ol,p)
		  
		  
		End Sub
	#tag EndMethod

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
		  
		  if s isa Lacet then
		    k =Lacet(s).pointoncurvedside(p)
		  elseif s isa circle then
		    k = 0
		  end if
		  
		  if GetIndexPoint(Pt) = 0 or  s.pointonside(p) = -1 or (s isa polygon and not s isa lacet ) or (k= -1) then
		    curved.append 0
		    centre.append nil
		  else
		    curved.append 1
		    if s isa circle then
		      centre.append s.getgravitycenter
		    elseif s isa lacet then
		      centre.append Lacet(s).GetCentre(k)
		    end if
		    narcs = narcs+1
		  end if
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.Value("Compo")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function subdiv(n as integer, i as integer) As basicpoint
		  dim a as double
		  
		  'a = StartAngle+(i/n)*(ArcAngle)
		  'return  Support + new BasicPoint(rayon*cos(a), rayon*sin(a))
		  '
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As shape
		  dim s as Lacet
		  s = new Lacet(Obl,self,p)
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Lacet(ol as objectslist, s as Lacet, q as BasicPoint)
		  dim i as integer
		  dim P As Point
		  dim M as Matrix
		  
		  Shape(ol,s)
		  redim centre(ubound(s.centre))
		  redim ctrl(ubound(s.ctrl))
		  redim extre(ubound(s.extre))
		  redim curved(ubound(s.curved))
		  narcs = s.narcs
		  for i = 0 to ubound(s.centre)
		    centre(i) = s.centre(i)
		  next
		  for i = 0 to ubound(s.ctrl)
		    ctrl(i) =  s.ctrl(i)
		  next
		  for i = 0 to ubound(s.extre)
		    extre(i) = s.extre(i)
		  next
		  for i = 0 to ubound(s.curved)
		    curved(i) = s.curved(i)
		  next
		  
		  CreateSkull
		  M = new TranslationMatrix(q)
		  Move(M)
		  
		  
		  
		End Sub
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
		    if curved(i) = 1 then
		      BiB2 = new BiBPoint(centre(i),Points(i).bpt)
		      n = BiB1.BiBDemiDroiteInterCercle(BiB2, bp(), bq, v)
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
		Function XMLPutInfosArcs(Doc as XMLDocument) As XMLELement
		  dim  Form, EL, EL1 as XMLElement
		  dim i as integer
		  
		  Form = Doc.CreateElement("InfosArcs")
		  EL = Doc.CreateElement("Supports")
		  EL.SetAttribute("N",str(narcs))
		  for i = 0 to npts-1
		    if curved(i) = 1 then
		      EL1 = Doc.CreateElement("Centre")
		      EL1.SetAttribute("Nr", str(i))
		      EL1.SetAttribute("CoordX",str(Centre(i).x))
		      EL1.SetAttribute("CoordY",str(Centre(i).y))
		    end if
		    EL.AppendChild EL1
		  next
		  Form.appendchild EL
		  Return Form
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(P as BasicPoint) As integer
		  dim i, n as integer
		  dim delta, cx as double
		  dim Bib as BiBPoint
		  dim A as angle
		  
		  delta = wnd.Mycanvas1.MagneticDist
		  
		  for i = 0 to npts-1
		    if curved(i) = 0 then
		      if  p.distance(Points(i).bpt,Points((i+1) mod npts).bpt ) <= delta   and p.between(Points(i).bpt,Points((i+1) mod npts).bpt)  then
		        return i
		      end if
		    else
		      BiB = new BiBpoint(Points(i).bpt,p)
		      A = new Angle(Bib, centre(i), ori)
		      cx = p.distance(centre(i))
		      if abs(cx-centre(i).distance(points(i).bpt))<= delta  and abs(A.alpha) <= abs(GetArcAngle(i))  then
		        return i
		      end if
		    end if
		    
		  next
		  
		  return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBoundingRadius() As double
		  dim br As Double
		  dim i as integer
		  dim q as basicpoint
		  
		  q=GetGravitycenter
		  
		  Br = Super.GetBoundingRadius
		  for i = 0 to ubound(ctrl)
		    Br = max(Br,q.Distance(ctrl(i)))
		  next
		  return Br
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Lacet(ol as ObjectsList, Temp as XMLElement)
		  dim List as XMLNodeList
		  dim EL, EL1, EL2 as XMLElement
		  dim i, k as integer
		  
		  Shape(ol,Temp)
		  
		  List = Temp.Xql("InfosArcs")
		  if List.length > 0 then
		    EL = XmlElement(List.Item(0))
		    EL1= XMLElement(EL.firstchild)
		    narcs = val(EL1.GetAttribute("N"))
		    if narcs = 0 then
		      narcs = 1
		      redim curved(2)
		      redim centre(2)
		      curved(2) = 1
		      EL1 = XMLElement(EL.firstchild)
		      centre(2) = new BasicPoint(val(EL1.GetAttribute("CoordX")), val(EL1.GetAttribute("CoordY")))
		    else
		      redim curved(npts-1)
		      redim centre(npts-1)
		      for i=0 to EL1.ChildCount-1
		        EL2 =  XMLElement(EL1.Child(i))
		        k = val(EL2.GetAttribute("Nr"))
		        curved(k)=1
		        centre(k) = new BasicPoint(val(EL2.GetAttribute("CoordX")), val(EL2.GetAttribute("CoordY")))
		      next
		    end if
		  end if
		  PrepareSkull
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Move(M as Matrix)
		  dim i as integer
		  
		  for i = 0 to Ubound(Childs)
		    Childs(i). Move(M)
		  next
		  MoveExtreCtrl(M)
		  EndMove
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos as textoutputStream)
		  'dim Source as Shape
		  'dim M as Matrix
		  'dim i as integer
		  'dim s as string
		  'dim r as double
		  '
		  'Source = ConstructedBy.shape
		  '
		  'if source isa circle and not hidden then
		  '
		  'r = support.distance(points(0).bpt)
		  '
		  's = "[ "
		  'for i = 0 to npts-2
		  's = s+ " " + Points(i).etiq+ " "
		  'next
		  's = s + " [ [ " + points(npts-1).etiq + " [ "  + str(support.x) + " " + str(support.y) + " ] " + points(0). etiq + " ] " + str(ori*r) + " ] arcsecteur "
		  '
		  's = s+"]"
		  '
		  'if fill > 49 then
		  'tos.writeline  s + " lacetrempli "
		  'else
		  'tos.writeline s + "lacet"
		  'end if
		  '
		  's = "[ "
		  'for i = 0 to npts-1
		  's = s+ " " + Points(i).etiq+ " "
		  'next
		  's = s + " ] "
		  'tos.writeline s + " suitepoints "
		  'end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function computeangle(n as integer, q as Basicpoint) As double
		  dim Ag as angle   //position d'un point sur l'arc d'origine en points(n)
		  dim Bib as BiBPoint
		  
		  Bib = new BiBPoint(points(n).bpt, q)
		  Ag = new Angle(Bib, centre(n), ori)
		  return Ag.alpha
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateExtreAndCtrlPoints()
		  dim Mat as RotationMatrix
		  dim BiB as BiBPoint
		  dim m, n ,i as integer
		  dim temp(1) as BasicPoint
		  dim A as Angle
		  dim alpha as double
		  
		  n = 0
		  m=0
		  for i = 0 to npts-1
		    if curved(i) = 1 then
		      Bib = new BiBPoint(Points(i).bpt, points((i+1) mod npts).bpt)
		      A = new Angle(Bib, centre(i), ori)
		      alpha = A.alpha/3
		      
		      Mat = new RotationMatrix(centre(i),alpha)
		      
		      extre(n) = Mat*Points(i).bpt
		      extre(n+1) = Mat*extre(n)
		      BiB = new BiBPoint(Points(i).bpt,extre(n))
		      
		      Bib.computeCtrlPoints(centre(i), ori,  temp)
		      ctrl(m) = temp(0)
		      ctrl(m+1) = temp(1)
		      for i = 2 to 5
		        ctrl(m+i) = Mat*ctrl(m+i-2)
		      next
		      n = n+2
		      m=m+6
		    end if
		  next
		End Sub
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
		  
		  if k <> -1 and curved(k) = 0 then                     //si ce sommet n'est pas l'origine d'un arc
		    return -1
		  else
		    return k                                  //sinon, on retourne son numéro qui est aussi le numéro du côté issu du point source de Pt
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCentre(k as integer) As BasicPoint
		  return Centre(k)
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
		Sub InsertPoint(k as integer, Pt as Point)
		  dim Q as Point
		  dim s as shape
		  
		  Points.Insert(k,Pt)
		  Childs.Insert(k,Pt)
		  Pt.setParent(self)
		  
		  npts = npts+1
		  
		  Q= Point(Pt.Constructedby.shape)
		  s = constructedby.shape
		  
		  if s isa Lacet then
		    k = s.getindexpoint(Q)
		    if k = -1 then
		      k =Lacet(s).pointoncurvedside(Q.bpt)
		    end if
		  end if
		  
		  
		  if  s.pointonside(Q.bpt) = -1 or (not (s isa lacet)) or (s isa Lacet and ( (k = -1) or( Lacet(s).curved(k) = 0) ) ) then
		    curved.append 0
		    centre.append nil
		  else
		    curved.append 1
		    if s isa circle then
		      centre.append s.getgravitycenter
		    elseif s isa lacet then
		      centre.append Lacet(s).GetCentre(k)
		    end if
		    narcs = narcs+1
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndConstruction()
		  PrepareSkull
		  super.endconstruction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpDateSkull()
		  dim i, j, k as integer
		  dim p As BasicPoint
		  dim m, n as integer
		  
		  p = points(0).bpt
		  
		  nsk.update(wnd.Mycanvas1.transform(p))
		  
		  m = 0   //numeros des points de ctr
		  n = 0      //numeros des pts extre
		  k = 0
		  
		  for i = 0 to npts-1
		    nsk.updatesommet(k,wnd.Mycanvas1.dtransform(points(i).bpt-p))
		    if curved(i) = 1 then
		      for j = 0 to 1
		        nsk.updateextre(k+j,  wnd.mycanvas1.dtransform(extre(n+j)-p))
		      next
		      n = n+2
		      for j = 0 to 5
		        nsk.updatectrl(k+j\2 , j mod 2, wnd.mycanvas1.dtransform(ctrl(m+j)-p))
		      next
		      m = m+6
		      k=k+3
		    else
		      k = k+1
		    end if
		  next
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
		Function Aire() As double
		  dim A, r,  alpha, beta as double
		  dim i as integer
		  dim c, p, q as BasicPoint
		  
		  A = 0
		  
		  for i = 0 to npts-1
		    if curved(i) = 0 then
		      A = A +points(i).bpt.Vect(points((i+1) mod npts).bpt)
		    else
		      r = getradius(i)
		      alpha = getarcangle(i)
		      c = centre(i)
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
		Sub Lacet(ol as objectslist)
		  Shape(ol)
		  fam = 7
		  forme = 0
		  npts = 1
		  ncpts = 1
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createskull()
		  dim i as integer
		  
		  nsk = new LSkull(wnd.mycanvas1.transform(Points(0).bpt))
		  
		  for i = 0 to npts-1
		    if curved(i) = 0 then
		      LSkull(nsk).addcurve(0)
		    else
		      LSkull(nsk).addcurve(2)
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as Graphics)
		  dim i as integer
		  
		  if nsk= nil  or  (not wnd.drapshowall and hidden) then
		    return
		  end if
		  
		  updateskull
		  nsk.fixecouleurs(self)
		  nsk.fixeepaisseurs(self)
		  nsk.paint(self, g)
		  
		  if not hidden then
		    for i = 0 to labs.count-1
		      Labs.element(i).paint(g)
		    next
		  end if
		  
		  if not hidden and Ti <> nil then
		    for i = 0 to npts-1
		      if curved(i) = 0 then
		        PaintTipOnSeg g, Points(i).bpt, Points((i+1) mod npts).bpt, colcotes(i)
		      else
		        PaintTipOnArc(g, Points(i).bpt, Points((i+1) mod npts).bpt, centre(i), colcotes(i))
		      end if
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveExtreCtrl(M as Matrix)
		  dim i as integer
		  
		  for i = 0 to ubound(extre)
		    extre(i) = M*extre(i)
		  next
		  for i = 0 to ubound(ctrl)
		    ctrl(i) = M*ctrl(i)
		  next
		  for i = 0 to ubound(centre)
		    if curved(i)=1 then
		      centre(i)=M*centre(i)
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextArc(j as integer) As integer
		  dim k as integer
		  
		  k = j
		  while k <= npts-1 and curved(k) =0
		    k=k+1
		  wend
		  return k
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paintside(g as graphics, cot as integer, ep as double, coul as couleur)
		  dim i, n as integer
		  
		  n = 0
		  
		  for i = 0 to cot-1
		    if curved(i)=0 then
		      n=n+1
		    else
		      n = n+3
		    end if
		  next
		  
		  nsk.paintside(g, n, ep, coul)
		  
		  if curved(cot) = 1 then
		    for i = 1 to 2
		      nsk.paintside(g, n+i, ep, coul)
		    next
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetArcAngle(k as integer) As double
		  dim Bib as BiBPoint
		  dim Ag as Angle
		  
		  if curved(k)=0 then
		    return 0
		  end if
		  Bib = new BiBPoint(points(k).bpt, points((k+1) mod npts).bpt)
		  Ag = new Angle(Bib, centre(k), ori)
		  return Ag.alpha
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SubSectPInShape(i as integer, p as BasicPoint) As Boolean
		  dim BiB as BiBPoint
		  dim cx as double
		  dim A as Angle
		  
		  if curved(i) = 0 then
		    return false
		  end if
		  BiB = new BiBpoint(Points(i).bpt,p)
		  A = new Angle(Bib, centre(i), ori)
		  cx = p.distance(centre(i))
		  if cx <= centre(i).distance(points(i).bpt)  and A.alpha <= GetArcAngle(i)  then
		    return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRadius(k as integer) As double
		  if curved(k) = 1 then
		    return centre(k).distance(points(k).bpt)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetStartAngle(k as integer) As double
		  dim q as BasicPoint
		  
		  q = Points(k).bpt - centre(k)
		  return q.anglepolaire
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrepareSkull()
		  redim extre(2*narcs-1)
		  redim ctrl(6*narcs-1)
		  Createskull
		  CreateExtreAndCtrlPoints
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGravitycenter() As BasicPoint
		  dim g as BasicPoint
		  dim i as integer
		  
		  g = new BasicPoint(0,0)
		  
		  for i = 0 to npts-1
		    g = g + points(i).bpt
		  next
		  
		  for i = 0 to ubound(extre)
		    g = g+ extre(i)
		  next
		  
		  g = g/(npts+ubound(extre)+1)
		  return g
		  
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
		    if curved(k) = 0 then
		      p.location(n) = p.bpt.location(a,b)
		      p.putonsegment(a,b,p.location(n),n)
		    else
		      angle = computeangle(k,p.bpt)
		      p.putonarc(a,b,centre(k),angle, GetArcAngle(k),GetStartAngle(k), n)
		    end if
		  end if
		  
		  setpoint p
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SideLength(n as integer) As double
		  
		  
		  if curved(n) = 0  then
		    return Points(n).bpt.distance(Points((n+1) mod npts).bpt)
		  else
		    return GetArcAngle(n)*GetRadius(n)
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

	#tag Note, Name = Avertissement
		
		Avec la version 2.3.7, j'ai supprimé tout ce qui prévoyait la présence de plusieurs arcs. 
		De cette façon l'origine du (seul) arc possible est le points n0 npts-1.
	#tag EndNote


	#tag Property, Flags = &h0
		narcs As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		centre(-1) As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		nsk As LSkull
	#tag EndProperty

	#tag Property, Flags = &h0
		ctrl(-1) As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		extre(-1) As BasicPoint
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="tobereconstructed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="diam"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="deleted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="plan"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="final"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="init"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="interm"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="signaire"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapori"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nonpointed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsw"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="labupdated"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IndexConstructedPoint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsInConstruction"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TracePt"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="auto"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="unmodifiable"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncpts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Invalid"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Attracting"
			Group="Behavior"
			InitialValue="True"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Liberte"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="id"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="selected"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Highlighted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="npts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Borderwidth"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="std"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ori"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fam"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="forme"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Modified"
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IDGroupe"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tsp"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
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
			Name="narcs"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
