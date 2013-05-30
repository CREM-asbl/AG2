#tag Class
Protected Class Retourner
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Retourner()
		  SelectOperation()
		  OPId=16
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLelement
		  dim Temp as XMLElement
		  
		  Temp=Doc.CreateElement(GetName)
		  Temp.appendchild tempshape.XMLPutIdInContainer(Doc)
		  
		  Temp.SetAttribute("CX", str(C.x))
		  Temp.SetAttribute("CY", str(C.y))
		  
		  Temp.SetAttribute("PX", str(P.x))
		  Temp.SetAttribute("PY", str(P.y))
		  
		  if Config.Trace then
		    Temp.SetAttribute("Trace", "true")
		  else
		    Temp.setattribute("Trace","false")
		  end if
		  
		  return Temp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim EL, EL1, EL2 as XMLElement
		  dim cx, cy, px, py as double
		  dim tr as string
		  
		  
		  EL = XMLElement(Temp.child(0))
		  cx = val(EL.GetAttribute("CX"))
		  cy = val(EL.GetAttribute("CY"))
		  c = new BasicPoint(cx,cy)
		  px = val(EL.GetAttribute("PX"))
		  py = val(EL.GetAttribute("PY"))
		  p = new BasicPoint(px,py)
		  
		  if p.x = 2 then
		    angle = 0
		  elseif p.x = 0 then
		    angle = PIDEMI
		  else
		    angle = (PI/4)*sign(p.y)
		  end if
		  
		  tr = EL.GetAttribute("Trace")
		  if tr = "true" then
		    Config.Trace = true
		  else
		    Config.Trace = false
		  end if
		  
		  SelectIdForms(EL)
		  DoOperation
		  if not Config.Trace then
		    objects.unselectall
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim  P1, P2,q As BasicPoint
		  dim alpha as double
		  dim i as integer
		  dim pt As point
		  
		  SelectOperation.Paint(g)
		  if dret = nil then
		    if CurrentHighlightedShape = nil   or ((CurrentHighlightedShape isa point) and (Point(currenthighlightedshape).ispointoncube) ) then
		      return
		    end if
		    if currenthighlightedshape isa point and ubound(point(currenthighlightedshape).parents) > 0   then
		      pt = point(currenthighlightedshape)
		      currentshape = pt.parents(0)
		      for i = 0 to ubound(pt.parents)
		        pt.parents(i).highlight
		        pt.parents(i).paint(g)
		      next
		    end if
		    C =CurrentHighlightedShape.GetGravityCenter
		    C.Paint(g)
		    q = Muser
		    q = q - c
		    alpha = q.anglepolaire
		    if abs(alpha) <= PI/8 or abs(alpha-PI) <= PI/8  or abs(alpha-2*PI)  <= PI/8 then
		      angle = 0
		      P = new BasicPoint(2,0)
		    elseif abs(alpha-PIDEMI) <= PI/8 or abs(alpha-3*PIDEMI) <= PI/8 then
		      angle = PIDEMI
		      P = new BasicPoint(0,2)
		    elseif abs(alpha-PI/4) < PI/8 or abs(alpha-5*PI/4) < PI/8 then
		      angle = PI/4
		      P = new BasicPoint(sqrt(2),sqrt(2))
		    elseif abs(alpha-3*PI/4) < PI/8 or abs(alpha-7*PI/4) < PI/8 then
		      angle = -PI/4
		      P = new BasicPoint(sqrt(2),-sqrt(2))
		    end if
		    
		    if p <> nil then
		      g.forecolor = Config.Transfocolor.col
		      P1 = C + P
		      P1 = Wnd.Mycanvas1.Transform(P1)
		      P2 = C - P
		      P2 = Wnd.Mycanvas1.Transform(P2)
		      g.drawline P1.x, P1.y, P2.x, P2.y
		      display = choose + anaxis + puis + click
		      Help g, display
		    end if
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Retourner(C as BasicPoint, P as BasicPoint)
		  SelectOperation()
		  OPId=16
		  self.C = C
		  self.P = P
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("Flip")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(P as BasicPoint) As shape
		  dim s as shape
		  dim i as integer
		  
		  s = super.getshape(p)
		  
		  if visible.count > 0 then
		    for i = 0 to visible.count-1
		      s = Visible.element(i)
		      if (s isa cube)  or (s isa point and point(s).pointoncube) or not choixvalide(s)   then
		        Visible.removeShape(s)
		        nobj = visible.count
		        i = i-1
		      end if
		    next
		  end if
		  
		  if Visible.count > 0  then
		    return visible.element(0)
		  else
		    return nil
		  end if
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i as integer
		  
		  if c = nil or p = nil then
		    return
		  end if
		  
		  currentshape = tempshape.element(0)
		  if currentshape isa point then
		    if UBound(point(currentshape).parents) > -1 then
		      currentshape = point(currentshape).parents(0)
		    else
		      return
		    end if
		  end if
		  if currentshape <> nil then
		    currentshape.selectneighboor
		  end if
		  
		  for i = 0 to tempshape.count-1
		    figs.addfigure tempshape.element(i).fig
		  next
		  
		  if  config.Trace  then
		    dret = new RetTimer(tempshape,self)
		  else
		    DoOper
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOper()
		  dim M as Matrix
		  dim i, j as integer
		  dim s as shape
		  dim t as Boolean
		  
		  M = new SymmetryMatrix(c,c+p)
		  
		  figs.creerlistesfigures
		  figs.Bouger(M)
		  
		  for i = 0 to tempshape.count -1
		    s = tempshape.element(i)
		    s.signaire = - s.signaire
		    s.ori = -s.ori
		    
		    if not Config.Trace then
		      if Config.stdbiface or ( s.Ti <> nil and (s.fillcolor.equal(poscolor) or s.fillcolor.equal(negcolor) )) then
		        s.fixecouleurfond(s.fillcolor.comp, s.fill)
		      end if
		    end if
		    if s isa standardpolygon then
		      standardpolygon(s).updateangle
		    end if
		    
		    for j = 0 to ubound(s.constructedshapes)
		      if s.constructedshapes(j).constructedby<> nil and s.constructedshapes(j).constructedby.oper =6  then
		        s.constructedshapes(j).ori = - s.constructedshapes(j).ori
		      end if
		    next
		    if s isa arc then
		      arc(s).updateangles
		    end if
		    if s isa circle then
		      circle(s).CreateExtreAndCtrlPoints
		    end if
		    if s isa Lacet then
		      Lacet(s).CreateExtreAndCtrlPoints
		    end if
		  next
		  
		  if s = currentcontent.SHUA then
		    currentcontent.UA = - currentcontent.UA
		  end if
		  
		  tempshape.inverserordre
		  currentcontent.thefigs.enablemodifyall
		  figs.updatematrixduplicatedshapes(M)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  UndoOperation(Temp)
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
		C As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		P As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		angle As double
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
			Name="angle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
