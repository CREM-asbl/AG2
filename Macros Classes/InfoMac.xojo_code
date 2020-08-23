#tag Class
Protected Class InfoMac
	#tag Method, Flags = &h0
		Sub Constructor(fa as integer, fo as integer)
		  self.fa = fa
		  self.fo = fo
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(MacInfo as MacConstructionInfo, EL as XMLElement, oper As integer)
		  dim EL0 as XMLElement
		  
		  
		  EL0 = XMLElement(EL.Child(0))
		  
		  self.MacInfo = MacInfo
		  self.oper=oper
		  forme0 = val(EL0.GetAttribute("Id"))   //MacId du support de la tsf
		  type = val(EL.GetAttribute("TsfType"))
		  ori = val(EL.GetAttribute("TsfOri"))
		  RealSide = val(EL.GetAttribute("TsfSide"))
		  RealId =  MacInfo.GetRealId(forme0)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(MacInfo as MacConstructionInfo, EL0 as XMLElement, EL1 as XMLElement, oper as integer)
		  
		  dim m as integer
		  dim ifm as infomac
		  dim EL01 as XMLElement
		  
		  
		  self.MacInfo = MacInfo
		  fa = val(EL0.GetAttribute(Dico.Value("NrFam")))
		  fo = val(EL0.GetAttribute(Dico.Value("NrForm")))
		  self.oper=oper
		  MacId = val(EL0.GetAttribute("Id"))
		  ori = val(EL0.GetAttribute("Ori"))
		  Npts = val(EL0.GetAttribute(Dico.Value("Npts")))
		  
		  if EL1 <> nil then
		    CopyParam (EL0, EL1, oper)
		  end if
		  if fa = 0 then
		    if fo = 2 then
		      fo = 0
		    end if
		    ptsur = fo
		    if ptsur = 1 then
		      ifm = MacInfo.GetInfoMac(forme0, m)
		      ifm.childs.append self
		    end if
		  else
		    Ncpts = val(EL0.GetAttribute(Dico.Value("Ncpts")))
		  end if
		  
		  EL01 = XMLElement(EL0.FirstChild)
		  if EL01 <> nil then
		    CreateChildren(EL01)
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Temp as XMLElement)
		  dim List as XMLNodeList
		  dim i as integer
		  dim EL1, EL2 as XMLElement
		  
		  
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
		    coord = new nBPoint
		    for i = 0 to EL1.Childcount-1
		      EL2 = XMLElement(EL1.Child(i))
		      coord.append new BasicPoint(val(EL2.GetAttribute("X")), val(EL2.GetAttribute("Y")))
		    next
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CopyParam(EL0 as XMLElement, EL1 as XMLElement, op as integer)
		  //On copie les infos de construction qui ne changeront pas  dans l'infomac du nouvel objet
		  dim EL2 as XMLElement
		  dim ifm as infomac
		  dim m as integer
		  
		  select case op
		    
		  case 1 //paraperp
		    Forme0 = val(EL1.GetAttribute("Id"))
		    NumSide0= val(EL1.GetAttribute("Index"))
		    ifm = MacInfo.GetInfoMac(forme0, m)
		    if ifm.npts > 2 then
		      seg = true
		    end if
		    if fo = 4 or fo = 5 then 'droites paraperp
		      ncpts=1
		    end if
		    ori = val(EL1.GetAttribute("Ori"))
		  case 14 //centre
		    forme0 = val(EL1.GetAttribute("Id"))
		  case 19 //DupliquerPoint
		    Forme0 = val(EL0.GetAttribute("Forme0"))  //Support du duplicat
		    Forme2 = val(EL1.GetAttribute("Id"))   //MacId du point dupliqué
		    num = val(EL1.GetAttribute("Data0")) //Ecart entre les numéros de coté du dupliqué et du duplicat
		    ifm = MacInfo.GetInfoMac(forme2,m)
		    if ifm.macId <> forme2 then
		      ifm = ifm.childs(m)
		    end if                              //infomac du point dupliqué
		    forme1 = ifm.forme0   //macId du support du dupliqué
		    numside1 = ifm.numside0 //numside du dupliqué
		    numside0 = (numside1+num) mod npts
		  case 24 //AppliquerTsf
		    Forme0 = val(EL1.GetAttribute("SuppTsf")) //MacId du support
		    Forme1 = val(EL1.GetAttribute("Id"))             //MacId de la source
		    numside0 = val(EL1.GetAttribute("Numside")) //Nr de coté du support (éventuel)
		    num = val(EL1.GetAttribute("Nr"))                    //Nr de la tsf
		  case 26 //diviser
		    Forme0 =  val(EL1.GetAttribute("Id"))
		    forme1 = val(EL1.GetAttribute("Id0"))
		    forme2 = val(EL1.GetAttribute("Id1"))
		    ndiv = val(EL1.GetAttribute("NDivP"))
		    idiv = val(EL1.GetAttribute("DivP"))
		    Numside0 = val(EL1.GetAttribute("Side"))  'Numéro du côté divisé en cas de polygone... sinon 0
		  case 28 //prolonger
		    Forme0 = val(EL1.GetAttribute("Id"))
		    NumSide0= val(EL1.GetAttribute("Index"))
		  case  37 // FixPtConstruction
		    Forme0 = val(EL1.GetAttribute("SuppTsf"))
		    numside0 = val(EL1.GetAttribute("Numside"))
		    num = val(EL1.GetAttribute("Nr"))
		  case 45 //inter
		    numside0 = val(EL1.GetAttribute("NumSide0"))
		    numside1 = val(EL1.GetAttribute("NumSide1"))
		    EL2 = XMLElement(EL1.child(0))
		    forme0 = val(EL2.GetAttribute("Id"))
		    EL2 = XMLElement(EL1.child(1))
		    forme1 = val(EL2.GetAttribute("Id"))
		  case 46 //PointSur (construction)
		    numside0 = val(EL1.GetAttribute("NumSide0"))
		    location = val(EL1.GetAttribute("Location"))
		    EL2 = XMLElement(EL1.child(0))
		    forme0 = val(EL2.GetAttribute("Id")) //Support du point sur
		  end select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateChildren(EL as XMLElement)
		  dim i as integer
		  dim ifm as InfoMac
		  dim EL1 as XMLElement
		  dim n, m as integer
		  
		  for i = 0 to npts-1
		    EL1 = XMLElement(EL.Child(i))
		    n =val(EL1.GetAttribute("Id"))
		    ifm =MacInfo.GetInfoMac(n,m)
		    if ifm <> nil then
		      if  ifm.macId <> n and m <> -1 then
		        ifm = ifm.childs(m)
		      end if
		    else
		      ifm = new InfoMac(0,0)
		      ifm.MacId = n
		    end if
		    childs.append ifm
		  next
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  Dim EL, temp As XMLElement
		  dim i as integer
		  
		  temp =  Doc.CreateElement("IfMac")
		  temp.SetAttribute(Dico.Value("NrFam"), Str(fa))
		  temp.SetAttribute(Dico.Value("NrForm"),Str(fo))
		  if fa <> 0 then
		    temp.Setattribute("Npts",str(Npts))
		    temp.setattribute("Ncpts",str(Ncpts))
		    temp.SetAttribute("Ori",str(ori))
		  else
		    temp.SetAttribute("PtSur",str(ptsur))
		    temp.setattribute("Location",str(location))
		    temp.SetAttribute("Ndiv",str(ndiv))
		    temp.SetAttribute("Idiv", str(idiv))
		  end if
		  temp.SetAttribute("Oper",str(Oper))
		  temp.SetAttribute("MId",str(MacId))
		  temp.Setattribute("RId",str(RealId))
		  temp.setAttribute("Side",str(Realside))
		  temp.setattribute("Forme0",str(Forme0))
		  temp.setattribute("Forme1",str(Forme1))
		  temp.setattribute("Forme2",str(Forme2))
		  temp.SetAttribute("Numside0",str(numside0))
		  temp.SetAttribute("Numside1",str(numside1))
		  temp.SetAttribute("Num",str(num))
		  temp.setattribute("Type",str(type))
		  if final then
		    Temp.SetAttribute("Fin",str(1))
		  else
		    Temp.SetAttribute("Fin",str(0))
		  End If
		  if Init then
		    Temp.SetAttribute("Ini",str(1))
		  else
		    Temp.SetAttribute("Ini",Str(0))
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
		  End If
		  If M <> Nil Then
		    M.XMLPutAttribute(Temp)
		  end if
		  if ubound(childs) > -1 then
		    EL = Doc.CreateElement("Childs")
		    for i = 0 to ubound(childs)
		      EL.appendChild(childs(i).XMLPutInContainer(Doc))
		    next
		    Temp.Appendchild EL
		  end if
		  if coord <> nil and not currentcontent.macrocreation  then
		    Temp.AppendChild coord.XMLPutInContainer(Doc)
		  end if
		  
		  
		  return temp
		End Function
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
		childs(-1) As infomac
	#tag EndProperty

	#tag Property, Flags = &h0
		coord As nBpoint
	#tag EndProperty

	#tag Property, Flags = &h0
		fa As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		final As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		fo As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Forme0 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Forme1 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Forme2 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		idiv As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		init As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		interm As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		location As double
	#tag EndProperty

	#tag Property, Flags = &h0
		M As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		MacId As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		MacInfo As MacConstructionInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		Ncpts As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ndiv As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Npts As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		num As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		numside0 As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		numside1 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		oper As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ori As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ptsur As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RealId As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RealSide As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		seg As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		type As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="fa"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="final"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="fo"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Forme0"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Forme1"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Forme2"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="idiv"
			Visible=false
			Group="Behavior"
			InitialValue="0"
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
			Name="init"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="interm"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="location"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MacId"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="Ncpts"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ndiv"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Npts"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="num"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="numside0"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="numside1"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="oper"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ori"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ptsur"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RealId"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RealSide"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="seg"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="type"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
