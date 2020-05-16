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
		  If sctxt.conditionedby <> Nil Then   //On déconditionne
		    oldcondby = sctxt.conditionedby
		    sctxt.conditionedby.conditioned.removeobject sctxt
		    sctxt.conditionedby = nil
		    endoperation
		    currentcontent.currentoperation = nil
		    WorkWindow.refreshtitle
		  elseif (currenthighlightedshape <> nil) and (currenthighlightedshape isa point) and (point(currenthighlightedshape).pointsur.count = 2) then
		    if point(currenthighlightedshape).conditioned.getposition(sctxt) =-1 then
		      point(currenthighlightedshape).conditioned.objects.append sctxt
		    end if                                               //addshape n'ajoute pas à une liste d'objets un point dont un parent est déjà membre de la liste
		    sctxt.conditionedby = point(CurrentHighlightedShape)
		    endoperation
		  end if
		  
		  currentcontent.currentoperation = nil
		  WorkWindow.refreshtitle
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
		  Dim EL, EL1 As XMLElement
		  dim List as XMLNodeList
		  dim condby as point
		  dim n as integer
		  
		  Temp = XMLElement(Temp.Child(0))
		  List = Temp.XQL(Dico.value("Form"))
		  if list.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		    n = val(EL1.GetAttribute("Id"))
		    sctxt  = currentcontent.TheObjects.Getshape(n)
		    condby = point(currentcontent.TheObjects.Getshape(Val(Temp.GetAttribute("Point"))))
		    If Val(Temp.GetAttribute("Condi"))=0 Then
		      sctxt.conditionedby = nil
		      condby.conditioned.removeobject sctxt
		    else
		      sctxt.conditionedby = condby
		      condby.conditioned.addshape sctxt
		      If Not currentcontent.currentoperation IsA readhisto Then
		        MsgBox "Le conditionnement a été rétabli"
		      End If
		    end if
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc As XMLDocument) As XMLElement
		  Dim Temp As  XMLElement
		  
		  Temp = Doc.CreateElement(GetName)
		  Temp.appendchild sctxt.XMLPutIdInContainer(Doc)
		  'On n'utilise pas Temp.appendchild tempshape.XMLPutIdInContainer(Doc) car sctxt a été highlighted mais non sélectionné
		  'En conséquence, dans le fichier XML il n'y a pas de niveau "Forms", on passe directement à "Form" et il n'y en a qu'une. Pas de sélection multiple dans le cas du menu contextuel!
		  
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
		  Dim EL, EL1 As XMLElement
		  dim List as XMLNodeList
		  dim condby as point
		  dim n as integer
		  
		  Temp = XMLElement(Temp.Child(0))
		  List = Temp.XQL(Dico.value("Form"))
		  if list.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		    n = val(EL1.GetAttribute("Id"))
		    sctxt  = currentcontent.TheObjects.Getshape(n)
		    condby = point(currentcontent.TheObjects.Getshape(Val(Temp.GetAttribute("Point"))))
		    If Val(Temp.GetAttribute("Condi"))=1 Then
		      sctxt.conditionedby = nil
		      condby.conditioned.removeobject sctxt
		      MsgBox "Le conditionnement a été annulé"
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
