#tag Class
Protected Class Prolonger
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Prolonger()
		  
		  SelectOperation
		  OpId = 28
		  wnd.PointerPolyg
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return   Dico.value("Prolonger")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLelement
		  dim Temp, EL as XMLElement
		  
		  Temp=Doc.CreateElement(GetName)
		  Temp.appendChild Bip.XMLPutInContainer(Doc)
		  if Bip isa Polygon then
		    EL = Dr.XMLPutIncontainer(Doc)
		    EL.SetAttribute("Ibip", str(ibip))
		    Temp.Appendchild EL
		  end if
		  return Temp
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim sh as shape
		  
		  sh = currenthighlightedshape
		  display = ""
		  if visible  = nil or sh = nil then
		    if app.macrocreation then
		      display = choose + asideofpoly
		    else
		      display = choose + asegment
		    end if
		  else
		    super.paint(g)
		    sh.highlightsegment(g, cot)
		    if app.macrocreation then
		      display = thissideofpoly + "?"
		    else
		      display = thissegment + "?"
		    end if
		  end if
		  Help g, display
		  
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
		Sub UndoOperation(Temp as XMLElement)
		  dim  EL1, EL2  as XMLElement
		  
		  
		  EL1 = XMLElement(Temp.child(0))
		  EL2 = XMLElement(EL1.child(0))
		  Bip = objects.getshape(val(EL2.GetAttribute("Id")))
		  
		  if Bip isa droite then
		    Droite(Bip).nextre = 2
		    Bip.forme = Bip.forme - 3
		    Dr = Droite(Bip)
		  else
		    EL2 = XMLElement(EL1.child(1))
		    Dr = droite(objects.getshape(val(EL2.GetAttribute("Id"))))
		    ibip = val(EL2.GetAttribute("Ibip"))
		    polygon(Bip).prol(ibip) = false
		    
		  end if
		  replacerperp
		  
		  if not (bip isa droite) then
		    dr.delete
		  end if
		  RedeleteCreatedFigures(temp)
		  RecreateDeletedFigures(temp)
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
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
		  if Bip isa droite then
		    Dr = droite(bip)
		    Droite(Bip).nextre = 0
		    Bip.forme = Bip.forme + 3
		    ibip = 0
		    jbip = 1
		  else
		    EL2 = XMLElement(EL1.child(1))
		    Dr = Droite(Objects.XMLLoadObject(EL2))
		    ibip = val(EL2.GetAttribute("Ibip"))
		    jbip = (ibip+1) mod Bip.npts
		    Polygon(Bip).prol(ibip) = true
		    
		    for i =  ubound(Bip.childs) downto Bip.npts
		      p = Bip.Childs(i)
		      if p.numside(0) = ibip then
		        p.removepointsur Bip
		        p.puton Dr
		      end if
		    next
		    
		  end if
		  
		  RedeleteDeletedFigures(temp)
		  RecreateCreatedFigures(temp)
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i, j as integer
		  
		  
		  Bip = currenthighlightedshape
		  CurrentContent.TheFigs.Removefigure Bip.fig
		  GetSide
		  
		  if Bip isa droite then
		    Dr = Droite(Bip)
		    Droite(Bip).nextre = 0
		    Dr.forme = Bip.forme + 3
		    Dr.fig = nil
		  elseif Bip isa polygon then
		    Dr = new Droite(objects, Bip.points(ibip), bip.points(jbip), 0)
		    Polygon(Bip).prol(ibip) = true
		  end if
		  
		  deplacerperp
		  Dr.endconstruction
		  
		  if Bip isa polygon then
		    Dr.setconstructedby Bip, 8
		    Dr.Constructedby.data.append ibip
		  end if
		  
		  for i = 2 to ubound(Dr.childs)
		    Dr.childs(i).fig = Dr.fig
		    Dr.fig.PtsSur.addshape Dr.childs(i)
		    for j = 0 to Dr.fig.subs.count - 1
		      if Dr.fig.subs.element(j).shapes.getposition(Dr) <> -1 then
		        Dr.fig.subs.element(j).PtsSur.addshape Dr.childs(i)
		      end if
		    next
		  next
		  
		  modifiertsf
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub deplacerperp()
		  dim s as shape
		  dim i,j, op as integer
		  dim Bib1, Bib2 as BiBPoint
		  dim r1, r2 as double
		  dim w as BasicPoint
		  dim p as point
		  objects.unselectall
		  
		  if Bip isa polygon then
		    for i =  ubound(Bip.childs) downto Bip.npts
		      p = Bip.Childs(i)
		      if p.numside(0) = ibip then
		        p.removepointsur Bip
		        p.puton Dr
		      end if
		    next
		  end if
		  
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
		Sub replacerperp()
		  dim j as integer
		  dim p as point
		  
		  
		  
		  if not (Bip isa droite) then
		    for j = ubound(Dr.childs) downto  Dr.npts
		      p = Dr.Childs(j)
		      p.removepointsur Dr
		      p.puton bip
		      p.numside(0) = ibip
		      if Bip.pointonside(p.bpt) = -1 then
		        p.invalider
		      end if
		    next
		  else
		    for j = Dr.npts to ubound(Dr.childs)
		      p = Dr.Childs(j)
		      if p.location(0) < 0 or p.location(0)> 1 then
		        p.invalider
		      end if
		    next
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Modifiertsf()
		  dim i as integer
		  dim op as integer
		  dim s as shape
		  
		  if Bip isa polygon then
		    for i =  ubound(Bip.constructedshapes) downto 0
		      if Bip.constructedshapes(i).isaparaperp  and Bip.constructedshapes(i).constructedby.data(0) = ibip then
		        s = Bip.ConstructedShapes(i)
		        droite(s).modifiertsf(Bip, Dr, 0)
		      end if
		    next
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetSide()
		  
		  if Bip isa cube then
		    cube(Bip).GetIbipJbip(cot,ibip,jbip)
		  elseif Bip isa polygon then
		    ibip = cot
		    jbip = (cot+1) mod Bip.npts
		  elseif Bip isa droite then
		    ibip = 0
		    jbip = 1
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s as shape
		  dim i as integer
		  
		  s = operation.GetShape(p)
		  
		  if s = nil then
		    return nil
		  end if
		  
		  
		  nobj = visible.count
		  for i = visible.count-1 downto 0
		    s = Visible.element(i)
		    if not s.ValidSegment(p,ibip) or ( s isa polygon and polygon(s).prol(ibip) ) then  //le côté a déjà été prolongé
		      visible.removeshape(s)
		    end if
		    if s isa droite and app.macrocreation then
		      visible.removeshape s
		    end if
		  next
		  
		  nobj = visible.count
		  redim index(nobj)
		  
		  iobj = 0
		  
		  for i = 0 to visible.count-1
		    s = visible.element(i)
		    if s isa droite then
		      index(i) = 0
		    else
		      index(i) = polygon(s).pointonside(p)
		    end if
		  next
		  
		  s = visible.element(iobj)
		  if s = nil then
		    return nil
		  end if
		  cot = index(iobj)
		  return s
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XmlDocument, EL as XMLElement) As XMLelement
		  if not Bip isa Polygon then
		    return nil
		  end if
		  EL.appendchild Dr.XMLPutIdINContainer(Doc)
		  EL.AppendChild Dr.XMLPutConstructionInfoInContainer(Doc)
		  
		  return EL
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
		BiP As shape
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

	#tag Property, Flags = &h0
		cot As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ntsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
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
			Name="HistId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="ibip"
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
			Name="cot"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
