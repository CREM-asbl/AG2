#tag Class
Protected Class InfoMac
	#tag Method, Flags = &h0
		Sub InfoMac(fa as integer, fo as integer)
		  self.fa = fa
		  self.fo = fo
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  dim temp as XMLElement
		  
		  temp =  Doc.CreateElement("IfMac")
		  temp.SetAttribute(Dico.Value("NrFam"), str(fa))
		  temp.SetAttribute(Dico.Value("NrForm"),str(fo))
		  temp.setattribute("loc",str(location))
		  temp.SetAttribute("MId",str(MacId))
		  temp.SetAttribute("Ori",str(ori))
		  temp.SetAttribute("PtSur",str(ptsur))
		  temp.Setattribute("RId",str(RealId))
		  temp.setAttribute("Side",str(side))
		  temp.SetAttribute("T",str(T))
		  if final then
		    Temp.SetAttribute("Fin",str(1))
		  else
		    Temp.SetAttribute("Fin",str(0))
		  end if
		  if Init then
		    Temp.SetAttribute("Ini",str(1))
		  else
		    Temp.SetAttribute("Ini",str(0))
		  end if
		  if Interm then
		    Temp.SetAttribute("Int",str(1))
		  else
		    Temp.SetAttribute("Int",str(0))
		  end if
		  return temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InfoMac(Temp as XMLElement)
		  fa = val(Temp.GetAttribute(Dico.Value("NrFam")))
		  fo= val(Temp.GetAttribute(Dico.Value("NrForm")))
		  
		  location = val(temp.Getattribute("loc"))
		  MacId = val(temp.GetAttribute("MId"))
		  ori = val(temp.GetAttribute("Ori"))
		  ptsur = val(temp.GetAttribute("PtSur"))
		  RealId = val(temp.Getattribute("RId"))
		  side = val(temp.GetAttribute("Side"))
		  T = val(temp.GetAttribute("T"))
		  final = (val(Temp.GetAttribute("Fin")) = 1)
		  init = ( val(Temp.GetAttribute("Ini")) = 1)
		  interm = (val(Temp.GetAttribute("Int")) = 1)
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = Interprétations
		
		MacId: Id interne à la macro de l'objet créé par l'oper n°NumOper
		Les vraies id des objets initiaux sont stockés dans MacInfo.RealInit
		Coord: coordonnées des sommets de l'objet construit
		
		Un IFMac pour chacune des opérations de la macro
	#tag EndNote


	#tag Property, Flags = &h0
		MacId As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		coord As nBpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		M As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		T As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		num As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RealId As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		location As double
	#tag EndProperty

	#tag Property, Flags = &h0
		ptsur As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		side As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		fa As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		fo As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ori As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		init As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		interm As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		final As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		type As Integer
	#tag EndProperty


	#tag ViewBehavior
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
			Name="MacId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="T"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TsfId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RealId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="location"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ptsur"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fa"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fo"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ori"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="init"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="interm"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="final"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
