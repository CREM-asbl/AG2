#tag Class
Protected Class Couleur
	#tag Method, Flags = &h0
		Function b() As integer
		  return col.Blue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function c() As double
		  return col.cyan
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function comp() As couleur
		  return new couleur (255-r,255-g,255-b)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(col as color)
		  self.col = col
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(rouge as integer, vert as integer, bleu as integer)
		  col =  RGB(rouge, vert, bleu)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Temp as XMLElement)
		  col = RGB(Val(Temp.GetAttribute(Dico.Value("Rouge"))),Val(Temp.GetAttribute(Dico.Value("Vert"))),Val(Temp.GetAttribute(Dico.Value("Bleu"))))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function equal(c as couleur) As boolean
		  return col = c.col
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function g() As integer
		  return col.green
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function m() As double
		  return col.magenta
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Moyenne(c2 as couleur) As couleur
		  return new couleur((r+c2.r)/2, (g+c2.g)/2, (b+c2.b)/2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function r() As integer
		  return col.red
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToEPS() As string
		  select case col
		  case RGB(0,0,0), CMY(1,1,1)
		    return "noir"
		  case RGB(255,255,0), CMY(0,0,1)
		    return "jaune"
		  case RGB(255,0,255), CMY(0,1,0)
		    return "magenta"
		  case RGB(0,255,255) , CMY(1,0,0)
		    return "cyan"
		  case RGB(255,0,0), CMY(0,1,1)
		    return "rouge"
		  case RGB(0,255,0), CMY(1,0,1)
		    return "vert"
		  case RGB(0,0,255), CMY(1,1,0)
		    return "bleu"
		  case RGB(255,255,255), CMY(0,0,0)
		    return "blanc"
		  else
		    if r = g and r = b then
		      return "[ 0 0 0 " + str(1-r/255) +" ]"
		    else
		      return  "[" + str(c) + " "+  str(m) + " "+ str(y) + " 0 ]"
		    end if
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument, Name as string) As XMLElement
		  dim Temp as XMLElement
		  
		  Temp = Doc.CreateElement(Name)
		  Temp.SetAttribute(Dico.value("Rouge"), str(r))
		  Temp.SetAttribute(Dico.Value("Vert"), str(g))
		  Temp.SetAttribute(Dico.Value("Bleu"), str(b))
		  return Temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function y() As double
		  return col.yellow
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
		col As color
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="col"
			Visible=false
			Group="Behavior"
			InitialValue="&h000000"
			Type="color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
