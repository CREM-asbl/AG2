#tag Class
Protected Class ModifTimer
Inherits Timer
	#tag Event
		Sub Action()
		  
		  can.mousecursor = System.cursors.wait
		  oper.DoOper(BPInter)
		  pas = pas-1
		  
		  
		  if pas = 0 then
		    if oper isa Glisser  then
		      SelectandDragOperation(oper).ajuster
		    elseif oper isa duplicate  then
		      duplicate(oper).endoper2
		    elseif oper isa Modifier then
		      Modifier(oper).figs.updateoldM
		      oper.ReDeleteDeletedFigures(Modifier(oper).Temp)
		      oper.RecreateCreatedFigures(Modifier(oper).Temp)
		    end if
		    self.Enabled = false
		    dret = nil
		    CurrentContent.isaundoredo = false
		    can.mousecursor = System.Cursors.StandardPointer
		    if oper isa redimensionner then
		      redimensionner(oper).c = nil
		    end if
		  end if
		  
		  can.invalidate
		  
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(oper as SelectOperation)
		  self.oper = oper
		  can.MouseCursor = system.cursors.wait
		  niter = 60
		  pas = niter
		  BPInter = oper.VectInter(niter)
		  Mode=2
		  period=50
		  enabled = true
		  
		  
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
		BPInter As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		Can As CustomCanvas1
	#tag EndProperty

	#tag Property, Flags = &h0
		niter As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		oper As SelectOperation
	#tag EndProperty

	#tag Property, Flags = &h0
		pas As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Mode"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Off"
				"1 - Single"
				"2 - Multiple"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="niter"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="pas"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Period"
			Visible=true
			Group="Behavior"
			InitialValue="1000"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
