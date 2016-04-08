#tag Class
Protected Class StandardPolygon
Inherits Polyqcq
	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, fam as integer, form as integer, p as BasicPoint)
		  dim i as integer
		  
		  super.constructor(ol,1,p)
		  objects = ol
		  file = Config.stdfile
		  self.fam = fam
		  self.forme = form
		  Myspecs = wnd.GetStdSpecs(fam-10,Forme)
		  npts = Ubound(Myspecs.angles)+2
		  for i=0 to npts-2
		    Angles.Append Myspecs.Angles(i)
		    Distances.Append Myspecs.Distances(i)
		  next
		  stdsize = Config.stdsize
		  sk = new Figskull(p,npts)
		  //sk = new Figskull(Myspecs)
		  for i=0 to npts-1
		    figskull(sk).getcote(i).order = 0
		  next
		  ori = 1
		  redim colcotes(npts-1)
		  redim prol(npts-1)
		  Fixecouleurtrait(Config.bordercolor,Config.Border)
		  Fixecouleurfond(Myspecs.Coul,100)
		  If MySpecs.NonPointed = 1 then
		    nonpointed = true
		  end if
		  std = true
		  autos
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Obl as ObjectsList, other as StandardPolygon, p As BasicPoint)
		  dim i as integer
		  
		  super.constructor(obl, other, p)
		  ncpts = 1
		  file = other.file
		  updateskull
		  MySpecs=other.MySpecs
		  stdsize=other.getStdsize
		  nonpointed = other.nonpointed
		  for i = 0 to npts-2
		    Angles.append other.Angles(i)
		  next
		  autos
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as ObjectsList, El as XMLElement)
		  dim i as integer
		  dim p as basicpoint
		  
		  Super.Constructor(ol, EL)
		  stdsize=Val(EL.GetAttribute("Taille"))
		  Ori = val(EL.GetAttribute("Ori"))
		  nonpointed = (val(EL.GetAttribute("NonPointed")) = 1)
		  redim Angles(npts-2)
		  if fam < 14 then
		    file = Config.stdfile
		    Myspecs = wnd.GetStdSpecs(fam-10,Forme)
		    for i=0 to npts-2
		      Angles(i) =  Myspecs.Angles(i)
		      Distances.Append Myspecs.Distances(i)
		    next
		  end if
		  p = coord.tab(1) - coord.tab(0) 'Points(1).bpt-Points(0).bpt
		  Angles(0)= p.anglepolaire
		  sk = new Figskull(points(0).bpt,npts)
		  for i=0 to npts-1
		    figskull(sk).getcote(i).order = 0
		  next
		  redim coord.curved(npts-1)
		  redim prol(npts-1)
		  std = true
		  autos
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape()
		  dim q as BasicPoint
		  dim i as integer
		  dim sc as double
		  dim cap as double
		  
		  sc = wnd.mycanvas1.scaling
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
		  UpdateSkull
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSpecs() As StdPolygonSpecifications
		  return MySpecs
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
		Sub InverserOri()
		  dim n, m as integer
		  dim bp as BasicPoint
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
		Function Paste(Obl as ObjectsList, p as BasicPoint) As shape
		  dim s as shape
		  s = new StandardPolygon(Obl,self,p)
		  Obl.addshape(s)
		  return s
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
		  if fam < 14 then
		    Form.SetAttribute("Angle",str(Angles(0)))
		  end if
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