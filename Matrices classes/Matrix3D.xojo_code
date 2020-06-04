#tag Class
Protected Class Matrix3D
	#tag Method, Flags = &h0
		Sub Constructor(beta as double, alpha as double)
		  //Rotation d'angle alpha autour d'une droite du plan z = 0 (angle beta avec horizontale)  passant par l'origine
		  
		  dim ca, cb, sa, sb as double
		  
		  ca = cos(alpha)
		  sa = sin(alpha)
		  cb = cos(beta)
		  sb = sin(beta)
		  
		  v1 = new TriDPoint(cb*cb+ca*sb*sb, -sb*cb*(ca-1),-sa*sb)
		  v2 = new TriDPoint(-sb*cb*(ca-1), sb*sb+ca*cb*cb, sa*cb)
		  v3 = new TriDPoint(sa*sb,-sa*cb,ca)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Multiply(v as TriDPoint) As TriDPoint
		  return v1*v.x+v2*v.y+v3*v.z
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
		v1 As TriDPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		v2 As TriDPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		v3 As TriDPoint
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
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
