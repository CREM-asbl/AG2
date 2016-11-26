#tag Class
Protected Class Copier
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  super.constructor
		  app.tampon.removeall
		  OpId = 5
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim s as shape
		  dim i, n as integer
		  
		  n = tempshape.count-1
		  for i = 0 to n
		    s = tempshape.item(i)
		    app.tampon.addshape(s)
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("EditCopy")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  dim i, j as integer
		  dim s as shape
		  
		  if currenthighlightedshape = nil then
		    Objects.unselectall
		    return
		  end if
		  
		  if CurrentHighlightedshape <> nil and currenthighlightedshape.selected = false then
		    Objects.Unselectall
		    Objects.selectobject(CurrentHighLightedshape)
		    app.Tampon.removeAll
		  end if
		  
		  Finished = false
		  can.Mousecursor = System.Cursors.Wait
		  currentcontent.MoveFront(CurrentHighlightedShape.id)
		  CurrentHighlightedShape.SelectNeighboor
		  wnd.refreshtitle
		  DoOperation
		  
		  endoperation
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp As XMLElement)
		  SelectIdForms(Temp)
		  DoOperation
		  objects.unselectall
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp As XMLElement)
		  app.tampon.removeall
		  
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
			Name="OpId"
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
