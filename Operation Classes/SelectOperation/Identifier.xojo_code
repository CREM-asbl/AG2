#tag Class
Protected Class Identifier
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.Constructor
		  OpId = 35
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i, j as integer
		  dim s, s1 as shape
		  
		  
		  if nobj = 2  then
		    if remplacement.Labs.count = 1 then
		      labremplacement = remplacement.labs.item(0).Text
		    else
		      labremplacement = ""
		    end if
		    if remplace.Labs.Count = 1 then
		      LabRemplace = remplace.Labs.item(0).Text
		    else
		      Labremplace = ""
		    end if
		    if ubound(remplace.parents) > -1 then
		      for i = 0 to ubound(remplace.parents)
		        shapes.append remplace.parents(i).id
		      next
		    end if
		    if ubound(remplace.constructedshapes) > -1 then
		      for i = 0 to ubound(remplace.constructedshapes)
		        csted.append remplace.constructedshapes(i).id
		      next
		    end if
		    remplace.Identify2(remplacement)  // remplacement remplace "remplacé"
		  elseif support <> nil then
		    remplacement.puton(support)
		    remplacement.placerptsursurfigure
		    remplacement.updateguides
		    remplacement.forme = 1
		  end if
		  
		  remplacement.mobility
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub endoperation()
		  super.endoperation
		  remplace = nil
		  Remplacement = nil
		  support = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.value("OperaIdentify")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s, sh, nextsh as shape
		  dim i, mag as integer
		  dim t, t1 as boolean
		  dim MagneticD as BasicPoint
		  
		  remplace = nil
		  remplacement = nil
		  support = nil
		  t = false
		  
		  s = super.getshape(p)
		  
		  for i =  visible.count-1 downto 0
		    s = Visible.item(i)
		    if  not (s isa point)  or (point(s).hasstdparent) or (s.constructedby <> nil and s.constructedby.oper = 9)  then
		      Visible.removeobject(s)
		      nobj = visible.count
		    end if
		  next
		  
		  if nobj = 2 and point(visible.item(0)).bpt.distance(point(visible.item(1)).bpt) < epsilon  then
		    t = positionner(point(visible.item(0)), point(visible.item(1)))
		  elseif nobj = 1 then
		    remplacement = point(visible.item(0))
		    mag = remplacement.magnetisme(magneticD,sh, nextsh)
		    if cancelattraction(remplacement) then
		      remplacement = nil
		    else
		      if Sh <>nil  and not (sh isa point) and  not sh.invalid and not sh.deleted and not sh.hidden and sh.pointonside(remplacement.bpt) <> -1 and  remplacement.authorisedputon(sh) then
		        support = sh
		      end if
		    end if
		    'next
		  end if
		  
		  if remplacement <> nil then
		    t1 = (remplacement.pointsur.count = 0)
		    if remplacement.guide <> nil then
		      t1 = t1 and (remplacement.guide.pointsur.count = 0)
		    end if
		    
		    if not ( (nobj = 2 and t)  or (nobj = 1 and support <> nil and t1) ) then
		      remplacement = nil
		    end if
		  end if
		  return remplacement
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  
		  
		  if remplacement = nil or ((support = nil) and (remplace = nil))  then
		    return
		  end if
		  
		  Objects.Unselectall
		  Objects.selectobject(CurrentHighLightedshape)
		  Finished = false
		  can.Mousecursor = System.Cursors.Wait
		  wnd.refreshtitle
		  
		  CurrentContent.Thefigs.removefigure remplacement.fig
		  if remplace <> nil then
		    CurrentContent.TheFigs.RemoveFigure remplace.fig
		  else
		    CurrentContent.TheFigs.RemoveFigure support.fig
		  end if
		  
		  DoOperation
		  endoperation
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  if nobj = 0 then
		    display =  choose + apoint
		  elseif remplacement  <> nil and remplace <> nil then
		    display = Identify + " " + thesetwopoints  + " ?"
		  elseif remplacement <> nil and support <> nil then
		    display = put+ "  "+ thepoint +"  "+ ontheline
		  end if
		  Help g, display
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function positionner(p as point, q as point) As Boolean
		  dim p1, q1 as point
		  
		  if p.pointsur.count > 0 or p.constructedby <> nil  or p.hasduplicate then
		    if q.pointsur.count > 0 or q.constructedby <> nil or q.hasduplicate then
		      return false
		    else
		      remplacement = q
		      remplace = p
		      return true
		    end if
		  else
		    remplacement = p
		    remplace = q
		    return true
		  end if
		  
		  //remplacement est toujours un point libre (ni sur ni construit) et sans dupliqués
		  //on pourra lui réaffecter les propriétés de remplacé
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim EL, EL1, EL2 as XMLElement
		  dim List as XMLNodeList
		  dim p as point
		  dim i, n, h as integer
		  dim s as shape
		  
		  EL = XMLElement(Temp.child(0))
		  EL1 = XMLElement(EL.child(0))
		  remplacement = point(objects.Getshape(val(EL1.Getattribute("Id"))))
		  EL1 = XMLElement(EL.child(1))
		  If EL1.GetAttribute("Ident") = "Point" then
		    remplace = point(objects.Getshape(val(EL1.Getattribute("Id"))))
		    remplace.identify2(remplacement)
		  else
		    support = objects.Getshape(val(EL1.Getattribute("Id")))
		    remplacement.puton(support)
		  end if
		  ReDeleteDeletedFigures(Temp)
		  ReCreateCreatedFigures(Temp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument, EL as XMLElement) As XMLElement
		  'Dim Temp,  EL1 as XMLElement
		  'dim i as integer
		  '
		  'if nobj = 2 then 'remplacement et remplace sont deux points
		  'EL.SetAttribute("Ident", "Point")
		  'EL.AppendChild remplacement.XMLPutIdInContainer(Doc)
		  'EL1 = Doc.CreateElement("Remplace")
		  'EL1.appendchild Remplace.XMLPutIdInContainer(Doc)
		  'EL1.SetAttribute("NbShapes", str(ubound(shapes)))
		  'for i = 0 to ubound(shapes)
		  'EL1.setattribute("IdSh"+str(i), str(shapes(i)))
		  'next
		  'if ubound(csted) > -1 then
		  'EL1.SetAttribute("NbCsted",str(ubound(csted)))
		  'for i = 0 to ubound(csted)
		  'EL1.setattribute("IdCst"+str(i), str(csted(i)))
		  'next
		  'end if
		  'EL.appendchild EL1
		  'end if
		  ''elseif support <> nil then
		  ''EL = Support.XMLPutIdInContainer(Doc)
		  ''EL.SetAttribute("Ident", "Shape")
		  ''end if
		  ''end if
		  ''EL.appendchild EL1
		  ''
		  ''Myself.appendchild EL
		  'return EL
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  Dim Myself, EL, EL1 as XMLElement
		  dim i as integer
		  
		  
		  Myself= Doc.CreateElement(GetName)
		  Myself.appendchild Remplacement.XMLPutInContainer(Doc)
		  if remplace <> nil then
		    EL = Remplace.XMLPutInContainer(Doc)
		    EL.SetAttribute("Ident", "Point")
		    EL1 = Doc.CreateElement("Parents")
		    EL1.SetAttribute("Nb", str(ubound(shapes)))
		    for i = 0 to ubound(shapes)
		      EL1.setattribute("Id"+str(i), str(shapes(i)))
		    next
		    EL.appendchild EL1
		    if ubound(csted) > -1 then
		      EL1 = Doc.CreateElement("Csted")
		      EL1.SetAttribute("Nb",str(ubound(csted)))
		      for i = 0 to ubound(csted)
		        EL1.setattribute("Id"+str(i), str(csted(i)))
		      next
		      EL.appendchild EL1
		    end if
		    Myself.appendchild EL
		  elseif support <> nil then
		    EL = Support.XMLPutInContainer(Doc)
		    EL.SetAttribute("Ident", "Shape")
		    Myself.appendchild EL
		  end if
		  return Myself
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim EL, EL1, EL2, EL3, EL4 as XMLElement
		  dim List as XMLNodeList
		  dim i, j, n, h as integer
		  dim s as shape
		  
		  EL = XMLElement(Temp.child(0))
		  EL1 = XMLElement(EL.child(0))
		  Remplacement  = point(objects.Getshape(val(EL1.Getattribute("Id"))))
		  if labremplacement <> "" then
		    remplacement.labs.item(0).Text = labremplacement
		  else
		    redim remplacement.labs.objects(-1)
		  end if
		  
		  EL2 = XMLElement(EL.child(1))
		  If EL2.GetAttribute("Ident") = "Point" then
		    Remplace = point(objects.XMLLoadObject(EL2))
		    List = EL2.XQL("Parents")
		    EL3 = XMLElement(List.Item(0))
		    n = val(EL3.GetAttribute("Nb"))
		    for i =  n downto 0
		      h = val(EL3.GetAttribute("Id"+str(i)))
		      s = objects.Getshape(h)
		      s.substitutepoint(remplace, remplacement)
		    next
		    List = EL2.XQL("Csted")
		    if List.length > 0 then
		      EL3 = XMLElement(List.Item(0))
		      n = val(EL3.GetAttribute("Nb"))
		      for i =  n downto 0
		        h = val(EL3.GetAttribute("Id"+str(i)))
		        s = objects.Getshape(h)
		        remplacement.removeconstructedshape s
		        s.constructedby.shape = remplace
		        remplace.constructedshapes.append s
		      next
		    end if
		    if remplacement.constructedby <> nil then                // p remplace les ptsconsted avec lesquels il coïncide
		      s = remplacement.constructedby.shape               // valable pour les transfos, duplicata, découpes  ...
		      s.RemoveConstructedShape(remplacement)
		      s.AddConstructedshape(remplace)
		      remplace.constructedby = remplacement.constructedby
		      remplacement.constructedby = nil
		    end if
		    
		    
		    if remplacement.pointsur.count >0 then
		      for i = remplacement.pointsur.count-1 downto 0
		        s = remplacement.pointsur.item(i)
		        remplacement.removepointsur(s)
		        remplace.puton s
		      next
		    end if
		    remplace.mobility
		    remplacement.mobility
		  else
		    support = objects.getshape(val(EL2.Getattribute("Id")))
		    remplacement.removepointsur(support)
		  end if
		  ReDeleteCreatedFigures(Temp)
		  ReCreateDeletedFigures(Temp)
		  
		  
		  
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
		csted(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		labremplace As string
	#tag EndProperty

	#tag Property, Flags = &h0
		labremplacement As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Remplace As point
	#tag EndProperty

	#tag Property, Flags = &h0
		Remplacement As point
	#tag EndProperty

	#tag Property, Flags = &h0
		shapes(-1) As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		support As shape
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
			Name="labremplace"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="labremplacement"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
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
