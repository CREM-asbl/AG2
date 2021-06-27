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
		  Dim loc, i, n, b As Integer 'ne sert que pour les cercles et les arcs
		  dim col as color
		  b = s.border
		  
		  
		  if b = 0 then
		    b = 100
		  end if
		  
		  if s.hidden then
		    col = config.HideColor.col
		  elseif s.highlighted then
		    col = config.HighlightColor.col
		  elseif s.isinconstruction then
		    col = config.weightlesscolor.col
		    b = 100
		  elseif s.tracept then
		    col = bleu
		    b = 100
		  else
		    col = s.bordercolor.col
		  end if 
		  
		  updatecurvecolor(s, col)
		  updatefillcolor(s.fillcolor.col, s.fill)
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fixeepaisseurs(s as shape)
		  
		  
		  if (s.isinconstruction  or s.selected ) and not s.tracept then
		    updateborderwidth(1.5*s.borderwidth)
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
		Sub paint(g as graphics, coul as couleur)
		  dim i as integer
		  
		  if not (currentcontent.currentoperation isa retourner and dret <>nil) then
		    'si  <> nil et currentop est une des opérations mentionnées, le calcul des extre et ctrl est fait par le timer
		    update(skullof)
		  end if
		  
		  for i = 0 to count-1
		    item(i).bordercolor = coul.col
		    g.drawobject item(i), x, y
		  next
		  
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
		Sub updatecurvecolor(s as shape, col as color)
		  dim i as integer
		  
		  if self isa arcskull then
		    for i = 0 to 2
		      item(i).bordercolor = col
		    next
		  elseif self isa segskull then
		    item(0).bordercolor = col
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
		Tous les côtés d'une forme ont même épaisseur mais pas nécessairement même couleur.
		
		Il y a deux de classes de skulls. Toutes sont des sous-classes de la classe Object2D du langage RealBasic.
		
		1ere famille de classes de skulls
		
		Object2D --- FigureShape --- NSkull ---- ArcSkull  ------- Utilisé pour les classes ---- Arc, FreeCircle, StdCircle
		                                                                ---- CubeSkull ----------------------------------  Cube
		                                                                ---- Lskull     ------------------------------------- Bande,  DSect, Lacet, Polreg, Polygon (et sous-classes,
		                                                                                                                                                     Polyqcq, Standardpolygon, etc, sauf Cube)                                                                                                                                                  
		                                                                ---- SecteurSkull --------------------------------  Secteur
		                                                                ---- SegSkull ------------------------------------  Droite
		
		2eme famille de classes de skulls 
		
		Object2D ----OvalShape  ---- OvalSkull ---------------------------------------------- Point, StdCircle
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
