#tag Class
Protected Class Transformation
Implements StringProvider
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
		  end select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  
		  dim col as Couleur
		  
		  
		  if type = 0 then
		    return
		  end if
		  
		  if (not Hidden2 or CurrentContent.TheTransfos.DrapShowALL)  and not supp.invalid and not supp.deleted  then
		    if Highlighted then
		      col = Config.highlightcolor
		    else
		      if Hidden2 then
		        col = Config.Hidecolor
		      else
		        col = Config.Transfocolor
		      end if
		    end if
		    
		    if not hidden then
		      DrawTip(g, col)
		      if supp isa bande or supp isa secteur or (supp isa polygon and type < 7 ) then
		        supp.Paintside(g, index, 2, Col)
		      else
		        supp.paint(g,col)
		      end if
		    end if
		    
		  end if
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
		      s2 = Constructedshapes.element(i)
		      s1 = s2.constructedby.shape
		      Appliquer(s1,s2)
		    next
		    'constructedfigs.updatematrixduplicatedshapes(M)
		  end if
		  
		  
		End Sub
	#tag EndMethod

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
		    if s2 isa Lacet then
		      Lacet(s2).MoveExtreCtrl(M)
		      s2.endmove
		    end if
		  else
		    Point(s2).moveto M*Point(s1).bpt
		    s2.Modified = true
		  end if
		  
		  
		  
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
		  if   (dret <> nil or  op isa modifier)  or CurrentContent.isaundoredo or (op isa ReadHisto and ReadHisto(op).OpId=31) then
		    ModifyImages
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computematrix()
		  dim k as double
		  dim u,v,w as BasicPoint
		  
		  select case type
		  case 1
		    v = supp.points((index+1)mod supp.npts).bpt- supp.points(index) .bpt
		    M = new translationmatrix (v*ori)
		  case 2
		    M = new rotationmatrix (supp.points(0).bpt, arc(supp).arcangle)
		  case 3
		    M = new rotationmatrix(point(supp).bpt, PI)
		  case 4
		    M = new rotationmatrix(point(supp).bpt,PIDEMI)
		  case 5
		    M = new rotationmatrix(point(supp).bpt, -PIDEMI)
		  case 6
		    if  supp isa droite then
		      M = new SymmetryMatrix(droite(supp).firstp, droite(supp).secondp)
		    elseif supp isa bande then
		      if index = 0 then
		        v = supp.points(1).bpt
		      else
		        v = Bande(supp).Point3
		      end if
		      M = new SymmetryMatrix(supp.points(2*index).bpt, v)
		    elseif supp isa polygon then
		      M = new SymmetryMatrix(supp.points(index).bpt, supp.points((index+1) mod supp.npts).bpt)
		    elseif supp isa secteur then
		      M = new SymmetryMatrix(supp.points(0).bpt, supp.points(index).bpt)
		    end if
		  case 7, 72
		    M = new HomothetyMatrix(supp.points(0).bpt,supp.points(1).bpt,supp.points(3).bpt, supp.points(2).bpt)
		  case 71
		    u = supp.points(0).bpt
		    v = supp.points(1).bpt
		    w = supp.points(2).bpt
		    k = w.location(u,v)
		    M = new HomothetyMatrix(u, k)
		  case 8
		    M = new SimilarityMatrix(supp.points(0).bpt,supp.points(1).bpt,supp.points(3).bpt, supp.points(2).bpt)
		  case 81
		    M = new SimilarityMatrix(supp.points(0).bpt,supp.points(1).bpt,supp.points(0).bpt, supp.points(2).bpt)
		  case 82
		    M = new SimilarityMatrix(supp.points(0).bpt,supp.points(1).bpt,supp.points(1).bpt, supp.points(2).bpt)
		  case 9  //Etirements
		    M = new AffinityMatrix(supp.points(0).bpt,supp.points(1).bpt,supp.points(2).bpt, supp.points(0).bpt,supp.points(1).bpt,supp.points(3).bpt)
		  case 10
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
		Sub Transformation(s as shape, n as integer, i as integer, ori as integer)
		  Transformation
		  supp = s
		  type = n
		  index = i
		  self.ori = ori
		  computematrix
		  oldM = M
		  
		  
		  if type < 3 or type > 6 then
		    T = new Tip
		  end if
		  
		  setfpsp(s)
		  CurrentContent.TheTransfos.AddTsf(self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Transformation(s as shape, EL as XMLElement)
		  dim n, i as integer
		  
		  
		  n = val(EL.GetAttribute("TsfType"))
		  ori = val(EL.GetAttribute("Ori"))
		  i = val(EL.GetAttribute("Index"))
		  
		  Transformation(s,n,i,ori)
		  
		  if val(EL.GetAttribute("Hid")) = 1 then
		    Hidden2 = true
		  end if
		  
		  'if type = 71 then
		  'supp.points(2).moveto supp.points(2).bpt.projection(supp.points(0).bpt, supp.points(1).bpt)
		  'end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetNum() As integer
		  return supp.GetIndexTsf(self)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEps(tos as textoutputstream)
		  
		  dim i, j as integer
		  dim s as string
		  dim r as double
		  
		  if supp.hidden or supp.invalid or supp.deleted or (type = 0) then
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
		      tos.writeline ( "[ "+supp.Points(i).etiq+ " 1  " + supp.Points(j).etiq+ "]  fleche" )
		    else
		      tos.writeline ( "[ "+ supp.Points(j).etiq+ " 1 "+ supp.Points(i).etiq+ "]  fleche" )
		    end if
		  case 2
		    s= "[ [ " + supp.points(1).etiq + supp.points(0).etiq  + supp.points(2).etiq + "] "
		    r = supp.points(0).bpt.distance(supp.points(1).bpt)*ori
		    s = s + " 1 " + str(r) + " ] "
		    if supp.ori = 1 then
		      tos.writeline s+" arcoripos"
		    else
		      tos.writeline s+" arcorineg"
		    end if
		  case 3, 4, 5
		    tos.writeline point(supp).etiq + " point"
		  case 6
		    if supp isa droite then
		      droite(supp).toEPS(tos)
		    elseif supp isa polygon then
		      i = index
		      j = (index+1) mod supp.npts
		      tos.writeline ( "[ "+supp.Points(i).etiq+ supp.Points(j).etiq+ "]  segment")
		    elseif supp isa bande then
		      i = 2*index
		      j = 2*index +1
		      tos.writeline ( "[ "+supp.Points(i).etiq+ supp.Points(j).etiq+ "]  droite")
		    elseif supp isa secteur then
		      i = 0
		      j = index
		      tos.writeline ( "[ "+ supp.Points(i).etiq+ supp.Points(j).etiq+  "]  droite")
		    end if
		  case 7, 72, 8
		    tos.writeline("[" + supp.points(0).etiq + " " + supp.points(1).etiq + " " + supp.points(2).etiq + " " + supp.points(3).etiq + "] polygone ")
		    tos.writeline ( "[ "+supp.Points(0).etiq+ " 1 "+supp.Points(3).etiq+ "]  fleche" )
		    tos.writeline ( "[ "+supp.Points(1).etiq+ " 1 "+supp.Points(2).etiq+ "]  fleche" )
		  case 71,81
		    supp.points(0).toeps(tos)
		    tos.writeline ( "[ "+supp.Points(1).etiq+ " 1  "+supp.Points(2).etiq+ "]  fleche" )
		  case 82
		    tos.writeline("[" + supp.points(0).etiq + " " + supp.points(1).etiq + " " + supp.points(2).etiq  + "] polygone ")
		    tos.writeline ( "[ "+supp.Points(0).etiq+ " 1  "+supp.Points(1).etiq+ "]  fleche" )
		    tos.writeline ( "[ "+supp.Points(1).etiq+ " 1  "+supp.Points(2).etiq+ "]  fleche" )
		  end select
		  
		  tos.writeline ( "1 fixeepaisseurtrait" )
		  tos.writeline ( "noir  fixecouleurtrait")
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setfpsp(s as shape)
		  if s isa droite then
		    fp = droite(s).firstp
		    sp = droite(s).secondp
		  elseif s isa polygon and (type = 1 or type = 6)  then
		    fp = s.points(index).bpt
		    sp = s.points((index+1) mod s.npts).bpt
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Transformation()
		  constructedshapes = new Objectslist
		  constructedfigs = new FigsList
		  oldM = new Matrix(1)
		  M = new Matrix(1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateconstructioninfos(s as shape)
		  
		  constructedshapes.AddShape s
		  updatefigconstructioninfos(s)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removefigconstructioninfos(s as shape)
		  constructedfigs.removefigure s.fig
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatefigconstructioninfos(s as shape)
		  constructedfigs.addfigure s.fig
		  
		End Sub
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
		    if constructedshapes.element(i) <> s then
		      t = t and (constructedshapes.element(i).fig <> s.fig)
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
		      for j = 0 to ubound(ff.shapes.element(i).constructedshapes)
		        s3 = ff.shapes.element(i).constructedshapes(j)
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
		  constructedshapes.removeshape s
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFigSources(f as figure) As figslist
		  dim ffl as figslist
		  dim i as integer
		  
		  if constructedfigs.getposition(f) <> -1 then
		    ffl = new figslist
		    for i = 0 to ubound(f.constructioninfos)
		      if f.constructioninfos(i).tsf = self then
		        ffl.addfigure f.constructioninfos(i).sourcefig
		      end if
		    next
		    return ffl
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ComputeFixPt() As BasicPoint
		  dim MId, M1 as Matrix
		  dim Pt as BasicPoint
		  
		  MId = new Matrix(1)
		  M1 = M - MId
		  M1 = M1.inv
		  
		  if M1 <> nil then
		    pt = new BasicPoint(0,0)
		    return  M1*pt
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setconstructioninfos(s1 as shape, s2 as shape)
		  setconstructioninfos1(s1,s2)  //uniquement pour les vraies transfos (donc pas pour les paraperp)
		  setconstructioninfos2(s1,s2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setconstructioninfos1(s1 as shape, s2 as shape)
		  dim j as integer
		  
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
		Sub CleanConstructedFigs()
		  dim i, j as integer
		  dim ff, sfig as figure
		  dim t as Boolean
		  dim tsf as transformation
		  
		  for i =  constructedfigs.count-1 downto 0
		    ff = constructedfigs.element(i)
		    t = true
		    for j = 0 to constructedshapes.count-1
		      t = t and constructedshapes.element(j).fig <> ff
		    next
		    
		    if t then
		      constructedfigs.removefigure  ff
		    end if
		  next
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
		Sub Highlight()
		  highlighted = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Unhighlight()
		  highlighted = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawTip(g as graphics, col as couleur)
		  
		  dim a,b as BasicPoint
		  dim can as mycanvas
		  dim i as integer
		  
		  can = wnd.mycanvas1
		  if type < 3 or type > 6 then
		    select case type
		    case 1
		      if ori = 1 then
		        a = can.transform(supp.points(index).bpt)
		        b = can.transform(supp.points((index+1)mod supp.npts) .bpt)
		      else
		        b = can.transform(supp.points(index).bpt)
		        a = can.transform(supp.points((index+1)mod supp.npts) .bpt)
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
		      'case 81
		      'a = can.transform(supp.points(1).bpt)
		      'b = can.transform(supp.points(2).bpt)
		    case 7, 8, 72,10
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
		    case 9
		      a = can.transform(supp.points(2).bpt)
		      b = can.transform(supp.points(3).bpt)
		    end select
		    T.updatetip(a,b,col)
		    g.DrawObject T, b.x, b.y
		  end if
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
		  if supp isa polygon or supp isa Bande or supp isa secteur then
		    Temp.SetAttribute("Index", str(index))
		  end if
		  
		  return Temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As String
		  
		  return GetType
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AppliquerExtreCtrl(s1 as Circle, s2 as Circle)
		  dim i as integer
		  
		  for i = 0 to ubound(s2.extre)
		    s2.extre(i) = M*s1.extre(i)
		  next
		  for i = 0 to ubound(s2.ctrl)
		    s2.ctrl(i) = M*s1.ctrl(i)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Equal(tsf as Transformation) As Boolean
		  return (Type = tsf.type) and (supp = tsf.supp) and (ori = tsf.ori) and (index = tsf.index)
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
		M As matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		supp As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		Type As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Deleted As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Constructedshapes As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		oldbordercolor As color
	#tag EndProperty

	#tag Property, Flags = &h0
		T As Tip
	#tag EndProperty

	#tag Property, Flags = &h0
		index As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ori As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Highlighted As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Hidden As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		OldM As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		fp As basicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		sp As basicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		Modified As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		constructedfigs As Figslist
	#tag EndProperty

	#tag Property, Flags = &h0
		chosen As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		FixPt As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		Hidden2 As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		nn As Integer
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
			Name="Type"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Deleted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="oldbordercolor"
			Group="Behavior"
			InitialValue="&h000000"
			Type="color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ori"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Highlighted"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Modified"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="chosen"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden2"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nn"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
