#tag Class
Protected Class GCConstruction
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub GCConstruction()
		  
		  SelectOperation()
		  OpId = 14
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.value("CenterConstruction")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  SelectOperation.Paint(g)
		  if CurrentHighlightedShape=nil then
		    Help g, choose+aform
		  else
		    Help g, click
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim s as shape
		  dim i,j, n as integer
		  'dim GC as Point
		  dim t as boolean
		  
		  n = tempshape.count-1
		  if n = -1 then
		    return
		  end if
		  
		  for i = 0 to n
		    s = tempshape.element(i)
		    if not (s isa Point) then
		      t = true
		      for j = 0 to Ubound(s.constructedshapes)
		        if s.constructedshapes(j).constructedby.oper = 0 then
		          t = false
		        end if
		      next
		      if t then
		        if  s isa circle then
		          s.Points(0).show
		        else
		          CurrentContent.Thefigs.RemoveFigure s.fig
		          currentshape = new Point(objects, s.getgravitycenter)
		          currentshape.setconstructedby(s,0)
		          currentshape.endconstruction
		        end if
		      end if
		    end if
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XmlElement)
		  dim s as shape
		  dim i, j, n as integer
		  dim EL as XMLElement
		  dim p as point
		  
		  EL = XMLElement(Temp.Child(0))
		  SelectIdForms(EL)
		  
		  n = tempshape.count-1
		  for i = 0 to n
		    s = tempshape.element(i)
		    if not (s isa point) and not (s isa circle) then
		      p = s.GetGC
		      p.delete
		    elseif s isa circle then
		      s.points(0).hide
		    end if
		  next
		  objects.unselectall
		  
		  ReDeleteCreatedFigures (Temp)
		  ReCreateDeletedFigures(Temp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc As XMLDocument) As XMLElement
		  dim EL, Temp as XMLElement
		  dim i as integer
		  
		  Temp = Doc.CreateElement(GetName)
		  Temp.appendchild Tempshape.XMLPutIdInContainer(Doc)
		  EL = Doc.CreateElement(Dico.Value("Centres"))
		  for i = 0 to tempshape.count-1
		    EL.AppendChild tempshape.element(i).GetGC.XMLPutINContainer(Doc)
		  next
		  Temp.appendchild EL
		  return temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XmlElement)
		  
		  ReDeleteDeletedFigures (Temp)
		  ReCreateCreatedFigures(Temp)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as basicPoint) As shape
		  dim s as shape
		  dim i, j as integer
		  
		  s = super.getshape(p)
		  
		  if visible.count > 0 then
		    for i =  visible.count-1 downto 0
		      s = Visible.element(i)
		      if s isa point or  s isa bande or s isa secteur or s isa Lacet or (s isa droite and droite(s).nextre < 2)  or s isa arc  then
		        visible.removeshape s
		        nobj = visible.count
		      end if
		    next
		  end if
		  
		  if Visible.count > 0  then
		    return visible.element(iobj)
		  else
		    return nil
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument, EL as XMLElement) As XMLElement
		  
		  EL.AppendChild currentshape.XMLPutIdINContainer(Doc)
		  EL.appendchild  currentshape.XMLPutConstructionInfoInContainer(Doc)
		  return EL
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GCConstruction(MExe as MacroExe, EL1 as XMLElement)
		  dim sh as shape
		  dim n, rid, side as integer
		  
		  GCConstruction
		  n = val(EL1.GetAttribute("Id"))
		  rid = MExe.GetRealId(n)
		  sh = objects.getshape(rid)
		  currentshape = sh.GetGC
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
	#tag EndViewBehavior
End Class
#tag EndClass
