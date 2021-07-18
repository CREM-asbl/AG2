#tag Class
Protected Class ColorChange
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor(B as Boolean, col as Color, side as integer)
		  Super.constructor
		  OpId = 12
		  Bord = B
		  If B Then
		    colsep = True
		  Else
		    colsep = False
		  End If
		  newcolor = New couleur(col)
		  currentcontent.currentoperation = Self
		  self.side = side
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  
		  
		  
		  setoldcolors
		  If bord And ( side <> -1) Then
		    currentshape.Fixecouleurtrait(side, newcolor)
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
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  Super.EndOperation
		  currentcontent.remettreTsfAvantPlan
		  Redim Oldcolors(-1)
		  can.refreshbackground
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
		  Super.paint(g)
		  
		  If CurrentContent.currentoperation = Self Then
		    display = choose + "d'abord la nouvelle couleur"
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  Dim s As shape
		  Dim bd As String
		  Dim EL, EL1 As XMLElement
		  Dim oldcolor As couleur
		  
		  
		  EL = XMLElement(Temp.Child(0)) 
		  bd =  EL.GetAttribute("Bord")
		  
		  If bd = "true" Then
		    Bord = True
		  Else
		    Bord = False
		  End If
		  
		  side = Val(EL.GetAttribute("side"))
		  SelectIdForms(EL)  'une seule forme à sélectionner
		  s = tempshape.item(0)
		  
		  EL1 = XMLElement(EL.child(1))    'lecture de newcolor
		  newcolor = New Couleur(EL1)
		  If side <> -1 Then
		    s.colcotes(side) = newcolor
		  Else
		    If Bord Then
		      s.FixeCouleurTrait (newcolor, Config.Border)
		    Else
		      s.FixeCouleurFond (newcolor, s.fill)
		      s.tsp = False
		    End If
		  End If
		  can.refreshBackGround
		  
		  
		  
		  
		  
		  
		  
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
		  Myself.setattribute("Icot", str(side))
		  return Myself
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  Dim Temp, EL, EL1 As XMLElement
		  dim i,j,n as integer
		  Dim s As shape
		  
		  'Comme on travaille uniquement dans le cadre du menu contextuel, il n'y a qu'au plus un élément dans tempshape
		  
		  If tempshape.count = 0 Then 
		    return nil
		  end if
		  
		  s = tempshape.item(0)
		  Temp = Doc.CreateElement(GetName)
		  
		  if Bord then
		    Temp.SetAttribute("Bord", "true")
		    Temp.setattribute("side", Str(s.side))
		  else
		    Temp.SetAttribute("Bord", "false")
		    Temp.setattribute("side", Str(-1))
		    Temp.SetAttribute("OldFill", Str(s.Fill))
		  end if
		  
		  If Not Bord Then
		    Temp.SetAttribute("Newfill",Str(newfill))
		  End If
		  
		  Temp.appendchild tempshape.XMLPutIdInContainer(Doc)
		  Temp.appendchild NewColor.XMLPutInContainer(Doc, "NewColor")
		  
		  If s.side = -1  Then
		    Temp.AppendChild Oldcolors(0).XMLPutInContainer(Doc, "OldColor")
		  Else
		    EL= Doc.CreateElement("OldColors")  
		    If s IsA Lacet And Not s IsA Secteur Then
		      for j = 0 to s.npts-1
		        EL.appendchild Oldcolors(j).XMLPutInContainer(Doc, "OldColor")
		      next
		    elseif s isa secteur then 
		      for j = 0 to 1 
		        EL.appendchild Oldcolors(j).XMLPutInContainer(Doc, "OldColor")
		      next
		    End If
		    Temp.appendchild EL
		  End If
		  
		  Return Temp
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  
		  Dim s As shape
		  dim bd as string
		  Dim EL, EL1 As XMLElement
		  dim oldcolor as couleur
		  
		  EL = XMLElement(Temp.Child(0)) 
		  bd =  EL.GetAttribute("Bord")
		  
		  if bd = "true" then
		    Bord = True
		  else
		    Bord = false
		  end if
		  
		  side = Val(EL.GetAttribute("side"))
		  SelectIdForms(EL)  'une seule forme à sélectionner
		  s = tempshape.item(0)
		  
		  EL1 = XMLElement(EL.child(2))    'lecture de oldcolor
		  oldcolor = New Couleur(EL1)
		  If  side <> -1 Then
		    s.colcotes(side) = oldcolor
		  Else
		    If Bord Then
		      s.FixeCouleurTrait (oldcolor, Config.Border)
		    Else
		      s.FixeCouleurFond (oldcolor, s.fill)
		      s.tsp = False
		    End If
		  End If
		  can.refreshBackGround
		  
		  
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
		OldFill As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		side As Integer
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
			Name="side"
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
		#tag ViewProperty
			Name="OldFill"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
