#tag Class
Protected Class Duplicate
Inherits SelectAndDragOperation
	#tag Method, Flags = &h0
		Sub abort()
		  dim i as integer
		  
		  for i =  tempshape.count-1 downto 0
		    CurrentContent.thefigs.RemoveFigure copies.item(i).fig
		    copies.item(i).delete
		  next
		  copies.removeall
		  Finished = true
		  CurrentContent.TheObjects.unselectall
		  can.mousecursor =System.Cursors.StandardPointer
		  copyptsur = false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CompleteOperation(NewPoint as BasicPoint)
		  dim AttractedShape,AttractingShape,NextAttractingShape as Shape
		  dim Magnetism,tempm As  Integer
		  dim Mp as BasicPoint
		  
		  if copyptsur then
		    cop.moveto newpoint
		    if dret = nil then
		      magnetism = Magnetisme(copies.item(0),MagneticD)
		    end if
		    endpoint = newpoint
		  elseif Newpoint <> EndPoint and tempshape.count > 0 then
		    Glissement(NewPoint)
		  end if
		  
		  super.completeoperation(NewPoint)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  copies = new objectslist
		  OpId = 19
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(MExe as MacroExe, EL0 as XMLElement, EL1 as XMLElement)
		  dim n, rid as integer
		  dim pt, q as point
		  dim sh as shape
		  
		  super.constructor
		  n = val(XMLElement(EL1).GetAttribute("Id"))
		  rid = MExe.GetRealId(n)
		  pt = point(objects.GetShape(rid))
		  
		  n = val(XMLElement(EL0).GetAttribute("Forme0"))
		  rid = MExe.GetRealId(n)
		  sh = objects.GetShape(rid)
		  
		  q = new point(objects, new basicpoint(0,0))
		  
		  pt.putduplicateon (sh, q)
		  currentshape = q
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOper1(M as Matrix)
		  dim  M1 as Matrix
		  dim i as integer
		  
		  if Config.Ajust then
		    if CurrentContent.ForHisto  then
		      M1 = Ajustement
		    else
		      ajuster
		    end if
		    if angle <> 0 then
		      M1 = new RotationMatrix(RotationPoint.bpt, angle)
		      M = M1*M
		    end if
		  end if
		  for i = 0 to copies.count-1
		    if tempshape.item(i).fam < 10 then
		      setconstructioninfo(i, M)
		    end if
		  next
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMethod(getName,"EndOper1")
		    d.setVariable("M",M)
		    d.setVariable("i",i)
		    d.setVariable("Config.Ajust",Config.Ajust)
		    d.setVariable("M1",M1)
		    d.setVariable("Ajustement",Ajustement)
		    d.setVariable("angle",angle)
		    d.setVariable("RotationPoint.bpt",RotationPoint.bpt)
		    err.message = err.message+d.getString
		    
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOper2()
		  
		  dim p0, p1 as point
		  dim M as Matrix
		  
		  
		  if not copyptsur then
		    copies = tempshape
		    tempshape = oldtempshape
		    M = new TranslationMatrix(EndPoint)
		    EndOper1(M)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  
		  dim pt, q, s1 as point
		  dim M as Matrix
		  dim sh as shape
		  
		  if copyptsur then
		    if (startpoint.distance(endpoint) < Epsilon)  or (currentattractingshape = nil) then
		      abort
		      return
		    end if
		    pt = point(tempshape.item(0))
		    q = point(copies.item(0))
		    sh = pt.pointsur.item(0)
		    
		    if pt.constructedby <> nil and pt.constructedby.oper = 10 then
		      s1 =point(pt.constructedby.shape)
		      if s1.pointsur.item(0) = pt.pointsur.item(0)  and s1.numside(0) = pt.numside(0) then
		        abort
		      end if
		    end if
		    
		    if sh.sametype(CurrentAttractingShape) or q.surseg or (sh isa circle and currentattractingshape isa droite and droite(currentattractingshape).nextre = 2) then
		      CurrentContent.Thefigs.RemoveFigure Currentattractingshape.fig
		      pt.putduplicateon(Currentattractingshape,q)
		      q.addtofigure
		    else
		      abort
		    end if
		  else
		    vect = endpoint - startpoint
		    M = new translationmatrix(vect)
		    EndOper1(M)
		  end if
		  LierGroupes
		  
		  super.Endoperation
		  copies.removeall
		  copyptsur = false
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMethod(getName,"EndOperation")
		    d.setVariable("M",M)
		    d.setVariable("pt",pt)
		    d.setVariable("q",q)
		    err.message = err.message+d.getString
		    
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  return Dico.Value("Duplicate")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p As BasicPoint) As shape
		  dim s as shape
		  dim s1 as point
		  dim i as integer
		  
		  s =super.getshape(p)
		  
		  if visible.count > 0 then
		    for i = visible.count-1 downto 0
		      s = Visible.item(i)
		      if s.constructedby <> nil and s.constructedby.oper = 6 then
		        visible.removeobject s
		      end if
		      if s isa point and point(s).pointsur.count=1 and s.constructedby <> nil and s.constructedby.oper = 10 then
		        s1 =point(s.constructedby.shape)
		        if s1.pointsur.item(0) = point(s).pointsur.item(0)  and s1.numside(0) = point(s).numside(0) then
		          visible.removeobject s
		        end if
		      end if
		      if currentcontent.macrocreation and not s.isptsur then
		        visible.removeobject s
		      end if
		      nobj = visible.count
		    next
		  end if
		  
		  if Visible.count > 0  then
		    return visible.item(iobj)
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p As BasicPoint)
		  dim i as integer
		  
		  if currenthighlightedshape = nil then
		    Objects.unselectall
		    return
		  end if
		  
		  for i = tempshape.count-1 downto 0
		    if tempshape.item(i).constructedby <> nil and tempshape.item(i).constructedby.oper = 6 then
		      tempshape.item(i).dounselect
		      tempshape.removeobject tempshape.item(i)
		    end if
		  next
		  
		  figs.removeall
		  StartPoint = p
		  EndPoint = p
		  
		  selection
		  currentshape = currenthighlightedshape
		  
		  objects.tspfalse
		  finished = false
		  wnd.refreshtitle
		  nobj = 1
		  
		  if CurrentShape.Idgroupe <> -1 then
		    currentshape.SelectGroup
		  end if                                            // Ici, on sélectionne uniquement les objets liés au currentshape
		  if tempshape.count = 1 and tempshape.item(0).isptsur then
		    CopyPtsur = true
		  end if
		  SetCopies(p)
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseUp(p as BasicPoint)
		  
		  dim M as Matrix
		  
		  if  tempshape.count = 0 then
		    return
		  end if
		  if currentattractingshape <> nil and MagneticD <> nil then
		    if copyptsur then
		      M = new TranslationMatrix(magneticD-p)
		      cop.move(M)
		    else
		      M = new TranslationMatrix(magneticD)
		      figs.move(M)
		    end if
		    CurrentContent.theobjects.enablemodifyall
		    EndPoint=Endpoint+magneticD
		  elseif copyptsur then
		    abort
		  end if
		  
		  super.mouseup(p)
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  
		  
		  super.Paint(g)
		  
		  if copyptsur  then
		    cop.paint(g)
		  end if
		  if  CurrentHighlightedShape = nil  and finished = true then
		    display =  choose + aform
		  else
		    display =  click + thendrag
		  end if
		  
		  Help g, display
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim i, fid as integer
		  dim EL, EL1, EL2, EL3 as XMLElement
		  dim M as Matrix
		  dim dep as BasicPoint
		  
		  
		  
		  TMP = Temp
		  
		  EL = XMLElement(Temp.child(0))
		  SelectIdForms(EL)
		  
		  if EL.childcount = 3 then
		    EL2 = XMLElement(EL.child(2))
		    angle = val(EL.Getattribute("angle"))
		    EL2 = XMLElement(EL.child(0))
		    fid = val(EL.GetAttribute("Id"))
		  end if
		  
		  RedeleteDeletedFigures(Temp)
		  
		  EL1 = XMLElement(EL.Child(1))
		  
		  if tempshape.item(0) isa point and EL1.Name = Dico.value("Form") then
		    RecreateCreatedFigures(Temp)
		    if Config.Trace  then
		      CopyPtSur = true
		      EL3 = XMLElement(EL1.firstchild)
		      startpoint = Point(tempshape.item(0)).bpt
		      endpoint = new BasicPoint(val(EL3.GetAttribute("X")), val(EL3.GetAttribute("Y")))
		      dep =  EndPoint-StartPoint
		      dep = dep/60
		      fid = val(EL1.getattribute("Id"))
		      cop = point(objects.getshape(fid))
		      copies.addshape cop
		      dep =  EndPoint-StartPoint
		      dep = dep/60
		      cop.moveto startpoint
		      if dep.norme > epsilon then
		        oldtempshape = tempshape
		        tempshape = copies
		        dret = new ModifTimer(self)
		      end if
		    end if
		  else
		    setcopies(StartPoint)
		    LierGroupes
		    reputids(EL1)
		    ReCreateCreatedFigures(copies,Temp)
		    for i = 0 to tempshape.count-1
		      figs.addobject copies.item(i).fig
		    next
		    EndPoint = new BasicPoint(val(EL.GetAttribute("DX")), val(EL.GetAttribute("DY")))
		    StartPoint = new BasicPoint(0,0)
		    M = new TranslationMatrix(EndPoint)
		    dep =  EndPoint-StartPoint
		    dep = dep/60
		    if Config.Trace and dep.norme > epsilon then
		      oldtempshape = tempshape
		      tempshape = copies
		      dret = new ModifTimer(self)
		    else
		      figs.Bouger(M)
		      EndOper1(M)
		    end if
		  end if
		  wnd.refresh
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setconstedpoint(i as integer, sh as shape)
		  dim s as shape
		  dim p, q as point
		  dim n, op, j as integer
		  
		  //sh est la nouvelle copie, (duplicata de s)
		  
		  s = tempshape.item(i)
		  if s.centerordivpoint then                            //les dupliqués des points de subdivision ou des centres sont considérés cimme des points de subdiv
		    q = point(sh)                                             //ou des centres pourautant que la forme mère des originaux soit également dupliquée
		    s1 = s.constructedby.shape
		    n = tempshape.getposition(s1)
		    if n <> -1 then                                        //on vérifie que la forme s1, père du point s (division ou centre) figure parmi les dupliqués
		      op = s.constructedby.oper              // op = 0 (centre) ou 4 (division) ou 7 (pt fixe de tsf)
		      if op <> 7 then                                  //on ne duplique pas une tsf en même temps que son support
		        q.setconstructedby(copies.item(n),op)
		        if op = 4 then
		          p = point(s.constructedby.data(0))
		          j = s1.getindexpoint(p)
		          q.constructedby.data.append copies.item(n).points(j)
		          p = point(s.constructedby.data(1))
		          j = s1.getindexpoint(p)
		          q.constructedby.data.append copies.item(n).points(j)
		          q.constructedby.data.append s.constructedby.data(2)
		          q.constructedby.data.append s.constructedby.data(3)
		        end if
		      end if
		    end if
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setconstructioninfo(i as integer, M as Matrix)
		  dim j, n, k,op as integer
		  dim P, qq as Point
		  dim s, s1, q  As  shape
		  dim M1 as Matrix
		  dim ff as figure
		  
		  s = tempshape.item(i)
		  q =copies.item(i)
		  
		  if q.centerordivpoint then
		    return
		  end if
		  M1 = new Matrix(1)
		  while s.successeur3(s1)
		    s = s1
		    M1 = Matrix(s1.constructedby.data(0)) * M1
		  wend
		  
		  M1 = M1.inv
		  M1 = M*M1
		  q.SetConstructedBy s,3
		  q.constructedby.data.append M1
		  if not s isa point then
		    for j = 0 to s.npts-1
		      if q.points(j).centerordivpoint then
		        s1 = s.points(j).constructedby.shape
		        n = tempshape.getposition(s1)
		        if n <> -1 and (n < i) and tempshape.getposition(s.points(j)) <> -1 then
		          k = tempshape.getposition(s.points(j))
		          q.SubstitutePoint(point(copies.item(k)), q.points(j))
		        end if
		      else
		        q.points(j).setconstructedby s.points(j), 3
		        q.points(j).constructedby.data.append M1
		        q.points(j).updateguides
		        q.points(j).mobility
		      end if
		    next
		  else
		    point(q).updateguides
		    point(q).mobility
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetCopies(p As BasicPoint)
		  dim i, j as integer
		  dim s1,s2 as Shape
		  dim ffigs as Figslist
		  dim ff as figure
		  
		  Vect = p
		  
		  p = new BasicPoint(0,0)
		  
		  if copyPtSur then
		    s1 = tempshape.item(0)
		    cop = new point(objects, point(s1).bpt)
		    cop.forme = s1.forme
		    cop.surseg = point(s1).surseg
		    copies.addshape cop
		  else
		    for i = 0 to tempshape.count-1
		      s1=tempshape.item(i)
		      if s1 isa point then
		        s2 = s1.paste(objects,point(s1).bpt)
		      else
		        s2 = s1.paste(objects,p)
		      end if
		      copies.addshape s2
		      setconstedpoint(i,s2)
		      IdentifyPointsinCopies(s2,i)
		      s2.EndConstruction
		      s2.nonpointed = s1.nonpointed
		      if s1.Highlighted then
		        highlight s2
		      end if
		    next
		    
		    for i = 0 to tempshape.count-2         //Si deux formes sources sont dans la même figure, les images doivent aussi être dans la même figure
		      for j = i+1 to tempshape.count-1
		        if (tempshape.item(i).fig = tempshape.item(j).fig) and (copies.item(i).fig <> copies.item(j).fig)  then
		          ffigs = new Figslist
		          ffigs.addobject copies.item(i).fig
		          ffigs.addobject copies.item(j).fig
		          CurrentContent.Thefigs.Removefigures ffigs
		          ff = ffigs.concat
		          ff.ListerPrecedences
		          CurrentContent.TheFigs.addobject ff
		        end if
		      next
		    next                                                  //Il faudra faire attention aux points construits dans setconstructioninfo
		    
		    for i = 0 to tempshape.count-1
		      figs.addobject copies.item(i).fig
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XmlDocument, EL as XMLElement) As XMLElement
		  dim Temp as XMLElement
		  
		  if copyptsur then
		    Temp = cop.XMLPutIdINContainer(Doc)
		    Temp.setAttribute("Forme0", str(cop.pointsur.item(0).id))
		    EL.appendchild Temp
		    EL.appendchild cop.XMLPutConstructionInfoInContainer(Doc)
		  end if
		  return EL
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  dim Myself, Temp, EL as XMLElement
		  
		  
		  Myself= Doc.CreateElement(GetName)
		  Myself.SetAttribute("DX", str(EndPoint.x-StartPoint.x))
		  Myself.SetAttribute("DY", str(EndPoint.y-StartPoint.y))
		  Myself.appendchild tempshape.XMLPutIdInContainer(Doc)
		  if copyptsur then
		    Myself.appendchild cop.XMLPutInContainer(Doc)
		  else
		    Myself.appendchild copies.XMLPutInContainer(Doc)
		  end if
		  
		  if rotationpoint <> nil then
		    Temp=XMLElement(Doc.CreateElement("Rotation"))
		    Temp.appendchild RotationPoint.XMLPutIdInContainer(Doc)
		    Temp.setattribute("angle",str(angle))
		    Myself.appendchild(Temp)
		  end if
		  return Myself
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim i,j,n as integer
		  dim s1, s2 as Shape
		  dim EL, EL1, EL2 as XMLElement
		  
		  EL = XMLElement(Temp.child(0))
		  SelectIdForms(EL)
		  
		  
		  EL1 = XMLElement(EL.Child(1))
		  
		  if tempshape.item(0) isa point and EL1.Name = Dico.value("Form") then
		    CopyPtSur = true
		    n = val(EL1.GetAttribute("Id"))
		    copies.addshape Objects.Getshape(n)
		  else
		    for i = 0 to EL1.childcount-1
		      EL2 = XMLElement(EL1.child(i))
		      n = val(EL2.GetAttribute("Id"))
		      copies.addshape Objects.Getshape(n)
		    next
		  end if
		  
		  for i =  tempshape.count-1 downto 0
		    s2 = copies.item(i)
		    if s2.constructedby <> nil then
		      s1 = s2.constructedby.shape
		      j = s1.constructedshapes.indexof(s2)
		      s1.constructedshapes.remove j
		    end if
		    if CopyPtSur then
		      point(s2).pointsur.item(0).removechild s2
		    end if
		    currentcontent.removeobject s2
		  next
		  
		  ReDeleteCreatedFigures(Temp)
		  RecreateDeletedFigures(Temp)
		  
		  objects.unselectall
		  wnd.refresh
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
		cop As point
	#tag EndProperty

	#tag Property, Flags = &h0
		CopyPtSur As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		icot As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		oldtempshape As objectslist
	#tag EndProperty

	#tag Property, Flags = &h0
		s1 As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		TMP As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		Vect As BasicPoint
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Angle"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CopyPtSur"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapUA"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapUL"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fid"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="icot"
			Group="Behavior"
			InitialValue="0"
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
			Name="info"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ntsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SidetoPaint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Std2flag"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
