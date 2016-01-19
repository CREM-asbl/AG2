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
		   super.Constructor
		  OpId = 3
		  prem = true
		  prembis = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(El as XmlElement)
		  dim List as XmlNodeList
		  
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

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i , k, n1, n2 as integer
		  dim s as point
		  
		  for i = tempshape.count -1 downto 0
		    if tempshape.element(i).constructedby <> nil and  tempshape.element(i).constructedby.oper = 6 then
		      objects.unselectobject tempshape.element(i)
		    end if
		    if tempshape.element(i) isa point and UBound(point(tempshape.element(i)).parents) > -1 then
		      s = point(tempshape.element(i))
		      for k = 0 to UBound(s.parents)
		        objects.selectobject s.parents(k)
		      next
		      objects.unselectobject s
		    end if
		  next
		  
		  if tempshape.count = 0 then
		    return
		  end if
		  
		  for i =  tempshape.count-1 downto 0
		    k =  tempshape.element(i).IDGroupe
		    if prem then
		      if k = -1 then
		        Objects.Groupes.append new ObjectsList
		        Numlist = Ubound(Objects.Groupes)
		        adjoindre(tempshape.element(i), NumList)
		      end if
		      NumList = tempshape.element(i).IdGroupe
		      prem = false
		    else
		      if k = -1 then
		        adjoindre(tempshape.element(i), NumList)
		      elseif  k <> NumList then
		        n1 = min(k, NumList)
		        n2 = max(k, NumList)
		        fusionner(n1, n2)
		        NumList = n1
		      end if
		    end if
		    if Numlist = k then
		      tempshape.objects.remove i
		    end if
		  next
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  dim i, n as integer
		  
		  if ubound(listids) > -1 then
		    super.endoperation
		    redim listids(-1)
		  end if
		  objects.unselectall
		  
		  wnd.Mycanvas1.Mousecursor =System.Cursors.StandardPointer
		  
		  n = objects.element(1).idgroupe
		  
		  if objects.count > 2 then
		    for i = 2 to objects.count-1
		      if objects.element(i).IDGroupe <> n then
		        return
		      end if
		    next
		  end if
		  
		  CurrentContent.currentoperation = nil
		  objects.unselectall
		  objects.unhighlightall
		  wnd.refresh
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fusionner(k as integer, n as integer)
		  dim j as integer
		  dim s as shape
		  
		  for j = 0 to Objects.Groupes(N).count-1
		    s = objects.Groupes(N).element(j)
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
		    s1 = visible.element(i)
		    if ( s1.constructedby <> nil and s1.constructedby.oper = 6)  then
		      visible.removeshape s1
		    end  if
		  next
		  nobj = visible.count-1
		  return visible.element(iobj)
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
		      s = tempshape.element(i)
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
		Sub Paint(g as graphics)
		  dim i as integer
		  dim s as shape
		  dim p as BasicPoint
		  
		  if CurrentContent.currentoperation = self then
		    display = choose + aform + alier
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
		    s = tempshape.element(i)
		    objects.groupes(numlist).removeShape s
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
			Name="Fusion"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
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
			Name="NumList"
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
			Name="prem"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="prembis"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
