#tag Class
Protected Class SelectOperation
Inherits Operation
	#tag Method, Flags = &h0
		Function CancelAttraction(p as point) As Boolean
		  dim i, j as integer
		  dim f1, f2 as figure
		  
		  if p <> nil and currentattractingshape <> nil and (not currentattractingshape isa repere or p.allparentsqcq)  then
		    f2 = currentattractingshape.fig
		    f1 = p.fig
		    i = figs.getposition(f1)
		    j = figs.GetPosition(f2)
		    if i <> j and i <> -1 and j <> -1 and figs.Mat.col(i,j) = 1 then
		      currentattractingshape.unhighlight
		      currentattractingshape = nil
		      return true
		    end if
		  end if
		  
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Choixvalide(s as shape) As Boolean
		  dim tsf as transformation
		  dim i, j, h, k as integer
		  dim ob as objectslist
		  dim ff, sf, fig1, figsource as figure
		  dim s1 as shape
		  dim ffl as figslist
		  
		  // Déterminer les choix valides pour les "mouvements" glisser, tourner, retourner, redimensionner
		  // Pour éviter des problèmes avec les figures images par des transfos (on verra plus tard si on peut assouplir) :
		  
		  'On ne peut pas déplacer une forme construite par une macro sauf si les objets initiaux sont dans la même figure
		  
		  // On invalide ensuite les formes appartenant à une figure qui contient une image sans contenir la source et le support de la transformation
		  // idem si une des formes liées à s est dans le même cas
		  // Il y a des exceptions
		  
		  if s = nil or not s.fig.PossibleDrag(self) or  s.macconstructedby <> nil then
		    return false
		  end if
		  
		  ffl = new figslist
		  ffl.addobject s.fig
		  
		  
		  if s.IDGroupe <> -1 then
		    ob = objects.groupes(s.idgroupe)
		    for i = 0 to Ob.count-1
		      if not ob.item(i).fig.PossibleDrag(self) then
		        return false
		      else
		        ffl.addobject ob.item(i).fig
		      end if
		    next
		  end if
		  
		  // Ensuite  on doit appliquer le même principe aux figures images de s.fig
		  
		  
		  for  i = 0 to s.fig.constructedfigs.count-1
		    ff = s.fig.constructedfigs.item(i)
		    if ff <> s.fig then           //toutes les figures images de s.fig sauf  s.fig elle-même (pour le cas où...)
		      for j = 0 to ubound(ff.Constructioninfos)
		        tsf = ff.Constructioninfos(j).tsf
		        figsource = ff.constructioninfos(j).sourcefig
		        if (tsf.supp.fig = ff) or  ((figsource <> s.fig) and (figsource <> ff))     then
		          return false
		        end if
		      next
		    end if
		  next
		  
		  // et aux figures images par une tsf de support dans s.fig
		  
		  for i = 0 to s.fig.shapes.count-1
		    s1 = s.fig.shapes.item(i)   //toutes les formes de la même figure que s
		    for j = 0 to s1.tsfi.count-1
		      tsf = s1.tsfi.item(j)                           //tous les supports de tsf situés dans la même figure que s
		      for h = 0 to tsf.constructedfigs.count-1
		        fig1 = tsf.constructedfigs.item(h)   //on teste toutes les figures images de ces tsfi
		        ffl = tsf.getfigsources(fig1)                     //toutes les sources de ces tsf
		        for k = 0 to ffl.count-1
		          if (ffl.item(k) = fig1) and (s.fig <> fig1) and not (tsf.type = 1 and self isa glisser) and  not (tsf.type = 2 and self isa tourner and tourner(self).c = tsf.supp.points(0).bpt) then
		            return false  // false si une figure différente de s.fig contient la source et l'image d'une transfo de support dans s.fig
		          end if
		        next
		      next
		    next
		  next
		  
		  return true
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMethod(getString,"Choixvalide")
		    d.setVariable("s",s)
		    err.message = err.message+d.getString
		    
		    Raise err
		    
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  super.Constructor
		  tempshape = Objects.selection
		  Figs = new FigsList
		  figsimges = new figslist
		  Objects.ReattractingAll
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMethod(getString,getString)
		    err.message = err.message+d.getString
		    
		    Raise err
		    
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Copyfigs() As figslist
		  dim flist As Figslist
		  dim i as integer
		  
		  Flist = new Figslist
		  
		  
		  for i = 0 to figs.count-1
		    Flist.addobject figs.item(i)
		  next
		  
		  return flist
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CopyTempShape() As Objectslist
		  dim oblist As Objectslist
		  dim i as integer
		  
		  Oblist = new Objectslist
		  
		  
		  for i = 0 to tempshape.count-1
		    Oblist.addshape tempshape.item(i)
		  next
		  
		  return Oblist
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOper(p as basicPoint)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOper(n as integer)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  dim i as integer
		  
		  ReinitAttraction
		  Objects.ReAttractingAll
		  objects.unhighlightall
		  
		  if not self isa saveeps and not self isa  savestd then
		    if CurrentContent.ForHisto and  CurrentContent.currentoperation <> nil  then
		      CurrentContent.AddOperation(self)  // Ne faut-il pas tester si l'opération est finie?
		    end if
		    CurrentContent.CurrentFileUpToDate=false
		    WorkWindow.refreshtitle
		  end if
		  
		  if WorkWindow.drapresel and not self isa delete and not self isa colorchange then
		    Objects.Oldselection = copytempshape
		    if not self isa appliquertsf  then
		      Objects.Reselect
		    else
		      objects.unselectall
		      for i = 0  to appliquertsf(self).copies.count-1
		        objects.selectobject(appliquertsf(self).copies.item(i))
		      next
		    end if
		  else
		    Objects.Unselectall
		  end if
		  currentshape = nil
		  can.RefreshBackground
		  super.EndOperation  // Recréation des figures
		  Figs = new FigsList
		  Finished = true   //Ceci ne devrait-il pas être la dernière instruction du "DoOperation"?
		  can.mousecursor = System.Cursors.StandardPointer
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormeAbsente(sid as integer, EL as XMLElement) As boolean
		  dim t as Boolean
		  dim j as integer
		  
		  t = true
		  if EL <> nil then
		    for j = 0 to EL.childcount-1
		      t = t and (sid <> val(XMLElement(EL.child(j)).GetAttribute("Id")))
		    next
		  end if
		  
		  Return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return "SelectOperation"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As String
		  return GetName
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HelpTsf(g as graphics)
		  dim str as string
		  
		  ntsf = ListTsf.count
		  if ntsf > 1 then
		    info = " (" + str(ntsf) + "," + str(itsf+1) + ")"
		  else
		    info = ""
		  end if
		  
		  if  ntsf = 0 then
		    Help g,  choose + atransformation
		  elseif currenthighlightedtsf <> nil then
		    select case currenthighlightedtsf.type
		    case 1
		      str = thistranslation
		    case 2
		      str = thisrotation
		    case 3
		      str = thishalfturn
		    case 4
		      str = thisquarterleft
		    case 5
		      str = thisquarterright
		    case 6
		      str = thissymmetry
		    case 7, 71, 72
		      str = thishomothety
		    case 8, 81, 82
		      str = thissimilarity
		    case 9
		      str = thisstretch
		    case 10
		      str = thisdisplacement
		    case 11
		      str = "ce cisaillement"
		    end select
		    str = str + " ?"
		    Help g, str
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Highlight(s as shape)
		  s.highlight
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IdentifyPointsinCopies(byref s as shape, i0 as integer)
		  dim i,j,k,m, n as integer   'Identification des sommets communs
		  dim s1, s2, sh, ss as shape
		  dim p as point
		  // s est l'élément i0 de copies
		  
		  if tempshape.count = 1 then
		    return
		  end if
		  
		  sh = tempshape.item(i0)
		  if  sh isa point then
		    return
		  end if
		  for i = 0 to sh.npts-1
		    p = sh.points(i)
		    j = 0
		    while (j < i0)and p.parents.indexof(tempshape.item(j)) = -1
		      j = j+1
		    wend
		    if j < i0 then
		      k = tempshape.item(j).getindexpoint(p)
		      if k <> -1 then
		        s2 = copies.item(j)
		        s.SubstitutePoint(s2.points(k), s.points(i))
		      end if
		    end if
		  next
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ImmediateDoOperation()
		  if tempshape.count > 0 then
		    can.Mousecursor = System.Cursors.Wait
		    DoOperation
		    endoperation
		    if currentcontent.currentoperation isa Copier then
		      currentcontent.currentoperation = nil
		    end if
		    WorkWindow.refreshtitle
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LierGroupes()
		  //Utilisé par dupliquer, coller et appliquertsf
		  
		  dim i, j, numlist as integer
		  
		  for i = 0 to tempshape.count-1
		    if  tempshape.item(i).IdGroupe <> -1 then
		      if copies.item(i).Idgroupe = -1 then
		        Objects.Groupes.append new ObjectsList
		        Numlist = Ubound(Objects.Groupes)
		        for j = 0 to copies.count-1
		          if tempshape.item(j).IdGroupe = tempshape.item(i).Idgroupe then
		            copies.item(j).IDGroupe = Numlist
		            Objects.Groupes(Numlist).addShape copies.item(j)
		          end if
		        next
		      end if
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  If currenthighlightedshape = Nil Then
		    Objects.unselectall
		    return
		  end if
		  
		  selection
		  
		  Finished = false
		  can.Mousecursor = System.Cursors.Wait
		  
		  WorkWindow.refreshtitle
		  DoOperation
		  if dret = nil  then
		    endoperation
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMoveTsf(p as BasicPoint)
		  ListTsf = new TransfosList
		  
		  if not (self isa readhisto) then
		    itsf = 0
		    if currenthighlightedtsf <> nil then
		      CurrenthighlightedTsf.unhighlight
		      currenthighlightedtsf = nil
		      currenthighlightedshape = nil
		    end if
		    CurrentContent.TheTransfos.GetTsf(p, ListTsf)
		    if ListTsf.count  > 0 then
		      CurrentHighlightedTsf = ListTsf.item(itsf)
		      currenthighlightedTsf.highlight
		      currenthighlightedshape = currenthighlightedtsf.supp
		      ntsf = ListTsf.count
		    end if
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseWheel()
		  
		  if visible <> nil and visible.count <> 0 then
		    nobj = visible.count
		    iobj = (iobj+1) mod nobj
		    if CurrentHighlightedShape<>nil then
		      CurrentHighlightedShape.UnHighLight
		    end if
		    CurrentHighlightedShape = visible.item(iobj)
		    CurrentHighlightedShape.HighLight
		    currentshape = currenthighlightedshape
		    can.refreshBackground
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseWheelTsf()
		  if ListTsf.count > 0 then
		    ListTsf.item(itsf).Highlighted = false
		    itsf = (itsf+1) mod ntsf
		    ListTsf.item(itsf).Highlighted = true
		    currenthighlightedtsf = ListTsf.item(itsf)
		    can.refreshbackground
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics)
		  
		  super.paint(g)
		  
		  if currenthighlightedshape = nil then
		    return
		  end if
		  
		  if  currenthighlightedshape isa Lacet and not currenthighlightedshape isa cube  and currentcontent.currentoperation.colsep   and side <> -1 then
		    Lacet(currenthighlightedshape).nsk.paintside(g, side, 1.5*Lacet(currenthighlightedshape).nsk.borderwidth, config.highlightcolor)  
		  else
		    CurrentHighlightedShape.HighLight
		    CurrentHighlightedShape.PaintAll(g)
		    CurrentHighlightedShape.UnHighLight
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  Temp = XMLElement(Temp.child(0))
		  SelectIdForms(Temp)
		  DoOperation
		  objects.unselectall
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub reputids(EL as XMLElement)
		  dim EL2, EL3 as XMLElement
		  dim i,j,n as integer
		  
		  for i = 0 to EL.childcount-1
		    EL2 = XMLElement(EL.child(i))
		    copies.item(i).id =  val(EL2.GetAttribute("Id"))
		    copies.item(i).plan = val(EL2.GetAttribute("Plan"))
		    currentcontent.plans(copies.item(i).plan) = copies.item(i).id     //Correction 3-09-2012
		    if tempshape.item(i).IdGroupe > -1 then
		      copies.item(i).IdGroupe = val(EL2.GetAttribute("IdGroupe"))
		    end if
		    if EL2.GetAttribute(Dico.value("Type")) <>  Dico.Value("Point") then
		      EL3 = XMLElement(EL2.child(0))
		      for j = 0 to copies.item(i).npts-1
		        copies.item(i).points(j).id = val(XMLElement(EL3.child(j)).GetAttribute("Id"))
		      next
		    end if
		  next
		  currentcontent.TheObjects.updateids
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SelectIdForms(Temp as XMLElement)
		  Dim List As XMLNodeList
		  dim EL, EL1 as XMLElement
		  Dim i, n As Integer
		  
		  objects.unselectall
		  List = Temp.XQL(Dico.value("Forms"))
		  If list.length > 0 Then
		    EL = XMLElement(List.Item(0))
		    For i = 0 To EL.childcount-1
		      EL1 = XMLElement(EL.child(i))
		      n = Val(EL1.GetAttribute("Id"))
		      If n <> 0 Then
		        tempshape.addshape Objects.Getshape(n)
		      Else
		        tempshape.addshape Objects.item(0)
		      End If
		    Next
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub selection()
		  dim i as integer
		  
		  if CurrentHighlightedshape <> nil  and currenthighlightedshape.selected = false then
		    Objects.Unselectall
		    Objects.selectobject(CurrentHighLightedshape)
		    CurrentHighlightedShape.tsp= false
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XmlDocument) As XMLElement
		  return ToXML(Doc)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc As XMLDocument) As XMLElement
		  dim Temp As  XMLElement
		  
		  Temp = Doc.CreateElement(GetName)
		  Temp.appendchild Tempshape.XMLPutIdInContainer(Doc)
		  return Temp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VectInter(n as integer) As BasicPoint
		  
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
		copies As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		Figs As FigsList
	#tag EndProperty

	#tag Property, Flags = &h0
		figsimges As figslist
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected init As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		tempshape As objectslist
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
