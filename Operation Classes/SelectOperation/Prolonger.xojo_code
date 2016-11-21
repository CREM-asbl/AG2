#tag Class
Protected Class Prolonger
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  super.Constructor
		  OpId = 28
		  wnd.PointerPolyg
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(MExe as MacroExe, EL1 as XMLElement)
		  dim n, rid as integer
		  
		  Constructor()
		  n = val(EL1.GetAttribute("Id"))
		  rid = MExe.GetRealId(n)
		  Bip = objects.GetShape(rid)
		  cot = MExe.GetRealSide(n)
		  DoOperation
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub deplacerptssur()
		  dim s as shape
		  dim i,j, op as integer
		  dim Bib1, Bib2 as BiBPoint
		  dim r1, r2 as double
		  dim w as BasicPoint
		  dim p as point
		  
		  objects.unselectall
		  
		  'if Bip isa polygon then
		  for i =  ubound(Bip.childs) downto Bip.npts
		    p = Bip.Childs(i)
		    select case p.forme
		    case 1
		      if p.numside(0) = ibip then
		        p.removepointsur Bip
		        p.puton Dr
		      end if
		    case 2 
		      j = p.PointSur.GetPosition(Bip)
		      s = p.PointSur.item(1-j)
		      p.removepointsur Bip
		      p.puton Dr
		      p.adjustinter(s,Dr)
		    end select
		  next
		  'end if
		  
		  for i = 2 to ubound(Dr.childs)
		    p = Dr.childs(i)
		    for j = 0 to ubound(p.parents)
		      s = p.parents(j)
		      if s <> Dr and s.isaparaperp then
		        w = droite(s).constructbasis
		        bib1 = new Bibpoint(droite(s).firstp, droite(s).firstp+w)
		        bib2 = new Bibpoint(Dr.firstp, Dr.secondp)
		        w = Bib1.BiBInterdroites(Bib2,droite(s).nextre, Dr.nextre,r1, r2)
		        if w <> nil then
		          p.valider
		          point(p).moveto w
		          p.puton Dr
		        end if
		      end if
		    next
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i, j as integer
		  
		  Bip = currenthighlightedshape
		  if not currentcontent.macrocreation then
		    CurrentContent.TheFigs.Removefigure Bip.fig
		  end if
		  GetSide
		  
		  Dr = new Droite(objects, Bip.points(ibip), bip.points(jbip), 0)
		  if Bip isa Lacet then
		    Lacet(Bip).prol(ibip) = true
		  end if
		  
		  deplacerptssur
		  Dr.endconstruction
		  
		  Dr.setconstructedby Bip, 8
		  Dr.Constructedby.data.append ibip
		  
		  for i = 2 to ubound(Dr.childs)
		    Dr.childs(i).fig = Dr.fig
		    Dr.fig.PtsSur.addshape Dr.childs(i)
		    for j = 0 to Dr.fig.subs.count - 1
		      if Dr.fig.subs.item(j).shapes.getposition(Dr) <> -1 then
		        Dr.fig.subs.item(j).PtsSur.addshape Dr.childs(i)
		      end if
		    next
		  next
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  
		  super.endoperation
		  
		  Bip = nil
		  Dr = nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return   Dico.value("Prolonger")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s as shape
		  dim i as integer
		  
		  s = operation.GetShape(p)
		  
		  if s = nil then
		    return nil
		  end if
		  dim n as integer
		  
		  nobj = visible.count-1
		  for i = visible.count-1 downto 0
		    s = Visible.item(i)
		    if not s.ValidSegment(p,ibip) or ( s isa Lacet and Lacet(s).prol(ibip) ) then  //le côté a déjà été prolongé
		      visible.removeobject(s)
		    end if
		    if s isa Lacet then
		      n = s.pointonside(p)
		      if n <> -1 and s.coord.curved(n) = 1 then
		        visible.removeobject(s)
		      end if
		    end if
		    
		    if s isa droite and droite(s).nextre = 0 then
		      visible.removeobject s
		    end if
		  next
		  
		  nobj = visible.count
		  redim index(-1)
		  redim index(nobj)
		  
		  iobj = 0
		  
		  for i = 0 to visible.count-1
		    s = visible.item(i)
		    if s isa droite then
		      index(i) = 0
		    else
		      index(i) = Lacet(s).pointonside(p)
		    end if
		  next
		  
		  s = visible.item(iobj)
		  if s = nil then
		    return nil
		  end if
		  cot = index(iobj)
		  return s
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetSide()
		  
		  if Bip isa cube then
		    cube(Bip).GetIbipJbip(cot,ibip,jbip)
		  elseif Bip isa Lacet  then
		    ibip = cot
		    jbip = (cot+1) mod Bip.npts
		  elseif Bip isa droite then
		    ibip = 0
		    jbip = 1
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim sh as shape
		  
		  sh = currenthighlightedshape
		  display = ""
		  if visible  = nil or sh = nil then
		    display = choose + asegment + ou + asideofpoly
		  else
		    super.paint(g)
		    if sh isa Lacet then
		      Lacet(sh).PaintSide(g,cot,2,config.highlightcolor)
		      'end if
		      'if currentcontent.macrocreation then
		      if sh.coord.curved(cot)=0 then
		        display = thissideofpoly + "?"
		      else
		        display = thisarc + "?"
		      end if
		    else
		      display = thissegment + "?"
		    end if
		  end if
		  Help g, display
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim  EL1, EL2  as XMLElement
		  dim i as integer
		  dim p as point
		  
		  EL1 = XMLElement(Temp.child(0))
		  EL2 = XMLElement(EL1.child(0))
		  Bip = objects.getshape(val(EL2.GetAttribute("Id")))
		  EL2 = XMLElement(EL1.child(1))
		  Dr = Droite(Objects.XMLLoadObject(EL2))
		  ibip = val(EL2.GetAttribute("Ibip"))
		  jbip = (ibip+1) mod Bip.npts
		  if Bip isa Polygon then
		    Polygon(Bip).prol(ibip) = true
		  end if
		  
		  for i =  ubound(Bip.childs) downto Bip.npts
		    p = Bip.Childs(i)
		    if p.numside(0) = ibip then
		      p.removepointsur Bip
		      p.puton Dr
		    end if
		  next
		  
		  
		  
		  RedeleteDeletedFigures(temp)
		  RecreateCreatedFigures(temp)
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub replacerperp()
		  dim j as integer
		  dim p as point
		  
		  
		  
		  
		  for j = ubound(Dr.childs) downto  Dr.npts
		    p = Dr.Childs(j)
		    p.removepointsur Dr
		    p.puton bip
		    p.numside(0) = ibip
		    if Bip.pointonside(p.bpt) = -1 then
		      p.invalider
		    end if
		    if p.location(0) < 0 or p.location(0)> 1 then
		      p.invalider
		    end if
		  next
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XmlDocument, EL as XMLElement) As XMLElement
		  dim Temp as XMLElement
		  
		  Temp =  Dr.XMLPutIdInContainer(Doc)
		  Temp.AppendChild DR.XMLPutChildsInContainer(Doc)
		  EL.appendchild Temp
		  EL.AppendChild Dr.XMLPutConstructionInfoInContainer(Doc)
		  
		  return EL
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  dim Temp, EL as XMLElement
		  
		  Temp=Doc.CreateElement(GetName)
		  Temp.appendChild Bip.XMLPutInContainer(Doc)
		  'if Bip isa Polygon then
		  EL = Dr.XMLPutIncontainer(Doc)
		  EL.SetAttribute("Ibip", str(ibip))
		  Temp.Appendchild EL
		  'end if
		  return Temp
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim  EL1, EL2  as XMLElement
		  
		  
		  EL1 = XMLElement(Temp.child(0))
		  EL2 = XMLElement(EL1.child(0))
		  Bip = objects.getshape(val(EL2.GetAttribute("Id")))
		  
		  EL2 = XMLElement(EL1.child(1))
		  Dr = droite(objects.getshape(val(EL2.GetAttribute("Id"))))
		  if Bip isa Polygon then
		    ibip = val(EL2.GetAttribute("Ibip"))
		    polygon(Bip).prol(ibip) = false
		  end if
		  replacerperp
		  
		  dr.delete
		  RedeleteCreatedFigures(temp)
		  RecreateDeletedFigures(temp)
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
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
		BiP As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		cot As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Dr As Droite
	#tag EndProperty

	#tag Property, Flags = &h0
		ibip As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		jbip As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="canceling"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="cot"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="ibip"
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
			Name="jbip"
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
