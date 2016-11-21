#tag Class
Protected Class Delier
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  OpId = 10
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  
		  dim i as integer
		  
		  for i = 0 to tempshape.count-1
		    tempshape.item(i).IdGroupe = -1
		    redim tempshape.item(i).OldIdGroupes(-1)
		  next
		  objects.groupes(numlist).removeall
		  objects.OptimizeGroups
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.value("EditUnlink")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  dim j as integer
		  
		  if CurrentHighlightedshape <> nil  then
		    Objects.Unselectall
		    numlist = Currenthighlightedshape.IdGroupe
		    if numlist <> -1 then
		      for j = 0 to objects.Groupes(numlist).count -1
		        objects.selectobject objects.groupes(numlist).item(j)
		      next
		      DoOperation
		      endoperation
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim i, j as integer
		  dim s as Shape
		  dim p as BasicPoint
		  
		  Help g, choose + agroup + adelier
		  
		  for j = 0 to UBound(objects.groupes)
		    objects.affichergroupe(j,bleu,g)
		  next
		  
		  g.ForeColor = Config.bordercolor.col
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim EL1 as XMLElement
		  
		  EL1 = XMLElement(Temp.FirstChild)
		  numlist = val(EL1.GetAttribute("IdGroupe"))
		  SelectIdForms(EL1)
		  
		  DoOperation
		  finished = true
		  objects.unselectall
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  dim temp as XMLElement
		  
		  temp =  Doc.CreateElement(Dico.Value("Group"))
		  temp.setattribute("IdGroupe", str(numlist))
		  temp.AppendChild tempshape.XMLPutIdInContainer(Doc)
		  
		  return temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim EL1 as XMLElement
		  dim i as integer
		  
		  EL1 = XMLElement(Temp.FirstChild)
		  numlist = val(EL1.GetAttribute("IdGroupe"))
		  SelectIdForms(EL1)
		  
		  objects.groupes.Insert(numlist,new ObjectsList)
		  for i = 0 to tempshape.count-1
		    Objects.Groupes(Numlist).addShape tempshape.item(i)
		  next
		  objects.OptimizeGroups
		  objects.unselectall
		  
		  
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
		numlist As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="canceling"
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
			Name="numlist"
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
			Name="SidetoPaint"
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
