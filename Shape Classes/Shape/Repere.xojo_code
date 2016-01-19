#tag Class
Protected Class Repere
Inherits Shape
	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist)
		  super.constructor(ol,0,0)
		  labs = new Lablist
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, El as XMLElement)
		  dim EL1 as XmlElement
		  dim List as XMLNodeList
		  dim i as integer
		  dim Wi, He as integer
		  dim Ori, Ix, Iy, p As  basicpoint
		  dim kw, kh, k as double
		  
		  super.constructor(ol,EL)
		  List = EL.XQL("Taille_Can")
		  EL1 = XMLElement(List.Item(0))
		  Wi = VAL(EL1.GetAttribute("W"))
		  He = Val(EL1.GetAttribute("H"))
		  List = EL.XQL("Origine")
		  EL1 = XMLElement(List.Item(0))
		  Ori = new BasicPoint(Val(El1.GetAttribute("X")), Val(El1.GetAttribute("Y")))
		  List = EL.XQL("IdX")
		  EL1 = XMLElement(List.Item(0))
		  Ix = new BasicPoint(Val(El1.GetAttribute("X")), Val(El1.GetAttribute("Y")))
		  List = EL.XQL("IdY")
		  EL1 = XMLElement(List.Item(0))
		  Iy = new BasicPoint(Val(El1.GetAttribute("X")), Val(El1.GetAttribute("Y")))
		  
		  'il est nécessaire de mettre à l'échelle car le repère du fichier de sauvegarde n'est pas nécessairement le même que celui
		  'du canvas. Il faut que toute la figure tienne sur le nouvel écran
		  Kw = wnd.Mycanvas1.width/Wi
		  Kh = wnd.Mycanvas1.height/He
		  
		  k = min(kw,kh)
		  
		  if k >= 1 then
		    origine = Ori
		    Idx = Ix
		    Idy = Iy
		  else
		    Idx = Ix*k
		    Idy= Iy*k
		    origine = new BasicPoint(wnd.mycanvas1.width/2, wnd.mycanvas1.height/2)
		    p = new BasicPoint(Wi/2,He/2)
		    origine = origine +(ori-p)*k
		  end if
		  wnd.MyCanvas1.setrepere(self)
		  echelle =  k
		  Hidden = true
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndConstruction()
		  CurrentContent.addshape self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGravitycenter() As basicpoint
		  return new BasicPoint(0,0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.value("Repere")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitConstruction()
		  origine = new BasicPoint(wnd.mycanvas1.width/2,wnd.mycanvas1.height/2)
		  Idx=new BasicPoint(50,0)
		  Idy=new BasicPoint(0,-50)
		  Hidden = true
		  wnd.MyCanvas1.setrepere(self)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Move(M as Matrix)
		  Transform(M)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PaintAll(g as graphics)
		  dim i as integer
		  
		  for i = 0 to labs.count-1
		    labs.element(i).paint(g)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Transform(M as Matrix)
		  if M isa TranslationMatrix then
		    origine = M *origine
		  else
		    Idx = M * Idx
		    Idy = M*Idy
		  end if
		  
		  wnd.mycanvas1.setrepere(self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  dim EL1, Form as XMLElement
		  dim i as integer
		  
		  Form = XMLPutIdInContainer(Doc)
		  
		  EL1 = Doc.CreateElement("Taille_Can")
		  El1.SetAttribute("W",Str(wnd.Mycanvas1.width))
		  EL1.SetAttribute("H",Str(wnd.Mycanvas1.height))
		  Form.appendchild EL1
		  
		  EL1 = Doc.CreateElement("Origine")
		  El1.SetAttribute("X", Str(origine.x))
		  El1.SetAttribute("Y", Str(origine.y))
		  Form.appendchild EL1
		  
		  EL1 = Doc.CreateElement("IdX")
		  El1.SetAttribute("X", Str(IdX.x))
		  EL1.SetAttribute("Y", Str(IdX.y))
		  Form.appendchild EL1
		  
		  EL1 = Doc.CreateElement("IdY")
		  El1.SetAttribute("X", Str(IdY.x))
		  El1.SetAttribute("Y", Str(IdY.y))
		  Form.appendchild EL1
		  
		  Form.AppendChild(Doc.CreateElement(Dico.Value("Hidden")))
		  
		  for i = 0 to labs.count-1
		    form.appendchild labs.element(i).toXML(Doc)
		  next
		  return Form
		  
		End Function
	#tag EndMethod


	#tag Note, Name = Licence
		
		Copyright © Mars 2010 CREM
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
		echelle As double
	#tag EndProperty

	#tag Property, Flags = &h0
		Idx As basicpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		Idy As basicpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		origine As basicpoint
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Attracting"
			Group="Behavior"
			InitialValue="True"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="auto"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Borderwidth"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsw"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="deleted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapori"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="echelle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fam"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="forme"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Highlighted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="id"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IDGroupe"
			Group="Behavior"
			InitialValue="-1"
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
			Name="IndexConstructedPoint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Invalid"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsInConstruction"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="labupdated"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Liberte"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Modified"
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncpts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nonpointed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotPossibleCut"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="npts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ori"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="plan"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="selected"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="signaire"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="std"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tobereconstructed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TracePt"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tsp"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="unmodifiable"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Validating"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
