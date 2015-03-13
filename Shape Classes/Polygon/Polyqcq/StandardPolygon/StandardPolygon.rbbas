#tag Class
Protected Class StandardPolygon
Inherits Polyqcq
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

	#tag Method, Flags = &h0
		Sub StandardPolygon(ol as ObjectsList, El as XMLElement)
		  dim i as integer
		  dim p as basicpoint
		  
		  Shape(ol, EL)
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
		Function GetSpecs() As StdPolygonSpecifications
		  return MySpecs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StandardPolygon(Obl as ObjectsList, other as StandardPolygon, p As BasicPoint)
		  dim i as integer
		  
		  Polygon(obl, other, p)
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
		Sub StandardPolygon(ol as ObjectsList, fam as integer, form as integer, p as BasicPoint)
		  dim sc as double
		  dim i as integer
		  
		  Polygon(ol,1,p)
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
		Function Paste(Obl as ObjectsList, p as BasicPoint) As shape
		  dim s as shape
		  s = new StandardPolygon(Obl,self,p)
		  Obl.addshape(s)
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructShape()
		  dim q as BasicPoint
		  dim i as integer
		  dim cs as curveshape
		  dim sc as double
		  dim cap as double
		  
		  sc = wnd.mycanvas1.scaling
		  //for i = 1 to npts-1
		  //cs = figskull(sk).getcote(i-1)
		  //q = new basicpoint(cs.X2,cs.Y2)
		  //q = q*sc*stdsize
		  //Points(i).moveto(Points(0).bpt + wnd.mycanvas1.idtransform(q))
		  //next
		  
		  cap = angles(0)
		  for i = 1 to npts-1
		    q = new BasicPoint(cos(cap),sin(cap))
		    points(i).moveto (points(i-1).bpt + q*distances(i-1)*stdsize)
		    if i < npts-1 then
		      cap = cap + ori*angles(i)
		    end if
		  next
		  
		  UpdateSkull
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateangle()
		  dim q as BasicPoint
		  
		  q = points(1).bpt-points(0).bpt
		  angles(0) = q.anglepolaire
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
		MySpecs As StdPolygonSpecifications
	#tag EndProperty

	#tag Property, Flags = &h0
		angles(-1) As double
	#tag EndProperty

	#tag Property, Flags = &h0
		distances(-1) As double
	#tag EndProperty

	#tag Property, Flags = &h0
		stdsize As double
	#tag EndProperty

	#tag Property, Flags = &h0
		file As string
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
			Name="stdsize"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="file"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
