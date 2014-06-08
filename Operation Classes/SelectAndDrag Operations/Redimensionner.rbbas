#tag Class
Protected Class Redimensionner
Inherits SelectAndDragOperation
	#tag Method, Flags = &h0
		Function GetName() As string
		  return  Dico.Value("Zoom")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  super.paint(g)
		  
		  if CurrentHighlightedShape=nil then
		    Help g,  choose + aform
		  else
		    Help g, drag + pour+ letzoom
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLelement
		  Dim Myself as XmlElement
		  dim Temp as XMLElement
		  
		  if c <> nil then
		    ratio=EndPoint.Distance(c)/StartPoint.Distance(c)
		    Myself= Doc.CreateElement(GetName)
		    
		    Myself.AppendChild Tempshape.XMLPutIdInContainer(Doc)
		    Myself.SetAttribute("Ratio",str(ratio))
		    Myself.setattribute("CX", str(c.x))
		    Myself.setattribute("CY", str(c.y))
		    Myself.Setattribute("startx", str(startpoint.x))
		    Myself.Setattribute("starty", str(startpoint.y))
		    Myself.Setattribute("endx", str(endpoint.x))
		    Myself.Setattribute("endy", str(endpoint.y))
		    return Myself
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XmlElement)
		  dim  M as Matrix
		  dim r as Double
		  dim EL as XMLElement
		  
		  EL = XMLElement(Temp.child(0))
		  SelectIdForms(EL)
		  
		  r = val(EL.GetAttribute(Dico.value("Ratio")))
		  r = 1/r
		  currentshape = tempshape.element(0)
		  
		  
		  if currentshape isa repere then
		    M = new HomothetyMatrix(new BasicPoint(0,0),r)
		    currentshape.Transform(M)
		    CurrentContent.theobjects.updateskull
		  else
		    super.UndoOperation(Temp)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Redimensionner()
		  SelectAndDragOperation
		  OpId = 22
		  
		Exception err
		  dim d As Debug
		  d = new Debug
		  d.setMethod(getString,getString)
		  err.message = err.message+d.getString
		  
		  Raise err
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CompleteOperation(NewPoint As BasicPoint)
		  dim k as double
		  dim np as BasicPoint
		  dim i as integer
		  dim M as Matrix
		  dim s As Shape
		  
		  if (tempshape.count = 0) or (NewPoint = EndPoint) then
		    return
		  end if
		  
		  if CurrentShape isa repere then
		    C= new BasicPoint(wnd.Mycanvas1.width/2,wnd.Mycanvas1.height/2)
		    newpoint = wnd.mycanvas1.mousecan
		    k= NewPoint.Distance(c)/EndPoint.Distance(c)
		    if k < epsilon then
		      return
		    end if
		    newrep(c,k)
		    endpoint = newpoint
		    return
		  end if
		  
		  C = CurrentShape.getgravitycenter
		  
		  if  (c<>NewPoint) and (c <> endpoint)  then
		    k= NewPoint.Distance(c)/EndPoint.Distance(c)
		    M = new HomothetyMatrix(c,k)
		    figs.Bouger(M)
		    EndPoint = NewPoint
		    if drapUL then
		      currentcontent.UL = currentcontent.SHUL.longueur(currentcontent.IcotUL)
		    end if
		    if drapUA then
		      currentcontent.UA = currentcontent.SHUA.aire
		    end if
		  end if
		  CurrentContent.TheObjects.EnableModifyAll
		  
		Exception err
		  dim d As Debug
		  d = new Debug
		  d.setMethod(GetName,"CompleteOperation")
		  d.setVariable("C",C)
		  err.message = err.message+d.getString
		  
		  Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s as shape
		  dim i, j as integer
		  s = super.getshape(p)
		  
		  if visible.count > 0  then
		    nobj = visible.count
		    for i =  nobj-1 downto 0
		      s = Visible.element(i)
		      if currentcontent.macrocreation then
		        visible.removeshape(s)
		      end if
		      for j = 0 to s.fig.shapes.count-1
		        if s.fig.shapes.element(j).std then
		          visible.removeshape(s)
		        end if
		      next
		      if   s isa point  or  not choixvalide(s)  then
		        Visible.removeShape(s)
		      end if
		      nobj = visible.count
		    next
		  end if
		  
		  if Visible.count > 0  then
		    return visible.element(0)
		  else
		    return nil
		  end if
		  
		Exception err
		  dim d As Debug
		  d = new Debug
		  d.setMethod("Redimensionner","getShape")
		  d.setVariable("P",p)
		  d.setVariable("Visible", Visible)
		  d.setVariable("i",i)
		  d.setVariable("s",s)
		  err.message = err.message+d.getString
		  
		  Raise err
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim  M as Matrix
		  dim r, cx, cy as Double
		  dim EL as XMLElement
		  dim i, niter as integer
		  dim NewPoint as BasicPoint
		  
		  niter = 60
		  
		  EL = XMLElement(Temp.child(0))
		  SelectIdForms(EL)
		  currentshape = tempshape.element(0)
		  ratio = val(EL.GetAttribute(Dico.value("Ratio")))
		  c = new basicpoint(val(EL.GetAttribute("CX")), val(EL.GetAttribute("CY")))
		  startpoint = new Basicpoint(val(EL.GetAttribute("startx")),val(EL.GetAttribute("starty")))
		  endpoint = new Basicpoint(val(EL.GetAttribute("endx")),val(EL.GetAttribute("endy")))
		  
		  r = ratio^(1/niter)
		  M1 = new HomothetyMatrix(c,r)
		  
		  if  currentshape isa repere then
		    if Config.Trace then
		      dret = new ModifTimer(self)
		    else
		      M = new HomothetyMatrix(new BasicPoint(0,0),ratio)
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
		    c = nil
		  end if
		  objects.enablemodifyall
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Redimensionner(EL as XmlElement)
		  dim EL1 as XmlElement
		  dim List as XmlNodeList
		  
		  Redimensionner
		  SelectIdForms(EL)
		  ratio = Val(EL.GetAttribute("Ratio"))
		  List = EL.XQL(Dico.value("Centre"))
		  if List.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		    c  = new BasicPoint(val(EL1.GetAttribute("X")), val(EL1.GetAttribute("Y")))
		  else
		    c = new BasicPoint(0,0)
		  end if
		  Config.Trace=true
		  
		  
		  
		Exception err
		  dim d As Debug
		  d = new Debug
		  d.setMethod(GetName,"Redimensionner(EL as XmlElement)")
		  d.setVariable("C",C)
		  err.message = err.message+d.getString
		  
		  Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOper(p as BasicPoint)
		  
		  if currentshape isa repere then
		    k0 = 1
		    newrep(c,M1.rapport)
		  else
		    figs.Bouger(M1)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NewRep(c as BasicPoint, k as double)
		  repere(CurrentShape).origine =  c + (repere(CurrentShape).origine -c) *k
		  repere(CurrentShape).Idx = repere(CurrentShape).Idx * k
		  repere(CurrentShape).Idy = repere(CurrentShape).Idy * k
		  wnd.mycanvas1.setrepere(repere(CurrentShape))
		  CurrentContent.theobjects.updateskull
		  CurrentContent.theobjects.updatelabels(k)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  'dim M as Matrix
		  '
		  'if currentshape = nil then
		  'currentcontent.currentoperation = nil
		  'wnd.mycanvas1.mousecursor = arrowcursor
		  'oldvisible.tspfalse
		  'else
		  'ratio=EndPoint.Distance(c)/StartPoint.Distance(c)
		  'M = new HomothetyMatrix(c,ratio)
		  'currentcontent.thefigs.enablemodifyall
		  'figs.updatematrixduplicatedshapes(M)
		  super.endoperation
		  c = nil
		  M1 = nil
		  'end if
		  
		Exception err
		  dim d As Debug
		  d = new Debug
		  d.setMethod(getName,"EndOperation")
		  d.setVariable("CurrentShape",CurrentShape)
		  d.setVariable("C",C)
		  err.message = err.message+d.getString
		  
		  Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseUp(p as BasicPoint)
		  dim M as Matrix
		  
		  if currentshape = nil then
		    wnd.mycanvas1.mousecursor = arrowcursor
		    oldvisible.tspfalse
		  else
		    ratio=EndPoint.Distance(c)/StartPoint.Distance(c)
		    if abs(ratio) > epsilon then
		      M = new HomothetyMatrix(c,ratio)
		      currentcontent.thefigs.enablemodifyall
		      figs.updatematrixduplicatedshapes(M)
		    end if
		    super.mouseup(p)
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
		C As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ratio As double
	#tag EndProperty

	#tag Property, Flags = &h0
		M1 As HomothetyMatrix
	#tag EndProperty

	#tag Property, Flags = &h0
		k0 As double
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
		#tag ViewProperty
			Name="ratio"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="k0"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
