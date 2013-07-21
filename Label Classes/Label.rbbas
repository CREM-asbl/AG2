#tag Class
Protected Class Label
	#tag Method, Flags = &h0
		Sub Label(n As integer)
		  
		  if chr(Etiquette) <> "*" and chr(Etiquette) <> "%"  then
		    Etiquette = Etiquette+1
		  end if
		  Text = chr(Etiquette)
		  loc = n
		  size = sizelabel
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim  q as BasicPoint
		  dim a, iobj  as integer
		  dim  dat as double
		  dim vis as objectslist
		  dim sh as shape
		  dim ch as string
		  dim type as integer  // 0 longueur  //1 aire // 2 abscisse
		  dim dr as droite
		  
		  if (dret <> nil and dret isa rettimer and text =  "*")   then
		    return
		  end if
		  
		  if correction = nil then
		    correction = new BasicPoint(0,0)
		  end if
		  
		  q = position + correction
		  q = wnd.mycanvas1.transform(q)
		  SetParam(g)
		  
		  if text = "%"  then
		    g.DrawString(str(shape.id),q.x, q.y)
		    ResetParam(g)
		    return
		  end if
		  if text <> "*"  then
		    g.DrawString(Text,q.x, q.y)
		    ResetParam(g)
		    return
		  end if
		  if not wnd.drapdim then
		    resetParam(g)
		    return
		  end if
		  
		  
		  
		  dat = -10000
		  ///////////// Abscisses
		  if shape isa point then
		    if point(shape).pointsur.count = 1  then
		      dat = arrondi2(point(shape).location(0))
		    else
		      vis = currentcontent.theobjects.findbipoint(point(shape).bpt)
		      if vis.count > 0  then
		        sh = vis.element(0)
		        if sh isa bipoint then
		          dat = arrondi2(point(shape).bpt.location(bipoint(sh)))
		        elseif sh isa polygon then
		          a = sh.pointonside(point(shape).bpt)
		          if a <> -1 then
		            dr = sh.getside(a)
		            dat = arrondi2(point(shape).bpt.location(dr))
		          end if
		        elseif sh isa Freecircle then
		          dat = arrondi2(point(shape).bpt.location(circle(sh)))
		        end if
		      else
		        ResetParam(g)
		        return
		      end if
		    end if
		    Type = 2
		  end if
		  ////////////////////// Longueurs
		  if (shape isa droite) or ((shape isa polygon or shape isa arc or shape isa freecircle) and loc <>-1 ) then
		    Type = 0
		    if shape isa droite  and droite(shape).nextre = 2 then
		      if shape = currentcontent.SHUL then
		        dat = arrondi2(droite(shape).longueur)
		      elseif currentcontent.UL <> 0 then
		        dat = arrondi2(droite(shape).longueur/currentcontent.UL)
		      end if
		    elseif shape isa Lacet and Loc <> -1 then
		      if currentcontent.UL <> 0 then
		        dat = arrondi2(Lacet(shape).SideLength(loc)/currentcontent.UL)
		      end if
		    elseif shape isa polygon and loc <> -1 then
		      if shape = currentcontent.SHUL and loc = currentcontent.IcotUL then
		        dat = arrondi2(polygon(shape).getside(loc).longueur)
		      elseif currentcontent.UL <> 0 then
		        dat = arrondi2(polygon(shape).getside(loc).longueur/currentcontent.UL)
		      end if
		    elseif shape isa arc and loc <>-1 then
		      dat = round(arc(shape).arcangle*180/PI)
		    elseif shape isa Freecircle and loc <> -1 and currentcontent.UL <> 0 then
		      dat = arrondi2(2*PI*Freecircle(shape).getradius/currentcontent.UL)
		    end if
		  end if
		  
		  ////////////  Aires
		  
		  if ( (shape isa polygon)  or (shape isa circle and not shape isa arc) ) and (loc = -1) then
		    if shape = currentcontent.SHUA then
		      dat = arrondi2(shape.aire)
		    elseif currentcontent.UA <> 0 then
		      dat = arrondi2(shape.aire/currentcontent.UA)
		    end if
		    type = 1
		  end if
		  
		  if dat <> -10000 then
		    if (shape isa arc) and loc <> -1  then
		      ch = left(str(dat),4)+"°"
		    elseif dat < 0 then
		      ch = left(str(dat),6)
		    else
		      ch = left(str(dat),5)
		    end if
		    
		    select case type
		    case 0
		      if (shape isa droite and shape =currentcontent.SHUL) or (shape isa polygon and shape = currentcontent.SHUL and loc = currentcontent.IcotUL)  then
		        ch = "Ref. " + ch
		      end if
		    case 1
		      if shape = currentcontent.SHUA  then
		        ch = "Ref. " + ch
		      end if
		    end select
		    g.Drawstring(ch,q.x, q.y)
		  else
		    infini(g)
		  end if
		  ResetParam(g)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetPosition()
		  dim fp, sp as BasicPoint
		  dim Trib as TriBPoint
		  
		  
		  if shape isa cube then
		    if loc >6 then
		      return
		    end if
		    fp = shape.points(loc).bpt
		    select case cube(shape).tr
		    case 0
		      sp = Shape.points((loc+1) mod 6).bpt
		    case 1
		      sp = shape.points(6).bpt
		    case 2
		      sp = shape.points(7).bpt
		    end select
		  elseif shape isa polygon and loc <> -1 then
		    fp = shape.points(loc).bpt
		    sp = Shape.points((loc+1) mod shape.npts).bpt
		  elseif  shape isa Bande and loc <> -1 then
		    fp = shape.points(0+2*loc).bpt
		    if loc = 0 then
		      sp = shape.points(1).bpt
		    else
		      sp = bande(shape).point3
		    end if
		  elseif shape isa Secteur and loc <> -1 then
		    fp = shape.points(0).bpt
		    sp = shape.points(loc).bpt
		  elseif shape isa Freecircle and loc <> -1 then
		    position = shape.points(1).bpt
		  elseif shape isa arc and loc <> -1 then
		    TriB = new TribPoint(arc(shape).getgravitycenter,arc(shape).startp, arc(shape).endp)
		    position = Trib.Subdiv(arc(shape).ori,2,1)
		  end if
		  
		  if shape isa repere or fixe then
		    Position = new BasicPoint(0,0)
		  elseif (shape isa polygon or Shape isa bande or shape isa secteur) and loc <> -1 then
		    Position = (fp+sp) /2
		  elseif loc = -1 then
		    Position = Shape.GetGravitycenter
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetSize(s as integer)
		  size = s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetItalic(it As boolean)
		  Italique = it
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetColor(c as Color)
		  col  = c
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Copy() As Label
		  Dim L as Label
		  
		  L = new Label(loc)
		  
		  L.Text = Text
		  L.Position = Position
		  L.size = size
		  L.col = col
		  L.Italique = Italique
		  L.Correction = Correction
		  L.font = font
		  L.shape = shape
		  L.fixe = fixe
		  return L
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseCorrection(P as BasicPoint)
		  
		  
		  Correction = P-Position
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  dim El as XmlElement
		  dim can as Mycanvas
		  dim corr as BasicPoint
		  
		  can = wnd.mycanvas1
		  
		  El = Doc.CreateElement("Label")
		  El.SetAttribute ("Text",Text)
		  El.SetAttribute ("Font",Font)
		  El.SetAttribute ("Size",str(size))
		  if fixe then
		    El.SetAttribute("Fixe",str(1))
		  end if
		  El.SetAttribute(Dico.value("Rouge"), str(Col.red))
		  El.SetAttribute(Dico.Value("Vert"), str(col.green))
		  El.SetAttribute(Dico.Value("Bleu"), str(col.blue))
		  El.SetAttribute ("Italic",str(Italique))
		  El.SetAttribute ("CorrectionX",str(Correction.X))
		  El.SetAttribute ("CorrectionY",str(Correction.Y))
		  if not shape isa repere then
		    EL.SetAttribute("Side", str(loc))
		  end if
		  return El
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Label(side as integer, EL as XMLElement)
		  dim coul as couleur
		  dim s as string
		  dim can as Mycanvas
		  
		  can = wnd.Mycanvas1
		  dim corr as BasicPoint
		  
		  Text = El.GetAttribute("Text")
		  if Text = "*" then
		    wnd.drapdim = true
		  end if
		  Font = EL.GetAttribute("Font")
		  Size = val(El.GetAttribute("Size"))
		  Oldsize = size
		  coul = new Couleur(EL)
		  col = coul.col
		  if El.GetAttribute("Italic")= "True" then
		    Italique = true
		  else
		    Italique = false
		  end if
		  loc = side
		  Corr= new BasicPoint( val(El.GetAttribute("CorrectionX")),  val(El.GetAttribute("CorrectionY")))
		  if val(EL.GetAttribute("Fixe")) = 1 then
		    fixe = true
		  else
		    Fixe = false
		  end if
		  if wnd.version >= 222 then
		    correction = corr
		  else
		    correction = can.idtransform(corr)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFont(f as string)
		  font = f
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEps(tos as textoutputStream)
		  dim q as BasicPoint
		  dim conv as string
		  dim TE as TextEncoding
		  dim eti as string
		  dim a, aa As  double
		  
		  q =  position + correction
		  
		  
		  if  text = "*" then
		    if shape isa point and point(shape).pointsur.count = 1  then
		      a = point(shape).location(0)
		      eti = left(str(Tronquer(a,2)),4)
		    elseif shape isa droite   then
		      a = droite(shape).firstp.distance(droite(shape).secondp)
		      eti = left(str(Tronquer(a,1)),4)
		    elseif shape isa polygon and loc = -1 then
		      a = arrondi2(polygon(shape).aire/currentcontent.UA)
		      eti = left(str(Tronquer(a,1)),4)
		    elseif shape isa polygon and loc <> -1 then
		      a =arrondi2(shape.points(loc).bpt.distance(shape.points((loc+1) mod shape.npts).bpt)/currentcontent.UL)
		      eti =left(str(Tronquer(a,1)),4)
		    elseif shape isa arc then
		      a = arc(shape).arcangle*180/PI
		      eti = left(str(sign(a)*floor(abs(a)+0.5)),4)
		    end if
		  else
		    eti = text
		  end if
		  TE = Encodings.WindowsANSI
		  
		  conv = ConvertEncoding (eti, TE)
		  tos.write("(")
		  tos.write(conv)
		  
		  if shape isa arc then
		    tos.writeline (")  ["+ str(q.x) +"  "+ str(q.y) + "] etiqhord  alphsymb (\260) show")
		  else
		    tos.writeline(")  ["+ str(q.x) +"  "+ str(q.y) + "] etiqhord")
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub pssize()
		  dim i, n as integer
		  dim w, h, p as double
		  
		  psw = 0
		  psh = 0
		  psp = 0
		  
		  for i = 1 to Text.len
		    p = 0
		    h = 0
		    w = 0
		    n = asc(Text.Mid(i))
		    select case n
		    case 224, 225, 226, 227,228,229
		      n = 97
		    case 231
		      n = 99
		    end select
		    TMBI(n,w,h,p)
		    psw = psw + w
		    psh = max(psh, h)
		    psp = max(psp ,p)
		  next
		  
		  
		  psw = psw*size
		  psp = psp*size
		  psh = psh*size
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function etiq() As string
		  dim et as string
		  
		  if  text = " " or text = "*"  then
		    et = ""
		  elseif text <> "0" and val(text) = 0 then
		    et = text+ " "
		  elseif  (text = "0" or val(text )<> 0) then
		    et = "n"+text
		  end if
		  
		  if text = "*" then
		    wnd.drapdim = true
		  end if
		  return et
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Label(Lab as Label)
		  setcolor(lab.col)
		  correction = new BasicPoint(lab.correction)
		  setfont(lab.font)
		  setitalic(lab.italique)
		  loc = lab.loc
		  position = new BasicPoint(lab.position)
		  psh = lab.psh
		  psw = lab.psw
		  setsize(lab.size)
		  text = lab.text
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Tronquer(a as double, n as integer) As double
		  dim aa as double
		  
		  aa = abs(a)
		  aa = arrondi2((10^n)*aa)/10^n
		  a = sign(a)*aa
		  if abs(a) < 0.1 then
		    a = 0
		  end if
		  return a
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFixe(t as Boolean)
		  Fixe = t
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function arrondi2(d as double) As double
		  return  round(d*100)/100
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetParam(g as graphics)
		  
		  OldCol = g.ForeColor
		  OldSize = g.TextSize
		  g.TextFont = Font
		  g.ForeColor = col
		  g.TextSize=size
		  g.bold = true
		  g.Italic = Italique
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetParam(g as graphics)
		  g.ForeColor = OldCol
		  g.TextSize=Oldsize
		  g.bold =false
		  g.Italic =false
		  g.TextFont = "System"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub infini(g as graphics)
		  setfont("Symbol")
		  g.TextFont= "Symbol"
		  Text= "¥"
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
		Text As string = "A"
	#tag EndProperty

	#tag Property, Flags = &h0
		Position As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		size As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Italique As Boolean = true
	#tag EndProperty

	#tag Property, Flags = &h0
		col As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		Font As string
	#tag EndProperty

	#tag Property, Flags = &h0
		psw As double
	#tag EndProperty

	#tag Property, Flags = &h0
		psh As double
	#tag EndProperty

	#tag Property, Flags = &h0
		psp As double
	#tag EndProperty

	#tag Property, Flags = &h0
		correction As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		loc As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		shape As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		fixe As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		oldtaille As double
	#tag EndProperty

	#tag Property, Flags = &h0
		Oldsize As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Oldcol As Color
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
			Name="Text"
			Group="Behavior"
			InitialValue="A"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="size"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Italique"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="col"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Font"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="psw"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="psh"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="psp"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="loc"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fixe"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="oldtaille"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Oldsize"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Oldcol"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
