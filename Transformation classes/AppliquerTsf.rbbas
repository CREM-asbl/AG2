#tag Class
Protected Class AppliquerTsf
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub AppliquerTsF()
		  MultipleSelectOperation()
		  OpId = 24
		  NumberOfItemsToSelect=2
		  copies = new objectslist
		  
		  MId = new Matrix(1)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("Appliquer")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim str as string
		  
		  if ListTsf = nil then
		    return
		  end if
		  
		  Select case CurrentItemToSet
		  case 1
		    super.paint(g)
		    Helptsf(g)
		  case 2
		    Operation.paint(g)
		    str = imageof
		    if currenthighlightedshape <> nil then
		      select case CurrentHighlightedShape.gettype
		      case Dico.value("Point")
		        str = str+thispoint +"?"
		      else
		        str = str + thisform + "?"
		      end select
		    else
		      str = choose+aform
		    end if
		    Help g, str
		  else
		    wnd.mycanvas1.mousecursor = system.cursors.wait
		    Help g, "Un peu de patience..."
		  end select
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Endoperation()
		  dim i,j as integer
		  
		  super.endoperation
		  CurrentItemToSet=2
		  for i = 0 to copies.count-1
		    for j = 0 to ubound(copies.element(i).points)
		      copies.element(i).points(j).tracept =  false
		    next
		  next
		  copies.removeall
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(s as shape) As Boolean
		  
		  select case CurrentItemtoSet
		  case 1
		    ntsf = ListTsf.count
		    if ntsf > 0 and not ListTsf.element(itsf).M.equal(MId)  then
		      tsf = ListTsf.element(itsf)
		      CurrentContent.TheTransfos.HideAll
		      tsf.Hidden = false
		      wnd.mycanvas1.refreshbackground
		      return true
		    else
		      return false
		    end if
		    
		  case 2
		    if currenthighlightedshape <> nil then
		      if not s.selected then
		        objects.unselectall
		        objects.selectobject(s)
		        if s.IDGroupe <> -1 then
		          s.selectgroup
		        end if
		      end if
		      creercopies
		      return true
		    end if
		  end select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  Dim Myself as XmlElement
		  dim Temp as XMLElement
		  
		  Myself= Doc.CreateElement(GetName)
		  Temp= tsf.supp.XMLPutIdINContainer(Doc)
		  Temp.SetAttribute("NumTSF", str(tsf.GetNum))
		  Myself.AppendChild Temp
		  Myself.appendchild tempshape.XMLPutIdINContainer(Doc)
		  Myself.appendchild copies.XMLPutInContainer(Doc)
		  return Myself
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim i,j,n, num as integer
		  dim s as shape
		  dim EL, EL1, EL2 as XMLElement
		  
		  dim tsf as Transformation
		  
		  
		  EL = XMLElement(Temp.child(0))
		  
		  s = SelectForm(EL)
		  
		  EL1 = XMLElement(EL.Child(0))
		  num = val(EL1.GetAttribute("NumTSF"))
		  tsf = s.tsfi.element(num)
		  
		  EL1 = XMLElement(EL.Child(2))
		  for i = 0 to EL1.childcount-1
		    EL2 = XMLElement(EL1.child(i))
		    n =  val(EL2.GetAttribute("Id"))
		    s = objects.getshape(n)
		    tsf.removeconstructioninfos(s)
		    CurrentContent.removeshape s
		  next
		  
		  RedeleteCreatedFigures(Temp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i, j as integer
		  
		  
		  setconstructioninfos
		  
		  if  Config.Trace  and (( tsf.type <> 7) and ( tsf.type <> 71) and ( tsf.type <> 72) or (HomothetyMatrix(tsf.M).rapport > 0))  then
		    draptraj = true
		    for i = 0 to copies.count-1
		      for j = 0 to ubound(copies.element(i).points)
		        copies.element(i).points(j).tracept = tempshape.element(i).points(j).tracept
		      next
		    next
		    if tsf.type = 6 then
		      for i = 0 to copies.count-1
		        copies.element(i).ori =  -copies.element(i).ori
		      next
		      dret = new RetTimer(copies,self)
		    else
		      dret=new TsfTimer(copies,self)
		    end if
		  else
		    DoOper
		    endoperation
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s as shape
		  dim i,j, n as integer
		  
		  s  = super.GetShape(p)
		  
		  select case CurrentItemToSet
		  case 1
		    return GetTsf(p)
		  case 2
		    for i = 0 to tsf.constructedshapes.count-1
		      if tsf.constructedshapes.element(i).constructedby.shape = s  then
		        return nil
		      end if
		    next
		    s = visible.element(iobj)
		    CurrentHighlightedShape = s
		    return s
		  end select
		  
		  
		  return nil
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseWheel()
		  select case CurrentItemtoSet
		  case 1
		    MouseWheelTsf
		    CurrentContent.TheTransfos.HideAll
		    if ListTsf.count >0 then
		      ListTsf.element(itsf).Hidden = false
		    end if
		    Wnd.mycanvas1.refreshbackground
		  case 2
		    super.MouseWheel
		  end select
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  
		  
		  if SetItem(CurrentHighlightedShape) then
		    NextItem
		    if FinishedSelecting then
		      Finished = false
		      wnd.Mycanvas1.Mousecursor = System.Cursors.Wait
		      DoOperation
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setconstructioninfos()
		  dim i as integer
		  
		  for i = 0 to tempshape.count-1
		    tsf.setconstructioninfos(tempshape.element(i),copies.element(i))
		  next
		  
		  'Exception err
		  'dim d As Debug
		  'd = new Debug
		  'd.setMethod("AppliquerTsf","setconstructioninfos")
		  'd.setVariable("i",i)
		  'd.setVariable("tempshape",tempshape)
		  'd.setvariable("copies",copies)
		  'err.message = err.message+d.getString
		  '
		  'Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOper()
		  dim i As  integer
		  dim s1, s2 as shape
		  
		  for i = 0 to tempshape.count -1
		    s1 = tempshape.element(i)
		    s2 = copies.element(i)
		    tsf.appliquer(s1,s2)
		    if tsf.type = 6 and  Config.stdbiface  then
		      s2.fixecouleurfond(s2.fillcolor.comp, s2.fill)
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AppliquerTsf(EL as XmlElement)
		  dim EL1 as XmlElement
		  dim s as shape
		  dim i as integer
		  
		  AppliquerTsF
		  
		  EL1 = XMLElement(EL.FirstChild)
		  s = Objects.getshape(val(EL1.GetAttribute("Id")))
		  i = val(EL1.GetAttribute("NumTSF"))
		  ListTsf.AddTsf  s.tsfi.element(i)
		  itsf = 0
		  SelectIdForms(EL)
		  Config.Trace = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim i,j,n, num as integer
		  dim s as shape
		  dim EL, EL1, EL2 as XMLElement
		  
		  
		  EL = XMLElement(Temp.child(0))
		  
		  s = SelectForm(EL)
		  
		  EL1 = XMLElement(EL.Child(0))
		  num = val(EL1.GetAttribute("NumTSF"))
		  tsf = s.tsfi.element(num)
		  
		  SelectIdForms(EL)
		  CreerCopies
		  EL1 = XMLElement(EL.Child(2))
		  reputids(EL1)
		  ReCreateCreatedFigures(Temp)
		  DoOperation
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreerCopies()
		  dim p as BasicPoint
		  dim s1, s2 as Shape
		  dim i,j as integer
		  
		  
		  for i = 0 to tempshape.count-1
		    s1 = tempshape.element(i)
		    if s1 isa point then
		      s2 = s1.paste(Objects,Point(s1).bpt)
		    else
		      p=new BasicPoint(0,0)
		      s2 = s1.paste(Objects,p)
		      s2.auto = 0                           ' = s1.auto
		    end if
		    copies.addshape s2
		    IdentifyPointsinCopies(s2,i)
		    s2.nonpointed = s1.nonpointed
		    s2.endconstruction
		  next
		  
		  LierGroupes
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(p as BasicPoint)
		  
		  select case currentitemtoset
		  case 1
		    MouseMoveTsf(p)
		  case 2
		    super.MouseMove(p)
		  end select
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetTsf(p as BasicPoint) As shape
		  CurrentContent.TheTransfos.ShowAll
		  if ntsf > 0 then
		    CurrentContent.TheTransfos.HideAll
		    ListTsf.element(itsf).Hidden = false
		    ListTsf.element(itsf).Highlight
		    currenthighlightedtsf = listtsf.element(itsf)
		  else
		    Currentcontent.Thetransfos.showall
		  end if
		  
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument, EL as XMLElement) As XMLElement
		  dim s1, s2 as shape
		  
		  s1 = tempshape.element(0)
		  s2 = copies.element(0)
		  
		  EL.AppendChild s2.XMLPutIdINContainer(Doc)
		  EL.appendchild  s2.XMLPutConstructionInfoInContainer(Doc)
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
		draptraj As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Tsf As Transformation
	#tag EndProperty

	#tag Property, Flags = &h0
		MId As Matrix
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
			Name="CurrentItemToSet"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="MultipleSelectOperation"
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
			Name="draptraj"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
