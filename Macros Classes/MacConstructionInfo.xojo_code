#tag Class
Protected Class MacConstructionInfo
	#tag Method, Flags = &h0
		Sub Constructor(m as Macro)
		  Mac = m
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(m as Macro, Temp as XMLElement)
		  dim EL , EL1, EL2 as XMLElement
		  dim nrf, nri, nrs, fa as integer
		  dim i, j, n, num, nch, mid as integer
		  dim ifm, ifmac as InfoMac
		  dim s as shape
		  
		  constructor(m)
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
		  
		  EL = XMLElement(Temp.firstChild)
		  for i = 0 to EL.ChildCount -1
		    EL1 = XMLElement(EL.Child(i))
		    fa = val(EL1.GetAttribute(Dico.Value("NrFam")))
		    if fa = 0 then
		      ifmac = CreateInfoMacPoint(EL1)
		    else
		      ifmac = CreateInfoMacShape(EL1)
		    end if
		    ifmac.MacInfo = self
		    
		    if ifmac.init  then
		      s = currentcontent.TheObjects.GetShape(ifmac.RealId)
		      s.ifmac = ifmac
		      if ifmac.npts < s.npts then
		        ifmac.seg = true
		        ifmac.RealSide = GetRealSide(n)
		      end if
		      for j = 0 to ifmac.childs.Count-1
		        ifmac.childs(j).RealId =s.points((j+ifmac.RealSide) mod s.npts).id
		      next
		      ifmac.ori = s.ori
		    end if
		    ifmacs.append ifmac
		  next
		  
		  
		  Exception err
		    var d as Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("nrf", nrf)
		    d.setVariable("nri", nri)
		    d.setVariable("nrfs", nrs)
		    d.setVariable("fa", fa)
		    d.setVariable("i", i)
		    d.setVariable("j", j)
		    d.setVariable("n", n)
		    d.setVariable("ifmac.npts", ifmac.npts)
		    d.setVariable("s.npts", s.npts)
		    err.message = err.message + d.getString
		    Raise err
		    
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateInfoMacPoint(EL1 as XMLElement) As infomac
		  dim mid, num as integer
		  dim ifm, ifmac as infomac
		  
		  mid = val(EL1.GetAttribute("MId"))
		  ifm = GetInfoMac(mid,num)
		  if ifm <> nil then
		    if  ifm.macId <> mid and num <> -1 then
		      ifmac = ifm.childs(num)
		    else
		      ifmac = ifm
		    end if
		  else
		    ifmac = new InfoMac(EL1)
		  end if
		  
		  return ifmac
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateInfoMacShape(EL1 as XMLElement) As infomac
		  dim List as XMLNodeList
		  dim EL2 as XMLElement
		  dim i as integer
		  dim ifmac as infomac
		  
		  ifmac = new InfoMac(EL1)
		  
		  List = EL1.XQL("Childs")
		  if List.length > 0 then
		    EL2 = XMLElement(List.Item(0))
		    for i = 0 to EL2.ChildCount-1
		      ifmac.childs.append CreateInfoMacPoint(XMLElement(EL2.Child(i)))
		    next
		  end if
		  
		  return ifmac
		End Function
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
		Function GetRealFinal(n as integer) As integer
		  if Mac.ObFinal.indexof(n) <> -1 then
		    return RealFinal(Mac.ObFinal.indexof(n))
		  else
		    return -1
		  end if
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
		Function GetRealSide(n as integer) As integer
		  
		  if Mac <> nil and Mac.ObInit.indexof(n) <> -1 then
		    return RealInitSide(Mac.ObInit.indexof(n))
		    'elseif Mac.ObInterm.indexof(n) <> -1 then
		    'return RealIntermSide(Mac.ObInterm.indexof(n))
		    'elseif Mac.ObFinal.indexof(n) <> -1 then
		    'return RealFinalSide(Mac.ObFinal.indexof(n))
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
		Function ToMac(Doc as XMLDocument) As XMLElement
		  dim EL, EL1, EL2 as XMLElement
		  dim i as integer
		  
		  EL = Doc.CreateElement("MacConstructionInfo")
		  EL.setAttribute("Name", Mac.Caption)
		  
		  EL1 = Doc.CreateElement("InfoMacs")
		  for i = 0 to ubound(IfMacs)
		    EL1. appendchild Ifmacs(i).XMLPutInContainer(Doc)
		  next
		  EL.Appendchild EL1
		  EL1 = Doc.CreateElement("InitialForms")
		  for i = 0 to Ubound(RealInit)
		    EL2 = Doc.CreateElement("Init")
		    EL2.SetAttribute("RealInit",str(RealInit(i)))
		    EL2.SetAttribute("RealInitSide",str(RealInitSide(i)))
		    EL1.AppendChild EL2
		  next
		  EL.Appendchild EL1
		  EL1 = Doc.CreateElement("FinalForms")
		  for i = 0 to Ubound(RealFinal)
		    EL2 = Doc.CreateElement("Final")
		    EL2.SetAttribute("RealFinal",str(RealFinal(i)))
		    EL1.AppendChild EL2
		  next
		  EL.Appendchild EL1
		  return EL
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


	#tag Property, Flags = &h0
		IfMacs() As InfoMac
	#tag EndProperty

	#tag Property, Flags = &h0
		Mac As Macro
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


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
	#tag EndViewBehavior
End Class
#tag EndClass
