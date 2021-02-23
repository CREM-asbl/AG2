#tag Class
Protected Class Redimensionner
Inherits SelectAndDragOperation
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
		    C= new BasicPoint(can.width/2,can.height/2)
		    newpoint = can.mousecan
		    k= NewPoint.Distance(c)/EndPoint.Distance(c)
		    if k < epsilon then
		      return
		    end if
		    newrep(c,k)
		    objects.updatecubes(0,k)
		    endpoint = newpoint
		    super.completeoperation(NewPoint)
		    return
		  end if
		  
		  C = CurrentShape.getgravitycenter
		  
		  if  (c<>NewPoint) and (c <> endpoint)  and (c <> nil) then
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
		  
		  super.completeoperation(NewPoint)
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMethod(GetName,"CompleteOperation")
		    d.setVariable("C",C)
		    err.message = err.message+d.getString
		    
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
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
		Sub Constructor(EL as XMLElement)
		  dim EL1 as XMLElement
		  dim List as XmlNodeList
		  
		  super.constructor
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
		    d.setMethod(GetName,"Redimensionner(EL as XMLElement)")
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
		    objects.updatecubes(0,M1.rapport)
		  else
		    figs.Bouger(M1)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  
		  super.endoperation
		  c = nil
		  M1 = nil
		  
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMethod(getName,"EndOperation")
		    d.setVariable("CurrentShape",CurrentShape)
		    d.setVariable("C",C)
		    err.message = err.message+d.getString
		    
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return  Dico.Value("Zoom")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s as shape
		  dim i, j as integer
		  
		  s = super.getshape(p)
		  
		  if visible.count > 0  then
		    nobj = visible.count
		    for i =  nobj-1 downto 0
		      s = Visible.item(i)
		      if currentcontent.macrocreation then
		        visible.removeobject(s)
		      end if
		      for j = 0 to s.fig.shapes.count-1
		        if s.fig.shapes.item(j).std then
		          visible.removeobject(s)
		        end if
		      next
		      if   s isa point  or  not choixvalide(s)  then
		        Visible.removeobject(s)
		      end if
		      nobj = visible.count
		    next
		  end if
		  
		  if Visible.count > 0  then
		    return visible.item(0)
		  else
		    return nil
		  end if
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("P",p)
		    d.setVariable("Visible", Visible)
		    d.setVariable("i",i)
		    d.setVariable("s",s)
		    err.message = err.message+d.getString
		    
		    Raise err
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseUp(p as BasicPoint)
		  dim M as Matrix
		  
		  if currentshape = nil then
		    can.mousecursor = System.Cursors.StandardPointer
		    oldvisible.tspfalse
		  elseif c <> nil then
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

	#tag Method, Flags = &h0
		Sub NewRep(c as BasicPoint, k as double)
		  repere(CurrentShape).origine =  c + (repere(CurrentShape).origine -c) *k
		  repere(CurrentShape).Idx = repere(CurrentShape).Idx * k
		  repere(CurrentShape).Idy = repere(CurrentShape).Idy * k
		  can.setrepere(repere(CurrentShape))
		  CurrentContent.theobjects.updatelabels(k)
		  
		End Sub
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
		Sub RedoOperation(Temp as XMLElement)
		  dim  M as Matrix
		  dim r, cx, cy as Double
		  dim EL as XMLElement
		  dim i, niter as integer
		  dim NewPoint as BasicPoint
		  
		  niter = 60
		  
		  EL = XMLElement(Temp.child(0))
		  SelectIdForms(EL)
		  currentshape = tempshape.item(0)
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
		      objects.updatecubes(0,ratio)
		    end if
		  else
		    for i = 0 to tempshape.count-1
		      figs.addobject tempshape.item(i).fig
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
		Function ToXML(Doc as XMLDocument) As XMLElement
		  Dim Myself as XMLElement
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
		Sub UndoOperation(Temp as XMLElement)
		  dim  M as Matrix
		  dim r as Double
		  dim EL as XMLElement
		  
		  EL = XMLElement(Temp.child(0))
		  SelectIdForms(EL)
		  
		  r = val(EL.GetAttribute(Dico.value("Ratio")))
		  r = 1/r
		  currentshape = tempshape.item(0)
		  
		  
		  if currentshape isa repere then
		    M = new HomothetyMatrix(new BasicPoint(0,0),r)
		    currentshape.Transform(M)
		    objects.updatecubes(0,r)
		  else
		    super.UndoOperation(Temp)
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
		k0 As double
	#tag EndProperty

	#tag Property, Flags = &h0
		M1 As HomothetyMatrix
	#tag EndProperty

	#tag Property, Flags = &h0
		ratio As double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Angle"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
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
			Name="drapUA"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapUL"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="fid"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
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
			Name="k0"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
			Name="OpId"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ratio"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
	#tag EndViewBehavior
End Class
#tag EndClass
