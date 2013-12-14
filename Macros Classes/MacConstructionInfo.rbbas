#tag Class
Protected Class MacConstructionInfo
	#tag Method, Flags = &h0
		Sub MacConstructionInfo(m as Macro)
		  Mac = m
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetInfoMac(n as integer) As InfoMac
		  dim i as integer
		  
		  for i = 0 to ubound (IfMacs)
		    if IfMacs(i).MacId = n then
		      return IfMacs(i)
		    end if
		  next
		  return nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XMLPutInContainer(Doc as XMLDocument) As XMLElement
		  dim Temp, EL as XMLElement
		  dim i as integer
		  
		  
		  Temp = Doc.CreateElement("IfMacs")
		  for i = 0 to ubound(ifmacs)
		    Temp.AppendChild IfMacs(i).XMLPutInContainer(Doc)
		  next
		  Temp.SetAttribute("NRF",str(ubound(realfinal)+1))
		  Temp.SetAttribute("NRI",str(ubound(realinit)+1))
		  Temp.SetAttribute("NRS",str(ubound(realInitside)+1))
		  'for i = 0 to ubound(RealFinal)
		  'Temp.SetAttribute("RF"+str(i),str(RealFinal(i)))
		  'next
		  for i = 0 to ubound(RealInit)
		    Temp.SetAttribute("RI"+str(i),str(RealInit(i)))
		  next
		  'for i = 0 to ubound(RealSide)
		  'Temp.SetAttribute("RS"+str(i),str(RealSide(i)))
		  'next
		  return Temp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MacConstructionInfo(m as Macro, Temp as XMLElement)
		  dim List as XmlNodeList
		  dim EL as XMLElement
		  dim nrf, nri, nrs as integer
		  dim i as integer
		  
		  MacConstructionInfo(m)
		  List = Temp.XQL("IfMacs")
		  if List.Length > 0 then
		    EL = XMLElement(List.Item(0))
		    nrf = val(EL.GetAttribute("NRF"))
		    nri = val(EL.GetAttribute("NRI"))
		    nrs = val(EL.GetAttribute("NRS"))
		    'if nrf > 0 then
		    'for i = 0 to nrf-1
		    'RealFinal.append val(EL.GetAttribute("RF"+str(i)))
		    'next
		    'end if
		    if nri > 0 then
		      for i = 0 to nri-1
		        RealInit.append val(EL.GetAttribute("RI"+str(i)))
		      next
		    end if
		    'if nrs > 0 then
		    'for i = 0 to nrs-1
		    'RealSide.append val(EL.GetAttribute("RS"+str(i)))
		    'next
		    'end if
		    for i = 0 to EL.ChildCount-1
		      IfMacs.append new InfoMac(XMLElement(EL.Child(i)))
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
		  elseif Mac.ObInterm.indexof(n) <> -1 then
		    return RealIntermSide(Mac.ObInterm.indexof(n))
		  elseif Mac.ObFinal.indexof(n) <> -1 then
		    return RealFinalSide(Mac.ObFinal.indexof(n))
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSommet(ni as integer, n as integer, byref m as integer) As InfoMac
		  
		  
		  dim i, j as integer
		  dim EL, EL0, EL1 as XMLElement
		  
		  if (Mac.Obinit.indexof(n) <> -1) or   (Mac.ObInterm.indexof(n) <> -1) or (Mac.ObFinal.indexof(n) <> -1) then
		    return GetInfoMac(n)
		  end if
		  
		  //Si c'est un point qui n'est ni initial ni intermédiaire, il appartient à un autre objet construit antérieurement
		  m = -1
		  
		  for i = ni downto 0
		    EL = XMLElement(Mac.Histo.Child(i))
		    if EL.Name = Dico.Value("Operation") then
		      EL0 = XMLElement(EL.Child(0))
		      if EL0.Childcount > 0 then
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
		RealIntermSide() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RealFinalSide() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			//Note: Cette liste ne concerne que les points intermédiaires qui appartiennent à un objet initial
			//Dont on doit donc retrouver les coordonnées facilement
		#tag EndNote
		RealInterm As Integer
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
			Name="RealInterm"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
