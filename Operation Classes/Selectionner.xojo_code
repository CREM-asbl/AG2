#tag Class
Protected Class Selectionner
Inherits Operation
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  OpId = 4
		  Objects.unselectall
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(t as boolean)
		  super.constructor
		  OpId = 4
		  all = t
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  
		  if all then
		    Objects.Unselectall
		    Objects.Selectall
		    return
		  end if
		  
		  if CurrentShape  = nil then
		    return
		  end if
		  
		  if not currentshape.selected then
		    Objects.selectobject(currentshape)
		  else
		    Objects.unselectobject(currentshape)
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  
		  if CurrentContent.ForHisto then
		    CurrentContent.AddOperation(self)
		  end if
		  
		  Finished = true
		  'can.invalidate
		  can.mousecursor =System.Cursors.StandardPointer
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  
		  if all then
		    return Dico.value("EditSelectall")
		  else
		    return Dico.Value("EditSelection")
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  currentshape = currenthighlightedshape
		  Finished = false
		  can.Mousecursor = System.Cursors.Wait
		  DoOperation
		  endoperation
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseWheel()
		  
		  nobj = visible.count
		  if visible <> nil and visible.count <> 0 then
		    iobj = (iobj+1) mod nobj
		    if CurrentHighlightedShape<>nil then
		      CurrentHighlightedShape.UnHighLight
		    end if
		    
		    CurrentHighlightedShape = visible.item(iobj)
		    CurrentHighlightedShape.HighLight
		    'can.invalidate
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g As Graphics)
		  
		  Super.Paint(g)
		  
		  if CurrentHighLightedShape <> nil then
		    display = click+pour+selectionner
		  else
		    display =  choose + aform
		  end if
		  
		  Help g, display
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  UndoOperation(Temp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function toXML(Doc as XMLDocument) As XMLElement
		  dim n as integer
		  
		  if all then
		    return Objects.Selection.XMLPutIdInContainer(Doc)
		  else
		    if currentshape <> nil then
		      return currentshape.XMLPutIdInContainer(Doc)
		    end if
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim s as shape
		  dim List as XMLNodeList
		  dim EL, EL1 as XMLElement
		  dim i,n as integer
		  
		  List = Temp.XQL(Dico.value("Forms"))
		  if list.length > 0 then
		    EL = XMLElement(List.Item(0))
		    for i = 0 to EL.childcount-1
		      EL1 = XMLElement(EL.child(i))
		      n = val(EL1.GetAttribute("Id"))
		      currentshape =  Objects.Getshape(n)
		      dooperation
		    next
		  else
		    currentshape = SelectForm(Temp)
		    dooperation
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
		all As boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="all"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
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
