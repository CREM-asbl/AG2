#tag Class
Protected Class ShapeConstruction
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub AbortConstruction()
		  currentcontent.drapabort = True
		  if currentshape.isinconstruction and (currentshape.indexconstructedpoint = 0) then
		    currentshape.points(0).delete
		  end if
		  currentshape.delete
		  if currentshape.indexConstructedPoint >= 1 and  currentcontent.FigsDeleted.Childcount > 0 then
		    currentcontent.Theobjects.XMLLoadObjects(currentcontent.FigsDeleted)
		  end if
		  currentshape = nil
		  EndOperation
		  currentcontent.drapabort = false
		  can.refreshbackground
		  WorkWindow.refreshtitle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AdjustMagnetism(curshape as point)
		  Dim p As point
		  
		  
		  if CurrentAttractingShape <> nil then
		    CurrentContent.thefigs.removefigure CurrentAttractingShape.fig
		    if CurrentAttractingShape isa Point then
		      curShape.Identify1(Point(CurrentAttractingshape))
		    elseif currentattractingshape.fam < 10 and currentshape.fam < 10  then
		      if NextCurrentAttractingShape <> nil then
		        CurrentContent.thefigs.removefigure NextCurrentAttractingShape.fig
		        curShape.adjustinter(CurrentAttractingShape,NextCurrentAttractingShape)
		      else
		        curshape.puton currentattractingshape
		      end if
		      curshape.mobility
		    end if
		  End If
		  
		  'If Self IsA paraperpconstruction And currentattractingshape IsA lacet Then
		  'If curshape = currentshape.points(1) and curshape.forme = 1 Then
		  'Curshape.forme = 3
		  'End If
		  'End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Annuler()
		  if finished = false then
		    AbortConstruction
		  else 
		    currentcontent.UndoLastOperation
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CheckNoIntersec(p as point) As Boolean
		  dim Histo as XMLElement
		  dim i as integer
		  dim EL, EL1 as XMLElement
		  
		  Histo = currentcontent.Histo
		  
		  for i = 0 to Histo.ChildCount-1
		    EL = XMLElement(Histo.child(i))
		    EL1 = XMLElement(EL.Child(0))
		    if (val(EL.GetAttribute("OpId")) = 45 or val(EL.GetAttribute("OpId")) = 46 or val(EL.GetAttribute("OpId")) = 19 )and val(EL1.GetAttribute("Id")) = p.id then
		      return false
		    end if
		  next
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(fam as integer, form As integer)
		  super.constructor()
		  OpId = 0
		  Objects.unselectAll
		  Famille = Fam
		  Forme = form
		  CreateShape
		  
		  NumberOfItemsToSelect = currentshape.ncpts
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Mexe as MacroExe, EL0 as XMLElement, EL1 As XMLElement)
		  dim  fa, fo, rid, side, n, i , num as integer
		  dim pt as point
		  dim EL as XMLElement
		  dim sh as shape
		  dim loc as double
		  
		  fa = val(EL0.GetAttribute(Dico.Value("NrFam")))
		  fo = val(EL0.GetAttribute(Dico.Value("NrForm")))
		  
		  constructor(fa,fo)
		  
		  if fa = 0 then
		    
		    if fo = 1 then
		      pt = point(currentshape)
		      EL = XMLElement(EL1.Child(0))
		      n = val(EL.GetAttribute("Id"))
		      rid = MExe.GetRealId(n)
		      sh = objects.GetShape(rid)
		      sh.setpoint(pt)
		      pt.pointsur.addshape sh
		      pt.numside.append val(EL1.GetAttribute("NumSide0"))
		      pt.location.append val(EL1.GetAttribute("Location"))
		      pt.puton sh, pt.location(0)
		      pt.endconstruction
		    end if
		  else
		    EL = XMLElement(EL0.Child(0))
		    for i = 0 to CurrentShape.ncpts-1
		      n = val(XMLElement(EL.Child(i)).GetAttribute("Id"))
		      rid = MExe.GetRealId(n)
		      pt = point(objects.GetShape(rid))
		      currentshape.substitutepoint(pt,currentshape.points(i))
		    next
		    currentshape.constructshape
		    currentshape.endconstruction
		    currentshape.coord.Createextreandctrlpoints(currentshape.ori)
		  end if
		  
		  Exception err
		    var d as Debug
		    d =  new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("i", i)
		    d.setVariable("n", n)
		    err.message = err.message + d.getString
		    Raise err
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(s as shape)
		  
		  super.constructor()
		  OpId = 0
		  currentshape = s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateShape()
		  Dim p As BasicPoint
		  dim specs as StdPolygonSpecifications
		  dim fam as integer
		  
		  
		  if famille <> -1 then
		    p = can.MouseUser
		  end if
		  
		  if Famille <10 then
		    select case Famille
		    case -1
		      currentshape = new Repere(objects)
		    case 0
		      currentshape = new Point(objects, p)
		    case 1
		      select case forme
		      case -1, 0
		        currentshape = new Droite(objects, p,2)
		      case 3
		        currentshape = new Droite(objects,p,0)
		      case 6
		        currentshape = new Droite(objects,p,1)
		      case 7
		        currentshape = new Bande(objects,p)
		      case 8
		        currentshape = new Secteur(objects,p)
		      end select
		    case 2
		      select case forme
		      case 0
		        currentshape = new  Polyqcq(objects,3,p)
		      case 1
		        currentshape = new TriangIso(objects,p)
		      case 2
		        currentshape = new Polreg(objects,3,p)
		      case 3
		        currentshape = new TriangRect(objects,p)
		      case 4
		        CurrentShape = new TriangRectIso(objects,p)
		      end select
		    case 3
		      select case forme
		      case 0
		        currentshape = new Polyqcq(objects,4, p)
		      case 1
		        currentshape = new Trap(objects, p)
		      case 2
		        currentshape = new TrapRect(objects, p)
		      case 3
		        currentshape = new TrapIso(objects, p)
		      case 4
		        currentshape = new Parallelogram(objects, p)
		      case 5
		        currentshape = new Rect(objects,p)
		      case 6
		        currentshape = new Losange(objects, p)
		      case 7
		        currentshape = new Polreg(objects,4, p)
		      end select
		    case 4
		      currentshape = new Polreg(objects, forme+3, p)
		    case 5
		      select case forme
		      case 0
		        currentshape = new FreeCircle(objects, p)
		      case 1
		        currentshape = new Arc(objects,p)
		      case 2
		        currentshape = new DSect(objects,p)
		      case 3
		        currentshape = new HalfDsk(objects,p)
		      end select
		    case 6
		      currentshape = new Polyqcq(objects, forme+3, p)
		    end select
		  else
		    fam = famille-10
		    specs =  Config.StdFamilies(Fam,Forme)
		    if specs.family = "Cubes" or specs.family = "Rods" then
		      currentshape = new Cube(objects, p, forme)
		    elseif   ubound(specs.angles) > 0  then
		      currentShape=new StandardPolygon(objects, famille, forme, p)
		    else
		      currentshape = new StdCircle(objects,famille, forme, p)
		    end if
		  end if
		  currentshape.fam = famille
		  currentshape.forme = forme
		  Currentshape.InitConstruction
		  Currentshape.IndexConstructedpoint = 0
		  
		  Workwindow.setcross
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  'Le fixecoord se trouve dans MouseMove
		  currentshape.constructshape
		  currentshape.endconstruction  //insère la forme dans currentcontent.TheObjects et crée la figure
		  finished = true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  dim i as integer
		  dim pt as point
		  
		  if currentcontent.macrocreation then
		    if currentshape isa point and point(currentshape).Forme > 0 then
		      pt = point(currentshape)
		      PrepareXMLandMac(pt)  //se termine par un currentcontent.addoperation
		    else
		      for i = 0 to currentshape.ncpts-1
		        pt = currentshape.points(i)
		        PrepareXMLandMac(pt)
		      next
		      super.EndOperation
		    end if
		  else
		    super.EndOperation
		  end if
		  CreateShape  //On relance la construction suivante
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  if currentshape isa point and point(currentshape).forme = 1 then
		    return "Point Sur Objet"
		  else
		    return  Dico.Value("Construction")
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  if SetItem(Currentshape) then
		    Formswindow.close
		    finished = false
		    NextItem
		    if CurrentItemToSet > NumberOfItemsToSelect then
		      DoOperation
		      EndOperation
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(p as BasicPoint)
		  dim magneticD As BasicPoint
		  dim magnetism as Integer
		  
		  if currentShape = nil then
		    return
		  end  if
		  
		  ReinitAttraction
		  CurrentShape.Fixecoord(p, Currentshape.IndexConstructedPoint)
		  magnetism = Magnetisme(currentshape,magneticD)
		  if currentshape isa point and currentattractingshape isa point then
		    magnetism = 0
		    return
		  end if
		  if magnetism > 0 then
		    if currentshape isa point then
		      currentattractedshape = currentshape
		    else
		      currentattractedshape = currentshape.points(Currentshape.IndexConstructedPoint)
		    end if
		    ShowAttraction
		    if currentattractingshape isa repere or  currentattractingshape isa point or nextcurrentattractingshape = nil then
		      CurrentShape.Fixecoord(magneticD, Currentshape.IndexConstructedPoint)
		    elseif not(currentattractingshape isa point) and not(nextcurrentattractingshape isa point) then
		      TraitementIntersec()
		    end if
		    if not currentattractingshape isa point then
		      side = currentattractingshape.pointonside(p)
		    end if
		  end if
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g As Graphics)
		  dim curshape as point
		  dim inter as intersec
		  
		  if (currentshape isa point and currentattractingshape <> nil and currentattractingshape isa point)  then
		    return
		  end if
		  
		  display = ""
		  
		  
		  if currentshape <> nil and not currentshape isa repere then
		    if not currentshape isa point then
		      curshape = currentshape.points(currentshape.IndexConstructedPoint)
		    else
		      curshape = point(currentshape)
		    end if
		    if currentattractingshape <> nil  then
		      CurrentAttractingshape.highlight
		      currenthighlightedshape = currentattractingshape
		      side = currentattractingshape.pointonside(curshape.bpt)
		      super.paint(g)
		      if currentattractingshape isa point or currentattractingshape isa repere then
		        display  = thispoint + "?"
		      elseif nextcurrentattractingshape <> nil then
		        display = attheinter + "?"
		      else
		        display = sur + " " + this(currentattractingshape.gettype) +"?"
		      end if
		    else
		      if currentshape.std then
		        display  = fix + therefpoint
		      else
		        display =  fix + apoint
		      end if
		    end if
		    
		    showattraction
		    Help g, display
		    
		    if  (not currentshape.std or WorkWindow.stdflag) then
		      currentshape.paintall(g)
		    else
		      Currentshape.Points(0).Paint(g)
		    end if
		    
		    if currentattractedshape <> nil then
		      CurrentAttractedShape.paint(g)
		    end if
		    
		    
		    'super.paint(g)
		    
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrepareXMLandMac(pt as point)
		  dim oper as operation
		  
		  if checknoIntersec(pt) and pt.forme > 0  then
		    select case Pt.forme
		    case 1
		      oper = new shapeconstruction
		      oper.OpId = 46
		    case 2
		      oper = new Intersec
		    end select
		    oper.currentshape = pt
		    currentcontent.addoperation(oper)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  Dim f As Integer
		  dim s as shape
		  dim EL as XMLElement
		  dim liste as ObjectsList
		  
		  
		  EL = XMLElement(Temp.child(0))
		  f = Val(EL.GetAttribute(Dico.Value("NrFam")))
		  If f <> -1 Then
		    s = Objects.XMLLoadObject(EL)
		    s.endconstruction
		    RedeleteDeletedFigures(Temp)
		    RecreateCreatedFigures(Temp)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(s as shape) As Boolean
		  dim curshape as point
		  dim i as integer
		  
		  if s <> nil  then
		    if s isa point then
		      curshape = point(s)
		    else
		      curshape = s.points(s.IndexConstructedPoint)
		      for i = 0 to s.indexconstructedpoint-1
		        if s.points(i).distanceto(curshape.bpt)< epsilon   then
		          CurrentContent.abortconstruction
		          return false
		        end if
		      next
		    end if
		    AdjustMagnetism(curshape)
		    if curshape.invalid then
		      CurrentContent.abortconstruction
		      return false
		    end if
		    ReinitAttraction
		    s.IndexConstructedPoint = s.IndexConstructedPoint+1
		  end if
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument, EL as XMLElement) As XMLElement
		  dim Temp as XMLElement
		  
		  if currentshape isa point  then
		    EL = Point(CurrentShape).XMLPutIdInContainer(Doc, EL)
		  else
		    Temp =  CurrentShape.XMLPutIdInContainer(Doc)
		    Temp.AppendChild currentshape.XMLPutChildsInContainer(Doc)
		    EL.AppendChild Temp
		  end if
		  
		  return EL
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  if currentshape isa point and point(currentshape).pointsur.count > 0 then
		    return Point(CurrentShape).XMLPutInContainer(Doc)
		  else
		    return CurrentShape.XMLPutInContainer(Doc)
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TraitementIntersec()
		  dim pt as Basicpoint
		  
		  pt = point(currentattractedshape).simulinter(CurrentAttractingShape,NextCurrentAttractingShape)
		  if pt = nil then
		    nextcurrentattractingshape.unhighlight
		    nextcurrentattractingshape = nil
		  else
		    CurrentShape.Fixecoord(pt, Currentshape.IndexConstructedPoint)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim s as shape
		  
		  s = SelectForm(Temp)
		  
		  if s <> nil then
		    ReDeleteCreatedFigures (Temp)
		    s.delete
		    ReCreateDeletedFigures(Temp)  // Probleme des infos de construction à restituer telles qu'avant la construction
		  end if
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
		Famille As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Forme As Integer
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
			Name="CurrentItemToSet"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="Famille"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="Forme"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
