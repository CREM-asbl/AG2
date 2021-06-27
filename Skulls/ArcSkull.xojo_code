#tag Class
Protected Class ArcSkull
Inherits NSkull
	#tag Method, Flags = &h0
		Sub Constructor(p as BasicPoint)
		  dim i as integer
		  ref = can.transform(p)
		  x = ref.x
		  y = ref.y
		  for i = 0 to 2
		    append new CurveShape
		    item(i).order = 2
		  next
		  
		  '3 curveshapes sont nécessaires pour réaliser un arc allant jusqu'à 360°
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics)
		  dim i as integer
		  
		  
		  If Not (currentcontent.currentoperation IsA retourner And dret  <>Nil) And Not currentcontent.currentoperation IsA Imprimer Then
		    'si  dret <> nil et currentop est une des opérations mentionnées, le calcul des extre et ctrl est fait par le timer
		    update(skullof)
		  end if
		  if skullof isa freecircle or skullof isa stdcircle then
		    g.drawobject self, x, y
		  end if
		  for i = 0 to count-1
		    g.drawobject item(i), x, y
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub scale(s as Shape, sc as Double)
		  dim i as integer
		  dim p, q as BasicPoint
		  
		  p =s.getgravitycenter
		  ref = can.transform(p)
		  x = ref.x * sc
		  y = ref.y * sc
		  
		  q = can.dtransform(s.coord.tab(1)-p) * sc
		  item(0).x = q.x
		  item(0).y = q.y
		  q = can.dtransform(s.coord.extre(0)-p) * sc
		  item(0).x2 = q.x
		  item(0).y2 = q.y
		  item(1).x=q.x
		  item(1).y=q.y
		  q = can.dtransform(s.coord.extre(1)-p) * sc
		  item(1).x2 = q.x
		  item(1).y2 = q.y
		  item(2).x=q.x
		  item(2).y=q.y
		  if s isa arc then
		    q = can.dtransform(s.coord.tab(2)-p) * sc
		  else
		    q =can.dtransform(s.coord.tab(1)-p) * sc
		  end if
		  item(2).x2 = q.x
		  item(2).y2 = q.y
		  
		  for i = 0 to 5
		    updatectrl(i, can.dtransform(s.coord.ctrl(i)-p) * sc)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update(s as shape)
		  dim i as integer
		  dim p, q as BasicPoint
		  
		  p =s.getgravitycenter
		  ref = can.transform(p)
		  x = ref.x
		  y = ref.y
		  
		  q = can.dtransform(s.coord.tab(1)-p)
		  item(0).x = q.x
		  item(0).y = q.y
		  q = can.dtransform(s.coord.extre(0)-p)
		  item(0).x2 = q.x
		  item(0).y2 = q.y
		  item(1).x=q.x
		  item(1).y=q.y
		  q = can.dtransform(s.coord.extre(1)-p)
		  item(1).x2 = q.x
		  item(1).y2 = q.y
		  item(2).x=q.x
		  item(2).y=q.y
		  if s isa arc then
		    q = can.dtransform(s.coord.tab(2)-p)
		  else
		    q =can.dtransform(s.coord.tab(1)-p)
		  end if
		  item(2).x2 = q.x
		  item(2).y2 = q.y
		  
		  for i = 0 to 5
		    updatectrl(i, can.dtransform(s.coord.ctrl(i)-p))
		  next
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatebordercolor(col as color, c as double)
		  dim i as integer
		  for i = 0 to 2
		    item(i).bordercolor = col
		    item(i).border = c
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateborderwidth(d as double)
		  dim i as integer
		  for i = 0 to 2
		    item(i).borderwidth = d
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatectrl(i as integer, p as BasicPoint)
		  dim j as integer
		  
		  j = i\2
		  i = i mod 2
		  item(j).controlx(i) = p.x
		  item(j).controly(i) = p.y
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="BorderOpacity"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FillOpacity"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="angle"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderColor"
			Visible=false
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderWidth"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FillColor"
			Visible=false
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
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
			Name="Rotation"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Scale"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
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
		#tag ViewProperty
			Name="X"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Y"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
