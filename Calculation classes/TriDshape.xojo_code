#tag Class
Protected Class TriDshape
	#tag Method, Flags = &h0
		Sub Constructor(s as shape, fp as BasicPoint)
		  dim i,j as integer
		  dim se as secteur
		  
		  if s isa point then
		    TriDpts.append new TriDPoint(point(s).bpt-fp)
		  else
		    for j = 0 to ubound(s.childs)
		      TriDpts.append new TriDpoint(s.childs(j).bpt-fp)
		    next
		  end if
		  
		  if (s isa circle or s.narcs > 0) then 
		    for i = 0 to ubound(s.coord.extre)
		      TriDpts.append new TriDPoint(s.coord.extre(i)-fp)
		    next
		    for i = 0 to ubound(s.coord.ctrl)
		      TriDPts.append new TriDPoint(s.coord.Ctrl(i)-fp)
		    next
		  end if
		  '
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
		TriDpts(-1) As Tridpoint
	#tag EndProperty


	#tag ViewBehavior
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
