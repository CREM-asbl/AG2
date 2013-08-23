#tag Class
Protected Class TransfosList
	#tag Method, Flags = &h0
		Sub TransfosList()
		  
		  CurrentTransfo = nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPosition(tsf as transformation) As Integer
		  
		  dim i as Integer
		  
		  
		  for i=0 to UBound(Transfos)
		    if  tsf.Equal(Transfos(i)) then
		      return i
		    end if
		  next
		  
		  return -1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddTsf(tsf as Transformation)
		  if tsf <> nil and GetPosition(tsf)  = -1 then
		    Transfos.append tsf
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveTsf(tsf as transformation)
		  dim pos as integer
		  
		  pos = GetPosition(tsf)
		  
		  if pos <> -1 then
		    Transfos.remove Pos
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnableModifyall()
		  dim i as integer
		  
		  for i = 0 to ubound(transfos)
		    transfos(i).modified = false
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function count() As integer
		  return ubound(transfos)+1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function element(n as integer) As transformation
		  if n >= 0 and n <= Ubound(Transfos) then
		    return Transfos(n)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HideAll()
		  dim i as integer
		  
		  for i=0 to UBound(Transfos)
		    Transfos(i).Hidden = true
		  next
		  
		  //Utilisé uniquement après le choix d'une tsf à appliquer
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowAll()
		  dim i as integer
		  
		  for i=0 to UBound(Transfos)
		    Transfos(i).Hidden = false
		  next
		  
		  //On montre les tsf qui ne sont pas cachées par Hidden2
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CleanConstructedFigs()
		  dim i as integer
		  
		  for i = 0 to count -1
		    element(i).cleanConstructedFigs
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetTsf(p as basicPoint, Byref TsfL as TransfosList)
		  
		  dim i as integer
		  dim s as shape
		  
		  
		  for i = 0 to count-1
		    s = element(i).supp
		    if  s.pInShape(p) then
		      if element(i).type > 0 and (s isa point or  element(i).index = element(i).supp.pointonside(p)) then
		        TsfL.AddTsf element(i)
		      end if
		    end if
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Unhighlightall()
		  dim i as integer
		  
		  for i =0 to ubound(transfos)
		    transfos(i).unhighlight
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
		Transfos(-1) As Transformation
	#tag EndProperty

	#tag Property, Flags = &h0
		DrapShowALL As Boolean
	#tag EndProperty


	#tag ViewBehavior
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
			Name="DrapShowALL"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
