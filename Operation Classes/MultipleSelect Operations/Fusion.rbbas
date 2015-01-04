#tag Class
Protected Class Fusion
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i,n as integer
		  dim Tr as BasicPoint
		  
		  if (Fus1 isa Lacet) or (Fus2 isa Lacet) then
		    
		  else
		    
		    
		    if dir = 1 then
		      if fus1.std or fus2.std then
		        Fus = new Polyqcq(CurrentContent.TheObjects,Fus1.Points((start1+1) mod Fus1.npts).bpt)
		        for i = 2 to Fus1.npts-1
		          Fus.AddPoint Fus1.Points((start1+i) mod Fus1.npts).bpt
		        next
		        Fus.AddPoint Fus2.Points(start2).bpt
		        for  i = 1 to Fus2.npts-2
		          Fus.AddPoint Fus2.Points((start2+Fus2.npts-i) mod fus2.npts).bpt
		        next
		      else
		        Fus = new Polyqcq(CurrentContent.TheObjects,Fus1.Points(start1).bpt)
		        for i = 1 to Fus1.npts-1
		          Fus.AddPoint Fus1.Points((start1+i) mod Fus1.npts).bpt
		        next
		        for i = 0 to Fus2.npts-1
		          Fus.AddPoint Fus2.Points((start2+i) mod Fus2.npts).bpt
		        next
		        Fus.Points(0).Identify1(Fus.Points(Fus1.npts))
		        Fus.Points(1).Identify1(Fus.Points(Fus1.npts+1))
		      end if
		      Fus.NotPossibleCut = true
		    else
		      Fus = new Polyqcq(CurrentContent.TheObjects,Fus1.Points((start1+1)mod Fus1.npts).bpt)
		      for i = 2 to Fus1.npts-1
		        Fus.AddPoint Fus1.Points((start1+i) mod Fus1.npts).bpt
		      next
		      for i = 1 to Fus2.npts-1
		        Fus.AddPoint Fus2.Points((start2+i) mod Fus2.npts).bpt
		      next
		      
		    end if
		  end if
		  
		  if Fus1.std or Fus2.std then
		    Fus.std = true
		    Fus.fam = 11
		  end if
		  if not Fus.std then
		    Fus.autos
		    redim fus.coord.curved(fus.npts-1)
		  end if
		  Fus.forme = Fus.npts-3
		  Fus.FillColor = Fus1.fillcolor.moyenne(Fus2.fillcolor)
		  Fus.Fill = (Fus1.fill+Fus2.fill)/2
		  Fus.InitConstruction
		  
		  Tr = Fus1.points((start1+1)mod Fus1.npts).bpt - Fus1.points(start1).bpt
		  Tr = Tr.VecNorPerp
		  M1 = new Translationmatrix(Tr*0.2)
		  M2 = new Translationmatrix(Tr*0.2)
		  Fus.Move(M1)
		  if dir = 1 and not Fus.std then
		    Fus.Points(0).Move(M1.inv)
		    Fus.Points(1).Move(M1.inv)
		  end if
		  Fus.EndConstruction
		  if not fus.std then
		    SetConstructionInfo(dir)
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fusion()
		  MultipleSelectOperation()
		  OpId = 27
		  NumberOfItemsToSelect=2
		  
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
		  if S = nil or (not s isa polygon) or s isa cube then
		    return nil
		  end if
		  
		  select case CurrentItemToSet
		  case 1
		    if S isa polygon and not s isa lacet then
		      return s
		    end if
		  case 2
		    if S isa polygon and not s isa lacet  and S<>Fus1 and Polygon(Fus1).PossibleFusionWith(Polygon(s), start1, start2, dir) then
		      return s
		    end if
		  end select
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(S as shape) As boolean
		  select case CurrentItemToSet
		  case 1
		    if s isa lacet then
		      Fus1 = lacet(s)
		    else
		      Fus1 = Polygon(s)
		    end if
		  case 2
		    if s isa lacet then
		      Fus2 = Lacet(s)
		    else
		      Fus2 =Polygon(s)
		    end if
		  end select
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as Graphics)
		  dim trait As CurveShape
		  super.paint(g)
		  dim a,b as BasicPoint
		  
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

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.EndOperation
		  Fus = nil
		  Fus1 = Nil
		  Fus2 = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XmlElement
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
		Sub RedoOperation(Temp as XMLElement)
		  dim EL0, EL1, EL2 as XMLElement
		  
		  
		  ReCreateCreatedFigures (Temp)
		  EL0 = XMLElement(Temp.firstchild)
		  EL1 = XMLElement(EL0.firstchild)
		  dir = val(EL1.GetAttribute("Dir"))
		  start1 = val(EL1.GetAttribute("Start1"))
		  start2 = val(EL1.GetAttribute("Start2"))
		  Fus1 = Polygon(Objects.Getshape(val(XMLElement(EL1.child(0)).GetAttribute("Id"))))
		  Fus2 = Polygon(Objects.GetShape(val(XMLElement(EL1.child(1)).GetAttribute("Id"))))
		  EL2 = XMLElement(EL0.child(1))
		  Fus =   Polygon(Objects.GetShape(val(EL2.GetAttribute("Id"))))
		  EL2 = XMLElement(EL2.child(1))
		  M1 = new Matrix(XMLElement(EL2.Child(0)))
		  M2 = new Matrix(XMLElement(EL2.Child(1)))
		  SetConstructionInfo(dir)
		  wnd.refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLElement) As XMLElement
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetConstructionInfo(dir as integer)
		  dim i as integer
		  
		  Fus.SetConstructedby nil, 9
		  Fus.constructedby.data.append Fus1
		  Fus.constructedby.data.append M1
		  Fus.constructedby.data.append Fus2
		  Fus.constructedby.data.append M2
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
		      Fus.Points(Fus1.npts+i).constructedby.data.append M2
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
		      Fus.Points(Fus1.npts+i-2).constructedby.data.append M2
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
		  Fus.Points(n).constructedby.data.append M2
		  Fus.Points(n).constructedby.data.append dir
		  Fus1.points(s1).addconstructedshape(Fus.points(n))
		  Fus2.points(s2).addconstructedshape(Fus.points(n))
		  
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
		Fus1 As Polygon
	#tag EndProperty

	#tag Property, Flags = &h0
		Fus2 As Polygon
	#tag EndProperty

	#tag Property, Flags = &h0
		Fus As Polygon
	#tag EndProperty

	#tag Property, Flags = &h0
		start1 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		start2 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		dir As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		M1 As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		M2 As Matrix
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
			Name="CurrentItemToSet"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="MultipleSelectOperation"
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
			Name="dir"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
