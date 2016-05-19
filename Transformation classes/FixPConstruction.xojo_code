#tag Class
Protected Class FixPConstruction
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  Super.Constructor()
		  OpId = 37
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(MExe as MacroExe, EL as XMLElement)
		  dim n, rid, num as integer
		  dim Supp as shape
		  
		  Constructor()
		  n = val(EL.GetAttribute("SuppTsf"))
		  rid = MExe.GetRealId(n)
		  supp = objects.GetShape(rid)
		  num = val(EL.GetAttribute("Nr"))
		  tsf = supp.tsfi.item(num)
		  tsf.computematrix
		  DoOperation
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim Fix as Point
		  dim pt as BasicPoint
		  
		  CurrentContent.TheFigs.Removefigure tsf.supp.fig
		  pt = tsf.ComputeFixPt
		  if pt <> nil then
		    Fix = new Point(objects, pt)
		    Fix.setconstructedby(tsf.supp,7)
		    Fix.constructedby.data.append tsf
		    tsf.FixPt = Fix
		    Fix.endconstruction
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.value("FixPConstruction")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s as shape
		  dim i,j, n as integer
		  dim type as string
		  
		  if Ubound(CurTsf) > -1 then
		    CurTsf(itsf).Highlighted = false
		  end if
		  
		  s  = super.GetShape(p)
		  
		  
		  CurrentContent.TheTransfos.ShowAll
		  redim CurTsf(-1)
		  
		  for j = 0 to Visible.count-1
		    s=Visible.item(j)
		    if s.tsfi.count > 0 then
		      for i = 0 to s.tsfi.count-1
		        if s.tsfi.item(i).Type > 6 and  s.tsfi.item(i).Type <> 9  and  s.tsfi.item(i).Type <> 11 then
		          CurTsf.Append (s.tsfi.item(i))
		        end if
		      next
		    end if
		  next
		  itsf = 0
		  ntsf = Ubound(CurTsf)+1
		  if ntsf > 0 then
		    CurrentContent.TheTransfos.HideAll
		    CurTsf(itsf).Hidden = false
		    CurTsf(itsf).Highlighted = true
		  end if
		  
		  return nil
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as basicPoint)
		  if ubound(curtsf) > -1 then
		    tsf = curtsf(itsf)
		    DoOperation
		    endoperation
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseWheel()
		  if Ubound(CurTsf) > -1 then
		    CurTsf(itsf).Highlighted = false
		    itsf = (itsf+1) mod ntsf
		    CurrentContent.TheTransfos.HideAll
		    CurTsf(itsf).Hidden = false
		    CurTsf(itsf).Highlighted = true
		    'can.invalidate
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim ty as string
		  
		  SelectOperation.Paint(g)
		  
		  if CurrentHighlightedShape=nil then
		    Help g, choose+atransformation
		  else
		    ty = curtsf(itsf).gettype
		    if ty = dico.Value("Homothety") then
		      Help g, thishomothety
		    elseif ty = Dico.value("Similitude") then
		      Help g, thissimilarity
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim s as shape
		  dim i, n, k as integer
		  dim EL, EL1, EL2  as XMLElement
		  dim Fix as point
		  
		  'EL1 = XMLElement(Temp.Child(0))
		  ''EL =  XMLElement(EL1.Child(0))
		  ''n = val(EL.GetAttribute("Id"))
		  ''s = Objects.Getshape(n)
		  's = SelectForm(EL1)
		  'EL = XMLElement(EL1.Child(1))
		  'n = Val(EL.GetAttribute("Num"))
		  'tsf = s.tsfi(n)
		  '
		  'EL = XMLElement(EL1.Child(2))
		  'Fix = new Point(objects, EL)
		  'Fix.moveto tsf.ComputeFixPt
		  '
		  'Fix.setconstructedby(tsf.supp,7)
		  'Fix.constructedby.data.append tsf
		  'tsf.FixPt = Fix
		  
		  
		  ReDeleteDeletedFigures (Temp)
		  ReCreateCreatedFigures(Temp)
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc As XMLDocument, EL as XMLElement) As XMLElement
		  
		  
		  EL.AppendChild tsf.FixPt.XMLPutIdINContainer(Doc)
		  EL.appendchild  tsf.FixPt.XMLPutConstructionInfoInContainer(Doc)
		  
		  return EL
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc As XMLDocument) As XMLElement
		  dim EL, Temp as XMLElement
		  dim Num as integer
		  
		  Temp = Doc.CreateElement(GetName)
		  Temp.appendchild tsf.supp.XMLPutIdInContainer(Doc)
		  EL = Doc.CreateElement(Dico.Value("Transformation"))
		  
		  EL.setattribute("TsfType", str(tsf.type))
		  EL.SetAttribute("Ori",str(tsf.ori))
		  if tsf.supp isa polygon or tsf.supp isa Bande or tsf.supp isa bande then
		    EL.SetAttribute("Index", str(tsf.index))
		  end if
		  Num = tsf.supp.GetIndexTsf(tsf)
		  EL.SetAttribute("Num",str(Num))
		  Temp.appendchild EL
		  
		  EL = Doc.CreateElement(Dico.Value("PtFix"))
		  EL.AppendChild tsf.FixPt.XMLPutINContainer(Doc)
		  Temp.appendchild EL
		  
		  return temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  
		  dim s as shape
		  dim i, j, n as integer
		  dim EL, EL1 as XMLElement
		  dim p as point
		  
		  EL1 = XMLElement(Temp.Child(0))
		  s = SelectForm(EL1)
		  EL = XMLElement(EL1.Child(1))
		  tsf = s.tsfi.item(Val(EL.GetAttribute("Num")))
		  p = tsf.fixpt
		  p.delete
		  
		  ReDeleteCreatedFigures (Temp)
		  ReCreateDeletedFigures(Temp)
		  
		  
		  
		  
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
		createdpoint As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		CurTsf() As Transformation
	#tag EndProperty

	#tag Property, Flags = &h0
		tsf As Transformation
	#tag EndProperty


	#tag ViewBehavior
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
			Name="SidetoPaint"
			Group="Behavior"
			InitialValue="0"
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
	#tag EndViewBehavior
End Class
#tag EndClass
