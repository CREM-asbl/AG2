#tag Class
Protected Class TriDPoint
	#tag Method, Flags = &h0
		Sub TriDPoint(p as Basicpoint)
		  x = p.x
		  y = p.y
		  z = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Projplan() As Basicpoint
		  return new BasicPoint(x,y)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Add(p as TriDPoint) As TriDPoint
		  return new TriDPoint(x+p.x, y+p.y, z+p.z)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TridPoint(px as double, py as double, pz as double)
		  x = px
		  y = py
		  z = pz
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Subtract(p as TriDpoint) As TriDPoint
		  return new TriDPoint(x-p.x,y-p.y,z-p.z)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Multiply(k as double) As TriDPoint
		  return new TriDPoint(x*k, y*k, z*k)
		End Function
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
		x As double
	#tag EndProperty

	#tag Property, Flags = &h0
		y As double
	#tag EndProperty

	#tag Property, Flags = &h0
		z As double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="x"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="y"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="z"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
