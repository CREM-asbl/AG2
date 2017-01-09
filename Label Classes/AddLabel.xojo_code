#tag Class
Protected Class AddLabel
Inherits SelectAndDragOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  colsep = true
		  OpId = 33
		  finished = true
		  loc = -1
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  
		  
		  Correction = new BasicPoint(lab.Correction.X,  lab.Correction.Y)
		  Etiquette = asc(Lab.Text)
		  if Lab.text = "*" then
		    wnd.drapdim = true
		  elseif Lab.text = "" then
		    currentshape.labs.removeobject lab
		  end if
		  currentshape.dounselect
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.EndOperation
		  Lw = nil
		  correction = nil
		  lab = nil
		  oldlabel = nil
		  drapnew = false
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetLab(EL as XMLElement) As Etiq
		  dim Lab1 As Etiq
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

	#tag Method, Flags = &h0
		Function GetName() As String
		  Return Dico.Value("Nominate")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s as shape
		  
		  s = Operation.GetShape(p)
		  
		  if s = nil  then
		    return can.getrepere
		  end if
		  
		  if s isa cube then
		    loc = s.pointOnSide(Muser)
		    if loc > 5  and loc < 9 then
		      if cube(s).mode = 0 or cube(s).mode = 2 then
		        loc = (loc-6)*2+1
		      else
		        loc = (loc -6)*2
		      end if
		    elseif loc > 7 then
		      loc  =(loc-9)*2
		    end if
		  elseif s isa Lacet  or s isa Freecircle  then
		    loc = s.PointOnSide(p)
		  end if
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  
		  if currentshape = nil then
		    return
		  end if
		  
		  if currentshape isa repere then
		    Lab = Currentshape.Labs.GetLab(can.MouseUser)
		  else
		    Lab =  Currentshape.Labs.GetLab(loc)
		  end if
		  
		  if Lab <> nil then
		    OldLabel = lab.copy
		    drapnew = false
		  else
		    Lab = new Etiq(loc)
		    Lab.chape = currentshape
		    Lab.setposition
		    Lab.MouseCorrection(p)  // la séparation entre position et correction permet de ne pas recalculer complètement la position
		    Currentshape.Labs.AddObject  Lab   // de l'étiquette en cas de mouvement ou modification
		    drapnew = true
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDrag(p as BasicPoint)
		  if lab <> nil then
		    Lab.MouseCorrection(P)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(p as BasicPoint)
		  
		  if finished = false then
		    return
		  end if
		  Currentshape = nil
		  loc = -1
		  if currenthighlightedshape <> nil then
		    currenthighlightedshape.unhighlight
		    currenthighlightedshape.tsp = false
		    currenthighlightedshape.dounselect
		  end if
		  Currentshape = GetShape(p)                            //retourne par priorité les points, ensuite les formes
		  if loc = -1 or currentshape isa circle then 
		    currenthighlightedshape = currentshape   'on n'a pas choisi un cote de polygone, ni de bande, ni de secteur
		  end if
		  can.refreshbackground
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseUp(p as BasicPoint)
		  dim pos as basicPoint
		  
		  if lab <> nil then
		    lab.MouseCorrection(p)
		  end if
		  Lw = new LabelWindow
		  Lw.ShowModal
		  
		  if lab.LockRight and lab.LockBottom then
		    pos = lab.position +lab.correction
		    lab.position = new BasicPoint(0,0)
		    lab.correction = pos
		  end if
		  finished = false
		  can.MouseCursor = system.cursors.wait
		  
		  DoOperation
		  endoperation
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as Graphics)
		  dim bp as BasicPoint
		  dim lab1 as Etiq
		  dim oldcol as color
		  dim i as integer
		  
		  if currentshape = nil then
		    return
		  end if
		  
		  super.Paint(g)
		  
		  if  currentshape isa repere then
		    oldcol = g.forecolor
		    g.forecolor = Config.highlightcolor.col
		    for i = 0 to currentshape.labs.count-1
		      bp = currentshape.labs.item(i).position  + currentshape.labs.item(i).correction
		      bp = can.transform(bp)
		      g.fillrect(bp.x, bp.y,5,5)
		    next
		    g.forecolor = oldcol
		    display =   click + pour + putatitle
		    Lab1 = Currentshape.Labs.GetLab(can.MouseUser)
		    
		  elseif currentshape <> nil then
		    display =   click+ pour + putalabel
		    Lab1 =  Currentshape.Labs.GetLab(loc)
		  end if
		  
		  if Lw = nil and  currenthighlightedshape <> nil then
		    if currentshape <> nil and loc = -1 then
		      currentshape.tsp = false
		      currentshape.doselect
		    end if
		    if currentshape isa Lacet and loc <> -1 then
		      Lacet(Currentshape).paintside(g,loc,2,config.highlightcolor)
		      'elseif currentshape isa polygon and loc <> -1 then
		      'polygon(currentshape).paintside(g,loc,2,config.highlightcolor)
		      display = display + sur +  thissegment
		      'elseif currentshape isa Bande and loc <> -1 then
		      'Bande(currentshape).paintside(g,loc,2,Config.highlightcolor)
		      'display = display+ " " +ontheline
		      'elseif  currentshape isa secteur and loc <> -1 then
		      'Secteur(currentshape).paintside(g,loc,2,Config.highlightcolor)
		      'display = display + " " + ontheline
		    else
		      currenthighlightedshape.highlight
		      currenthighlightedshape.paint(g)
		      if not currentshape isa repere then
		        if currentshape isa FreeCircle and not currentshape.isaellipse  and loc = -1 then
		          display = display +" "+ onthedisk
		        else
		          display = display + sur + this(lowercase(currenthighlightedshape.GetType))
		        end if
		      end if
		    end if
		    
		    if lab1 <> nil then
		      oldcol = Lab1.TextColor
		      Lab1.TextColor = Config.highlightcolor.col
		      Lab1.paint(g)
		      Lab1.Textcolor = oldcol
		    end if
		  end if
		  
		  Help g, display
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp As XMLElement)
		  dim EL, EL1 as XMLElement
		  dim loc as integer
		  dim Lab1 as Etiq
		  dim corr as BasicPoint
		  dim coul as Couleur
		  dim type as string
		  
		  EL = XMLElement(Temp.Child(0))
		  type = EL.GetAttribute("Type")
		  
		  EL1 = XMLElement(EL.Child(0))
		  CurrentShape = Objects.GetShape(val(EL1.GetAttribute("Id")))
		  
		  select case type
		  case  "Creation"
		    EL1 = XMLElement(EL.Child(1))
		    ResetLab(EL1,CurrentShape)
		  case "Modification"
		    EL1 = XMLElement(EL.child(2))
		    Lab1 = GetLab(EL1)
		    currentshape.labs.removeobject Lab1
		    EL1 = XMLElement(EL.Child(1))
		    ResetLab(EL1,CurrentShape)
		  case "Deletion"
		    EL1 = XMLElement(EL.child(1))
		    Lab1 = GetLab(EL1)
		    currentshape.labs.removeobject lab1
		  end select
		  
		  if lab1  <> nil and lab1.text = "*" then
		    wnd.drapdim = true
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetLab(EL as XMLElement, sh as shape)
		  dim lab1 As Etiq
		  dim loc as integer
		  dim s as string
		  
		  loc = -1
		  s = EL.GetAttribute("Side")
		  if s = "-1" then
		    loc = -1
		  elseif s<> "" then
		    loc = val(s)
		  end if
		  
		  Lab1 = new Etiq(loc,EL)
		  lab1.chape = sh
		  lab1.setposition
		  sh.labs.addobject lab1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  dim El As XMLElement
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
		  El.AppendChild(Lab.chape.XMLPutIdINContainer(Doc))
		  
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
		  dim lab1 as Etiq
		  dim corr as BasicPoint
		  dim type as string
		  
		  
		  EL = XMLElement(Temp.Child(0))
		  type = EL.GetAttribute("Type")
		  
		  El1 = XMLElement(EL.Child(0))
		  CurrentShape = Objects.GetShape(val(El1.GetAttribute("Id")))
		  
		  
		  select case type
		  case "Creation"
		    EL1 = XMLElement(EL.Child(1))
		    Lab1 = GetLab(EL1)
		    currentshape.labs.removeobject Lab1
		  case "Modification"
		    EL1 = XMLElement(EL.Child(1))
		    Lab1 =GetLab(EL1)
		    currentshape.labs.removeobject Lab1
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
		Correction As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		couleur As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		drapnew As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Font As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Italique As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Lab As Etiq
	#tag EndProperty

	#tag Property, Flags = &h0
		loc As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Lw As LabelWindow
	#tag EndProperty

	#tag Property, Flags = &h0
		OldLabel As Etiq
	#tag EndProperty

	#tag Property, Flags = &h0
		taille As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Angle"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
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
			Name="couleur"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapnew"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapUA"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapUL"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fid"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
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
			Name="Italique"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="loc"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
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
			Name="taille"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
