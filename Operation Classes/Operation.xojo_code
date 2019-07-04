#tag Class
Protected Class Operation
	#tag Method, Flags = &h0
		Sub AddOperationToMac(OpList as XMLDocument, EL1 as XMLElement)
		  dim EL as XMLElement
		  dim str as string
		  
		  if (self isa shapeconstruction) and (currentshape isa point)  then
		    select case point(currentshape).pointsur.count
		    case 0
		      OpId = 0
		      str = GetName
		    case 1
		      OpId = 46
		      str = "PointSur"
		    end select
		  else
		    str = GetName
		  end if
		  if (not self isa shapeconstruction) or (not currentshape isa repere) then
		    El=Oplist.CreateElement(Dico.Value("Operation"))
		    El.SetAttribute(Dico.Value("Numero"),str(Currentcontent.TotalOperation))
		    El.SetAttribute(Dico.Value("Type"), str)
		    EL.SetAttribute("OpId", str(opId))
		    EL1.AppendChild ToMac(OpList,EL)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Annuler()
		  FormsWindow.close
		  If finished = True Then
		    CurrentContent.UndoLastOperation
		  end if
		  can.refreshBackground
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  WorkWindow.drapshowall = False
		  Objects = CurrentContent.theobjects
		  oldp = new BasicPoint(0,0)
		  CurrentContent.TheTransfos.DrapShowAll = false //On cache les tsf hidden2
		  CurrentContent.TheTransfos.ShowAll                     //On montre les autres
		  CurrentContent.TheTransfos.Unhighlightall
		  CurrentContent.curoper = nil
		  CurrentContent.CreateFigs
		  if not self isa SaveBitMap then
		    can.clearoffscreen
		  end if
		  finished = true
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  display = ""
		  if oldvisible <> nil then
		    oldvisible.tspfalse
		  end if
		  CurrentContent.CreateFigs
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBiPoint(p as BasicPoint) As Shape
		  dim s as shape
		  dim i,ind as integer
		  
		  redim index(-1)
		  if self isa prolonger then
		    visible = Objects.findbipoint(p)
		  else
		    Visible = Objects.findobject(p)
		  end if
		  
		  for i = visible.count-1  downto 0
		    s = Visible.item(i)
		    if S isa Lacet or s isa droite then 'isa Bande or S isa Lacet or S isa secteur or s isa droite then
		      ind = s.pointonside(p)
		      if ind = -1 or (s isa lacet and s.coord.curved(ind) = 1) then
		        Visible.removeobject(s)
		      else
		        index.insert 0, ind
		      end if
		    elseif not (s isa droite) then
		      Visible.removeobject(s)
		    end if
		  next
		  
		  nobj = visible.count
		  if visible.count > 0 then
		    return Visible.item(iobj)
		  else
		    return nil
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  Return "Operation"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As Shape
		  dim i as integer
		  
		  redim index(-1)
		  
		  if oldvisible <> nil then
		    oldvisible.tspfalse
		  end if
		  
		  visible = Objects.findobject(p)
		  if visible.count <> nobj then
		    oldvisible = new objectslist
		    for i = 0 to visible.count-1
		      oldvisible.addshape visible.item(i)
		    next
		    iobj = 0
		  end if
		  
		  nobj = visible.count
		  if nobj = 0 then
		    objects.tspfalse
		    return nil
		  else
		    for i=0 to nobj-1
		      visible.item(i).tsp = true
		      visible.item(i).side = visible.item(i).pointonside(p)
		    next
		    return Visible.item(iobj)
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Help(g as graphics, s1 as string)
		  'todo : à placer dans canvas ?
		  if Config.ShowHelp and not canceling then
		    g.forecolor = Config.bordercolor.col
		    g.DrawString  lowercase(s1+info) ,Mcanx+8,Mcany+3
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Magnetisme(byref magneticD as BasicPoint, cfig as figure) As integer
		  dim AttractedShape , AttractingShape, NextAttractingShape as Shape
		  dim magnetism, gridmagnetism as integer
		  dim attractedpoint as point
		  dim gridd, d as BasicPoint
		  
		  if Cfig = nil then
		    return 0
		  end if
		  
		  magnetism=Cfig.Magnetisme(d,AttractedShape,AttractingShape, NextAttractingShape)
		  
		  
		  CurrentAttractingShape=AttractingShape
		  NextCurrentAttractingShape = NextAttractingShape
		  CurrentAttractedShape=AttractedShape
		  if magnetism > 0 then
		    magneticD = d -Point(AttractedShape).bpt
		  end if
		  
		  if CurrentContent.TheGrid<>nil then
		    GridMagnetism=Cfig.GridMagnetism(gridd,AttractedPoint)
		    
		    if GridMagnetism>magnetism then
		      magnetism=GridMagnetism
		      magneticD=gridd - AttractedPoint.bpt
		      CurrentAttractedShape=AttractedPoint
		      Currentattractingshape = can.rep
		    end if
		  end if
		  return magnetism
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Magnetisme(sh as shape, byref magneticD as BasicPoint) As integer
		  // Utilisé pour déterminer le magnétisme lors d'une modification ou de la duplication d'un point
		  // ou encore lors d'une construction. Attractedshape (c-a-d currentpoint) est nécessairement le point sur lequel on tire
		  
		  dim  AttractingShape, NextAttractingShape as Shape
		  dim magnetism, gridmagnetism as integer
		  dim attractedpoint, currentpoint as point
		  dim gridd, d as BasicPoint
		  
		  if sh = nil then
		    return 0
		  end if
		  
		  if not sh isa point then
		    currentpoint = sh.Points(sh.IndexConstructedPoint)
		  else
		    currentpoint = point(sh)
		  end if
		  
		  
		  ReinitAttraction
		  magnetism=Currentpoint.Magnetisme(d,AttractingShape, NextAttractingShape)
		  
		  if attractingshape <>nil and  attractingshape.fam > 9 then
		    attractingshape = nil
		    magnetism = 0
		    d = new basicpoint(0,0)
		  end if
		  
		  CurrentAttractingShape=AttractingShape
		  NextCurrentAttractingShape = NextAttractingShape
		  magneticD = d
		  
		  if magnetism = 0 and CurrentContent.TheGrid <> nil then
		    GridMagnetism=currentpoint.GridMagnetism(gridd)
		    if GridMagnetism>magnetism then
		      magnetism=GridMagnetism
		      magneticD= gridd    'currentpoint.bpt+gridd
		      currentattractingshape = can.rep
		    end if
		  end if
		  
		  if magnetism > 0 then
		    ShowAttraction
		  else
		    magneticD = nil
		  end if
		  return magnetism
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Mcanx() As integer
		  return can.MouseCan.x
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Mcany() As integer
		  return can.MouseCan.y-10.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  Objects.UnselectAll
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDrag(p as BasicPoint)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(p as BasicPoint)
		  if not self isa decouper then
		    currentshape = nil
		  end if
		  
		  if not (self isa readhisto) then
		    if oldp <> nil and p.distance(oldp) > can.magneticdist  then
		      oldp = p
		      objects.unhighlightall
		      CurrentHighlightedShape = GetShape(p)
		      if CurrentHighlightedShape<>nil   then
		        CurrentHighlightedShape.HighLight
		        side = currenthighlightedshape.pointonside(p)
		      end if
		      
		    end if
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseUp(p as basicPoint)
		  ReinitAttraction
		  CurrentAttractedShape=nil
		  CurrentAttractingShape=nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseWheel()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Muser() As BasicPoint
		  return can.MouseUser
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Muserx() As double
		  return can.MouseUser.x
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Musery() As double
		  return can.MouseUser.y
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OperationFinished() As Boolean
		  return finished
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  if CurrentHighlightedShape= nil then
		    info = ""
		    return
		  end if
		  
		  if nobj > 1 then
		    info = " (" + str(nobj) + "," + str(iobj+1) + ")"
		  else
		    info = ""
		  end if
		  
		  #if DebugBuild then
		    if CurrentHighlightedShape <> nil then
		      info = info + " ("+str(CurrentHighlightedShape.id)+")"
		    end if
		  #endif
		  
		  'if WorkWindow.drappt then
		  'info = info + " (" + left(str(can.Mouseuser.x),5)+", "+ left(str(can.Mouseuser.y),5) +")"
		  'end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReCreateCreatedFigures(liste as ObjectsList, Temp as XMLElement)
		  RecreateFigures(1, liste, Temp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReCreateCreatedFigures(Temp as XMLElement)
		  RecreateFigures(1,Temp)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReCreateDeletedFigures(Temp as XMLElement)
		  RecreateFigures(0,Temp)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RecreateFigures(k as integer, liste as objectslist, Temp as XMLElement)
		  dim  j as integer
		  dim List as XMLNodeList
		  dim EL, EL1 as XMLElement
		  
		  if k = 0 then
		    List = Temp.XQL("Deleted_Figures")
		  else
		    List = Temp.XQL("Created_Figures")
		  end if
		  if List.length > 0 then
		    EL = XMLElement(List.Item(0))
		    EL = XMLElement(EL.firstchild)
		    liste.XMLLireIdFigs(EL)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RecreateFigures(k as integer, Temp as XMLElement)
		  dim  j as integer
		  dim List as XMLNodeList
		  dim EL, EL1 as XMLElement
		  
		  if k = 0 then
		    List = Temp.XQL("Deleted_Figures")
		  else
		    List = Temp.XQL("Created_Figures")
		  end if
		  if List.length > 0 then
		    EL = XMLElement(List.Item(0))
		    if EL.Firstchild.Name = "Creation" or EL.FirstChild.Name  = "Deletion" then
		      EL = XMLElement(EL.firstchild)
		    end if
		    objects.XMLLoadobjects(EL)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReDeleteCreatedFigures(Temp as XMLElement)
		  RedeleteFigures(1,temp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReDeleteDeletedFigures(Temp as XMLElement)
		  
		  RedeleteFigures(0,Temp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedeleteFigures(k as integer, Temp as XMLElement)
		  dim i, n as integer
		  dim List as XMLNodeList
		  dim EL, EL1 as XMLElement
		  dim ff as figure
		  
		  
		  if k = 0 then
		    List = Temp.XQL("Deleted_Figures")
		  else
		    List = Temp.XQL("Created_Figures")
		  end if
		  
		  if List.length > 0 then
		    EL = XMLElement(List.item(0))
		    EL = XMLElement(EL.firstchild)
		    For i = 0 to EL.childcount-1
		      EL1 = XMLElement(EL.child(i))
		      n = val(EL1.GetAttribute("FigId"))
		      ff = CurrentContent.TheFigs.GetFigure(n)
		      if ff <> nil then
		        CurrentContent.TheFigs.Removefigure ff
		      end if
		    next
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReinitAttraction()
		  
		  'currentcontent.TheObjects.UnHighlightall
		  
		  if CurrentAttractedShape<>nil then
		    CurrentAttractedShape.UnHighLight
		    CurrentAttractedShape=nil
		  end if
		  
		  if CurrentAttractingShape<>nil then
		    CurrentAttractingShape.UnHighLight
		    CurrentAttractingShape=nil
		  end if
		  
		  if NextCurrentAttractingShape<>nil then
		    NextCurrentAttractingShape.UnHighLight
		    NextCurrentAttractingShape=nil
		  end if
		  
		  if CurrentHighlightedShape <> nil then
		    CurrentHighlightedShape.UnHighLight
		    CurrentHighlightedShape=nil
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetVisible()
		  Visible.removeAll
		  nobj = Visible.count
		  redim index(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReverseGetShape(p as BasicPoint) As shape
		  return Objects.reversefindobject(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectForm(Temp as XMLElement) As Shape
		  dim List as XMLNodeList
		  dim EL, EL1, EL2 as XMLElement
		  dim i, n as integer
		  
		  
		  List = Temp.XQL(Dico.value("Form"))
		  if list.length > 0 then
		    EL = XMLElement(List.Item(0))
		    n = val(EL.GetAttribute("Id"))
		    return Objects.Getshape(n)
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectTsf(Temp as XMLElement) As Transformation
		  dim List as XMLNodeList
		  dim EL, EL1, EL2 as XMLElement
		  dim i, n, orien, ty, ind as integer
		  dim s as shape
		  dim t as Boolean
		  
		  
		  List = Temp.XQL(Dico.value("Transformation"))
		  if list.length > 0 then
		    EL = XMLElement(List.Item(0))
		    EL1 = XMLElement(EL.FirstChild)
		    n = val(EL1.GetAttribute("Id"))
		    s = Objects.Getshape(n)
		    ty = val(EL.GetAttribute("TsfType"))
		    orien =  val(EL.GetAttribute("Ori"))
		    if s isa Lacet then 'polygon or s isa bande or s isa secteur then
		      ind = val(EL.GetAttribute("Index"))
		    end if
		    for i = 0 to s.tsfi.count-1
		      t = true
		      t = t and ty = s.tsfi.item(i).type
		      t = t and  orien = s.tsfi.item(i).ori
		      if s isa Lacet then 'polygon or s isa bande or s isa secteur then
		        t = t and ind = s.tsfi.item(i).index
		      end if
		      if t then
		        return s.tsfi.item(i)
		      end if
		    next
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowAttraction()
		  
		  dim icot as integer
		  
		  if CurrentAttractedShape<>nil then
		    CurrentAttractedShape.HighLight
		  end if
		  
		  if CurrentAttractingShape<>nil then
		    if currentcontent.currentoperation isa duplicate and   duplicate(currentcontent.currentoperation).copyptsur and currentattractingshape isa polygon  then
		      icot = currentattractingshape.pointonside(point(duplicate(currentcontent.currentoperation).copies.item(0)).bpt)
		      if icot <> -1 then
		        Lacet(currentattractingshape).Paintside(can.BackgroundPicture.graphics,icot,2,Config.highlightcolor)
		      end if
		    else
		      CurrentAttractingShape.HighLight
		    end if
		  end if
		  
		  if CurrentAttractingShape isa point or NextCurrentAttractingShape isa point then
		    NextCurrentAttractingShape = nil
		  end if
		  if NextCurrentAttractingShape<>nil   then
		    NextCurrentAttractingShape.HighLight
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument, EL as XMLElement) As XMLElement
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  
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

	#tag Note, Name = Mcan
		Mcanx et Mcany sont utilisées pour afficher des "help" à l'écran
	#tag EndNote

	#tag Note, Name = Numeros des operations
		
		
		
		
		Variable: OpId (Id d'opération)
		Chaque classe d'opérations a un code.
		
		
		1) Operations
		Ouvrir un fichier : -1
		ShapeConstruction: 0  
		ParaperpConstruction: 1 ou 2
		SaveBitmap:  Pour mémoire
		Selectionner: 4 
		CreateGrid : 29 
		ReadHisto : 34 Pour mémoire
		
		Annuler : 31
		Refaire : 32 
		
		2) SelectOperation
		Lier: 3  
		Delier: 10 
		Copier: 5  
		Coller:6 
		Delete: 7
		SaveEPS: 8   Pour mémoire
		Print : 9        Pour mémoire
		ChangePosition: 11 
		ColorChange: 12 
		Epaisseur: 13  
		GCConstruction: 14 
		Hide: 15 
		Retourner: 16 
		TransparencyChange: 18 
		Prolonger: 28
		Rigidifier: 30  
		AddLabel : 33  
		Identifier: 35
		Tracer : 36
		FixPConstruction 37
		Pointer: 38
		Flecher: 39
		Conditionner: 40
		Unit : 41
		HideTsf: 44
		Inter : 45                  //N'est utilisé que pour les macros et les autointer: on assimile l'intersection de deux objets à une opération
		PointSur: 46            // Idem pour la construction d'un Point Sur
		SaveStd : 47 Pour mémoire
		Decomposer: 48
		
		3) SelectandDragOperation
		Duplicate: 19 
		Glisser: 20  
		Modifier: 21
		Redimensionner: 22  
		Tourner: 23 
		
		4) MultipleSelectOperation
		TransfoConstruction: 17
		AppliquerTsf: 24  
		TrajectoireTsf: 48
		Decouper: 25  
		Divide: 26   
		Fusion: 27
		ChooseFinal : 42
		MacroExe : 43
		
	#tag EndNote


	#tag Property, Flags = &h0
		canceling As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		colsep As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentAttractedShape As Shape
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentAttractingShape As Shape
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentHighlightedShape As Shape
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentHighlightedTsf As Transformation
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentShape As Shape
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentTsf As Transformation
	#tag EndProperty

	#tag Property, Flags = &h0
		display As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Finished As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		HistId As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		index() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		info As string
	#tag EndProperty

	#tag Property, Flags = &h0
		iobj As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		itsf As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ListTsf As TransfosList
	#tag EndProperty

	#tag Property, Flags = &h0
		NextCurrentAttractingShape As Shape
	#tag EndProperty

	#tag Property, Flags = &h0
		nobj As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ntsf As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Objects As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		oldp As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		Oldvisible As objectslist
	#tag EndProperty

	#tag Property, Flags = &h0
		OpId As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		selshape As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		side As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Visible As ObjectsList
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
