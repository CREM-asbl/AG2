#tag Class
Protected Class HybridShape
Inherits Polyqcq
	#tag Method, Flags = &h0
		Sub HybridShape(ol as Objectslist, P as BasicPoint)
		  dim i as integer
		  dim  idem as Boolean
		  
		  Shape (ol)
		  Points(0).MoveTo(p)
		  fam = 7
		  forme = 0
		  npts = 1
		  ncpts = 1
		  
		  sk = new figSkull(wnd.mycanvas1.transform(p))
		  figskull(Sk).addpoint(new BasicPoint(0,0))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddPoint(p as BasicPoint)
		  dim  i,j as integer
		  
		  Points.append new Point(objects,p)
		  SetPoint(Points(npts))
		  figskull(sk).addpoint(wnd.mycanvas1.dtransform(p-Points(0).bpt))
		  npts = npts+1
		  ncpts = ncpts+1
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  return Dico.Value("Compo")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function subdiv(n as integer, i as integer) As basicpoint
		  dim a as double
		  
		  a = StartAngle+(i/n)*(ArcAngle)
		  return  Support + new BasicPoint(rayon*cos(a), rayon*sin(a))
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub oldUpDateSkull(n as integer, p as Basicpoint)
		  figskull(sk).updatesommet(n,p)
		  
		  if n = npts-1  then
		    UpdateArc
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as Objectslist, p as Basicpoint) As shape
		  dim s as HybridShape
		  s = new HybridShape(Obl,self,p)
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateArc()
		  dim  j as integer
		  dim div as BasicPoint
		  dim  an, da as double
		  
		  calculangles
		  for j=1 to PrecisionCurve-1
		    div = subdiv(PrecisionCurve,j)
		    figskull(sk).UpdateSommet(npts-1+j,wnd.mycanvas1.dtransform(div-points(0).bpt))      //points(0).bpt sert de point de référence au skull
		  next
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HybridShape(ol as objectslist, s as HybridShape, q as BasicPoint)
		  dim i as integer
		  dim P As Point
		  dim M as Matrix
		  
		  HybridShape(Ol,s.Points(0).bpt)
		  
		  Ori = s.Ori
		  
		  M = new TranslationMatrix(q)
		  
		  support =  new basicpoint(s.support)
		  
		  
		  
		  for i = 1 to s.npts-1
		    AddPoint (s.Points(i).bpt)
		  next
		  AddCurve(s.Support)
		  
		  Transform(M)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveSupport(M as Matrix)
		  Support = M*Support
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function pInShape(p as BasicPoint) As Boolean
		  'dim ptx(),pty() as double
		  dim i,j as integer
		  dim c as Boolean
		  dim div as BasicPoint
		  dim Bord as nBPoint
		  
		  Bord = new nBPoint
		  
		  for i = 0 to npts-1
		    Bord.append Points(i).bpt
		  next
		  
		  for j=1 to PrecisionCurve-1
		    div = subdiv(PrecisionCurve,j)
		    Bord.append div
		  next
		  
		  return Bord.pInShape(p)
		  
		  'i=0
		  'j=Ubound(ptx)
		  'c=false
		  'for  i = 0  to Ubound(ptx)
		  'if ((((pty(i)<=p.y) and (p.y <pty(j))) or ((pty(j) <= p.y) and (p.y < pty(i)))) and (p.x < (ptx(j) - ptx(i)) * (p.y - pty(i)) / (pty(j) - pty(i)) + ptx(i))) then
		  'c =not c
		  'end if
		  'j=i
		  'next
		  '
		  'return c
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NormaliseAngle(angle as double) As double
		  if Ori >0 then
		    while  angle <0
		      angle = angle +2*PI
		    wend
		    while angle > 2*PI
		      angle = angle-2*PI
		    wend
		  else
		    while angle >0
		      angle = angle-2*PI
		    wend
		    while angle < -2*PI
		      angle = angle+2*PI
		    wend
		  end if
		  return angle
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInfosArcs(Doc as XMLDocument) As XMLELement
		  dim  Form, EL as XMLElement
		  dim i as integer
		  
		  
		  Form = Doc.CreateElement("InfosArcs")
		  
		  Form.appendchild EL
		  EL = Doc.CreateElement("Supports")
		  EL.SetAttribute("CoordX",str(Support.x))
		  EL.SetAttribute("CoordY",str(Support.y))
		  Form.appendchild EL
		  
		  
		  Return Form
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointOnSide(p as BasicPoint) As integer
		  dim i, n as integer
		  dim delta, cx, cy as double
		  dim q, q1 as BasicPoint
		  dim startangle, endangle, angle As double
		  dim t as Boolean
		  
		  delta = wnd.Mycanvas1.MagneticDist
		  for i = 0 to npts -1
		    if  (p.distance(Points(i).bpt,Points((i+1) mod npts).bpt ) <= delta) and p.between(Points(i).bpt,Points((i+1) mod npts).bpt )    then
		      return i
		    end if
		  next
		  
		  q= Support
		  cx=p.Distance(q)
		  if abs(cx-rayon)<= delta then
		    p = p-q
		    angle = p.anglepolaire -startangle
		    angle = normaliseangle(angle)
		    if ori >0 then
		      t = ( angle < arcangle)
		    else
		      t = (angle > arcangle)
		    end if
		    if t then
		      return npts-1
		    end if
		  end if
		  
		  return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddCurve(C as BasicPoint)
		  dim j as integer
		  dim div as BasicPoint
		  
		  support = C
		  
		  CalculAngles
		  rayon = GetRadius
		  
		  for j=1 to PrecisionCurve-1
		    'div = subdiv(PrecisionCurve,j)                                                  'C + new BasicPoint(rayon*cos(an), rayon*sin(an))
		    figskull(sk).addpoint new basicpoint(0,0)                               '(wnd.mycanvas1.transform(div))
		  next
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBoundingRadius() As double
		  dim br As Double
		  dim i as integer
		  dim q as basicpoint
		  
		  q=GetGravitycenter
		  
		  Br = Super.GetBoundingRadius
		  
		  Br = max(Br,q.Distance(Support)+GetRadius)
		  
		  
		  return Br
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Hybridshape(ol as ObjectsList, Temp as XMLElement)
		  dim List as XMLNodeList
		  dim EL as XMLElement
		  dim i as integer
		  
		  
		  Shape(ol,Temp)
		  'IndexOnSkull.Append 0
		  sk = new Figskull(wnd.mycanvas1.transform(Points(0).bpt),npts)
		  'for i=1 to npts-1
		  'IndexOnSkull.Append i
		  'next
		  
		  List = Temp.Xql("InfosArcs")
		  if List.length > 0 then
		    EL = XmlElement(List.Item(0))
		    for i=1 to EL.ChildCount-1
		      AddCurve(new BasicPoint(val(EL.Child(i).getAttribute("CoordX")),val(EL.Child(i).getAttribute("CoordY"))))
		    next
		  end if
		  EndConstruction
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveCurve(n as integer)
		  'dim i as integer
		  '
		  'n = NumArc(n)
		  '
		  'if n <> - 1 then
		  'for i=1 to PrecisionCurve-1
		  'figskull(sk).removepoint()
		  'next
		  'PtArcs.Remove(n)
		  'Supports.Remove(n)
		  'end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRadius() As double
		  return Support.Distance(Points(npts-1).bpt)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Move(M as Matrix)
		  dim i as integer
		  
		  for i = 0 to Ubound(Childs)
		    Childs(i). Move(M)
		  next
		  MoveSupport(M)
		  EndMove
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertPoint(index as integer, P as Point)
		  'dim i as integer
		  '
		  'super.InsertPoint(index,P)
		  '
		  'i = IndexOnSkull(UBound(IndexOnSkull))
		  'IndexOnSkull.append i+1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndMove()
		  'updatecoord
		  Updateskull          //repositionne les sommets du skull
		  updatearc             // recalcule l'arc
		  updatelab
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToEPS(tos as textoutputStream)
		  dim Source as Shape
		  dim M as Matrix
		  dim i as integer
		  dim s as string
		  dim r as double
		  
		  Source = ConstructedBy.shape
		  
		  if source isa circle and not hidden then
		    
		    r = support.distance(points(0).bpt)
		    
		    s = "[ "
		    for i = 0 to npts-2
		      s = s+ " " + Points(i).etiq+ " "
		    next
		    s = s + " [ [ " + points(npts-1).etiq + " [ "  + str(support.x) + " " + str(support.y) + " ] " + points(0). etiq + " ] " + str(ori*r) + " ] arcsecteur "
		    
		    s = s+"]"
		    
		    if fill > 49 then
		      tos.writeline  s + " lacetrempli "
		    else
		      tos.writeline s + "lacet"
		    end if
		    
		    s = "[ "
		    for i = 0 to npts-1
		      s = s+ " " + Points(i).etiq+ " "
		    next
		    s = s + " ] "
		    tos.writeline s + " suitepoints "
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetGravitycenter() As basicpoint
		  dim i,j,num as integer
		  dim p as basicpoint
		  
		  
		  p = new basicpoint(0,0)
		  if npts > 0 then
		    for i = 0 to  npts-1
		      p = p+Points(i).bpt
		      num = num +1
		    next
		    for j=1 to PrecisionCurve-1
		      p = p + subdiv(PrecisionCurve,j)
		      num = num +1
		    next
		    return p/num
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub update()
		  dim circ as shape
		  dim M as Matrix
		  
		  rayon = getradius
		  
		  circ = constructedby.shape
		  select case constructedby.oper
		  case 3, 5
		    M = Matrix(constructedby.data(0))
		  case 6
		    M = Transformation(constructedby.data(0)).M
		  end select
		  
		  if circ isa hybridshape then
		    support = M*Hybridshape(circ).support
		  else
		    support =M*circ.getgravitycenter
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CalculAngles()
		  dim A, B, C as BasicPoint
		  dim angle as double
		  
		  
		  A = Points(0).bpt-support                                  'Fin arc
		  B = Points(npts-1).bpt-support                         'Début arc
		  
		  StartAngle = B.Anglepolaire
		  angle = A.Anglepolaire-B.Anglepolaire
		  Arcangle = NormaliseAngle(angle)
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

	#tag Note, Name = Avertissement
		
		Avec la version 2.3.7, j'ai supprimé tout ce qui prévoyait la présence de plusieurs arcs. 
		De cette façon l'origine du (seul) arc possible est le points n0 npts-1.
	#tag EndNote


	#tag Property, Flags = &h0
		Support As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		StartAngle As double
	#tag EndProperty

	#tag Property, Flags = &h0
		ArcAngle As double
	#tag EndProperty

	#tag Property, Flags = &h0
		rayon As double
	#tag EndProperty


	#tag Constant, Name = PrecisionCurve, Type = Double, Dynamic = False, Default = \"25", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
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
			Name="StartAngle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ArcAngle"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="rayon"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
