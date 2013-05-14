#tag Class
Protected Class ProjectionMatrix
Inherits Matrix
	#tag Method, Flags = &h0
		Sub OrthoProjectionMatrix(a as BasicPoint, b as BasicPoint)
		  dim d , n as double
		  dim u as basicpoint
		  
		  d = b.sqrdistance(a)
		  
		  if a <> nil and b <> nil and d > epsilon then
		    u = b-a
		    n = 1 /d
		    v1 = u*((u.x)*n)
		    v2 = u*((u.y)*n)
		    v3 = a - u* (a*u)/d^2
		    
		    'v1 = new BasicPoint((b.x-a.x)*(b.x-a.x),(b.x-a.x)*(b.y-a.y))
		    'v2 = new BasicPoint((b.x-a.x)*(b.y-a.y),(b.y-a.y)*(b.y-a.y))
		    'v1 = v1/d
		    'v2 = v2/d
		    'v3 = a - v1*a.x -v2*a.y
		    
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
	#tag EndViewBehavior
End Class
#tag EndClass
