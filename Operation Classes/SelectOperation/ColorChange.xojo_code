#tag Class
Protected Class ColorChange
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor(B as boolean, col as couleur)
		  super.constructor
		  OpId = 12
		  Bord = B
		  newcolor = col
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim s as shape
		  dim i, n as integer
		  
		  setoldcolors
		  n = tempshape.count -1
		  
		  for i = 0 to n
		    s = tempshape.element(i)
		    if Bord then
		      if s isa polygon and icot <> -1 then
		        polygon(s).colcotes(icot) = newcolor
		      else
		        s.FixeCouleurTrait Newcolor, Config.Border
		      end if
		    else
		      s.FixeCouleurFond Newcolor, 100
		      s.tsp = false
		    end if
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.EndOperation
		  currentcontent.remettreTsfAvantPlan
		  Redim Oldcolor(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("ToolsColor")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as Basicpoint) As shape
		  dim s as shape
		  dim i as integer
		  
		  icot = -1
		  s = super.getshape(p)
		  
		  if visible.count = 0 then
		    return nil
		  end if
		  
		  if bord then
		    for i = 0 to visible.count-1
		      s = Visible.element(i)
		      if s isa polygon  then
		        index.append polygon(s).pointonside(p)
		      else
		        index.append -1
		      end if
		    next
		    icot = index(iobj)
		  else
		    for i = visible.count-1 downto 0
		      s = Visible.element(i)
		      if s isa arc then
		        visible.removeshape s
		      end if
		    next
		  end if
		  
		  
		  
		  return visible.element(iobj)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as Basicpoint)
		  dim i, j as integer
		  dim s as shape
		  
		  if currenthighlightedshape = nil then
		    Objects.unselectall
		    return
		  end if
		  
		  if CurrentHighlightedshape <> nil and currenthighlightedshape.selected = false then
		    Objects.Unselectall
		    Objects.selectobject(CurrentHighLightedshape)
		  end if
		  
		  DoOperation
		  
		  endoperation
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g As Graphics)
		  super.paint(g)
		  
		  Help g,""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim i, n as integer
		  dim s as shape
		  dim bd as string
		  dim EL, EL1, EL2 as XMLElement
		  dim r, g, b as double
		  
		  
		  EL = XMLElement(Temp.Child(0))
		  bd =  EL.GetAttribute("Bord")
		  
		  if bd = "true" then
		    Bord = true
		  else
		    Bord = false
		  end if
		  
		  SelectIdForms(EL)
		  n = tempshape.count-1
		  EL1 = XMLElement(EL.child(1))
		  r = Val(EL1.GetAttribute(Dico.Value("Rouge")))
		  g = Val(EL1.GetAttribute(Dico.Value("Vert")))
		  b = Val(EL1.GetAttribute(Dico.Value("Bleu")))
		  newcolor = new couleur(r,g,b)
		  icot = Val(EL.getattribute("Icot"))
		  
		  for i = 0 to n
		    s = tempshape.element(i)
		    if Bord then
		      if s isa polygon and icot <> -1 then
		        polygon(s).colcotes(icot) = newcolor
		      else
		        s.FixeCouleurTrait Newcolor, Config.Border
		      end if
		    else
		      s.fill = 100
		      s.FixeCouleurFond newcolor, s.fill
		      s.tsp = false
		    end if
		  next
		  objects.unselectall
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetOldColors()
		  dim i, j, n as integer
		  dim s as shape
		  n = tempshape.count-1
		  
		  for i = 0 to n
		    s = tempshape.element(i)
		    if Bord then
		      if  s isa polygon  then
		        if icot <> -1 then
		          OldColor.append s.colcotes(icot)
		        else
		          for j = 0 to s.npts-1
		            OldColor.append s.colcotes(j)
		          next
		        end if
		      else
		        OldColor.append s.getBorderColor
		      end if
		    else
		      OldColor.append s.GetFillColor
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument) As XMLElement
		  Dim Myself  as XmlElement
		  dim i as integer
		  
		  Myself= Doc.CreateElement(Dico.value("Forms"))
		  for i = 0 to tempshape.count-1
		    Myself.appendchild tempshape.element(i).XMLPutIdInContainer(Doc)
		  next
		  if Bord then
		    Myself.SetAttribute("Bord", "true")
		  else
		    Myself.SetAttribute("Bord", "false")
		  end if
		  Myself.appendchild NewColor.XMLPutInContainer(Doc, "NewColor")
		  Myself.setattribute("Icot", str(icot))
		  return Myself
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  Dim Myself , EL, Temp as XmlElement
		  dim i,j,n as integer
		  dim s as shape
		  
		  
		  
		  n = tempshape.count
		  if n>0 then
		    Myself= Doc.CreateElement(GetName)
		    if Bord then
		      Myself.SetAttribute("Bord", "true")
		    else
		      Myself.SetAttribute("Bord", "false")
		    end if
		    
		    Myself.appendchild tempshape.XMLPutIdInContainer(Doc)
		    Myself.appendchild NewColor.XMLPutInContainer(Doc, "NewColor")
		    Myself.setattribute("Icot", str(icot))
		    
		    EL = Doc.CreateElement("OldColors")
		    for i = 0 to n-1
		      EL.appendchild Oldcolor(i).XMLPutInContainer(Doc, "OldColor")
		    next
		    Myself.appendchild EL
		    return Myself
		  end if
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim i, n as integer
		  dim s as shape
		  dim bd as string
		  dim EL, EL1, EL2 as XMLElement
		  dim r, g, b as double
		  dim c as couleur
		  
		  EL = XMLElement(Temp.Child(0))
		  bd =  EL.GetAttribute("Bord")
		  
		  if bd = "true" then
		    Bord = true
		  else
		    Bord = false
		  end if
		  
		  SelectIdForms(EL)
		  n = tempshape.count-1
		  EL1 = XMLElement(EL.child(2))
		  
		  for i = 0 to n
		    s = tempshape.element(i)
		    EL2 = XMLElement(EL1.child(i))
		    r = Val(EL2.GetAttribute(Dico.Value("Rouge")))
		    g = Val(EL2.GetAttribute(Dico.Value("Vert")))
		    b = Val(EL2.GetAttribute(Dico.Value("Bleu")))
		    c = new Couleur(r,g,b)
		    if Bord then
		      s.FixeCouleurTrait c, s.border
		    else
		      s.FixeCouleurFond c, s.fill
		      s.tsp = false
		    end if
		  next
		  objects.unselectall
		  
		  
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
		Bord As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		icot As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected NewColor As Couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		Oldcolor(-1) As couleur
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Bord"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="icot"
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
			Name="info"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
			Group="Behavior"
			InitialValue="0"
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
			Name="nobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ntsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SidetoPaint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Std2flag"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
