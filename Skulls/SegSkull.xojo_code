#tag Class
Protected Class SegSkull
Inherits NSkull
	#tag Method, Flags = &h0
		Sub Constructor(p as BasicPoint)
		  
		  X = 0
		  Y = 0
		  append new curveshape
		  item(0).x = 0
		  item(0).y = 0
		  item(0).X2 = 0
		  item(0).Y2 = 0
		  updatesize(1)
		  borderwidth = 1
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fixeepaisseurs(s as shape)
		  '
		  if (s.isinconstruction  or s.selected ) and not s.tracept then
		    item(0).borderwidth = 1.5*s.borderwidth
		  else
		    item(0).borderwidth = s.borderwidth
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g As graphics)
		  g.drawobject item(0), x, y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update(s as shape)
		  dim p, q as BasicPoint
		  
		  fixecouleurs(s)
		  fixeepaisseurs(s)
		  if s isa droite then
		    p =s.getgravitycenter
		    ref = can.transform(p)
		    x = ref.x
		    y = ref.y
		    
		    q= can.dtransform(droite(s).extre1-p)
		    item(0).x=q.x
		    item(0).y=q.y
		    q= can.dtransform(droite(s).extre2-p)
		    item(0).x2=q.x
		    item(0).y2=q.y
		  elseif s isa supphom then
		    p =s.coord.tab(0)
		    ref = can.transform(p)
		    x = ref.x
		    y = ref.y
		    
		    q= can.dtransform(s.coord.tab(1)-p)
		    item(0).x=q.x
		    item(0).y=q.y
		    q= can.dtransform(s.coord.tab(2)-p)
		    item(0).x2=q.x
		    item(0).y2=q.y
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatebordercolor(col as color, c as double)
		  item(0).bordercolor = col
		  item(0).border = c
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateborderwidth(d as double)
		  item(0).borderwidth = d
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
			Name="angle"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderColor"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderWidth"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FillColor"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
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
			Name="Rotation"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Scale"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
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
		#tag ViewProperty
			Name="X"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Y"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
