#tag Class
Protected Class CreateGrid
Inherits Operation
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit)) or  (TargetAndroid and (Target64Bit))
	#tag Method, Flags = &h0
		Sub Constructor()
		  dim k as integer
		  
		  super.constructor()
		  OpId = 29
		  
		  'todo : A placer dans gridWindow
		  oldtype = GridWindow.popupmenu1.listindex
		  
		  if CurrentContent.thegrid <> nil then
		    oldtaillepoints = CurrentContent.thegrid.gs
		    oldrapport = CurrentContent.thegrid.rapport
		  end if
		  GridWindow.ShowModal
		  
		  if GridWindow.result = 1 then
		    type = GridWindow.PopupMenu1.listindex
		    taillepoints = GridWindow.Popupmenu2.listindex + 2
		    k = GridWindow.Popupmenu3.listindex
		    GridWindow.close
		    select case k
		    case 0
		      rapport = 1
		    case 1
		      rapport = 0.5
		    case 2
		      rapport = 1/3
		    case 3
		      rapport = 2
		    case 4
		      rapport = 3
		    end select
		    DoOperation
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(t as Boolean)
		  super.constructor
		  OpId = 29
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOper(t as integer, taille as integer, r as double)
		  dim c as Basicpoint
		  dim Mat as Matrix
		  
		  select case t
		  case 0
		    CurrentContent.TheGrid= nil
		  case 1
		    CurrentContent.TheGrid = new SquareGrid(taille, r)
		  case 2
		    CurrentContent.TheGrid = new HexGrid(taille, r)
		  end select
		  
		  type = t
		  taillepoints = taille
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  DoOper(type,taillepoints,rapport)
		  if config.menu = "Menu_A" then
		    if type <> 0 then
		      config.MvBt(0) = true
		    else
		      config.MvBt(0) = false
		    end if
		  end if
		  endoperation
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  if type + oldtype > 0 then
		    super.endoperation
		    finished = true
		    CurrentContent.currentoperation = nil
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  Return Dico.value("ToolsGrid")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim EL, EL1 as XMLElement
		  
		  EL = XMLElement(Temp.Child(0))
		  type  = val(EL.Getattribute("Type"))
		  if type  <> 0 then
		    taillepoints = val(EL.Getattribute("PointSize"))
		    rapport = val(EL.GetAttribute("Ratio"))
		    dooper(type, taillepoints, rapport)
		  else
		    CurrentContent.thegrid = nil
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  dim EL as XMLElement
		  dim Temp as XMLElement
		  
		  if type > 0 then
		    EL = CurrentContent.thegrid.XMLPutInContainer(Doc)
		    EL.Setattribute("Ratio", str(rapport))
		  else
		    EL =  Doc.CreateElement(Dico.Value("ToolsGrid"))
		    EL.Setattribute("Type", str(0))
		  end if
		  
		  Temp =  Doc.CreateElement("OldGrid")
		  Temp.SetAttribute("Type",str(oldtype))
		  Temp.SetAttribute("PointSize", str(oldtaillepoints))
		  Temp.SetAttribute("Ratio", str(oldrapport))
		  EL.AppendChild(Temp)
		  
		  return EL
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim EL, EL1 as XMLElement
		  
		  EL = XMLElement(Temp.Child(0))
		  EL1 = XMLElement(EL.Child(0))
		  
		  
		  type  = val(EL1.Getattribute("Type"))
		  if type  <> 0 then
		    taillepoints = val(EL1.Getattribute("PointSize"))
		    rapport = val(EL.GetAttribute("Ratio"))
		    if rapport = 0 then
		      rapport = 1
		    end if
		    rapport = 1/rapport
		    dooper(type, taillepoints, rapport)
		  else
		    CurrentContent.thegrid = nil
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
		oldrapport As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		oldtaillepoints As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		oldtype As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		rapport As double
	#tag EndProperty

	#tag Property, Flags = &h0
		TaillePoints As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		type As Integer
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
			Name="oldrapport"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="oldtaillepoints"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="oldtype"
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
			Name="rapport"
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
			Name="TaillePoints"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
		#tag ViewProperty
			Name="type"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
