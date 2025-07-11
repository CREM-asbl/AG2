#tag Class
Protected Class Polreg
Inherits Polygon
	#tag Method, Flags = &h0
		Function check() As Boolean
		  dim i as integer
		  dim g as BasicPoint
		  dim M as RotationMatrix
		  dim t as Boolean
		  dim p as BasicPoint
		  dim tolerance as double

		  // Tolérance plus large pour tenir compte des imprécisions lors des modifications
		  tolerance = epsilon * 10

		  if npts < 3 then
		    return true
		  end if

		  g = getgravitycenter
		  M = new RotationMatrix(g, 2*PI/Npts)

		  t = true
		  p = Points(0).bpt

		  // Vérification que tous les sommets sont équidistants du centre
		  dim rayon as double
		  rayon = g.distance(Points(0).bpt)

		  for i = 0 to npts-1
		    // Vérification de la distance au centre (régularité radiale)
		    if abs(g.distance(Points(i).bpt) - rayon) > tolerance then
		      t = false
		      exit for
		    end if
		  next

		  // Vérification de la régularité angulaire si la régularité radiale est OK
		  if t then
		    p = Points(0).bpt
		    for i = 1 to npts-1
		      p = M*p
		      if Points(i).bpt.distance(p) > tolerance then
		        t = false
		        exit for
		      end if
		    next
		  end if

		  return t
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, n as integer)

		  Shape.constructor(ol,2,n)

		  redim prol(npts-1)
		  Initcolcotes
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as objectslist, d as integer, p As BasicPoint)
		  dim i as integer

		  shape.Constructor(ol, 2,d)

		  Points.append new Point(ol, p)
		  setPoint(Points(0))
		  redim prol(npts-1)
		  Initcolcotes
		  liberte = 4
		  createskull(p)
		  ori = 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ol as Objectslist, Temp as XMLElement)
		  super.constructor(ol,Temp)
		  ncpts = 2
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub endconstruction()


		  super.endconstruction


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetBoundingRadius() As double
		  return Points(0).bpt.distance(getgravitycenter)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType() As string
		  select case npts
		  case 3
		    return Dico.Value("TriangEqui")
		  case 4
		    return Dico.Value("Carre")
		  case 5
		    Return Dico.value("PentaReg")
		  case 6
		    return Dico.Value("HexaReg")
		  case 7
		    return Dico.Value("HeptaReg")
		  case 8
		    Return Dico.value("OctoReg")
		  case 9
		    return Dico.Value("EnneaReg")
		  case 10
		    return Dico.Value("DecaReg")
		  case 11
		    Return Dico.value("UndecaReg")
		  case 12
		    return Dico.Value("DodecaReg")
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Paste(Obl as ObjectsList, p as BasicPoint) As Lacet
		  dim s as Polreg

		  s = new Polreg(Obl,self,p)
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateShape()
		  // Méthode spécialisée pour maintenir la régularité du polygone
		  // Appel de la méthode parent pour les opérations de base
		  Super.UpdateShape()

		  // Reconstruction régulière après mise à jour
		  ReconstructRegular()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReconstructRegular()
		  // Reconstruit un polygone régulier en préservant les points contraints
		  dim i as integer
		  dim centre as BasicPoint
		  dim rayon as double
		  dim angle, angleIncrement as double
		  dim premierSommet, deuxiemeSommet as BasicPoint

		  if npts < 3 then
		    return
		  end if

		  // Utiliser les deux premiers points comme référence
		  premierSommet = Points(0).bpt
		  deuxiemeSommet = Points(1).bpt

		  // Calcul des paramètres du polygone régulier
		  angleIncrement = 2 * PI / npts
		  centre = CalculateRegularCenter(premierSommet, deuxiemeSommet, angleIncrement)
		  rayon = centre.distance(premierSommet)
		  angle = atan2(premierSommet.y - centre.y, premierSommet.x - centre.x)

		  // Reconstruction des sommets non-contraints
		  for i = 2 to npts - 1
		    if not IsPointConstrained(i) then
		      dim nouveauPoint as BasicPoint
		      dim nouvelAngle as double

		      nouvelAngle = angle + i * angleIncrement
		      nouveauPoint = new BasicPoint(centre.x + rayon * cos(nouvelAngle), centre.y + rayon * sin(nouvelAngle))
		      Points(i).moveto nouveauPoint
		    end if
		  next

		  updatecoord()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CalculateRegularCenter(p1 as BasicPoint, p2 as BasicPoint, angleIncrement as double) As BasicPoint
		  // Calcule le centre d'un polygone régulier basé sur deux sommets consécutifs
		  dim distance as double
		  dim milieu as BasicPoint
		  dim direction as BasicPoint
		  dim hauteur as double
		  dim centre as BasicPoint

		  distance = p1.distance(p2)
		  milieu = new BasicPoint((p1.x + p2.x) / 2, (p1.y + p2.y) / 2)

		  // Direction perpendiculaire au segment p1-p2
		  direction = new BasicPoint(-(p2.y - p1.y), p2.x - p1.x)
		  direction = direction.normer()

		  // Calcul de la distance du centre au milieu du côté
		  hauteur = distance / (2 * tan(angleIncrement / 2))

		  centre = new BasicPoint(milieu.x + direction.x * hauteur, milieu.y + direction.y * hauteur)

		  return centre
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsPointConstrained(index as integer) As Boolean
		  // Vérifie si un point spécifique est contraint
		  dim p as Point
		  dim i as integer

		  if index < 0 or index >= npts then
		    return false
		  end if

		  p = Points(index)

		  // Points "sur" d'autres formes
		  if p.pointsur.count > 0 then
		    return true
		  end if

		  // Points construits par des opérations parallèle/perpendiculaire
		  if p.constructedby <> nil then
		    if p.constructedby.oper = 1 or p.constructedby.oper = 2 then
		      return true  // Points construits par parallèle/perpendiculaire
		    end if
		  end if

		  // Points avec liberté limitée
		  if p.liberte = 0 then
		    return true
		  end if

		  // Vérifier si le point fait partie d'un segment parallèle/perpendiculaire
		  if ubound(p.parents) >= 0 then
		    for i = 0 to ubound(p.parents)
		      dim parentShape as Shape
		      parentShape = p.parents(i)
		      if parentShape <> nil and parentShape isa droite then
		        dim dr as droite
		        dr = droite(parentShape)
		        if dr.constructedby <> nil and (dr.constructedby.oper = 1 or dr.constructedby.oper = 2) then
		          return true // Point sur un segment parallèle/perpendiculaire
		        end if
		      end if
		    next
		  end if

		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasConstrainedPoints() As Boolean
		  // Vérifie si le polygone a des points contraints (sur d'autres formes)
		  dim i as integer

		  for i = 0 to npts - 1
		    if IsPointConstrained(i) then
		      return true
		    end if
		  next

		  return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier30() As Matrix
		  // Modification spécialisée pour polygones réguliers avec 3 sommets modifiés
		  dim ep0, ep1, ep2, np0, np1, np2 as BasicPoint
		  epnp(ep0, ep1, ep2, np0, np1, np2)

		  // Utiliser une similitude directe basée sur les deux premiers points
		  dim M as SimilarityMatrix
		  M = new SimilarityMatrix(ep0, ep1, np0, np1)

		  Transform(M)
		  ReconstructRegular()

		  return M
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier31(n as integer) As Matrix
		  // Modification spécialisée quand un sommet est "sur" une autre forme
		  dim ep0, ep1, ep2, np0, np1, np2 as BasicPoint
		  epnp(ep0, ep1, ep2, np0, np1, np2)

		  dim M as SimilarityMatrix

		  // Choix de deux points fixes pour définir la similitude
		  select case n
		  case 0
		    M = new SimilarityMatrix(ep1, ep2, np1, np2)
		  case 1
		    M = new SimilarityMatrix(ep0, ep2, np0, np2)
		  case 2
		    M = new SimilarityMatrix(ep0, ep1, np0, np1)
		  end select

		  Transform(M)
		  ReconstructRegular()

		  return M
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier32(n1 as integer, n2 as integer) As Matrix
		  // Modification spécialisée quand deux sommets sont "sur" d'autres formes
		  dim ep0, ep1, ep2, np0, np1, np2 as BasicPoint
		  epnp(ep0, ep1, ep2, np0, np1, np2)

		  dim n3 as integer
		  n3 = TroisiemeIndex(n1, n2)

		  dim M as SimilarityMatrix

		  select case n3
		  case 0
		    M = new SimilarityMatrix(ep1, ep2, np1, np2)
		  case 1
		    M = new SimilarityMatrix(ep0, ep2, np0, np2)
		  case 2
		    M = new SimilarityMatrix(ep0, ep1, np0, np1)
		  end select

		  Transform(M)
		  ReconstructRegular()

		  return M
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2fixes(p as point) As Matrix
		  // Maintien de la régularité avec un point fixe
		  dim M as Matrix
		  M = super.Modifier2fixes(p)
		  ReconstructRegular()
		  return M
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2fixes(p as point, q as point) As Matrix
		  // Maintien de la régularité avec deux points fixes
		  dim M as Matrix
		  M = super.Modifier2fixes(p, q)
		  ReconstructRegular()
		  return M
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier1fixe(p as point, q as point) As Matrix
		  // Maintien de la régularité avec un point fixe et un déplacé
		  dim M as Matrix
		  M = super.Modifier1fixe(p, q)
		  ReconstructRegular()
		  return M
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modifier2(n1 as integer, n2 as integer) As Matrix
		  // Maintien de la régularité avec deux points modifiés
		  dim M as Matrix
		  M = super.Modifier2(n1, n2)
		  ReconstructRegular()
		  return M
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub endmove()
		  // Maintien de la régularité après chaque mouvement
		  super.endmove()
		  ReconstructRegular()
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
		aveccentre As boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected M As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		supp As shape
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
			Name="aveccentre"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
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
