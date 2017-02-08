#tag Class
Protected Class ColorChange
Inherits SelectOperation
	#tag Method, Flags = &h0
		Function ComputeNSideMax() As integer
		  dim i, n as integer
		  dim s as shape
		  
		  n = 0
		  
		  if icot <> -1 then   'dans ce cas l'opération ne porte que sur un seul objet qui est un lacet et c'est la bordercolor qui est modifiée
		    s = tempshape.item(0)
		    n = 0
		  else
		    for i = 0 to tempshape.count -1
		      if tempshape.element(i) isa Lacet then
		        n = max(n, tempshape.item(i).npts-1)
		      else 
		        n = max(n,1)
		      end if
		    next
		  end if
		  return n
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(B as boolean, col as couleur)
		  super.constructor
		  OpId = 12
		  Bord = B
		  newcolor = col
		  icot = -1
		  if B then
		    colsep = true
		  else
		    colsep = false
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim s as shape
		  dim i, n as integer
		  
		  n = tempshape.count-1
		  setoldcolors
		  
		  s = currenthighlightedshape
		  
		  if s.side <> -1 then
		    s = tempshape.item(0)
		    s.Fixecouleurtrait(s.side, newcolor)
		  else
		    for i = 0 to n
		      s = tempshape.item(i)
		      if Bord then
		        s.FixeCouleurTrait (Newcolor, Config.Border)
		      else
		        if s.fill <> 0 then
		          newfill = s.fill
		        else
		          newfill = 100
		        end if
		        s.FixeCouleurFond (Newcolor, newfill)
		        s.tsp = false
		      end if
		    next
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.EndOperation
		  currentcontent.remettreTsfAvantPlan
		  Redim Oldcolors(-1,-1)
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
		      s = Visible.item(i)
		      if s isa Lacet  then
		        s.side  = s.pointonside(p)
		        side = s.side
		      elseif s isa point then
		        s.side = -1
		      end if
		    next
		    icot = Visible.item(iobj).side
		  else
		    for i = visible.count-1 downto 0
		      s = Visible.item(i)
		      if s isa arc then
		        visible.removeobject s
		      end if
		    next
		  end if
		  
		  
		  
		  return visible.item(iobj)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as Basicpoint)
		  
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
		  newcolor = new couleur(EL1)
		  newfill = val(EL.GetAttribute("Newfill"))
		  icot = Val(EL.getattribute("Icot"))
		  
		  for i = 0 to n
		    s = tempshape.item(i)
		    if Bord then
		      if s isa polygon and icot <> -1 then
		        polygon(s).colcotes(icot) = newcolor
		      else
		        s.FixeCouleurTrait Newcolor, Config.Border
		      end if
		    else
		      s.FixeCouleurFond newcolor,newfill
		      s.tsp = false
		    end if
		  next
		  objects.unselectall
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetOldColors()
		  dim i, j, n, nmax as integer
		  dim s as shape
		  
		  n = tempshape.count-1
		  nmax = computensidemax
		  
		  redim OldColors(n,nmax)
		  redim oldfills(n)
		  
		  if icot <> -1 then
		    s = tempshape.item(0)
		    redim oldcolors(0,0)
		    OldColors(0,0) = s.Bordercolor  's.colcotes(icot)
		  else
		    for i = 0 to n
		      s = tempshape.item(i)
		      if Bord then
		        if  s isa Lacet and not s isa secteur  then
		          for j = 0 to s.npts-1
		            OldColors(i,j) =s.colcotes(j)
		          next
		        elseif s isa secteur then 
		          for j = 0 to 1
		            OldColors(i,j) =s.colcotes(j)
		          next
		        else
		          OldColors(i,0) = s.getBorderColor
		        end if
		      else
		        OldColors (i,0) = s.GetFillColor
		        OldFills(i) = s.Fill
		      end if
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument) As XMLElement
		  Dim Myself  as XMLElement
		  dim i as integer
		  
		  Myself= Doc.CreateElement(Dico.value("Forms"))
		  for i = 0 to tempshape.count-1
		    Myself.appendchild tempshape.item(i).XMLPutIdInContainer(Doc)
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
		  Dim Myself , EL, EL1 as XMLElement
		  dim i,j,n as integer
		  dim s as shape
		  
		  
		  
		  n = tempshape.count
		  if n=0 then
		    return nil
		  end if
		  
		  Myself= Doc.CreateElement(GetName)
		  if Bord then
		    Myself.SetAttribute("Bord", "true")
		  else
		    Myself.SetAttribute("Bord", "false")
		  end if
		  
		  Myself.appendchild tempshape.XMLPutIdInContainer(Doc)
		  Myself.appendchild NewColor.XMLPutInContainer(Doc, "NewColor")
		  Myself.setattribute("Icot", str(icot))
		  if not Bord then
		    Myself.SetAttribute("Newfill",str(newfill))
		  end if
		  
		  EL = Doc.CreateElement("OldColors")
		  if icot <> -1 then
		    EL.AppendChild Oldcolors(0,0).XMLPutInContainer(Doc, "OldColor")
		  else
		    for i = 0 to n-1
		      s = tempshape.item(i)
		      EL1 = Doc.CreateElement("Objet"+str(i))
		      if Bord then
		        if s isa Lacet and not s isa Secteur then
		          for j = 0 to s.npts-1
		            EL1.appendchild Oldcolors(i,j).XMLPutInContainer(Doc, "OldColor")
		          next
		        elseif s isa secteur then 
		          for j = 0 to 1 
		            EL1.appendchild Oldcolors(i,j).XMLPutInContainer(Doc, "OldColor")
		          next
		        else 
		          EL1.appendchild Oldcolors(i,0).XMLPutInContainer(Doc, "OldColor")
		        end if
		      else
		        EL1.appendchild Oldcolors(i,0).XMLPutInContainer(Doc, "OldColor")
		        EL1.SetAttribute("Fill", str(OldFills(i)))
		      end if
		      EL.appendchild EL1
		    next
		  end if
		  Myself.appendchild EL
		  return Myself
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim i, j, n, f as integer
		  dim s as shape
		  dim bd as string
		  dim EL, EL1, EL2, EL3 as XMLElement
		  dim r, g, b as double
		  dim c as couleur
		  
		  EL = XMLElement(Temp.Child(0))
		  bd =  EL.GetAttribute("Bord")
		  
		  if bd = "true" then
		    Bord = true
		  else
		    Bord = false
		  end if
		  
		  icot = val(EL.GetAttribute("Icot"))
		  SelectIdForms(EL)
		  n = tempshape.count-1
		  
		  EL1 = XMLElement(EL.child(2))
		  if icot <> -1 then 
		    s = tempshape.item(0)
		    EL2 = XMLElement(EL1.child(0))
		    s.colcotes(icot) = new Couleur(EL2)
		  else
		    for i = 0 to n
		      s = tempshape.item(i)
		      EL2 = XMLElement(EL1.child(i))
		      if Bord then
		        if s isa Lacet then
		          for j = 0 to s.npts-1
		            EL3 = XMLElement(EL2.child(j))
		            lacet(s).colcotes(j) =new Couleur(EL2)
		          next
		        else
		          s.FixeCouleurTrait new couleur(EL2), s.border
		        end if
		      else
		        EL3 = XMLElement(EL2.child(j))
		        c = new Couleur(EL2)
		        f = Val(EL2.GetAttribute("Fill"))
		        s.FixeCouleurFond c, f
		        s.tsp = false
		      end if
		    next
		  end if
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
		newfill As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		OldColors(-1,-1) As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		OldFills(-1) As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Bord"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="canceling"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsep"
			Group="Behavior"
			Type="Boolean"
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
			Name="newfill"
			Group="Behavior"
			Type="Integer"
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
			Name="side"
			Group="Behavior"
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
