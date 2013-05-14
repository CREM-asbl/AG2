#tag Class
Protected Class HexGrid
Inherits Grid
	#tag Method, Flags = &h0
		Function GridMagnetism(ByRef p As BasicPoint) As Integer
		  dim a, b, a0, b0 as double
		  dim r , d as double
		  dim u, v, q as BasicPoint
		  
		  r = sqrt(3)
		  u = new BasicPoint(1,0)
		  v = new BasicPoint(0.5,r/2)
		  
		  
		  a = p.x-p.y/r
		  b = 2*p.y/r
		  a0 = a - floor(a)
		  b0 = b-floor(b)
		  
		  if 2*a0+b0 < 1 and 2*b0+a0 < 1 then
		    q = u * floor(a) + v * floor(b)
		  elseif 2*a0+b0 > 2 and 2*b0+a0 > 2 then
		    q = u*(floor(a)+1) + v*(floor(b)+1)
		  elseif a0> b0 then
		    q = u*(floor(a)+1) + v*floor(b)
		  else
		    q = u* floor(a) + v*(floor(b)+1)
		  end if
		  
		  p = q-p
		  d =  PointPriority  - (p*p)*(can.scaling*can.scaling)
		  p = q
		  return d
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Print(g as graphics, sc as double)
		  dim r1 as double
		  dim i,j as integer
		  dim p as BasicPoint
		  dim u,v as double
		  
		  r1 = sqrt(3)
		  
		  computelimits
		  
		  for i = ceil(x0) to floor(x1)
		    for j = ceil(y0) to floor(y1/r1-0.5)
		      p = can.transform(new Basicpoint(i,j*r1))
		      u = (p.x-Gs)*sc
		      v = (p.y-Gs)*sc
		      if  u > 0 and u < can.width*sc and v > 0 and v < can.height*sc then
		        g.Fillrect(u, v,Gs,Gs)
		      end if
		      p = can.transform(new BasicPoint(i+0.5,(j+0.5)*r1))
		      u = (p.x-Gs)*sc
		      v = (p.y-Gs)*sc
		      if  u > 0 and u < can.width*sc and v > 0 and v < can.height*sc then
		        g.Fillrect(u, v,Gs,Gs)
		      end if
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HexGrid(taillepoints as Integer, r as double)
		  HexGrid (taillepoints)
		  rapport = r
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos As TextOutputStream)
		  tos.writeline("reseautriangulaire")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HexGrid(taille as integer)
		  Grid(taille)
		  type = 2
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
