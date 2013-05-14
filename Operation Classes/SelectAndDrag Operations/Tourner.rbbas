#tag Class
Protected Class Tourner
Inherits SelectAndDragOperation
	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("Tourner")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Tourner()
		  
		  SelectAndDragOperation()
		  OpId = 23
		  c = nil
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  
		  selectAndDragOperation.Paint(g)
		  
		  
		  
		  if  CurrentHighlightedShape = nil and  tempshape.count  = 0 then
		    Help g,  choose + aform
		  elseif (C = nil or CurrentHighlightedShape isa point) and tempshape.count > 0 then
		    Help g,  choose + lecentre
		  else
		    Help g,  drag+ pour + letturn
		  end if
		  
		  if CurrentHighlightedShape <> nil and CurrentHighlightedShape.Hidden then
		    CurrentHighlightedShape.Show
		    CurrentHighlightedShape.HighLight
		    CurrentHighlightedShape.Paint(g)
		    CurrentHighlightedShape.UnHighLight
		    CurrentHighlightedShape.Hide
		  end if
		  
		  if C <> nil then
		    c.paint(g)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLelement
		  Dim Myself as XmlElement
		  
		  Myself= Doc.CreateElement("Tourner")
		  Myself.appendchild tempshape.XMLPutIdInContainer(Doc)
		  Myself.Setattribute("CX", str(c.x))
		  Myself.Setattribute("CY", str(c.y))
		  Myself.SetAttribute("Angle",str(angle))
		  Myself.Setattribute("startx", str(startpoint.x))
		  Myself.Setattribute("starty", str(startpoint.y))
		  Myself.Setattribute("endx", str(endpoint.x))
		  Myself.Setattribute("endy", str(endpoint.y))
		  return Myself
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p As BasicPoint) As Shape
		  dim i as integer
		  dim s as Shape
		  
		  s=super.GetShape(p)
		  
		  if visible.count > 0 then
		    for i =  visible.count-1 downto 0
		      s = Visible.element(i)
		      if tempshape.count > 1 then
		        if C <> nil or  not s.selected then
		          Visible.removeShape(s)
		        end if
		      end if
		      nobj = visible.count
		    next
		  end if
		  
		  if visible.count > 0 then
		    for i =  visible.count-1 downto 0
		      s = Visible.element(i)
		      if not choixvalide(s) then
		        Visible.removeShape(s)
		      end if
		    next
		  end if
		  nobj = visible.count
		  
		  if Visible.count > 0  then
		    return visible.element(0)
		  else
		    return nil
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p As BasicPoint)
		  super.mousedown(p)
		  
		  if currenthighlightedshape  = nil then
		    return
		  end if
		  
		  if CurrenthighlightedShape isa point then
		    c = point(CurrenthighlightedShape).Bpt
		  else
		    c = currenthighlightedshape.getgravitycenter
		  end if
		  
		  if not choixvalide(currenthighlightedshape) then
		    currenthighlightedshape = nil
		    c = nil
		    CurrentContent.theobjects.unselectall
		    finished = true
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CompleteOperation(Newpoint As BasicPoint)
		  dim i as integer
		  dim M as Matrix
		  dim a as double
		  dim oldpt as basicpoint
		  dim s as Shape
		  
		  if NewPoint=EndPoint then
		    return
		  end if
		  
		  if tempshape.element(0) isa repere then
		    c = new basicpoint(wnd.mycanvas1.width/2,wnd.mycanvas1.height/2)
		    a = GetAngle(c,newpoint)-GetAngle(c,endpoint)
		    M = new RotationMatrix(c,a)
		    Repere(tempshape.element(0)).Origine = M*Repere(tempshape.element(0)).Origine
		    M = new Rotationmatrix(new BasicPoint(0,0),a)
		    tempshape.element(0).Transform(M)
		    endpoint = newpoint
		    CurrentContent.theobjects.updateskull
		    wnd.MyCanvas1.refreshbackground
		    return
		  end if
		  
		  if tempshape.count = 0 then
		    return
		  end if
		  
		  if C <>nil then
		    a = GetAngle(c,NewPoint)-GetAngle(c,EndPoint)
		    M = new RotationMatrix(c,a)
		    figs.Bouger(M)
		    updateangles(a)
		  end if
		  
		  EndPoint =NewPoint
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  
		  Super.EndOperation
		  C = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseUp(p as BasicPoint)
		  dim M as Matrix
		  
		  if c <> nil then
		    angle = GetAngle(c,EndPoint)-GetAngle(c,StartPoint)
		    M = new RotationMatrix(c,angle)
		    currentcontent.thefigs.enablemodifyall
		    figs.updatematrixduplicatedshapes(M)
		    super.MouseUp(p)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim i as integer
		  dim M as Matrix
		  dim EL as XMLElement
		  dim a as double
		  dim NewPoint as BasicPoint
		  
		  EL = XMLElement(Temp.child(0))
		  SelectIdForms(EL)
		  currentshape = tempshape.element(0)
		  c = new basicpoint(val(EL.GetAttribute("CX")), val(EL.GetAttribute("CY")))
		  startpoint = new Basicpoint(val(EL.GetAttribute("startx")),val(EL.GetAttribute("starty")))
		  endpoint = new Basicpoint(val(EL.GetAttribute("endx")),val(EL.GetAttribute("endy")))
		  a = val(EL.GetAttribute(Dico.value("Angle")))
		  M = new RotationMatrix(c,a)
		  
		  if  currentshape isa repere then
		    if Config.Trace then
		      dret = new ModifTimer(self)
		    else
		      Repere(currentshape).Origine = M*Repere(currentshape).Origine
		      M = new Rotationmatrix(new BasicPoint(0,0),a)
		      currentshape.Transform(M)
		    end if
		    CurrentContent.theobjects.updateskull
		  else
		    for i = 0 to tempshape.count-1
		      figs.addfigure tempshape.element(i).fig
		    next
		    figs.creerlistesfigures
		    if Config.Trace then
		      dret = new ModifTimer(self)
		    else
		      NewPoint = EndPoint
		      EndPoint = StartPoint
		      CompleteOperation(NewPoint)
		    end if
		  end if
		  Objects.EnableModifyAll
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim  M as Matrix
		  dim a, cx, cy as Double
		  dim EL as XMLElement
		  
		  EL = XMLElement(Temp.child(0))
		  SelectIdForms(EL)
		  
		  a = val(EL.GetAttribute(Dico.value("Angle")))
		  a = -a
		  
		  if tempshape.element(0) isa repere then
		    cx = val(EL.GetAttribute("CX"))
		    cy = val(EL.GetAttribute("CY"))
		    c = new basicpoint(cx, cy)
		    M = new RotationMatrix(c,a)
		    Repere(tempshape.element(0)).Origine = M*Repere(tempshape.element(0)).Origine
		    M = new Rotationmatrix(new BasicPoint(0,0),a)
		    tempshape.element(0).Transform(M)
		    CurrentContent.theobjects.updateskull
		  else
		    super.UndoOperation(Temp)
		    Updateangles(a)
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
		c As BasicPoint
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
			Name="drapUA"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="SelectAndDragOperation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapUL"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="SelectAndDragOperation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Group="Behavior"
			Type="string"
			InheritedFrom="Operation"
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
			Name="Angle"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			InheritedFrom="SelectAndDragOperation"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
