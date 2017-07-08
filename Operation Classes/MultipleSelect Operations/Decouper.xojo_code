#tag Class
Protected Class Decouper
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub addtofigurecutinfos()
		  dim i as integer
		  dim p as point
		  dim ff as figure
		  dim List1 as figslist
		  
		  ff = currentshape.fig
		  
		  for i = 0 to ncutpt-1
		    p = cutpts(i)
		    if ff.somm.getposition(p) = -1 and ff.ptssur.getposition(p) = -1 and ff.ptsconsted.getposition(p) = -1 then
		      CurrentContent.Thefigs.Removefigure ff
		      CurrentContent.Thefigs.Removefigure p.fig
		      List1 = new figslist
		      list1.addobject ff
		      list1.addobject p.fig
		      ff = list1.concat
		      ff.ListerPrecedences
		      CurrentContent.TheFigs.addobject ff
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Choixvalide(pt as point) As Boolean
		  select case currentitemtoset
		  case 2
		    if not currentshape.std then
		      return  currentshape.PointOnSide (Pt.bpt) <> -1
		    else
		      return  (currentshape.getindexpoint(pt) <> -1) or ((pt.constructedby <> nil) and (pt.constructedby.shape = currentshape) )
		    end if
		  else
		    if  (Pt = CutPts(ncutpt-1) or Pt = CutPts(0))  then
		      return false
		    end if
		    if currentshape.std then
		      return  (currentshape.getindexpoint(pt) <> -1) or ((pt.constructedby <> nil) and (pt.constructedby.shape = currentshape) )
		    else
		      return true
		    end if
		  end select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  OpId = 25
		  wnd.PointerPolyg
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i as integer                          'Cut(0) et Cut(1) sont les deux pièces
		  
		  
		  currentshape.movetoback
		  
		  for i = 0 to 1
		    Cut(i) = GetCutShape (i)                                                                   //Cut(i) = GetCutShape (i+1,true)
		  next
		  
		  addtofigurecutinfos
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.endoperation
		  redim CutPts(-1)
		  Cut(0)=nil
		  Cut(1)=nil
		  ncutpt = 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FinishedSelecting() As Boolean
		  if CurrentItemToSet >3 and ValidPointOnSide(CutPts(ncutpt-1)) then
		    return true
		  else
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCutShape(n as integer) As Shape
		  //Méthode qui construit les deux pièces de la découpe. On y passe d'abord avec n = 0 puis n =1
		  
		  dim s as Shape
		  dim i, k as integer
		  dim M as Translationmatrix
		  dim P, pt1, pt2 As Point
		  dim k2 as double
		  dim bp, Tr as basicPoint
		  dim centres() as BasicPoint
		  dim curved() as integer
		  
		  if (currentshape isa Circle)  or (currentshape.hybrid) then
		    s = new Lacet(Objects)   //initialisation de la pièce
		  elseif currentshape isa standardpolygon then
		    s = new StandardPolygon(Objects)
		  else
		    s = new Polyqcq(Objects)
		  end if
		  
		  if not s.std then
		    s.SetConstructedBy currentshape,5
		  end if
		  
		  if n = 0 then
		    for i = 0 to ncutpt-1                              //On ajoute les points de découpe. addpoint se trouve dans polygon ou Lacet
		      s.addpoint(CutPts(i).bpt)                 // ncpts augmente chaque fois de 1, npts aussi. Donc ncpts = ncutpt
		    next
		  else
		    for i =  ncutpt-1  downto 0                  //on parcourt le trait de découpage dans l'autre sens
		      s.addpoint(CutPts(i).bpt)
		    next
		  end if
		  
		  redim centres(-1)
		  redim curved(-1)
		  
		  for i = 0 to s.npts-2
		    centres.append nil
		    curved.append 0
		  next
		  
		  if n = 0 then                           //pt1 et pt2 sont les deux points de découpe situés sur le bord de currentshape
		    pt1= cutpts(ncutpt-1)      //partir de cutpts(ncutpt-1), revenir à cutpts(0)  entretemps on va adjoindre les sommets de s rencontrés
		    pt2 = cutpts(0)
		  else
		    pt1= cutpts(0)                  //partir de cutpts(0), revenir à cutpts(ncutpt-1) idem
		    pt2 = cutpts(ncutpt-1)
		  end if
		  
		  while Pt1<> Pt2                                     //pt1 parcourt les sommets intermédiaires pt2 est le point final
		    if pt2 = currentshape.NextBorderPoint(pt1, pt2) then
		      if currentshape isa polygon then
		        centres.append nil
		        curved.append 0
		      elseif currentshape isa circle then
		        centres.append currentshape.points(0).bpt
		        curved.append 1
		      elseif currentshape isa lacet then
		        k = currentshape.GetIndexPoint(pt1)
		        if k = -1 then
		          k = lacet(currentshape).pointonside(pt1.bpt)
		        end if
		        centres.append currentshape.coord.centres(k)
		        curved.append currentshape.coord.curved(k)
		      end if
		      pt1 = pt2
		    else
		      pt1 = currentshape.NextBorderPoint(pt1, pt2)
		      k = currentshape.GetIndexPoint(pt1)
		      P = new Point(Objects,pt1.bpt)
		      if not s.std then                                                           //on ne relie pas les morceaux des formes standard à leur mère
		        P.SetConstructedBy pt1,5                                     // donc on pourra supprimer la mère standard sans tuer les enfants
		      end if
		      s.InsertPoint(s.npts, P)
		      centres.append currentshape.coord.centres(k)
		      curved.append currentshape.coord.curved(k)
		    end if
		  wend
		  
		  s.narcs = 0
		  for i = 0 to ubound(curved)
		    s.narcs = s.narcs + curved(i)
		  next
		  
		  s.autos
		  Tr = CutPts(ncutpt-1).bpt-CutPts(0).bpt
		  Tr = Tr.VecNorPerp
		  M = new Translationmatrix(Tr*0.2*currentshape.ori*((-1)^n))
		  if not s.std  then
		    setconstructioninfo(s, n, M)
		  end if
		  s.Ori = currentshape.Ori                //Les deux pièces sont orientées comme la forme mère
		  s.fixecouleurfond(currentshape.fillcolor,currentshape.fill)
		  s.fam = 7
		  s.forme = s.npts-2
		  s.initconstruction
		  recopiercouleurs (s)
		  if s.Hybrid  then
		    s.coord.centres = centres
		    s.coord.curved = curved
		  end if
		  if s.std then
		    s.fam = 14
		    standardpolygon(s).myspecs = polygon(s).createspecs
		    standardpolygon(s).angles = standardpolygon(s).myspecs.angles
		    standardpolygon(s).distances = standardpolygon(s).myspecs.angles
		  end if
		  Lacet(s).prepareskull(s.points(0).bpt)
		  if s.hybrid then
		    Lacet(s).coord.CreateExtreAndCtrlPoints(s.ori)
		    s.coord.MoveExtreCtrl(M)
		  end if
		  s.Move(M)
		  s.endconstruction
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  return Dico.Value("Decouper")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As Shape
		  dim S As Shape
		  dim i,n as integer
		  dim Pt, P1 as Point
		  dim ff as figure
		  
		  
		  if CurrentItemToSet = 1 then
		    S = Operation.GetShape(p)
		    if ( not (S isa Polygon or s isa circle)  or (s isa cube) or (s isa arc)  or s.isaellipse or S isa Bande ) then
		      S = nil
		    end if
		    return s
		  else
		    visible = objects.findpoint(p)
		    if visible.count > 0 then
		      for i =visible.count-1 downto 0
		        pt = point(visible.item(i))
		        if not choixvalide(pt) then
		          visible.objects.remove i
		        end if
		      next
		    end if
		    if visible.count > 0 then
		      nobj = visible.count
		      return visible.item(iobj)
		    else
		      return nil
		    end if
		  end if
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as Graphics)
		  dim trait As CurveShape
		  super.paint(g)
		  dim a,b as BasicPoint
		  dim i as integer
		  dim oldCol as Color
		  
		  g.Bold=True
		  
		  select case CurrentItemToSet
		  case 1
		    Help g, choose + aform + tocut
		  case 2
		    Help g, choose + thefirstcutpoint
		  else
		    oldCol = g.ForeColor
		    g.ForeColor =  Config.Weightlesscolor.col
		    for i=1 to ncutpt-1
		      a = can.transform(CutPts(i-1).bpt)
		      b = can.transform(CutPts(i).bpt)
		      g.DrawLine(a.x,a.y,b.x,b.y)
		    next
		    g.ForeColor = oldCol
		    
		    if CurrentHighlightedShape=nil then
		      Help g, choose + anothercutpoint
		    elseif currenthighlightedshape isa point then
		      g.ForeColor =  Config.Weightlesscolor.col
		      a = can.transform(CutPts(ncutpt-1).bpt)
		      b = can.transform(Point(CurrentHighlightedShape).bpt)
		      g.DrawLine(a.x,a.y,b.x,b.y)
		      g.ForeColor = oldCol
		    end if
		  end select
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub recopiercouleurs(s as shape)
		  dim p1, p2, q1, q2 as point
		  dim  i, cote as integer
		  
		  if not s.std then
		    for i= 0 to s.npts-1
		      if currentshape isa circle then
		        s.colcotes(i) = currentshape.bordercolor
		      else
		        p1 = s.points(i)
		        p2 = s.points((i+1) mod s.npts)
		        q1 = point(p1.constructedby.shape)
		        q2 = point(p2.constructedby.shape)
		        cote = CurrentShape.GetCoteOfPts(q1,q2)
		        if (cote<>-1) then
		          s.colcotes(i) = currentshape.colcotes(cote)
		        else
		          s.colcotes(i) = config.bordercolor
		        end if
		      end if
		    next
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  
		  ReCreateCreatedFigures(Temp)
		  wnd.refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetConstructionInfo(s as shape, n as integer, M as Matrix)
		  dim i as integer
		  
		  s.SetConstructedBy currentshape,5
		  s.ConstructedBy.Data.Append M
		  if n = 0 then
		    for i = 0 to ncutpt-1
		      s.Points(i).SetConstructedBy CutPts(i),5
		    next
		  else
		    for i = 0 to ncutpt-1
		      s.Points(i).SetConstructedBy CutPts(ncutpt-1-i),5
		    next
		  end if
		  for i = 0 to s.npts-1
		    s.Points(i).constructedby.data.append M
		    s.points(i).updateguides
		    s.Points(i).Mobility
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(S as Shape) As Boolean
		  dim i as integer        'On fait la liste des points de découpe
		  dim Pt, P1 as Point
		  dim ff as figure
		  
		  If s = nil then
		    return false
		  end if
		  
		  select case CurrentItemToSet
		  case 1
		    currentshape = S
		    if currentshape.std then
		      currentshape.show
		    end if
		    currentshape.movetofront
		  else
		    Pt = Point(S)
		    If ValidPointOnSide(Pt) then
		      P1 = Pt
		    elseif not currentshape.std and currentshape.PointOnSide(Pt.bpt) <> -1  then
		      P1 = new Point(Objects, Pt.bpt)
		      P1.PutOn currentshape
		      P1.placerptsursurfigure
		    elseif currentshape.pInShape(Pt.bpt) then
		      P1 = Pt
		    else
		      return false
		    end if
		    CutPts.Append(P1)
		    ncutpt = ncutpt+1
		  end select
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument) As XMLElement
		  dim EL1 as XMLElement
		  
		  EL1 =  Doc.CreateElement(Dico.Value("Forms"))
		  EL1.SetAttribute("NCutPoints", str(ncutpt))
		  EL1.AppendChild Cut(0).XMLPutIdInContainer(Doc)
		  EL1.AppendChild Cut(1).XMLPutIdInContainer(Doc)
		  EL1.appendchild currentshape.XMLPutIdInContainer(Doc)
		  return EL1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  dim EL0, EL1 as XMLElement
		  
		  EL0 = Doc.CreateElement(Dico.value("OperaCut"))
		  EL0.appendchild currentshape.XMLPutIdInContainer(Doc)
		  EL1 =  Doc.CreateElement(Dico.Value("Forms"))
		  EL1.SetAttribute("NCutPoints", str(ncutpt))
		  EL1.AppendChild Cut(0).XMLPutInContainer(Doc)
		  EL1.AppendChild Cut(1).XMLPutInContainer(Doc)
		  EL0.appendchild EL1
		  return EL0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim EL, EL1 as XMLElement
		  
		  EL = XMLElement(Temp.child(0))
		  EL1 = XMLElement(EL.Child(1))
		  
		  Cut(0) = Objects.Getshape(val(XMLElement(EL1.child(0)).GetAttribute("Id")))
		  Cut(1) = Objects.Getshape(val(XMLElement(EL1.child(1)).GetAttribute("Id")))
		  Cut(0).delete
		  Cut(1).delete
		  ReDeleteCreatedFigures (Temp)
		  wnd.refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValidPointOnSide(pt as point) As Boolean
		  If( (Pt.IsChildOf(currentshape) or ((currentshape.PointOnside(Pt.bpt)<> -1) and (Pt.ConstructedBy <> nil) and _
		    (Pt.constructedby.Shape = currentshape) and  (Pt.constructedby.oper = 4))) or Pt.duplicateorcut )and Pt.bpt <> currentshape.GetGravitycenter then
		    return true
		  else
		    return false
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


	#tag Property, Flags = &h0
		Cut(1) As Shape
	#tag EndProperty

	#tag Property, Flags = &h0
		CutPts(-1) As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		ncutpt As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="canceling"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsep"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentItemToSet"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
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
			Name="ncutpt"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="side"
			Group="Behavior"
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
