#tag Class
Protected Class MultipleSelectOperation
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  CurrentItemToSet=1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  if not currentcontent.drapabort then
		    super.endoperation
		  end if
		  CurrentItemToSet=1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FinishedSelecting() As Boolean
		  return CurrentItemToSet>NumberOfItemsToSelect
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  if CurrentHighlightedShape=nil then
		    return
		  end if
		  
		  if SetItem(CurrentHighlightedShape) then
		    NextItem
		    if currenthighlightedshape <> nil then
		      currenthighlightedshape.UnHighLight
		      CurrentHighlightedShape=nil
		    end if
		    if FinishedSelecting then
		      Finished = false
		      can.Mousecursor = System.Cursors.Wait
		      DoOperation
		      EndOperation
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NextItem()
		  CurrentItemToSet = CurrentItemToSet + 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OperationFinished() As Boolean
		  return FinishedSelecting
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  super.Paint(g)
		  
		  'if CurrentHighlightedShape<>nil then
		  'CurrentHighlightedShape.HighLight
		  'CurrentHighlightedShape.PaintAll(g)
		  'CurrentHighlightedShape.UnHighLight
		  'end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(s as Shape) As boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Visremove(s as Shape)
		  s.tsp = false
		  Visible.removeobject(s)
		  
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
		CurrentItemToSet As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected NumberOfItemsToSelect As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="canceling"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsep"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentItemToSet"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="info"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="nobj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ntsf"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
