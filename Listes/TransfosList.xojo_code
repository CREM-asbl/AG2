#tag Class
Protected Class TransfosList
Inherits Liste
	#tag Method, Flags = &h0
		Sub CleanConstructedFigs()
		  dim i as integer
		  
		  for i = 0 to count -1
		    item(i).cleanConstructedFigs
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnableModifyall()
		  dim i as integer
		  
		  for i = 0 to ubound(objects)
		    Transformation(objects(i)).modified = false
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetTsf(p as basicPoint, Byref TsfL as TransfosList)
		  
		  dim i as integer
		  dim s as shape
		  
		  
		  for i = 0 to count-1
		    s = item(i).supp
		    if  s.pInShape(p) then
		      if item(i).type > 6 then
		        TsfL.AddObject item(i)
		      else
		        if item(i).type > 0 and (s isa point or  item(i).index = item(i).supp.pointonside(p)) then  's est un point ou p est sur le "bon coté" du support
		          TsfL.AddObject item(i)
		        end if
		      end if
		    end if
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HideAll()
		  dim i as integer
		  
		  for i=0 to UBound(Objects)
		    Transformation(Objects(i)).Hidden = true
		  next
		  
		  //Utilisé uniquement après le choix d'une tsf à appliquer
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function item(n as integer) As transformation
		  return Transformation(element(n))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OldGetPosition(tsf as Transformation) As Integer
		  dim i as Integer
		  
		  if tsf = nil then
		    return -1
		  end if
		  
		  for i=0 to UBound(Objects)
		    if  tsf.Equal(Transformation(Objects(i))) then
		      return i
		    end if
		  next
		  
		  return -1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowAll()
		  dim i as integer
		  
		  for i=0 to UBound(Objects)
		    Transformation(Objects(i)).Hidden = false
		  next
		  
		  //On montre les tsf qui ne sont pas cachées par Hidden2
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Unhighlightall()
		  dim i as integer
		  
		  for i =0 to ubound(objects)
		    Transformation(objects(i)).unhighlight
		  next
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
		CurrentTransfo As Transformation
	#tag EndProperty

	#tag Property, Flags = &h0
		DrapShowALL As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="DrapShowALL"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
	#tag EndViewBehavior
End Class
#tag EndClass
