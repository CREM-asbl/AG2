#tag Class
Protected Class Matrix
Implements StringProvider
	#tag Method, Flags = &h0
		Sub Matrix(u1 as BasicPoint, u2 As BasicPoint, u3 As BasicPoint)
		  v1 = u1
		  v2 = u2
		  v3 = u3
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Add(M AS Matrix) As Matrix
		  dim u1, u2, u3 as BasicPoint
		  u1 = M.v1
		  u2 = M.v2
		  u3=M.v3
		  return new Matrix(v1+u1,v2+u2,v3+u3)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Subtract(M as Matrix) As Matrix
		  dim u1, u2,u3 as BasicPoint
		  u1 = M.v1
		  u2 = M.v2
		  u3=M.v3
		  return new Matrix(v1-u1,v2-u2,v3-u3)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Multiply(r as double) As matrix
		  
		  dim u1, u2, u3 as basicPoint
		  
		  u1 = v1*r
		  u2 = v2*r
		  u3 = v3*r
		  
		  return new Matrix(u1, u2, u3)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function det() As double
		  return v1.x*v2.y-v1.y*v2.x
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Trace() As double
		  return v1.x+v2.y
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Multiply(v as BasicPoint) As BasicPoint
		  return new BasicPoint(v1.x*v.x+v2.x*v.y+v3.x,v1.y*v.x+v2.y*v.y+v3.y)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Multiply(ByRef M As Matrix) As Matrix
		  dim u1, u2, u3 , w1, w2, w3 as BasicPoint
		  
		  w1 = M.v1
		  w2 = M.v2
		  w3 = M.v3
		  u1 = new BasicPoint(v1.x*w1.x+v2.x*w1.y, v1.y*w1.x+v2.y*w1.y)
		  u2 = new BasicPoint(v1.x*w2.x+v2.x*w2.y, v1.y*w2.x+v2.y*w2.y)
		  u3 = self*w3
		  return new Matrix(u1,u2,u3)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function inv() As Matrix
		  dim u1,u2,u3 as BasicPoint
		  dim delta as double
		  
		  delta = det
		  if delta <>0 then
		    delta = 1/delta
		    u1 = new BasicPoint(v2.y, -v1.y)
		    u1 = u1*delta
		    u2 = new BasicPoint(-v2.x,v1.x)
		    u2 = u2*Delta
		    u3 = new BasicPoint(v2.x*v3.y-v2.y*v3.x,v1.y*v3.x-v1.x*v3.y)
		    u3 = u3*delta
		    return new Matrix(u1,u2,u3)
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Null() As Boolean
		  return (v1 = nil) or (v2 = nil) or (v3 = nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Matrix(r as double)
		  v1 = new basicpoint(r,0)
		  v2 = new basicpoint(0,r)
		  v3 = new basicpoint(0,0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Conjugate(M as Matrix) As Matrix
		  // Calcul de M*self*M^-1
		  
		  dim M1 as Matrix
		  
		  if M.det = 0 then
		    return nil
		  else
		    M1 = M.inv
		    M1 = self*M1
		    return M*M1
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Equal(M as Matrix) As Boolean
		  dim t as boolean
		  
		  t = true
		  t = t and (v1.x = M.v1.x)
		  t = t and (v1.y = M.v1.y)
		  t = t and (v2.x = M.v2.x)
		  t = t and (v2.y = M.v2.y)
		  t = t and (v3.x = M.v3.x)
		  t = t and (v3.y = M.v3.y)
		  
		  return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TranslaterOrigine() As Matrix
		  dim u1, u2, u3 as BasicPoint
		  
		  u1 = v1
		  u2 = v2
		  u3 = new BasicPoint(0,0)
		  
		  return new Matrix(u1,u2,u3)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Translater(p as Basicpoint) As Matrix
		  // On suppose que la matrice donnée admet l'origine comme point fixe.
		  
		  dim T as TranslationMatrix
		  
		  T = new TranslationMatrix(p)
		  return Conjugate(T)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLPutAttribute(Temp as XMLElement)
		  Temp.SetAttribute("Data00",str(v1.x))
		  Temp.SetAttribute("Data01",str(v1.y))
		  Temp.SetAttribute("Data10",str(v2.x))
		  Temp.SetAttribute("Data11",str(v2.y))
		  Temp.SetAttribute("Data20",str(v3.x))
		  Temp.SetAttribute("Data21",str(v3.y))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getString() As String
		  dim s as String
		  
		  s = "v1 "+ v1.getString+EndOfLine
		  s = s+ "v2 "+ v2.getString+EndOfLine
		  s = s+ "v3 "+ v3.getString+EndOfLine
		  return s
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Matrix(M as Matrix)
		  v1 = new BasicPoint(M.v1)
		  v2 = new BasicPoint (M.v2)
		  v3 = new BasicPoint(M.v3)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Matrix(Tmp as XMLElement)
		  dim x, y as double
		  x = val(Tmp.GetAttribute("Data00"))
		  y = val(Tmp.GetAttribute("Data01"))
		  v1 = new BasicPoint(x,y)
		  x = val(Tmp.GetAttribute("Data10"))
		  y = val(Tmp.GetAttribute("Data11"))
		  v2 = new BasicPoint(x,y)
		  x = val(Tmp.GetAttribute("Data20"))
		  y = val(Tmp.GetAttribute("Data21"))
		  v3 = new BasicPoint(x,y)
		  
		  
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
		v1 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		v2 As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		v3 As BasicPoint
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
	#tag EndViewBehavior
End Class
#tag EndClass
