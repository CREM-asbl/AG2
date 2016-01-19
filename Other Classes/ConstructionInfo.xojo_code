#tag Class
Protected Class ConstructionInfo
	#tag Method, Flags = &h0
		Sub Constructor(s as Shape, Op as Integer)
		  Shape=s
		  Oper = Op
		End Sub
	#tag EndMethod


	#tag Note, Name = Explications
		
		Oper est un entier désignant la construction utilisée (pas nécessairement la classe de construction)
		Les data doivent permettre de réexécuter la construction en interne
		
		
		Codes
		
		0 : Calcul du Centre de gravité 
		1: Bipoint parallele 
		2: Bipoint perpendiculaire
		3: Duplication. Data: matrice de transformation
		4: Divide (diviser un segment, un arc ou un cercle) 
		5 : Découpe. Data: matrice de Transformation
		6: Image par une transformation
		7: Point fixe d'une transformation
		8: Prolongement d'un segment ou côté de polygone 
		9 : Fusion // shape = nil
		10: Duplication d'un pointsur
		
		Data
		0: aucun
		1: 1: index de côté de forme; 2: transformation (mat = MId) (type = 0) 3. Ori (ajouté pour les macros) 
		2: idem précédent
		3: Matrice de transformation
		4: 1: firstpoint, 2: secondpoint (les deux points limitant l'intervalle à diviser) 3: dénominateur de la division (n), 4: numéro du point de division  (de 1 à n-1)
		5: pour les pièces: 1 : matrice de transformation, 2: sens de parcours (1 ou -1)
		6:  Transformation
		7: Transformation   
		8: si côté de polygone prolongé: data(0) = numéro du côté
		9:  0: 1ere forme fusionnée 1: matrice correspondante 2: 2eme forme fusionnée 3: matrice correspondante 
		10 : difference entre les  numéros de côté sur l'original et la copie (voir point.putduplicateon)
	#tag EndNote

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
		Data(-1) As Variant
	#tag EndProperty

	#tag Property, Flags = &h0
		Oper As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Shape As Shape
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
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
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Oper"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
