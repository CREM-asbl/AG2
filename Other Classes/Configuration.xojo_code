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
		      ChargerStdForms(Temp.GetAttribute("Name"))
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

		  Names = Array("FreeCircle", "Arc","DSect", "HalfDsk")
		  nlibf(5)=3
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

	#tag Method, Flags = &h1
		Protected Sub SafeSetCheckMark(menu as string, submenu as string, subsubmenu as string, hasTag as boolean)
		  dim m as DesktopMenuItem
		  dim sm as DesktopMenuItem
		  dim ssm as DesktopMenuItem

		  m = MenuMenus.Child(menu)
		  if m = nil then return

		  sm = m.Child(submenu)
		  if sm = nil then return

		  if subsubmenu <> "" then
		    ssm = sm.Child(subsubmenu)
		    if ssm = nil then return
		    ssm.HasCheckMark = hasTag
		  else
		    sm.HasCheckMark = hasTag
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChargerMenu(El As XMLElement)
		  SafeSetCheckMark("EditMenu", "EditUndo", "", El.XQL("Undo").length > 0)
		  SafeSetCheckMark("EditMenu", "EditRedo", "", El.XQL("Redo").length > 0)
		  SafeSetCheckMark("EditMenu", "EditCopy", "", El.XQL("Copy").length > 0)
		  SafeSetCheckMark("EditMenu", "EditPaste", "", El.XQL("Paste").length > 0)
		  SafeSetCheckMark("EditMenu", "EditSelection", "", El.XQL("Selection").length > 0)
		  SafeSetCheckMark("EditMenu", "EditReSelect", "", El.XQL("Reselect").length > 0)
		  SafeSetCheckMark("EditMenu", "EditSelectall", "", El.XQL("Selectall").length > 0)
		  SafeSetCheckMark("EditMenu", "EditDelete", "", El.XQL("Delete").length > 0)
		  SafeSetCheckMark("EditMenu", "EditLink", "", El.XQL("Link").length > 0)
		  SafeSetCheckMark("EditMenu", "EditUnlink", "", El.XQL("Link").length > 0)

		  SafeSetCheckMark("ToolsMenu", "ToolsColorTransparent", "", El.XQL("ColTsp").length > 0)
		  SafeSetCheckMark("ToolsMenu", "ToolsColorTransparent", "ToolsOpq", El.XQL("ColTsp").length > 0)
		  SafeSetCheckMark("ToolsMenu", "ToolsColorTransparent", "ToolsSTsp", El.XQL("ColTsp").length > 0)
		  SafeSetCheckMark("ToolsMenu", "ToolsColorTransparent", "ToolsTsp", El.XQL("ColTsp").length > 0)
		  SafeSetCheckMark("ToolsMenu", "ToolsThickness", "ToolsThick1", El.XQL("Thickness").length > 0)
		  SafeSetCheckMark("ToolsMenu", "ToolsThickness", "ToolsThick2", El.XQL("Thickness").length > 0)
		  SafeSetCheckMark("ToolsMenu", "ToolsHide", "", El.XQL("Hide").length > 0)
		  SafeSetCheckMark("ToolsMenu", "ToolsRigid", "", El.XQL("Rigid").length > 0)
		  SafeSetCheckMark("ToolsMenu", "ToolsGrid", "", El.XQL("Grid").length > 0)
		  SafeSetCheckMark("ToolsMenu", "ToolsHisto", "", El.XQL("Histo").length > 0)
		  SafeSetCheckMark("ToolsMenu", "ToolsARPlan", "", El.XQL("AVPlan").length > 0)
		  SafeSetCheckMark("ToolsMenu", "ToolsAVPlan", "", El.XQL("AVPlan").length > 0)
		  SafeSetCheckMark("ToolsMenu", "ToolsLabel", "", El.XQL("Label").length > 0)

		  SafeSetCheckMark("MacrosMenu", "MacrosLoad", "", El.XQL("Macros").length > 0)
		  SafeSetCheckMark("MacrosMenu", "MacrosCreate", "", El.XQL("Macros").length > 0)

		  SafeSetCheckMark("OperaMenu", "OperaDivide", "", El.XQL("Divide").length > 0)
		  SafeSetCheckMark("OperaMenu", "OperaCut", "", El.XQL("Cut").length > 0)
		  SafeSetCheckMark("OperaMenu", "OperaMerge", "", El.XQL("Merge").length > 0)
		  SafeSetCheckMark("OperaMenu", "OperaClone", "", El.XQL("Cloner").length > 0)
		  SafeSetCheckMark("OperaMenu", "OperaIdentify", "", El.XQL("Identify").length > 0)
		  SafeSetCheckMark("OperaMenu", "OperaProl", "", El.XQL("Prolonger").length > 0)
		  SafeSetCheckMark("OperaMenu", "OperaCreateCenter", "", El.XQL("CreateCenter").length > 0)

		  SafeSetCheckMark("TransfosMenu", "TransfosAppliquer", "", El.XQL("Transformations").length > 0)
		  SafeSetCheckMark("TransfosMenu", "TransfosDefine", "DefinirTranslation", El.XQL("Translation").length > 0)
		  SafeSetCheckMark("TransfosMenu", "TransfosDefine", "DefinirRotation", El.XQL("Rotation").length > 0)
		  SafeSetCheckMark("TransfosMenu", "TransfosDefine", "DefinirQuartD", El.XQL("Rot90D").length > 0)
		  SafeSetCheckMark("TransfosMenu", "TransfosDefine", "DefinirQuartG", El.XQL("Rot90G").length > 0)
		  SafeSetCheckMark("TransfosMenu", "TransfosDefine", "DefinirDemitour", El.XQL("SymCentrale").length > 0)
		  SafeSetCheckMark("TransfosMenu", "TransfosDefine", "Definirsymetrieaxiale", El.XQL("SymOrtho").length > 0)
		  SafeSetCheckMark("TransfosMenu", "TransfosDefine", "DefinirSimilitude", El.XQL("Similitude").length > 0)
		  SafeSetCheckMark("TransfosMenu", "TransfosDefine", "DefinirHomothetie", El.XQL("Homothetie").length > 0)
		  SafeSetCheckMark("TransfosMenu", "TransfosDefine", "DefinirEtirement", El.XQL("Etirement").length > 0)
		  SafeSetCheckMark("TransfosMenu", "TransfosDefine", "DefinirDeplacement", El.XQL("Deplacement").length > 0)
		  SafeSetCheckMark("TransfosMenu", "TransfosDefine", "DefinirCisaillement", El.XQL("Cisaillement").length > 0)
		  SafeSetCheckMark("TransfosMenu", "TransfosHide", "", El.XQL("HideTsf").length > 0)
		  SafeSetCheckMark("TransfosMenu", "TransfosFixedPoints", "", El.XQL("PtsFix").length > 0)
		  SafeSetCheckMark("TransfosMenu", "InvCurve", "", El.XQL("InvCurve").length > 0)

		  SafeSetCheckMark("PrefsMenu", "Fonds", "Install", true)
		  SafeSetCheckMark("PrefsMenu", "Fonds", "FondEcranConfigurer", true)
		  SafeSetCheckMark("PrefsMenu", "Fonds", "UnInstall", true)
		  SafeSetCheckMark("PrefsMenu", "PrefsStdForms", "", El.XQL("StdForms").length > 0)
		  SafeSetCheckMark("PrefsMenu", "PrefsTrace", "", El.XQL("Traj").length > 0)
		  SafeSetCheckMark("PrefsMenu", "PrefsMagDist", "", El.XQL("DistanceMagnetisme").length > 0)
		  SafeSetCheckMark("PrefsMenu", "PrefsColor", "PrefsColorBorder", El.XQL("ColBorder").length > 0)
		  SafeSetCheckMark("PrefsMenu", "PrefsColor", "PrefsColorFill", El.XQL("ColFill").length > 0)
		  SafeSetCheckMark("PrefsMenu", "PrefsColor", "PrefsColorStdFam", El.XQL("ColStdFam").length > 0)
		  SafeSetCheckMark("PrefsMenu", "PrefsThickness", "", El.XQL("Thickness").length > 0)
		  SafeSetCheckMark("PrefsMenu", "PrefsPolyg", "", El.XQL("Pointer").length > 0)
		  SafeSetCheckMark("PrefsMenu", "PrefsBiface", "", El.XQL("Biface").length > 0)
		  SafeSetCheckMark("PrefsMenu", "PrefsAjust", "", El.XQL("Ajuster").length > 0)
		  SafeSetCheckMark("PrefsMenu", "PrefsFleches", "", El.XQL("Flecher").length > 0)
		  SafeSetCheckMark("PrefsMenu", "PrefsUL", "PrefsULDef", true)
		  SafeSetCheckMark("PrefsMenu", "PrefsUL", "PrefsULChoix", true)
		  SafeSetCheckMark("PrefsMenu", "PrefsUA", "PrefsUADef", true)
		  SafeSetCheckMark("PrefsMenu", "PrefsUA", "PrefsUAChoix", true)
		  SafeSetCheckMark("PrefsMenu", "PrefsArea", "", El.XQL("Area").length > 0)
		  SafeSetCheckMark("PrefsMenu", "PrefsArea", "PrefsAreaArith", El.XQL("Area").length > 0)
		  SafeSetCheckMark("PrefsMenu", "PrefsArea", "PrefsAreaAlg", El.XQL("Area").length > 0)

		  SafeSetCheckMark("HelpMenu", "HelpView", "", true)
		  SafeSetCheckMark("HelpMenu", "HelpVisit", "", true)
		  SafeSetCheckMark("HelpMenu", "HelpAbout", "", true)
		  SafeSetCheckMark("HelpMenu", "HelpUG", "", true)

		  SafeSetCheckMark("NotesMenu", "NotesOpen", "", El.XQL("Notes").length > 0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChargerStdForms(std as string)
		  dim fi as FolderItem
		  dim Doc As XMLDocument
		  dim List, Famlist, FormList as XMLNodeList
		  dim EL, CurFig, EL1, EL2,EL3 as XMLElement
		  dim h,i,j,k as Integer
		  dim CurSpecs as StdPolygonSpecifications

		  if not ShowStdTools then
		    return
		  end if

		  select case std
		  case "Jeu_de_base.std"
		    Doc = new XMLDocument(jeu_de_base)
		  case "Jeu_reduit.std"
		    Doc = new XMLDocument(jeu_reduit)
		  case "Polyminos.std"
		    Doc = new XMLDocument(polyminos)
		  case "Reglettes.std", "Rods.std"
		    Doc = new XMLDocument(reglettes)
		  case "Tangram.std"
		    Doc = new XMLDocument(tangram)
		  case "Cubes.std"
		    Doc = new XMLDocument(cubes)
		  case "Etoiles.std"
		    Doc = new XMLDocument(etoiles)
		  else
		    fi = app.StdFolder.Child(std)
		    if not fi.exists then
		      MsgBox Dico.Value("FileMenu") + " " + std + Dico.Value("Introuvable")
		      return
		    end if
		    Doc = new XMLDocument(fi)
		  end select

		  stdfile = std

		  EL = Doc.DocumentElement
		  Famlist = EL.XQL("Famille")
		  NstdFam = Famlist.Length
		  if nstdfam > 4 then
		    MsgBox TooManyFiles(stdfile) + EndOfLine + only4
		    nstdfam = 4
		  end if

		  for i = 0 to nstdfam-1
		    EL1 = XMLElement(Famlist.Item(i))
		    NamesStdFamilies(i) = EL1.GetAttribute("Nom")
		    List = EL1.XQL("Couleur")
		    if List.length > 0 then
		      EL2 = XMLElement(List.Item(0))
		      StdColor(i) = new Couleur(EL2)
		    end if
		    FormList = EL1.XQL("Forme")
		    Nstdf(i) = FormList.length
		    for j = 0 to nstdf(i)-1
		      Curfig = XMLElement(FormList.Item(j))
		      CurSpecs=new StdPolygonSpecifications
		      Curspecs.NonPointed = val(Curfig.GetAttribute("NonPointed"))  // 0 ou 1
		      Curspecs.family = NamesStdFamilies(i)
		      CurSpecs.name = CurFig.GetAttribute("Nom")
		      List = Curfig.XQL("Couleur")
		      if List.length > 0 then
		        EL3 = XMLElement(List.Item(0))
		        Curspecs.coul = new Couleur(EL3)
		      else
		        curspecs.coul = stdcolor(i)
		      end if
		      List = Curfig.XQL("Arete")
		      for k = 0 to List.Length-1
		        EL3 = XMLElement(List.Item(k))
		        Curspecs.Distances.append Val(EL3.GetAttribute("Longueur"))
		        Curspecs.Angles.append Val(EL3.GetAttribute("Angle"))*PI/180
		      next
		      StdFamilies(i,j) = Curspecs
		    next
		  next

		  Exception err
		    var d as Debug = new Debug
		    d.setVariable("i", i)
		    d.setVariable("j", j)
		    d.setVariable("k", k)

		    err.message = CurrentMethodName + EndOfLine + d.getString + app.ObjectToJSON(self)

		    Raise err

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ConfigElem(m as string, sm as string, tag as string) As XMLNode
		  dim menu as DesktopMenuItem
		  dim submenu as DesktopMenuItem

		  menu = MenuMenus.Child(m)
		  if menu = nil then return nil

		  submenu = menu.Child(sm)
		  if submenu = nil then return nil

		  if submenu.HasCheckMark then
		    return CFG.CreateElement(tag)
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ConfigElem3(m as string, sm as string, ssm as string, tag as string) As XMLNode
		  dim menu as DesktopMenuItem
		  dim submenu as DesktopMenuItem
		  dim subsubmenu as DesktopMenuItem

		  menu = MenuMenus.Child(m)
		  if menu = nil then return nil

		  submenu = menu.Child(sm)
		  if submenu = nil then return nil

		  subsubmenu = submenu.Child(ssm)
		  if subsubmenu = nil then return nil

		  if subsubmenu.HasCheckMark then
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

	#tag Method, Flags = &h0
		Sub CreateNewMenu(Menu as String)
		  dim fi as FolderItem

		  if Menu <> "" then
		    fi=app.MenusFolder.Child(Menu+".men")
		    ToXML.SaveXML fi
		  end if


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetMenuItem(menu as string, sousmenu as string) As boolean
		  dim m as DesktopMenuItem
		  dim sm as DesktopMenuItem

		  m = MenuMenus.Child(menu)
		  if m = nil then return false

		  sm = m.Child(sousmenu)
		  if sm = nil then return false

		  return sm.HasCheckMark
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub initParams()
		  HideColor = BleuPale
		  HighLightColor = magenta
		  WeightlessColor = Blue
		  Bordercolor = Black
		  Fillcolor = White
		  TransfoColor = Green
		  Border = 100
		  Fill = 0
		  Thickness = 1.5
		  ShowHelp = true
		  trace = true
		  ajust = true
		  ' Quatre paramètres peuvent varier d'une forme à une autre. Ils doivent être incorporés aux fichiers des formes.
		  biface = false   'Param de forme : biface
		  PolPointes = true   'Param de forme : pointe
		  PolFleches = false   ' 'Param de forme : fleche
		  area = 0                  ' 'Param de forme : area (0 ou 1)
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

EL2 = temp.AppendChild(Doc.CreateElement("Configuration"))
	  EL2.AppendChild(Doc.CreateTextNode(Menu))

	  EL3 = temp.AppendChild(Doc.CreateElement("StdSize"))
	  EL3.AppendChild(Doc.CreateTextNode(str(StdSize)))

	  EL4 = temp.AppendChild(Doc.CreateElement("LastInfo"))
		  EL4.AppendChild(Doc.CreateTextNode(lastinfo))


		  //enregistrement du document XML
		  fi=app.DocFolder.Child("AG_Init.xml")
		  tos=TextOutputStream.Create(fi)
		  if tos =nil then
		    MsgBox Dico.Value("AGInitNotUpdatable")
		  else
		    tos.write(Doc.ToString)
		    tos.close
		  end if

		  Exception err
		    err.message = err.message+CurrentMethodName+EndOfLine+app.ObjectToJSON(self)
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetLangue(NewLang as string)
		  if Langue <> NewLang and NewLang <> "" then
		    OldLangue = Langue
		    Langue = NewLang
		    if Dico.load(Langue) = false then
		      Langue = OldLangue
		    end if
		  end if


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setMenu(m as string)
		  if Menu = m then
		    return
		  end if

		  oldMenu = Menu
		  if m = "" then
		    m  = "Menu_AC"
		  end if
		  Menu = m
		  ChargerConfig
		  save

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setPassword(pass as string)
		  Password = pass

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
		  return thefile + stdfile + toomanyfamilies
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml() As XMLDocument
		  dim temp, EL as XMLNode
		  dim i, j as integer

		  CFG = New XmlDocument


		  temp = CFG.AppendChild(CFG.CreateElement("Configuration"))

		  EL = ConfigElem("EditMenu","EditUndo","Undo")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("EditMenu","EditRedo","Redo")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("EditMenu","EditCopy","Copy")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("EditMenu","EditPaste","Paste")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("EditMenu","EditSelection","Selection")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("EditMenu","EditReselect","Reselect")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("EditMenu","EditSelectall","Selectall")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("EditMenu","EditDelete","Delete")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("EditMenu","EditLink","Link")
		  if EL <> nil then temp.AppendChild EL

		  EL = ConfigElem("ToolsMenu","ToolsColorTransparent","ColTsp")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("ToolsMenu","ToolsColor", "ToolsColorBorder","ColBorder")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("ToolsMenu","ToolsColor", "ToolsColorFill","ColFill")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("ToolsMenu","ToolsColor", "ToolsColorStdFam","ColStdFam")
		  if EL <> nil then temp.AppendChild EL

		  EL = ConfigElem3("ToolsMenu","ToolsThickness","ToolsThick1","Thickness")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("ToolsMenu","ToolsRigid","Rigid")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("ToolsMenu","ToolsHide","Hide")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("ToolsMenu","ToolsGrid","Grid")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("ToolsMenu","ToolsHisto","Histo")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("ToolsMenu","ToolsAVPlan","AVPlan")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("ToolsMenu","ToolsLabel","Label")
		  if EL <> nil then temp.AppendChild EL

		  EL = ConfigElem("MacrosMenu", "MacrosLoad", "Macros")
		  if EL <> nil then temp.AppendChild EL

		  EL = ConfigElem("OperaMenu","OperaDivide","Divide")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("OperaMenu","OperaCut","Cut")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("OperaMenu","OperaMerge","Merge")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("OperaMenu","OperaClone","Cloner")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("OperaMenu","OperaProl","Prolonger")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("OperaMenu","OperaCreateCenter","CreateCenter")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("OperaMenu","OperaIdentify","Identify")
		  if EL <> nil then temp.AppendChild EL

		  EL = ConfigElem("TransfosMenu","TransfosAppliquer","Transformations")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("TransfosMenu","TransfosDefine","DefinirTranslation","Translation")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("TransfosMenu","TransfosDefine", "DefinirRotation","Rotation")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("TransfosMenu","TransfosDefine", "DefinirQuartD","Rot90D")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("TransfosMenu","TransfosDefine", "DefinirQuartG","Rot90G")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("TransfosMenu","TransfosDefine",  "DefinirDemitour","SymCentrale")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("TransfosMenu","TransfosDefine",  "Definirsymetrieaxiale","SymOrtho")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("TransfosMenu","TransfosDefine",  "DefinirHomothetie","Homothetie")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("TransfosMenu","TransfosDefine", "DefinirSimilitude","Similitude")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("TransfosMenu","TransfosDefine", "DefinirDeplacement","Deplacement")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("TransfosMenu","TransfosDefine", "DefinirEtirement","Etirement")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem3("TransfosMenu","TransfosDefine", "DefinirCisaillement","Cisaillement")
		  if EL <> nil then temp.AppendChild EL

		  EL = ConfigElem("TransfosMenu","TransfosFixedPoints","PtsFix")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("TransfosMenu","TransfosHide","HideTsf")
		  if EL <> nil then temp.AppendChild EL


		  EL = ConfigElem("PrefsMenu","PrefsStdForms", "StdForms")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("PrefsMenu","PrefsFleches", "Flecher")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("PrefsMenu","PrefsTrace", "Traj")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("PrefsMenu","PrefsPolyg", "Pointer")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("PrefsMenu","PrefsBiface", "Biface")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("PrefsMenu","PrefsAjust", "Ajuster")
		  if EL <> nil then temp.AppendChild EL

		  EL = ConfigElem("PrefsMenu","PrefsMagDist", "DistanceMagnetisme")
		  if EL <> nil then
		    EL.setattribute("Value", str(MagneticDist))
		    temp.appendchild EL
		  end if

		  EL = ConfigElem("HelpMenu","HelpView", "View")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("HelpMenu","HelpVisit", "Visit")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("HelpMenu","HelpAbout", "About")
		  if EL <> nil then temp.AppendChild EL
		  EL = ConfigElem("NotesMenu","NotesOpen", "Notes")
		  if EL <> nil then temp.AppendChild EL


		  if ShowStdTools then
		    temp.AppendChild CFG.CreateElement("StdForms")
		    EL = CFG.CreateElement("StdFile")
		    if EL <> nil then
		      EL.SetAttribute("Name", stdfile)
		      Temp.AppendChild EL
		    end if
		    EL = CFG.CreateElement("TailleFormesStandard")
		    if EL <> nil then
		      EL.SetAttribute("Value", str(stdsize))
		      Temp.AppendChild EL
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
		            temp.AppendChild EL
		          end if
		        end if
		      next
		    next
		  end if
		  if MvBt(0) then
		    temp.AppendChild CFG.CreateElement("Modify")
		  end if
		  if MvBt(1) then
		    temp.AppendChild CFG.CreateElement("Slide")
		  end if
		  if MvBt(2) then
		    temp.AppendChild CFG.CreateElement("Turn")
		  end if
		  if MvBt(3) then
		    temp.AppendChild CFG.CreateElement("Return")
		  end if
		  if MvBt(4) then
		    temp.AppendChild CFG.CreateElement("Zoom")
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
		Area As integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		biface As Boolean
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
		PolFleches As Boolean
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
		username As String = "Enseignant"
	#tag EndProperty

	#tag Property, Flags = &h0
		Weightlesscolor As couleur
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Ajust"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Area"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="biface"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fill"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="GridPointsSize"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
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
			Name="Langue"
			Visible=false
			Group="Behavior"
			InitialValue="Francais"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastInfo"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
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
			Name="MagneticDist"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Menu"
			Visible=false
			Group="Behavior"
			InitialValue="Menu_AC"
			Type="string"
			EditorType="MultiLineEditor"
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
			Name="Nstdfam"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OldLangue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OldMenu"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Password"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PolFleches"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PolPointes"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="pwok"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShowHelp"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShowStdTools"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShowTools"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="stdfile"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StdSize"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="integer"
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
			Name="TextSize"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Thickness"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
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
			Name="Trace"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="user"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="username"
			Visible=false
			Group="Behavior"
			InitialValue="Historique"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
