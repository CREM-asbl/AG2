#tag Class
Protected Class Divide
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub AddOperationToMac(OpList as XMLDocument, EL1 as XMLElement)
		  dim EL as XMLElement
		  dim i as integer
		  
		  for i = 0 to CreatedShapes.count -1
		    El=Oplist.CreateElement(Dico.Value("Operation"))
		    El.SetAttribute(Dico.Value("Numero"),str(Currentcontent.TotalOperation))
		    El.SetAttribute(Dico.Value("Type"), GetName)
		    EL.SetAttribute("OpId", str(opId))
		    EL1.AppendChild ToMac(i, OpList,EL)
		    Currentcontent.TotalOperation  = CurrentContent.TotalOperation +1
		  next
		  Currentcontent.TotalOperation  = CurrentContent.TotalOperation - 1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  createdshapes = new objectslist
		  OpId = 26
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ntemp as integer)
		  super.constructor
		  NumberOfItemsToSelect=2
		  NumberofDivisions = ntemp
		  createdshapes = new objectslist
		  colsep = true
		  OpId = 26
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Mexe as MacroExe, EL1 as XMLElement)
		  dim n, rid, side, divp, Id0, Id1 as integer
		  
		  Divide.constructor()
		  n = val(EL1.GetAttribute("Id"))
		  rid = Mexe.GetRealId( n)
		  currentshape = objects.getshape(rid)
		  numberofdivisions = val(EL1.GetAttribute("NDivP"))
		  divp = val(EL1.GetAttribute("DivP"))
		  Id0 = val(EL1.GetAttribute("Id0"))
		  rid = MExe.GetRealId(Id0)
		  firstpoint = point(objects.getshape(rid))
		  Id1 = val(EL1.GetAttribute("Id1"))
		  rid = MExe.GetRealId(Id1)
		  secondpoint = point(objects.getshape(rid))
		  DoOperation
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createshapes()
		  dim s as shape
		  dim i as integer
		  dim p as BasicPoint
		  dim Q as point
		  dim Bib as BiBPoint
		  dim Trib as TriBPoint
		  
		  S = currentshape
		  
		  if S isa StdCircle then
		    Firstpoint.show
		  end if
		  
		  if s isa lacet then
		    if lacet(s).coord.curved(side) = 0 then
		      Bib = new BiBpoint(firstpoint.bpt,secondpoint.bpt)
		    else
		      Trib = new TribPoint(lacet(s).getcentre(side),firstpoint.bpt,secondpoint.bpt)
		    end if
		  elseif S isa BiPoint or s isa polygon then
		    Bib = new BiBpoint(firstpoint.bpt,secondpoint.bpt)
		  elseif s isa circle then
		    Trib = new TriBPoint(s.getgravitycenter, firstpoint.bpt, secondpoint.bpt)
		  end if
		  
		  for i= 1 to Numberofdivisions-1
		    if s isa lacet then
		      if lacet(s).coord.curved(side) = 0 then
		        p = Bib.subdiv(NumberofDivisions,i)
		      else
		        p = Trib.subdiv(s.ori, NumberofDivisions,i)
		      end if
		    elseif S isa BiPoint or s isa polygon then
		      p = Bib.subdiv(NumberofDivisions,i)
		    elseif s isa circle then
		      p = Trib.subdiv(s.ori, NumberofDivisions,i)
		    end if
		    Q=new Point(Objects,p)
		    Q.setconstructedby S, 4
		    Q.constructedBy.data.append firstpoint
		    Q.constructedBy.data.append secondpoint
		    Q.ConstructedBy.data.append numberofdivisions
		    Q.ConstructedBy.data.append i
		    Q.ConstructedBy.data.append side
		    CreatedShapes.addshape  Q
		    Q.mobility
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  
		  CurrentContent.TheFigs.Removefigure currentshape.fig
		  createshapes
		  createdshapes.endconstruction
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.EndOperation
		  CreatedShapes.removeall
		  side = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  return Dico.Value("Divide")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as basicpoint) As shape
		  dim s as Shape
		  dim i as Integer
		  
		  s = Operation.GetShape(p)
		  
		  
		  for i = visible.count-1 downto 0
		    s = visible.item(i)
		    if s isa bande or s isa secteur then
		      visible.removeobject visible.item(i)
		    end if
		    if  (s isa droite and droite(s).nextre <> 2)   then
		      visible.removeobject visible.item(i)
		    end if
		    if s isa lacet then
		      side = s.pointonside(p)
		      s.side = side
		      if side = -1 then
		        visible.removeobject visible.item(i)
		      end if
		    end if
		  next
		  
		  if visible.count = 0 then
		    return nil
		  end if
		  
		  s = visible.item(iobj)
		  if s = nil or  (currentitemtoset = 2 and s = firstpoint) then
		    return nil
		  end if
		  
		  select case CurrentItemToSet
		  case 1
		    return s
		  case 2
		    if s isa Point   then
		      return s
		    else
		      return nil
		    end if
		  end select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g As Graphics)
		  
		  super.paint(g)
		  
		  Select case CurrentItemToSet
		  case 1
		    Help g,  choose + thefirstdivpoint + oraformtodivide
		  case 2
		    FirstPoint.HighLight
		    FirstPoint.Paint(g)
		    FirstPoint.UnhighLight
		    Help g, choose + theseconddivpoint
		  end select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim s as Shape
		  dim i, j as Integer
		  dim EL, EL0, EL1, EL2 as XMLElement
		  dim fam, form as integer
		  
		  EL = XMLElement(Temp.Child(0))
		  NumberofDivisions = val(EL.GetAttribute("NumberOfDivisions") )
		  
		  EL0 = XMLElement(EL.Child(0))
		  EL1 = XMLElement(EL.Child(1))
		  EL2 = XMLElement(EL.Child(2))
		  
		  fam = val(EL0.Getattribute(Dico.Value("NrFam")))
		  form = val(EL0.GetAttribute(Dico.value("NrForm")))
		  if fam <> 1 or form <> -1 then
		    currentshape = selectform(EL)
		  else
		    firstpoint = Point(Objects.Getshape( val(EL1.GetAttribute("Id"))))
		    secondpoint  = Point(Objects.Getshape( val(EL2.GetAttribute("Id"))))
		    currentshape = new Bipoint(objects, firstpoint, secondpoint)
		    currentshape.id = val (EL0.GetAttribute("Id"))
		  end if
		  
		  if not currentshape isa StdCircle then
		    firstpoint = Point(Objects.Getshape( val(EL1.GetAttribute("Id"))))
		    secondpoint  = Point(Objects.Getshape( val(EL2.GetAttribute("Id"))))
		  else
		    s = currentshape
		    firstpoint = new Point(Objects,new BasicPoint(s.GetGravitycenter.x+Circle(s).Radius,s.GetGravitycenter.y))
		    firstpoint.id = val(EL1.GetAttribute("Id"))
		    secondpoint = firstpoint
		  end if
		  
		  createshapes
		  EL1 = XMLElement(EL.Child(3))
		  for i = 0 to createdshapes.count-1
		    createdshapes.item(i).id = val(XMLElement(EL1.child(i)).GetAttribute("Id"))
		    createdshapes.item(i).plan  = val(XMLElement(EL1.child(i)).GetAttribute("plan"))
		    currentcontent.addshape createdshapes.item(i)
		  next
		  ReDeleteDeletedFigures(Temp)
		  ReCreateCreatedFigures(Temp)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(s As Shape) As Boolean
		  dim ff as figure
		  dim d as droite
		  dim sh as shape
		  dim ar() as point
		  
		  select case CurrentItemToSet
		  case 1
		    if s isa point then
		      firstpoint = point(s)
		    else
		      currentshape = s
		      if s isa droite then
		        firstpoint=droite(s).points(0)
		        secondpoint = droite(s).points(1)
		      elseif s isa arc then
		        firstpoint=arc(s).points(1)
		        secondpoint = arc(s).points(2)
		      elseif s  isa Circle then
		        Firstpoint = s.Points(1)
		        secondpoint = firstpoint
		      elseif s isa cube and side <> -1 then
		        d = cube(s).getside(side)
		        firstpoint = d.points(0)
		        secondpoint= d.points(1)
		      elseif s isa lacet and side <> -1 then
		        firstpoint = s.points(side)
		        secondpoint = s.points((side +1) mod s.npts)
		      end if
		      nextitem
		    end if
		    
		  case 2
		    secondpoint = point(s)
		    ar = array(firstpoint, secondpoint)
		    if firstpoint.onsameshape(secondpoint, sh)  and ((sh isa droite) or  (sh isa circle)) and sh.PassePar(ar) then
		      currentshape = sh
		    else
		      currentshape = new BiPoint(Objects,Firstpoint,secondpoint) // on crée un "bipoint de circonstance"
		    end if
		  end select
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(i as integer, Doc as XMLDocument, EL as XMLElement) As XMLElement
		  
		  
		  
		  EL.appendchild createdshapes.item(i).XMLPutIdinContainer(Doc)
		  EL.appendchild  createdshapes.item(i).XMLPutConstructionInfoInContainer(Doc)
		  
		  return EL
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  
		  Dim Myself as XMLElement
		  
		  Myself= Doc.CreateElement(GetName)
		  Myself.setattribute("NumberOfDivisions",str(Numberofdivisions))
		  Myself.SetAttribute("Side", str(side))
		  Myself.appendchild currentshape.XMLPutIdInContainer(Doc)
		  Myself.appendchild firstpoint.XMLPutInContainer(Doc)
		  Myself.appendchild secondpoint.XMLPutInContainer(Doc)
		  Myself.appendchild createdshapes.XMLPutIdInContainer(Doc)
		  return Myself
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  
		  dim s as Shape
		  dim i as Integer
		  dim EL as XMLElement
		  
		  EL = XMLElement(Temp.Child(0))
		  SelectIdForms(EL)
		  
		  for i =  tempshape.count-1 downto 0
		    tempshape.item(i).delete
		  next
		  
		  s = selectform(EL)
		  if s isa bipoint and not s isa droite then
		    s.delete
		  end if
		  RedeleteCreatedFigures(Temp)
		  RecreateDeletedFigures(Temp)
		  
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
		CreatedShapes As objectslist
	#tag EndProperty

	#tag Property, Flags = &h0
		currentshape As shape
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Firstpoint As point
	#tag EndProperty

	#tag Property, Flags = &h0
		NumberOfDivisions As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected secondpoint As point
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
			Name="NumberOfDivisions"
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
