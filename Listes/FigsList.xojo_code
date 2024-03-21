#tag Class
Protected Class FigsList
Inherits Liste
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit)) or  (TargetAndroid and (Target64Bit))
	#tag Method, Flags = &h0
		Sub AddObject(Obj as Figure)
		  Dim i As Integer
		  
		  
		  if Obj = nil then
		    return
		  end if
		  
		  if GetPosition(Obj) <> -1 then
		    return
		  Else
		    Objects.append Obj
		  end if
		  
		  
		  super.AddObject(obj)
		  
		  
		  if (self = CurrentContent.TheFigs) and Obj.idfig = -1 then
		    Obj.idfig = newIdFig
		    for i = 0 to Obj.subs.count-1
		      if Obj.subs.item(i).supfig <> Obj then
		        MsgBox  Dico.Value("InconsistFigs")
		      end if
		    next
		    Obj.XMLPutInContainer(1,CurrentContent.Oplist)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub adjustconstructedinfos(ff as figure)
		  dim i, j, k as integer
		  dim tsf as transformation
		  dim f as figure
		  
		  for k = 0 to count-1
		    for i =  item(k).Constructedfigs.count-1 downto 0
		      f =  item(k).Constructedfigs.item(i)
		      if getposition(f) = -1 then
		        for j = 0 to ubound(f.constructioninfos)
		          if f.constructioninfos(j).sourcefig = item(k) then
		            f.constructioninfos(j).sourcefig = ff
		          end if
		        next
		      else
		        for j = ubound(f.constructioninfos) downto 0
		          if f.constructioninfos(j).sourcefig = item(k) then
		            ff.setconstructedby ff, f.constructioninfos(j).tsf
		            tsf = f.Constructioninfos(j).tsf
		            tsf.constructedfigs.removefigure f
		            tsf.constructedfigs.addobject ff
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
		  
		  for j =  count-1 downto 0
		    sf = item(j)
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
		      tsf.constructedfigs.addobject ff
		      sf.constructioninfos.remove i
		    next
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub appendlist(liste as figslist)
		  dim i as integer
		  
		  for i = 0 to liste.count-1
		    addobject liste.item(i)
		  next
		End Sub
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
		Sub Bouger(M as matrix)
		  dim i as integer
		  dim A,  M0, M1, M2, MId  as Matrix
		  dim but, source as figure
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
		Sub cancelfixedpoints()
		  dim i as integer
		  
		  for i = 0 to count-1
		    item(i).cancelfixedpoints
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub canceloldbpts()
		  dim j as integer
		  
		  for j = 0 to count-1
		    item(j).canceloldbpts
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Canceltrace()
		  dim i As integer
		  
		  for i = 0 to count -1
		    item(i).canceltrace
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Concat() As Figure
		  Dim ff, sf As figure
		  dim temp as figslist
		  dim i, j as integer
		  dim pt as point
		  
		  if count = 1 then
		    return item(0)
		  end if
		  
		  //conserver toutes les figures jusqu'à la fin pour mettre à jour les infos de construction
		  temp = new figslist
		  
		  for i = count-1 downto 0
		    temp.addobject item(i)
		  next
		  
		  ff = new Figure
		  
		  for i = 0 to count-1
		    ff.shapes.concat item(i).shapes
		  next
		  
		  for i = 0 to count-1
		    ff.somm.concat item(i).somm
		  next
		  
		  for i = 0 to count-1
		    ff.PtsSur.concat item(i).PtsSur
		  next
		  
		  for i = 0 to count-1
		    ff.PtsConsted.concat item(i).PtsConsted
		  next
		  
		  for i = 0 to count-1
		    if item(i).isapoint = nil then       'Probleme: pourquoi avoir un jour supprimé ce test?  (révision 75) Prévu pour le cas ou des sommets de formes sont
		      for j = 0 to item(i).subs.count-1                          'construits avant les formes.
		        ff.subs.addobject item(i).subs.item(j)
		      next
		    end if
		  next
		  
		  for i = 0 to ff.subs.count-1
		    ff.subs.item(i).supfig = ff
		  next
		  
		  for i = 0 to ff.shapes.count-1
		    ff.shapes.item(i).fig = ff
		  next
		  
		  for i = 0 to ff.somm.count-1
		    ff.somm.item(i).fig = ff
		  next
		  
		  for i = 0 to ff.PtsSur.count-1
		    ff.PtsSur.item(i).fig = ff
		  next
		  
		  for i = 0 to ff.PtsConsted.count-1
		    ff.PtsConsted.item(i).fig = ff
		  next
		  
		  for i = 0 to ff.somm.count-1
		    pt = point(ff.somm.item(i))
		    if pt <> nil and pt.macconstructedby = nil then
		      ff.shapes.removeobject pt   // indispensable pour éviter certains bugs -- (cas où le point n'était pas construit)
		      if pt.pointsur.count > 0 then
		        ff.ptssur.addshape pt
		        for j = 0 to pt.pointsur.count-1
		          sf = pt.pointsur.item(j).getsousfigure(ff)
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
		  
		  ff.fusionnerinclusions
		  
		  temp.adjustconstructioninfos(ff)
		  temp.adjustconstructedinfos(ff)
		  CurrentContent.TheFigs.optimize(ff)
		  
		  return ff
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  previdfig = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function count() As integer
		  return Ubound(objects)+1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateState(st as string, p as point)
		  dim j as integer
		  dim EL as XMLElement
		  
		  EL = CurrentContent.Oplist.CreateElement(st)
		  
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
		      item(j).createstate(EL)
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
		Sub CreerIndex()
		  dim i, j as integer
		  dim p, q as point
		  redim index(-1)
		  
		  
		  if count = 1  then
		    index.append 0
		    return
		  end if
		  
		  if currentcontent.forhisto then
		    q = modifier(currentcontent.currentoperation).pointmobile
		  elseif currentcontent.currentoperation isa readHisto then
		    q = modifier(readhisto(currentcontent.currentoperation).curoper).pointmobile
		  else
		    q = modifier(currentcontent.curoper).pointmobile
		  end if
		  if q.guide = nil then
		    p = q
		  else
		    p = q.guide
		  end if
		  index.append Objects.indexof(p.fig)
		  
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
		    tsf = TsfList.item(i)
		    for j = 0 to tsf.constructedfigs.count-1
		      tsf.constructedfigs.item(j).chosen = false
		    next
		  next
		  
		  for i = 0 to count-1
		    figs0.addobject item(i)
		    figs0.item(i).chosen = true
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
		      tsf = TsfList.item(i)
		      for j = 0 to tsf.constructedfigs.count-1
		        if not tsf.constructedfigs.item(j).chosen then
		          ff = tsf.constructedfigs.item(j).constructioninfos(0).sourcefig
		          m0 = figs0.getposition(ff)
		          m1 = figs0.getposition(tsf.supp.fig)
		          if (m0 > n0 and m0 <= n1) or (m1 > n0 and m1 <= n1) then
		            listesources.append ff
		            listetsf.append tsf
		            listebuts.append tsf.constructedfigs.item(j)
		            figs0.addobject tsf.constructedfigs.item(j)
		            tsf.constructedfigs.item(j).chosen = true
		          end if
		        end if
		      next
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
		Sub CreerMatricePrecedences(n as integer)
		  dim i , j  , k as integer
		  
		  Mat = new MatrixnD(n)
		  
		  for i = 0 to n -2
		    for j = i+1 to n-1
		      if item(i).precede(item(j)) then
		        mat.col(i,j) = 1
		      end if
		      if item(j).precede(item(i)) then
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
		Sub Enablechooseall()
		  dim i as integer
		  for i = 0 to count-1
		    item(i).chosen = false
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub enablemodifyall()
		  dim i as integer
		  
		  for i = 0 to count -1
		    item(i).enablemodifyall
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fusionner()
		  dim i, j, nc as integer
		  dim ff as new figslist
		  dim f as figure
		  dim index() as integer
		  
		  nc = M1.nc
		  
		  for i = 0 to nc-1
		    if M1.col (i,i) > 0 then
		      ff.addobject item(i)
		      index.append i
		    end if
		  next
		  
		  
		  if ff.count > 0 then
		    f = ff.concat
		    f.ListerPrecedences
		    
		    for j = ubound(index) downto 0
		      CurrentContent.TheFigs.removefigure item(index(j))
		      removefigure item(index(j))
		    next
		    
		    addobject f
		    CurrentContent.TheFigs.addobject f
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fx1cancel()
		  dim i as integer
		  
		  for i=0 to count-1
		    item(i).fx1cancel
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFigure(n as integer) As figure
		  dim i as integer
		  
		  for i = 0 to count-1
		    if item(i).idfig = n then
		      return item(i)
		    end if
		  next
		  
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPosition(f as Figure) As Integer
		  
		  return Objects.indexof(f)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As String
		  dim s as String
		  dim i as integer
		  
		  s = "FigsList{"
		  for i=0 to UBound(Objects)
		    s = s+Figure(Objects(i)).getString+","
		  next
		  s = s+"}"
		  
		  return s
		End Function
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
		Function InsertConstedPoints(p as point, Doc as XMLDocument) As XMLElement
		  dim i as integer
		  dim  Form, EL as XMLElement
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
		Function InsertPointSurInState(p as point, Doc as XMLDocument) As XMLElement
		  dim i as integer
		  dim  Form, EL as XMLElement
		  
		  Form = Doc.CreateElement("PtSur")
		  
		  for i = 0 to p.pointsur.count - 1
		    EL = Doc.CreateElement("Forme")
		    EL.SetAttribute("Id",str(p.pointsur.item(i).id))
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
		Function item(n as integer) As Figure
		  return Figure(element(n))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Move(M as matrix)
		  dim i as integer
		  
		  
		  for i = 0 to count-1
		    item(i).Move(M)
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub movepoints(M as matrix)
		  dim i as integer
		  
		  
		  for i = 0 to count-1
		    item(i).MovePoints(M)
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
		Sub optimize(ff as figure)
		  dim i as integer
		  dim pt as point
		  dim temp as figslist
		  
		  temp = new figslist
		  
		  for i = 0 to count-1
		    pt = item(i).Isapoint
		    if pt <> nil then
		      if ff.somm.getposition(pt) <> -1 then
		        temp.addobject item(i)
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
		Function Ordonner() As Boolean
		  dim  n0 as integer
		  
		  redim index(-1)
		  
		  if count <= 1 then
		    index.append 0
		    return true
		  end if
		  
		  CreerMatricePrecedences(count)
		  
		  if not Mat.Null and  Bouclesasupprimer (n0) then
		    fusionner 
		    return ordonner
		  else
		    CreerIndex
		    return true
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveFigure(f as Figure)
		  Dim  EL1, EL2 As XMLElement
		  dim i As Integer
		  
		  If f = Nil Or getposition(f) = -1 Then
		    return
		  end if
		  
		  If (Self = CurrentContent.TheFigs) And (Currentcontent.FigsCreated.Childcount > 0)   Then
		    EL1 = XMLElement(CurrentContent.FigsCreated.firstchild)
		    For i = EL1.childcount-1 DownTo 0
		      EL2 = XMLElement(EL1.child(i))
		      If Val(EL2.GetAttribute("FigId")) = f.idfig Then
		        EL1.RemoveChild EL2
		      End If
		    Next
		  Elseif f.idfig <> -1 And CurrentContent.ForHisto  Then
		    If (Self = CurrentContent.TheFigs ) Then 'And (CurrentContent.currentoperation.currentshape.indexconstructedpoint > 1) Then
		      'conserver ou non le "and" ci-dessus? Si on remet ce "and", octopus se plante
		      f.XMLPutInContainer(0,CurrentContent.Oplist)
		    End If
		  End If
		  
		  RemoveObject f
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveFigures(figs as figslist)
		  dim i as integer
		  
		  for i =  Figs.count-1 downto 0
		    RemoveFigure figs.item(i)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub restore()
		  dim j as integer
		  
		  for j = 0 to count-1
		    item(j).restore
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub restructurer()
		  dim i as integer
		  
		  for i = 0 to count-1
		    item(i).restructurer
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub save()
		  dim j as integer
		  
		  for j = 0 to count-1
		    item(j).save
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetIdFig(n as integer)
		  previdfig = n
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Update(p as point, np as BasicPoint) As Boolean
		  dim t as Boolean
		  dim i as integer
		  
		  if p = nil then
		    return false
		  end if
		  p.updatefirstpoint(np)
		  t = true
		  for i = 0 to count-1
		    t = item(index(i)).update1(p) and t
		  next
		  
		  return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatematrixduplicatedshapes(M as matrix)
		  dim i as integer
		  
		  for i = 0 to count-1
		    item(i).updatematrixduplicatedshapes(M)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateoldM()
		  dim i as integer
		  for i = 0 to count-1
		    item(i).updateoldM
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
		figs0 As figslist
	#tag EndProperty

	#tag Property, Flags = &h0
		Index(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		listebuts(-1) As figure
	#tag EndProperty

	#tag Property, Flags = &h0
		listesources(-1) As figure
	#tag EndProperty

	#tag Property, Flags = &h0
		listetsf(-1) As transformation
	#tag EndProperty

	#tag Property, Flags = &h0
		M1 As MatrixnD
	#tag EndProperty

	#tag Property, Flags = &h0
		Mat As MatrixnD
	#tag EndProperty

	#tag Property, Flags = &h0
		previdfig As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
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
			Name="previdfig"
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
	#tag EndViewBehavior
End Class
#tag EndClass
