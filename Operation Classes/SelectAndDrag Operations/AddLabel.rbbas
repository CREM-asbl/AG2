#tag Class
Protected Class AddLabel
Inherits SelectAndDragOperation
	#tag Method, Flags = &h0
		Sub AddLabel()
		  SelectAndDragOperation()
		  OpId = 33
		  finished = true
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  
		  
		  Correction = new BasicPoint(lab.Correction.X,  lab.Correction.Y)
		  Etiquette = asc(Lab.Text)
		  if Lab.text = "*" then
		    wnd.drapdim = true
		  elseif Lab.text = "" then
		    currentshape.labs.removelab lab
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  
		  if currentshape isa repere then
		    Lab = Currentshape.Labs.GetLab(wnd.Mycanvas1.MouseUser)
		  else
		    Lab =  Currentshape.Labs.GetLab(loc)
		  end if
		  
		  if Lab <> nil then
		    OldLabel = lab.copy
		    drapnew = false
		  else
		    Lab = new Label(loc)
		    Lab.shape = currentshape
		    Lab.setposition
		    Lab.MouseCorrection(p)  // la séparation entre position et correction permet de ne pas recalculer complètement la position
		    Currentshape.Labs.AddLab  Lab   // de l'étiquette en cas de mouvement ou modification
		    drapnew = true
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as Graphics)
		  
		  dim lab1 as Label
		  dim oldcol as color
		  
		  
		  super.Paint(g)
		  
		  if  currentshape isa repere then
		    display =   click + pour + putatitle
		  else
		    display =   click+ pour + putalabel
		  end if
		  
		  Help g, display
		  
		  
		  if Lw = nil and currentshape <> nil then
		    
		    if currentshape isa polygon and loc <> -1 then
		      polygon(currentshape).paintside(g,loc,2,wnd.highlightcolor)
		    elseif currentshape isa Bande and loc <> -1 then
		      Bande(currentshape).paintside(g,loc,2,wnd.highlightcolor)
		    elseif  currentshape isa secteur and loc <> -1 then
		      Secteur(currentshape).paintside(g,loc,2,wnd.highlightcolor)
		    elseif currenthighlightedshape <> nil then
		      currenthighlightedshape.highlight
		      currenthighlightedshape.paint(g)
		    end if
		    
		    if currentshape isa repere then
		      Lab1 = Currentshape.Labs.GetLab(wnd.Mycanvas1.MouseUser)
		    else
		      Lab1 =  Currentshape.Labs.GetLab(loc)
		    end if
		    if lab1 <> nil then
		      oldcol = Lab1.col
		      Lab1.col = wnd.highlightcolor.col
		      Lab1.paint(g)
		      Lab1.col = oldcol
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  Return Dico.Value("Nominate")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(p as BasicPoint)
		  dim p1, q1 as Basicpoint
		  dim s as shape
		  
		  if finished = false then
		    return
		  end if
		  
		  if currenthighlightedshape <> nil then
		    currenthighlightedshape.unhighlight
		  end if
		  Currentshape = GetShape(p) //retourne par priorité les points, ensuite les formes
		  if loc = -1 then  
		    currenthighlightedshape = currentshape   'on n'a pas choisi un cote de polygone, ni de bande, ni de secteur
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  dim El As XmlElement
		  dim type as string
		  
		  El = Doc.CreateElement(GetName)
		  
		  if OldLabel <> nil and lab <> nil then
		    type = "Modification"
		  elseif oldlabel <> nil then
		    type = "Deletion"
		  elseif lab <> nil then
		     type = "Creation"
		  end if
		  
		  EL.SetAttribute("Type", type)
		  El.AppendChild(Lab.shape.XMLPutIdINContainer(Doc))
		  
		  select case type
		  case "Creation"
		    El.AppendChild(Lab.ToXml(Doc))
		  case "Modification"
		    El.AppendChild(Lab.ToXml(Doc))
		    El.AppendChild(OldLabel.ToXml(Doc))
		  case "Deletion"
		    El.AppendChild(OldLabel.ToXml(Doc))
		  end select
		  
		  return El
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp As XMLElement)
		  dim EL, EL1  as XMLElement
		  dim List as XMLNodeList
		  dim loc As integer
		  dim lab1 as label
		  dim corr as BasicPoint
		  dim type as string
		  
		  
		  EL = XMLElement(Temp.Child(0))
		  type = EL.GetAttribute("Type")
		  
		  El1 = XmlElement(EL.Child(0))
		  CurrentShape = Objects.GetShape(val(El1.GetAttribute("Id")))
		  
		  
		  select case type
		  case "Creation"
		    EL1 = XMLElement(EL.Child(1))
		    Lab1 = GetLab(EL1)
		    currentshape.labs.removelab Lab1
		  case "Modification"
		    EL1 = XMLElement(EL.Child(1))
		    Lab1 =GetLab(EL1)
		    currentshape.labs.removelab Lab1
		    EL1 = XMLElement(EL.Child(2))
		    ResetLab(EL1, CurrentShape)
		  case "Deletion"
		    EL1 = XMLElement(EL.Child(1))
		    ResetLab(EL1, CurrentShape)
		  end select
		  
		  if lab1  <> nil and lab1.text = "*" then
		    wnd.drapdim = true
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.EndOperation
		  Lw = nil
		  correction = nil
		  lab = nil
		  oldlabel = nil
		  finished = true
		  drapnew = false
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp As XMLElement)
		  dim EL, EL1 as XMLElement
		  dim loc as integer
		  dim Lab1 as Label
		  dim corr as BasicPoint
		  dim coul as Couleur
		  dim type as string
		  
		  EL = XMLElement(Temp.Child(0))
		  type = EL.GetAttribute("Type")
		  
		  EL1 = XmlElement(EL.Child(0))
		  CurrentShape = Objects.GetShape(val(EL1.GetAttribute("Id")))
		  
		  select case type
		  case  "Creation"
		    EL1 = XMLElement(EL.Child(1))
		    ResetLab(EL1,CurrentShape)
		  case "Modification"
		    EL1 = XmlElement(EL.child(2))
		    Lab1 = GetLab(EL1)
		    currentshape.labs.removelab Lab1
		    EL1 = XMLElement(EL.Child(1))
		    ResetLab(EL1,CurrentShape)
		  case "Deletion"
		    EL1 = XmlElement(EL.child(1))
		    Lab1 = GetLab(EL1)
		    currentshape.labs.removelab lab1
		  end select
		  
		  if lab1  <> nil and lab1.text = "*" then
		    wnd.drapdim = true
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseUp(p as BasicPoint)
		  
		  lab.MouseCorrection(p)
		  Lw = new LabelWindow
		  Lw.ShowModal
		  
		  finished = false
		  wnd.mycanvas1.MouseCursor = system.cursors.wait
		  
		  DoOperation
		  endoperation
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDrag(p as BasicPoint)
		  
		  Lab.MouseCorrection(P)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s as shape
		  
		  s = Operation.GetShape(p)
		  
		  
		  if s = nil then
		    s= wnd.mycanvas1.getrepere
		  end if
		  
		  if s isa polygon then
		    loc = polygon(s).PointOnSide(Muser)
		  elseif s isa Bande  then
		    loc = Bande (s).PointOnSide(Muser)
		  elseif s isa secteur then
		    loc = Secteur(s).PointOnSide(Muser)
		  else
		    loc = -1
		  end if
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseWheel()
		  
		  if visible <> nil and visible.count <> 0 then
		    nobj = visible.count
		    iobj = (iobj+1) mod nobj
		    if CurrentHighlightedShape<>nil then
		      CurrentHighlightedShape.UnHighLight
		    end if
		    
		    CurrentHighlightedShape = visible.element(iobj)
		    CurrentHighlightedShape.HighLight
		    currentshape = currenthighlightedshape
		    Wnd.mycanvas1.refreshbackground
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetLab(EL as XMLElement, sh as shape)
		  dim lab1 As Label
		  dim loc as integer
		  dim s as string
		  
		  loc = -1
		  s = EL.GetAttribute("Side")
		  if s = "-1" then
		    loc = -1
		  elseif s<> "" then
		    loc = val(s)
		  end if
		  
		  Lab1 = new Label(loc,EL)
		  lab1.shape = sh
		  lab1.setposition
		  sh.labs.addlab lab1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLab(EL as XMLElement) As Label
		  dim Lab1 As Label
		  dim corr as BasicPoint
		  
		  if not currentshape isa repere then
		    loc = val(EL.GetAttribute("Side"))
		    Lab1 = currentshape.labs.getlab(loc)
		  else
		    corr = new BasicPoint (val(EL.GetAttribute("CorrectionX")),  val(EL.GetAttribute("CorrectionY")))
		    Lab1 = currentshape.labs.getlab(corr)
		  end if
		  
		  return Lab1
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
		Lw As LabelWindow
	#tag EndProperty

	#tag Property, Flags = &h0
		taille As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		couleur As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		Italique As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		OldLabel As Label
	#tag EndProperty

	#tag Property, Flags = &h0
		Font As string
	#tag EndProperty

	#tag Property, Flags = &h0
		loc As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Lab As Label
	#tag EndProperty

	#tag Property, Flags = &h0
		Correction As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		drapnew As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="fa"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fo"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="sid"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Group="Behavior"
			Type="string"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Angle"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			InheritedFrom="SelectAndDragOperation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fid"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="SelectAndDragOperation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Std2flag"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SidetoPaint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="info"
			Group="Behavior"
			Type="string"
			InheritedFrom="Operation"
		#tag EndViewProperty
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
		#tag ViewProperty
			Name="taille"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="couleur"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Italique"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Font"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="loc"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapnew"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
