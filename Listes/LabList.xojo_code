#tag Class
Protected Class LabList
Inherits Liste
	#tag Method, Flags = &h0
		Sub AddObject(Lab as Etiq)
		  if Lab <> nil then
		    if (not lab.chape isa repere and GetPosition(Lab)  = -1) or  (lab.chape isa repere and Getlab(lab.correction) = nil) then
		      Objects.append Lab
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLab(corr as BasicPoint) As Etiq
		  dim i as Integer
		  dim scale as double
		  
		  scale = can.scaling
		  
		  for i=0 to UBound(Objects)
		    if corr.distance(Etiq(Objects(i)).correction) < Config.magneticdist/scale then
		      return Objects(i)
		    end if
		  next
		  
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLab(loc as integer) As Etiq
		  dim i as Integer
		  
		  
		  for i=0 to UBound(Objects)
		    
		    if Etiq(objects(i)).loc = loc  then
		      return objects(i)
		    end if
		    
		  next
		  
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function item(n as integer) As Etiq
		  if n >= 0 and n <= Ubound(objects) then
		    return  Etiq(objects(n))
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function newlab(Temp as XMLElement, sh as shape) As etiq
		  dim loc, i as integer
		  dim s as string
		  dim exists as Boolean
		  dim Lab as Etiq
		  
		  loc = -1
		  s = Temp .GetAttribute("Side")
		  
		  if s = "-1" then
		    loc = -1
		  elseif s<> "" then
		    loc = val(s)
		  end if
		  
		  Lab = new Etiq(loc,temp)
		  
		  if sh isa repere then
		    for i =0 to UBound(Objects)
		      if Etiq(Objects(i)).correction = lab.correction  then
		        exists  = true
		      end if
		    next
		  else
		    for i =0 to UBound(Objects)
		      if Etiq(Objects(i)).loc = loc  then
		        exists  = true
		      end if
		    next
		  end if
		  
		  if exists then
		    return nil
		  else
		    return lab
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
