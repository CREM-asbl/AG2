#tag Class
Protected Class SaveEPS
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub adapterparamborder(s as shape, tos as TextOutputStream)
		  dim col as couleur
		  
		  if ti then
		    if s isa circle then
		      col = new couleur(circle(s).nsk.bordercolor)
		    else
		      col = new couleur(s.nsk.bordercolor)
		    end if
		  else
		    col = s.bordercolor
		  end if
		  
		  if not col.equal(Bordercolor) then
		    bordercolor=col
		    tos.writeline(bordercolor.ToEPS + " fixecouleurtrait")
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub adapterparamborder(s as shape, tos as textoutputStream, i as integer)
		  dim cs as curveshape
		  dim col as Couleur
		  drapseg = false
		  cs = LSkull(s.nsk).item(i)
		  if ti then
		    col = new couleur(cs.bordercolor)
		  else
		    col = s.colcotes(i)
		  end if
		  if not col.equal(bordercolor) then
		    bordercolor=col
		    tos.writeline(bordercolor.ToEPS + " fixecouleurtrait")
		    drapseg = true
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub adapterparamdessin(s as shape, tos as textoutputStream)
		  dim col as couleur
		  
		  if s.hidden or s.deleted then
		    return
		  end if
		  
		  adapterparamborder(s,tos)
		  adapterparamfill(s, tos)
		  adapterparamepais(s,tos)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub adapterparamepais(s as shape, tos as TextOutputStream)
		  
		  
		  if ti then
		    if s.nsk.borderwidth <> borderwidth then
		      borderwidth = s.nsk.borderwidth
		    end if
		    tos.writeline(str(borderwidth) + " fixeepaisseurtrait")
		  elseif s.borderwidth <> borderwidth then
		    borderwidth = s.borderwidth
		    tos.writeline(str(borderwidth) + " fixeepaisseurtrait")
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub adapterparametiq(lab as etiq, tos as textoutputstream)
		  dim font as string
		  
		  if lab.Textsize <> corps then
		    corps = lab.Textsize
		    tos.writeline(str(corps) + " fixecorps")
		  end if
		  font = adapterpolice(lab.Textfont,lab.italic)
		  if font <> police then
		    police = font
		    tos.writeline(police + "fixepolice")
		  end if
		  if lab.Textcolor <> textcolor.col then
		    textcolor = new couleur(lab.Textcolor)
		    tos.writeline(colorToEPS(Textcolor.col) + " fixecouleurtexte")
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub adapterparamfill(s as shape, tos as textoutputStream)
		  dim col as couleur
		  dim co as color
		  
		  if  s.nsk = nil  then
		    return
		  end if
		  
		  
		  if s isa point then
		    co = s.nsk.bordercolor
		  elseif s isa circle or s isa lacet then
		    co =s.nsk.fillcolor
		  end if
		  
		  if s.fill > 49 then
		    if ti then
		      col = new couleur(s.nsk.fillcolor)
		    else
		      col = new couleur(co)
		    end if
		    
		    if not col.equal(fillcolor) then
		      fillcolor = col
		      tos.writeline(fillcolor.ToEPS + " fixecouleurfond")
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function adapterpolice(f as string, it as boolean) As string
		  if f = "Courier New" then
		    return "/Courier "
		  elseif f = "Times New Roman" then
		    if it then
		      return "/Times-BoldItalic  "
		    else
		      return "/Times-Bold "
		    end if
		  else
		    return "/"+ f + " "
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub adjoindrepoint(tos as TextOutputstream, q as point)
		  dim n as integer
		  n = q.id
		  
		  if (not q.hidden or (ubound(q.parents) > -1 ) )  and not q.invalid and not q.deleted then
		    if n > Ubound(Obeps) then
		      redim Obeps(n)
		    end if
		    
		    if Obeps(n) = 0 then
		      Obeps(n) = 1
		      tos.writeline("/"+q.etiquet+ " [" + str(q.bpt.x) + " " + str(q.bpt.y) +"]   store")
		    end if
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ajustminmax(x as double, y as double)
		  dim p as BasicPoint
		  
		  p = new BasicPoint(x,y)
		  p = M*p
		  
		  x = p.x
		  y = p.y
		  
		  xmax = max(x,xmax)
		  ymax = max(y,ymax)
		  xmin = min(x,xmin)
		  ymin = min(y,ymin)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ajustminmax(q as point)
		  
		  if  ubound(q.parents) > -1 then
		    ajustminmax(q.bpt.x, q.bpt.y)
		    if q.labs.count = 1 then
		      ajustminmaxlab(q)
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ajustminmaxlab(s as shape)
		  dim bp, bp1 as BasicPoint
		  dim lab as  Etiq
		  dim i as integer
		  
		  if s.labs.count = 0  or (s.hidden  and not s isa repere) then
		    return
		  end if
		  
		  
		  
		  for i = 0 to s.labs.count -1
		    lab = s.labs.item(i)
		    bp = lab.correction
		    bp = bp + lab.position
		    ajustminmax(bp.x,bp.y)
		    
		    lab.pssize
		    bp1 = new BasicPoint(lab.psw, -lab.psh)
		    bp1 = can.idtransform(bp1)
		    bp1= bp1*(50/28.35)
		    bp1 = bp1 +bp
		    
		    ajustminmax(bp1.x,bp1.y)
		    bp = lab.correction
		    
		    bp1 = new BasicPoint(lab.psw, -lab.psp)
		    bp1 = can.idtransform(bp1)
		    bp1= bp1*(50/28.35)
		    bp1.y = - bp1.y
		    bp1 = bp1 +bp
		    
		    ajustminmax(bp1.x,bp1.y)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Body(tos as TextOutputstream, Oblist as ObjectsList)
		  dim s as shape
		  dim q as BasicPoint
		  dim i, j, n as integer
		  dim x,y as double
		  dim etiq as string
		  dim font as string
		  
		  if CurrentContent.TheGrid <>  nil then
		    borderwidth = 0.5
		    tos.writeline(str(0.5) + " fixeepaisseurtrait")
		    CurrentContent.TheGrid.ToEPS (tos)
		  end if
		  
		  // On commence par définir les points
		  
		  for i = 0 to tempshape.count-1
		    s = tempshape.item(i)
		    n = s.id
		    if  s isa point then
		      adjoindrepoint(tos,Point(s))
		    else
		      for j = 0 to Ubound(s.childs)
		        adjoindrepoint(tos,point(s.childs(j)))
		      next
		      for j = 0 to ubound(s.constructedshapes)
		        if s.constructedshapes(j).centerordivpoint then
		          adjoindrepoint(tos,point(s.constructedshapes(j)))
		        end if
		      next
		    end if
		  next
		  
		  // On écrit les titres
		  s = can.rep
		  for j = 0 to  s.labs.count -1
		    adapterparametiq(s.labs.item(j), tos)
		    s.labs.item(j).toEPS(tos)
		  next
		  
		  for i = 1 to CurrentContent.TheObjects.count-1
		    s = CurrentContent.TheObjects.GetPlan(i)
		    if s.selected then
		      if s isa polygon then
		        adapterparamepais(s,tos)
		        adapterparamfill(s, tos)
		        adapterparamborder(s,tos)
		        s.toeps(tos)
		      elseif  not s.invalid and not s.deleted and not s.hidden  then
		        adapterparamdessin(s, tos)
		        s.toeps(tos)
		      end if
		      if s.tsfi.count > 0 then
		        for j = 0 to s.tsfi.count-1
		          s.tsfi.item(j).toEps(tos)
		        next
		      end if
		      for j = 0 to  s.labs.count -1
		        if wnd.drapdim or s.labs.item(j).text <> "*" then
		          adapterparametiq(s.labs.item(j), tos)
		          s.labs.item(j).toEPS(tos)
		        end if
		      next
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Body0()
		  dim s as shape
		  dim q as BasicPoint
		  dim i, j as integer
		  dim x,y as double
		  dim r as double
		  
		  xmax = -9999
		  ymax = -9999
		  xmin = 9999
		  ymin = 9999
		  
		  s = can.rep
		  ajustminmaxlab(s)
		  
		  for i = 0 to tempshape.count-1
		    s = tempshape.item(i)
		    if  not s.invalid and not s.deleted then
		      ajustminmaxlab(s)
		      if s isa point then
		        ajustminmax(point(s))
		      else
		        for j = 0 to Ubound(s.childs)
		          ajustminmax(point(s.childs(j)))
		        next
		        for j = 0 to ubound(s.constructedshapes)
		          if s.constructedshapes(j).centerordivpoint then
		            ajustminmax(point(s.constructedshapes(j)))
		          end if
		        next
		        if s isa circle then
		          q = s.points(0).bpt
		          r = circle(s).radius
		          x = q.x + r
		          y = q.y +r
		          ajustminmax(x,y)
		          x = q.x - r
		          y = q.y -r
		          ajustminmax(x,y)
		        end if
		        if s isa droite and droite(s).nextre < 2 then
		          drapdroite = true
		        end if
		      end if
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Body1(tos as TextOutputstream, Oblist as ObjectsList)
		  dim i, j , k as integer
		  dim s as shape
		  dim t As Boolean
		  
		  for i = 0 to ubound(obeps)
		    if obeps(i) = 1 then
		      t = false
		      j = 0
		      while not t and j <= Oblist.count-1
		        s = Oblist.item(j)
		        t =  (s.id = i)
		        if not t then
		          for k = 0 to ubound(s.childs)
		            if s.childs(k).id = i then
		              s = s.childs(k)
		              t = true
		            end if
		          next
		        end if
		        if not t then
		          for k = 0 to ubound(s.constructedshapes)
		            if s.constructedshapes(k).centerordivpoint  and  s.constructedshapes(k).id = i then
		              s = s.constructedshapes(k)
		              t = true
		            end if
		          next
		        end if
		        j = j+1
		      wend
		      
		      if t and s isa point  and not s.invalid  and not s.deleted then
		        adapterparamdessin(s, tos)
		        if s.labs.count = 1 then
		          adapterparametiq(s.labs.item(0),tos)
		          s.labs.item(0).toeps(tos)
		        end if
		      end if
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ColorToEPS(col as color) As string
		  select case col
		  case RGB(0,0,0), CMY(1,1,1)
		    return "noir"
		  case RGB(1,1,0), CMY(0,0,1)
		    return "jaune"
		  case RGB(1,0,1), CMY(0,1,0)
		    return "magenta"
		  case RGB(0,1,1) , CMY(1,0,0)
		    return "cyan"
		  else
		    return  "[" + str(col.cyan) + " "+  str(col.magenta) + " "+ str(col.yellow) + " 0 ]"
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  super.Constructor
		  OpId = 8
		  if tempshape.count  = 0 then
		    objects.selectall
		  end if
		  M = new Matrix(1)
		  ti = false
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(s as string, name as string, tip as boolean)
		  super.Constructor
		  disp = s
		  ti = tip
		  nom = name
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateTip(tos as TextOutputStream)
		  dim cur1, cur2 as basicpoint
		  
		  cur2  = can.MouseUser
		  tos.writeline("noir fixecouleurtrait")
		  tos.writeline("blanc fixecouleurfond")
		  tos.writeline("/Courier fixepolice")
		  tos.writeline ("8 fixecorps")
		  tos.writeline("1 fixeepaisseurtrait")
		  
		  if nom =  Dico.Value("Construction") or nom = Dico.Value("Modify") then
		    tos.writeline("[  [ " + str(cur2.x+0.05) + " " + str(cur2.y) + " ] [ " + str(cur2.x+0.2) + " " + str(cur2.y) + " ] ] segment")
		    tos.writeline("[  [ " + str(cur2.x-0.05) + " " + str(cur2.y) + " ] [ " + str(cur2.x-0.2) + " " + str(cur2.y) + " ] ] segment")
		    tos.writeline("[  [ " + str(cur2.x) + " " + str(cur2.y+0.05) + " ] [ " + str(cur2.x) + " " + str(cur2.y+0.2) + " ] ] segment")
		    tos.writeline("[  [ " + str(cur2.x) + " " + str(cur2.y-0.05) + " ] [ " + str(cur2.x) + " " + str(cur2.y-0.2) + " ] ] segment")
		    tos.writeline("0.5 fixetaillepoint")
		    tos.writeline(" [ " + str(cur2.x) + " " + str(cur2.y) + " ]  point")
		  else
		    cur1 = new Basicpoint (-0.3,0.45)
		    cur1 = cur2 - cur1
		    tos.writeline("[  [ " + str(cur1.x) + " " + str(cur1.y) + " ] 1  [" + str(cur2.x) + " " + str(cur2.y) +" ]  ] flechecreuse" )
		  end if
		  
		  tos.writeline("(" + disp + ")  [" + str(cur2.x) + " " + str(cur2.y) +" ]  [0 0.1] addp etiqhord ")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub creerprologueeps(tos as textoutputstream)
		  dim a , b, aa, bb as double
		  dim r as double
		  dim u1, u2, u3 as BasicPoint
		  
		  rotate
		  
		  Body0 // Calcul de la Bounding Box
		  
		  
		  if CurrentContent.TheGrid <>  nil then
		    xmin = xmin-1
		    ymin = ymin-1
		    xmax = xmax+1
		    ymax = ymax+1
		  else
		    xmin = xmin-0.1
		    ymin = ymin-0.1
		    xmax = xmax+0.1
		    ymax = ymax+0.1
		  end if
		  
		  if drapdroite then
		    xmin = xmin-1 '0.05*a
		    xmax = xmax+1 '0.05*a
		    ymin = ymin-1 '0.05*b
		    ymax = ymax+1 '0.05*b
		    'a=a*1.1
		    'b=b*1.1
		  end if
		  a = xmax - xmin
		  b = ymax - ymin
		  
		  if a > 19 then
		    b = b*19/a
		    a = 19
		  end if
		  
		  llx = 28.35
		  lly = 28.35
		  urx = (a+1)*28.35
		  ury = (b+1)*28.35
		  
		  tos.writeline("%!PS-Adobe-3.0 EPSF-3.0")
		  tos.writeline("%%BoundingBox: 28 28 "+ str(urx) + " "+ str(ury))
		  tos.writeline("%%Creator:Apprenti Geometre Version 2")
		  'readag2ps
		  'writeag2ps(tos)
		  tos.write ag2
		  tos.writeline("debut")
		  tos.writeline("[[1 cm 1 cm][" + str(a+1) + " cm " + str(b+1) + " cm]] fixecadre")
		  tos.writeline("[[" + str(xmin) +" " + str(ymin) + "][" + str(xmax) + " " + str(ymax) +"]] fixedomaine")
		  if alpha <> 0 then
		    alpha = (alpha*180)/PI
		    tos.writeline(str(alpha)+ " rotate")
		    tos.writeline("/etiqhord {" + str(alpha) + " neg etiqobliqued} def ")
		  end if
		  tos.writeline "1 fixemoderemplissage"
		  bordercolor = black
		  fillcolor = black
		  textcolor = black
		  'Pour la transparence
		  'tos.writeline("0 .pushpdf14devicefilter")
		  'tos.writeline("<< >> 28 28 " + str(ceil(urx)) + " "+ str(ceil(ury)) + " .begintransparencygroup")
		  'tos.writeline("0.5 .setopacityalpha")
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim Tos as TextOutputStream
		  dim titre as string
		  dim n as integer
		  dim f as folderitem
		  
		  if tempshape.count =  0 and can.rep.labs.count = 0 then
		    return
		  end if
		  
		  if CurrentContent.CurrentFile=nil then
		    Titre = Dico.Value("SansTitre")+".eps"
		  else
		    n = CurrentContent.CurrentFile.Name.Instr(".")
		    if n = 0 then
		      Titre = CurrentContent.CurrentFile.Name+".eps"
		    else
		      Titre = Left(CurrentContent.CurrentFile.Name, n-1) +".eps"
		    end if
		  end if
		  
		  f = getsavefolderitem(FileAGTypes.EPS, Titre)
		  
		  if f <> nil then
		    can.MouseCursor= System.Cursors.wait
		    tos=f.createTextFile
		    creerprologueeps(tos)
		    Body(tos,tempshape)
		    Body1(tos,tempshape)
		    if ti then
		      CreateTip(tos)
		    end if
		    'tos.writeline(".endtransparencygroup")
		    'tos.writeline(".poppdf14devicefilter")
		    tos.writeline("fin")
		    tos.close
		    can.MouseCursor= System.Cursors.StandardPointer
		  end if
		  redim obeps(-1)
		  tempshape.canceldejaexporte
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.value("FileSaveEPS")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub readag2ps()
		  dim tis as textinputstream
		  
		  tis= TextInputStream.Open(app.appfolder.child("AG2.ps"))
		  s = tis.readall
		  tis.close
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub rotate()
		  dim u, c, p as BasicPoint
		  
		  
		  u = new BasicPoint(can.Rep.Idx.x, can.Rep.Idx.y)
		  u.y = - u.y
		  alpha = u.anglepolaire
		  c = new BasicPoint(0,0)
		  M = new RotationMatrix (c,alpha)
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub writeag2ps(tos as textoutputstream)
		  if s <> "" then
		    tos.write s
		    tos.writeline ""
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
		alpha As double
	#tag EndProperty

	#tag Property, Flags = &h0
		Border As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Bordercolor As Couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		Borderwidth As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Corps As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		disp As string
	#tag EndProperty

	#tag Property, Flags = &h0
		drapdroite As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drapseg As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Fill As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FillColor As Couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		llx As double
	#tag EndProperty

	#tag Property, Flags = &h0
		lly As double
	#tag EndProperty

	#tag Property, Flags = &h0
		M As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		nom As string
	#tag EndProperty

	#tag Property, Flags = &h0
		ObEPS(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		PointSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Police As string
	#tag EndProperty

	#tag Property, Flags = &h0
		s As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Textcolor As Couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		ti As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		urx As double
	#tag EndProperty

	#tag Property, Flags = &h0
		ury As double
	#tag EndProperty

	#tag Property, Flags = &h0
		xmax As double
	#tag EndProperty

	#tag Property, Flags = &h0
		xmin As double
	#tag EndProperty

	#tag Property, Flags = &h0
		ymax As double
	#tag EndProperty

	#tag Property, Flags = &h0
		ymin As double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="alpha"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Borderwidth"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="canceling"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Corps"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="disp"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapdroite"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapseg"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="llx"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="lly"
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
			Name="nom"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
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
			Name="PointSize"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Police"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="s"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
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
			Name="ti"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="urx"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ury"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="xmax"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="xmin"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ymax"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ymin"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
