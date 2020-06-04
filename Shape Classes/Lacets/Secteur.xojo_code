#tag Class
Protected Class Secteur
Inherits DSect
	#tag Method, Flags = &h0
		Sub ComputeArcAngle()
		  
		  if not drapori then
		    computeori
		  end if
		  if   abs(arcangle)  >  0.2 and ori <> 0 then
		    drapori = true  //on ne peut plus changer l'orientation
		  end if
		  arcangle = computeangle(points(2).bpt)
		  
		  'arcangle a toujours meme signe que l'orientation
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Computeextre()
		  dim p0,p1,p2 as basicPoint
		  dim D1 as BiBPoint
		  dim mi, ma as double
		  
		  
		  p0 = coord.tab(0)
		  p1 = coord.tab(1)
		  p2 =coord.tab(2)
		  
		  if p1.distance(p2) > epsilon  then
		    D1 = new BiBPoint(p0,p1)
		    D1.Interscreen(mi,ma)
		    p1 = D1.BptOnBiBpt(ma+1)
		    D1 = new BiBPoint(p0,p2)
		    D1.Interscreen(mi,ma)
		    p2 = D1.BptOnBiBpt(ma+1)
		  end if
		  
		  skullcoord = new TriBPoint(TriBPoint(coord))
		  skullcoord.tab(1) = p1
		  skullcoord.tab(2) = p2
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, p as BasicPoint)
		  super.constructor(ol,p)
		  auto = 2
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(obl as objectslist, s as secteur, p as basicpoint)
		  dim M as Matrix
		  
		  
		  super.constructor(obl,s)
		  ncpts = 3
		  
		  M = new TranslationMatrix(p)
		  createskull(can.transform(s.Points(0).bpt))
		  computeextre
		  Move(M)
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, Temp as XMLElement)
		  super.Constructor(ol,Temp)
		  ncpts = 3
		  createskull(can.transform(Points(0).bpt))
		  computeextre
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub createskull(p as BasicPoint)
		  'Cfr Bande
		  nsk = new Lskull(5,p)
		  nsk.skullof = self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecoord(p as BasicPoint, n as integer)
		  dim i as integer
		  for i = n to 2
		    Points(i).moveto(p)
		  next
		  
		  select case n
		  case 0
		    arcangle = 0
		    coord.centres(1) = p
		    Lskull(nsk).item(0).border = 100
		  case 1
		    computeori
		    startangle = coord.startangle  
		    for i = 1 to 3
		      Lskull(nsk).item(i).border = 100  
		    next
		  case 2
		    Lskull(nsk).item(4).border = 100
		  end select
		  constructshape
		  updatecoord
		  computeextre
		  coord.CreateExtreAndCtrlPoints(ori)
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecouleurtrait(c as couleur, b as integer)
		  dim i as integer
		  
		  Bordercolor = c
		  Border = b
		  
		  redim colcotes(2)
		  for i = 0 to 2
		    colcotes(i) = c
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fixecouleurtrait(i as integer, c as couleur)
		  
		  
		  if i <> 1 then
		    colcotes(i) = c
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBibSide(i as integer) As BiBPoint
		  dim Bib as BiBPoint
		  
		  if i = 0 then
		    i = 1
		  end if
		  
		  BiB = new BiBPoint(coord.tab(0), coord.tab(i) )
		  BiB.nextre = 1
		  return BiB
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGravityCenter() As BasicPoint
		  dim g as BasicPoint
		  
		  g = coord.tab(0)+coord.tab(1)+coord.tab(2)
		  return g/3
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSide(i as integer) As Droite
		  dim d as droite
		  
		  if i = 0 then
		    d = new Droite(Points(0),Points(1))
		  elseif i = 1 or i = 2 then
		    
		    d = new Droite(Points(0),Points(2))
		  else 
		    d = nil
		  end if
		  if d <> nil then
		    d.nextre = 1
		  end if
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.value("Secteur")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Initcolcotes()
		  dim i as integer
		  redim colcotes(2)
		  for i = 0 to 2
		    colcotes(i) = Config.bordercolor
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function oldcomputeangle(q as Basicpoint) As double
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
		Sub oldcomputeori()
		  ori = coord.orientation
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub oldConstructor(S as Secteur, M as Matrix)
		  Super.Constructor(S,M)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub oldEndConstruction()
		  drapori = true
		  super.endconstruction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function oldGetEndangle() As double
		  dim q as BasicPoint
		  
		  q = Points(2).bpt-Points(0).bpt
		  return q.anglepolaire
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function oldGetStartangle() As double
		  
		  dim q as BasicPoint
		  
		  q = Points(1).bpt-Points(0).bpt
		  return q.anglepolaire
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function oldInside(p as BasicPoint) As Boolean
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
		Sub oldMove(M as Matrix)
		  super.Move(M)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub oldUpdateangles()
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
		Function oldXMLPutInContainer(Doc as XMLDocument) As XMLElement
		  dim Form, Temp as XMLElement
		  dim i, n as integer
		  dim col as couleur
		  
		  Form = XMLPutIdInContainer(Doc)
		  
		  if fig <> nil and not self isa repere then
		    Form.SetAttribute("FigId",str(fig.idfig))
		  end if
		  
		  for i = 0 to labs.count-1
		    form.appendchild labs.item(i).toXML(Doc)
		  next
		  
		  Form.AppendChild  XMLPutChildsInContainer(Doc)
		  
		  if  NbPtsConsted > 0 then
		    Form.appendchild XMLPutPtsConstedInContainer(Doc)
		  end if
		  
		  if constructedby <> nil then
		    form.appendchild XMLPutConstructionInfoInContainer(Doc)
		  end if
		  
		  if not currentcontent.macrocreation then
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
		Function Paste(Obl as objectslist, p as basicpoint) As Secteur
		  dim s as Secteur
		  dim a, b as Point
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
		Function PointMagnetism2(bp as BasicPoint) As basicpoint
		  dim i as integer
		  
		  i = pointonside(bp)
		  
		  if i <> -1 then
		    if i = 0 then 
		      return   bp.projection(points(0).bpt, points(1).bpt)
		    else
		      return   bp.projection(points(0).bpt, points(2).bpt)
		    end if
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As integer
		  dim  imin as integer
		  dim distmin, dist as double
		  
		  if p.audela(points(0).bpt, points(1).bpt) and p.audela(points(0).bpt, points(2).bpt) then
		    distmin = p.distance(Points(0).bpt,Points(1).bpt)
		    imin = 0
		    dist = p.distance(Points(0).bpt,Points(2).bpt)
		    if dist < distmin then
		      distmin = dist
		      imin = 2
		    end if
		    if distmin < can.MagneticDist  then
		      return imin
		    else
		      return -1
		    end if
		  else
		    return -1
		  end if
		  
		  
		  
		  //PointOnSide retourne 0 ou 2 (ou -1)
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos as TextOutputstream)
		  dim i as integer
		  
		  if not hidden then
		    tos.writeline ( "[ "+Points(0).etiquet+" "+Points(1).etiquet+ " ]  demidroite" )
		    tos.writeline (  "[ "+Points(0).etiquet+" "+Points(2).etiquet+ " ]   demidroite" )
		  end if
		  
		  for i = 0 to ubound(childs)
		    childs(i).toeps(tos)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateShape()
		  dim i,j as integer
		  dim s,t as shape
		  dim b as Boolean
		  
		  
		  Shape.UpdateShape
		  'oldupdateangles
		  computeextre
		  
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
		skullcoord As Tribpoint
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="arcangle"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="area"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Attracting"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="auto"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Biface"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Borderwidth"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsw"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="deleted"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapori"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="endangle"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="fam"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fleche"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="forme"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Highlighted"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="id"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IDGroupe"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
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
			Name="IndexConstructedPoint"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Invalid"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsInConstruction"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="labupdated"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
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
			Name="Liberte"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Modified"
			Visible=false
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
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
			Name="narcs"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncpts"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="npts"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ori"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="plan"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Pointe"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="radius"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="selected"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="signaire"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="startangle"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="std"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
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
			Name="tobereconstructed"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="TracePt"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="tsp"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="unmodifiable"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Validating"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
