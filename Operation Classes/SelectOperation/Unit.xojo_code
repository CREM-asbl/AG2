#tag Class
Protected Class Unit
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor(n as integer)
		  
		  Super.constructor
		  OpId = 41
		  Type = n
		  icot = -1
		  
		  
		  if Type = 2 or Type = 3 then
		    DoOperation
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim dr as droite
		  dim sh as shape
		  
		  select case type
		  case 0, 2
		    if currentcontent.SHUL <> nil then
		      oldsh =  currentcontent.SHUL.id
		      oldicot = currentcontent.IcotUL
		    else
		      oldsh = -1
		    end if
		  case 1, 3
		    if currentcontent.SHUA <> nil then
		      oldsh =  currentcontent.SHUA.id
		    else
		      oldsh = -1
		    end if
		  end select
		  
		  if currenthighlightedshape <> nil then
		    sh = currenthighlightedshape
		    
		    select case type
		    case 0
		      if sh isa droite and droite(sh).nextre = 2 then
		        dr = droite(sh)
		      elseif sh isa cube and icot <> -1 then
		        dr = cube(sh).getside(icot)
		      elseif sh isa polygon and icot <> -1  then
		        dr = polygon(sh).getside(icot)
		      end if
		      if dr.longueur > epsilon then
		        currentcontent.UL = dr.longueur
		        currentcontent.SHUL = sh
		        currentcontent.IcotUL = icot
		      end if
		    case 1
		      if ( (sh isa Lacet and icot = -1) or sh isa circle) and  abs(sh.aire) > epsilon then
		        currentcontent.UA = sh.aire
		        currentcontent.SHUA = sh
		      end if
		    end select
		    
		  else
		    select case type
		    case 2
		      currentcontent.UL = 1
		      currentcontent.SHUL = nil
		      currentcontent.IcotUL = -1
		      endoperation
		    case 3
		      currentcontent.UA = 1
		      currentcontent.SHUA = nil
		      endoperation
		    end select
		  end if
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMethod(getName,"DoOperation")
		    d.setVariable("dr",dr)
		    d.setVariable("sh",sh)
		    d.setVariable("type",type)
		    d.setVariable("icot",icot)
		    err.message = err.message+d.getString
		    
		    Raise err
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  
		  if type = 0 then
		    return Dico.Value("PrefsUL")
		  else
		    return Dico.Value("PrefsUA")
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s as shape
		  dim i as integer
		  
		  
		  s = super.getshape(p)
		  
		  if visible.count = 0 then
		    return nil
		  end if
		  
		  select case Type
		  case 0
		    for i = 0 to visible.count-1
		      s = Visible.item(i)
		      if not ( s isa droite and droite(s).nextre = 2) and not (s isa Lacet and Lacet(s).pointonside(p) <> -1) then
		        visible.removeobject s
		      end if
		    next
		    
		  case 1
		    
		    for i = 0 to visible.count-1
		      s = Visible.item(i)
		      if not (( s isa Lacet or s isa Stdcircle or s isa freecircle)  and abs(s.aire) > epsilon)  then
		        visible.removeobject s
		      end if
		    next
		  end select
		  return visible.item(iobj)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub MouseMove(p as BasicPoint)
		  
		  objects.unhighlightall
		  currenthighlightedshape = Getshape(p)
		  
		  if  currenthighlightedshape <> nil and Type = 0 then
		    icot = currenthighlightedshape.pointonside(p)
		  else
		    icot = -1
		  end if
		  can.RefreshBackground
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g As Graphics)
		  
		  operation.paint(g)
		  
		  if currenthighlightedshape isa Lacet and icot <> -1 then
		    Lacet(currenthighlightedshape).paintside(g,icot,2,Config.highlightcolor)
		  else
		    if CurrentHighlightedShape<>nil then
		      CurrentHighlightedShape.HighLight
		      CurrentHighlightedShape.PaintAll(g)
		      CurrentHighlightedShape.UnHighLight
		    end if
		  end if
		  
		  g.Bold=True
		  
		  if currenthighlightedshape = nil then
		    
		    select case Type
		    case 0
		      Help g,  choose + asegment
		    case 1
		      Help g, choose + aform
		    end select
		    
		  else
		    
		    select case Type
		    case 0
		      Help g, thissegment +  " ?"
		    case 1
		      Help g, thisform + " ?"
		    end select
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim EL, EL1 as XMLElement
		  dim dr as droite
		  dim n as integer
		  
		  EL = XMLElement(Temp.FirstChild)
		  
		  select case Type
		  case 0
		    n = val(EL.GetAttribute("SHUL"))
		    currentcontent.SHUL = currentcontent.TheObjects.Getshape(n)
		    if currentcontent.SHUL isa polygon then
		      currentcontent.IcotUL = val(EL.Getattribute("IcotUL"))
		      dr = currentcontent.SHUL.GetSide(CurrentContent.IcotUL)
		      currentcontent.UL = dr.longueur
		    else
		      currentcontent.IcotUL = -1
		      currentcontent.UL = droite(currentcontent.SHUL).longueur
		    end if
		  case 1
		    n = val(EL.GetAttribute("SHUA"))
		    currentcontent.SHUA = currentcontent.TheObjects.Getshape(n)
		    currentcontent.UA = currentcontent.SHUA.aire
		  case 2
		    currentcontent.UL = 1
		    currentcontent.SHUL = nil
		    currentcontent.IcotUL = -1
		  case 3
		    currentcontent.UA = 1
		    currentcontent.SHUA = nil
		  end select
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  Dim Myself , EL, EL1 as XMLElement
		  
		  
		  Myself= Doc.CreateElement(GetName)
		  Myself.SetAttribute("Type",str(Type))
		  select case Type
		  case 0
		    if  currentcontent.SHUL <> nil then
		      Myself.SetAttribute("SHUL", str(currentcontent.SHUL.id))
		      if currentcontent.SHUL isa polygon then
		        Myself.setattribute("IcotUL", str(currentcontent.IcotUL))
		      end if
		    end if
		  case 1
		    if currentcontent.SHUA <> nil then
		      Myself.SetAttribute("SHUA", str(currentcontent.SHUA.id))
		    end if
		  case 2, 3
		    Myself.SetAttribute("Default", str(1))
		  end select
		  
		  EL = Doc.CreateElement(Dico.value("OldValue"))
		  EL.SetAttribute("OldSH", str(oldsh))
		  if type = 0 then
		    EL.SetAttribute("OldIcot", str(oldicot))
		  end if
		  Myself.appendchild EL
		  return Myself
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim EL, EL1 as XMLElement
		  dim dr as droite
		  
		  EL = XMLElement(Temp.FirstChild)
		  EL1=XMLElement(EL.FirstChild)
		  oldsh = val(EL1.GetAttribute("OldSH"))
		  
		  if oldsh = -1 then
		    select case Type
		    case 0, 2
		      currentcontent.SHUL = nil
		      currentcontent.UL = 1
		      currentcontent.IcotUL = -1
		    case 1, 3
		      currentcontent.SHUA = nil
		      currentcontent.UA=1
		    end select
		  else
		    select case Type
		    case 0, 2
		      currentcontent.SHUL = currentcontent.TheObjects.Getshape(oldsh)
		      currentcontent.IcotUL = val(EL.GetAttribute("OldIcot"))
		      if currentcontent.SHUL isa polygon and currentcontent.IcotUL <> -1 then
		        dr = currentcontent.SHUL.GetSide(currentcontent.IcotUL)
		        currentcontent.UL = dr.longueur
		      else
		        currentcontent.UL = droite(currentcontent.SHUL).longueur
		      end if
		    case 1, 3
		      currentcontent.SHUA= currentcontent.TheObjects.Getshape(oldsh)
		      currentcontent.UA = currentcontent.SHUA.aire
		    end select
		  end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		icot As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		oldicot As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		oldsh As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Type As Integer
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
			Name="icot"
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
			Name="oldicot"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="oldsh"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
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
			Name="Std2flag"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
		#tag ViewProperty
			Name="Type"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
