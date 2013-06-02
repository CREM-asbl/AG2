#tag Class
Protected Class HomothetyMatrix
Inherits SimilarityMatrix
	#tag Method, Flags = &h0
		Sub HomothetyMatrix(c as BasicPoint, k as double)
		  if c <> nil then
		    
		    v1 = new BasicPoint(k,0)
		    v2 = new BasicPoint(0,k)
		    v3 = c*(1-k)
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HomothetyMatrix(s1 as BasicPoint, s2 as BasicPoint, b1 as BasicPoint, b2 as BasicPoint)
		  dim M1 as TranslationMatrix
		  dim M3 as HomothetyMatrix
		  dim M as matrix
		  dim k, alpha as double
		  dim b3 as BasicPoint
		  
		  
		  if s1 <> nil and s2 <> nil and b1 <> nil and b2 <> nil then
		    if s1 = b1 then
		      HomothetyMatrix(s1,b2.location(s1,s2) )
		    else
		      SimilarityMatrix(s1,s2,b1,b2)
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function rapport() As double
		  return sqrt(det)*sign(trace)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function centre() As basicpoint
		  dim k as double
		  
		  k = rapport
		  
		  if k <> 1 then
		    return v3/(1-k)
		  else
		    return nil
		  end if
		  
		  
		  
		End Function
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
