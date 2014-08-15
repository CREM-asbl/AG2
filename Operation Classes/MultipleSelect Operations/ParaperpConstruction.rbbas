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
		  dim n as integer
		  
		  
		  if famille <> 1 then
		    return
		  end if
		  
		  p = new BasicPoint(0,0)
		  ol = CurrentContent.TheObjects
		  select case forme
		  case 1
		    n = 2 'currentshape = new Droite(ol, p,2)  // segment parallele
		    op = 1
		  case 2
		    n = 2 'currentshape = new Droite(ol, p,2)  //segment perpendiculaire
		    op = 2
		  case 4
		    n = 0 'currentshape = new Droite(ol,p,0) // droite parallele
		    op = 1
		  case 5
		    n = 0 'currentshape = new Droite(ol,p,0) // droite perpendiculaire
		    op = 2
		  end select
		  currentshape = new Droite(ol,p,n)
		  currentshape.fam = 1
		  currentshape.forme = forme
		  currentshape.auto = 6
		  currentshape.liberte = 3
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
		    BiB1=Refe.coord.GetBiB(index(iobj))
		  case 2
		    curshape = currentshape.points(0)
		    AdjustMagnetism(curshape)
		    droite(currentshape).constructshape
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
		    droite(currentshape).constructshape
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
		  dim u, v as BasicPoint
		  
		  currentshape.setconstructedby(Refe,op)
		  currentshape.constructedby.data.append index(iobj)
		  tsf = refe.gettsf(0,index(iobj))
		  if tsf = nil then
		    tsf = new Transformation(Refe,0,index(iobj), 0)
		  end if
		  currentshape.constructedby.data.append tsf
		  tsf.constructedshapes.addshape currentshape
		  refe.tsfi.addtsf tsf
		  BiB2 = droite(currentshape).coord.GetBiB(0)
		  u = BiB1.second-BiB1.first
		  v = BiB2.second-BiB2.first
		  if op = 1 then
		    ori = sign(u*v)
		  else
		    ori = sign(u.vect(v))
		  end if
		  currentshape.constructedby.data.append ori  // ajouté le 15 juin 2014 (jour de la Trinité) pour les macros
		  super.dooperation
		  currentshape.setfigconstructioninfos
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParaperpConstruction(Mexe as MacroExe, EL0 as XMLElement, EL1 as XMLElement)
		  dim  fa, fo, rid, side, n, i , num as integer
		  dim pt as point
		  dim EL as XMLElement
		  dim sh as shape
		  
		  fa = val(EL0.GetAttribute(Dico.Value("NrFam")))
		  fo = val(EL0.GetAttribute(Dico.Value("NrForm")))
		  ParaperpConstruction (fa,fo)
		  n = val(EL1.GetAttribute("Id"))
		  ori = val(EL1.GetAttribute("Ori"))
		  rid = MExe.GetRealId(n)
		  Refe= objects.GetShape(rid)
		  currentshape.setconstructedby(Refe, val(EL1.GetAttribute("Oper")))
		  side = Mexe.GetRealSide(n)
		  currentshape.constructedby.data.append side
		  currentshape.constructedby.data.append nil
		  currentshape.constructedby.data.append ori
		  
		  'Positionnement aisé du premier point
		  EL =XMLElement(EL0.Child(0))
		  n = val(XMLElement(EL.Child(0)).GetAttribute("Id"))
		  rid = MExe.GetRealId(n)
		  pt = point(objects.GetShape(rid))
		  currentshape.substitutepoint(pt,currentshape.points(0))
		  
		  'Deuxième point
		  'a) Calculer la direction de la droite/segment
		  Droite(currentshape).constructshape
		  currentshape.updatecoord
		  
		  'b) Positionner le deuxième point
		  ' si fo > 3 then  'pas de probleme rien à changer à ce qui précède : une droite n'a qu'un second point caché
		  if fo <3 then
		    EL = XMLElement(EL.Child(1))
		    n = val(EL.GetAttribute("Id"))
		    rid = MExe.GetRealId(n)
		    pt = point(objects.GetShape(rid))
		    'b1) Si l'extrémité n'est pas un point sur, il s'agit soit d'un point initial, soit d'un point déjà défini, on le positionne conformément au contenu de la macro
		    'voir remarque correspondante dans  macro.paraperp
		    BiB1 = new BiBPoint(currentshape.coord)
		    if val(EL.GetAttribute("NrForm"))  <> 1 then
		      pt.moveto pt.bpt.projection(BiB1)
		      
		      'b2) si l'extrémité est un point sur, il faut repositionner l'extrémité
		    else
		      EL = XMLElement(EL.Child(0))
		      pt.surseg = (val(EL.GetAttribute("Surseg")) = 1)
		      EL = XMLElement(EL.Child(0))
		      n = val(EL.GetAttribute("Id")) 'macId du support de pt
		      rid = MExe.GetRealId(n)
		      sh = objects.Getshape(rid)
		      num = val(EL.GetAttribute("NrCote"))
		      pt.moveto BiB1.ComputeDroiteFirstIntersect(sh,num,pt.bpt)
		    end if
		    currentshape.substitutepoint(pt,currentshape.points(1))
		    'currentshape.Points(1).location(0) = pt.bpt.location(sh, 0)
		  end if
		  
		  currentshape.endconstruction
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

	#tag Property, Flags = &h0
		BiB1 As BiBPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		BiB2 As BiBPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ori As Integer
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
		#tag ViewProperty
			Name="ori"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
