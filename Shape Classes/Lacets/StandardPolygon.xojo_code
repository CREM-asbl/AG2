#tag Class
Protected Class StandardPolygon
Inherits Polygon
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
		    specs = config.stdfamilies(fam-10,form)
		    'specs = wnd.GetStdSpecs(fam-10,Forme)
		    npts = Ubound(specs.angles)+2
		    for i=0 to npts-2
		      Angles.Append specs.Angles(i)
		      Distances.Append specs.Distances(i)
		    next
		    If Specs.NonPointed = 1 then
		      nonpointed = true
		    end if
		    stdsize = config.stdsize
		    Fixecouleurfond(specs.Coul,100)
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
		  dim i as integer
		  
		  Polygon.constructor(obl, other, p)
		  ncpts = 1
		  file = other.file
		  stdsize=other.getStdsize
		  nonpointed = other.nonpointed
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
		  stdsize=Val(EL.GetAttribute("Taille"))
		  Ori = val(EL.GetAttribute("Ori"))
		  nonpointed = (val(EL.GetAttribute("NonPointed")) = 1)
		  if self isa cube then
		    return
		  end  if
		  redim Angles(npts-2)
		  if fam < 14 then
		    file = Config.stdfile
		    specs = config.stdfamilies(fam-10,forme)
		    'specs = wnd.GetStdSpecs(fam-10,Forme)
		    for i=0 to npts-2
		      Angles(i) =  specs.Angles(i)
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
		    specs = config.stdfamilies(fam-10,forme)
		    'specs = wnd.GetStdSpecs(fam-10,Forme)
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
		  dim i as integer
		  
		  Fus = new StandardPolygon(Objects, 14, npts+fus2.npts-5, Points((start1+1)mod npts).bpt)
		  Fus.npts=1
		  
		  for i = 2 to npts-1
		    Fus.AddPoint Points((start1+i) mod npts).bpt
		  next
		  if  dir = -1  then
		    for  i = 1 to Fus2.npts-1
		      Fus.AddPoint Fus2.Points((start2+i) mod fus2.npts).bpt
		    next
		  elseif dir = 1 then
		    for i = 0 to Fus2.npts-2
		      Fus.AddPoint Fus2.Points((start2+Fus2.npts-i) mod Fus2.npts).bpt
		    next
		  end if
		  Fus.coord= new nBPoint(Fus)
		  specs = fus.createspecs
		  
		  redim Fus.Angles(Fus.npts-2)
		  redim Fus.Distances(Fus.npts-2)
		  for i=0 to Fus.npts-2
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
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PossibleFusionWith(S as Lacet, byref i0 as integer, byref j0 as integer, byref dir as integer) As boolean
		  dim i, j as integer
		  dim delta as double
		  dim dr1, dr2 as BiBPoint
		  
		  'Rappel: les polygones standard sont toujours orientés positivement (InverserOri est appliqué en cas de retournement)
		  'Néanmoins les deux cas dir = 1 et dir = -1 peuvent se présenter
		  
		  delta = can.MagneticDist
		  
		  for i = 0  to npts-1
		    dr1 = getBiBside(i)
		    for j = 0 to S.npts-1
		      dr2 = s.getBiBside(j)
		      if dr1.sufficientlynear(dr2) then
		        i0 = i
		        j0 = j
		        dir = 1
		        return true
		      elseif  dr1.sufficientlynear(dr2.returned) then
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
		oldMySpecs As StdPolygonSpecifications
	#tag EndProperty

	#tag Property, Flags = &h0
		stdsize As double
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
