#tag Class
Protected Class Rigidifier
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		   super.Constructor
		  OpId = 30
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i as integer
		  
		  for i = 0 to tempshape.count -1
		    tempshape.element(i).rigidifier
		  next
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.value("ToolsRigid")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As Shape
		  dim s as shape
		  
		  s = Operation.getshape(p)
		  
		  if s = nil then
		    return s
		  end if
		  
		  if  s.fam > 9  then ' or (s isa point and point(s).pointsur.count> 0)   then Pourquoi ne pas pouvoir punaiser un point sur ?
		    s = nil
		  end if
		  
		  
		  return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim s as string
		  
		  if currenthighlightedshape = nil then
		    Help g, choose + aform + arigidifier + ou + aderigidifier
		  else
		    if currenthighlightedshape isa  point then
		      s = thispoint
		    else
		      s = thisform
		    end if
		    if currenthighlightedshape.std then
		      Help g, derigidifier + s
		    else
		      Help g, rigidifier + s
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp As XMLElement)
		  UndoOperation(Temp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp As XMLElement)
		  dim EL as XMLElement
		  
		  EL = XmlElement(Temp.Child(0))
		  objects.unselectall
		  SelectIdForms(EL)
		  DoOperation
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


	#tag ViewBehavior
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
