#tag Class
Protected Class Lier
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub adjoindre(s as shape, n as integer)
		  s.OldIdGroupes.Append  s.IdGroupe
		  s.IDGroupe = N
		  Objects.Groupes(N).addShape s
		  listids.append s.id

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Super.Constructor
		  OpId = 3
		  prem = true
		  prembis = True
		  WorkWindow.refreshtitle


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(El as XMLElement)
		  Dim List As XmlNodeList

		  Constructor()
		  List = EL.XQL(Dico.value("Group"))
		  if List.length > 0 then
		    EL = XMLElement(List.Item(0))
		    NumList = val(EL.GetAttribute("IdGroupe"))
		    Fusion = val(EL.GetAttribute("Fusion"))
		    SelectIdForms(EL)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
		Sub DoOperation()
		  Dim i, selectedGroupId, n1, n2 As Integer
		  dim s as point

		  for i = tempshape.count -1 downto 0
		    if tempshape.item(i).constructedby <> nil and  tempshape.item(i).constructedby.oper = 6 then
		      objects.unselectobject tempshape.item(i)
		    end if
		    if tempshape.item(i) isa point and UBound(point(tempshape.item(i)).parents) > -1 then
		      s = point(tempshape.item(i))
		      for selectedGroupId = 0 to UBound(s.parents)
		        objects.selectobject s.parents(selectedGroupId)
		      next
		      objects.unselectobject s
		    end if
		  next

		  if tempshape.count = 0 then
		    return
		  end if

		  for i = tempshape.count-1 downto 0
		    selectedGroupId = tempshape.item(i).IDGroupe
		    if prem then
		      if selectedGroupId = -1 then
		        Objects.Groupes.append new ObjectsList
		        Numlist = Ubound(Objects.Groupes)
		        adjoindre(tempshape.item(i), NumList)
		      end if
		      NumList = tempshape.item(i).IdGroupe
		      prem = false
		    else
		      If selectedGroupId = -1 Then
		        adjoindre(tempshape.item(i), NumList)
		      Elseif  selectedGroupId <> NumList Then
		        n1 = min(selectedGroupId, NumList)
		        n2 = max(selectedGroupId, NumList)
		        fusionner(n1, n2)
		        NumList = n1
		      end if
		    end if
		  next
		  EndOperation

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  Dim i, n As Integer

		  if ubound(listids) > -1 then
		    super.endoperation
		    redim listids(-1)
		  end if
		  objects.unselectall

		  can.Mousecursor =System.Cursors.StandardPointer

		  n = objects.item(1).idgroupe

		  if objects.count > 2 then
		    for i = 2 to objects.count-1
		      if objects.item(i).IDGroupe <> n then
		        return
		      end if
		    next
		  end if

		  CurrentContent.currentoperation = nil
		  objects.unselectall
		  objects.unhighlightall
		  can.refreshbackground

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fusionner(k as integer, n as integer)
		  dim j as integer
		  dim s as shape

		  for j = 0 to Objects.Groupes(N).count-1
		    s = objects.Groupes(N).item(j)
		    s.OldIdGroupes.append s.IDGroupe
		    s.IDGroupe = k
		    Objects.Groupes(k).addShape s
		    listids.append s.id
		  next
		  Objects.Groupes(N).removeAll
		  Objects.OptimizeGroups
		  fusion = n
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("EditLink")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as Basicpoint) As shape
		  dim s, s1 as shape
		  dim i as integer

		  s = super.getshape(p)

		  for i = visible.count-1 downto 0
		    s1 = visible.item(i)
		    if ( s1.constructedby <> nil and s1.constructedby.oper = 6)  then
		      visible.removeobject s1
		    end  if
		  next
		  nobj = visible.count
		  if nobj > 0 then
		    return visible.item(iobj)
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ImmediateDoOperation()
		  dim i,g1,g2,cg as integer
		  dim s as Shape
		  dim ok as Boolean

		  g1=-1
		  g2=-1
		  ok = true

		  // On vérifie que les formes sélectionnées n'appartiennent pas à plus de deux groupes
		  if tempshape.count >0 then
		    i = 0
		    while (i < tempshape.count and ok = true)
		      s = tempshape.item(i)
		      cg = s.IDGroupe
		      if g1 = -1then
		        g1 = cg
		      elseif g2 = -1 and cg <> g1 then
		        g2 = cg
		      elseif cg <> g1 and cg <> g2 then
		        ok = false
		      end if
		      i=i+1
		    wend
		    if ok then
		      Super.ImmediateDoOperation
		    else
		      i = MsgBox (Dico.value("Max2Groups"),48)
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as Basicpoint)
		  If currenthighlightedshape = Nil Then
		    EndOperation
		    Return
		  End If

		  selection
		  Finished = False
		  DoOperation


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  Dim i As Integer


		  if CurrentContent.currentoperation = self then
		    display = choose + aform + alier + EndOfLine _
		    +"Après avoir choisi la dernière forme à lier, cliquez du bouton droit " + EndOfLine _
		    + "en dehors de toute forme"
		  end if

		  for i = 0 to ubound(objects.groupes)
		    objects.affichergroupe(i, bleu,g)
		  next

		  g.ForeColor = Config.bordercolor.col

		  Help g, display
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim List as XmlNodeList
		  dim EL as XMLElement
		  dim n, i as integer
		  dim pr as integer

		  List = Temp.XQL(Dico.value("Group"))
		  if List.length > 0 then
		    EL = XMLElement(List.Item(0))
		    NumList = val(EL.GetAttribute("IdGroupe"))
		    Fusion = val(EL.GetAttribute("Fusion"))
		    pr = val(EL.GetAttribute("Prem"))
		    if pr = 1 then
		      prembis = true
		    else
		      prembis = false
		    end if
		    prem = prembis
		    SelectIdForms(EL)
		    if NumList <> -1 and NumList <= Ubound (Objects.groupes) then
		      prem = false
		    end if
		    DoOperation
		    finished = true
		    objects.unselectall
		  end if


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  dim temp, EL as XMLElement
		  dim i as integer
		  dim s as shape

		  temp =  Doc.CreateElement(Dico.Value("Group"))
		  temp.setattribute("IdGroupe", str(numlist))
		  temp.setattribute("Fusion", str(Fusion))
		  if prembis then
		    temp.setattribute("Prem",str(1))
		  end if
		  prembis = false
		  EL = Doc.CreateElement(Dico.Value("Formes"))
		  for i  = 0 to ubound(listids)
		    s = objects.getshape(listids(i))
		    if s.oldIdgroupes(ubound(s.oldidgroupes)) = fusion then
		      EL.appendchild s.XMLPutIdinContainer(Doc)
		    end if
		  next

		  temp.AppendChild EL

		  return temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim i,n,k  as integer
		  dim s as shape
		  dim EL as XMLElement
		  dim List as XmlNodeList
		  dim g as graphics

		  List = Temp.XQL(Dico.value("Group"))
		  if List.length = 0 then
		    return
		  end if

		  EL = XMLElement(List.Item(0))
		  NumList = val(EL.GetAttribute("IdGroupe"))
		  Fusion = val(EL.GetAttribute("Fusion"))
		  SelectIdForms(EL)

		  if fusion <> -1 then
		    objects.groupes.Insert(fusion,new ObjectsList)
		  end if

		  for i = 0 to tempshape.count-1
		    s = tempshape.item(i)
		    objects.groupes(numlist).removeobject s
		    s.IDGroupe = s.OldIdgroupes.pop
		    if fusion <> -1 then
		      objects.groupes(fusion).addShape s
		    end if
		  next
		  Objects.OptimizeGroups
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
		Fusion As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		listids() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		NumList As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		prem As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		prembis As Boolean
	#tag EndProperty


	#tag ViewBehavior
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
			Name="Fusion"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
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
			Name="NumList"
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
			Name="prem"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="prembis"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
