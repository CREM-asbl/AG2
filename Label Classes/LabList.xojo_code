#tag Class
Protected Class LabList
	#tag Method, Flags = &h0
		Sub AddLab(Lab as Etiq)
		  if Lab <> nil then
		    if (not lab.chape isa repere and GetPosition(Lab)  = -1) or  (lab.chape isa repere and Getlab(lab.correction) = nil) then
		      Labs.append Lab
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function count() As integer
		  return ubound(Labs)+1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function element(n as integer) As Etiq
		  if n >= 0 and n <= Ubound(Labs) then
		    return  Labs(n)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLab(corr as BasicPoint) As Etiq
		  dim i as Integer
		  dim scale as double
		  
		  scale = wnd.mycanvas1.scaling
		  
		  for i=0 to UBound(Labs)
		    if corr.distance(Labs(i).correction) < Config.magneticdist/scale then
		      return Labs(i)
		    end if
		  next
		  
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLab(loc as integer) As Etiq
		  dim i as Integer
		  
		  
		  for i=0 to UBound(Labs)
		    
		    if Labs(i).loc = loc  then
		      return Labs(i)
		    end if
		    
		  next
		  
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPosition(Lab as Etiq) As Integer
		  
		  return labs.indexof (lab)
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
		    for i =0 to UBound(Labs)
		      if Labs(i).correction = lab.correction  then
		        exists  = true
		      end if
		    next
		  else
		    for i =0 to UBound(Labs)
		      if Labs(i).loc = loc  then
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

	#tag Method, Flags = &h0
		Sub Removeall()
		  redim labs(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveLab(Lab as Etiq)
		  dim pos as integer
		  
		  pos = GetPosition(Lab)
		  
		  if pos <> -1 then
		    Labs.remove Pos
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
		Labs(-1) As Etiq
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
