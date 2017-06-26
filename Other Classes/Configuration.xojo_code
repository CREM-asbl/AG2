#tag Class
Protected Class Configuration
	#tag Method, Flags = &h0
		Sub ChargerBoutons(El as XMLElement)
		  MvBt(0) = EL.XQL("Modify").length > 0
		  MvBt(1) = EL.XQL("Slide").length > 0
		  MvBt(2) = EL.XQL("Turn").length > 0
		  MvBt(3) = EL.XQL("Return").length > 0
		  MvBt(4) = EL.XQL("Zoom").length > 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChargerConfig()
		  dim List as XMLNodeList
		  dim i,j,k as integer
		  dim C as XMLDocument
		  dim El,temp as  XMLElement
		  dim fi as FolderItem
		  
		  
		  if oldMenu = Menu then
		    return
		  end if
		  
		  select case Menu
		  case "Menu_A"
		    C=new XMLDocument(Menu_A)
		  case "Menu_B"
		    C = new XMLDocument(Menu_B)
		  case "Menu_C"
		    C=new XMLDocument(Menu_C)
		  case "Menu_AB"
		    C = new XMLDocument(Menu_AB)
		  case "Menu_AC"
		    C = new XMLDocument(Menu_AC)
		  else
		    fi = app.MenusFolder.Child(Menu+".men")
		    if not  fi.exists  then
		      MsgBox  Dico.Value("Cfg") +  " " + Menu + " " + Dico.Value("Introuvable")
		      quit
		    else
		      C=new XMLDocument(fi)
		    end if
		  end select
		  El = C.DocumentElement
		  
		  ChargerMenu(El)
		  ChargerBoutons(El)
		  
		  ShowTools = EL.XQL("FreeForms").length > 0
		  ShowStdTools = EL.XQL("StdForms").length > 0
		  
		  GridPointsSize = 1
		  List = EL.XQL("DistanceMagnetisme")
		  if List.length > 0 then
		    Temp = XMLElement(List.Item(0))
		    MagneticDist= Val(Temp.GetAttribute("Value"))
		  else
		    MagneticDist = 8
		  end if
		  
		  if ShowStdTools then
		    List = EL.XQL("StdFile")
		    if List.Length > 0 then
		      Temp = XMLElement(List.Item(0))
		      StdFile = Temp.GetAttribute("Name")
		      ChargerStdForms
		    else
		      ShowStdTools = false
		    end if
		  end if
		  
		  ChargerLibForms(El)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChargerLibForms(El as XMLElement)
		  ' todo : (peut-être même un module)
		  dim i, j,k,n as integer
		  dim List as XMLNodeList
		  dim Temp as XMLElement
		  dim Names(-1) as string
		  
		  
		  Libfamilies(0,0) = "Point"
		  nlibf(0)=0
		  
		  Names = Array("Segment", "SegParall", "SegPerp", "Droite", "DroiteParall", "DroitePerp", "DemiDroite", "Bande", "Secteur")
		  nlibf(1)=8
		  for j = 0 to nlibf(1)
		    Libfamilies(1,j)=Names(j)
		  next
		  
		  Names = Array("Triang", "TriangIso", "TriangEqui", "TriangRect", "TriangRectIso")
		  nlibf(2)=4
		  for j = 0 to nlibf(2)
		    Libfamilies(2,j)=Names(j)
		  next
		  
		  Names = Array("Quadri","Trap","TrapRect","TrapIso","Parallelogram","Rect","Losange","Carre")
		  nlibf(3)=7
		  for j = 0 to nlibf(3)
		    Libfamilies(3,j)=Names(j)
		  next
		  
		  Names = Array("TriangEqui","Carre","PentaReg","HexaReg","HeptaReg","OctoReg","EnneaReg","DecaReg","UndecaReg","DodecaReg")
		  nlibf(4)=9
		  for j = 0 to nlibf(4)
		    Libfamilies(4,j)=Names(j)
		  next
		  
		  Names = Array("FreeCircle", "Arc","DSect")
		  nlibf(5)=2
		  for j = 0 to nlibf(5)
		    Libfamilies(5,j)=Names(j)
		  next
		  
		  Names = Array("Triang","Quadri","Penta","Hexa","Hepta","Octo","Ennea","Deca","Undeca","Dodeca")
		  nlibf(6)=9
		  for j = 0 to nlibf(6)
		    Libfamilies(6,j)=Names(j)
		  next
		  
		  
		  
		  for i = 0 to 6
		    for j = 0 to nlibf(i)
		      Libvisible(i,j) = false
		    next
		    nlibvis(i) = false
		  next
		  
		  if ShowTools then
		    LibVisible(0,0) = true
		    nlibvis(0) = true
		    for i = 1 to 6
		      List=EL.XQL("Fam"+str(i))
		      n =list.length
		      If list.Length > 0 then
		        for j =  0 to n-1
		          Temp = XMLElement(List.Item(j))
		          k = val(Temp.GetAttribute("Vis"))
		          Libvisible(i,k) = true
		        next
		      end if
		      UpdateNlibVis(i)
		    next
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChargerMenu(El As XMLElement)
		  dim mmenubar as MenuItem
		  
		  'un moyen plus propre ?
		  mmenubar = MenuMenus
		  
		  mmenubar.Child("EditMenu").Child("EditUndo").checked = El.XQL("Undo").length > 0
		  mmenubar.Child("EditMenu").Child("EditRedo").checked = El.XQL("Redo").length > 0
		  mmenubar.Child("EditMenu").Child("EditCopy").checked = El.XQL("Copy").length > 0
		  mmenubar.Child("EditMenu").Child("EditPaste").checked = El.XQL("Paste").length > 0
		  mmenubar.Child("EditMenu").Child("EditSelection").checked = El.XQL("Selection").length > 0
		  mmenubar.Child("EditMenu").Child("EditReSelect").checked = El.XQL("Reselect").length > 0
		  mmenubar.Child("EditMenu").Child("EditSelectall").checked = El.XQL("Selectall").length > 0
		  mmenubar.Child("EditMenu").Child("EditDelete").checked = El.XQL("Delete").length > 0
		  mmenubar.Child("EditMenu").Child("EditLink").checked = El.XQL("Link").length > 0
		  mmenubar.Child("EditMenu").Child("EditUnlink").checked = El.XQL("Link").length > 0
		  
		  mmenubar.Child("ToolsMenu").Child("ToolsColor").Child("ToolsColorBorder").checked = El.XQL("ColBorder").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsColor").Child("ToolsColorFill").checked = El.XQL("ColFill").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsColor").Child("ToolsColorStdFam").checked = El.XQL("ColStdFam").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsColorTransparent").checked = El.XQL("ColTsp").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsColorTransparent").Child("ToolsOpq").checked = El.XQL("ColTsp").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsColorTransparent").Child("ToolsSTsp").checked = El.XQL("ColTsp").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsColorTransparent").Child("ToolsTsp").checked = El.XQL("ColTsp").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsThickness").Child("ToolsThick1").checked = El.XQL("Thickness").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsThickness").Child("ToolsThick2").checked = El.XQL("Thickness").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsHide").checked = El.XQL("Hide").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsRigid").checked = El.XQL("Rigid").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsGrid").checked = El.XQL("Grid").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsHisto").checked = El.XQL("Histo").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsARPlan").checked = El.XQL("AVPlan").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsAVPlan").checked = El.XQL("AVPlan").length > 0
		  mmenubar.Child("ToolsMenu").Child("ToolsLabel").checked = El.XQL("Label").length > 0
		  
		  mmenubar.Child("MacrosMenu").Child("MacrosLoad").checked = El.XQL("Macros").length > 0
		  mmenubar.Child("MacrosMenu").Child("MacrosCreate").checked = El.XQL("Macros").length > 0
		  
		  mmenubar.Child("OperaMenu").Child("OperaDivide").checked = El.XQL("Divide").length > 0
		  mmenubar.Child("OperaMenu").Child("OperaCut").checked = El.XQL("Cut").length > 0
		  mmenubar.Child("OperaMenu").Child("OperaMerge").checked = El.XQL("Merge").length > 0
		  mmenubar.Child("OperaMenu").Child("OperaClone").checked = El.XQL("Cloner").length > 0
		  mmenubar.Child("OperaMenu").Child("OperaIdentify").checked = El.XQL("Identify").length > 0
		  mmenubar.Child("OperaMenu").Child("OperaProl").checked = El.XQL("Prolonger").length > 0
		  mmenubar.Child("OperaMenu").Child("OperaCreateCenter").checked = El.XQL("CreateCenter").length > 0
		  
		  mmenubar.Child("TransfosMenu").Child("TransfosAppliquer").checked = El.XQL("Transformations").length > 0
		  mmenubar.Child("TransfosMenu").Child("TransfosDefine").child("DefinirTranslation").checked = El.XQL("Translation").length > 0
		  mmenubar.Child("TransfosMenu").Child("TransfosDefine").Child("DefinirRotation").checked = El.XQL("Rotation").length > 0
		  mmenubar.Child("TransfosMenu").Child("TransfosDefine").Child("DefinirQuartD").checked = El.XQL("Rot90D").length > 0
		  mmenubar.Child("TransfosMenu").Child("TransfosDefine").Child("DefinirQuartG").checked = El.XQL("Rot90G").length > 0
		  mmenubar.Child("TransfosMenu").Child("TransfosDefine").Child("DefinirDemitour").checked = El.XQL("SymCentrale").length > 0
		  mmenubar.Child("TransfosMenu").Child("TransfosDefine").Child("Definirsymetrieaxiale").checked = El.XQL("SymOrtho").length > 0
		  mmenubar.Child("TransfosMenu").Child("TransfosDefine").Child("DefinirSimilitude").checked = El.XQL("Similitude").length > 0
		  mmenubar.Child("TransfosMenu").Child("TransfosDefine").Child("DefinirHomothetie").checked = El.XQL("Homothetie").length > 0
		  mmenubar.Child("TransfosMenu").Child("TransfosDefine").Child("DefinirEtirement").checked = El.XQL("Etirement").length > 0
		  mmenubar.Child("TransfosMenu").Child("TransfosDefine").Child("DefinirDeplacement").checked = El.XQL("Deplacement").length > 0
		  mmenubar.Child("TransfosMenu").Child("TransfosDefine").Child("DefinirCisaillement").checked = El.XQL("Cisaillement").length > 0
		  mmenubar.Child("TransfosMenu").Child("TransfosHide").checked = El.XQL("HideTsf").length > 0
		  mmenubar.Child("TransfosMenu").Child("TransfosFixedPoints").checked = El.XQL("PtsFix").length > 0
		  mmenubar.Child("TransfosMenu").Child("InvCurve").checked = El.XQL("InvCurve").length > 0
		  
		  mmenubar.Child("PrefsMenu").Child("Fonds").Child("Install").checked =true
		  mmenubar.Child("PrefsMenu").Child("Fonds").Child("UnInstall").checked =true
		  mmenubar.Child("PrefsMenu").Child("PrefsStdForms").checked = El.XQL("StdForms").length > 0
		  mmenubar.Child("PrefsMenu").Child("PrefsTrace").checked = El.XQL("Traj").length > 0
		  mmenubar.Child("PrefsMenu").Child("PrefsMagDist").checked = El.XQL("DistanceMagnetisme").length > 0
		  mmenubar.Child("PrefsMenu").Child("PrefsThickness").checked = El.XQL("Thickness").length > 0
		  mmenubar.Child("PrefsMenu").Child("PrefsPolyg").checked  = El.XQL("Pointer").length > 0
		  mmenubar.Child("PrefsMenu").Child("PrefsBiface").checked =  El.XQL("Biface").length > 0
		  mmenubar.Child("PrefsMenu").Child("PrefsAjust").checked =  El.XQL("Ajuster").length > 0
		  mmenubar.Child("PrefsMenu").Child("PrefsFleches").checked = El.XQL("Flecher").length > 0
		  mmenubar.Child("PrefsMenu").Child("PrefsUL").child("PrefsULDef").checked = true
		  mmenubar.Child("PrefsMenu").Child("PrefsUL").child("PrefsULChoix").checked = true
		  mmenubar.Child("PrefsMenu").Child("PrefsUA").child("PrefsUADef").checked = true
		  mmenubar.Child("PrefsMenu").Child("PrefsUA").child("PrefsUAChoix").checked = true
		  mmenubar.Child("PrefsMenu").Child("PrefsArea").checked = El.XQL("Area").length >0
		  mmenubar.Child("PrefsMenu").Child("PrefsArea").child("PrefsAreaArith").checked= El.XQL("Area").length >0
		  mmenubar.Child("PrefsMenu").Child("PrefsArea").child("PrefsAreaAlg").checked = El.XQL("Area").length >0
		  
		  mmenubar.Child("HelpMenu").Child("HelpView").checked = true
		  mmenubar.Child("HelpMenu").Child("HelpVisit").checked = true
		  mmenubar.Child("HelpMenu").Child("HelpAbout").checked = true
		  mmenubar.Child("HelpMenu").Child("HelpUG").checked = true
		  
		  mmenubar.Child("NotesMenu").Child("NotesOpen").checked = El.XQL("Notes").length > 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChargerStdForms()
		  dim fi as FolderItem
		  dim Doc As XMLDocument
		  dim List, Famlist, FormList as XMLNodeList
		  dim EL, CurFig, EL1, EL2,EL3 as XMLElement
		  dim h,i,j,k,nrep as Integer
		  dim CurSpecs as StdPolygonSpecifications
		  
		  if not ShowStdTools then
		    return
		  end if
		  
		  select case stdfile
		  case "Jeu_de_base.std"
		    Doc=new XMLDocument(jeu_de_base)
		  case "Jeu_reduit.std"
		    Doc = new XMLDocument(jeu_reduit)
		  case "Polyminos.std"
		    Doc=new XMLDocument(polyminos)
		  case "Reglettes.std", "Rods.std"
		    Doc = new XMLDocument(reglettes)
		  case "Tangram.std"
		    Doc = new XMLDocument(tangram)
		  case "Cubes.std"
		    Doc = new XMLDocument(cubes)
		  case "Etoiles.std"
		    Doc = new XMLDocument(etoiles)
		  else
		    fi = app.StdFolder.Child(stdfile)
		    if not fi.exists then
		      MsgBox Dico.Value("FileMenu") + " " + stdfile + Dico.Value("Introuvable")
		      return
		    end if
		    Doc=new XMLDocument(fi)
		  end select
		  
		  EL = Doc.DocumentElement
		  Famlist = EL.XQL("Famille")
		  NstdFam = Famlist.Length
		  if nstdfam > 4 then
		    MsgBox  TooManyFiles(stdfile) + EndOfLine + only4
		    nstdfam = 4
		  end if
		  
		  for i = 0 to nstdfam-1
		    EL1 = XMLElement(Famlist.Item(i))
		    NamesStdFamilies(i)=EL1.GetAttribute("Nom")
		    List = EL1.XQL("Couleur")
		    if List.length > 0 then
		      EL2 = XMLElement(List.Item(0))
		      StdColor(i)=new Couleur(EL2)
		    end if
		    FormList = EL1.XQL("Forme")
		    Nstdf(i) = FormList.length
		    for j=0 to nstdf(i)-1
		      Curfig = XMLElement(FormList.Item(j))
		      CurSpecs=new StdPolygonSpecifications
		      Curspecs.NonPointed = val(Curfig.GetAttribute("NonPointed"))  // 0 ou 1
		      Curspecs.family = NamesStdFamilies(i)
		      CurSpecs.name=CurFig.GetAttribute("Nom")
		      List = Curfig.XQL("Couleur")
		      if List.length >0 then
		        EL3 =  XMLElement(List.Item(0))
		        Curspecs.coul = new Couleur(EL3)
		      else
		        curspecs.coul = stdcolor(i)
		      end if
		      List = Curfig.XQL("Arete")
		      for k=0 to List.Length-1
		        EL3 = XMLElement(List.Item(k))
		        nrep = Val(EL3.GetAttribute("Repete"))
		        if nrep = 0 then
		          nrep = 1
		        end if
		        for h = 0 to nrep-1
		          Curspecs.Distances.append Val(EL3.GetAttribute("Longueur"))
		          Curspecs.Angles.append Val(EL3.GetAttribute("Angle"))*PI/180
		        next
		      next
		      StdFamilies(i,j) = Curspecs
		    next
		  next
		  if wnd <> nil then
		    wnd.ClearStdBox
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ConfigElem(m as string, sm as string, tag as string) As XMLNode
		  if MenuMenus.Child(m).Child(sm).checked then
		    return CFG.CreateElement(tag)
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ConfigElem3(m as string, sm as string, ssm as string, tag as string) As XMLNode
		  if MenuMenus.Child(m).Child(sm).Child(ssm).checked then
		    return CFG.CreateElement(tag)
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ConfigElem4(m as string, sm as string, ssm as string, sssm as string, tag as string) As XMLNode
		  if MenuMenus.Child(m).Child(sm).Child(ssm).Child(sssm).checked then
		    return CFG.CreateElement(tag)
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  dim fi  As folderItem
		  dim C as XMLDocument
		  dim El,El1 as XMLNode
		  dim El2 as XMLTextNode
		  dim List as XMLNodeList
		  dim lastmaj,f() as String
		  
		  initParams
		  fi=app.DocFolder.Child("AG_Init.xml")
		  
		  password = hash("")
		  
		  if fi.exists then
		    try
		      C=new XMLDocument(fi)
		    catch err as XmlException
		      Save
		      return
		    end try
		    List = C.XQL("AG_Init")
		    if List.Length>0 then
		      EL = List.Item(0)
		      List = EL.XQL("Password")
		      EL1= List.Item(0)
		      if El1<>nil then
		        El2=XMLTextNode(El1.FirstChild)
		        if El2<>nil then
		          if EL2.Value <> "" then
		            setPassword(El2.Value)
		          end if
		        end if
		      end if
		    end if
		    
		    List = EL.XQL("Language")
		    if List.Length>0 then
		      EL1 = List.Item(0)
		      if EL1 <> nil then
		        El2=XMLTextNode(El1.FirstChild)
		        if El2 <> nil then
		          setLangue( EL2.Value)
		        else
		          setLangue("Francais")
		        end if
		      end if
		    end if
		    
		    List = EL.XQL("Configuration")
		    if List.Length>0 then
		      EL1 = List.Item(0)
		      if EL1 <> nil then
		        El2=XMLTextNode(El1.FirstChild)
		        if El2 <> nil then
		          setMenu( EL2.Value)
		        else
		          setMenu("Menu_AC")
		        end if
		      end if
		    end if
		    
		    List = EL.XQL("StdSize")
		    if List.Length>0 then
		      EL1 = List.Item(0)
		      if EL1 <> nil then
		        El2=XMLTextNode(El1.FirstChild)
		        if El2 <> nil then
		          StdSize = val(EL2.Value)
		        else
		          StdSize =1
		        end if
		      end if
		    end if
		    
		    List = EL.XQL("LastInfo")
		    if List.Length>0 then
		      EL1 = List.Item(0)
		      if EL1 <> nil then
		        El2=XMLTextNode(El1.FirstChild)
		        if EL2 <> nil then
		          lastinfo =  EL2.Value
		        end if
		      end if
		    end if
		  else
		    'Si AG_Init n'existe pas, on le recrée"
		    setLangue("Francais")
		    Menu = "Menu_AC"
		    StdSize = 1
		    Save
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetMenuItem(menu as string, sousmenu as string) As boolean
		  return MenuMenus.Child(menu).Child(sousmenu).checked
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub initParams()
		  HideColor = BleuPale
		  HighLightColor=magenta
		  WeightlessColor=Blue
		  Bordercolor= Black
		  Fillcolor=White
		  TransfoColor = Green
		  Border = 100
		  Fill = 0
		  Thickness = 1.5
		  ShowHelp = true
		  trace = true
		  ajust = true
		  stdbiface = false
		  PolPointes = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Save()
		  dim fi As FolderItem
		  dim tos as TextOutputStream
		  dim Doc as XMLDocument
		  dim temp,EL, EL1, EL2,EL3, EL4 as XMLNode
		  
		  'save pourAG_init
		  
		  //création du document XML
		  
		  Doc=new XMLDocument
		  temp = Doc.appendChild(Doc.CreateElement("AG_Init"))
		  
		  EL = temp.appendChild(Doc.CreateElement("Password"))
		  EL.AppendChild(Doc.CreateTextNode(Password))
		  
		  
		  EL1 = temp.appendChild(Doc.CreateElement("Language"))
		  EL1.AppendChild(Doc.CreateTextNode(Langue))
		  
		  EL2 = temp.appendchild(Doc.CreateElement("Configuration"))
		  EL2.AppendChild(Doc.CreateTextNode(Menu))
		  
		  EL3 = temp.appendchild(Doc.CreateElement("StdSize"))
		  EL3.AppendChild(Doc.CreateTextNode(str(StdSize)))
		  
		  EL4 = temp.appendchild(Doc.CreateElement("LastInfo"))
		  EL4.AppendChild(Doc.CreateTextNode(lastinfo))
		  
		  
		  //enregistrement du document XML
		  fi=app.DocFolder.Child("AG_Init.xml")
		  tos=fi.CreateTextFile
		  if tos =nil then
		    MsgBox Dico.Value("AGInitNotUpdatable")
		  else
		    tos.write(Doc.ToString)
		    tos.close
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveToFile()
		  dim fi as FolderItem
		  
		  if Menu <> "" then
		    fi=app.MenusFolder.Child(Menu+".men")
		    ToXML.SaveXML fi
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetLangue(NewLang as string)
		  if Langue <> NewLang then
		    OldLangue = Langue
		    if NewLang = "" then
		      NewLang = "Francais" 'pas de caractères spéciaux pour nom de fichier
		    end if
		    Langue = NewLang
		    Dico.load(Langue)
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setMenu(m as string)
		  oldMenu = Menu
		  if m = "" then
		    m  = "Menu_AC"
		  end if
		  Menu = m
		  ChargerConfig
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setPassword(pass as string)
		  Password = pass
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetStdFile(file as string)
		  stdfile = file
		  ChargerStdForms
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setUser(u as string)
		  User = u
		  if User = "prof" then
		    username = Dico.Value("Enseignant")
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToggleFLib(fam as integer)
		  dim i as integer
		  
		  nlibvis(fam) = not nlibvis(fam)
		  
		  for i=0 to nlibf(fam)
		    Libvisible(fam,i) = nlibvis(fam)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToggleLibVisible(fam as integer, shape as integer)
		  Libvisible(fam,shape) = not Libvisible(fam,shape)
		  UpdateNLibVis(fam)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TooManyFiles(s as string) As string
		  return thefile + stdfile +toomanyfamilies
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml() As XMLDocument
		  dim temp, EL as XMLNode
		  dim i, j as integer
		  
		  CFG = New XmlDocument
		  
		  
		  temp = CFG.AppendChild(CFG.CreateElement("Configuration"))
		  
		  temp.AppendChild ConfigElem("EditMenu","EditUndo","Undo")
		  temp.AppendChild ConfigElem("EditMenu","EditRedo","Redo")
		  temp.AppendChild ConfigElem("EditMenu","EditCopy","Copy")
		  temp.AppendChild ConfigElem("EditMenu","EditPaste","Paste")
		  temp.AppendChild ConfigElem("EditMenu","EditSelection","Selection")
		  temp.AppendChild ConfigElem("EditMenu","EditReselect","Reselect")
		  temp.AppendChild ConfigElem("EditMenu","EditSelectall","Selectall")
		  temp.AppendChild ConfigElem("EditMenu","EditDelete","Delete")
		  temp.AppendChild ConfigElem("EditMenu","EditLink","Link")
		  
		  temp.AppendChild ConfigElem("ToolsMenu","ToolsColorTransparent","ColTsp")
		  temp.AppendChild ConfigElem3("ToolsMenu","ToolsColor", "ToolsColorBorder","ColBorder")
		  temp.AppendChild ConfigElem3("ToolsMenu","ToolsColor", "ToolsColorFill","ColFill")
		  temp.AppendChild ConfigElem3("ToolsMenu","ToolsColor", "ToolsColorStdFam","ColStdFam")
		  
		  if  MenuMenus.Child("ToolsMenu").Child("ToolsThickness").Child("ToolsThick1").checked  then
		    temp.appendchild CFG.CreateElement("Thickness")
		  end if
		  temp.AppendChild ConfigElem("ToolsMenu","ToolsRigid","Rigid")
		  temp.AppendChild ConfigElem("ToolsMenu","ToolsHide","Hide")
		  temp.AppendChild ConfigElem("ToolsMenu","ToolsGrid","Grid")
		  temp.AppendChild ConfigElem("ToolsMenu","ToolsHisto","Histo")
		  temp.AppendChild ConfigElem("ToolsMenu","ToolsAVPlan","AVPlan")
		  temp.AppendChild ConfigElem("ToolsMenu","ToolsLabel","Label")
		  
		  temp.appendchild ConfigElem("MacrosMenu", "MacrosLoad", "Macros")
		  
		  temp.AppendChild ConfigElem("OperaMenu","OperaDivide","Divide")
		  temp.AppendChild ConfigElem("OperaMenu","OperaCut","Cut")
		  temp.AppendChild ConfigElem("OperaMenu","OperaMerge","Merge")
		  temp.AppendChild ConfigElem("OperaMenu","OperaClone","Cloner")
		  temp.AppendChild ConfigElem("OperaMenu","OperaProl","Prolonger")
		  temp.AppendChild ConfigElem("OperaMenu","OperaCreateCenter","CreateCenter")
		  temp.AppendChild ConfigElem("OperaMenu","OperaIdentify","Identify")
		  
		  temp.AppendChild ConfigElem("TransfosMenu","TransfosAppliquer","Transformations")
		  temp.AppendChild ConfigElem4("TransfosMenu","TransfosDefine", "DefinirIso","DefinirTranslation","Translation")
		  temp.AppendChild ConfigElem4("TransfosMenu","TransfosDefine", "DefinirIso","DefinirRotation","Rotation")
		  temp.AppendChild ConfigElem4("TransfosMenu","TransfosDefine", "DefinirIso","DefinirQuartD","Rot90D")
		  temp.AppendChild ConfigElem4("TransfosMenu","TransfosDefine", "DefinirIso", "DefinirQuartG","Rot90G")
		  temp.AppendChild ConfigElem4("TransfosMenu","TransfosDefine", "DefinirIso", "DefinirDemitour","SymCentrale")
		  temp.AppendChild ConfigElem4("TransfosMenu","TransfosDefine", "DefinirIso","Definirsymetrieaxiale","SymOrtho")
		  temp.AppendChild ConfigElem4("TransfosMenu","TransfosDefine", "DefinirSimi", "DefinirHomothetie","Homothetie")
		  temp.AppendChild ConfigElem4("TransfosMenu","TransfosDefine", "DefinirSimi","DefinirSimilitude","Similitude")
		  temp.AppendChild ConfigElem4("TransfosMenu","TransfosDefine", "DefinirIso","DefinirDeplacement","Deplacement")
		  temp.AppendChild ConfigElem4("TransfosMenu","TransfosDefine", "DefinirAffi","DefinirEtirement","Etirement")
		  temp.AppendChild ConfigElem4("TransfosMenu","TransfosDefine", "DefinirAffi","DefinirCisaillement","Cisaillement")
		  
		  temp.AppendChild ConfigElem("TransfosMenu","TransfosFixedPoints","PtsFix")
		  temp.AppendChild ConfigElem("TransfosMenu","TransfosHide","HideTsf")
		  
		  
		  temp.AppendChild ConfigElem("PrefsMenu","PrefsStdForms", "StdForms")
		  temp.AppendChild ConfigElem("PrefsMenu","PrefsFleches", "Flecher")
		  temp.AppendChild ConfigElem("PrefsMenu","PrefsTrace", "Traj")
		  temp.AppendChild ConfigElem("PrefsMenu","PrefsPolyg", "Pointer")
		  temp.AppendChild ConfigElem("PrefsMenu","PrefsBiface", "Biface")
		  temp.AppendChild ConfigElem("PrefsMenu","PrefsAjust", "Ajuster")
		  
		  EL = ConfigElem("PrefsMenu","PrefsMagDist", "DistanceMagnetisme")
		  if EL <> nil then
		    EL.setattribute("Value", str(MagneticDist))
		    temp.appendchild EL
		  end if
		  
		  temp.AppendChild ConfigElem("HelpMenu","HelpView", "View")
		  temp.AppendChild ConfigElem("HelpMenu","HelpVisit", "Visit")
		  temp.AppendChild ConfigElem("HelpMenu","HelpAbout", "About")
		  temp.AppendChild ConfigElem("NotesMenu","NotesOpen", "Notes")
		  
		  
		  if ShowStdTools then
		    temp.AppendChild CFG.CreateElement("StdForms")
		    EL = CFG.CreateElement("StdFile")
		    if EL <> nil then
		      EL.SetAttribute("Name", stdfile)
		      Temp.appendchild EL
		    end if
		    EL = CFG.CreateElement("TailleFormesStandard")
		    if EL <> nil then
		      EL.SetAttribute("Value", str(stdsize))
		      Temp.appendchild EL
		    end if
		  end if
		  
		  if ShowTools then
		    temp.AppendChild CFG.CreateElement("FreeForms")
		    for i = 1 to 7
		      for j =  0 to 10
		        if LibVisible (i,j) then
		          EL = CFG.CreateElement("Fam"+str(i))
		          if EL <> nil then
		            EL.SetAttribute("Vis", str(j))
		            temp.appendchild EL
		          end if
		        end if
		      next
		    next
		  end if
		  if MvBt(0) then
		    temp.appendchild CFG.CreateElement("Modify")
		  end if
		  if MvBt(1) then
		    temp.appendchild CFG.CreateElement("Slide")
		  end if
		  if MvBt(2) then
		    temp.appendchild CFG.CreateElement("Turn")
		  end if
		  if MvBt(3) then
		    temp.appendchild CFG.CreateElement("Return")
		  end if
		  if MvBt(4) then
		    temp.appendchild CFG.CreateElement("Zoom")
		  end if
		  
		  CFG.PreserveWhitespace = true
		  return CFG
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateNLibVis(fam as integer)
		  dim i as integer
		  dim visible as Boolean
		  
		  visible = false
		  
		  for i=0 to nlibf(fam)
		    visible = visible or Libvisible(fam,i)
		  next
		  
		  nlibvis(fam) = visible
		  
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
		Ajust As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Border As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Bordercolor As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		CFG As XMLDocument
	#tag EndProperty

	#tag Property, Flags = &h0
		Fill As integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Fillcolor As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		GridPointsSize As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Hidecolor As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		HighlightColor As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		Langue As string
	#tag EndProperty

	#tag Property, Flags = &h0
		LastInfo As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Libfamilies(7,10) As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Libvisible(7,10) As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		MagneticDist As double
	#tag EndProperty

	#tag Property, Flags = &h0
		Menu As string
	#tag EndProperty

	#tag Property, Flags = &h0
		MvBt(4) As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		NamesStdFamilies(3) As string
	#tag EndProperty

	#tag Property, Flags = &h0
		nlibf(7) As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		nlibvis(7) As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		nstdf(4) As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Nstdfam As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		OldLangue As string
	#tag EndProperty

	#tag Property, Flags = &h0
		OldMenu As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Password As String
	#tag EndProperty

	#tag Property, Flags = &h0
		PolPointes As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		pwok As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ShowHelp As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ShowStdTools As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ShowTools As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		stdbiface As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Stdcolor(4) As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		StdFamilies(4,12) As StdPolygonSpecifications
	#tag EndProperty

	#tag Property, Flags = &h0
		stdfile As string
	#tag EndProperty

	#tag Property, Flags = &h0
		StdSize As integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0
		TextSize As Integer = 12
	#tag EndProperty

	#tag Property, Flags = &h0
		Thickness As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Trace As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		TransfoColor As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		user As string
	#tag EndProperty

	#tag Property, Flags = &h0
		username As String = "Historique"
	#tag EndProperty

	#tag Property, Flags = &h0
		Weightlesscolor As couleur
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Ajust"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="GridPointsSize"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Langue"
			Group="Behavior"
			InitialValue="Francais"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastInfo"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MagneticDist"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Menu"
			Group="Behavior"
			InitialValue="Menu_AC"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Nstdfam"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OldLangue"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OldMenu"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Password"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PolPointes"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="pwok"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShowHelp"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShowStdTools"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShowTools"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="stdbiface"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="stdfile"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StdSize"
			Group="Behavior"
			InitialValue="0"
			Type="integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextSize"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Thickness"
			Group="Behavior"
			InitialValue="0"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Trace"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="user"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="username"
			Group="Behavior"
			InitialValue="Historique"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
