#tag Class
Protected Class Fusion
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  OpId = 27
		  NumberOfItemsToSelect=2
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i as integer
		  dim Tr as BasicPoint
		  
		  
		  if (Fus1.Hybrid) or (Fus2.Hybrid) then
		    return
		  end if
		  
		  if Fus1.std then 
		    Fus = StandardPolygon(Fus1).Fusionner(Fus2,start1,start2,dir)
		  else
		    Fus = Polygon(Fus1).Fusionner(Fus2,start1,start2,dir)
		  end if
		  
		  if fus = nil then
		    return
		  end if
		  
		  
		  Fus.autos
		  Fus.forme = Fus.npts-3
		  Fus.FillColor = Fus1.fillcolor.moyenne(Fus2.fillcolor)
		  Fus.Fill = (Fus1.fill+Fus2.fill)/2
		  Fus.InitColCotes
		  
		  Tr = Fus1.points((start1+1)mod Fus1.npts).bpt - Fus1.points(start1).bpt
		  Tr = Tr.VecNorPerp
		  M1 = new Translationmatrix(Tr*0.2)
		  
		  Fus.Move(M1)
		  
		  Fus.EndConstruction
		  if not fus.std then
		    SetConstructionInfo(dir)
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.EndOperation
		  Fus = nil
		  Fus1 = Nil
		  Fus2 = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  return Dico.Value("OperaMerge")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As Shape
		  dim S As Shape
		  
		  S = Operation.GetShape(p)
		  if S = nil or (not s isa Lacet) or s isa cube or s.auto = 3 then
		    return nil
		  end if
		  
		  select case CurrentItemToSet
		  case 1
		    return s
		  case 2
		    if  S<>Fus1 and Lacet(Fus1).PossibleFusionWith(Lacet(s), start1, start2, dir) then
		      return s
		    end if
		  end select
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as Graphics)
		  
		  super.paint(g)
		  
		  g.Bold=True
		  
		  select case CurrentItemToSet
		  case 1
		    display = choose+ thefirstformtomerge
		  case 2
		    display = choose + thesecondformtomerge
		  end select
		  
		  Help g, display
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim EL0, EL1, EL2 as XMLElement
		  dim List as XMLNodeList
		  
		  ReCreateCreatedFigures (Temp)
		  EL0 =  XMLElement(Temp.FirstChild)
		  List = EL0.XQL(Dico.Value("Forms"))
		  if List.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		  end if
		  dir = val(EL1.GetAttribute("Dir"))
		  start1 = val(EL1.GetAttribute("Start1"))
		  start2 = val(EL1.GetAttribute("Start2"))
		  Fus1 = Polygon(Objects.Getshape(val(XMLElement(EL1.child(0)).GetAttribute("Id"))))
		  Fus2 = Polygon(Objects.GetShape(val(XMLElement(EL1.child(1)).GetAttribute("Id"))))
		  List = EL0.XQL(Dico.Value("Form"))
		  
		  if List.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		  end if
		  Fus =   Polygon(Objects.GetShape(val(EL1.GetAttribute("Id"))))
		  
		  if not Fus.std then
		    List = EL0.XQL(Dico.Value("ConstructedBy"))
		    if List.length > 0 then
		      EL1 = XMLElement(List.Item(0))
		    end if
		    M1 = new Matrix(XMLElement(EL1.Child(0)))
		    M2 = new Matrix(XMLElement(EL1.Child(1)))
		    SetConstructionInfo(dir)
		  end if
		  wnd.refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetConstructionInfo(dir as integer)
		  dim i as integer
		  
		  
		  Fus.SetConstructedby nil, 9
		  Fus.constructedby.data.append Fus1
		  Fus.constructedby.data.append M1
		  Fus.constructedby.data.append Fus2
		  Fus.constructedby.data.append M1
		  Fus.constructedby.data.append dir
		  Fus1.AddConstructedShape Fus
		  Fus2.AddConstructedShape Fus
		  
		  if dir = 1 then             //Les deux points "de fusion" sont chacun images d'un point de Fus1 ET d'un point de Fus2
		    SetConstructionInfoPoint (0, dir, start1, start2)
		    SetConstructionInfoPoint (1, dir,   (start1+1) mod Fus1.npts, (start2+1) mod Fus2.npts)
		    for i = 2 to Fus1.npts-1
		      Fus.Points(i).setconstructedby  Fus1.Points((start1+i) mod Fus1.npts), 9
		      Fus.Points(i).constructedby.data.append M1
		    next
		    for i = 2 to Fus2.npts-1
		      Fus.Points(Fus1.npts+i).setconstructedby  Fus2.Points((start2+i) mod Fus2.npts), 9
		      Fus.Points(Fus1.npts+i).constructedby.data.append M1
		    next
		  else                               //Idem mais les numéros sont différents
		    SetConstructionInfoPoint (0, dir,   (start1+1) mod Fus1.npts, start2)
		    SetConstructionInfoPoint (Fus1.npts-1, dir,  start1, (start2+1) mod Fus2.npts)
		    for i = 2 to Fus1.npts-1
		      Fus.Points(i-1).setconstructedby  Fus1.Points((start1+i) mod Fus1.npts), 9
		      Fus.Points(i-1).constructedby.data.append M1
		    next
		    for i = 2 to Fus2.npts-1
		      Fus.Points(Fus1.npts+i-2).setconstructedby  Fus2.Points((start2+i) mod Fus2.npts), 9
		      Fus.Points(Fus1.npts+i-2).constructedby.data.append M1
		    next
		  end if
		  
		  for i = 0 to Fus.npts-1
		    Fus.points(i).updateguides
		    Fus.Points(i).mobility
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetConstructionInfoPoint(n as integer, dir as integer, s1 as integer, s2 as integer)
		  Fus.Points(n).setconstructedby nil, 9
		  Fus.Points(n).constructedby.data.append Fus1.points(s1)
		  Fus.Points(n).constructedby.data.append M1
		  Fus.Points(n).constructedby.data.append Fus2.points(s2)
		  Fus.Points(n).constructedby.data.append M1
		  Fus.Points(n).constructedby.data.append dir
		  Fus1.points(s1).addconstructedshape(Fus.points(n))
		  Fus2.points(s2).addconstructedshape(Fus.points(n))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(S as shape) As boolean
		  dim P as Lacet
		  
		  select case CurrentItemToSet
		  case 1
		    if s.Hybrid then
		      Fus1 = lacet(s)
		    elseif s.std then
		      Fus1 = StandardPolygon(s)
		    else
		      Fus1 = Polygon(s)
		    end if
		  case 2
		    if s.Hybrid then
		      Fus2 = Lacet(s)
		    elseif s.std then
		      Fus2 = StandardPolygon(s)
		    else
		      Fus2 =Polygon(s)
		    end if
		    if Fus2.std and not Fus1.std then
		      P = Fus1
		      Fus1 = Fus2
		      Fus2 = Polygon(P)
		    end if
		    
		  end select
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLElement) As XMLElement
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  dim EL0, EL1 as XMLElement
		  
		  EL0 = Doc.CreateElement(GetName)
		  EL1= Doc.CreateElement(Dico.Value("Forms"))
		  EL1.setAttribute("Dir", str(dir))
		  EL1.SetAttribute("Start1",str(start1))
		  EL1.SetAttribute("Start2",str(start2))
		  EL1.appendchild Fus1.XMLPutIdInContainer(Doc)
		  EL1.appendchild Fus2.XMLPutIdInContainer(Doc)
		  EL0.appendchild EL1
		  EL0.AppendChild Fus.XMLPutInContainer(Doc)
		  return EL0
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim s as shape
		  dim EL as XMLElement
		  
		  EL = XMLElement(Temp.firstchild)
		  s = SelectForm(EL)
		  s.delete
		  objects.unselectall
		  ReDeleteCreatedFigures (Temp)
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
		dir As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Fus As Lacet
	#tag EndProperty

	#tag Property, Flags = &h0
		Fus1 As Lacet
	#tag EndProperty

	#tag Property, Flags = &h0
		Fus2 As Lacet
	#tag EndProperty

	#tag Property, Flags = &h0
		M1 As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		M2 As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		start1 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		start2 As Integer
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
			Name="dir"
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
			Name="start1"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="start2"
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
