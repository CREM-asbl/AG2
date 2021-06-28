#tag Class
Protected Class ColorChange
Inherits SelectOperation
	#tag Method, Flags = &h0
		Function ComputeNSideMax() As integer
		  Dim i, n As Integer
		  'dim s as shape
		  
		  'n = 0
		  
		  if icotcol <> -1 then   'dans ce cas l'opération ne porte que sur un seul objet qui est un lacet et c'est la bordercolor qui est modifiée
		    's = tempshape.item(0)
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
		Sub Constructor(B as Boolean, col as Color)
		  Super.constructor
		  OpId = 12
		  Bord = B
		  If B Then
		    colsep = True
		  Else
		    colsep = False
		  End If
		  newcolor = New couleur(col)
		  'currentcontent.currentoperation = Self
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(B as boolean, col as Color, side as integer)
		  Super.constructor
		  currentcontent.currentoperation = Self
		  OpId = 12
		  Bord = B
		  icotcol = side
		  if B then
		    colsep = True
		  else
		    colsep = False
		  End If
		  newcolor = New couleur(col)
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  
		  Dim i As Integer
		  
		  currentshape = currenthighlightedshape
		  setoldcolors
		  
		  
		  
		  If bord And ( icotcol <> -1) Then
		    currentshape.Fixecouleurtrait(icotcol, newcolor)
		  Else
		    if Bord then
		      currentshape.FixeCouleurTrait (newcolor, Config.Border)
		    else
		      If currentshape.fill <> 0 Then
		        newfill = currentshape.fill
		      else
		        newfill = 100
		      end if
		      currentshape.FixeCouleurFond (Newcolor, newfill)
		      currentshape.tsp = False
		    End If
		    can.refreshBackGround
		    
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  Super.EndOperation
		  currentcontent.remettreTsfAvantPlan
		  Redim Oldcolors(-1)
		  'can.refreshbackground
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
		  
		  icotcol = -1
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
		    icotcol = Visible.item(iobj).side
		  else
		    for i = visible.count-1 downto 0
		      s = Visible.item(i)
		      if s isa arc then
		        visible.removeobject s
		      end if
		    next
		  end if
		  
		  
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
		  'Super.paint(g)
		  
		  If CurrentContent.currentoperation = Self Then
		    display = choose + "d'abord la nouvelle couleur"
		    
		    
		    
		    
		    'display = choose + aform + alier + EndOfLine _ 
		    '+"Après avoir choisi la dernière forme à lier, cliquez du bouton droit " + EndOfLine _
		    '+ "en dehors de toute forme"
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  Dim i, n As Integer
		  dim s as shape
		  dim bd as string
		  dim EL, EL1, EL2 as XMLElement
		  dim r, g, b as double
		  
		  
		  Temp = XMLElement(Temp.Child(0))
		  bd =  Temp.GetAttribute("Bord")
		  
		  if bd = "true" then
		    Bord = true
		  else
		    Bord = false
		  End If
		  
		  SelectIdForms(Temp)
		  n = tempshape.count-1
		  EL1 = XMLElement(Temp.child(1))
		  newcolor = new couleur(EL1)
		  newfill = Val(Temp.GetAttribute("Newfill"))
		  icotcol = Val(Temp.getattribute("Icot"))
		  
		  for i = 0 to n
		    s = tempshape.item(i)
		    if Bord then
		      If s IsA polygon And icotcol <> -1 Then
		        polygon(s).colcotes(icotcol) = newcolor
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
		  Dim i, j, n, nmax As Integer
		  Dim s As shape
		  Dim sn As Integer
		  
		  
		  
		  s = tempshape.item(0)
		  If s IsA BiPoint Then
		    sn = 0
		  Else
		    sn =  s.npts-1
		  End If
		  If Bord Then
		    Redim oldcolors(sn)
		    If s IsA BiPoint Then
		      OldColors(0) = s.GetBorderColor
		    Else
		      For i = 0 To sn
		        OldColors(i) = s.colcotes(i)
		      Next
		    End If
		  Else
		    Redim oldcolors(0)
		    OldColors (0) = s.GetFillColor
		    Redim OldFills(0)
		    OldFills(0) = s.Fill
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
		  Myself.setattribute("Icot", str(icotcol))
		  return Myself
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  Dim Temp, EL, EL1 As XMLElement
		  dim i,j,n as integer
		  dim s as shape
		  
		  
		  
		  n = tempshape.count
		  if n=0 then
		    return nil
		  end if
		  
		  Temp = Doc.CreateElement(GetName)
		  if Bord then
		    Temp.SetAttribute("Bord", "true")
		  else
		    Temp.SetAttribute("Bord", "false")
		  end if
		  Temp.setattribute("Icot", Str(icotcol))
		  If Not Bord Then
		    Temp.SetAttribute("Newfill",Str(newfill))
		  End If
		  
		  Temp.appendchild tempshape.XMLPutIdInContainer(Doc)
		  Temp.appendchild NewColor.XMLPutInContainer(Doc, "NewColor")
		  
		  EL = Doc.CreateElement("OldColors")
		  if icotcol <> -1 then
		    EL.AppendChild Oldcolors(0).XMLPutInContainer(Doc, "OldColor")
		  Else
		    s = tempshape.item(0)
		    EL1 = Doc.CreateElement("Objet")  'EL1 = EL.Child
		    if Bord then
		      if s isa Lacet and not s isa Secteur then
		        for j = 0 to s.npts-1
		          EL1.appendchild Oldcolors(j).XMLPutInContainer(Doc, "OldColor")
		        next
		      elseif s isa secteur then 
		        for j = 0 to 1 
		          EL1.appendchild Oldcolors(j).XMLPutInContainer(Doc, "OldColor")
		        next
		      else 
		        EL1.appendchild Oldcolors(0).XMLPutInContainer(Doc, "OldColor")
		      end if
		    else
		      EL1.appendchild Oldcolors(0).XMLPutInContainer(Doc, "OldColor")
		      EL1.SetAttribute("Fill", str(OldFills))
		    end if
		    EL.appendchild EL1
		    
		  end if
		  Temp.appendchild EL
		  Return Temp
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  Dim i, j, n, f As Integer
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
		  
		  icotcol = Val(EL.GetAttribute("Icot"))
		  SelectIdForms(EL)
		  n = tempshape.count
		  
		  EL1 = XMLElement(EL.child(2))
		  If icotcol <> -1 Then 
		    s = tempshape.item(0)
		    EL2 = XMLElement(EL1.child(0))
		    s.colcotes(icotcol) = new Couleur(EL2)
		  else
		    for i = 0 to n-1
		      s = tempshape.item(i)
		      EL2 = XMLElement(EL1.child(i))
		      if Bord then
		        if s isa Lacet and not s isa secteur then
		          for j = 0 to s.npts-1
		            EL3 = XMLElement(EL2.child(j))
		            lacet(s).colcotes(j) =new Couleur(EL3)
		          next
		        elseif s isa secteur then
		          for j = 0 to 1
		            EL3 = XMLElement(EL2.child(j))
		            lacet(s).colcotes(j) =new Couleur(EL3)
		          next
		        else
		          s.FixeCouleurTrait new couleur(EL2), s.border
		        end if
		      else
		        EL3 = XMLElement(EL2.child(0))
		        c = new Couleur(EL3)
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
		icotcol As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected NewColor As Couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		newfill As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		OldColors(-1) As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		OldFills(-1) As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Bord"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="canceling"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsep"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="icotcol"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="info"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
			Visible=false
			Group="Behavior"
			InitialValue="0"
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
			Name="newfill"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="nobj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ntsf"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
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
