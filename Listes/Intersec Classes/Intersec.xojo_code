#tag Class
Protected Class Intersec
Inherits SelectOperation
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit)) or  (TargetAndroid and (Target64Bit))
	#tag Method, Flags = &h0
		Sub Addpoint(p as point)
		  dim i1, j1 as integer  //Utilisé dans Point.adjustinter et shape.valider
		  dim d as Double
		  
		  if pts.indexof(p) <> -1 then
		    return
		  end if
		  
		  // différent de la version du 19/08/12
		  
		  d = nearest(p,i1,j1)
		  if bezet(i1,j1) or (d > can.magneticdist and currentcontent.currentoperation isa shapeconstruction)  then
		    p.invalider
		    return
		  end if
		  
		  if i1 <> -1 and j1 <> -1 and bptinters(i1,j1) <> nil   then
		    p.puton sh1
		    p.puton sh2
		    p.forme = 2
		    pts.append p
		    p.moveto bptinters(i1,j1)
		    bezet(i1,j1) = true
		    ids(i1,j1) = p.id
		    setlocation(p,i1,j1)
		    if val(i1,j1) and (p.conditionedby=nil or not point(p.conditionedby).invalid) then
		      p.valider
		    else
		      p.invalider
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Combien() As integer
		  dim i, j , n as integer
		  
		  n = 0
		  
		  for i = 0 to nlig -1
		    for j = 0 to ncol -1
		      if val(i,j) then
		        n = n+1
		      end if
		    next j
		  next i
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeinter()
		  dim i, j, k  as integer
		  
		  'if ((sh1 isa DSect) and (not sh1 isa secteur) ) or ((sh2 isa Dsect)  and not (sh2 isa secteur)) then
		  if sh1.hybrid or sh2.hybrid then
		    return  'Cas à ajouter
		  end if
		  
		  init
		  drappara = false
		  somevalidpoint = false
		  if not sh1 isa circle then
		    if not sh2 isa circle then
		      computeinterlines
		    else
		      computeinterlines_circle
		      if sh2 isa arc then
		        for i = 0 to nlig
		          val(i,j) = val(i,j) and arc(sh2).inside(bptinters(i,j) )
		        next
		      end if
		    end if
		  elseif sh1 isa circle then '( sh1 est un cercle, sh2 aussi))
		    k = computeintercercles
		    if k = 3 then 'cercles confondus
		      somevalidpoint = false
		    end if
		  end if
		  
		  for i = 0 to nlig
		    for j = 0 to ncol
		      somevalidpoint = somevalidpoint or val(i,j)
		    next
		  next
		  
		  if not somevalidpoint then
		    return
		  else
		    positionfalseinterpoints
		  end if  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function computeintercercles() As integer
		  dim k as integer
		  dim bq() as basicpoint
		  dim g1, g2 as circle
		  
		  g1 = circle(sh1)
		  g2 = circle(sh2)
		  k = g1.inter(g2,bq())
		  
		  if k = 3 or k = 0 then   'introduit pour sangaku02
		    val(0,0) = false
		    val(0,1) = false
		    return k
		  end if
		  
		  bptinters(0,0) = bq(0)
		  bptinters(0,1) = bq(1)
		  
		  return 2
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeinterlines()
		  dim i, j,k as integer
		  dim bp as basicpoint
		  dim d1, d2 as droite
		  dim r1,r2 as double
		  
		  
		  for i = 0 to nlig
		    d1 = sh1.getside(i)
		    if d1 <> nil then
		      for j = 0 to ncol
		        bp = nil
		        d2 = sh2.getside(j)
		        if d2 <> nil then
		          if not(sh1 isa droite and droite(sh1).parallelto(sh2,j)) and not (sh2 isa droite and droite(sh2).parallelto(sh1,i)) then
		            k = d1.inter(d2,bp,r1,r2)
		            if bp <> nil then
		              bptinters(i,j) = bp
		            end if
		            if k = 0 or r1 > 998 then
		              val(i,j) = false
		            end if
		            if r1 > 998 then
		              drappara = true
		            end if
		          else
		            val(i,j) = false
		          end if
		        else
		          val(i,j) = false
		        end if
		      next
		    else
		      val(i,j) =false
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computeinterlines_circle()
		  dim i, j,k as integer
		  dim b, w, p(1) as basicpoint
		  dim d1 as droite
		  dim g2 as circle
		  
		  g2 = circle(sh2)
		  
		  for i = 0 to nlig
		    d1 = sh1.getside(i)
		    b = new BasicPoint(0,0)
		    w = new BasicPoint(0,0)
		    k = d1.inter(g2,p(),b,w)
		    
		    select case k
		    case 0
		      bptinters(i,0) = nil
		      bptinters(i,1) = nil
		      val(i,0) = false
		      val(i,1) = false
		    case 1
		      bptinters(i,0) = b
		      bptinters(i,1) = b
		    case 2
		      if p(0).distanceSquaredTo(d1.firstp) > p(1).distanceSquaredTo(d1.firstp) then
		        dim temp as basicpoint = p(0)
		        p(0) = p(1)
		        p(1) = temp
		      end if
		      bptinters(i,0) = p(0)
		      bptinters(i,1) = p(1)
		      select case d1.nextre
		      case 1
		        for j = 0 to 1
		          if not p(j).audela(d1.firstp, d1.secondp) then
		            val(i,j) = false
		          end if
		        next
		      case 2
		        for j = 0 to 1
		          if not p(j).between(d1.firstp, d1.secondp) then
		            val(i,j) = false
		          end if
		        next
		      end select
		    end select
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Super.constructor
		  OpId = 45
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(MExe as MacroExe, EL1 as XMLElement)
		  
		  dim ob as objectslist
		  dim EL2 as XMLElement
		  dim n, rid, num0, num1 as integer
		  dim s1, s2 as shape
		  dim p as point
		  
		  
		  ob = currentcontent.theobjects
		  EL2 = XMLElement(EL1.FirstChild)
		  n = CDBl(EL2.GetAttribute("Id"))
		  rid = MExe.GetRealId(n)
		  s1 = ob.Getshape(rid)
		  EL2 = XMLElement(EL1.Child(1))
		  n = CDbl(EL2.GetAttribute("Id"))
		  rid = MExe.GetRealId(n)
		  s2 = ob.Getshape(rid)
		  
		  constructor(s1,s2)
		  computeinter
		  
		  num0 = CDbl(EL1.GetAttribute("NumSide0"))
		  num1 = CDbl(EL1.GetAttribute("NumSide1"))
		  
		  currentshape = new point(ob, bptinters(num0,num1))
		  currentshape.forme = 2
		  p = point(currentshape)
		  s1.setpoint(p)
		  s2.setpoint(p)
		  redim p.numside(-1)
		  redim p.numside(1)
		  redim p.location(-1)
		  redim p.location(1)
		  p.pointsur.addshape s1
		  p.pointsur.addshape s2
		  setlocation(p,num0,num1)
		  'p.endconstruction
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(s1 as shape, s2 as shape)
		  constructor()
		  sh1 = s1
		  sh2 = s2
		  
		  
		  if s1 isa circle and s2 isa circle then
		    if s1.id > s2.id then
		      sh1 = s2
		      sh2 = s1
		    end if
		  elseif sh1 isa circle and not sh2 isa circle then
		    sh1 = s2
		    sh2 = s1  //le cercle est sh2
		  end if
		  
		  if sh1 isa droite then
		    nlig = 0
		  elseif sh1 isa bande or sh1 isa secteur then
		    nlig = 1
		  elseif sh1 isa circle then
		    nlig = 0
		  else
		    nlig = sh1.npts-1
		  end if
		  
		  if sh2 isa droite then
		    ncol = 0
		  elseif sh2 isa bande or sh2 isa secteur then
		    ncol = 1
		  elseif sh2 isa circle then
		    ncol = 1
		  else
		    ncol = sh2.npts-1
		  end if
		  
		  redim bptinters(nlig, ncol)
		  redim ids(nlig,ncol)
		  redim val(nlig,ncol)
		  redim bezet(nlig,ncol)
		  
		  ' bptsinter est la liste de tous les points d'inter possibles des droites supports des cotés de sh1 et de sh2
		  ' val indique si ces points appartiennent aux cotes eux-memes et que les points peuvent donc etre validés
		  'points est un tableau de (pointeurs vers les) points d'intersection effectivement présents
		  'pts est la liste de ces points dans leur ordre de construction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  if currentcontent.macrocreation then
		    CurrentContent.AddOperation(self)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  return  Dico.Value("Intersection")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As String
		  return "Intersec"
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub init()
		  dim i, j as integer
		  
		  
		  
		  redim bptinters(nlig, ncol)
		  redim val(nlig,ncol)
		  redim bezet(nlig,ncol)
		  
		  for i = 0 to nlig
		    for j = 0 to ncol
		      bptinters(i,j) = nil
		      val(i,j) = true
		    next
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function locatepoint(p as BasicPoint) As basicPoint
		  dim i, j, i1, j1  as integer
		  dim r1, s as double
		  
		  r1  = 10000
		  for i = 0 to nlig
		    for j = 0 to ncol
		      if val(i,j) and (not bezet(i,j))  and (bptinters(i,j)<> nil) then
		        s = p.distance(bptinters(i,j))
		        if abs(s) < r1 then
		          r1 = s
		          i1 = i
		          j1 = j
		        end if
		      end if
		    next
		  next
		  
		  if  bezet(i1,j1) or (r1 > can.magneticdist and currentcontent.currentoperation isa shapeconstruction)  then
		    return nil
		  else
		    return bptinters(i1,j1)
		  end if
		  
		  //détermine la position valide et libre la plus proche
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function nbnear(q as Point) As integer
		  dim i, m  as integer
		  
		  
		  
		  for i = 0 to ubound(pts)
		    if (q <> pts(i)) and (q.bpt.distance(pts(i).bpt) < can.magneticdist) then
		      m = m+1
		    end if
		  next
		  
		  return m //nombre d'autres points d'inter tout proches
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function nearest(pt as point, byref i1 as integer, byref j1 as integer) As double
		  dim r1, s as double
		  dim i, j, h, k as integer
		  
		  r1 = 10000
		  
		  if pt.forme = 2 then
		    h = pt.numside(0)
		    k = pt.numside(1)
		    if  val(h,k) and (not bezet(h,k) ) and pt.bpt.distance(bptinters(h,k))  < epsilon then
		      i1 = h
		      j1 = k
		      return 0
		    end if
		  end if
		  
		  i1 = h
		  j1 = k
		  for i = 0 to nlig
		    for j = 0 to ncol
		      if val(i,j)  and (not bezet(i,j)) and bptinters(i,j) <> nil then
		        s = pt.bpt.distance(bptinters(i,j))
		        if abs(s) < r1 then
		          r1 = s
		          i1 = i
		          j1 = j
		        end if
		      end if
		    next
		  next
		  return r1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub positionfalseinterpoints()
		  //Les faux points d'intersection sont les sommets communs aux deux formes sh1 ou sh2
		  // ou les sommets de l'un qui sont pointsur sur l'autre. (Exemple: point de tangence d'un cercle inscrit à un polygone.) Ces points n'ont pas le statut de pointinter mais occupent la place
		  //d'un point inter. Celle-ci doit être mentionnée comme occupée. On les calcule en premier lieu.
		  //Idem pour les points de subdivision
		  
		  dim i,h,k, i1, j1 as integer
		  dim p as point
		  dim d as double
		  
		  for i = 0 to ubound(sh1.points)
		    p = sh1.points(i)
		    if   sh2.getindex(p) <> -1 and p.forme < 2 then
		      d = nearest(p, i1,j1) 
		      if d < epsilon then
		        bezet(i1, j1) = true 
		        ids(i1, j1) = p.id     ' on ne peut placer aucun vrai pt d'inter ici
		      end if
		    end if
		  next
		  for i = 0 to ubound(sh2.points)
		    p = sh2.points(i)
		    if   sh1.getindex(p) <> -1 and p.forme < 2 then
		      d = nearest(p, i1,j1) 
		      if d < epsilon then
		        bezet(i1, j1) = true 
		        ids(i1, j1) = p.id     ' on ne peut placer aucun vrai pt d'inter ici
		      end if
		    end if
		  next
		  
		  
		  for i = 0 to ubound(sh1.constructedshapes)
		    if sh1.constructedshapes(i) isa point  then
		      p = point(sh1.constructedshapes(i))
		      h = sh1.pointonside(p.bpt)
		      if h <> -1 then
		        for k = 0 to ncol
		          if bptinters(h,k) <> nil and bezet(h,k) = false and  ( p.bpt.distance (bptinters(h,k)) < epsilon) then
		            bezet(h,k) = true
		            ids(h,k) = p.id 
		          end if
		        next
		      end if
		    end if
		  next
		  
		  for i = 0 to ubound(sh2.constructedshapes)
		    if sh2.constructedshapes(i) isa point  then
		      p = point(sh2.constructedshapes(i))
		      h = sh2.pointonside(p.bpt)
		      if h <> -1 then
		        for k = 0 to nlig
		          if bptinters(k,h) <> nil and bezet(k,h) = false and  ( p.bpt.distance (bptinters(k,h)) < epsilon) then 
		            bezet(k,h) = true
		            ids(k,h) = p.id 
		          end if
		        next
		      end if
		    end if
		  next
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Removepoint(p as point)
		  
		  pts.remove pts.indexof(p)
		  
		  
		  if  ubound(pts) = -1 then
		    CurrentContent.TheIntersecs.removeobject self
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub replacerphase1(pt as point)
		  dim   h, k as integer
		  
		  h = pt.numside(0)     'On mémorise l'ancienne position
		  k = pt.numside(1)
		  
		  
		  if val(h,k) and ids(h,k) = pt.id   then 'valide ou non, le point est replacé là où il était et revalidé
		    validerpoint(pt,h,k)
		  else
		    replacerphase2(pt)
		  end if
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub replacerphase2(pt as point)
		  dim   i1, j1, h, k as integer
		  dim d as double
		  dim s as shape
		  
		  
		  h = pt.numside(0)     'On mémorise l'ancienne position
		  k = pt.numside(1)
		  
		  d = nearest(pt,i1,j1)
		  
		  if pt.invalid then          'cas des points invalides
		    if val(i1,j1) and not bezet(i1,j1) then 'and d < can.magneticdist then 'un point invalide peut etretemps avoir été déplacé loin d'un emplacement valide
		      'Que se passe-t-il quand un point valide est assez proche d'une place vacante qui n'est pas la sienne (sinon il aurait été replacé à la phase 1)
		      if  (not (sh1 isa circle) and not(sh2 isa circle)) or (sh1 isa circle and sh2 isa circle)  then
		        // on ne risque de changer un pt d'inter de côté que s'il n'existe aucun autre pt d'inter dans son voisinage et que pas de probl de parallelisme --ou perp
		        // peut être en défaut si A// B et B//C et que A inter C est calculé // prévoir la transitivité
		        if  ((i1 <> h  or  j1 <> k) and not bezet(h,k)  and nbnear(pt) > 0) or (sh1.isaparaperp(s) and s = sh2)  or drappara then
		          i1 = h
		          j1 = k
		        end if
		      end if
		      validerpoint(pt,i1,j1)
		    end if
		    return
		  else                               'cas des points valides
		    if d > epsilon  then  'un pt valide trop loin de toute place vacante est invalidé
		      pt.invalider
		      bezet(h,k) = false
		      ids(h,k) = 0
		      return
		    else               'sinon on envisage de le changer de place
		      if val(i1,j1) then
		        validerpoint(pt,i1,j1)
		      else
		        pt.invalider
		        bezet(h,k) = false
		        ids(h,k) = 0
		      end if
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setlocation(p as point, i as integer, j as integer)
		  p.numside(0) = i
		  p.numside(1) = j
		  if  not sh1 isa circle then
		    p.location(0) = bptinters(i,j).location(sh1,i)
		  else
		    p.location(0) = bptinters(i,j).location(circle(sh1))
		  end if
		  if  not sh2 isa circle then
		    p.location(1) = bptinters(i,j).location(sh2,j)
		  else
		    p.location(1) = bptinters(i,j).location(circle(sh2))
		  end if
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMethod(getString,"setlocation")
		    d.setVariable("p",p)
		    d.setVariable("i",i)
		    d.setVariable("j",j)
		    d.setVariable("sh1",sh1)
		    d.setVariable("sh2",sh2)
		    err.message = err.message+d.getString
		    
		    Raise err
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument, EL as XMLElement) As XMLElement
		  
		  Return  Point(currentshape).XMLPutIdInContainer(Doc, EL)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update(p as point)
		  
		  //Utilisé (notamment) par figure.restoreinit
		  //On ne passe ici que pour replacer un point d'inter qui a été modifié. Donc pas quand on le crée
		  
		  computeinter
		  replacerphase1(p)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub validerpoint(pt as point, i as integer, j As integer)
		  if bptinters(i,j) = nil then
		    return
		  end if
		  if ids(i,j) <> 0 and ids(i,j) <> pt.id then
		    return
		  end if
		  bezet(i,j) = true
		  pt.moveto bptinters(i,j)
		  ids(i,j) = pt.id
		  setlocation(pt,i,j)
		  pt.modified = true
		  pt.updateshape
		  if val(i,j) and (bptinters(i,j) <> nil) and ((pt.conditionedby = nil) or (not pt.conditionedby.invalid)) and  not sh1.invalid and not sh2.invalid then
		    pt.valider
		  end if
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		bezet(-1,-1) As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		bptinters(-1,-1) As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		drap As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drappara As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ids(-1,-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ncol As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		nlig As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		pts(-1) As point
	#tag EndProperty

	#tag Property, Flags = &h0
		sh1 As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		sh2 As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		somevalidpoint As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		val(-1,-1) As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="canceling"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsep"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drap"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="drappara"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
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
			Name="info"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncol"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="nlig"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="nobj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ntsf"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="somevalidpoint"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
