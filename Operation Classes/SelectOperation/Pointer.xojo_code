#tag Class
Protected Class Pointer
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.Constructor
		  OpId = 38
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i as integer
		  
		  if currenthighlightedshape.pointe = false then
		    currenthighlightedshape.pointer
		  else
		    currenthighlightedshape.depointer 
		    if currenthighlightedshape isa arc then
		      currenthighlightedshape.points(0).pointe = true
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return   Dico.value("Pointer")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  UndoOperation(Temp)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim EL as XMLElement
		  EL = XMLElement(Temp.FirstChild)
		  SelectIdForms(EL)
		  currenthighlightedshape = tempshape.item(0)
		  DoOperation
		End Sub
	#tag EndMethod


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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
