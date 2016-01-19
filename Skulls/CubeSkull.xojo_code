#tag Class
Protected Class CubeSkull
Inherits Skull
	#tag Method, Flags = &h0
		Sub Constructor(p as BasicPoint, f as integer, k as integer)
		  dim cs as curveshape
		  dim fs as figureshape
		  dim i as integer
		  dim M as Rotationmatrix
		  dim bp(-1),q as BasicPoint
		  
		  CC = new Group2D
		  ref = p
		  CC.x = 0
		  CC.y = 0
		  CC.borderwidth = 1
		  CC.border = 100
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
		    cs = new curveshape
		    cs.X = bp(i).X
		    cs.Y = bp(i).Y
		    
		    cs.X2 = bp((i+1) mod 6).X
		    cs.Y2 = bp((i+1) mod 6).Y
		    fs.append cs
		  next
		  Group2D(CC).append fs
		  for i = 0 to 2
		    cs = new curveshape
		    cs.X = bp(6).X
		    cs.Y = bp(6).Y
		    cs.X2 = bp(2*i+1-(f mod 2) ).X
		    cs.Y2 = bp(2*i+1-(f mod 2) ).Y
		    Group2D(CC).append cs
		  next
		  if f = 2  then
		    for i = 0 to 2
		      cs = new curveshape
		      cs.X = bp(7).X
		      cs.Y = bp(7).Y
		      cs.X2 = bp(2*i).X
		      cs.Y2 = bp(2*i).Y
		      Group2D(CC).append cs
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCote(i as integer) As curveshape
		  dim fs as figureshape
		  if i < 6 then
		    fs = figureshape(Group2D(CC).item(0))
		    return  curveshape(fs.item(i))
		  else
		    return curveshape(Group2D(CC).item(i-5))
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim i as integer
		  dim fs as figureshape
		  dim cs as curveshape
		  
		  fs = figureshape(Group2D(CC).item(0))
		  
		  fs.fillcolor = CC.fillcolor
		  fs.fill = cc.fill
		  g.drawobject fs, ref.x, ref.y
		  
		  For i = 0 to 5
		    cs = fs.item(i)
		    cs.Borderwidth = CC.borderwidth
		    cs.Border = CC.border
		    g.drawobject cs, ref.x, ref.y
		  next
		  
		  for i = 1 to Group2D(cc).count-1
		    cs = curveshape(Group2D(CC).item(i))
		    cs.Borderwidth = CC.borderwidth
		    cs.Border = CC.border
		    g.drawobject cs, ref.x, ref.y
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update(p as BasicPoint, m as integer)
		  dim cs, cs0 as curveshape
		  dim fs as figureshape
		  dim i as integer
		  
		  ref = p
		  if m = 1 then
		    cs = CurveShape(Group2D(CC).item(1))
		    cs.X2 = p.X
		    cs.Y2 = p.Y
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updatebordercolors(colcotes() as couleur)
		  dim i as integer
		  dim fs as figureshape
		  dim cs as curveshape
		  
		  fs = figureshape(Group2D(CC).item(0))
		  
		  For i = 0 to 5
		    cs = fs.item(i)
		    cs.Bordercolor = colcotes(i).col
		  next
		  
		  for i = 1 to Group2D(CC).count-1
		    cs = curveshape(Group2D(CC).item(i))
		    cs.Bordercolor = colcotes(5+i).col
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateBorderwidth(w as double)
		  dim i as integer
		  dim fs as figureshape
		  dim cs as curveshape
		  
		  CC.Borderwidth = w
		  
		  fs = figureshape(Group2D(CC).item(0))
		  
		  For i = 0 to 5
		    cs = fs.item(i)
		    cs.Borderwidth = w
		  next
		  
		  for i = 1 to Group2D(CC).count-1
		    cs = curveshape(Group2D(CC).item(i))
		    cs.Borderwidth = w
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesommet(n as integer, p as BasicPoint, m as integer)
		  dim cs, cs0 as curveshape
		  dim fs as figureshape
		  dim i as integer
		  
		  fs = figureshape(Group2D(CC).item(0))
		  if n < 6 then
		    cs = fs.item(n)
		    cs.X=p.x
		    cs.Y=p.y
		    if n <> 0 then
		      cs = fs.item(n-1)
		      cs.X2=p.x
		      cs.Y2=p.y
		    end if
		    if  n = 5  then
		      cs = fs.item(5)
		      cs0 = fs.item(0)
		      cs.X2 = cs0.X
		      cs.Y2 = cs0.Y
		    end if
		    i = n+m-1
		    if i mod 2 = 0 then
		      i = i/2
		      cs = CurveShape(Group2D(CC).item(i+1))
		      cs.X2 = p.X
		      cs.Y2 = p.Y
		    end if
		  end if
		  
		  if n = 6 then
		    for i = 1 to 3
		      cs = curveshape(Group2D(CC).item(i))
		      cs.X = p.X
		      cs.y = p.Y
		      cs.X2 = fs.item(2*i-1-m).X
		      cs.Y2 = fs.item(2*i-1-m).Y
		    next
		  end if
		  
		  if n = 7 then
		    for i = 4 to 6
		      cs = curveshape(Group2D(CC).item(i))
		      cs.X = p.X
		      cs.y = p.Y
		      cs.X2 = fs.item(2*(i-4)).X
		      cs.Y2 = fs.item(2*(i-4)).Y
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
