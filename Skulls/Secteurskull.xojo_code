#tag Class
Protected Class Secteurskull
Inherits Skull
	#tag Method, Flags = &h0
		Sub Constructor(p As Basicpoint)
		  dim cs as curveshape
		  dim i as integer
		  dim GCC as Group2D
		  dim ars as arcshape
		  
		  CC = new Group2D
		  GCC = Group2D(CC)
		  ref = p
		  CC.x = 0
		  CC.y = 0
		  CC.borderwidth = 1
		  CC.border = 0
		  
		  for i = 0 to 1
		    cs =new curveshape
		    cs.X = 0
		    cs.Y = 0
		    cs.X2 = 0
		    cs.Y2 = 0
		    cs.border = 0
		    cs.fill = 0
		    GCC.append cs
		  next
		  
		  ars =new arcshape
		  
		  diag = wnd.mycanvas1.width^2
		  diag = diag + wnd.mycanvas1.height^2
		  diag = sqrt(diag)
		  
		  ars.width = 2*diag
		  ars.height = 2*diag
		  Ars.Startangle = 0
		  Ars.Arcangle = 0
		  ars.border = 0
		  ars.fill=0
		  
		  GCC.append ars
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCote(n as integer) As curveshape
		  dim GCC as Group2D
		  
		  GCC = Group2D(CC)
		  
		  select case n
		  case 0
		    return curveshape(GCC.item(0))
		  case 1
		    return curveshape(GCC.item(1))
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Paint(g as graphics)
		  dim i as integer
		  
		  
		  for i =  2 downto 0
		    g.drawobject Group2D(CC).item(i), ref.x, ref.y
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updateangles(ang as double, start as double)
		  dim GCC as Group2D
		  
		  GCC = Group2D(CC)
		  
		  
		  ArcShape(GCC.item(2)).Startangle = start
		  ArcShape(GCC.item(2)).Arcangle = ang
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updatebordercolor(col as color, f as integer)
		  dim GCC as Group2D
		  dim i as integer
		  
		  GCC= Group2D(CC)
		  
		  for i = 0 to 1
		    curveshape(GCC.item(i)).bordercolor = col
		    curveshape(GCC.item(i)).border = f
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateBorderwidth(n as integer)
		  dim GCC as Group2D
		  dim i as integer
		  
		  GCC= Group2D(CC)
		  
		  for i = 0 to 1
		    curveshape(GCC.item(i)).borderwidth= n
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateFillColor(c as color, f as integer)
		  
		  dim GCC as Group2D
		  
		  
		  GCC= Group2D(CC)
		  
		  
		  arcshape(GCC.item(2)).fillcolor = c
		  arcshape(GCC.item(2)).fill = f
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesommet(n as integer, bp as basicPoint)
		  dim GCC as Group2D
		  
		  GCC= Group2D(CC)
		  
		  select case n
		  case 0
		    curveshape(GCC.item(0)).X2 = bp.x
		    curveshape(GCC.item(0)).Y2 = bp.y
		    curveshape(GCC.item(0)).border = 100
		  case 1
		    curveshape(GCC.item(1)).X2 = bp.x
		    curveshape(GCC.item(1)).Y2 = bp.y
		    curveshape(GCC.item(1)).border = 100
		  end select
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		diag As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderColor"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderWidth"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="diag"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FillColor"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
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
			Name="Rotation"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Scale"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
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
			Name="X"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Y"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
