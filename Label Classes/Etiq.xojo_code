#tag Class
Protected Class Etiq
Inherits Label
	#tag Method, Flags = &h0
		Function arrondi2(d as double) As string
		  dim s1, s2, s3 as string
		  dim r, k as double
		  dim m,  i as integer
		  dim b as boolean
		  dim p as integer
		  
		  p = currentcontent.ndec
		  
		  b = (d < 0)
		  
		  if b then
		    d = abs(d)
		  end if
		  
		  r = pow(10,p)
		  k = round(d*r)
		  k = k/r
		  
		  s1 = str(k)
		  m = instr(s1,".")
		  select case m
		  case 0
		    s2 = s1
		  case  1
		    s2= str(0)
		  else
		    s2 = s1.left(m-1)
		    s3 = s1. right(len(s1)-m)
		    s3=s3.left(p)
		  end select
		  if b then
		    s2 = "-"+s2
		  end if
		  if s3 ="" then
		    return s2
		  else
		    return s2+","+s3
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Augmentefont()
		  dim n as single
		  n = TextSize
		  
		  SetSize(n+2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Lab as Etiq)
		  super.constructor
		  setcolor(lab.Textcolor)
		  correction = new BasicPoint(lab.correction.x, lab.correction.y)
		  setfont(lab.Textfont)
		  setitalic(lab.italic)
		  loc = lab.loc
		  position = new BasicPoint(lab.position.x, lab.position.y)
		  psh = lab.psh
		  psw = lab.psw
		  setsize(lab.Textsize)
		  text = lab.text
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(n As integer)
		  
		  super.constructor
		  if chr(Etiquette) <> "*" and chr(Etiquette) <> "%"  then
		    Etiquette = Etiquette+1
		  end if
		  Text = chr(Etiquette)
		  loc = n
		  TextSize = sizelabel
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(side as integer, EL as XMLElement)
		  dim coul as couleur
		  
		  super.constructor
		  
		  dim corr as BasicPoint
		  
		  Text = El.GetAttribute("Text")
		  if Text = "*" then
		    wnd.drapdim = true
		  end if
		  TextFont = EL.GetAttribute("Font")
		  TextSize = val(El.GetAttribute("Size"))
		  Oldsize = Textsize
		  coul = new Couleur(EL)
		  Textcolor = coul.col
		  if El.GetAttribute("Italic")= "True" then
		    Italic = true
		  else
		    Italic = false
		  end if
		  loc = side
		  Corr= new BasicPoint( val(El.GetAttribute("CorrectionX")),  val(El.GetAttribute("CorrectionY")))
		  if val(EL.GetAttribute("Fixe")) = 1 then
		    SetFixe(true)
		  else
		    SetFixe(false)
		  end if
		  if wnd.version >= 222 then
		    correction = corr
		  else
		    correction = can.idtransform(corr)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Copy() As Etiq
		  Dim L as Etiq
		  
		  L = new Etiq(loc)
		  
		  L.Text = Text
		  L.Position = Position
		  L.Textsize = Textsize
		  L.Textcolor = TextColor
		  L.Italic = Italic
		  L.Correction = Correction
		  L.Textfont = Textfont
		  L.chape = chape
		  L.Lockright = Lockright
		  L.LockBottom = LockBottom
		  return L
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DiminueFont()
		  dim n as single
		  n = TextSize
		  
		  if n > 10 then
		    SetSize(n-2)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Etiquet() As String
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
		Sub MouseCorrection(P as BasicPoint)
		  Correction = P-Position
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim  q as BasicPoint
		  dim a  as integer
		  dim  dat as string
		  dim vis as objectslist
		  dim sh as shape
		  dim type as integer  // 0 longueur  //1 aire // 2 abscisse
		  dim dr as droite
		  
		  if (dret <> nil and dret isa rettimer and text =  "*")   then
		    return
		  end if
		  
		  if correction = nil then
		    correction = new BasicPoint(0,0)
		  end if
		  
		  q = position + correction
		  q = can.transform(q)
		  SetParam(g)
		  
		  if chape.highlighted then
		    g.forecolor =config.highlightcolor.col
		  end if
		  
		  if text = "%"  then
		    g.DrawString(str(chape.id),q.x, q.y)
		    ResetParam(g)
		    return
		  end if
		  if text <> "*"   then
		    g.DrawString(Text,q.x, q.y)
		    ResetParam(g)
		    return
		  end if
		  if not wnd.drapdim then
		    resetParam(g)
		    return
		  end if
		  
		  
		  
		  dat ="-10000"
		  ///////////// Abscisses
		  if chape isa point then
		    if point(chape).pointsur.count = 1  then
		      dat = arrondi2(point(chape).location(0))
		    else
		      vis = currentcontent.theobjects.findbipoint(point(chape).bpt)
		      if vis.count > 0  then
		        sh = vis.item(0)
		        if sh isa bipoint then
		          dat = arrondi2(point(chape).bpt.location(bipoint(sh)))
		        elseif sh isa polygon then
		          a = sh.pointonside(point(chape).bpt)
		          if a <> -1 then
		            dr = sh.getside(a)
		            dat = arrondi2(point(chape).bpt.location(dr))
		          end if
		        elseif sh isa Freecircle then
		          dat = arrondi2(point(chape).bpt.location(circle(sh)))
		        end if
		      else
		        ResetParam(g)
		        return
		      end if
		    end if
		    Type = 2
		  end if
		  ////////////////////// Longueurs
		  if (chape isa droite)  or (chape isa arc) or ((chape isa Lacet  or chape isa freecircle) and loc <>-1 ) then
		    Type = 0
		    if chape isa droite then
		      if droite(chape).nextre = 2 then
		        if chape = currentcontent.SHUL then
		          dat = arrondi2(droite(chape).longueur)
		        elseif currentcontent.UL <> 0 then
		          dat = arrondi2(droite(chape).longueur/currentcontent.UL)
		        end if
		      else
		        dat =  "¥"
		        setfont("Symbol")
		      end if
		    elseif chape isa Lacet and Loc <> -1 then
		      if currentcontent.UL <> 0 then
		        dat = arrondi2(Lacet(chape).SideLength(loc)/currentcontent.UL)
		      end if
		    elseif chape isa polygon and loc <> -1 then
		      if chape = currentcontent.SHUL and loc = currentcontent.IcotUL then
		        dat = arrondi2(polygon(chape).getside(loc).longueur)
		      elseif currentcontent.UL <> 0 then
		        dat = arrondi2(polygon(chape).getside(loc).longueur/currentcontent.UL)
		      end if
		    elseif chape isa arc  then
		      dat = str(round(arc(chape).arcangle*180/PI))+"°"
		    elseif chape isa Freecircle and loc <> -1 and currentcontent.UL <> 0 then
		      dat = arrondi2(2*PI*Freecircle(chape).getradius/currentcontent.UL)
		    end if
		  end if
		  
		  ////////////  Aires
		  
		  if ( (chape isa Lacet)  or (chape isa circle and not chape isa arc) ) and (loc = -1) then
		    if chape = currentcontent.SHUA then
		      dat = arrondi2(chape.Aire)
		    elseif currentcontent.UA <> 0 then
		      dat = arrondi2(chape.aire/currentcontent.UA)
		    end if
		    type = 1
		  end if
		  
		  if dat <>"-10000" then
		    select case type
		    case 0
		      if (chape isa droite and chape =currentcontent.SHUL) or (chape isa polygon and chape = currentcontent.SHUL and loc = currentcontent.IcotUL)  then
		        dat = str(1)
		      end if
		    case 1
		      if chape = currentcontent.SHUA  then
		        dat = str(1)
		      end if
		    end select
		    g.Drawstring(dat,q.x, q.y)
		  end if
		  ResetParam(g)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Print(g as Graphics, sc as Double)
		  dim  q as BasicPoint
		  dim  dat as string
		  dim vis as objectslist
		  dim sh as shape
		  dim type,a as integer  // 0 longueur  //1 aire // 2 abscisse
		  dim dr as Droite
		  
		  if correction = nil then
		    correction = new BasicPoint(0,0)
		  end if
		  
		  SetParam(g)
		  g.TextSize=Textsize * sc
		  
		  q = position + correction
		  q = can.transform(q)
		  q = q * sc
		  if text = "%"  then
		    g.DrawString(str(chape.id),q.x, q.y)
		    return
		  end if
		  if text <> "*"   then
		    g.DrawString(Text,q.x, q.y)
		    return
		  end if
		  
		  if not wnd.drapdim then
		    return
		  end if
		  
		  
		  
		  dat ="-10000"
		  ///////////// Abscisses
		  if chape isa point then
		    if point(chape).pointsur.count = 1  then
		      dat = arrondi2(point(chape).location(0))
		    else
		      vis = currentcontent.theobjects.findbipoint(point(chape).bpt)
		      if vis.count > 0  then
		        sh = vis.item(0)
		        if sh isa bipoint then
		          dat = arrondi2(point(chape).bpt.location(bipoint(sh)))
		        elseif sh isa polygon then
		          a = sh.pointonside(point(chape).bpt)
		          if a <> -1 then
		            dr = sh.getside(a)
		            dat = arrondi2(point(chape).bpt.location(dr))
		          end if
		        elseif sh isa Freecircle then
		          dat = arrondi2(point(chape).bpt.location(circle(sh)))
		        end if
		      else
		        return
		      end if
		    end if
		    Type = 2
		  end if
		  ////////////////////// Longueurs
		  if (chape isa droite)  or (chape isa arc) or ((chape isa Lacet  or chape isa freecircle) and loc <>-1 ) then
		    Type = 0
		    if chape isa droite then
		      if droite(chape).nextre = 2 then
		        if chape = currentcontent.SHUL then
		          dat = arrondi2(droite(chape).longueur)
		        elseif currentcontent.UL <> 0 then
		          dat = arrondi2(droite(chape).longueur/currentcontent.UL)
		        end if
		      else
		        dat =  "¥"
		        setfont("Symbol")
		      end if
		    elseif chape isa Lacet and Loc <> -1 then
		      if currentcontent.UL <> 0 then
		        dat = arrondi2(Lacet(chape).SideLength(loc)/currentcontent.UL)
		      end if
		    elseif chape isa polygon and loc <> -1 then
		      if chape = currentcontent.SHUL and loc = currentcontent.IcotUL then
		        dat = arrondi2(polygon(chape).getside(loc).longueur)
		      elseif currentcontent.UL <> 0 then
		        dat = arrondi2(polygon(chape).getside(loc).longueur/currentcontent.UL)
		      end if
		    elseif chape isa arc  then
		      dat = str(round(arc(chape).arcangle*180/PI))+"°"
		    elseif chape isa Freecircle and loc <> -1 and currentcontent.UL <> 0 then
		      dat = arrondi2(2*PI*Freecircle(chape).getradius/currentcontent.UL)
		    end if
		  end if
		  
		  ////////////  Aires
		  
		  if ( (chape isa Lacet)  or (chape isa circle and not chape isa arc) ) and (loc = -1) then
		    if chape = currentcontent.SHUA then
		      dat = arrondi2(chape.Aire)
		    elseif currentcontent.UA <> 0 then
		      dat = arrondi2(chape.aire/currentcontent.UA)
		    end if
		    type = 1
		  end if
		  
		  if dat <>"-10000" then
		    select case type
		    case 0
		      if (chape isa droite and chape =currentcontent.SHUL) or (chape isa polygon and chape = currentcontent.SHUL and loc = currentcontent.IcotUL)  then
		        dat = str(1)
		      end if
		    case 1
		      if chape = currentcontent.SHUA  then
		        dat = str(1)
		      end if
		    end select
		    g.Drawstring(dat,q.x, q.y)
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
		  
		  
		  psw = psw*Textsize
		  psp = psp*Textsize
		  psh = psh*Textsize
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
		Sub SetColor(c as Color)
		  Textcolor  = c
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFixe(t as Boolean)
		  LockRight = t
		  LockBottom = t
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFont(f as string)
		  TextFont = f
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetItalic(it As boolean)
		  Italic = it
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetParam(g as graphics)
		  
		  OldCol = g.ForeColor
		  OldSize = g.TextSize
		  g.TextFont = TextFont
		  g.ForeColor = TextColor
		  g.TextSize=Textsize
		  g.bold = true
		  g.Italic = Italic
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetPosition()
		  dim fp, sp as BasicPoint
		  
		  
		  
		  if chape isa cube then
		    if loc >6 then
		      return
		    end if
		    fp = chape.points(loc).bpt
		    select case cube(chape).tr
		    case 0
		      sp = chape.points((loc+1) mod 6).bpt
		    case 1
		      sp = chape.points(6).bpt
		    case 2
		      sp = chape.points(7).bpt
		    end select
		  elseif  chape isa Bande and loc <> -1 then
		    fp = chape.points(0+2*loc).bpt
		    if loc = 0 then
		      sp = chape.points(1).bpt
		    else
		      sp = bande(chape).point3
		    end if
		  elseif chape isa Secteur and loc <> -1 then
		    fp = chape.points(0).bpt
		    sp = chape.points(loc).bpt
		  elseif chape isa Lacet and loc <> -1 then
		    fp = chape.points(loc).bpt
		    sp = chape.points((loc+1) mod chape.npts).bpt
		  end if
		  
		  if chape isa repere or (LockRight and LockBottom) then
		    Position = new BasicPoint(0,0)
		  elseif (chape isa Lacet ) and loc <> -1 then
		    Position = (fp+sp) /2
		  elseif chape isa Freecircle and loc <> -1 then
		    position = chape.points(1).bpt
		  elseif chape isa arc and loc <> -1 then
		    position = TriBPoint(chape.coord).Subdiv(arc(chape).ori,2,1)
		  elseif loc = -1 then
		    Position = chape.GetGravitycenter
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetSize(s as single)
		  me.Textsize = s
		  me.refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEps(tos as textoutputStream)
		  dim q as BasicPoint
		  dim conv as string
		  dim TE as TextEncoding
		  dim eti as string
		  dim a As  double
		  
		  q =  position + correction
		  
		  
		  if  text = "*" then
		    if chape isa point and point(chape).pointsur.count = 1  then
		      eti = arrondi2(point(chape).location(0))
		    elseif chape isa droite   then
		      eti=arrondi2(droite(chape).firstp.distance(droite(chape).secondp))
		    elseif chape isa polygon and loc = -1 then
		      eti = arrondi2(polygon(chape).aire/currentcontent.UA)
		    elseif chape isa polygon and loc <> -1 then
		      eti =arrondi2(chape.points(loc).bpt.distance(chape.points((loc+1) mod chape.npts).bpt)/currentcontent.UL)
		    elseif chape isa arc then
		      a = arc(chape).arcangle*180/PI
		      eti = left(str(sign(a)*floor(abs(a)+0.5)),4)
		    end if
		  else
		    eti = text
		  end if
		  TE = Encodings.WindowsANSI
		  
		  conv = ConvertEncoding (eti, TE)
		  tos.write("(")
		  tos.write(conv)
		  
		  if chape isa arc then
		    tos.writeline (")  ["+ str(q.x) +"  "+ str(q.y) + "] etiqhord  alphsymb (\260) show")
		  else
		    tos.writeline(")  ["+ str(q.x) +"  "+ str(q.y) + "] etiqhord")
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  dim El as XMLElement
		  
		  El = Doc.CreateElement("Label")
		  El.SetAttribute ("Text",Text)
		  El.SetAttribute ("Font",TextFont)
		  El.SetAttribute ("Size",str(Textsize))
		  if LockRight and LockBottom then
		    El.SetAttribute("Fixe",str(1))
		  end if
		  El.SetAttribute(Dico.value("Rouge"), str(TextColor.red))
		  El.SetAttribute(Dico.Value("Vert"), str(Textcolor.green))
		  El.SetAttribute(Dico.Value("Bleu"), str(Textcolor.blue))
		  El.SetAttribute ("Italic",str(Italic))
		  El.SetAttribute ("CorrectionX",str(Correction.X))
		  El.SetAttribute ("CorrectionY",str(Correction.Y))
		  if not chape isa repere then
		    EL.SetAttribute("Side", str(loc))
		  end if
		  return El
		End Function
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
		chape As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		correction As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		fixe As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		loc As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Oldcol As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		Oldsize As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		oldtaille As double
	#tag EndProperty

	#tag Property, Flags = &h0
		Position As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		psh As double
	#tag EndProperty

	#tag Property, Flags = &h0
		psp As double
	#tag EndProperty

	#tag Property, Flags = &h0
		psw As double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Bold"
			Visible=true
			Group="Font"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DataField"
			Visible=true
			Group="Database Binding"
			Type="String"
			EditorType="DataField"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DataSource"
			Visible=true
			Group="Database Binding"
			Type="String"
			EditorType="DataSource"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fixe"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="20"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Italic"
			Visible=true
			Group="Font"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="loc"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Multiline"
			Visible=true
			Group="Appearance"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Oldcol"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Oldsize"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="oldtaille"
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
			Name="psw"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Selectable"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Text"
			Group="Behavior"
			InitialValue="A"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextAlign"
			Visible=true
			Group="Appearance"
			InitialValue="0"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Left"
				"1 - Center"
				"2 - Right"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextColor"
			Visible=true
			Group="Appearance"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextFont"
			Visible=true
			Group="Font"
			InitialValue="System"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextSize"
			Visible=true
			Group="Font"
			InitialValue="0"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextUnit"
			Visible=true
			Group="Font"
			InitialValue="0"
			Type="FontUnits"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - Pixel"
				"2 - Point"
				"3 - Inch"
				"4 - Millimeter"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Underline"
			Visible=true
			Group="Font"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
