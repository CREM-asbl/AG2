#tag Class
Protected Class CubeSkull
Inherits NSkull
	#tag Method, Flags = &h0
		Sub Constructor(p as BasicPoint, f as integer, k as integer)
		  dim cs as curveshape
		  dim fs as figureshape
		  dim i as integer
		  dim M as Rotationmatrix
		  dim bp(-1),q as BasicPoint
		  
		  
		  ref = p
		  x = 0
		  y = 0
		  borderwidth = 1
		  border = 100
		  fs = new figureshape
		  
		  bp.append new BasicPoint(0,0)
		  
		  select case f                                                        //f est le mode
		  case 0, 2
		    bp.append new BasicPoint(k,0)
		    bp.append new BasicPoint(k+0.5,-0.2)
		    bp.append new BasicPoint(k+0.5,-1.2)
		    bp.append new BasicPoint(0.5,-1.2)
		    bp.append new BasicPoint(0,-1)
		    bp.append new BasicPoint(k,-1)
		    bp.append new BasicPoint(0.5,-0.2)
		  case 1
		    M = new RotationMatrix (new BasicPoint(0,-1), -PI/3)
		    for i = 1 to 5
		      q = bp(i-1)
		      bp.append M*q
		    next
		    bp.append new BasicPoint(0,-1)
		  end select
		  
		  for i = 0 to 5
		    append new curveshape
		    item(i).X = bp(i).X
		    item(i).Y = bp(i).Y
		    
		    Item(i).X2 = bp((i+1) mod 6).X
		    Item(i).Y2 = bp((i+1) mod 6).Y
		  next
		  
		  for i = 0 to 2
		    append new curveshape
		    Item(5+i).X = bp(6).X
		    Item(5+i).Y = bp(6).Y
		    Item(5+i).X2 = bp(2*i+1-(f mod 2) ).X
		    Item(5+i).Y2 = bp(2*i+1-(f mod 2) ).Y
		  next
		  if f = 2  then
		    for i = 0 to 2
		      append new curveshape
		      Item(7+i).X = bp(7).X
		      Item(7+i).Y = bp(7).Y
		      Item(7+i).X2 = bp(2*i).X
		      Item(7+i).Y2 = bp(2*i).Y
		      append cs
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCote(i as integer) As curveshape
		  
		  if i < 6 then
		    return  item(i)
		  else
		    return item(i-5) 
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim i as integer
		  dim fs as figureshape
		  dim cs as curveshape
		  
		  g.drawobject self, ref.x, ref.y
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update(p as BasicPoint, m as integer)
		  dim cs, cs0 as curveshape
		  dim fs as figureshape
		  dim i as integer
		  
		  ref = p
		  if m = 1 then
		    item(1).X2 = p.X
		    item(1).Y2 = p.Y
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updatebordercolors(colcotes() as couleur)
		  dim i as integer
		  
		  
		  For i = 0 to 5
		    item(i).Bordercolor = colcotes(i).col
		  next
		  
		  for i = 1 to count-1
		    item(i).Bordercolor = colcotes(5+i).col
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateBorderwidth(w as double)
		  dim i as integer
		  
		  Borderwidth = w
		  
		  
		  
		  For i = 0 to 5
		    item(i).Borderwidth = w
		  next
		  
		  for i = 1 to count-1
		    item(i).Borderwidth = w
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesommet(n as integer, p as BasicPoint, m as integer)
		  dim cs, cs0 as curveshape
		  dim i as integer
		  
		  if n < 6 then
		    item(n).X=p.x
		    item(n).Y=p.y
		    if n <> 0 then
		      item(n-1).X2=p.x
		      item(n-1).Y2=p.y
		    end if
		    if  n = 5  then
		      item(5).X2 = item(0).X
		      item(5).Y2 = item(0).Y
		    end if
		    i = n+m-1
		    if i mod 2 = 0 then
		      i = i/2
		      item(i+1).X2 = p.X
		      item(i+1).Y2 = p.Y
		    end if
		  end if
		  
		  if n = 6 then
		    for i = 1 to 3
		      item(i).X = p.X
		      item(i).y = p.Y
		      item(i).X2 = item(2*i-1-m).X
		      item(i).Y2 =item(2*i-1-m).Y
		    next
		  end if
		  
		  if n = 7 then
		    for i = 4 to 6
		      item(i).X = p.X
		      item(i).y = p.Y
		      item(i).X2 =item(2*(i-4)).X
		      item(i).Y2 = item(2*(i-4)).Y
		    next
		  end if
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
