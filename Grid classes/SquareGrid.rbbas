#tag Class
Protected Class SquareGrid
Inherits Grid
	#tag Method, Flags = &h0
		Function GridMagnetism(ByRef p as BasicPoint) As Integer
		  dim d as double
		  dim q as BasicPoint
		  
		  q = new Basicpoint(round(p.x), round(p.y))
		  p = q-p
		  d =  PointPriority-(p*p)*(can.scaling*can.scaling)
		  p = q
		  return d
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Print(g as graphics, sc as double)
		  dim i, j as integer
		  dim u, v as double
		  dim p as BasicPoint
		  
		  computelimits
		  
		  for i = ceil(x0) to floor(x1)
		    for j = ceil(y0) to floor(y1)
		      p = can.transform(new Basicpoint(i,j))
		      u = floor((p.x-Gs/2)*sc)
		      v = ceil((p.y-Gs/2))*sc
		      if  u > 0 and u < can.width*sc and v > 0 and v < can.height*sc then
		        g.Fillrect(u, v,Gs,Gs)
		      end if
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SquareGrid(taillepoints as integer, r as double)
		  SquareGrid (taillepoints)
		  rapport = r
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos As TextOutputStream)
		  tos.writeline("reseau")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SquareGrid(taille as integer)
		  Grid(taille)
		  type = 1
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
			Name="rapport"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Grid"
		#tag EndViewProperty
		#tag ViewProperty
			Name="type"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Grid"
		#tag EndViewProperty
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
			Name="x0"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Grid"
		#tag EndViewProperty
		#tag ViewProperty
			Name="x1"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Grid"
		#tag EndViewProperty
		#tag ViewProperty
			Name="y0"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Grid"
		#tag EndViewProperty
		#tag ViewProperty
			Name="y1"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Grid"
		#tag EndViewProperty
		#tag ViewProperty
			Name="gs"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Grid"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
