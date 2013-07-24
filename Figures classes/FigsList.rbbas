#tag Class
Protected Class FigsList
Implements StringProvider
	#tag Method, Flags = &h0
		Function GetPosition(f as Figure) As Integer
		  
		  return figures.indexof(f)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddFigure(f as Figure)
		  dim i As integer
		  
		  if f = nil then
		    return
		  end if
		  
		  if GetPosition(f)  <> -1 then
		    return
		  else
		    Figures.append f
		  end if
		  
		  if (self = CurrentContent.TheFigs) and  f.idfig = -1 then
		    f.idfig = newIdFig
		    for i = 0 to f.subs.count-1
		      if f.subs.element(i).supfig <> f then
		        MsgBox  Dico.Value("InconsistFigs")
		      end if
		    next
		    f.XMLPutInContainer(1,CurrentContent.Oplist)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveFigure(f as Figure)
		  dim  EL1, EL2 as XMLElement
		  dim i As Integer
		  
		  if getposition(f) = -1 then
		    return
		  end if
		  
		  if (self = CurrentContent.TheFigs) and (Currentcontent.FigsCreated.Childcount > 0)   then
		    EL1 = XMLElement(CurrentContent.FigsCreated.firstchild)
		    for i = EL1.childcount-1 downto 0
		      EL2 = XMLElement(EL1.child(i))
		      if val(EL2.GetAttribute("FigId")) = f.idfig then
		        EL1.RemoveChild EL2
		      end if
		    next
		  elseif f.idfig <> -1 and CurrentContent.ForHisto  then
		    if (self = CurrentContent.TheFigs ) and (not wnd.dblclic  or (CurrentContent.currentoperation.currentshape.indexconstructedpoint > 1)) then
		      f.XMLPutInContainer(0,CurrentContent.Oplist)
		    end if
		  end if
		  
		  if figures.indexof(f) <> -1 then
		    figures.remove figures.indexof(f)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function count() As integer
		  return Ubound(Figures)+1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function element(idx As Integer) As Figure
		  if idx>=0 and idx<=Ubound(Figures) then
		    return Figures(idx)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FigsList()
		  previdfig = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Concat() As Figure
		  dim ff, sf as figure
		  dim temp as figslist
		  dim i, j as integer
		  dim pt as point
		  
		  //conserver toutes les figures jusqu'à la fin pour mettre à jour les infos de construction
		  temp = new figslist
		  
		  if count = 1 then
		    return element(0)
		  end if
		  
		  for i = count-1 downto 0
		    temp.addfigure Element(i)
		  next
		  
		  ff = new Figure
		  
		  for i = 0 to count-1
		    ff.shapes.concat element(i).shapes
		  next
		  
		  for i = 0 to count-1
		    ff.somm.concat element(i).somm
		  next
		  
		  for i = 0 to count-1
		    ff.PtsSur.concat element(i).PtsSur
		  next
		  
		  for i = 0 to count-1
		    ff.PtsConsted.concat element(i).PtsConsted
		  next
		  
		  for i = 0 to count-1
		    if element(i).isapoint = nil then                                    'Probleme: pourquoi avoir un jour supprimé ce test?  (révision 75) Prévu pour le cas ou des sommets de formes sont
		      for j = 0 to element(i).subs.count-1                          'construits avant les formes.
		        ff.subs.addfigure element(i).subs.element(j)
		      next
		    end if
		  next
		  
		  for i = 0 to ff.subs.count-1
		    ff.subs.element(i).supfig = ff
		  next
		  
		  for i = 0 to ff.shapes.count-1
		    ff.shapes.element(i).fig = ff
		  next
		  
		  for i = 0 to ff.somm.count-1
		    ff.somm.element(i).fig = ff
		  next
		  
		  for i = 0 to ff.PtsSur.count-1
		    ff.PtsSur.element(i).fig = ff
		  next
		  
		  for i = 0 to ff.PtsConsted.count-1
		    ff.PtsConsted.element(i).fig = ff
		  next
		  
		  for i = 0 to ff.somm.count-1
		    pt = point(ff.somm.element(i))
		    if pt <> nil then
		      ff.shapes.removeshape pt   // indispensable pour éviter certains bugs -- (cas où le point n'était pas construit)
		      if pt.pointsur.count > 0 then
		        ff.ptssur.addshape pt
		        for j = 0 to pt.pointsur.count-1
		          sf = pt.pointsur.element(j).getsousfigure(ff)
		          if sf <> nil then
		            sf.ptssur.addshape pt
		          end if
		        next
		      end if
		      if pt.centerordivpoint then
		        ff.ptsconsted.addshape pt
		        sf = pt.constructedby.shape.getsousfigure(ff)
		        if sf <> nil then
		          sf.ptsconsted.addshape pt
		        end if
		      end if
		    end if
		  next
		  ff.fusionnerautosimaff
		  ff.fusionnerinclusions
		  
		  temp.adjustconstructioninfos(ff)
		  temp.adjustconstructedinfos(ff)
		  CurrentContent.TheFigs.optimize(ff)
		  
		  return ff
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Removeall()
		  redim Figures(-1)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub save()
		  dim j as integer
		  
		  for j = 0 to count-1
		    element(j).save
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub restore()
		  dim j as integer
		  
		  for j = 0 to count-1
		    element(j).restore
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub canceloldbpts()
		  dim j as integer
		  
		  for j = 0 to count-1
		    element(j).canceloldbpts
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Ordonner() As Boolean
		  dim  n0 as integer
		  
		  redim index(-1)
		  
		  if count <= 1 then
		    index.append 0
		    return true
		  end if
		  
		  CreerMatricePrecedences(count)
		  
		  if not Mat.Null and  Bouclesasupprimer (n0) then
		    fusionner (n0)
		    return ordonner
		  else
		    CreerIndex
		    return true
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreerMatricePrecedences(n as integer)
		  dim i , j  , k as integer
		  
		  Mat = new MatrixnD(n)
		  
		  for i = 0 to n -2
		    for j = i+1 to n-1
		      if element(i).precede(element(j)) then
		        mat.col(i,j) = 1
		      end if
		      if element(j).precede(element(i)) then
		        mat.col(j,i) = 1
		      end if
		    next
		  next
		  
		  for i = 0 to n-1
		    for j = 0 to n-1
		      if i <> j then
		        for k = 0 to n-1
		          if k <> i and k <> j then
		            if mat.col(i,j) = 1 and mat.col(j,k) = 1  then
		              mat.col(i,k) = 1
		            end if
		          end if
		        next
		      end if
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsererIndex(i as integer)
		  'dim j as integer
		  
		  'If ubound(index) = -1 then
		  'index.append i
		  'else
		  'j = 0
		  'while j <= ubound(index) and Mat.col(i,index(j)) = 0
		  'j = j+1
		  'wend
		  'index.insert  j, i
		  '
		  'end if
		  
		  dim  j as integer
		  
		  if i = -1 or index.indexof(i) <> -1 then
		    return
		  end if
		  
		  j = 0
		  while j <=  UBound(index) and Mat.col(i,index(j)) = 0
		    j = j+1
		  wend
		  
		  index.insert j,i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreerIndex()
		  dim i, j as integer
		  dim p, q as point
		  redim index(-1)
		  
		  
		  if count = 1  then
		    index.append 0
		    return
		  end if
		  
		  q = modifier(currentcontent.currentoperation).pointmobile
		  if q.guide = nil then
		    p = q
		  else
		    p = q.guide
		  end if
		  index.append Figures.indexof(p.fig)
		  
		  for i = 0 to count-1
		    if index.indexof(i) = -1 then
		      j = 0
		      while j <=  UBound(index) and Mat.col(i,index(j)) = 0
		        j = j+1
		      wend
		      index.insert j,i
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Update(p as point, np as BasicPoint) As Boolean
		  dim t as Boolean
		  dim i as integer
		  dim M as Matrix
		  
		  
		  
		  M = new TranslationMatrix(np-p.bpt)
		  
		  p.updatefirstpoint(M)
		  
		  t = true
		  for i = 0 to count-1
		    t =element(index(i)).update1(p) and t
		  next
		  
		  return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub cancelfixedpoints()
		  dim i as integer
		  
		  for i = 0 to count-1
		    element(i).cancelfixedpoints
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Move(M as matrix)
		  dim i as integer
		  
		  
		  for i = 0 to count-1
		    element(i).Move(M)
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateState(st as string, p as point)
		  dim j as integer
		  dim EL as XMLElement
		  
		  EL = CurrentContent.Oplist.createelement(st)
		  
		  if p <> nil and p.pointsur.count > 0 and p.multassomm < 2 then
		    EL.appendchild InsertPointSurInState(p, CurrentContent.OpList)
		  end if
		  
		  if p <> nil and  p.multassomm > 0 then
		    EL.appendchild InsertTrueParents(p, CurrentContent.OpList)
		  end if
		  
		  if p <> nil and  p.centerordivpoint  then
		    EL.appendchild InsertConstedPoints(p, CurrentContent.OpList)
		  end if
		  
		  if st <> "FinalState" then
		    for j = 0 to count-1
		      element(j).createstate(EL)
		    next
		  end if
		  
		  if st = "FigsMoved" then
		    CurrentContent.FigsMoved.appendchild EL
		  else
		    CurrentContent.FigsModified.appendchild EL
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub creerlistesfigures()
		  dim i, j, n0, n1, n2, m0, m1 as integer //utilise par les mouvements
		  dim tsf as transformation
		  dim Tsflist As Transfoslist
		  dim ff as figure
		  dim MatId as Matrix
		  MatId = new Matrix(1)
		  dim curoper as Operation
		  curoper = CurrentContent.CurrentOperation
		  
		  redim listebuts(-1)
		  redim listesources(-1)
		  redim listetsf(-1)
		  figs0 = new figslist
		  
		  tsflist = CurrentContent.TheTransfos
		  CurrentContent.TheFigs.enablechooseall
		  for i = 0 to tsflist.count-1
		    tsf = TsfList.element(i)
		    for j = 0 to tsf.constructedfigs.count-1
		      tsf.constructedfigs.element(j).chosen = false
		    next
		  next
		  
		  for i = 0 to count-1
		    figs0.addfigure element(i)
		    figs0.element(i).chosen = true
		  next
		  
		  if tsflist.count = 0 then
		    return
		  end if
		  
		  n0 = -1
		  n2 = ubound(listetsf)
		  
		  while n2 < ubound(listetsf)+1
		    n1 = figs0.count-1
		    n2 = ubound(listetsf)+1
		    for i = 0 to tsflist.count-1
		      tsf = TsfList.element(i)
		      if  not (tsf.M.Equal(MatId)) or  ((not curoper isa glisser ) and (not curoper isa redimensionner) ) then
		        
		        for j = 0 to tsf.constructedfigs.count-1
		          if not tsf.constructedfigs.element(j).chosen then
		            ff = tsf.constructedfigs.element(j).constructioninfos(0).sourcefig
		            m0 = figs0.getposition(ff)
		            m1 = figs0.getposition(tsf.supp.fig)
		            if (m0 > n0 and m0 <= n1) or (m1 > n0 and m1 <= n1) then
		              listesources.append ff
		              listetsf.append tsf
		              listebuts.append tsf.constructedfigs.element(j)
		              figs0.addfigure tsf.constructedfigs.element(j)
		              tsf.constructedfigs.element(j).chosen = true
		            end if
		          end if
		        next
		      end if
		    next
		    n0 = n1
		  wend
		  
		  for i = 0 to ubound(listesources)
		    listesources(i).Mmove = new Matrix(1)
		    listetsf(i).oldM = listetsf(i).M
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Bouger(M as matrix)
		  dim i as integer
		  dim A,  M0, M1, M2, MId  as Matrix
		  dim but, source, supp as figure
		  dim dr as shape
		  
		  
		  MId = new Matrix(1)
		  
		  
		  move(M)
		  
		  for i = 0 to UBound(listetsf)
		    but = listebuts(i)
		    if but.isafigprp(dr) and listetsf(i).M.Equal(MId)  then
		      M2 = M.TranslaterOrigine
		      M2 = M2.Translater(dr.points(0).bpt)
		    else
		      source = listesources(i)
		      A = source.Mmove
		      M1 = listetsf(i).M
		      M0 = listetsf(i).oldM
		      M0 = M0.inv
		      M2 = M1*A*M0
		    end if
		    but.move(M2)
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub movepoints(M as matrix)
		  dim i as integer
		  
		  
		  for i = 0 to count-1
		    element(i).MovePoints(M)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Enablechooseall()
		  dim i as integer
		  for i = 0 to count-1
		    element(i).chosen = false
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NewIdFig() As Integer
		  prevIdfig = prevIdfig + 1
		  return previdfig
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetIdFig(n as integer)
		  previdfig = n
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveFigures(figs as figslist)
		  dim i as integer
		  
		  for i =  Figs.count-1 downto 0
		    RemoveFigure figs.element(i)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFigure(n as integer) As figure
		  dim i as integer
		  
		  for i = 0 to count-1
		    if element(i).idfig = n then
		      return element(i)
		    end if
		  next
		  
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub appendlist(liste as figslist)
		  dim i as integer
		  
		  for i = 0 to liste.count-1
		    addfigure liste.element(i)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InsertPointSurInState(p as point, Doc as XMLDocument) As XMLElement
		  dim i as integer
		  dim  Form, EL as XMLElement
		  
		  Form = Doc.CreateElement("PtSur")
		  
		  for i = 0 to p.pointsur.count - 1
		    EL = Doc.CreateElement("Forme")
		    EL.SetAttribute("Id",str(p.pointsur.element(i).id))
		    EL.SetAttribute("Location", str(p.location(i)))
		    EL.SetAttribute("Numside", str(p.numside(i)))
		    Form.appendchild EL
		  next
		  
		  return Form
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InsertTrueParents(p as point, Doc as XMLDocument) As XMLElement
		  dim i as integer
		  dim  Form, EL as XMLElement
		  
		  Form = Doc.CreateElement("Parents")
		  
		  for i = 0 to ubound(p.parents)
		    if p.parents(i).getindexpoint(p) <> -1 then
		      EL = Doc.CreateElement("Forme")
		      EL.SetAttribute("Id",str(p.parents(i).id))
		      Form.appendchild EL
		    end if
		  next
		  
		  return Form
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function bouclesasupprimer(ByRef n0 as integer) As Boolean
		  dim n as integer
		  
		  
		  n = Mat.nc
		  n0 = 1
		  M1 = Mat
		  
		  while  M1.Trace = 0 and not M1.Null and n0 < n
		    M1 = Mat*M1
		    n0 = n0+1
		  wend
		  
		  return M1.Trace >0
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateoldM()
		  dim i as integer
		  for i = 0 to count-1
		    element(i).updateoldM
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub adjustconstructedinfos(ff as figure)
		  dim i, j, k as integer
		  dim tsf as transformation
		  dim f as figure
		  
		  for k = 0 to count -1
		    for i =  element(k).Constructedfigs.count-1 downto 0
		      f =  element(k).Constructedfigs.element(i)
		      if getposition(f) = -1 then
		        for j = 0 to ubound(f.constructioninfos)
		          if f.constructioninfos(j).sourcefig = element(k) then
		            f.constructioninfos(j).sourcefig = ff
		          end if
		        next
		      else
		        for j = ubound(f.constructioninfos) downto 0
		          if f.constructioninfos(j).sourcefig = element(k) then
		            ff.setconstructedby ff, f.constructioninfos(j).tsf
		            tsf = f.Constructioninfos(j).tsf
		            tsf.constructedfigs.removefigure f
		            tsf.constructedfigs.addfigure ff
		            f.constructioninfos.remove j
		          end if
		        next
		      end if
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub adjustconstructioninfos(ff as figure)
		  dim f, sf as figure
		  dim i, j as integer
		  dim tsf as Transformation
		  dim sh as shape
		  dim pt as point
		  
		  for j =  count-1 downto 0
		    sf = element(j)
		    for i =  ubound(sf.constructioninfos) downto 0
		      f = sf.constructioninfos(i).sourcefig
		      tsf = sf.constructioninfos(i).tsf
		      f.constructedfigs.removefigure sf
		      if getposition(f) = -1 Then
		        ff.setconstructedby f, tsf
		      else
		        ff.setconstructedby ff, tsf
		      end if
		      tsf.constructedfigs.removefigure sf
		      tsf.constructedfigs.addfigure ff
		      sf.constructioninfos.remove i
		    next
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InsertConstedPoints(p as point, Doc as XMLDocument) As XMLElement
		  dim i as integer
		  dim  Form, EL as XMLElement
		  dim s as shape
		  dim tsf as Transformation
		  
		  Form = Doc.CreateElement("PtsConsted")
		  
		  
		  EL = Doc.CreateElement("Forme")
		  EL.SetAttribute("Id",str(p.constructedby.shape.id))
		  El.SetAttribute("Oper", str(p.constructedby.oper))
		  if p.constructedby.oper = 4 then
		    EL.setattribute("First", str(point(p.constructedby.data(0)).id))
		    EL.setattribute("Second", str(point(p.constructedby.data(1)).id))
		    EL.setattribute("NdivP",str(p.constructedby.data(2)))
		    EL.setattribute("DivP",str(p.constructedby.data(3)))
		  elseif p.constructedby.oper = 7 then
		    tsf = Transformation(p.ConstructedBy.data(0))
		    i = tsf.supp.GetIndexTsf(tsf)
		    EL.SetAttribute("Nr", str(i))
		  end if
		  Form.appendchild EL
		  
		  return Form
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub optimize(ff as figure)
		  dim i, j as integer
		  dim pt as point
		  dim temp as figslist
		  
		  temp = new figslist
		  
		  for i = 0 to count-1
		    pt = element(i).Isapoint
		    if pt <> nil then
		      if ff.somm.getposition(pt) <> -1 then
		        temp.addfigure element(i)
		      end if
		    end if
		  next
		  
		  if temp.count > 0 then
		    temp.adjustconstructioninfos(ff)
		    temp.adjustconstructedinfos(ff)
		  end if
		  
		  removefigures temp
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Canceltrace()
		  dim i As integer
		  
		  for i = 0 to count -1
		    element(i).canceltrace
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fusionner( n as integer)
		  dim i, j, nc as integer
		  dim ff as new figslist
		  dim f as figure
		  dim index() as integer
		  
		  nc = M1.nc
		  
		  for i = 0 to nc-1
		    if M1.col (i,i) > 0 then
		      ff.addfigure element(i)
		      index.append i
		    end if
		  next
		  
		  if ff.count > 0 then
		    f = ff.concat
		    f.ListerPrecedences
		    
		    for j = ubound(index) downto 0
		      CurrentContent.TheFigs.removefigure element(index(j))
		      removefigure element(index(j))
		    next
		    
		    addfigure f
		    CurrentContent.TheFigs.addfigure f
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub restructurer()
		  dim i as integer
		  
		  for i = 0 to count-1
		    element(i).restructurer
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub enablemodifyall()
		  dim i as integer
		  
		  for i = 0 to count -1
		    element(i).enablemodifyall
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatematrixduplicatedshapes(M as matrix)
		  dim i as integer
		  
		  for i = 0 to count-1
		    element(i).updatematrixduplicatedshapes(M)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As String
		  dim s as String
		  dim i as integer
		  
		  s = "FigsList{"
		  for i=0 to UBound(Figures)
		    s = s+Figures(i).getString+","
		  next
		  s = s+"}"
		  
		  return s
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
		Figures(-1) As Figure
	#tag EndProperty

	#tag Property, Flags = &h0
		Mat As MatrixnD
	#tag EndProperty

	#tag Property, Flags = &h0
		M1 As MatrixnD
	#tag EndProperty

	#tag Property, Flags = &h0
		Index(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		listesources(-1) As figure
	#tag EndProperty

	#tag Property, Flags = &h0
		listetsf(-1) As transformation
	#tag EndProperty

	#tag Property, Flags = &h0
		listebuts(-1) As figure
	#tag EndProperty

	#tag Property, Flags = &h0
		figs0 As figslist
	#tag EndProperty

	#tag Property, Flags = &h0
		previdfig As Integer
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
			Name="previdfig"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
