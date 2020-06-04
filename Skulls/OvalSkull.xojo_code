#tag Class
Protected Class OvalSkull
Inherits OvalShape
	#tag Method, Flags = &h0
		Sub Constructor(r as double, p as BasicPoint)
		  
		  width = 2*r
		  height = 2*r
		  x = 0
		  y = 0
		  ref = p
		  radius = r
		  borderwidth = 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics)
		  g.DrawObject self, 0, 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update(p as Basicpoint, r as double)
		  if not trace then
		    Updateradius(r)
		  else
		    Update(p,Hauteur,true)
		  end if
		  ref = can.transform(p)
		  x = ref.x
		  y = ref.y
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update(p as basicPoint, h as double, ret as Boolean)
		  width = 2*h
		  height = 2*h
		  Hauteur = h
		  trace = ret
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateAngle(a as double)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateborderwidth(r as double)
		  borderwidth = r
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatecolor(col as color, tsp as integer)
		  bordercolor = col
		  border = tsp
		  fillcolor = col
		  fill = tsp
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updateradius(r as double)
		  width = 2*r
		  height = 2*r
		  radius = r
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

	#tag Note, Name = Peindre un point vec drawobject
		
		Placer les coordonnées-écran du point dans l'objet ref de l'ovalskull et dans les variables X et Y de ovalskull
		Le tracé de l'ovalskull prend le centre comme point de référence (X,Y). Pour un point, on utilise donc 
		g.drawobject rsk, 0, 0 
		
		
	#tag EndNote


	#tag Property, Flags = &h0
		Hauteur As double = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		radius As double
	#tag EndProperty

	#tag Property, Flags = &h0
		ref As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		skullof As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		trace As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="BorderOpacity"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FillOpacity"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderColor"
			Visible=false
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderWidth"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FillColor"
			Visible=false
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hauteur"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
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
			Name="radius"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Rotation"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Scale"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Segments"
			Visible=false
			Group="Behavior"
			InitialValue="0"
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
		#tag ViewProperty
			Name="trace"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="X"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Y"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
