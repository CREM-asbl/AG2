#tag Class
Protected Class TransparencyChange
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor(f as integer)
		  
		  super.constructor
		  OpId = 18
		  self.f = f
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim s as shape
		  dim i, n as integer
		  
		  n = tempshape.count -1
		  redim oldfill(n)
		  for i = 0 to n
		    s = tempshape.item(i)
		    oldfill(i) = s.fill
		    s.fill = f
		  next
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("ToolsColorTransparent")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ImmediateDoOperation(f as integer)
		  if tempshape.count > 0 then
		    can.Mousecursor = System.Cursors.Wait
		    WorkWindow.refreshtitle
		    DoOperation
		    endoperation
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paint(g as graphics) As string
		  Help g, choose + aform + arenransparenteouopaque
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  Dim i, n As Integer
		  dim s as shape
		  
		  
		  
		  Temp = XMLElement(Temp.child(0))
		  SelectIdForms(Temp)
		  n = tempshape.count-1
		  f = Val(Temp.GetAttribute("NewFill"))
		  for i = 0 to n
		    s = tempshape.element(i)
		    s.fill = f
		  next
		  objects.unselectall
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  Dim Myself , EL, Temp as XMLElement
		  dim i,j,n as integer
		  dim s as shape
		  
		  
		  
		  n = tempshape.count
		  if n>0 then
		    Myself= Doc.CreateElement(GetName)
		    Myself.appendchild tempshape.XMLPutIdInContainer(Doc)
		    Myself.setattribute("NewFill", str(f))
		    
		    
		    EL = Doc.CreateElement("OldFills")
		    for i = 0 to n-1
		      EL.SetAttribute("OldFill"+str(i), str(oldfill(i)))
		    next
		    Myself.appendchild EL
		    return Myself
		  end if
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp As XMLElement)
		  Dim i, n As Integer
		  dim s as shape
		  dim EL as XMLElement
		  
		  Temp = XMLElement(Temp.child(0))
		  SelectIdForms(Temp)
		  
		  n = tempshape.count
		  EL = XMLElement(Temp.child(1))
		  for i = 0 to n-1
		    s = tempshape.element(i)
		    s.fill= val(EL.GetAttribute("OldFill"+str(i)))
		  next
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
		f As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		OldFill(-1) As Integer
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
			Name="display"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="f"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
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
