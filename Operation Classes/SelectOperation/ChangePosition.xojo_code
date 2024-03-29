#tag Class
Protected Class ChangePosition
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor(n as integer)
		  SelectOperation.Constructor
		  OpId = 11
		  foreground = n
		  objects.unselectall
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  Dim i  As Integer
		  dim s as shape
		  
		  s = tempshape.item(0)
		  if s = nil then 
		    return
		  end if
		  pos.append currentcontent.plans.indexof(s.id)
		  if foreground = 0 then
		    currentcontent.moveback(s.id)
		  else
		    currentcontent.movefront(s.id)
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.EndOperation
		  redim pos(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  if foreground=0 then
		    return Dico.Value("ToolsARPlan")
		  else
		    return Dico.Value("ToolsAVPlan")
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g As Graphics)
		  
		  SelectOperation.Paint(g)
		  
		  if foreground = 0 then
		    if CurrentHighlightedShape=nil then
		      Help g, choose + aform + toputatbackground
		    else
		      Help g, click
		    end if
		  else
		    if CurrentHighlightedShape=nil then
		      Help g,  choose + aform + toputatforeground
		    else
		      Help g, click
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  Dim i As Integer
		  dim s as Shape
		  dim EL, EL1 as XMLElement
		  dim fg as string
		  
		  fg = Temp.GetAttribute(Dico.Value("Type"))
		  if fg =Dico.Value("ToolsARPlan") then
		    foreground = 0
		  else
		    foreground = 1
		  End If
		  Super.RedoOperation(Temp)
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument) As XMLElement
		  dim temp, EL,EL1 as XMLElement
		  dim i as integer
		  
		  temp = Doc.CreateElement(Dico.value("Forms"))
		  for i = 0 to tempshape.count-1
		    temp.AppendChild tempshape.item(i).XMLPutIdINContainer(Doc)
		  next
		  temp.setattribute("Foreground", str(foreground))
		  
		  return temp
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  dim temp, EL,EL1 as XMLElement
		  dim i as integer
		  
		  'temp = Doc.CreateElement(GetName)
		  'temp.AppendChild SelectOperation.ToXML(Doc)
		  
		  temp = super.ToXML(Doc)
		  if temp <> nil then
		    EL =  Doc.CreateElement(Dico.value("Positions"))
		    EL1 = Doc.CreateElement(Dico.value("Position"))
		    for i = 0 to tempshape.count-1
		      EL1.setattribute(Dico.Value("Old"), str(pos(i)))
		    next
		    EL.AppendChild EL1
		    temp.appendchild EL
		  end if
		  
		  return temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  Dim i As Integer
		  dim s as Shape
		  dim EL, EL1 as XMLElement
		  
		  
		  Temp = XMLElement(Temp.child(0))
		  SelectIdForms(Temp)
		  EL = XMLElement(Temp.child(1))
		  if EL = nil then
		    return
		  end if
		  Redim pos(0)
		  EL1 = XMLElement(EL.Child(0))
		  pos(0) = Val(EL1.GetAttribute(Dico.Value("Old")))
		  s=tempshape.item(0)
		  currentcontent.setposition(s,pos(0))
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
		foreground As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Pos(-1) As Integer
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
			Name="Finished"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="foreground"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
