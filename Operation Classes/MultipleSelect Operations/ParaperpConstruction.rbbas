#tag Class
Protected Class ParaperpConstruction
Inherits ShapeConstruction
	#tag Method, Flags = &h0
		Sub ParaperpConstruction(fam as integer, form As integer)
		  ShapeConstruction(fam,form)
		  OpId = 1
		  
		  NumberOfItemsToSelect = 3
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateShape()
		  dim ol as Objectslist
		  dim p as BasicPoint
		  
		  
		  if famille <> 1 then
		    return
		  end if
		  
		  p = new BasicPoint(0,0)
		  ol = CurrentContent.TheObjects
		  select case forme
		  case 1
		    currentshape = new Droite(ol, p,2)  // segment parallele
		    op = 1
		  case 2
		    currentshape = new Droite(ol, p,2)  //segment perpendiculaire
		    op = 2
		  case 4
		    currentshape = new Droite(ol,p,0) // droite parallele
		    op = 1
		  case 5
		    currentshape = new Droite(ol,p,0) // droite perpendiculaire
		    op = 2
		  end select
		  currentshape.auto = 6
		  currentshape.liberte = 3
		  'CurrentShape.IsInConstruction = true
		  Currentshape.InitConstruction
		  CurrentShape.IndexConstructedPoint = 0
		  wnd.setcross
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g As Graphics)
		  operation.paint(g)
		  display = ""
		  select case currentitemtoset
		  case 1
		    display = choose + asegmentoraline
		  else
		    if currentattractingshape <> nil then
		      currentattractingshape.paint(g)
		      if currentattractingshape isa point or currentattractingshape isa repere then
		        display  = thispoint + "?"
		      elseif nextcurrentattractingshape <> nil then
		        display = attheinter + "?"
		      else
		        display = sur + this (currentattractingshape.gettype) +"?"
		      end if
		    end if
		    showattraction
		    if constructed then
		      currentshape.paintall(g)
		    end if
		  end select
		  
		  Help g, display
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("Paraperp")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(p as BasicPoint)
		  dim magneticD As BasicPoint
		  dim magnetism as Integer
		  
		  ReinitAttraction
		  
		  select case currentitemtoset
		  case 1
		    Refe = GetBiPoint(p)
		    currentattractingshape = Refe
		  else
		    CurrentShape.Fixecoord(p, currentshape.IndexConstructedPoint)
		    constructed = true
		    magnetism = Magnetisme(currentshape,magneticD)
		    if magnetism>0  then
		      currentattractedshape = currentshape.points(currentshape.IndexConstructedPoint)
		      ShowAttraction
		      wnd.mycanvas1.RefreshBackground
		      if nextcurrentattractingshape = nil then
		        CurrentShape.Fixecoord(magneticD, Currentshape.IndexConstructedPoint)
		      elseif not(currentattractingshape isa point) and not(nextcurrentattractingshape isa point) then
		        TraitementIntersec()
		      end if
		    end if
		  end select
		  showattraction
		  
		  
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
		    CurrentHighlightedShape = visible.element(iobj)
		    CurrentHighlightedShape.HighLight
		    Wnd.mycanvas1.refreshbackground
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim s, s1 as shape
		  dim i, j as integer
		  dim tsf as Transformation
		  
		  currentshape = SelectForm(Temp)
		  currentshape.delete
		  objects.unselectall
		  
		  ReDeleteCreatedFigures (Temp)
		  ReCreateDeletedFigures(Temp)
		  
		  wnd.refresh
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(s as shape) As Boolean
		  dim magneticD, p As BasicPoint   // s est identique à "currentshape" (voir "shapeconstruction")
		  dim magnetism, i as Integer
		  dim curshape  as Point
		  
		  currentshape = s
		  
		  if Refe = nil then
		    return false
		  end
		  
		  p = wnd.mycanvas1.mouseuser
		  magneticD = new BasicPoint(0,0)
		  
		  select case  currentitemtoset
		  case 1
		    if forme >2 then
		      currentshape.Points(1).hide
		    end if
		    currentshape.setconstructedby(Refe,op)
		    currentshape.constructedby.data.append index(iobj)
		  case 2
		    curshape = currentshape.points(0)
		    AdjustMagnetism(curshape)
		    if curshape.invalid then
		      CurrentContent.abortconstruction
		      return false
		    end if
		    curshape.mobility
		    ReinitAttraction
		    currentshape.IndexConstructedPoint = currentshape.IndexConstructedPoint+1
		    if droite(currentshape).nextre = 0 then
		      nextitem
		    end if
		  case 3
		    currentshape.constructshape
		    curshape = currentshape.points(1)
		    AdjustMagnetism(curshape)
		    if curshape.invalid or currentshape.points(0).distanceto(curshape.bpt)< epsilon   then
		      CurrentContent.abortconstruction
		      return false
		    end if
		    if currentattractingshape isa polygon  then
		      curshape.surseg = true
		      if currentshape.points(0).pointsur.count = 1 and currentshape.points(0).pointsur.element(0) isa polygon then
		        currentshape.points(0).surseg = true
		      end if
		    end if
		    curshape.mobility
		    ReinitAttraction
		    currentshape.IndexConstructedPoint = currentshape.IndexConstructedPoint+1
		  end select
		  
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub endoperation()
		  
		  refe = nil
		  super.endoperation
		  constructed = false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument, EL as XMLElement) As XMLElement
		  dim Temp as XMLElement
		  Temp = super.ToMac(Doc,EL)
		  
		  Temp.Appendchild currentshape.XMLPutConstructionInfoInContainer(Doc)
		  
		  return Temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim tsf as transformation
		  
		  currentshape.setconstructedby(Refe,op)
		  currentshape.constructedby.data.append index(iobj)
		  tsf = refe.gettsf(0,index(iobj))
		  if tsf = nil then
		    tsf = new Transformation(Refe,0,index(iobj), 0)
		  end if
		  currentshape.constructedby.data.append tsf
		  tsf.constructedshapes.addshape currentshape
		  refe.tsfi.addtsf tsf
		  super.dooperation
		  currentshape.setfigconstructioninfos
		  
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
		Refe As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		op As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		constructed As boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Famille"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="ShapeConstruction"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Forme"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="ShapeConstruction"
		#tag EndViewProperty
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
			Name="CurrentItemToSet"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="MultipleSelectOperation"
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
			Name="op"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="constructed"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
