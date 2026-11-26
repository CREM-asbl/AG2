#tag Class
Protected Class MacroExe
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub Constructor(n as integer)
		  Mac = app.TheMacros.item(n)
		  if currentcontent <> nil then  'On retient ainsi les macros réellement utilisées dans un écran (et sans répétition)
		    currentcontent.TheMacros.addmac(Mac)
		  end if
		  Constructor(Mac)
		  
		  mac.OpenDescripWindow
		  fa = -1
		  
		  
		  
		  //Cette classe a pour objet de choisir de nouveaux objets initiaux et de construire la MacConstructionInfo associée
		  //Dans SetItem, complété par "InstructionsSuivantes", on se borne à déterminer les objets initiaux
		  
		  //Dans le DoOperation, on commence par créer les "InfoMac" associés aux différentes opérations de la macro et d'y placer
		  //les informations ne changeant pas d'une instance de la macro à une autre (essentiellement les id-macros et les numéros de forme et de famille).
		  
		  // ensuite,  on appelle la méthode MacExe de la classe Macro qui se charge de calculer tous les bpt des objets intermédiaires et finaux
		  // Quand on revient à MacroExe, il reste à créer les objets finaux et mettre en place les informations à utiliser lors d'une modification.
		  
		  //La routine MacExe  de Macro est également utilisée lors des modifications d'une figure contenant des macros.
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Macr as Macro)
		  super.constructor()
		  Mac = Macr
		  OpId = 43
		  NumberOfItemsToSelect = ubound(macr.obinit) +1
		  Histo = Macr.Histo
		  MacInfo = new MacConstructionInfo(Mac)
		  Mac.MacInf = MacInfo
		  codesoper = Array(0,1,14,16,19,28,35,37,39,24,25,26,27,43,45,46)  //codes des opérations
		  colsep = true
		  Mac.codesoper = codesoper
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateFinal(ifmac as InfoMac) As shape
		  dim  s, newshape as shape
		  dim i as integer
		  
				  if objects = nil or currentcontent = nil or currentcontent.TheObjects = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil objects/currentcontent")
				    return nil
				  end if
				  if ifmac = nil or MacInfo = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil ifmac/MacInfo")
				    return nil
				  end if
		  
		  newshape = objects.createshape(ifmac.fa,ifmac.fo)
				  if newshape = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil newshape")
				    return nil
				  end if
		  newshape.auto=0
		  
		  newshape.initconstruction
		  if ifmac.oper = 19 or ifmac.oper = 46 then
				    if point(newshape) = nil then
				      System.DebugLog(CurrentMethodName + ": skip nil point(newshape)")
				      return newshape
				    end if
		    s = currentcontent.Theobjects.getshape(MacInfo.GetRealId(ifmac.forme0))
				    if s = nil then
				      System.DebugLog(CurrentMethodName + ": skip nil s")
				    else
				      point(newshape).puton s, ifmac.location
				      point(newshape).ifmac = ifmac
				    end if
		  end if
		  if ifmac.oper = 1 and (ifmac.fo> 3)  then
				    if newshape.npts > 1 and Ubound(newshape.points) >= 1 then
				      if newshape.points(1) <> nil then
				        newshape.points(1).hide
				      end if
				    end if
		    newshape.ncpts = 1
		  end if
		  newshape.ori = ifmac.ori
		  if newshape isa arc then
		    arc(newshape).drapori = true
		  end if
		  
		  newshape.MacConstructedBy = MacInfo
		  for i = 0 to ubound(MacInfo.Realinit)
		    s = currentcontent.Theobjects.getshape(MacInfo.Realinit(i))
				    if s = nil then
				      System.DebugLog(CurrentMethodName + ": skip nil s Realinit i=" + Str(i))
				      Continue For
				    end if
		    s.addMacConstructedshape newshape
		  next
		  
		  currentcontent.addshape newshape
		  MacInfo.RealFinal.append newshape.id
		  ifmac.RealId = newshape.id
		  ifmac.final = true
		  for i = 0 to newshape.npts-1
				    if i < 0 or i > Ubound(ifmac.childs) or i > Ubound(newshape.points) then
				      System.DebugLog(CurrentMethodName + ": skip final OOB i=" + Str(i))
				      Continue For
				    end if
				    if newshape.points(i) = nil then
				      System.DebugLog(CurrentMethodName + ": skip nil final point i=" + Str(i))
				      Continue For
				    end if
				    if i >= 0 and i <= Ubound(ifmac.childs) then
				      if ifmac.childs(i) <> nil and ifmac.childs(i).RealId = 0 then                           //cas où des points devront être identifiés
				        ifmac.childs(i).RealId = newshape.points(i).id
				      end if
		    end if
		  next
		  return newshape
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateFinalSkulls()
		  dim i, n as integer
		  dim s as shape
		  
				  if MacInfo = nil or objects = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil MacInfo/objects")
				    return
				  end if
				  for i = 0 to ubound(MacInfo.RealFinal)
				    if i < 0 or i > Ubound(MacInfo.RealFinal) then
				      Continue For
				    end if
		    n = MacInfo.RealFinal(i)
		    s = objects.GetShape(n)
				    if s = nil then
				      System.DebugLog(CurrentMethodName + ": skip nil s n=" + Str(n))
				      Continue For
				    end if
		    if s isa point then
		      s.createskull(point(s).bpt)
		      point(s).mobility
		    else
				      if s.npts = 0 then
				        System.DebugLog(CurrentMethodName + ": skip npts=0 n=" + Str(n))
				        Continue For
				      end if
		      if Ubound(s.points) < 0 or s.points(0) = nil then
			        System.DebugLog(CurrentMethodName + ": skip nil points(0) n=" + Str(n))
			        Continue For
			      end if
		      s.createskull(s.points(0).bpt)
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateIfMacObject(EL as XMLElement, oper as integer)
		  //Cette  méthode crée les structures Ifmac de classe Infomac mais n'y place aucune valeur numérique de position.
		  //Cette opération est exécutée dans la deuxième phase : exécution de la macro prise en charge par la méthode macexe de la classe Macro
		  
		  dim i, n, k as integer
		  dim EL0, EL1 as XMLElement
		  dim ifmac, ifm As InfoMac
		  dim s, newshape as shape
		  
				  if Mac = nil or MacInfo = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil Mac/MacInfo")
				    return
				  end if
				  if objects = nil or currentcontent = nil or currentcontent.TheObjects = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil objects/currentcontent")
				    return
				  end if
		  if EL = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil EL")
		    return
		  end if
		  if EL.ChildCount = 0 then
		    System.DebugLog(CurrentMethodName + ": skip empty operation EL")
		    return
		  end if
		  EL0 = XMLElement(EL.Child(0))
		  if EL.ChildCount > 1 then
		    EL1 = XMLElement(EL.Child(1))
		  end if
		  if EL0 = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil EL0")
		    return
		  end if
		  n = val(EL0.GetAttribute("Id"))
		  
		  if (Mac.ObInit.indexof(n) = -1) and  (Mac.ObInterm.indexof(n) = -1) and  (Mac.ObFinal.indexof(n) = -1) then
		    return
		  end if
		  
		  //Pemière partie: création de l'infomac
		  ifmac = new InfoMac(MacInfo, EL0,EL1,oper)
				  if ifmac = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil ifmac")
				    return
				  end if
		  
		  //Deuxième partie : adaptation selon la classe (init, interm, final)
		  if Mac.ObInit.indexof(n) <> -1 then
		    ifmac.RealId =MacInfo.GetRealInit(n)
		    if ifmac.RealId = -1 then
		      System.DebugLog(CurrentMethodName + ": skip RealId -1 n=" + Str(n))
		      return
		    end if
		    ifmac.init = true
		    s = currentcontent.TheObjects.GetShape(ifmac.RealId)
				    if s = nil then
				      System.DebugLog(CurrentMethodName + ": skip nil s RealId=" + Str(ifmac.RealId))
				      return
				    end if
		    if s isa point then
		      ifmac.fo = point(s).forme
		    end if
		    s.ifmac = ifmac
		    if ifmac.npts < s.npts then
		      ifmac.seg = true
		      ifmac.RealSide = MacInfo.GetRealSide(n)
		    end if
		    for i = 0 to ifmac.npts-1
				      if i < 0 or i > Ubound(ifmac.childs) then
				        System.DebugLog(CurrentMethodName + ": skip childs OOB i=" + Str(i))
				        Continue For
				      end if
				      if ifmac.childs(i) = nil then
				        System.DebugLog(CurrentMethodName + ": skip nil child i=" + Str(i))
				        Continue For
				      end if
		      if s.npts <= 0 or Ubound(s.points) < 0 then
			        System.DebugLog(CurrentMethodName + ": skip bad shape points n=" + Str(n))
			        Continue For
			      end if
			      k = ((i + ifmac.RealSide) mod s.npts + s.npts) mod s.npts
			      if k < 0 or k > Ubound(s.points) or s.points(k) = nil then
				        System.DebugLog(CurrentMethodName + ": skip bad point k=" + Str(k))
				        Continue For
				      end if
			      ifmac.childs(i).RealId = s.points(k).id
		    next
		    ifmac.ori = s.ori
		  end if
		  
		  if Mac.ObInterm.indexof(n) <> -1 then
		    ifmac.interm = true
		    for i = 0 to ubound(ifmac.childs)
				      if i < 0 or i > Ubound(ifmac.childs) then
				        Continue For
				      end if
		      ifm = ifmac.childs(i)
				      if ifm = nil then
				        System.DebugLog(CurrentMethodName + ": skip nil ifm i=" + Str(i))
				        Continue For
				      end if
		      if Mac.ObInit.indexof(Ifm.MacId) <> -1 then
		        ifm.init = true
		        ifm.RealId = MacInfo.GetRealInit(Ifm.MacId)
		        if ifm.RealId = -1 then
		          System.DebugLog(CurrentMethodName + ": skip RealId -1 MacId=" + Str(Ifm.MacId))
		          Continue For
		        end if
		      end if
		    next
		  end if
		  
		  if (Mac.ObFinal.indexof(n) <> -1)  then // A-t-on affaire  à un objet final?
		    newshape = CreateFinal(ifmac)
				    if newshape = nil then
				      System.DebugLog(CurrentMethodName + ": skip nil newshape")
				      return
				    end if
		    IdentifyPoints(newshape, ifmac,EL0)
		    newshape.endconstruction
		    newshape.ifmac = ifmac
		    for i = 0 to newshape.npts-1
				      if i < 0 or i > Ubound(ifmac.childs) or i > Ubound(newshape.points) then
				        System.DebugLog(CurrentMethodName + ": skip final OOB i=" + Str(i))
				        Continue For
				      end if
		      ifm = ifmac.childs(i)
				      if ifm = nil then
				        System.DebugLog(CurrentMethodName + ": skip nil ifm i=" + Str(i))
				        Continue For
				      end if
		      if Mac.ObInit.indexof(Ifm.MacId) <> -1 then
		        ifm.init = true
		        ifm.RealId = MacInfo.GetRealInit(Ifm.MacId)
		        if ifm.RealId = -1 then
		          System.DebugLog(CurrentMethodName + ": skip RealId -1 MacId=" + Str(Ifm.MacId))
		          Continue For
		        end if
		      end if
		      if newshape.points(i) = nil then
		        System.DebugLog(CurrentMethodName + ": skip nil newshape.points i=" + Str(i))
		        Continue For
		      end if
	      newshape.points(i).ifmac = ifm
		      if ifm.fo = 1 and (Mac.ObInterm.indexof(ifm.forme0) =-1) then
				        if MacInfo.GetRealId(ifm.forme0) = -1 then
				          System.DebugLog(CurrentMethodName + ": skip RealId -1 forme0=" + Str(ifm.forme0))
				        else
				          s = currentcontent.TheObjects.getshape(MacInfo.GetRealId(ifm.forme0))
				          if s <> nil then
				            newshape.points(i).numside.append  ifm.numside0
				            newshape.points(i).placerptsursurfigure
				          end if
				        end if
		      end if
		      newshape.points(i).forme = ifm.fo
		    next
		  end if
		  
		  MacInfo.IfMacs.append ifmac
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("El", El)
		    d.setVariable("oper", oper)
		    d.setVariable("s", s)
		    d.setVariable("i", i)
		    d.setVariable("n", n)
		    err.message = err.message+d.getString
		    
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateIfMacs(Temp as XMLElement)
		  dim i, oper as integer
		  dim EL as XMLElement
		  
				  if Mac = nil or MacInfo = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil Mac/MacInfo")
				    return
				  end if
		  if Temp = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil Temp")
		    return
		  end if
		  for i = 0 to Temp.Childcount-1  // i : numéro de l'opération
		    EL = XMLElement(Temp.Child(i))
		    if EL = nil then
		      System.DebugLog(CurrentMethodName + ": skip nil EL i=" + Str(i))
		      Continue For
		    end if
		    if EL.Name = Dico.Value("Operation") then  //est-ce une opération de construction (forme ou tsf) ? prévoir le cas contraire!
		      //Pour les points d'intersection, ptsur = 0 (ils sont traités comme résultant d'une opération d'inter (code 45))
		      oper = val(EL.GetAttribute("OpId"))
		      if codesoper.indexof(oper) <>  -1 then
		        CreateIfMacObject(EL,oper)
		      elseif oper = 17 then
		        CreateIfMacTsf(EL,oper)
		      end if
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateIfMacTsf(EL as XMLElement, oper as integer)
		  
		  dim ifmac as InfoMac
		  dim s as shape
		  dim tsf as transformation
		  
				  if Mac = nil or MacInfo = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil Mac/MacInfo")
				    return
				  end if
				  if objects = nil or currentcontent = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil objects/currentcontent")
				    return
				  end if
				  if EL = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil EL")
				    return
				  end if
		  
		  ifmac = new InfoMac(MacInfo, EL, oper)
				  if ifmac = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil ifmac")
				    return
				  end if
		  
		  if Mac.ObFinal.indexof(ifmac.forme0) <> -1 then
		    s = objects.getshape(ifmac.RealId)
				    if s = nil then
				      System.DebugLog(CurrentMethodName + ": skip nil s")
				      return
				    end if
		    tsf = CreateTsf(s, ifmac.type,ifmac.Realside, ifmac.ori)
				    if s.tsfi = nil then
				      System.DebugLog(CurrentMethodName + ": skip nil s.tsfi")
				    else
				      ifmac.num = s.tsfi.GetPosition(tsf)
				    end if
		  end if
		  
		  MacInfo.IfMacs.append ifmac
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateObject(EL as XMLElement, oper as integer)
		  dim Curop as Operation
		  dim i, n, rid, side as integer
		  dim EL0, EL1, EL01, EL02 as XMLElement
		  dim createdshape as shape
		  
		  if EL = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil EL")
		    return
		  end if
		  if EL.ChildCount = 0 then
		    System.DebugLog(CurrentMethodName + ": skip empty operation EL")
		    return
		  end if
		  EL0 = XMLElement(EL.Child(0))
		  if EL.ChildCount > 1 then
		    EL1 = XMLElement(EL.Child(1))
		  end if
		  if EL0 = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil EL0")
		    return
		  end if
		  n = val(EL0.GetAttribute("Id"))
		  if Mac.ObInit.indexof(n) <> -1 then
		    rid = GetRealId(n)
		    if rid = -1 then
		      System.DebugLog(CurrentMethodName + ": skip unknown MacId n=" + Str(n) + " rid=-1")
		      return
		    end if
		    createdshape = objects.getshape(rid)
		    if createdshape = nil then
		      System.DebugLog(CurrentMethodName + ": skip nil shape n=" + Str(n) + " rid=" + Str(rid))
		      return
		    end if
		    EL01 = XMLElement(EL0.Child(0))
		    if EL01 = nil then
		      System.DebugLog(CurrentMethodName + ": skip nil EL01 n=" + Str(n))
		      return
		    end if
		    if EL01.ChildCount = 0 then
		      System.DebugLog(CurrentMethodName + ": skip empty EL01 n=" + Str(n))
		      return
		    end if
		    side = GetRealSide(n)
		    if side = -1 then
		      side = 0
		    end if
		    if createdshape.npts > 0 then
		      for i = 0 to EL01.ChildCount-1
		        EL02 = XMLElement(EL01.Child(i))
		        if EL02 = nil then
		          System.DebugLog(CurrentMethodName + ": skip nil EL02 i=" + Str(i) + " n=" + Str(n))
		          Continue For
		        end if
		        MacId.append val(EL02.GetAttribute("Id"))
		        Real.Append createdshape.points((i+side) mod createdshape.npts).id
		        RealSide.append -1  ' Les MacInfo.RealInit et MacInfo.RealInitSide correspondants devront être utilisés
		      next                                                                   ' comme MacId  dans les instructions de la sous-macro faisant appel à l'objet initial
		    end if
		    'Chaque fois qu'on va construire un nouvel objet, on placera sa MacId  dans 'MacId'
		  else                                                                     'son id dans Real et ' éventuellement le n° de côté dans RealSide. Ces données deviennent les MacId
		    'dans la macro principale en étant reprises dans le XMLElement créé par ToMac
		    select case oper
		    case 0, 46 //Construction et PointSur
		      curop = new shapeconstruction(self, EL0, EL1)
		      createdshape = curop.currentshape
		    case 1 //paraperp
		      curop = new ParaperpConstruction(self, EL0, EL1)
		      createdshape = curop.currentshape
		    case 14 //Centre
		      curop = new GCConstruction(self,  EL1)
		      createdshape = curop.currentshape
		    case 19 //Dupliquer
		      curop = new Duplicate(self,EL0, EL1)
		      createdshape = curop.currentshape
		    case 24 //AppliquerTsf
		      curop = new AppliquerTsf(self,  EL1)
		      if AppliquerTsf(curop).copies.count > 0 then
		        createdshape = AppliquerTsf(curop).copies.item(0)
		      end if
		    case 26 //Point de division
		      curop = new divide(self, EL1)
		      if divide(curop).createdshapes.count > 0 then
		        createdshape = divide(curop).createdshapes.item(0)
		      end if
		    case 28 //Prolonger
		    curop = new Prolonger(self,EL1)
		    if Prolonger(curop).NewLine <> nil then
		      createdshape = Prolonger(curop).NewLine
		    end if
		    case 37 //FixPConstruction
		      curop = new FixPConstruction(self, EL1)
		      if FixPConstruction(curop).tsf <> nil then
		        createdshape = FixPConstruction(curop).tsf.FixPt
		      end if
		    case 45  //Point d'intersection
		      curop = new Intersec(self, EL1)
		      createdshape = curop.currentshape
		    end select
		    
		    if createdshape = nil then
		      System.DebugLog(CurrentMethodName + ": skip nil createdshape n=" + Str(n) + " oper=" + Str(oper))
		      return
		    end if
		    if Mac.ObFinal.IndexOf(n) = -1 then
		      createdshape.hidden = true
		    end if
		    MacId.Append n
		    Real.Append createdshape.id
		    RealSide.Append 0
		    
		    for i = 0 to EL0.ChildCount-1
		      EL01 = XMLElement(EL0.Child(i))
		      if EL01 = nil then
		        System.DebugLog(CurrentMethodName + ": skip nil EL01 i=" + Str(i) + " n=" + Str(n))
		        MacId.append -1
		        Real.Append -1
		        RealSide.append -1
		        Continue For
		      end if
		      MacId.append val(EL01.GetAttribute("Id"))
		      if i <= createdshape.npts - 1 then
		        Real.Append createdshape.points(i).id
		      else
		        Real.Append -1
		      end if
		      RealSide.append -1
		    next
		    
		    if curop <> nil then
		      curop.endoperation
		    end if
		  end if
		  
		  exception err
		    var d as Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("Curop", Curop)
		    d.setVariable("i", i)
		    d.setVariable("n", n)
		    d.setVariable("rid", rid)
		    d.setVariable("side", side)
		    d.setVariable("EL0", EL0)
		    d.setVariable("EL1", EL1)
		    d.setVariable("EL01", EL01)
		    d.setVariable("EL02", EL02)
		    d.setVariable("createdShape", createdshape)
		    err.Message = err.Message + d.getString
		    raise err
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateTransfo(EL as XMLElement, oper as integer)
		  dim  EL0 as XMLElement
		  dim fa, fo, n, rid, type as integer
		  dim supp as shape
		  dim tsf as transformation
		  dim side as integer
		  
		  if EL = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil EL")
		    return
		  end if
		  EL0 = XMLElement(EL.Child(0))
		  if EL0 = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil EL0")
		    return
		  end if
		  
		  fa = val(EL0.GetAttribute(Dico.Value("NrFam")))  //concerne le support
		  fo = val(EL0.GetAttribute(Dico.Value("NrForm")))
		  
		  n = val(EL0.GetAttribute("Id"))
		  rid = GetRealId(n)                                 //Le support doit avoir été créé antérieurement
		  if rid = -1 then
		    System.DebugLog(CurrentMethodName + ": skip unknown MacId n=" + Str(n) + " rid=-1")
		    return
		  end if
		  supp = objects.getshape(rid)
		  if supp = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil support n=" + Str(n) + " rid=" + Str(rid))
		    return
		  end if
		  type = val(EL.GetAttribute("TsfType"))
		  side = val(EL.GetAttribute("TsfSide"))
		  tsf = CreateTsf(supp, type,side, supp.ori)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateTsf(s as shape, n as integer, cote as integer, ori as integer) As transformation
		  dim tsf as Transformation
		  
				  if s = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil s")
				    return nil
				  end if
				  if CurrentContent = nil or CurrentContent.TheTransfos = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil CurrentContent/TheTransfos")
				    return nil
				  end if
		  
		  tsf = new transformation
		  tsf.supp = s
		  tsf.type = n
		  tsf.index = cote
		  tsf.ori = ori
		  
		  if n <> 0 and  (n < 3 or n > 6 ) then
		    tsf.T = new Tip
		  end if
		  
		  tsf.setfpsp(s)
		  tsf.computematrix
		  CurrentContent.TheTransfos.AddObject(tsf)
				  if s.tsfi <> nil then
				    s.tsfi.addObject tsf
				  else
				    System.DebugLog(CurrentMethodName + ": skip nil s.tsfi")
				  end if
		  
		  return tsf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
				  if Mac = nil or MacInfo = nil or currentcontent = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil Mac/MacInfo/currentcontent")
				    return
				  end if
		  if currentcontent.macrocreation then   'on utilise une macro à l'intérieur de la construction d'une autre
		    ExecuteMacro(Histo)
		  else
		    CreateIfMacs(Histo)
		    mac.macexe(macinfo)                                       //Exécution de la macro: calcul des positions de tous les points ou de la matrice de la tsf
		    CreateFinalSkulls
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  fa = -1
		  
		  if mac.mw <> nil then
		    mac.mw.close
		  end if
		  if currentcontent.macrocreation then
		    CurrentContent.CurrentFileUpToDate=false
		    WorkWindow.refreshtitle
		    objects.unselectall
		    CurrentItemToSet=1
		    Finished = true
		  else
		    currenthighlightedshape = nil
		    super.EndOperation
		  end if
		  
		  objects.unhighlightall
		  can.refreshbackground
		  MacInfo = new MacConstructionInfo(Mac)
		  Mac.MacInf = MacInfo
		  Redim MacId(-1)
		  Redim Real(-1)
		  Redim RealSide(-1)
		  can.mousecursor = System.Cursors.StandardPointer
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExecuteMacro(Temp as XMLElement)
		  
		  dim EL as XMLElement  'on exécute une sous-macro d'une macro
		  dim i, oper as integer
		  
		  if Temp = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil Temp")
		    return
		  end if
		  for i = 0 to Temp.Childcount-1  // i : numéro de l'opération
		    EL = XMLElement(Temp.Child(i))
		    if EL = nil then
		      System.DebugLog(CurrentMethodName + ": skip nil EL i=" + Str(i))
		      Continue For
		    end if
		    if EL.Name = Dico.Value("Operation") then
		      oper = val(EL.GetAttribute("OpId"))
		      if codesoper.indexof(oper) <>  -1 then
		        CreateObject(EL,oper)
		      elseif oper = 17 then
		        CreateTransfo(EL,oper)
		      end if
		    end if
		  next
		  
		  endoperation
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("MacroExe ")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
	Function GetRealId(n as integer) As integer
	dim idx as integer = MacId.indexof(n)
	if idx = -1 then
	  return -1
	end if
	return Real(idx)
	  
		  Exception err
		    var d as Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("n", n)
		    err.message = err.message + d.getString
		    Raise err
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRealSide(n as integer) As integer
		  dim idx as integer = MacId.indexof(n)
		  if idx = -1 then
		    return -1
		  end if
		  if idx < 0 or idx > Ubound(RealSide) then
		    System.DebugLog(CurrentMethodName + ": skip RealSide OOB idx=" + Str(idx))
		    return -1
		  end if
		  return RealSide(idx)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim i as integer
		  dim  sh as shape
		  
		  if fa = -1 and CurrentItemToSet > 0 and Mac <> nil then
		    if CurrentItemToSet - 1 >= 0 and CurrentItemToSet - 1 <= Ubound(Mac.ObInit) then
		      fa = Mac.FaInit(CurrentItemToSet - 1)
		      fo = Mac.FoInit(CurrentItemToSet - 1)
		    end if
		  end if
		  
		  sh = operation.getshape(p)
		  if sh = nil or visible = nil or visible.count = 0 then
		    return nil
		  end if
		  
		  str = lowercase(identifier(fa, fo))
		  
		  nobj = visible.count-1
		  redim index(-1)
		  redim index(nobj)
		  
		  for i =  visible.count-1 downto 0
		    if i < 0 or i >= visible.count then
		      Continue For
		    end if
		    sh = visible.item(i)
		    if sh = nil then
		      Continue For
		    end if
		    side = sh.pointonside(p)
		    if not SelectionnerObjetIni(sh,p) then
		      visremove(sh)
		    else
		      if i >= 0 and i <= Ubound(index) then
		        index(i) = sh.pointonside(p)
		      end if
		    end if
		  next
		  
		  if visible.count = 0 then
		    return nil
		  end if
		  if iobj < 0 or iobj >= visible.count then
		    System.DebugLog(CurrentMethodName + ": reset invalid iobj=" + Str(iobj))
		    iobj = 0
		  end if
		  		  
		  sh = visible.item(iobj)
		  if sh = nil then
		    return nil
		  end if
		  side = sh.pointonside(p)
		  
		  return sh
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IdentifyPoints(newshape as shape, ifmac as InfoMac, EL0 as XMLElement)
		  
		  dim EL1, EL2 as XMLElement
		  dim j, m,  num as integer
		  dim ifm as infomac
		  dim pt as point
		  
		  if newshape = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil newshape")
		    return
		  end if
		  if ifmac = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil ifmac")
		    return
		  end if
		  if EL0 = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil EL0")
		    return
		  end if
		  EL1 = XMLElement(EL0.Child(0))   //EL1 contient la description des points de newshape
		  if EL1 = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil EL1")
		    return
		  end if
		  
		  for j = 0 to newshape.ncpts-1  //On considère les points de construction un à un
		    pt = nil
		    if j < 0 or j >= EL1.ChildCount then
		      System.DebugLog(CurrentMethodName + ": skip EL1 OOB j=" + Str(j))
		      Continue For
		    end if
		    EL2 = XMLElement(EL1.Child(j))
		    if EL2 = nil then
		      System.DebugLog(CurrentMethodName + ": skip nil EL2 j=" + Str(j))
		      Continue For
		    end if
		    if j < 0 or j > Ubound(ifmac.childs) or j > Ubound(newshape.points) then
		      System.DebugLog(CurrentMethodName + ": skip identify OOB j=" + Str(j))
		      Continue For
		    end if
		    if newshape.points(j) = nil then
		      System.DebugLog(CurrentMethodName + ": skip nil newshape.points j=" + Str(j))
		      Continue For
		    end if
		    m = val(EL2.GetAttribute("Id"))     //m est la macid  du point associé à newshape.points(j)
		    ifm = MacInfo.GetInfoMac(m,num)
		    if ifm <> nil and (ifm.init or ifm.final)   then
		      if ifm.MacId = m then
		        pt  = point(CurrentContent.TheObjects.Getshape(ifm.RealId))
		      else
		        if ifmac.childs(j) = nil then
		          System.DebugLog(CurrentMethodName + ": skip nil child j=" + Str(j))
		          Continue For
		        end if
		        pt = point(Currentcontent.TheObjects.Getshape(ifmac.childs(j).Realid))
		      end if
		      if pt <> nil and pt <> newshape.points(j) then
		        newshape.substitutepoint(pt,newshape.points(j))
		      end if
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(p as BasicPoint)
		  dim MacId as integer
		  dim sh as shape
		  
				  if Mac = nil or ubound(Mac.ObInit) = -1 then
		    return
		  end if
		  if currenthighlightedshape <> nil then
		    currenthighlightedshape.unhighlight
		    currenthighlightedshape = nil
		  end if
		  if fa = -1 and CurrentItemToSet > 0 then                               //fa = -1: sert à ne passer qu'une fois dans cette partie de la routine
				    if CurrentItemToSet-1 < 0 or CurrentItemToSet-1 > Ubound(Mac.ObInit) then
				      return
				    end if
		    MacId = Mac.ObInit(CurrentItemtoSet-1)
		    fa = Mac.FaInit(CurrentItemToSet-1)
		    fo = Mac.FoInit(CurrentItemToSet-1)
		  end if
		  currenthighlightedshape =getshape(p)
		  if currenthighlightedshape <> nil then
		    currenthighlightedshape.highlight
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  
		  'currentshape = currenthighlightedshape
		  
		  if visible  = nil or currenthighlightedshape = nil then
		    display = choose + un + " " +str
		  else
		    if currenthighlightedshape isa Lacet and side <> -1 and fa = 1 then
		      Lacet(currenthighlightedshape).paintside(g,side,2,config.highlightcolor)
		    elseif side = -1 then
		      currenthighlightedshape.highlight
		    end if
		    operation.paint(g)
		    display = this(str) + " ?"
		  end if
		  
		  Help g, display
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim  EL1, Obj as XMLElement
		  dim i, n as integer
		  dim s as shape
		  dim List as XmlNodeList
		  dim t as Boolean
		  dim Nom as string
		  
				  if Temp = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil Temp")
				    return
				  end if
				  if Temp.ChildCount = 0 then
				    System.DebugLog(CurrentMethodName + ": skip empty Temp")
				    return
				  end if
				  if App = nil or App.TheMacros = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil App/TheMacros")
				    return
				  end if
				  if currentcontent = nil or objects = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil currentcontent/objects")
				    return
				  end if
		  
		  if Temp.Child(0) = nil then
		    System.DebugLog(CurrentMethodName + ": skip nil Temp.Child(0)")
		    return
		  end if
		  Nom = Temp.child(0).GetAttribute("Name")
		  Mac = App.TheMacros.GetMacro(Nom)
		  if Mac = Nil then
				    System.DebugLog(CurrentMethodName + ": skip nil Mac")
		    return
		  end if
		  
		  currentcontent.currentoperation = new macroexe(mac)
		  MacInfo = new MacConstructionInfo(Mac)
		  Mac.MacInf = MacInfo
		  if Temp.FirstChild <> nil then
		    List = Temp.FirstChild.XQL("Initial_Forms")
		    if List <> nil and List.Length > 0 then
		      Obj= XMLElement(List.Item(0))
		      if Obj <> nil and Obj.ChildCount > 0 then
		        for i =0 to  Obj.Childcount-1
		          EL1 = XMLElement(Obj.Child(i))
		          if EL1 = nil then
		            Continue For
		          end if
		          n = val(EL1.GetAttribute("Id"))
		          s = objects.Getshape(n)
		          if s = nil then
		            System.DebugLog(CurrentMethodName + ": skip nil s n=" + Str(n))
		            Continue For
		          end if
		          t = setitem(s)
		        next
		      end if
		    end if
		  end if
		  DoOperation
		  WorkWindow.refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectionnerObjetIni(sh as shape, p as BasicPoint) As Boolean
		  dim b as Boolean
		  
				  if sh = nil then
				    System.DebugLog(CurrentMethodName + ": skip nil sh")
				    return false
				  end if
		  
		  b = (sh.fam = fa)
		  
		  select case fa     //une macro valable pour (par ex) un Triangle doit pouvoir être appliquée à un triangiso ou un triangrect ou...
		  case 1               //une macro valable pour un segment  (fa = 1, fo < 3) doit pouvoir être appliquée à un côté de polygone
		    select case fo
		    case 0
		      b = (b and sh.forme <3) or  sh.validsegment(p, side)
		    case 1, 2, 4, 5, 6, 7, 8
		      b = b and (sh.forme = fo)
		    case 3
		      b = b and ((sh.forme >2)  and  (sh.forme < 6))
		    end select
		  case 2
		    select case fo
		    case 0
		      b = b or (sh isa polreg and sh.npts = 3)
		    case 1
		      b =( b and ((sh.forme =1) or (sh.forme = 2)or (sh.forme = 4))) or (sh isa polreg and sh.npts = 3)
		    case 2
		      b = (b and  (sh.forme = 2)) or ( sh isa polreg and sh.npts = 3)
		    case 3, 4
		      b = b and  (sh.forme = fo)
		    end select
		  case 3
		    select case fo
		    case 0
		      b = b or  (sh isa polreg and sh.npts = 4)
		    case 1
		      b = b and (sh.forme > 0) 'and (sh.forme < 4)
		    case 2
		      b = ( b and (sh.forme  =2 or sh.forme = 5 or sh.forme = 7)) or  (sh isa polreg and sh.npts = 4)
		    case 3
		      b = (b and (sh.forme > 2)) or  (sh isa polreg and sh.npts = 4)
		    case 4
		      b = b and (sh.forme >= 4)
		    case 5
		      b = (b and (sh.forme = 5 or sh.forme = 7)) or  (sh isa polreg and sh.npts = 4)
		    case 6, 7
		      b = (b and sh.forme = fo) or (sh isa polreg and sh.npts = 4)
		    end select
		  case 4, 5, 6
		    b = b and sh.forme = fo
		  end select
		  
		  return b
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(s as shape) As Boolean
		  //Les deux infos doivent toujours être lues ensemble: l'id de l'objet choisi et le numéro de côté (0 s'il n'y en a qu'un)
		  
		  if not currentcontent.macrocreation then
		    if Mac.MacInf = nil then
		      Mac.MacInf = new MacConstructionInfo(Mac)
		    end if
		    MacInfo = Mac.MacInf
		    Mac.MacInf.RealInit.append s.id
		    Mac.MacInf.RealInitSide.append side
		    objects.unhighlightall
		  else
		    MacId.append Mac.ObInit(CurrentItemtoSet-1)
		    Real.append s.id
		    RealSide.append side
		  end if
		  
		  fa = -1
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument, EL as XMLElement) As XMLElement
		  dim EL0, EL1, EL2 ,Temp as XMLElement
		  dim i as integer
		  dim s as shape
		  
		  EL0 = Doc.CreateElement(Dico.Value("Forms"))
		  
		  for i = 0 to ubound(MacInfo.RealFinal)
		    s = Objects.Getshape(MacInfo.RealFinal(i))
		    EL0.appendchild s.XMLPutIdInContainer(Doc)
		  next
		  EL.appendchild EL0
		  
		  EL.AppendChild MacInfo.ToMac(Doc)
		  return EL
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  dim EL0, EL1 as XMLElement
		  dim i as integer
		  dim s as shape
		  
		  EL0 = Doc.CreateElement(Dico.Value("Macro"))
		  EL0.setAttribute("Name", Mac.Caption)
		  EL1 =  Doc.CreateElement("Initial_Forms")
		  for i = 0 to ubound(MacInfo.RealInit)
		    s = Objects.Getshape(MacInfo.RealInit(i))
		    EL1.appendchild s.XMLPutIdInContainer(Doc)
		  next
		  EL0.appendchild EL1
		  EL1 =  Doc.CreateElement("Final_Forms")
		  for i = 0 to ubound(MacInfo.RealFinal)
		    s = Objects.Getshape(MacInfo.RealFinal(i))
		    EL1.appendchild s.XMLPutIdInContainer(Doc)
		  next
		  EL0.appendchild EL1
		  return EL0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim  EL1, Obj as XMLElement
		  dim i, n as integer
		  dim s as shape
		  dim List as XmlNodeList
		  
		  List = Temp.FirstChild.XQL("Final_Forms")
		  
		  If list.Length > 0 then
		    Obj= XMLElement(List.Item(0))
		    if obj.childcount > 0 then
		      for i = Obj.Childcount-1 downto 0
		        EL1 = XMLElement(Obj.Child(i))
		        n = val(EL1.GetAttribute("Id"))
		        s = objects.Getshape(n)
		        s.delete
		      next
		    end if
		  end if
		  ReDeleteCreatedFigures (Temp)
		  RecreateDeletedFigures(Temp)
		  WorkWindow.refresh
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		codesoper(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		curop As MacroExe
	#tag EndProperty

	#tag Property, Flags = &h0
		fa As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		fo As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Histo As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		Mac As Macro
	#tag EndProperty

	#tag Property, Flags = &h0
		MacId(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		MacInfo As MacConstructionInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		Real(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RealSide(-1) As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		str As string
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="canceling"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsep"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentItemToSet"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fa"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
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
			Name="HistId"
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
			Name="info"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
			Visible=false
			Group="Behavior"
			InitialValue="0"
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
			Name="nobj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ntsf"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="str"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
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
