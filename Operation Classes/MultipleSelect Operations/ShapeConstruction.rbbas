#tag Class
Protected Class ShapeConstruction
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub ShapeConstruction(fam as integer, form As integer)
		  MultipleSelectOperation()
		  OpId = 0
		  
		  Objects.unselectAll
		  
		  Famille = Fam
		  Forme = form
		  CreateShape
		  
		  NumberOfItemsToSelect = currentshape.ncpts
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  return  Dico.Value("Construction")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateShape()
		  dim p as BasicPoint
		  dim specs as StdPolygonSpecifications
		  dim fam as integer
		  
		  if famille <> -1 then
		    p = wnd.mycanvas1.MouseUser
		  end if
		  
		  if Famille <10 then
		    select case Famille
		    case -1
		      currentshape = new Repere(objects)
		    case 0
		      currentshape = new Point(objects, p)
		    case 1
		      select case forme
		      case 0
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
		        currentshape = new Triangle(objects,3,p)
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
		      end select
		    case 6
		      if forme = 0 then
		        currentshape = new Triangle(objects,3,p)
		      else
		        currentshape = new Polyqcq(objects, forme+3, p)
		      end if
		      'case 7
		      'Lacets
		    end select
		  else
		    fam = famille-10
		    specs =  Config.StdFamilies(Fam,Forme)
		    if specs.family = "Cubes" or specs.family = "Rods" then
		      currentshape = new Cube(objects, p, forme)
		    elseif  specs.family = "Segments" or ubound(specs.angles) > 0  then
		      currentShape=new StandardPolygon(objects, famille, forme, p)
		    else
		      currentshape = new StdCircle(objects,famille, forme, p)
		    end if
		  end if
		  
		  currentshape.fam = famille
		  currentshape.forme = forme
		  Currentshape.InitConstruction
		  Currentshape.IndexConstructedpoint = 0
		  wnd.setcross
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(p as BasicPoint)
		  dim magneticD As BasicPoint
		  dim magnetism as Integer
		  dim inter as intersec
		  dim pt as Basicpoint
		  
		  if currentShape = nil then
		    return
		  end  if
		  
		  ReinitAttraction
		  CurrentShape.Fixecoord(p, Currentshape.IndexConstructedPoint)
		  magnetism = Magnetisme(currentshape,magneticD)
		  if currentshape isa point and currentattractingshape  isa point then
		    magnetism =0
		    return
		  end if
		  if magnetism>0 then
		    if currentshape isa point   then
		      currentattractedshape = currentshape
		    else
		      currentattractedshape = currentshape.points(Currentshape.IndexConstructedPoint)
		    end if
		    ShowAttraction
		    wnd.mycanvas1.RefreshBackground
		    if nextcurrentattractingshape = nil then
		      CurrentShape.Fixecoord(magneticD, Currentshape.IndexConstructedPoint)
		    elseif not(currentattractingshape isa point) and not(nextcurrentattractingshape isa point) then
		      pt = point(currentattractedshape).simulinter(CurrentAttractingShape,NextCurrentAttractingShape)
		      if pt = nil then
		        nextcurrentattractingshape.unhighlight
		        nextcurrentattractingshape = nil
		        'point(currentattractedshape).valider
		      else
		        CurrentShape.Fixecoord(pt, Currentshape.IndexConstructedPoint)
		      end if
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
		    if currentattractingshape <> nil then
		      currentattractingshape.paint(g)
		      if currentattractingshape isa point or currentattractingshape isa repere then
		        display  = thispoint + "?"
		      elseif nextcurrentattractingshape <> nil then
		        display = attheinter + "?"
		      else
		        display = sur + this + " " +currentattractingshape.gettype +"?"
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
		    
		    if  (not currentshape.std or wnd.stdflag) then
		      currentshape.paintall(g)
		    else
		      Currentshape.Points(0).Paint(g)
		    end if
		    
		    if currentattractedshape <> nil then
		      CurrentAttractedShape.paint(g)
		    end if
		    
		  end if
		  super.paint(g)
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  if SetItem(Currentshape) then
		    finished = false
		    NextItem
		    if CurrentItemToSet>NumberOfItemsToSelect then
		      DoOperation
		      EndOperation
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(s as shape) As Boolean
		  dim curshape as point
		  dim i as integer
		  
		  if s<>nil  then
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
		  end if
		  s.IndexConstructedPoint = s.IndexConstructedPoint+1
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.EndOperation
		  currentshape = nil
		  CreateShape
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i as integer
		  
		  currentshape.endconstruction  //insère la forme dans currentcontent.TheObjects et crée la figure
		  finished = true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim f as integer
		  dim s as shape
		  dim EL as XMLElement
		  dim liste as ObjectsList
		  
		  
		  EL = XMLElement(Temp.child(0))
		  F = val(EL.GetAttribute(Dico.Value("NrFam")))
		  if f = -1 then
		    s = Objects.XMLLoadObject(EL)
		    s.endconstruction
		  else
		    RedeleteDeletedFigures(Temp)
		    RecreateCreatedFigures(Temp)
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
		Sub shapeconstruction(s as shape)
		  
		  MultipleSelectOperation()
		  OpId = 0
		  currentshape = s
		End Sub
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
		Sub AdjustMagnetism(curshape as point)
		  
		  dim magneticD as BasicPoint
		  dim magnetism as integer
		  
		  if CurrentAttractingShape<>nil  then
		    CurrentContent.thefigs.removefigure   CurrentAttractingShape.fig
		    if CurrentAttractingShape isa Point  then
		      curShape.Identify1(Point(CurrentAttractingShape))
		    elseif  currentattractingshape.fam < 10 and currentshape.fam < 10  then
		      if NextCurrentAttractingShape <> nil then
		        CurrentContent.thefigs.removefigure NextCurrentAttractingShape.fig
		        curShape.adjustinter(CurrentAttractingShape,NextCurrentAttractingShape)
		      else
		        curshape.puton currentattractingshape
		      end if
		      curshape.mobility
		    end if
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


	#tag Property, Flags = &h1
		Protected Famille As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Forme As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ntsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Group="Behavior"
			Type="string"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
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
			Name="Std2flag"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SidetoPaint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="info"
			Group="Behavior"
			Type="string"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentItemToSet"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="MultipleSelectOperation"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
