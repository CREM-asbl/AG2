#tag Class
Protected Class Transformation
	#tag Method, Flags = &h0
		Sub Appliquer(s1 as shape, s2 as shape)
		  dim i as integer
		  dim oldpt as BasicPoint
		  dim t as boolean
		  
		  t = true
		  
		  
		  if not  S2 isa Point then
		    for i= 0 to s1.npts-1
		      s2.childs(i).bpt = M*(s1.childs(i).bpt)   //Avant 19/9/12: point(s2.childs(i)).moveto M*Point(s1.childs(i)).bpt
		      point(s2.childs(i)).modified = true
		    next
		    if type = 6  then
		      s2.ori = - s1.ori
		    end if
		    if s2 isa standardpolygon then
		      standardpolygon(s2).updateangle
		    end if
		    if s1 isa circle then
		      AppliquerExtreCtrl(Circle(s1),Circle(s2))
		      circle(s2).computeradius
		    end if
		    if s2 isa arc  or s2 isa secteur then
		      s2.computearcangle
		      s2.drapori = true
		    end if
		    if s2.Hybrid then
		      AppliquerExtreCtrl (s1,s2)'coord.MoveExtreCtrl(M)
		    end if
		  else
		    Point(s2).moveto M*Point(s1).bpt
		    s2.Modified = true
		  end if
		  s2.endmove
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AppliquerExtreCtrl(s1 as shape, s2 as shape)
		  dim i as integer
		  
		  if s1.Hybrid or s1 isa circle then
		    for i = 0 to ubound(s2.coord.extre)
		      s2.coord.extre(i) = M*s1.coord.extre(i)
		    next
		    for i = 0 to ubound(s2.coord.ctrl)
		      s2.coord.ctrl(i) = M*s1.coord.ctrl(i)
		    next
		    
		    for i = 0 to ubound(s1.coord.centres)
		      if s1.coord.centres(i) <> nil then
		        s2.coord.centres(i) = M*s1.coord.centres(i)
		      end if
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CleanConstructedFigs()
		  dim i, j as integer
		  dim ff, sfig as figure
		  dim t as Boolean
		  dim tsf as transformation
		  
		  for i =  constructedfigs.count-1 downto 0
		    ff = constructedfigs.item(i)
		    t = true
		    for j = 0 to constructedshapes.count-1
		      t = t and constructedshapes.item(j).fig <> ff
		    next
		    
		    if t then
		      constructedfigs.removefigure  ff
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ComputeFixPt() As BasicPoint
		  'dim MId, M1 as Matrix
		  'dim Pt as BasicPoint
		  '
		  'MId = new Matrix(1)
		  'M1 = M - MId
		  'M1 = M1.inv
		  '
		  'if M1 <> nil then
		  'pt = new BasicPoint(0,0)
		  'return  M1*pt
		  'else
		  'return nil
		  'end if
		  
		  return M.FixPt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computematrix()
		  dim k as double
		  dim u,v,w as BasicPoint
		  dim nbp as nBPoint
		  dim n as integer
		  dim Ls as Lacet
		  
		  select case type
		  case 1
		    v = supp.points((index+1)mod supp.npts).bpt- supp.points(index) .bpt
		    M = new translationmatrix (v*ori)
		  case 2
		    if supp isa arc then
		      M = supp.coord.RotationMatrix
		    elseif supp.hybrid then
		      n = self.index
		      ls = Lacet(supp)
		      M = new RotationMatrix(supp.coord.centres(n), Ls.computeangle(n, Ls.coord.tab(n+1)))
		    end if
		  case 3
		    M = new rotationmatrix(point(supp).bpt, PI)
		  case 4
		    M = new rotationmatrix(point(supp).bpt,PIDEMI)
		  case 5
		    M = new rotationmatrix(point(supp).bpt, -PIDEMI)
		  case 6
		    if  supp isa droite then
		      M = supp.coord.SymmetryMatrix        '(droite(supp).firstp, droite(supp).secondp)
		      'elseif supp isa bande then
		      'if index = 0 then
		      'v = supp.points(1).bpt
		      'else
		      'v = Bande(supp).Point3
		      'end if
		      'M = new SymmetryMatrix(supp.points(index).bpt, v)
		    elseif (supp isa Lacet) then
		      nbp = supp.GetBiBSide(index)
		      if nbp <> nil then
		        M = nbp.SymmetryMatrix  'new SymmetryMatrix(supp.points(index).bpt, supp.points((index+1) mod supp.npts).bpt)
		      end if
		      'elseif supp isa secteur then
		      'M = new SymmetryMatrix(supp.points(0).bpt, supp.points(index).bpt)
		    end if
		  case 7, 72 // Homothéties
		    M = supp.coord.HomothetyMatrix
		  case 71
		    u = supp.points(0).bpt
		    v = supp.points(1).bpt
		    w = supp.points(2).bpt
		    k = w.location(u,v)
		    M = new HomothetyMatrix(u, k)
		  case 8 //Similitudes
		    M = supp.coord.SimilarityMatrix
		  case 81
		    M = new SimilarityMatrix(supp.points(0).bpt,supp.points(1).bpt,supp.points(0).bpt, supp.points(2).bpt)
		  case 82
		    M = new SimilarityMatrix(supp.points(0).bpt,supp.points(1).bpt,supp.points(1).bpt, supp.points(2).bpt)
		  case 9, 11  //Etirements - Cisaillements
		    M = new AffinityMatrix(supp.points(0).bpt,supp.points(1).bpt,supp.points(3).bpt, supp.points(0).bpt,supp.points(1).bpt,supp.points(2).bpt)
		  case 10 //Deplacement
		    M = new IsometryMatrix(supp.points(0).bpt,supp.points(1).bpt,supp.points(3).bpt, supp.points(2).bpt)
		  end select
		  
		  if M = nil then
		    M = oldM
		  end if
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMethod("Transformation","computematrix")
		    d.setVariable("k",k)
		    d.setVariable("u",u)
		    d.setVariable("v",v)
		    d.setVariable("w",w)
		    d.setVariable("type",Type )
		    d.setVariable("M",M)
		    err.message = err.message+d.getString
		    
		    Raise err
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  constructedshapes = new Objectslist
		  constructedfigs = new FigsList
		  oldM = new Matrix(1)
		  M = new Matrix(1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(s as shape, n as integer, i as integer, ori as integer)
		  dim j as integer
		  
		  Constructor()
		  supp = s                       'support de la tsf
		  type = n                        'type de transformation (translation, rotation etc) ATTENTION: type = 0 pour les paraperp
		  index = i                        'numéro éventuel du côté
		  self.ori = ori                  'orientation du support
		  if type <> 0 then
		    computematrix
		    oldM = M
		  end if
		  
		  if type <> 0 and  (type < 3 or type > 6 ) then
		    T = new Tip
		  end if
		  setfpsp(s)                             'Deux premiers points du support
		  CurrentContent.TheTransfos.AddObject(self)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(s as shape, EL as XMLElement)
		  dim n, i as integer
		  
		  
		  n = val(EL.GetAttribute("TsfType"))
		  ori = val(EL.GetAttribute("Ori"))
		  i = val(EL.GetAttribute("Index"))
		  
		  Constructor(s,n,i,ori)
		  
		  if val(EL.GetAttribute("Hid")) = 1 then
		    Hidden2 = true
		  end if
		  
		  'if type = 71 then
		  'supp.points(2).moveto supp.points(2).bpt.projection(supp.points(0).bpt, supp.points(1).bpt)
		  'end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawTip(g as graphics, coul as couleur)
		  dim a,b as BasicPoint
		  dim col as color
		  
		  col = coul.col
		  
		  if type < 3 or type > 6 then
		    select case type
		    case 1
		      if ori = 1 then
		        a = can.transform(supp.points(index).bpt)
		        b = can.transform(supp.points((index+1)mod supp.npts).bpt)
		      else
		        b = can.transform(supp.points(index).bpt)
		        a = can.transform(supp.points((index+1)mod supp.npts).bpt)
		      end if
		    case 2
		      b = can.transform(supp.points(2).bpt)
		      a = supp.points(2).bpt - supp.points(0).bpt
		      a = a.vecnorperp
		      a = can.dtransform(a)
		      a =  b - a*supp.ori
		    case  71, 81
		      a = can.transform(supp.points(1).bpt)
		      b = can.transform(supp.points(2).bpt)
		    case 7, 8, 72
		      a = can.transform(supp.points(0).bpt)
		      b = can.transform(supp.points(3).bpt)
		      T.updatetip(a,b,col)
		      g.DrawObject T, b.x, b.y
		      a = can.transform(supp.points(1).bpt)
		      b = can.transform(supp.points(2).bpt)
		    case 82
		      a = can.transform(supp.points(0).bpt)
		      b = can.transform(supp.points(1).bpt)
		      T.updatetip(a,b,col)
		      g.DrawObject T, b.x, b.y
		      a = can.transform(supp.points(1).bpt)
		      b = can.transform(supp.points(2).bpt)
		    case 9, 11
		      a = can.transform(supp.points(3).bpt)
		      b = can.transform(supp.points(2).bpt)
		    case 10
		      a = can.transform(supp.points(0).bpt)
		      b = can.transform(supp.points(3).bpt)
		    end select
		    T.updatetip(a,b,col)
		    g.DrawObject T, b.x, b.y
		  end if
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("a", a)
		    d.setVariable("b", b)
		    d.setVariable("col", col)
		    err.message = err.message+d.getString
		    
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Equal(tsf as Transformation) As Boolean
		  if type = 0 then
		    return (tsf.type = 0) and (supp=tsf.supp) and (index = tsf.index) 'and (constructedshapes.item(0) = tsf.constructedshapes.item(0))
		  else
		    return (Type = tsf.type) and (supp = tsf.supp) and (ori = tsf.ori) and (index = tsf.index)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFigSources(f as figure) As figslist
		  dim ffl as figslist
		  dim i as integer
		  
		  if constructedfigs.getposition(f) <> -1 then
		    ffl = new figslist
		    for i = 0 to ubound(f.constructioninfos)
		      if f.constructioninfos(i).tsf = self then
		        ffl.addobject f.constructioninfos(i).sourcefig
		      end if
		    next
		    return ffl
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetNum() As integer
		  return supp.GetIndexTsf(self)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As String
		  
		  return GetType
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  select case Type
		  case 1
		    return Dico.Value("Translation")
		  case 2
		    return Dico.Value("Rotation")
		  case 3
		    return Dico.Value("Demitour")
		  case 4
		    return Dico.Value("QuartG")
		  case 5
		    return Dico.Value("QuartD")
		  case 6
		    return Dico.Value("Symmetrieaxiale")
		  case 7
		    return Dico.Value("Homothety")
		  case 8, 81, 82
		    return Dico.value("Similitude")
		  case 9
		    return Dico.value("Etirement")
		  case 10
		    return Dico.value("Deplacement")
		  case 11
		    return Dico.Value("Cisaillement")
		  end select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Highlight()
		  highlighted = true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ModifyImages()
		  dim i as integer  // Utilisé lors des modifications du support de la tsf
		  dim s1,s2 as shape
		  
		  if type = 0 then
		    return
		  end if
		  
		  if M <> nil and M.v1 <> nil then
		    for i = 0 to constructedshapes.count -1
		      s2 = Constructedshapes.item(i)
		      s1 = s2.constructedby.shape
		      Appliquer(s1,s2)
		      if s1 isa circle  or s1 isa lacet then
		        AppliquerExtreCtrl(s1,s2)
		      end if
		    next
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  
		  dim coul as couleur
		  
		  if type = 0 or hidden or not supp.noinvalidpoints then
		    return
		  end if
		  
		  if (not Hidden2 or CurrentContent.TheTransfos.DrapShowALL)  and not supp.invalid and not supp.deleted  then
		    if Highlighted then
		      coul = config.highlightcolor
		    else
		      if Hidden2 then
		        coul = Config.Hidecolor
		      else
		        coul = Config.Transfocolor
		      end if
		    end if
		    
		    if supp isa point then
		      point(supp).rsk.update(point(supp).bpt,supp.borderwidth)
		      point(supp).rsk.updatecolor(coul.col,100)
		      point(supp).rsk.paint(g)
		    else
		      supp.nsk.update(supp)
		      if supp isa Lacet then
		        Lskull(supp.nsk).paint(g, index, coul, type)
		      else
		        supp.nsk.paint(g,coul)
		      end if
		      DrawTip(g, coul)
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RacN(niter as integer) As Matrix
		  dim q, v as BasicPoint
		  dim u1, u2, u3, u4 As  BasicPoint
		  dim Mat as SimilarityMatrix
		  dim M1 as Matrix
		  dim bib1, Bib2 as BiBPoint
		  dim r1, r2 as double
		  dim i as integer
		  dim s as shape
		  
		  select case type
		  case 1, 2,3,4,5,7,71,72,8,81,82, 10
		    M1 = M.RacN(niter)
		  case 9
		    u1= supp.points(0).bpt
		    u2= supp.points(1).bpt
		    u3= supp.points(3).bpt
		    u4 = supp.points(2).bpt
		    Bib1 = new BiBPoint(u1,u2)
		    Bib2 = new BiBPoint(u3,u4)
		    q = Bib2.BibInterdroites(bib1,0,0,r1,r2)
		    u4 = q + (u3 -q)*(((r1-1)/r1)^(1/niter))
		    M1 = new AffinityMatrix(u1,u2,u3,u1,u2,u4)
		  case 11
		    u1= supp.points(0).bpt
		    u2= supp.points(1).bpt
		    u3= supp.points(3).bpt
		    u4 = supp.points(2).bpt
		    u4 = u3 + (u4-u3)/niter
		    M1 = new AffinityMatrix(u1,u2,u3,u1,u2,u4)
		  end select
		  
		  return M1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removeconstructioninfos(s as shape)
		  dim ff as figure
		  dim s1, s2,s3  As  shape
		  dim i, j, k as integer
		  dim t as Boolean
		  
		  if not S isa Point then
		    for j = 0 to s.npts-1
		      if s.childs(j).constructedby <> nil then
		        s1 = s.childs(j).constructedby.shape
		        s1.constructedshapes.remove s1.constructedshapes.indexof(s.childs(j))
		        s.childs(j).constructedby = nil
		      end if
		    next
		  end if
		  
		  t = true
		  for i = 0 to constructedshapes.count -1
		    if constructedshapes.item(i) <> s then
		      t = t and (constructedshapes.item(i).fig <> s.fig)
		    end if
		  next
		  if t then
		    removefigconstructioninfos(s)
		  end if
		  
		  s1 = s.Constructedby.shape
		  ff = s1.fig
		  t = true
		  k = ff.shapes.getposition(s1)
		  for i = 0 to ff.shapes.count-1
		    if i <> k then
		      for j = 0 to ubound(ff.shapes.item(i).constructedshapes)
		        s3 = ff.shapes.item(i).constructedshapes(j)
		        if s3.constructedby.oper = 6 then
		          t = t and s3.fig <> s.fig
		        end if
		      next
		    end if
		  next
		  
		  if t then
		    s1.fig.constructedfigs.removefigure s.fig
		  end if
		  
		  s1.constructedshapes.remove s1.constructedshapes.indexof(s)
		  constructedshapes.removeobject s
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removefigconstructioninfos(s as shape)
		  constructedfigs.removefigure s.fig
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub restore()
		  setfpsp(supp)
		  computematrix
		  oldM = M
		  modifyimages
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setconstructioninfos(s1 as shape, s2 as shape)
		  setconstructioninfos1(s1,s2)  //uniquement pour les vraies transfos (donc pas pour les paraperp)
		  setconstructioninfos2(s1,s2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setconstructioninfos1(s1 as shape, s2 as shape)
		  dim j as integer  'fixer les infos de construction de l'image
		  
		  s2.setconstructedby s1,6
		  s2.constructedby.data.append self
		  if not S2 isa Point then
		    for j = 0 to s2.npts-1
		      s2.Points(j).setconstructedby s1.Points(j),6
		      s2.Points(j).constructedby.data.append self
		      s2.points(j).liberte=0
		    next
		  else
		    s2.liberte = 0
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setconstructioninfos2(s1 as shape, s2 as shape)
		  if s2.fig = nil or s1.fig = nil then  'fixer les infos de construcion de la figure de l'image
		    return
		  end if
		  
		  s2.fig.setconstructedby s1.fig, self
		  updateconstructioninfos(s2)
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMethod("Transformation","setconstructioninfos2")
		    d.setVariable("s1",s1)
		    d.setVariable("s2",s2)
		    err.message = err.message+d.getString
		    
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setfpsp(s as shape)
		  if s isa droite then
		    fp = droite(s).firstp
		    sp = droite(s).secondp
		  elseif s isa secteur then
		    fp = s.points(0).bpt
		    sp = s.points(index/2+1).bpt
		  elseif s isa Bande then
		    fp=s.points(index).bpt
		    if index =0 then
		      sp = s.points(1).bpt
		    else
		      sp=Bande(s).Point3
		    end if
		  elseif s isa Lacet and (type = 1 or type = 6)  then
		    fp = s.points(index).bpt
		    sp = s.points((index+1) mod s.npts).bpt
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function supportonside(i as integer) As boolean
		  if index = i then
		    return true
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEps(tos as textoutputstream)
		  
		  dim i, j as integer
		  dim s as string
		  dim r as double
		  
		  if supp.hidden or supp.invalid or supp.deleted or hidden2 or  (type = 0) then
		    return
		  end if
		  
		  tos.writeline ( "2 fixeepaisseurtrait" )
		  tos.writeline ( "vert  fixecouleurtrait")
		  
		  select case type
		  case 1
		    if supp isa droite then
		      i = 0
		      j = 1
		    elseif supp isa polygon then
		      j = (index+1) mod supp.npts
		      i = index
		    end if
		    if ori = 1 then
		      tos.writeline ( "[ "+supp.Points(i).etiquet+ " 1  " + supp.Points(j).etiquet+ "]  fleche" )
		    else
		      tos.writeline ( "[ "+ supp.Points(j).etiquet+ " 1 "+ supp.Points(i).etiquet+ "]  fleche" )
		    end if
		  case 2
		    s= "[ [ " + supp.points(1).etiquet + supp.points(0).etiquet  + supp.points(2).etiquet + "] "
		    r = supp.points(0).bpt.distance(supp.points(1).bpt)*ori
		    s = s + " 1 " + str(r) + " ] "
		    if supp.ori = 1 then
		      tos.writeline s+" arcoripos"
		    else
		      tos.writeline s+" arcorineg"
		    end if
		  case 3, 4, 5
		    tos.writeline point(supp).etiquet + " point"
		  case 6
		    if supp isa droite then
		      droite(supp).toEPS(tos)
		    elseif supp isa polygon then
		      i = index
		      j = (index+1) mod supp.npts
		      tos.writeline ( "[ "+supp.Points(i).etiquet+ supp.Points(j).etiquet+ "]  segment")
		    elseif supp isa bande then
		      i = 2*index
		      j = 2*index +1
		      tos.writeline ( "[ "+supp.Points(i).etiquet+ supp.Points(j).etiquet+ "]  droite")
		    elseif supp isa secteur then
		      i = 0
		      j = index
		      tos.writeline ( "[ "+ supp.Points(i).etiquet+ supp.Points(j).etiquet+  "]  droite")
		    end if
		  case 7, 72, 8, 9, 10, 11
		    tos.writeline("[" + supp.points(0).etiquet + " " + supp.points(1).etiquet + " " + supp.points(2).etiquet + " " + supp.points(3).etiquet + "] polygone ")
		    if type <> 9 and type <>11 then
		      tos.writeline ( "[ "+supp.Points(0).etiquet+ " 1 "+supp.Points(3).etiquet+ "]  fleche" )
		    else
		      tos.writeline ( "[ "+supp.Points(3).etiquet+ " 1 "+supp.Points(2).etiquet+ "]  fleche" )
		    end if
		    if type <9 then
		      tos.writeline ( "[ "+supp.Points(1).etiquet+ " 1 "+supp.Points(2).etiquet+ "]  fleche" )
		    end if
		  case 71,81
		    supp.points(0).toeps(tos)
		    tos.writeline ( "[ "+supp.Points(1).etiquet+ " 1  "+supp.Points(2).etiquet+ "]  fleche" )
		  case 82
		    tos.writeline("[" + supp.points(0).etiquet+ " " + supp.points(1).etiquet+ " " + supp.points(2).etiquet + "] polygone ")
		    tos.writeline ( "[ "+supp.Points(0).etiquet+ " 1  "+supp.Points(1).etiquet+ "]  fleche" )
		    tos.writeline ( "[ "+supp.Points(1).etiquet+ " 1  "+supp.Points(2).etiquet+ "]  fleche" )
		  end select
		  
		  tos.writeline ( "1 fixeepaisseurtrait" )
		  tos.writeline ( "noir  fixecouleurtrait")
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Unhighlight()
		  highlighted = False
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update()
		  // Utilisé lors des modifications du support de la tsf
		  dim op as Operation
		  dim bp as BasicPoint
		  
		  if type = 0 then
		    return
		  end if
		  
		  setfpsp(supp)
		  OldM = M
		  op = CurrentContent.currentoperation
		  if op isa retourner and type = 4 then
		    type = 5
		  elseif op isa retourner and type = 5 then
		    type = 4
		  end if
		  computematrix
		  if FixPt <> nil then
		    bp = computefixpt
		    if bp <> nil then
		      FixPt.moveto bp
		    end if
		  end if
		  if   ( dret <> nil or  op isa modifier)  or CurrentContent.isaundoredo or (op isa ReadHisto and ReadHisto(op).OpId=31) then
		    ModifyImages
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateconstructioninfos(s as shape)
		  'fixer les infos relatives aux constructions opérées par la tsf
		  constructedshapes.AddShape s
		  updatefigconstructioninfos(s)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatefigconstructioninfos(s as shape)
		  constructedfigs.addobject s.fig
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc As XMLDocument) As XMLElement
		  dim Temp as XMLElement
		  
		  Temp = Doc.CreateElement(Dico.Value("Transformation"))
		  Temp.setattribute("TsfType", str(type))
		  Temp.SetAttribute("Ori",str(ori))
		  if Hidden2 then
		    Temp.SetAttribute("Hid",str(1))
		  end if
		  Temp.appendchild  supp.XMLPutIdInContainer(Doc)
		  if supp isa Lacet then
		    Temp.SetAttribute("Index", str(index))
		  end if
		  
		  return Temp
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
		chosen As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		constructedfigs As Figslist
	#tag EndProperty

	#tag Property, Flags = &h0
		Constructedshapes As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		Deleted As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		final As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		FixPt As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		fp As basicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		Hidden As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Hidden2 As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Highlighted As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		index As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Interm As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		M As matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		Modified As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		nn As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		oldbordercolor As color
	#tag EndProperty

	#tag Property, Flags = &h0
		OldM As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		ori As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		sp As basicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		supp As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		T As Tip
	#tag EndProperty

	#tag Property, Flags = &h0
		type As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="chosen"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Deleted"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="final"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden2"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Highlighted"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
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
			Name="Interm"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="nn"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="oldbordercolor"
			Visible=false
			Group="Behavior"
			InitialValue="&h000000"
			Type="color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ori"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
