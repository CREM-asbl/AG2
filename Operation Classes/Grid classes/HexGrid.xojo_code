#tag Class
Protected Class HexGrid
Inherits Grid
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit)) or  (TargetAndroid and (Target64Bit))
	#tag Method, Flags = &h0
		Sub Constructor(taille as integer)
		  super.constructor(taille)
		  type = 2
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(taillepoints as Integer, r as double)
		  constructor(taillepoints)
		  rapport = r
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GridMagnetism(ByRef p As BasicPoint) As Integer
		  dim a, b, a0, b0 as double
		  dim r , d as double
		  dim u, v, q as BasicPoint
		  
		  r = sqrt(3)*rapport
		  u = new BasicPoint(1*rapport,0)
		  v = new BasicPoint(0.5*rapport, r/2)
		  
		  a = Round(2*p.y/r)
		  
		  if a Mod 2 = 0 then
		    q = new BasicPoint(Round(p.x/rapport)*rapport, a*r/2)
		  else
		    b = Round(2*p.x/rapport)
		    if b Mod 2 = 0 then 
		      if (p.x >= b*rapport/2) then
		        b = b + 1
		      else 
		        b = b - 1
		      end if
		    end if
		    q = new BasicPoint(b*rapport/2, a*r/2)
		  end if
		  
		  p = q-p
		  d = PointPriority - (p*p)*(can.scaling*can.scaling)
		  p = q
		  return d
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Print(g as graphics, sc as double)
		  dim i, j, r1 as double
		  dim p as BasicPoint
		  dim u,v as double
		  
		  r1 = sqrt(3)
		  
		  computelimits
		  
		  for i = ceil(x0/sc)*sc to floor(x1/sc)*sc step sc
		    for j = ceil(y0/sc)*sc to floor(y1/sc)*sc step sc
		      p = can.transform(new Basicpoint(i,j*r1))
		      u = (p.x-Gs)
		      v = (p.y-Gs)
		      if  u > 0 and u < can.width and v > 0 and v < can.height then
		        g.Fillrect(u, v, Gs, Gs)
		      end if
		      p = can.transform(new BasicPoint(i + 0.5*sc,(j + 0.5*sc)*r1))
		      u = (p.x-Gs)
		      v = (p.y-Gs)
		      if  u > 0 and u < can.width and v > 0 and v < can.height then
		        g.Fillrect(u, v, Gs, Gs)
		      end if
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos As TextOutputStream)
		  tos.writeline("reseautriangulaire")
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
			Name="gs"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
			Name="rapport"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
			Name="type"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="x0"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="x1"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="y0"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="y1"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
