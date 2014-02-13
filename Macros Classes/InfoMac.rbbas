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
		  dim EL, temp as XMLElement
		  dim i as integer
		  
		  temp =  Doc.CreateElement("IfMac")
		  temp.SetAttribute(Dico.Value("NrFam"), str(fa))
		  temp.SetAttribute(Dico.Value("NrForm"),str(fo))
		  temp.Setattribute("Npts",str(Npts))
		  temp.setattribute("Ncpts",str(Ncpts))
		  temp.SetAttribute("Oper",str(Oper))
		  temp.SetAttribute("MId",str(MacId))
		  temp.SetAttribute("Ori",str(ori))
		  temp.SetAttribute("PtSur",str(ptsur))
		  temp.Setattribute("RId",str(RealId))
		  temp.setAttribute("Side",str(Realside))
		  temp.setattribute("Forme0",str(Forme0))
		  temp.setattribute("Forme1",str(Forme1))
		  temp.setattribute("Forme2",str(Forme2))
		  temp.SetAttribute("Numside0",str(numside0))
		  temp.SetAttribute("Numside1",str(numside1))
		  temp.SetAttribute("Ndiv",str(ndiv))
		  temp.SetAttribute("Idiv", str(idiv))
		  temp.setattribute("Location",str(location))
		  temp.setattribute("Type",str(type))
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
		  if seg then
		    Temp.setattribute("Seg",str(1))
		  else
		    Temp.setattribute("Seg",str(0))
		  end if
		  EL = Doc.CreateElement("Childs")
		  for i = 0 to ubound(childs)
		    EL.appendChild(childs(i).XMLPutInContainer(Doc))
		  next
		  Temp.Appendchild EL
		  if coord <> nil then
		    Temp.AppendChild coord.XMLPutInContainer(Doc)
		  end if
		  if M <> nil then
		    M.XMLPutAttribute(Temp)
		  end if
		  
		  return temp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InfoMac(Temp as XMLElement)
		  dim List as XMLNodeList
		  dim i as integer
		  dim EL1 as XMLElement
		  
		  coord = new nBPoint
		  fa = val(Temp.GetAttribute(Dico.Value("NrFam")))
		  fo= val(Temp.GetAttribute(Dico.Value("NrForm")))
		  Npts = val(Temp.GetAttribute("Npts"))
		  Ncpts = val(Temp.GetAttribute("Ncpts"))
		  oper = val(temp.GetAttribute("Oper"))
		  MacId = val(temp.GetAttribute("MId"))
		  ori = val(temp.GetAttribute("Ori"))
		  ptsur = val(temp.GetAttribute("PtSur"))
		  RealId = val(temp.Getattribute("RId"))
		  Realside = val(temp.GetAttribute("Side"))
		  Forme0 = val(temp.GetAttribute("Forme0"))
		  Forme1 = val(temp.GetAttribute("Forme1"))
		  Forme2 = val(temp.GetAttribute("Forme2"))
		  numside0 = val(temp.GetAttribute("Numside0"))
		  numside1 = val(temp.GetAttribute("Numside1"))
		  ndiv = val(temp.GetAttribute("Ndiv"))
		  idiv = val(temp.GetAttribute("Idiv"))
		  location = val(temp.Getattribute("Location"))
		  type = val(temp.GetAttribute("Type"))
		  
		  final = (val(Temp.GetAttribute("Fin")) = 1)
		  init = ( val(Temp.GetAttribute("Ini")) = 1)
		  interm = (val(Temp.GetAttribute("Int")) = 1)
		  seg = (val(Temp.GetAttribute("Seg"))=1)
		  
		  M = new Matrix(temp)
		  
		  List = Temp.XQL("Coords")
		  if List.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		    for i = 0 to EL1.Childcount-1
		      coord.append new BasicPoint (XMLElement(EL1.Child(i)))
		    next
		  end if
		  
		  List = Temp.XQL("Childs")
		  if List.length > 0 then
		    EL1 = XMLElement(List.Item(0))
		    for i = 0 to EL1.Childcount-1
		      childs.append new InfoMac(XMLElement(EL1.Child(i)))
		    next
		  end if
		End Sub
	#tag EndMethod


	#tag Note, Name = Interprétations
		
		Un IFMac pour chacune des opérations de la macro
		
		
		RealSide est utilisé pour mémoriser le numéro du côté d'un polygone, d'un secteur ou d'une bande utilisé comme segment ou droite
		numside et location sont utilisés pour les pointsur un côté de figure (polygone, etc...)
		
		coord: liste des abscisses
		fa et fo: détermination dy type d'objet (famille, forme)
		final, interm, init : vrai si l'objet a cette propriété (à remplacer par stade = 0, 1 ou 2 (d'init à final)
		forme0 et forme1: macId des formes dont on prend l'inter
		numside0 et numside1 (pour ptsur et ptinter) : numéros des côtés des formes dont on prend l'inter
		                numside1 sert aussi pour les ptssur "simples"
		                location : abscisse d'un pointsur (pas d'un pt inter)
		forme0 et numside0 sont également utilisés pour les ParaperpConstruction
		ptsur: id de l'objet sur lequel un point se trouve
		M : matrice d'une transfo
		MacId: id relatif à la macro
		num ?
		ori: orientation
		RealId: id de l'objet réel (pour init et final)
		RealSide : numéro du côté d'un polyg choisi comme segment
		Type: type d'une transfo
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
		num As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RealId As Integer
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

	#tag Property, Flags = &h0
		numside0 As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		location As double
	#tag EndProperty

	#tag Property, Flags = &h0
		numside1 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ptsur As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Forme0 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Forme1 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		oper As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Npts As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Ncpts As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		childs(-1) As infomac
	#tag EndProperty

	#tag Property, Flags = &h0
		ndiv As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		idiv As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Forme2 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		seg As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		RealSide As Integer
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
		#tag ViewProperty
			Name="num"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="type"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RealSide"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="numside0"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="numside1"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Forme0"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Forme1"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="oper"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Npts"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ncpts"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ndiv"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="idiv"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Forme2"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="seg"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
