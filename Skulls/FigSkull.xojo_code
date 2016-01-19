#tag Class
Protected Class FigSkull
Inherits Skull
	#tag Method, Flags = &h0
		Sub addline(u1 as double, v1 as double, u2 as double, v2 as double)
		  FigureShape(CC).addline(u1,v1,u2,v2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub addpoint(p as BasicPoint)
		  dim i as integer
		  
		  cotes.append new curveshape
		  i= UBound(cotes)
		  FigureShape(CC).append cotes(i)
		  cotes(i).order = 0
		  
		  cotes(i).X=p.x
		  cotes(i).Y=p.y
		  
		  if i <> 0 then
		    cotes(i-1).X2=p.x
		    cotes(i-1).Y2=p.y
		  end if
		  
		  'if fin then
		  cotes(i).X2=cotes(0).x     //on referme tjrs le lacet
		  cotes(i).Y2=cotes(0).y    // si voulait définir un chemin, il faudrait utiliser le paramètre booléen "fin"
		  'else
		  'cotes(i).X2=p.x
		  'cotes(i).Y2=p.y
		  'end if
		  'if i <> 0 then
		  'cotes(i-1).border = 100
		  'end if
		  cotes(i).border = 100
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BoundingBox()
		  dim i, n as integer
		  
		  n = ubound(cotes)
		  
		  dlx = cotes(0).X
		  dly = cotes(0).Y
		  urx = cotes(0).X
		  ury = cotes(0).Y
		  for i = 1 to n
		    dlx = min(dlx, cotes(i).X)
		    dly = min(dly, cotes(i).Y)
		    urx = max(urx, cotes(i).X)
		    ury = max(ury, cotes(i).Y)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(p as BasicPoint)
		  CC = new FigureShape
		  ref = p
		  CC.x = 0
		  CC.y = 0
		  CC.borderwidth = 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(p as BasicPoint, n as integer)
		  dim i as integer
		  
		  constructor(p)
		  for i = 0 to n-1
		    cotes.append new curveshape
		    FigureShape(CC).append cotes(i)
		    cotes(i).X = 0
		    cotes(i).Y = 0
		    cotes(i).X2 = 0
		    cotes(i).Y2 = 0
		  next
		  updatesize(1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Curspecs as StdPolygonSpecifications)
		  dim s, p(-1), q as BasicPoint  //Utilisé uniquement pour les icones de la boite à outils
		  dim i, n as integer
		  dim cap as double
		  
		  s = new BasicPoint(0,0)
		  q = new BasicPoint(0,0)
		  n = ubound(curspecs.angles)+2
		  constructor(q)
		  cap = -curspecs.angles(0)
		  p.append q
		  for i = 1 to n-1
		    q = new BasicPoint(cos(cap),sin(cap))
		    q = p(i-1)+ q * Curspecs.distances(i-1)
		    p.append  q
		    if i < n-1 then
		      cap = cap - curspecs.angles(i)
		    end if
		  next
		  
		  for i = 0 to n-1
		    cotes.append new curveshape
		    cotes(i).X=p(i).X
		    cotes(i).Y=p(i).Y
		    if i < n-1 then
		      cotes(i).X2=p(i+1).X
		      cotes(i).Y2=p(i+1).Y
		    else
		      cotes(i).X2=0
		      cotes(i).Y2=0
		    end if
		    FigureShape(CC).append cotes(i)
		  next
		  BoundingBox
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCote(i as integer) As curveshape
		  if  i >-1 and i <= ubound(cotes) then
		    return cotes(i)
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertPoint(p as basicpoint, n as integer)
		  cotes.insert (n,new curveshape)
		  FigureShape(CC).insert (n,cotes(n))
		  
		  cotes(n).X=p.x
		  cotes(n).Y=p.y
		  
		  cotes(n-1).X2=p.x
		  cotes(n-1).Y2=p.y
		  
		  cotes(n).X2=cotes(0).x                '(n+1)mod (Ubound(cotes)+1)).X
		  cotes(n).Y2=cotes(0).y                '(n+1)mod (Ubound(cotes)+1)).Y
		  
		  
		  cotes(n).order = 0
		  cotes(n).border = 100
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Nbcotes() As integer
		  
		  return ubound(cotes)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Paint(g as graphics)
		  dim i as integer
		  
		  super.paint(g)
		  for i = 0 to ubound(cotes)
		    g.drawobject cotes(i), ref.x, ref.y
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemovePoint()
		  dim i as integer
		  
		  i = ubound(cotes)
		  FigureShape(CC).Remove(i)
		  cotes(i-1).X2=cotes(0).X
		  cotes(i-1).Y2=cotes(0).Y
		  cotes(i) = nil
		  cotes.Remove(i)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updatebordercolor(bc as color, b as integer)
		  dim i as integer
		  
		  CC.Bordercolor = bc
		  CC.Border = b
		  for i = 0 to ubound(cotes)
		    updatebordercolor(bc,b,i)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Updatebordercolor(bc as color, b as integer, i as integer)
		  cotes(i).bordercolor = bc
		  cotes(i).Border = b
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateBorderwidth(w as double)
		  dim i as integer
		  
		  CC.Borderwidth = w
		  for i = 0 to ubound(cotes)
		    cotes(i).borderwidth = w
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateSommet(i as integer, p as BasicPoint)
		  dim n As integer
		  
		  n = Ubound(cotes)
		  cotes(i).X=p.x
		  cotes(i).Y=p.y
		  if i <> 0 then
		    cotes(i-1).X2=p.x
		    cotes(i-1).Y2=p.y
		  end if
		  if i = n then
		    cotes(n).X2 = cotes(0).X
		    cotes(n).Y2 = cotes(0).Y
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


	#tag Property, Flags = &h0
		cotes(-1) As CurveShape
	#tag EndProperty

	#tag Property, Flags = &h0
		dlx As double
	#tag EndProperty

	#tag Property, Flags = &h0
		dly As double
	#tag EndProperty

	#tag Property, Flags = &h0
		urx As double
	#tag EndProperty

	#tag Property, Flags = &h0
		ury As double
	#tag EndProperty


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
			Name="dlx"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="dly"
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
			Name="urx"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ury"
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
