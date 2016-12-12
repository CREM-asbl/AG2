#tag Class
Protected Class MatrixnD
	#tag Method, Flags = &h0
		Sub Constructor(n As integer)
		  nc = n
		  
		  redim col(-1,-1)
		  redim col(nc-1,nc-1)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(n as integer, m as double)
		  dim i as integer
		  
		  Constructor(n)
		  
		  
		  for i = 0 to nc-1
		    col(i,i) = m
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FermetureTransitive() As MatrixnD
		  dim i, j, k as integer
		  dim MT, M1 as MatrixnD
		  
		  
		  M1 = self
		  MT = self
		  if nc = 1 then
		    return self
		  end if
		  
		  for i = 1 to nc-1
		    M1 = self*M1
		    MT = MT + M1
		  next
		  
		  for j =0 to nc-1
		    for k = 0 to nc-1
		      if MT.col(j,k) >0 then
		        MT.col(j,k) = 1
		      end if
		    next
		  next
		  
		  return MT
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Null() As Boolean
		  dim t as boolean
		  dim i,j as integer
		  
		  t = true
		  i = 0
		  j = 0
		  
		  while t  and i < nc
		    t = t and col(i,j) =0
		    j = j+1
		    if j = nc then
		      j = 0
		      i = i+1
		    end if
		  wend
		  
		  
		  return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Add(M as MatrixnD) As MatrixnD
		  dim i, j as integer
		  dim M1 as MatrixnD
		  
		  M1 = new MatrixnD(nc)
		  
		  for i = 0 to nc-1
		    for j = 0 to nc-1
		      M1.col(i,j) = col(i,j)+M.col(i,j)
		    next
		  next
		  
		  return M1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Multiply(M as MatrixnD) As MatrixnD
		  dim i, j, k as integer
		  dim M1 as MatrixnD
		  
		  if M.nc <> nc then
		    return nil
		  end if
		  
		  M1 = new MatrixnD(nc)
		  
		  for i = 0 to nc-1
		    for j = 0 to nc-1
		      for k = 0 to nc-1
		        M1.col(i,j) = M1.col(i,j) + col(i,k)*M.col(k,j)
		      next
		    next
		  next
		  
		  return M1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SommCol(k as integer) As Double
		  dim r as double
		  dim i as integer
		  
		  r = 0
		  for i = 0 to nc-1
		    r = r+Col(i,k)
		  next
		  
		  return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Trace() As double
		  dim i  as integer
		  dim tr as double
		  
		  for i = 0 to nc-1
		    tr = tr+col(i,i)
		  next
		  return tr
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


	#tag Property, Flags = &h0
		Col(-1,-1) As double
	#tag EndProperty

	#tag Property, Flags = &h0
		nc As Integer
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
			Name="nc"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
