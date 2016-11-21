#tag Class
Protected Class NSkull
Inherits FigureShape
	#tag Method, Flags = &h0
		Sub Constructor(p as BasicPoint)
		  dim q as BasicPoint
		  q = can.transform(p)
		  x = q.x
		  Y = q.y
		  ref = q
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fixecouleurs(s as shape)
		  dim loc, i, n, b, f as integer 'ne sert que pour les cercles et les arcs
		  
		  b = s.border
		  f= s.fill
		  if b = 0 then
		    b = 100
		  end if
		  
		  
		  if s.tracept then
		    updatebordercolor (bleu,b)
		  elseif s.hidden and s.highlighted Then
		    updatebordercolor(config.HighlightColor.col, b)
		    updatefillcolor(s.fillcolor.col,0)
		  elseif s.hidden Then
		    updatebordercolor(cyan, b)
		    updatefillcolor(s.fillcolor.col,0)
		  elseif s.tsp and s.Highlighted then
		    updatefillcolor(s.fillColor.col,0)
		    updatebordercolor(config.HighlightColor.col,b)
		  elseif s.tsp then
		    updatefillcolor(s.fillColor.col,0)
		    updatebordercolor(s.BorderColor.col,b)
		  elseif s.highlighted and s.selected then
		    updatebordercolor(config.HighlightColor.col,b)
		  elseif s.highlighted  then
		    updatefillcolor(s.fillColor.col,f)
		    updatebordercolor(config.HighlightColor.col,b)
		  elseif s.selected and s.fillcolor.equal(white) then
		    updatebordercolor(s.BorderColor.col, b)
		  elseif s.isinconstruction then
		    updatefillcolor(config.Weightlesscolor.col,0)
		    updatebordercolor(config.WeightlessColor.col,b)
		  else
		    updatefillcolor(s.Fillcolor.col,f)
		    updatebordercolor(s.BorderColor.col,b)
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fixeepaisseurs(s as shape)
		  dim  i as integer
		  
		  
		  if (s.highlighted or s.isinconstruction  or s.selected ) and not s.tracept then
		    updateborderwidth(2*s.borderwidth)
		  else
		    updateborderwidth(s.borderwidth)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertPoint(p as BasicPoint, n as integer)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub oldpaint(s as shape, g as graphics)
		  update(can.transform(s.points(0).bpt))
		  paint(g)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paint(g as graphics)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub paintside(g as graphics, n as integer, ep as double, coul as couleur)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removepoint(n as integer)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update(p as BasicPoint)
		  
		  
		  
		  x = p.x
		  y =p.y
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update(s as shape)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatebordercolor(col as color, c as double)
		  bordercolor = col 'méthode condamnée à disparaître
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
		Sub updaterotation(a as double)
		  rotation = a
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesize(k as double)
		  scale = k
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updatesommet(n as integer, p as BasicPoint)
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = Explications
		
		Les "skulls" sont les "squelettes" des différentes formes géométriques, c'est-à-dire les objets informatiques de bas niveau qui sont 
		réellement dessinés.
		Lors de chaque exécution d'une routine "paint", les skulls doivent être mis à jour du point de vue des coordonnées de chacun des sommets,
		(ou autres points significatifs), des couleurs et de l'épaisseur de chaque côté.  Les informations nécessaires sont extraites des objets de haut niveau correspondants.
		Tous les côtés d'une forme ont même épaisseur mais pas nécessairement même épaisseur.
		
		Il y a deux de classes de skulls. Toutes sont des sous-classes de la classe Object2D du langage RealBasic.
		
		1ere famille de classes de skulls
		
		Object2D --- FigureShape --- NSkull ---- ArcSkull  ------- Utilisé pour les classes ---- Arc, FreeCircle, StdCircle
		                                                                ---- CubeSkull ----------------------------------  Cube
		                                                                ---- Lskull     ------------------------------------- Bande,  DSect, Lacet, Polreg, Polygon (et sous-classes,
		                                                                                                                                                     Polyqcq, Standardpölygon, etc, sauf Cube)                                                                                                                                                  
		                                                                ---- SecteurSkull --------------------------------  Secteur
		                                                                ---- SegSkull ------------------------------------  Droite
		
		2eme famille de classes de skulls 
		
		Object2D ----OvalShape  ---- OvalSkull ---------------------------------------------- Point
	#tag EndNote


	#tag Property, Flags = &h0
		angle As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		BB As BiBPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ref As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		skullof As shape
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="angle"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
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
