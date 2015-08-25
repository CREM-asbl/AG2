#tag Class
Protected Class Grid
	#tag Method, Flags = &h0
		Function GridMagnetism(Byref p as BasicPoint) As integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computelimits()
		  x0 = min(min(can.cig.x,can.cid.x),min(can.csg.x,can.csd.x))
		  x1 =max(max(can.cig.x,can.cid.x),max(can.csg.x,can.csd.x))
		  y0 = min(min(can.cig.y,can.cid.y),min(can.csg.y,can.csd.y))
		  y1 =max(max(can.cig.y,can.cid.y),max(can.csg.y,can.csd.y))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Print(g as graphics, sc as double)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  Dim Gr as XMLElement
		  
		  Gr =  Doc.CreateElement(Dico.Value("ToolsGrid"))
		  Gr.SetAttribute("Type", str(type))
		  Gr.SetAttribute("PointSize", str(gs))
		  return Gr
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Grid(taillepoints as integer)
		  
		  can = wnd.Mycanvas1
		  gs = taillepoints
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g As Graphics)
		  
		  g.PenHeight=1
		  g.PenWidth=1
		  g.foreColor=mag
		  print(g,1)
		  g.forecolor = noir
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos As TextOutputStream)
		  
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
		x0 As double
	#tag EndProperty

	#tag Property, Flags = &h0
		x1 As double
	#tag EndProperty

	#tag Property, Flags = &h0
		y0 As double
	#tag EndProperty

	#tag Property, Flags = &h0
		y1 As double
	#tag EndProperty

	#tag Property, Flags = &h0
		gs As double
	#tag EndProperty

	#tag Property, Flags = &h0
		type As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		can As Mycanvas
	#tag EndProperty

	#tag Property, Flags = &h0
		rapport As double
	#tag EndProperty


	#tag ViewBehavior
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
			Name="x0"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="x1"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="y0"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="y1"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="gs"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="type"
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
	#tag EndViewBehavior
End Class
#tag EndClass
