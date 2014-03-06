#tag Class
Protected Class MacConstructionInfo
	#tag Method, Flags = &h0
		Sub MacConstructionInfo(m as Macro)
		  Mac = m
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetInfoMac(mid as integer, byref num as integer) As InfoMac
		  dim i as integer
		  
		  for i = 0 to ubound (IfMacs)
		    if IfMacs(i).MacId = mid then
		      num = 0
		      return IfMacs(i)
		    else
		      num = GetInfoMacIn(ifmacs(i),mid)
		    end if
		    if num <> -1 then
		      return ifmacs(i)
		    end if
		  next
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  dim Temp, EL as XMLElement
		  dim i as integer
		  
		  Temp = Doc.CreateElement("MacConstructionInfo")
		  Temp.SetAttribute("NRF",str(ubound(realfinal)+1))
		  Temp.SetAttribute("NRI",str(ubound(realinit)+1))
		  Temp.SetAttribute("NRS",str(ubound(realInitside)+1))
		  for i = 0 to ubound(RealInit)
		    Temp.SetAttribute("RI"+str(i),str(RealInit(i)))
		  next
		  for i = 0 to ubound(RealFinal)
		    Temp.SetAttribute("RF"+str(i),str(RealFinal(i)))
		  next
		  
		  EL= Doc.CreateElement("IfMacs")
		  for i = 0 to ubound(ifmacs)
		    EL.AppendChild IfMacs(i).XMLPutInContainer(Doc)
		  next
		  Temp.appendChild EL
		  return Temp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MacConstructionInfo(m as Macro, Temp as XMLElement)
		  dim List as XmlNodeList
		  dim EL , EL1, EL2 as XMLElement
		  dim nrf, nri, nrs as integer
		  dim i, j, n, num as integer
		  dim ifm, ifmac as InfoMac
		  
		  MacConstructionInfo(m)
		  nrf = val(Temp.GetAttribute("NRF"))
		  nri = val(Temp.GetAttribute("NRI"))
		  nrs = val(Temp.GetAttribute("NRS"))
		  if nri > 0 then
		    for i = 0 to nri-1
		      RealInit.append val(Temp.GetAttribute("RI"+str(i)))
		    next
		  end if
		  if nrf > 0 then
		    for i = 0 to nrf-1
		      RealFinal.append val(Temp.GetAttribute("RF"+str(i)))
		    next
		  end if
		  
		  List = Temp.XQL("IfMacs")
		  if List.Length > 0 then
		    EL = XMLElement(List.Item(0))
		    for i = 0 to EL.ChildCount-1
		      EL1 = XMLElement(EL.Child(i))
		      ifmac = new InfoMac(EL1)
		      List = EL1.XQL("Childs")
		      if List.Length > 0 then
		        EL2= XMLElement(List.Item(0))
		        for j = 0 to ifmac.npts-1
		          n = ifmac.childs(j).MacId
		          ifm = GetInfoMac(n,num)
		          if ifm <> nil then
		            if  ifm.macId <> n and num <> -1 then
		              ifmac.childs(j) = ifm.childs(num)
		            else
		              ifmac.childs(j) = ifm
		            end if
		          else
		            ifmac.childs(j) = new InfoMac(XMLElement(EL2.Child(j)))
		          end if
		        next
		      end if
		      ifmacs.append ifmac
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRealInit(n as integer) As integer
		  if Mac.ObInit.indexof(n) <> -1 then
		    return RealInit(Mac.ObInit.indexof(n))
		  else
		    return -1
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRealFinal(n as integer) As integer
		  if Mac.ObFinal.indexof(n) <> -1 then
		    return RealFinal(Mac.ObFinal.indexof(n))
		  else
		    return -1
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRealSide(n as integer) As integer
		  
		  if Mac.ObInit.indexof(n) <> -1 then
		    return RealInitSide(Mac.ObInit.indexof(n))
		    'elseif Mac.ObInterm.indexof(n) <> -1 then
		    'return RealIntermSide(Mac.ObInterm.indexof(n))
		  elseif Mac.ObFinal.indexof(n) <> -1 then
		    return RealFinalSide(Mac.ObFinal.indexof(n))
		  else
		    return 0
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSommet(ni as integer, n as integer, byref m as integer) As InfoMac
		  
		  
		  dim i, j as integer
		  dim EL, EL0, EL1 as XMLElement
		  
		  'if (Mac.Obinit.indexof(n) <> -1) or   (Mac.ObInterm.indexof(n) <> -1) or (Mac.ObFinal.indexof(n) <> -1) then
		  'return GetInfoMac(n)
		  'end if
		  
		  //Si c'est un point qui n'est ni initial ni intermédiaire, il appartient à un autre objet construit antérieurement
		  
		  
		  for i = ni downto 0
		    EL = XMLElement(Mac.Histo.Child(i))
		    if EL.Name = Dico.Value("Operation") then
		      EL0 = XMLElement(EL.Child(0))
		      if EL0.GetAttribute("Type") = "Point" and n = val(EL0.GetAttribute("Id")) then
		        m = 0
		        return Ifmacs(i)
		      elseif EL0.Childcount > 0 then
		        EL1 = XMLElement(EL0.FirstChild)
		        for j = 0 to EL1.Childcount-1
		          if n = val(EL1.Child(j).GetAttribute("Id")) then
		            m = j
		            return IfMacs(i)
		          end if
		        next
		      end if
		    end if
		  next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetInfoMacIn(IfMac as InfoMac, mid as integer) As integer
		  dim i as Integer
		  dim ifm  as infomac
		  
		  for i=0 to Ubound(IfMac.Childs)
		    if IfMac.Childs(i).Macid = mid  then
		      return i
		    end if
		  next
		  return -1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRealId(n as integer) As integer
		  dim m as integer
		  m = GetRealInit(n)
		  if m = -1 then
		    m = GetRealFinal(n)
		  end if
		  return m
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Mac As Macro
	#tag EndProperty

	#tag Property, Flags = &h0
		IfMacs() As InfoMac
	#tag EndProperty

	#tag Property, Flags = &h0
		RealFinal() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RealInit() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RealInitSide() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RealFinalSide() As Integer
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
	#tag EndViewBehavior
End Class
#tag EndClass
