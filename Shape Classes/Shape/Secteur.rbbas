#tag Class
Protected Class Secteur
Inherits Shape
	#tag Method, Flags = &h0
		Sub secteur(ol as objectslist, p as BasicPoint)
		  
		  shape(ol,3,3)
		  Points.append new Point(ol, p)
		  setPoint(Points(0))
		  ori = 0
		  sk = new Secteurskull(wnd.mycanvas1.transform(Points(0).bpt))
		  sk.updatefillcolor(blanc,0)
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.value("Secteur")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as BasicPoint, n as integer)
		  dim i as integer
		  dim cs as curveshape
		  
		  select case n
		  case 0
		    for i = 0 to 2
		      Points(i).moveto(p)
		    next
		    sk.update(wnd.myCanvas1.transform(p))
		  case 1
		    for i = 1 to 2
		      Points(i).moveto(p)
		    next
		  case 2
		    Points(2).moveto(p)
		    computearcangle
		  end select
		  
		  if n > 0 then
		    updateskull
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetStartangle() As double
		  
		  dim q as BasicPoint
		  
		  q = Points(1).bpt-Points(0).bpt
		  return q.anglepolaire
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetEndangle() As double
		  dim q as BasicPoint
		  
		  q = Points(2).bpt-Points(0).bpt
		  return q.anglepolaire
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Computeextre()
		  dim p0,p1,p2 as basicPoint
		  dim D1 as BiBPoint
		  dim mi, ma as double
		  
		  p0 = Points(0).bpt
		  p1 = Points(1).bpt
		  p2 = Points(2).bpt
		  
		  
		  if p1.distance(p2) < epsilon  then
		    extre(0)= p1
		    extre(1)= p2
		  else
		    D1 = new BiBPoint(p0,p1)
		    D1.Interscreen(mi,ma)
		    extre(0) = D1.BptSurBiBpt(ma+0.1)
		    D1 = new BiBPoint(p0,p2)
		    D1.Interscreen(mi,ma)
		    extre(1) = D1.BptSurBiBpt(ma+0.1)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paintside(g as graphics, cot as integer, ep as double, coul as couleur)
		  dim cs as curveshape
		  
		  cs = Secteurskull(sk).getcote(cot)
		  cs.borderwidth = ep*borderwidth
		  cs.bordercolor = coul.col
		  g.drawobject(cs, sk.ref.x, sk.ref.y)
		  cs.borderwidth = borderwidth
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as objectslist, p as basicpoint) As shape
		  dim s, a, b as shape
		  dim j as integer
		  
		  s = new Secteur(Obl,self,p)
		  
		  for j = 3 to Ubound(childs)
		    a = childs(j)
		    b = Point(a.Paste(Obl,p,s))
		  next
		  
		  
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(p as BasicPoint) As Boolean
		  return inside(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As integer
		  dim  imin as integer
		  dim distmin, dist as double
		  
		  //Pour la cohérence avec les routines d'intersection, il est préférable que les côtés d'un secteurs soient numérotés 0 et 1, plutôt que 1 et 2
		  //Autrement dit, le coté n°0 comprend les points 0 et 1, le côté n°1 comprend les points n° 0 et 2.
		  
		  distmin = p.distance(Points(0).bpt,Points(1).bpt)
		  imin = 0
		  dist = p.distance(Points(0).bpt,Points(2).bpt)
		  if dist < distmin then
		    distmin = dist
		    imin = 1
		  end if
		  if distmin < wnd.Mycanvas1.MagneticDist  then
		    return imin
		  else
		    return -1
		  end if
		  
		  //PointOnSide retourne 0 ou 1
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos as TextOutputstream)
		  dim i as integer
		  
		  if not hidden then
		    tos.writeline ( "[ "+Points(0).etiq+" "+Points(1).etiq+ " ]  demidroite" )
		    tos.writeline (  "[ "+Points(0).etiq+" "+Points(2).etiq+ " ]   demidroite" )
		  end if
		  
		  for i = 0 to 2
		    points(i).toeps(tos)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateShape()
		  dim i,j as integer
		  dim s,t as shape
		  dim b as Boolean
		  
		  Shape.UpdateShape
		  
		  for i = 0 to Ubound(ConstructedShapes)
		    s = ConstructedShapes(i)
		    if s isa droite then
		      s.updateshape
		      for j = 0 to ubound(s.constructedshapes)
		        t = s.constructedshapes(j)
		        if t.constructedby.oper = 1 or t.constructedby.oper = 2 then
		          t.updateshape
		        end if
		      next
		    end if
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateskull()
		  dim i as integer
		  dim bp as Basicpoint
		  dim sangle as double
		  
		  bp = points(0).bpt
		  bp = wnd.myCanvas1.transform(bp)
		  
		  computeextre
		  
		  
		  for i=0 to npts-1
		    if i=0 then
		      sk.update(bp)
		    else
		      secteurskull(sk).Updatesommet(i-1,wnd.myCanvas1.dtransform(extre(i-1)-points(0).bpt))
		    end
		  next
		  
		  bp = wnd.Mycanvas1.Rep.Idx
		  sangle = bp.Anglepolaire
		  updateangles
		  secteurskull(sk).updateangles(-arcangle,-startangle+sangle)
		  secteurskull(sk).updateborderwidth(borderwidth)
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Secteur(obl as objectslist, s as secteur, p as basicpoint)
		  dim M as Matrix
		  
		  
		  Shape(obl,s)
		  ncpts = 3
		  M = new TranslationMatrix(p)
		  sk = new Secteurskull(wnd.mycanvas1.transform(s.Points(0).bpt))
		  ori = s.ori
		  computeextre
		  Move(M)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Secteur(ol as objectslist, Temp as XMLElement)
		  Shape(ol,Temp)
		  sk = new Secteurskull(wnd.mycanvas1.transform(Points(0).bpt))
		  Updateskull
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Secteur(S as Secteur, M as Matrix)
		  Shape(S,M)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSide(n as integer) As Droite
		  dim d as Droite
		  
		  // n vaut 0 ou 1
		  
		  n = n+1
		  d = new Droite(Points(0),Points(n))
		  d.nextre = 1
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FixeCouleurFond(c as couleur, f as integer)
		  fillcolor = c
		  fill = f
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  dim Form, Temp as XMLElement
		  dim i, n as integer
		  dim col as couleur
		  
		  Form = XMLPutIdInContainer(Doc)
		  
		  if fig <> nil and not self isa repere then
		    Form.SetAttribute("FigId",str(fig.idfig))
		  end if
		  
		  for i = 0 to labs.count-1
		    form.appendchild labs.element(i).toXML(Doc)
		  next
		  
		  Form.AppendChild  XMLPutChildsInContainer(Doc)
		  
		  if  NbPtsConsted > 0 then
		    Form.appendchild XMLPutPtsConstedInContainer(Doc)
		  end if
		  
		  if constructedby <> nil then
		    form.appendchild XMLPutConstructionInfoInContainer(Doc)
		  end if
		  
		  if not app.macrocreation then
		    Form.AppendChild  BorderColor.XMLPutIncontainer(Doc, Dico.Value("ToolsColorBorder"))
		    Temp = Doc.CreateElement(Dico.Value("Thickness"))
		    Temp.SetAttribute("Value", str(borderwidth))
		    Form.AppendChild Temp
		  end if
		  
		  if Hidden then
		    Form.AppendChild(Doc.CreateElement(Dico.Value("Hidden")))
		  end if
		  
		  if Invalid then
		    Form.AppendChild(Doc.CreateElement(Dico.Value("Invalid")))
		  end if
		  Form.AppendChild XMLPutTsfInContainer(Doc)
		  
		  return Form
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Inside(p as BasicPoint) As Boolean
		  dim q as BasicPoint
		  dim a as double
		  
		  q = p - Points(0).bpt
		  a = q.anglepolaire
		  
		  if ori >0 then
		    if  startangle <= endangle then
		      return  startangle <= a and a <= endangle
		    else
		      return  startangle <= a or a <= endangle
		    end if
		  else
		    if  startangle >= endangle then
		      return  startangle >= a and a >= endangle
		    else
		      return startangle >= a or a >= endangle
		    end if
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ComputeArcAngle()
		  if   abs(arcangle)  >  0.2 then
		    drapori = true  //on ne peut plus changer l'orientation
		  end if
		  if not drapori then
		    ori = points(0).bpt.orientation(points(1).bpt,points(2).bpt)
		  end if
		  
		  arcangle = computeangle(points(2).bpt)
		  
		  'arcangle a toujours meme signe que l'orientation
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function computeangle(q as Basicpoint) As double
		  dim e, a as double
		  
		  q = q-points(0).bpt
		  e = q.anglepolaire
		  a = e - startangle
		  
		  if ori >0 then
		    if a < 0 then
		      a = a + 2*PI
		    end if
		  elseif ori <0 then
		    if a >0 then
		      a = a -2*PI
		    end if
		  end if
		  
		  return a
		  'a a toujours meme signe que ori
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Updateangles()
		  dim q as basicpoint
		  
		  q = Points(1).bpt - Points(0).bpt
		  startangle = q.anglepolaire
		  q = Points(2).bpt - Points(0).bpt
		  endangle = q.anglepolaire
		  computearcangle
		  
		  // startangle et endangle  sont toujours entre 0 et 2 pi
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Move(M as Matrix)
		  super.Move(M)
		  updateskull
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as Graphics)
		  dim op as operation
		  dim i, n as integer
		  
		  computeextre
		  updateskull
		  n = -1
		  op =CurrentContent.currentoperation
		  
		  if op <> nil and op.nobj > 0 and op.visible.element(op.iobj) = self then
		    if op isa transfoconstruction or op isa  paraperpconstruction then
		      n = op.index(op.iobj)
		    end if
		  end if
		  
		  if highlighted and n > -1  then
		    for i = 0 to 1
		      if i <> n then
		        paintside (g, i, 1, bordercolor)
		      else
		        paintside (g, n, 2, Config.highlightcolor)
		      end if
		    next
		  else
		    super.paint(g)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBibSide(i as integer) As BiBPoint
		  dim j as integer
		  
		  if i =0 then
		    j = 1
		  else
		    i = 0
		    j = 2
		  end if
		  
		  return new BiBPoint(coord.tab(i), coord.tab(j) )
		  
		  
		End Function
	#tag EndMethod


	#tag Note, Name = Licence
		
		Copyright © Mars 2010 CREM
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
		extre(1) As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		arcangle As double
	#tag EndProperty

	#tag Property, Flags = &h0
		startangle As double
	#tag EndProperty

	#tag Property, Flags = &h0
		endangle As double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="NotPossibleCut"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tobereconstructed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="diam"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="deleted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="plan"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="final"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="init"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="interm"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="signaire"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapori"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nonpointed"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsw"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="labupdated"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IndexConstructedPoint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsInConstruction"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TracePt"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="auto"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="unmodifiable"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncpts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Invalid"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Attracting"
			Group="Behavior"
			InitialValue="True"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Liberte"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
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
			Name="id"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="selected"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Highlighted"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="npts"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Borderwidth"
			Group="Behavior"
			InitialValue="0"
			Type="double"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="std"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ori"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fam"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="forme"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Modified"
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IDGroupe"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tsp"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			InheritedFrom="Shape"
		#tag EndViewProperty
		#tag ViewProperty
			Name="arcangle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="startangle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="endangle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
