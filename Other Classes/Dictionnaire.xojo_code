#tag Class
Protected Class Dictionnaire
Inherits Dictionary
	#tag Method, Flags = &h0
		Sub load(lang as string)
		  dim C as XMLDocument
		  dim fi as FolderItem
		  dim EL, EL1, EL2 as XMLElement
		  dim Key as variant
		  dim  Txt, Name as string
		  dim i, j as integer
		  
		  select case lang
		  case "Francais"
		    C = new XMLDocument(Francais)
		  case "English"
		    C = new XMLDocument(English)
		  case "PortuguesBr"
		    C = new XMLDocument(PortuguesBr)
		  else
		    Name = lang+".dct"
		    fi = app.DctFolder.Child(Name)
		    if not fi.exists then
		      MsgBox Dico.Value("FileMenu") + " " + Name + " " + Dico.Value("Introuvable")
		      return
		    else
		      C=new XMLDocument(fi)
		    end if
		  end select
		  
		  
		  EL = C.DocumentElement
		  
		  for i = 0 to EL.Childcount -1
		    EL1 = XMLElement(EL.Child(i))
		    for j = 0 to EL1.Childcount -1
		      EL2 = XMLElement(EL1.Child(j))
		      Key = EL2.Name
		      Txt = EL2.GetAttribute("Name")
		      Dico.Value(Key)=Txt
		    next j
		  next i
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function value(code As string) As string
		  if haskey(code) then
		    return dictionary.value(code)
		  else
		    return code
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
			Name="BinCount"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
