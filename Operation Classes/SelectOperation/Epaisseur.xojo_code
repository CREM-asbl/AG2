#tag Class
Protected Class Epaisseur
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  OpId = 13
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ep as double)
		  
		  super.constructor
		  OpId = 13
		  Thickness = ep
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  Dim i,j As Integer
		  Dim thin, thick, actual As Double
		  setoldthicknesses
		  
		  thin = config.thickness
		  thick = 1.5*thin
		  for i = 0 to tempshape.count -1
		    If Not tempshape.item(i) IsA cube Then
		      actual = tempshape.item(i).borderwidth
		      If actual = thin Or actual = thick Then
		        thickness  = thin*thick/actual
		      Else
		        thickness = config.thickness
		      end if
		      tempshape.item(i).borderwidth = thickness
		      for j = 0 to ubound(tempshape.item(i).childs)
		        tempshape.item(i).childs(j).borderwidth = thickness
		      next
		    end if
		  next
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.value("Thickness")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  Dim i, j, n As Integer
		  dim s as shape
		  dim EL, EL1, EL2 as XMLElement
		  dim r as double
		  
		  
		  EL = XMLElement(Temp.Child(0))
		  r = val(EL.GetAttribute("NewThickness"))
		  SelectIdForms(EL)
		  n = tempshape.count-1
		  
		  for i = 0 to n
		    s = tempshape.item(i)
		    s.borderwidth = r
		    for j = 0 to ubound(s.childs)
		      s.childs(j).borderwidth = r
		    next
		  next
		  objects.unselectall
		  
		  'For i = 0 To tempshape.count -1
		  'If Not tempshape.item(i) IsA cube Then
		  'tempshape.item(i).borderwidth = thickness
		  'For j = 0 To ubound(tempshape.item(i).childs)
		  'tempshape.item(i).childs(j).borderwidth = thickness
		  'Next
		  'End If
		  'Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetOldThicknesses()
		  dim i, n as integer
		  
		  n = tempshape.count-1
		  for i = 0 to n
		    oldthicknesses.append tempshape.item(i).borderwidth
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument) As XMLElement
		  Dim Myself , EL, EL1 as XMLElement
		  dim i,n as integer
		  
		  n = tempshape.count
		  
		  Myself= Doc.CreateElement(Dico.value("Forms"))
		  Myself.setattribute("NewThickness", str(thickness))
		  for i = 0 to n-1
		    Myself.appendchild  tempshape.item(i).XMLPutIdInContainer(Doc)
		  next
		  return Myself
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  Dim Myself , EL, EL1 as XMLElement
		  dim i,n as integer
		  
		  n = tempshape.count
		  if n>0 then
		    Myself= Doc.CreateElement(GetName)
		    Myself.setattribute("NewThickness", str(thickness))
		    EL = tempshape.XMLPutIdInContainer(Doc)
		    Myself.appendchild EL
		    EL = Doc.CreateElement(Dico.value("OldThicknesses"))
		    EL1 = Doc.CreateElement("OldThickness")
		    for i = 0 to n-1
		      EL1.setattribute(Dico.value("Old"), str(oldthicknesses(i)))
		    next
		    EL.AppendChild EL1
		    Myself.appendchild EL
		    return Myself
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim i,j, n as integer
		  dim s as shape
		  dim EL, EL1, EL2 as XMLElement
		  dim r as double
		  
		  
		  EL = XMLElement(Temp.Child(0))
		  SelectIdForms(EL)
		  n = tempshape.count-1
		  EL1 = XMLElement(EL.child(1))
		  
		  for i = 0 to n
		    s = tempshape.item(i)
		    EL2 = XMLElement(EL1.child(i))
		    r = Val(EL2.GetAttribute("Old"))
		    s.borderwidth = r
		    for j = 0 to ubound(s.childs)
		      s.childs(j).borderwidth =r
		    next
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
		Oldthicknesses(-1) As double
	#tag EndProperty

	#tag Property, Flags = &h0
		Thickness As double
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
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Thickness"
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
