#tag Class
Protected Class Glisser
Inherits SelectAndDragOperation
	#tag Method, Flags = &h0
		Sub CompleteOperation(NewPoint as BasicPoint)
		  dim M as Matrix
		  
		  if NewPoint=EndPoint then
		    return
		  end if
		  
		  M = new Translationmatrix(NewPoint-EndPoint)
		  
		  if CurrentShape isa repere then
		    CurrentShape.Transform(M)
		    endpoint = newpoint
		  elseif NewPoint <> EndPoint and tempshape.count > 0 then
		    Glissement(NewPoint)
		    CurrentContent.TheTransfos.enablemodifyall
		  end if
		  
		  super.CompleteOperation(NewPoint)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  OpId = 20
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.EndOperation
		  Angle=0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  return  Dico.Value("Slide")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As Shape
		  dim s as Shape
		  dim i as integer
		  
		  s = super.GetShape(p)
		  
		  if visible.count > 0 then
		    for i = visible.count-1 downto 0
		      s = Visible.item(i)
		      if (s isa point and Point(s).liberte = 0)  then
		        Visible.removeobject(s)
		      elseif not choixvalide(s) then
		        Visible.removeobject(s)
		      end if
		      nobj = visible.count
		    next
		  end if
		  
		  if Visible.count > 0  then
		    return visible.item(iobj)
		  else
		    return nil
		  end if
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseUp(p as BasicPoint)
		  dim M, M1 as Matrix
		  
		  
		  if currentattractingshape <> nil then
		    M = new TranslationMatrix(MagneticD)
		    figs.Bouger(M)
		    EndPoint=EndPoint+magneticD
		  end if
		  
		  M = new Translationmatrix(endpoint-startpoint)
		  
		  if Config.Ajust  then
		    M1 = Ajustement
		    if M1 <> nil and M1.v1 <> nil  then
		      M = M1*M
		    end if
		  end if
		  currentcontent.thefigs.enablemodifyall
		  figs.updatematrixduplicatedshapes(M)
		  super.mouseup(p)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g As Graphics)
		  super.Paint(g)
		  
		  if CurrentHighlightedShape=nil  and  currentshape = nil then
		    display =  choose + aform
		  else
		    display =drag + pour + letslide
		  end if
		  
		  Help g, display
		  
		  
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
		  
		  if tempshape.count = 0 then
		    return
		  end if
		  
		  currentshape = tempshape.item(0)
		  EndPoint = new BasicPoint(val(EL.GetAttribute("DX")), val(EL.GetAttribute("DY")))
		  StartPoint = new BasicPoint(0,0)
		  
		  if EL.childcount = 2 then
		    EL = XMLElement(EL.child(1))
		    angle = val(EL.Getattribute("angle"))
		    EL = XMLElement(EL.child(0))
		    fid = val(EL.GetAttribute("Id"))
		  end if
		  
		  M = new TranslationMatrix(EndPoint)
		  
		  if  currentshape isa repere then
		    if Config.Trace then
		      dret  = New ModifTimer(Self)
		    else
		      currentshape.Transform(M)
		    end if
		  else
		    for i = 0 to tempshape.count-1
		      figs.addobject tempshape.item(i).fig
		    next
		    figs.creerlistesfigures
		    if Config.Trace and  endpoint.norme/60 > epsilon  then
		      dret = new ModifTimer(self)
		    else
		      figs.Bouger(M)
		      ajuster
		    end if
		    updateangles(angle)
		  end if
		  
		  'Objects.EnableModifyAll
		  CurrentContent.TheTransfos.enablemodifyall
		  CurrentContent.Thefigs.enablemodifyall
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  Dim Myself as XMLElement
		  dim Temp as XMLElement
		  
		  Myself= Doc.CreateElement(GetName)
		  Myself.SetAttribute("DX", str(EndPoint.x-StartPoint.x))
		  Myself.SetAttribute("DY", str(EndPoint.y-StartPoint.y))
		  
		  Myself.appendchild tempshape.XMLPutIdInContainer(Doc)
		  
		  if rotationpoint <> nil then
		    Temp=XMLElement(Doc.CreateElement("Rotation"))
		    Temp.appendchild RotationPoint.XMLPutIdInContainer(Doc)
		    Temp.setattribute("angle",str(angle))
		    Myself.appendchild(Temp)
		  end if
		  return Myself
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim  M as Matrix
		  dim EL as XMLElement
		  dim a as double
		  dim D as BasicPoint
		  
		  EL = XMLElement(Temp.child(0))
		  SelectIdForms(EL)
		  D = new BasicPoint(-val(EL.GetAttribute("DX")), -val(EL.GetAttribute("DY")))
		  
		  if tempshape.item(0) isa repere then
		    CurrentShape = tempshape.item(0)
		    M = new Translationmatrix(D)
		    CurrentShape.Transform(M)
		  else
		    super.UndoOperation(Temp)
		    if EL.childcount = 2 then
		      EL = XMLElement(EL.child(1))
		      a = val(EL.Getattribute("angle"))
		      tempshape.updateangles(-a)
		    end if
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
