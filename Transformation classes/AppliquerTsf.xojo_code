#tag Class
Protected Class AppliquerTsf
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  Super.constructor
		  
		  OpId = 24
		  NumberOfItemsToSelect=2
		  copies = new objectslist
		  objects.unhighlightall
		  MId = new Matrix(1)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Mexe as MacroExe, EL1 as XMLElement)
		  dim s1, s2, supp as shape
		  dim tsf as transformation
		  dim n, rid, num  as integer
		  
		  
		  Constructor()
		  
		  n = val(EL1.GetAttribute("SuppTsf"))
		  rid = MExe.GetRealId(n)
		  supp = objects.Getshape(rid)
		  num = val(EL1.GetAttribute("Nr"))
		  tsf = supp.tsfi.item(num)
		  
		  n = val(EL1.GetAttribute("Id"))
		  rid = MExe.GetRealId(n)
		  s1 = objects.Getshape(rid)
		  objects.unselectall
		  objects.selectobject(s1)
		  CreerCopies
		  tsf.appliquer(s1,copies.item(0))
		  tsf.setconstructioninfos1(s1,copies.item(0))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(EL as XMLElement)
		  dim EL1 as XMLElement
		  dim s as shape
		  dim i as integer
		  
		  Constructor()
		  
		  EL1 = XMLElement(EL.FirstChild)
		  s = Objects.getshape(val(EL1.GetAttribute("Id")))
		  i = val(EL1.GetAttribute("NumTSF"))
		  ListTsf.AddObject  s.tsfi.item(i)
		  itsf = 0
		  SelectIdForms(EL)
		  Config.Trace = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreerCopies()
		  dim p as BasicPoint
		  dim s1, s2 as Shape
		  dim i,j as integer
		  
		  
		  for i = 0 to tempshape.count-1
		    s1 = tempshape.item(i)
		    if s1 isa point then
		      s2 = s1.paste(Objects,Point(s1).bpt)
		    else 
		      p=new BasicPoint(0,0)
		      s2 = s1.paste(Objects,p)
		    end if
		    copies.addshape s2
		    IdentifyPointsinCopies(s2,i)
		    s2.copierparams(s1)
		    s2.endconstruction
		  next
		  
		  LierGroupes
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOper()
		  dim i As  integer
		  dim s1, s2 as shape
		  
		  for i = 0 to tempshape.count -1
		    s1 = tempshape.item(i)
		    s2 = copies.item(i)
		    tsf.appliquer(s1,s2)
		    if tsf.type = 6 and  Config.biface  then
		      s2.fixecouleurfond(s2.fillcolor.comp, s2.fill)
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i, j as integer
		  
		  
		  setconstructioninfos
		  
		  if  Config.Trace  and TrajValide then
		    draptraj = true
		    for i = 0 to copies.count-1
		      for j = 0 to ubound(copies.item(i).points)
		        copies.item(i).points(j).tracept = tempshape.item(i).points(j).tracept
		      next
		    next
		    if tsf.type = 6 then
		      'for i = 0 to copies.count-1
		      'copies.item(i).ori =  -copies.item(i).ori
		      'next
		      dret = New RetTimer(copies,Self)
		    else
		      dret =new TsfTimer(copies,self)
		    end if
		  else
		    DoOper
		    endoperation
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Endoperation()
		  dim i,j as integer
		  
		  super.endoperation
		  CurrentItemToSet=2
		  for i = 0 to copies.count-1
		    for j = 0 to ubound(copies.item(i).points)
		      copies.item(i).points(j).tracept =  false
		    next
		  next
		  copies.removeall
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("Appliquer")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s as shape
		  dim i,j, n as integer
		  
		  CurrentHighlightedShape = nil
		  s  = super.GetShape(p)
		  if s = nil then
		    return nil
		  end if
		  select case CurrentItemToSet
		  case 1
		    return GetTsf(p)
		  case 2
		    for i =  visible.count-1 downto 0
		      s = visible.item(i)
		      'if s <> nil and  s.isaellipse then
		      'visible.removeobject s
		      'end if
		      if self isa TrajectoireTsf and not s isa point then
		        visible.removeobject s
		      end if
		      for j = 0 to tsf.constructedshapes.count-1
		        if tsf.constructedshapes.item(j).constructedby.shape = s  then
		          visible.removeobject s
		        end if
		      next
		    next
		    s = visible.item(iobj)
		    CurrentHighlightedShape = s
		    return s
		  end select
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetTsf(p as BasicPoint) As shape
		  CurrentContent.TheTransfos.ShowAll
		  if ntsf > 0 then
		    CurrentContent.TheTransfos.HideAll
		    ListTsf.item(itsf).Hidden = false
		    ListTsf.item(itsf).Highlight
		    currenthighlightedtsf = listtsf.item(itsf)
		  else
		    Currentcontent.Thetransfos.showall
		  end if
		  
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  
		  
		  if SetItem(CurrentHighlightedShape) then
		    NextItem
		    if FinishedSelecting then
		      Finished = false
		      can.Mousecursor = System.Cursors.Wait
		      DoOperation
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(p as BasicPoint)
		  Select Case currentitemtoset
		  case 1
		    colsep = true
		    MouseMoveTsf(p)
		    if currenthighlightedshape <> nil then
		      can.refreshbackground
		    end if
		  case 2
		    colsep = false
		    super.MouseMove(p)
		  end select
		  'can.refreshbackground
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseWheel()
		  select case CurrentItemtoSet
		  case 1
		    MouseWheelTsf
		    CurrentContent.TheTransfos.HideAll
		    if ListTsf.count >0 then
		      ListTsf.item(itsf).Hidden = false
		    end if
		    'can.refreshbackground
		  case 2
		    super.MouseWheel
		  end select
		  
		  
		End Sub
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
		    elseif self isa TrajectoireTsf then
		      str = choose+apoint
		    else
		      str = choose+aform
		    end if
		    Help g, str
		  else
		    can.mousecursor = system.cursors.wait
		    Help g, wait
		  end select
		  
		  
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
		  tsf = s.tsfi.item(num)
		  
		  SelectIdForms(EL)
		  CreerCopies
		  EL1 = XMLElement(EL.Child(2))
		  reputids(EL1)
		  ReCreateCreatedFigures(Temp)
		  DoOperation
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setconstructioninfos()
		  dim i as integer
		  
		  for i = 0 to tempshape.count-1
		    tsf.setconstructioninfos(tempshape.item(i),copies.item(i))
		  next
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMethod("AppliquerTsf","setconstructioninfos")
		    d.setVariable("i",i)
		    d.setVariable("tempshape",tempshape)
		    d.setvariable("copies",copies)
		    err.message = err.message+d.getString
		    
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(s as shape) As Boolean
		  
		  select case CurrentItemtoSet
		  case 1
		    ntsf = ListTsf.count
		    if ntsf > 0 then 'and not ListTsf.item(itsf).M.equal(MId)  then
		      tsf = ListTsf.item(itsf)
		      CurrentContent.TheTransfos.HideAll
		      tsf.Hidden = false
		      tsf.highlight
		      tsf.supp.highlight
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
		Function ToMac(Doc as XMLDocument, EL as XMLElement) As XMLElement
		  dim s2 as shape
		  dim Temp as XMLElement
		  
		  s2 = copies.item(0)
		  
		  
		  Temp = s2.XMLPutIdINContainer(Doc)
		  Temp.AppendChild s2.XMLPutChildsInContainer(Doc)
		  EL.AppendChild Temp
		  EL.appendchild  s2.XMLPutConstructionInfoInContainer(Doc)
		  return EL
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  Dim Myself as XMLElement
		  dim Temp as XMLElement
		  
		  Myself= Doc.CreateElement(GetName)
		  Temp= tsf.supp.XMLPutIdINContainer(Doc)
		  Temp.SetAttribute("NumTSF", str(tsf.GetNum))    'pour le cas où une forme supporte plusieurs tsf
		  Myself.AppendChild Temp
		  Myself.appendchild tempshape.XMLPutIdINContainer(Doc)
		  Myself.appendchild copies.XMLPutInContainer(Doc)
		  return Myself
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TrajValide() As Boolean
		  dim s as shape
		  dim BiB1, BiB2 as BiBPoint
		  dim u1, u2, u3, u4, q as BasicPoint
		  dim r1, r2 as double
		  
		  select case tsf.type
		  case 7, 71, 72
		    if tsf.M.rapport <= 0 then
		      return false
		    end if
		  case 9  'Etirement de rapport négatif
		    s = tsf.supp
		    Bib1 = tsf.supp.getBibside(0)
		    Bib2 = tsf.supp.getBiBSide(2)
		    q = Bib2.BibInterdroites(bib1,2,2,r1,r2)
		    if q <> nil  then
		      return false
		    end if
		  end select
		  return true
		  
		  
		  
		  
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
		  tsf = s.tsfi.item(num)
		  
		  EL1 = XMLElement(EL.Child(1))
		  for i = 0 to EL1.childcount-1
		    EL2 = XMLElement(EL1.child(i))
		    n =  val(EL2.GetAttribute("Id"))
		    s = objects.getshape(n)
		    tsf.removeconstructioninfos(s)
		    CurrentContent.removeobject s
		  next
		  
		  RedeleteCreatedFigures(Temp)
		  
		  Exception err
		    var d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("Temp", Temp)
		    d.setVariable("EL", EL)
		    d.setVariable("EL1", EL1)
		    d.setVariable("i", i)
		    d.setVariable("tsf", tsf)
		    err.message = err.message+d.getString
		    
		    Raise err
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
		draptraj As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		MId As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		Tsf As Transformation
	#tag EndProperty


	#tag ViewBehavior
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
			Name="CurrentItemToSet"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="draptraj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
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
