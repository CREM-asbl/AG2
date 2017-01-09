#tag Class
Protected Class CreateGrid
Inherits Operation
	#tag Method, Flags = &h0
		Sub Constructor()
		  dim gw as GridWindow
		  dim k as integer
		  
		  super.constructor()
		  OpId = 29
		  
		  'todo : A placer dans gridWindow
		  gw = new GridWindow
		  oldtype = gw.popupmenu1.listindex
		  
		  if CurrentContent.thegrid <> nil then
		    oldtaillepoints = CurrentContent.thegrid.gs
		    oldrapport = CurrentContent.thegrid.rapport
		  end if
		  gw.ShowModal
		  
		  if gw.result=1 then
		    type = gw.PopupMenu1.listindex
		    taillepoints = gw.Popupmenu2.listindex + 2
		    k = gw.Popupmenu3.listindex
		    gw.close
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
		  
		  if r <> 1 then
		    c = new BasicPoint(0,0)
		    can.rep.idx = can.rep.idx*r
		    can.rep.idy = can.rep.idy*r
		    can.setrepere(can.rep)
		    Mat = new HomothetyMatrix(c, 1/r)
		    Objects.UpdateUserCoord(Mat)
		  end if
		  
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
			Name="oldrapport"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="oldtaillepoints"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="oldtype"
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
			Name="rapport"
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
			Name="TaillePoints"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="type"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
