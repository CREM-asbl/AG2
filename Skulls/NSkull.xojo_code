#tag Class
Protected Class NSkull
Inherits FigureShape
	#tag Method, Flags = &h0
		Sub fixecouleurs(s as shape)
		  dim loc, i, n as integer
		  dim cs(-1) as curveshape
		  
		  if s isa lacet then
		    cs = lacet(s).nsk.cs
		    if s.hidden or s.tsp  then
		      updatefillcolor(s.fillcolor.col,0)
		    else
		      updatefillcolor(s.fillcolor.col,s.fill)
		    end if
		    currentcurve = 0
		    for i = 0 to s.npts-1
		      if s.hidden and s.highlighted then
		        updatecurvecolor(s,i,config.HighlightColor.col, 100)
		      elseif s.hidden Then
		        updatecurvecolor(s,i, config.HideColor.col,100)
		      elseif s.highlighted then
		        n = s.getindexside
		        if n = -1 or n = i then
		          updatecurvecolor(s,i, config.HighlightColor.col, 100)
		        else
		          updatecurvecolor(s,i,  lacet(s).colcotes(i).col,100)
		        end if
		      elseif s.selected then
		        updatecurvecolor(s,i, config.BorderColor.col, 100)
		      else
		        updatecurvecolor(s,i, lacet(s).colcotes(i).col, 100)
		      end if
		      border = 100
		    next
		  else
		    if s.tracept then
		      updatebordercolor (bleu,100)
		    elseif s.hidden and s.highlighted Then
		      updatebordercolor(config.HighlightColor.col, 100)
		      updatefillcolor(s.fillcolor.col,0)
		    elseif s.hidden Then
		      updatebordercolor(cyan, 100)
		      updatefillcolor(s.fillcolor.col,0)
		    elseif s.tsp and s.Highlighted then
		      updatefillcolor(s.fillColor.col,0)
		      updatebordercolor(config.HighlightColor.col,100)
		    elseif s.tsp then
		      updatefillcolor(s.fillColor.col,0)
		      updatebordercolor(s.BorderColor.col,100)
		    elseif s.highlighted and s.selected then
		      updatebordercolor(config.HighlightColor.col,100)
		    elseif s.highlighted  then
		      updatefillcolor(s.fillColor.col,fill)
		      updatebordercolor(config.HighlightColor.col,100)
		    elseif s.selected and s.fillcolor.equal(white) then
		      updatebordercolor(s.BorderColor.col, 100)
		    elseif s.isinconstruction then
		      updatefillcolor(config.Weightlesscolor.col,0)
		      updatebordercolor(config.WeightlessColor.col,100)
		    else
		      updatefillcolor(s.Fillcolor.col,s.fill)
		      updatebordercolor(s.BorderColor.col,s.border)
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fixeepaisseurs(s as shape)
		  dim loc, i, n as integer
		  dim cs(-1) as curveshape
		  
		  if s isa lacet then
		    cs = lacet(s).nsk.cs
		    currentcurve = 0
		    for i = 0 to s.npts-1
		      if (s.highlighted or s.isinconstruction  or s.selected ) and not s.tracept then
		        updatecurvewidth(s,i,2*s.borderwidth)
		      else
		        updatecurvewidth(s,i,s.borderwidth)
		      end if
		    next
		  else
		    if (s.highlighted or s.isinconstruction  or s.selected ) and not s.tracept then
		      updateborderwidth(2*s.borderwidth)
		    else
		      updateborderwidth(s.borderwidth)
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics)
		  g.drawobject self, ref.x, ref.y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(s as shape, g as graphics)
		  update(wnd.mycanvas1.transform(s.points(0).bpt))
		  paint(g)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paintside(g as graphics, n as integer, ep as double, coul as couleur)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update(p as BasicPoint)
		  ref = p
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatebordercolor(col as color, c as double)
		  bordercolor = col
		  border = c
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateborderwidth(d as double)
		  borderwidth = d
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatectrl(n as integer, p as BasicPoint)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatecurvecolor(s as shape, i as integer, col as color, c as double)
		  dim lac as lacet
		  dim n as integer
		  
		  if s isa lacet then
		    lac = lacet(s)
		  end if
		  
		  if lac.coord.curved(i) = 0 then
		    lac.nsk.cs(currentcurve).bordercolor = col
		    lac.nsk.cs(currentcurve).border = c
		    currentcurve = currentcurve+1
		  else
		    for n = 0 to 2
		      lac.nsk.cs(currentcurve+n).bordercolor = col
		      lac.nsk.cs(currentcurve+n).border = c
		    next
		    currentcurve = currentcurve+3
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatecurvewidth(s as shape, i as integer, c as double)
		  dim lac as lacet
		  dim n as integer
		  
		  if s isa lacet then
		    lac = lacet(s)
		  end if
		  
		  if lac.coord.curved(i) = 0 then
		    lac.nsk.cs(currentcurve).borderwidth = c
		    currentcurve = currentcurve+1
		  else
		    for n = 0 to 2
		      lac.nsk.cs(currentcurve+n).borderwidth = c
		    next
		    currentcurve = currentcurve+3
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateextre(n as integer, p as BasicPoint)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatefillcolor(col as color, c as double)
		  fillcolor = col
		  fill = c
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesize(k as double)
		  scale = k
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateskull()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesommet(n as integer, p as BasicPoint)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		cs(-1) As curveshape
	#tag EndProperty

	#tag Property, Flags = &h0
		currentcurve As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ref As BasicPoint
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
			Name="Count"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="currentcurve"
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
