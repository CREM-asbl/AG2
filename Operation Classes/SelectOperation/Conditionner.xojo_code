#tag Class
Protected Class Conditionner
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor(sh as shape)
		  
		  super.constructor
		  OpId = 40
		  
		  sctxt = sh
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  if sctxt.conditionedby <> nil then   //On déconditionne
		    oldcondby = sctxt.conditionedby
		    sctxt.conditionedby.conditioned.removeobject sctxt
		    sctxt.conditionedby = nil
		    endoperation
		    currentcontent.currentoperation = nil
		    wnd.refreshtitle
		  elseif (currenthighlightedshape <> nil) and (currenthighlightedshape isa point) and (point(currenthighlightedshape).pointsur.count = 2) then
		    if point(currenthighlightedshape).conditioned.getposition(sctxt) =-1 then
		      point(currenthighlightedshape).conditioned.objects.append sctxt
		    end if                                               //addshape n'ajoute pas à une liste d'objets un point dont un parent est déjà membre de la liste
		    sctxt.conditionedby = point(CurrentHighlightedShape)
		    endoperation
		  end if
		  
		  currentcontent.currentoperation = nil
		  wnd.refreshtitle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return   Dico.value("Conditionner")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as basicPoint) As shape
		  dim s as shape
		  dim i as integer
		  
		  
		  s = super.getshape(p)
		  
		  for i = visible.count downto 0
		    if (not visible.item(i) isa point) or point(visible.item(i)).pointsur.count <> 2 then
		      visible.removeobject visible.item(i)
		    end if
		  next
		  
		  nobj = visible.count
		  
		  if visible.count > 0 then
		    return visible.item(iobj)
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(p as basicPoint)
		  if sctxt <> nil and  sctxt.conditionedby <> Nil then
		    dooperation
		  else
		    super.mousemove(p)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  super.paint(g)
		  
		  if currenthighlightedshape <> nil and currenthighlightedshape isa point and (point(currenthighlightedshape).pointsur.count = 2) then
		    display = thispoint + " ?"
		  else
		    display = choose + apoint + inter
		  end if
		  
		  Help g, display
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim EL, EL1 as XMLElement
		  dim List as XMLNodeList
		  dim condby as point
		  dim n as integer
		  
		  EL = XMLElement(Temp.FirstChild)
		  List = EL.XQL(Dico.value("Form"))
		  if list.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		    n = val(EL1.GetAttribute("Id"))
		    sctxt  = currentcontent.TheObjects.Getshape(n)
		    condby = point(currentcontent.TheObjects.Getshape(val(EL.GetAttribute("Point"))))
		    if val(EL.GetAttribute("Condi"))=0 then
		      sctxt.conditionedby = nil
		      condby.conditioned.removeobject sctxt
		    else
		      sctxt.conditionedby = condby
		      condby.conditioned.addshape sctxt
		    end if
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc As XMLDocument) As XMLElement
		  dim Temp As  XMLElement
		  
		  Temp = Doc.CreateElement(GetName)
		  Temp.appendchild sctxt.XMLPutIdInContainer(Doc)
		  if oldcondby <> nil then
		    Temp.SetAttribute("Condi",str(0))
		  else
		    Temp.SetAttribute("Condi",str(1))
		  end if
		  if sctxt.conditionedby <> nil then
		    Temp.SetAttribute("Point",str(sctxt.conditionedby.id))
		  else
		    Temp.SetAttribute("Point",str(oldcondby.id))
		  end if
		  return Temp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim EL, EL1 as XMLElement
		  dim List as XMLNodeList
		  dim condby as point
		  dim n as integer
		  
		  EL = XMLElement(Temp.FirstChild)
		  List = EL.XQL(Dico.value("Form"))
		  if list.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		    n = val(EL1.GetAttribute("Id"))
		    sctxt  = currentcontent.TheObjects.Getshape(n)
		    condby = point(currentcontent.TheObjects.Getshape(val(EL.GetAttribute("Point"))))
		    if val(EL.GetAttribute("Condi"))=1 then
		      sctxt.conditionedby = nil
		      condby.conditioned.removeobject sctxt
		    else
		      sctxt.conditionedby = condby
		      condby.conditioned.addshape sctxt
		    end if
		  end if
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		oldcondby As point
	#tag EndProperty

	#tag Property, Flags = &h0
		sctxt As shape
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="canceling"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsep"
			Group="Behavior"
			Type="Boolean"
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
			Name="side"
			Group="Behavior"
			Type="Integer"
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
