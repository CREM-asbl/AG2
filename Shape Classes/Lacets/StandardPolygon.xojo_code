#tag Class
Protected Class StandardPolygon
Inherits Polygon
	#tag CompatibilityFlags = ( TargetDesktop and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList)
		  
		  Shape.Constructor(ol)
		  fam = 0
		  forme = 0
		  npts = 0
		  ncpts = 0
		  std = true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, fam as integer, form as integer, p as BasicPoint)
		  dim i as integer
		  dim specs as StdPolygonSpecifications
		  
		  shape.constructor(ol)
		  std = true
		  file = Config.stdfile
		  self.fam = fam
		  self.forme = form
		  ncpts = 1
		  if fam < 14 then 'fam = 14 pour la fusion de deux stdpolyg		    
		    specs = config.StdFamilies(fam-10,Forme)
		    npts = Ubound(specs.angles)+2
		    for i=0 to npts-2
		      Angles.Append specs.Angles(i)
		      Distances.Append specs.Distances(i)
		    next
		    If Specs.NonPointed = 1 then
		      pointe = false
		    end if
		    stdsize = config.stdsize
		    Fixecouleurfond(new Couleur(config.stdcolor(fam - 10).col), 100)
		  else 
		    points(0).moveto p
		    angles.append 0
		    nsk = new LSkull(1,p)
		    nsk.skullof = self
		  end if
		  
		  redim colcotes(npts-1)
		  redim prol(npts-1)
		  ori = 1
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Obl as ObjectsList, other as StandardPolygon, p As BasicPoint)
		  Dim i As Integer
		  
		  Polygon.constructor(obl, other, p)
		  std = true
		  ncpts = 1
		  file = other.file
		  stdsize=other.getStdsize
		  copierparams(other)
		  autos
		  redim angles(other.npts-2)
		  redim distances(other.npts-2)
		  for i = 0 to other.npts-2
		    angles(i) = other.angles(i)
		    distances(i) = other.distances(i)
		  next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, El as XMLElement)
		  dim i as integer
		  dim p as basicpoint
		  dim specs as StdPolygonSpecifications
		  
		  Super.Constructor(ol, EL)
		  stdsize = Val(EL.GetAttribute("Taille"))
		  Ori = val(EL.GetAttribute("Ori"))
		  pointe = (val(EL.GetAttribute("NonPointed")) = 0)
		  if self isa cube then
		    return
		  end  if
		  redim Angles(npts-2)
		  if fam < 14 then
		    file = EL.GetAttribute("StdFile")
		    if (file <> Config.stdfile) then
		      return
		    end if
		    specs = config.StdFamilies(fam-10,Forme)
		    for i=0 to npts-2
		      Angles(i) = specs.Angles(i)
		      Distances.Append specs.Distances(i)
		    next
		  end if
		  
		  
		  p = coord.tab(1) - coord.tab(0) 
		  Angles(0)= p.anglepolaire
		  std = true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape()
		  dim q as BasicPoint
		  dim i as integer
		  dim cap as double
		  dim specs as StdPolygonSpecifications
		  
		  if fam < 14 then
		    specs = config.StdFamilies(fam-10,Forme)
		  else
		    specs = createspecs
		  end if
		  if ubound(angles) = -1 then
		    for i=0 to npts-2
		      Angles.Append specs.Angles(i)
		      Distances.Append specs.Distances(i)
		    next
		  end if
		  
		  coord.tab(0) = points(0).bpt
		  cap = angles(0)
		  for i = 1 to npts-1
		    q = new BasicPoint(cos(cap),sin(cap))
		    coord.tab(i) = coord.tab(i-1) + q*distances(i-1)*stdsize
		    if i < npts-1 then
		      cap = cap + ori*angles(i)
		    end if
		  next
		  repositionnerpoints
		  if nsk = nil then
		    createskull(coord.tab(0))
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Fusionner(Fus2 as Lacet, start1 as integer, start2 as integer, dir as integer) As Polygon
		  dim specs as StdPolygonSpecifications
		  dim Fus as StandardPolygon
		  dim i, j as integer
		  dim dr1, dr2 as BiBPoint
		  dim segments1(), segments2() As BiBPoint
		  dim pts() As BasicPoint
		  
		  for i = 0 to npts-1
		    segments1.Add(getBiBside(i))
		  next
		  
		  for i = 0 to Fus2.npts-1
		    segments2.Add(Fus2.getBiBside(i))
		  next
		  
		  
		  for i = segments1.LastIndex downto 0
		    dr1 = segments1(i)
		    for j = segments2.LastIndex downto 0
		      dr2 = segments2(j)
		      if dr1.sufficientlynear(dr2) then
		        segments1.RemoveAt(i)
		        segments2.RemoveAt(j)
		      elseif dr1.sufficientlynear(dr2.returned) then
		        segments1.RemoveAt(i)
		        segments2.RemoveAt(j)                    
		      end if
		    next
		  next
		  
		  for i = 0 to segments2.LastIndex
		    segments1.Add segments2(i)
		  next 
		  
		  pts.add(segments1(0).First)
		  pts.add(segments1(0).Second)
		  segments1.RemoveAt(0)
		  i = 0 
		  
		  do
		    dim pt as BasicPoint
		    pt = pts(pts.LastIndex)
		    if Segments1(i).First.isSameAs(pt) then
		      pts.add(segments1(i).second)
		      segments1.RemoveAt(i)
		      i = 0
		    elseif Segments1(i).Second.isSameAs(pt) then
		      pts.add(segments1(i).First)
		      segments1.RemoveAt(i)
		      i = 0 
		    else
		      i = i + 1
		    end if
		  loop until segments1.count = 1 or i = segments1.count
		  
		  
		  Fus = new StandardPolygon(Objects, 14, pts.count, pts(0))
		  Fus.npts = 1
		  
		  for i = 1 to pts.LastIndex 
		    Fus.AddPoint pts(i)
		  next
		  
		  Fus.coord = new nBPoint(Fus)
		  specs = fus.createspecs
		  
		  redim Fus.Angles(Fus.npts-2)
		  redim Fus.Distances(Fus.npts-2)
		  for i = 0 to Fus.npts-2
		    Fus.Angles(i) = specs.Angles(i)
		    Fus.Distances(i) = specs.Distances(i)
		  next
		  
		  Fus.std = true
		  Fus.file = ""
		  Fus.stdsize = 1
		  Fus.Fam = 14
		  return Fus
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getStdsize() As double
		  return stdsize
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  
		  return Dico.value("PolygStd")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitConstruction()
		  super.initconstruction
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InverserOri()
		  dim n, m as integer
		  dim p as point
		  
		  n = 1
		  m = npts-1
		  
		  while n < m
		    p = points(n)
		    points(n) = points(m)
		    points(m) = p
		    p = childs(n)
		    childs(n) = childs(m)
		    childs(m)=p
		    n = n+1
		    m = m-1
		  wend
		  ori = -ori
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as ObjectsList, p as BasicPoint) As StandardPolygon
		  dim s as new StandardPolygon(Obl,self,p)
		  Obl.addshape(s)
		  
		  var M as Translationmatrix = new Translationmatrix(p-points(0).bpt)
		  s.Move(M)
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PossibleFusionWith(S as Lacet, byref i0 as integer, byref j0 as integer, byref dir as integer) As boolean
		  dim i, j, k as integer
		  dim delta as double
		  dim dr1, dr2 as BiBPoint
		  
		  'Rappel: les polygones standard sont toujours orientés positivement (InverserOri est appliqué en cas de retournement)
		  'Néanmoins les deux cas dir = 1 et dir = -1 peuvent se présenter
		  
		  for i = 0 to npts-1
		    dr1 = getBiBside(i)
		    for j = 0 to S.npts-1
		      dr2 = s.getBiBside(j)
		      if dr1.sufficientlynear(dr2) then
		        i0 = i
		        j0 = j
		        dir = 1
		        return true
		      elseif dr1.sufficientlynear(dr2.returned) then
		        i0 = i
		        j0 = j
		        dir = -1
		        return true               
		      end if
		    next
		  next
		  
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateangle()
		  dim q as BasicPoint
		  
		  q = points(1).bpt-points(0).bpt
		  angles(0) = q.anglepolaire
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  dim Form As XMLElement
		  
		  Form = Shape.XMLPutInContainer(Doc)
		  Form.SetAttribute("StdFile",  file)
		  Form.SetAttribute("Taille", str(stdsize))
		  Form.SetAttribute("Angle",str(Angles(0)))
		  Form.SetAttribute("Ori",str(Ori))
		  
		  return form
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
		angles(-1) As double
	#tag EndProperty

	#tag Property, Flags = &h0
		distances(-1) As double
	#tag EndProperty

	#tag Property, Flags = &h0
		file As string
	#tag EndProperty

	#tag Property, Flags = &h0
		MySpecs As StdPolygonSpecifications
	#tag EndProperty

	#tag Property, Flags = &h0
		stdsize As double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="paraperp"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ArcAngle"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
			Name="fam"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="file"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
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
			InitialValue="0"
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
			Name="std"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="stdsize"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
