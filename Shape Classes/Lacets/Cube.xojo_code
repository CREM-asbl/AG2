#tag Class
Protected Class Cube
Inherits StandardPolygon
	#tag Method, Flags = &h0
		Sub Constructor(ol as Objectslist, p as BasicPoint, m as integer)
		  dim sc, size as double
		  dim k as integer   'k est la taille de la réglette. Pour les cubes : 1, pour les réglettes forme+1
		  
		  Polygon.constructor(ol,1,p)
		  redim prol(11)
		  file = Config.stdfile
		  fam = 10
		  forme = m
		  mode = m
		  sc = can.scaling
		  stdsize=Config.StdSize
		  
		  angles.append 0
		  Myspecs = Config.StdFamilies(0,forme)
		  if Config.NamesStdFamilies(0) = "Rods" then
		    k = forme+1                        'k est la taille de la réglette
		    FixeCouleurFond  (MySpecs.Coul,  100)
		    mode = 0
		    rod = true
		  else
		    k = 1
		    FixeCouleurFond  (Config.StdColor(0),  100)
		  end if
		  narcs = 0
		  if mode = 2 then
		    npts = 8
		    fill = 0
		  else
		    npts = 7
		  end if
		  
		  createskull(p,mode,k, self)
		  Borderwidth = 1/(sc*stdsize)
		  FixeCouleurTrait   (Config.bordercolor,  Config.Border)
		  Fixecouleurfond(fillcolor,fill)
		  std = true
		  autos
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(obl as objectslist, other as cube, p as basicPoint)
		  dim M as Matrix
		  dim sc as double
		  dim i as integer
		  
		  Shape.constructor(obl,other)
		  rod = other.rod
		  angles.append Other.angles(0)
		  stdsize=other.getSize
		  sc = can.scaling
		  M = new TranslationMatrix(p)
		  file = Config.stdfile
		  Borderwidth = 1/(sc*stdsize)
		  if rod then
		    csk = new Cubeskull(can.transform(p),0,other.forme+1)
		  else
		    csk = new Cubeskull(can.transform(p),other.forme,1)
		  end if
		  csk.skullof = self
		  csk.updatesize(sc*stdsize)
		  csk.updatefillcolor(fillcolor.col,fill)
		  
		  Move(M)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, El as XMLElement)
		  dim name as string
		  dim sc as double
		  dim mode, k as integer
		  
		  super.constructor(ol,EL)
		  
		  stdsize = Val(El.GetAttribute("Taille"))
		  angles.append  Val(El.GetAttribute("Angle"))
		  name =  EL.GetAttribute("StdFile")
		  if name = "Rods.std" then
		    rod = true
		    mode = 0
		    k = forme+1
		  else
		    mode = forme
		    k = 1
		  end if
		  file = Config.stdfile
		  
		  sc = can.scaling
		  std = true
		  csk = new Cubeskull(can.transform(points(0).bpt),mode, k)
		  csk.skullof = self
		  csk.updatesize(sc*stdsize)
		  Borderwidth = 1/(sc*stdsize)
		  Border = 100
		  updateskull
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape()
		  dim q as BasicPoint
		  dim i as integer
		  dim fs as figureshape
		  dim cs as curveshape
		  
		  fs = figureshape(csk.item(0))
		  for i = 1 to 5
		    cs = fs.item(i)
		    q = new basicpoint(cs.X,cs.Y)
		    Points(i).moveto(Points(0).bpt + can.idtransform(q))
		  next
		  cs = curveshape(csk.item(1))
		  q = new BasicPoint (cs.X,cs.Y)
		  Points(6).moveto(Points(0).bpt + can.idtransform(q))
		  if npts = 8 then
		    cs =curveshape( csk.item(4))
		    q = new BasicPoint (cs.X,cs.Y)
		    Points(7).moveto(Points(0).bpt + can.idtransform(q))
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createskull(p as BasicPoint, mode as integer, k as integer, s as shape)
		  csk = new Cubeskull(can.transform(p),mode,k)
		  csk.skullof = s
		  csk.updatesize(can.scaling*stdsize)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Endconstruction()
		  ConstructShape
		  super.Endconstruction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as BasicPoint, n as integer)
		  If n = 0 then
		    Points(0).Moveto(p)
		    csk.update(can.transform(p), n)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FixeCouleurtrait(c as couleur, b as integer)
		  Bordercolor = c
		  Border = b
		  Initcolcotes
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetiBipjBip(cot as integer, Byref Ibip as integer, byref Jbip as integer)
		  if cot < 6 then
		    ibip = cot
		    jbip = (ibip+1) mod 6
		  else
		    if mode = 0 or mode = 2 then
		      ibip = 1 + 2*(cot-6)
		      jbip = 6
		    else
		      ibip = 2*(cot-6)
		      jbip = 6
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSide(i as integer) As Droite
		  dim d as Droite
		  select case  i
		  case 0, 1, 2, 3, 4, 5
		    d = new Droite(Points(i),Points((i+1) mod 6))
		    tr = 0
		  case 6, 7, 8
		    if mode = 0 or mode = 2 then
		      d = new droite(Points(6),Points((i-6)*2+1))
		    elseif mode = 1 then
		      d = new droite(Points(6),Points((i-6)*2))
		    end if
		    tr = 1
		  case 9,10,11
		    d = new droite(Points(7),Points((i-9)*2))
		    tr = 2
		  end select
		  
		  
		  
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getSize() As integer
		  return stdsize
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.Value("Cube")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitColcotes()
		  dim i as integer
		  
		  redim colcotes(11)
		  
		  for i = 0 to 8
		    colcotes(i) = Config.bordercolor
		  next
		  for i = 9 to 11
		    colcotes(i) = new couleur(cyan)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  if not wnd.drapshowall and hidden then
		    return
		  end if
		  
		  
		  
		  if hidden  Then
		    csk.updateborderwidth(borderwidth)
		    csk.updatebordercolor(config.HideColor.col, 100)
		    csk.updatefillcolor(fillcolor.col,0)
		  elseif highlighted then
		    csk.updateborderwidth(borderwidth)
		    csk.updatebordercolor(Config.highlightcolor.col,100)
		  elseif isinconstruction then
		    csk.updateborderwidth(1.5*borderwidth)
		    csk.updatebordercolor(Config.Weightlesscolor.col,100)
		  elseif selected then
		    csk.updateborderwidth(borderwidth)
		    csk.updatebordercolor(BorderColor.col, 100)
		  else
		    csk.updateborderwidth(Borderwidth)
		    csk.UpdateFillColor(FillColor.col,Fill)
		    csk.updatebordercolors(colcotes,100)
		  end if
		  
		  csk.paint(g)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paintside(g as graphics, cot as integer, ep as double, coul as couleur)
		  dim cs as curveshape
		  
		  cs = cubeskull(nsk).getcote(cot)
		  cs.borderwidth = ep*borderwidth
		  cs.bordercolor = coul.col
		  g.drawobject(cs, nsk.ref.x, nsk.ref.y)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as ObjectsList, p as BasicPoint) As Cube
		  dim s as new Cube(Obl,self,p)
		  Obl.addshape(s)
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(p as BasicPoint) As Boolean
		  dim Bord as nBPoint
		  dim i as integer
		  
		  
		  
		  Bord = new nBPoint
		  for i = 0 to 5
		    Bord.append points(i).bpt
		  next
		  
		  return  Bord.pInShape(p)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As integer
		  dim i, imin as integer
		  dim distmin, dist, delta as double
		  dim q as BasicPoint
		  
		  delta = can.MagneticDist
		  
		  distmin = p.distance(Points(0).bpt,Points(1).bpt)
		  imin = -1
		  for i=0  to 5
		    dist = p.distance(Points(i).bpt,Points((i+1) mod 6).bpt)
		    if dist <= distmin and dist <  delta and  p.between(Points(i).bpt,Points((i+1) mod 6).bpt) then
		      distmin = dist
		      imin = i
		    end if
		  next
		  
		  'Problème avec cube quand imin > 6 en effet, les points > 6 n'existent pas mais ces imin représentent les segments reliant le point(6)
		  
		  for i = 0 to 2
		    if mode=0 or mode = 2  then
		      q = Points(2*i+1).bpt
		    else
		      q=Points(2*i).bpt
		    end if
		    dist = p.distance(Points(6).bpt,q)
		    if dist <= distmin and dist <  delta and  p.between(Points(6).bpt,q) then
		      distmin = dist
		      imin = i+6
		    end if
		  next
		  
		  if mode = 2 then
		    for i = 0 to 2
		      q=Points(2*i).bpt
		      dist = p.distance(Points(7).bpt,q)
		      if dist <= distmin and dist <  delta and  p.between(Points(7).bpt,q) then
		        distmin = dist
		        imin = i+9
		      end if
		    next
		  end if
		  
		  // Si mode = 0 ou 2 :  imin = 6: coté [6, 1], imin = 7 coté [6, 3] imin = 8 cote [6, 5]
		  // Si mode = 1:    imin = 6: coté [6, 0], imin = 7 coté [6, 2] imin = 8 cote [6, 4]
		  //Si mode = 2:    imin = 9: coté [7, 0], imin = 8 coté [7, 2] imin = 8 cote [7, 4]
		  return imin
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PossibleAttractionWith(other as Shape) As Boolean
		  dim i, j as integer
		  dim magdist as double
		  
		  magdist = can.MagneticDist
		  
		  if not other isa cube then
		    return false
		  end if
		  
		  for i = 0 to npts-1
		    for j = 0 to other.npts-1
		      if points(i).bpt.distance(other.points(j).bpt) < magdist then
		        return true
		      end if
		    next
		  next
		  
		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos as TextOutputStream)
		  dim s as string
		  dim i as integer
		  
		  s = "[ "
		  for i = 0 to 5
		    s = s+ " " + Points(i).etiquet+ " "
		  next
		  s = s+"]"
		  
		  
		  if fill > 49 then
		    tos.writeline s+" polygonerempli"
		  else
		    tos.writeline s+ " polygone"
		  end if
		  
		  select case forme
		  case 0, 2
		    s = "[  "+ Points(6).etiquet + " " + Points(1).etiquet + " ]"
		    tos.writeline s+ " segment"
		    s = "[  "+ Points(6).etiquet + " " + Points(3).etiquet + " ]"
		    tos.writeline s+ " segment"
		    s = "[  "+ Points(6).etiquet + " " + Points(5).etiquet + " ]"
		    tos.writeline s+ " segment"
		  case 1
		    s = "[  "+ Points(6).etiquet + " " + Points(0).etiquet + " ]"
		    tos.writeline s+ " segment"
		    s = "[  "+ Points(6).etiquet + " " + Points(2).etiquet + " ]"
		    tos.writeline s+ " segment"
		    s = "[  "+ Points(6).etiquet + " " + Points(4).etiquet + " ]"
		    tos.writeline s+ " segment"
		  end select
		  
		  if forme = 2  then
		    tos.writeline "traittirete"
		    s = "[  "+ Points(7).etiquet+ " " + Points(0).etiquet + " ]"
		    tos.writeline s+ " segment"
		    s = "[  "+ Points(7).etiquet+ " " + Points(2).etiquet + " ]"
		    tos.writeline s+ " segment"
		    s = "[  "+ Points(7).etiquet + " " + Points(4).etiquet + " ]"
		    tos.writeline s+ " segment"
		    tos.writeline "traitplein"
		  end if
		  
		  if not nonpointed then
		    for i = 0 to ubound(childs)
		      childs(i).ToEps(tos)
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updateskull()
		  dim i as integer
		  dim cs as curveshape
		  csk.updatesize(can.scaling)
		  for i=0 to 6
		    if i=0 then
		      csk.ref =can.transform(Points(0).bpt)
		      if forme = 1 and not rod  then
		        cs = curveshape(csk.item(1))
		        cs.X2 = 0
		        cs.Y2 = 0
		      end if
		    else
		      
		    end
		  next
		  
		  if npts = 8 and i = 7 then
		    UpdateSkull(i,can.dtransform(Points(7).bpt-Points(0).bpt))
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateSkull(n as integer, p as BasicPoint)
		  if rod then 
		    cubeskull(csk).updatesommet(n,p,0)
		  else
		    cubeskull(csk).updatesommet(n,p,forme)
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
		csk As Cubeskull
	#tag EndProperty

	#tag Property, Flags = &h0
		mode As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		np As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		rod As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		tr As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ArcAngle"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Attracting"
			Group="Behavior"
			InitialValue="True"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="auto"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Borderwidth"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsw"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="deleted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapori"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fam"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="file"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="forme"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Highlighted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="id"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IDGroupe"
			Group="Behavior"
			InitialValue="-1"
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
			Name="IndexConstructedPoint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Invalid"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsInConstruction"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="labupdated"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Liberte"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="mode"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Modified"
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="narcs"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncpts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nonpointed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotPossibleCut"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="np"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="npts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ori"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="plan"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="rod"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="selected"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="signaire"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="std"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="stdsize"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tobereconstructed"
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
			Name="tr"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TracePt"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tsp"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="unmodifiable"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Validating"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
