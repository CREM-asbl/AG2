#tag Class
Protected Class WindContent
	#tag Method, Flags = &h0
		Sub AbortConstruction()
		  Var s As shape
		  if currentoperation isa shapeconstruction then
		    drapabort = True
		    s = currentoperation.currentshape
		    If s.isinconstruction And (s.indexconstructedpoint = 0) and not s isa point Then
		      s.points(0).delete
		    End If
		    s.delete
		    If s.indexConstructedPoint >= 1 And  FigsDeleted.Childcount > 0 Then
		      Theobjects.XMLLoadObjects(FigsDeleted)
		    End If
		  Elseif  currentoperation  <> Nil And currentoperation IsA lier Then
		    currentoperation.MouseDown(new BasicPoint(0,0))
		    
		  elseif currentoperation isa macroexe and macroexe(currentoperation).mac.mw <> nil  then
		    macroexe(currentoperation).mac.mw.close
		  end if
		  drapabort = false
		  currentoperation = Nil
		  WorkWindow.refreshtitle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddOperation(o as Operation)
		  Dim codes() As Integer
		  
		  codes = Array(2,4,8,9,34,41,42) //SaveBitMap, SaveEps, Print, ReadHisto, Unit, ChooseFinal, Sélectionner
		  // 34: on ne crée pas d'historique de la lecture d'un historique
		  
		  if (Histo = nil) or (o = nil) or (codes.indexof(o.OpId) <> -1) or (macrocreation and o isa modifier) then
		    return
		  end if
		  
		  currentop = totaloperation
		  if macrocreation then
		    o.AddOperationToMac(OpList, Histo)
		  else
		    InsertInHisto(o)
		  end if
		  TotalOperation  = TotalOperation +1
		  SaveHisto
		  WorkWindow.pushbutton1.enabled = true
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddPlan(s as shape)
		  if (not s isa point  or point(s).pointsur.count =0 ) and (plans.indexof(s.id) = -1 ) then
		    plans.append s.id
		    s.plan = ubound(plans)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Addshape(s as shape)
		  TheObjects.addshape s
		  
		  if s.plan = -1 then
		    AddPlan(s)
		  elseif s.Plan > ubound(plans) then
		    plans.append s.id
		  else
		    Plans(s.plan) = s.id
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChargerObjets(FAG as XMLElement)
		  dim n as integer
		  dim dr as droite
		  dim r as Repere
		  
		  TheObjects.drapplan = (val(FAG.GetAttribute("Plans")) = 1)
		  TheObjects.SetId(-1)
		  TheObjects.XMLLoadObjects(FAG)
		  TheObjects.updateids
		  n = val(FAG.GetAttribute("SHUA"))
		  if n <> 0 then
		    SHUA = TheObjects.Getshape(n)
		    UA = SHUA.aire
		  end if
		  n = val(FAG.GetAttribute("SHUL"))
		  if n <> 0 then
		    SHUL = TheObjects.Getshape(n)
		    if SHUL isa droite then
		      UL = droite(SHUL).longueur
		    elseif SHUL isa polygon then
		      IcotUL = val(FAG.GetAttribute("IcotUL"))
		      dr = Polygon(SHUL).Getside(IcotUL)
		      UL = dr.longueur
		    end if
		  end if
		  r = can.rep
		  TheObjects.updatelabels(r.echelle)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChargerPrefs(FAG as XMLElement, f as folderitem)
		  dim BkCol as string
		  dim Obj As XMLElement
		  dim List as XMLNodeList
		  dim s1, s2 As string
		  
		  
		  removeall
		  ndec = val(FAG.GetAttribute("NbrDec"))
		  if ndec =0 then
		    ndec = 2
		  end if
		  BkCol = FAG.GetAttribute("BkCol")
		  if BkCol = "noir" and WorkWindow.BackgroundColor = &cFFFFFF then
		    WorkWindow.switchcolors
		  end if
		  
		  Setpolygpointes(val(FAG.GetAttribute(Replace(Dico.value("PrefsPolyg")," ","_"))))
		  Workwindow.settrace(val(FAG.GetAttribute(Replace(Dico.value("PrefsTrace")," ","_"))))
		  SetFleches(val(FAG.GetAttribute(Replace(Dico.value("PrefsFleches")," ","_"))))
		  config.area  = val(FAG.GetAttribute("Area"))
		  
		  List = FAG.XQL("FondEcran")
		  
		  if List.length > 0 then
		    Obj = XMLElement(List.item(0))
		    s1 = Obj.GetAttribute("File")
		    s2 = Obj.GetAttribute("Align")
		    f = f.parent
		    f = f.child(s1)
		    if f=nil then
		      return 
		    else
		      can.setFondEcran(Picture.Open(f), f.Name)
		      can.alignFondEcran(s2)
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(n as integer)
		  id = n
		  TheGrid = nil
		  TheFigs = new FigsList()
		  TheObjects = new ObjectsList
		  TheTransfos = new TransfosList
		  TheIntersecs = new IntersecList
		  TheMacros = new MacrosList
		  OpenOpList
		  Etiquette=64
		  ndec = 2
		  SHUA = nil
		  SHUL = nil
		  UA = 1
		  UL = 1
		  IcotUL = -1
		  currentoperation = nil
		  if can <> nil then
		    can.sctxt = nil
		    can.ctxt = false
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateFigs()
		  FigsCreated = OpList.CreateElement("Created_Figures")
		  FigsDeleted = OpList.CreateElement("Deleted_Figures")
		  FigsMoved = OpList.CreateElement("MovedFigures")
		  FigsModified = OpList.CreateElement("ModifiedFigures")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateHisto()
		  Dim fi As Folderitem
		  dim d as Date
		  dim t as string
		  dim m, n as integer
		  d  = new Date
		  
		  fi = GetFolderHisto("Historiques/"+Config.username+"/"+Str(d.Year)+"-"+Str(d.Month)+"-"+Str(d.Day))
		  
		  if fi <> nil then
		    if currentfile <> nil then
		      t = currentfile.name
		      n =instr(t,"/")
		      while n > 0
		        m = len(t)
		        t = right(t,m-n)
		        n = instr(t,"/")
		      wend
		      titrehisto = NthField(t,".",1)
		    else
		      titrehisto = Dico.value("Figure")+"-"+str(id)+" "+str(d.Hour)+"-"+str(d.Minute)
		    end if
		    TitreHisto = TitreHisto+".hag"
		    
		    fi = fi.Child(titrehisto)
		    if fi.Exists then
		      fi.delete
		    end if
		    if fi <> nil then
		      FiHisto = fi
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreatePlans()
		  dim i, n as integer
		  dim s as shape
		  
		  n = TheObjects.count-1
		  redim plans(-1)
		  redim plans(n)
		  plans(0)=0
		  for i = 1 to n
		    s = TheObjects.item(i)
		    if s.plan = -1  or  s.plan = 0  or s.plan > ubound(plans) then
		      plans.append s.id
		      s.plan = ubound(plans)
		    else
		      plans(s.plan) = s.id
		    end if
		  next
		  
		  for i = ubound(plans)  downto 1
		    if plans(i) = 0 or plans(i) = -1 then
		      plans.remove i
		    end if
		  next
		  updateplans
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreerOperation(Temp as XMLElement) As Operation
		  Dim nop As Integer
		  dim curoper as Operation
		  dim EL as XMLElement
		  dim n as integer
		  dim mac as Macro
		  dim cap as string
		  dim Doc as XMLDocument
		  
		  nop = val(Temp.GetAttribute("OpId"))
		  
		  select case nop
		    'case 2 //SaveBitmap Pour mémoire
		    'case 8 //SaveEPS  Pour mémoire
		    'case 9 //Print Pour Mémoire
		  case -1
		    curoper = new Ouvrir
		  case 0
		    curoper = new ShapeConstruction
		  case 1
		    curoper = new ParaperpConstruction
		  case 3 //Lier
		    curoper = New Lier
		  case 4 //Selectionner
		    curoper = new Selectionner(false)
		  case 5 //Copier
		    curoper = new Copier
		  case 6 //Coller
		    curoper = new Coller
		  case 7 //Delete
		    curoper = new Delete
		  case 10 //Delier
		    curoper = new Delier
		  Case 11 //ChangePosition   'Changer de plan
		    curoper = new ChangePosition
		  case 12 //ColorChange
		    curoper = new ColorChange
		  case 13 //Epaisseur
		    curoper = new Epaisseur
		  case 14 //GCConstruction
		    curoper = new GCconstruction
		  case 15 //Hide
		    curoper = new Hide(true)
		  case 16 //Retourner
		    curoper = new Retourner
		  case 17 //TransfoConstruction
		    curoper =New TransfoConstruction
		  case 18 //TransparencyChange
		    curoper = new TransparencyChange
		  case 19 //Duplicate
		    curoper = new Duplicate
		  case 20 //Glisser
		    curoper = new Glisser
		  case 21 //Modifier
		    curoper = new Modifier
		  case 22 //Redimensionner
		    curoper = new Redimensionner
		  case 23 //Tourner
		    curoper = new Tourner
		  case 24 //AppliquerTsf
		    curoper = new AppliquerTsf
		  case 25 // Decouper
		    curoper = new Decouper
		  case 26 //Divide
		    curoper = new Divide
		  case 27 //Fusion
		    curoper = new Fusion
		  case 28 //Prolonger
		    curoper = new Prolonger
		  case 29 //CreateGrid
		    curoper =new creategrid(true)
		  case 30 //Rigidifier
		    curoper = new Rigidifier
		    
		    'Case 31 //annuler
		    'case 32 //refaire
		    'Pour mémoire
		    
		  case 33 //Nommer
		    curoper = New AddLabel
		  case 35  //Identifier
		    curoper = new Identifier
		  case 36
		    curoper = new Tracer
		  case 37
		    curoper = new FixPConstruction
		  case 38
		    curoper = new Pointer
		  case 39
		    curoper = new Flecher
		  case 40
		    curoper = new Conditionner
		  case 41
		    EL = XMLElement(Temp.FirstChild)
		    n = val(EL.GetAttribute("Type"))
		    curoper = new Unit(n)
		    
		    'case 42 //ChooseFinal Pour mémoire
		  case 43 //MacroExe
		    EL = XMLElement(Temp.firstchild)
		    cap = EL.GetAttribute("Name")
		    Mac = app.theMacros.GetMacro(cap)
		    if Mac = nil then
		      cap = cap+".xmag"
		      try 
		        Doc = new XmlDocument(app.MacFolder.Child(cap))
		        mac =new Macro(Doc)
		        app.themacros.addmac mac
		        WorkWindow.updatesousmenusmacros
		      catch
		        MsgBox "Macro "+cap+" introuvable"
		        return nil
		      end try
		    end if
		    curoper = new MacroExe(Mac)
		  case 44 //TransfosHide
		    curoper = New HideTsf
		  Case 45  //AutoIntersection
		    curoper = New AuToIntersec(Temp)
		  end select
		  
		  
		  return curoper
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Creerrepere()
		  CurrentOperation = new ShapeConstruction (-1,0)
		  addshape currentoperation.currentshape
		  AddOperation(CurrentOperation)
		  CurrentOperation = nil
		  can.mousecursor = System.Cursors.StandardPointer
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ForHisto() As Boolean
		  return  (not isaundoredo and not (currentoperation isa ReadHisto))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFolderHisto(directory as string) As folderItem
		  Dim fi As FolderItem
		  dim childs(-1) as string
		  dim i as Integer
		  
		  childs = Split(directory,"/")
		  fi=App.DocFolder
		  
		  for i=0 to UBound(childs)
		    fi = fi.Child(childs(i))
		    if not fi.Exists then
		      fi.CreateAsFolder
		      if not fi.Exists then
		        MsgBox Dico.Value("ErrorOnSave")+ " " + Dico.Value("Nowritingpermission")
		        return nil
		      end if
		    end if
		  next
		  
		  return fi
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRepere() As Repere
		  if TheObjects.item(0) isa repere then
		    return Repere(TheObjects.item(0))
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetWindTitle() As string
		  Dim windowTitle, tit1, tit2 As String
		  
		  tit1 = Dico.value("MainTitle1")
		  tit2 = Dico.value("MainTitle2")
		  if CurrentFile=nil then
		    WindowTitle= tit1+ " "+ Config.username
		  else
		    WindowTitle=tit1 +" "+ Config.username + " "+ tit2 + " "+ CurrentFile.Name
		  end if
		  
		  if CurrentOperation<>nil then
		    WindowTitle=WindowTitle+" - "+ Dico.value(CurrentOperation.getName)
		    if CurrentOperation isa ShapeConstruction and shapeconstruction(currentoperation).currentshape <> nil  then
		      WindowTitle=WindowTitle+ " " + lowercase(Dico.value(ShapeConstruction(CurrentOperation).Currentshape.GetType))
		    elseif CurrentOperation isa TransfoConstruction then
		      WindowTitle=WindowTitle+" : "+ lowercase(Dico.value(TransfoConstruction(CurrentOperation).GetType(TransfoConstruction(CurrentOperation).type)))
		    elseif CurrentOperation isa MacroExe then
		      WindowTitle = WindowTitle+ " : " + lowercase(MacroExe(CurrentOperation).Mac.Caption)
		    end if
		  else
		    windowTitle = windowtitle+" - "+Dico.value("Noactiveop")
		  end if
		  
		  WindowTitle = windowTitle+" -- "+ Dico.Value("Figure")+" "+str(id)
		  
		  if not CurrentFileUpToDate then
		    WindowTitle=WindowTitle+"*"
		  end if
		  
		  return WindowTitle
		  
		  'if currentcontent.macrocreation then
		  'Title=Dico.Value("MacrosCreate") + "*"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertInHisto(o as operation)
		  Dim El As XMLElement
		  
		  El=Oplist.CreateElement(Dico.Value("Operation"))
		  El.SetAttribute(Dico.Value("Numero"),str(TotalOperation))
		  El.SetAttribute(Dico.Value("Type"), o.GetName)
		  EL.SetAttribute("OpId", Str(o.OpId))
		  El.AppendChild (o.ToXml(Oplist))
		  if FigsCreated.childcount > 0 then
		    EL.appendchild FigsCreated
		  end if
		  if FigsDeleted.childcount > 0 then
		    EL.appendchild FigsDeleted
		  end if
		  if FigsMoved.childcount > 0 then
		    EL.appendchild FigsMoved
		  end if
		  if FigsModified.childcount > 0 then
		    EL.appendchild FigsModified
		  end if
		  Histo.AppendChild El
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MakeXML() As XMLDocument
		  Dim Doc As XMLDocument
		  dim AG, TMP, EL as XMLElement
		  dim i as integer
		  dim s as shape
		  dim Mac as Macro
		  dim d as Date
		  dim st as string
		  dim f as FolderItem
		  dim FEName As string
		  
		  d = new Date
		  
		  Doc = new XmlDocument
		  AG = Doc.CreateElement("AG")
		  Doc.Appendchild (AG)
		  AG.SetAttribute("Creation_Date",d.ShortDate)
		  f = SpecialFolder.Documents.Parent
		  if f <> nil then
		    st = f.Name
		  end if
		  AG.SetAttribute("Creator", st)
		  AG.SetAttribute(Dico.Value("Langage"),Config.Langue)
		  AG.SetAttribute(Dico.value("Config"),Config.Menu)
		  AG.SetAttribute("Plans", str(1))
		  if WorkWindow.BackgroundColor = noir then
		    AG.SetAttribute("BkCol","noir")
		  end if
		  if SHUA <> nil then
		    AG.SetAttribute("SHUA", str(SHUA.id))
		  end if
		  if SHUL <> nil then
		    AG.SetAttribute("SHUL",str(SHUL.id))
		    AG.SetAttribute("IcotUL",str(IcotUL))
		  end if
		  AG.SetAttribute("Version",str(App.MajorVersion)+"."+str(App.MinorVersion)+"."+str(App.BugVersion))
		  AG.SetAttribute("DateCompil", str(app.BuildDate))
		  if Config.Trace then
		    AG.SetAttribute(Replace(Dico.value("PrefsTrace")," ","_"), str(1))
		  else
		    AG.SetAttribute(Replace(Dico.value("PrefsTrace")," ","_"), str(0))
		  end if
		  if config.polpointes then
		    AG.SetAttribute(Replace(Dico.value("PrefsPolyg")," ","_"), str(1))
		  else
		    AG.SetAttribute(Replace(Dico.value("PrefsPolyg")," ","_"), str(0))
		  end if
		  if config.polfleches then
		    AG.SetAttribute(Replace(Dico.value("PrefsFleches")," ","_"), str(1))
		  else
		    AG.SetAttribute(Replace(Dico.value("PrefsFleches")," ","_"), str(0))
		  end if
		  if config.biface then 
		    AG.SetAttribute(Replace(Dico.value("PrefsBiface")," ","_"), str(1))
		  else
		    AG.SetAttribute(Replace(Dico.value("PrefsBiface")," ","_"), str(0))
		  end if
		  if config.area = 0  then 'AireArith
		    AG.SetAttribute("Area", str(0)) 
		  else   'AireAlge
		    AG.SetAttribute("Area", str(1))
		  end if
		  AG.SetAttribute("NbrDec", str(ndec))
		  if can.FondsEcran <> nil then
		    TMP = Doc.CreateElement("FondEcran")
		    TMP.SetAttribute("File",can.FondsEcran.GetName) 
		    TMP.SetAttribute("Align",can.FondsEcran.GetAlign)
		    AG.AppendChild TMP
		  end if
		  If TheMacros.Count > 0 Then
		    TMP = Doc.CreateElement("Macros")
		    for i = 0 to TheMacros.count-1
		      Mac =TheMacros.item(i)
		      EL = XMLElement(Doc.importnode(mac.Histo,true))
		      'Mac.ToXML(Doc,EL)
		      TMP.AppendChild EL
		    Next
		    AG.appendchild TMP
		  end if
		  
		  if TheObjects.item(0) isa repere then
		    TMP = Doc.CreateElement(Dico.Value("Forms"))                  'Forms remplace Objects 
		    TMP.AppendChild TheObjects.item(0).XMLPutInContainer(Doc)
		  else
		    MsgBox Dico.value("CorruptedFile")
		    return nil
		  end if
		  TheObjects.unselectall //désélection  pour que les objets soient dans le même ordre que dans la mémoire
		  for i = 1 to TheObjects.count-1
		    s = TheObjects.item(i)
		    s.plan = CurrentContent.plans.IndexOf(s.id)
		    TMP.appendchild s.XMLPutInContainer(Doc)
		  next
		  AG.AppendChild TMP
		  if TheGrid<>nil then
		    AG.appendchild TheGrid.XMLPutInContainer(Doc)
		  end if
		  
		  return Doc
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveBack(n as integer)
		  
		  if plans.indexof(n) <> -1 then
		    plans.remove  plans.indexof(n)
		    plans.insert 1,n
		    UpdatePlans
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveFront(n as integer)
		  
		  if plans.indexof(n) <> -1 then
		    plans.remove  plans.indexof(n)
		    plans.append n
		    UpdatePlans
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub openOpList()
		  CurrentOp = -1
		  totaloperation = 0
		  OpList = new XMLDocument
		  OpList.PreserveWhiteSpace = true
		  Histo = OpList.CreateElement("AG")
		  OpList.Appendchild (Histo)
		  if not macrocreation then
		    Histo.SetAttribute(Dico.Value("Langage"),Config.Langue)
		    Histo.SetAttribute(Dico.value("Config"),Config.Menu)
		    Histo.SetAttribute("Version",str(App.MajorVersion)+"."+str(App.MinorVersion)+"."+str(App.BugVersion))
		    if config.polpointes then
		      Histo.SetAttribute(Replace(Dico.value("PrefsPolyg")," ","_"), str(1))
		    else
		      Histo.SetAttribute(Replace(Dico.value("PrefsPolyg")," ","_"), str(0))
		    end if
		    if Config.Trace then
		      Histo.SetAttribute(Dico.value("PrefsTrace"), str(1))
		    else
		      Histo.SetAttribute(Dico.value("PrefsTrace"), str(0))
		    end if
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Optimize()
		  
		  //Retire de la liste les points qui ont des parents
		  dim pt as point
		  dim i as Integer
		  
		  for i = TheObjects.count downto 0
		    if TheObjects.item(i) isa point then
		      pt = point(TheObjects.item(i))
		      if Ubound(pt.parents) >-1 and (pt.constructedby = nil or pt.constructedby.oper = 10)  then
		        removeobject pt
		      end if
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OpToCancel() As XMLElement
		  dim n as integer
		  
		  if macrocreation then
		    return nil
		  else
		    n = currentop
		    while n > 0 and Histo.child(n) <> nil and val(XMLElement(Histo.child(n)).GetAttribute("Undone")) = 1
		      n = n-1
		    wend
		    if n = 0 then
		      return nil
		    end if
		    return  XMLElement(Histo.Child(n))
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoLastOperation()
		  dim El as XMLElement
		  
		  isaundoredo = true
		  Currentop= currentop+1
		  EL = XMLElement(Histo.Child(currentop))
		  EL.SetAttribute("Undone","0")
		  SaveHisto
		  CurrentFileUpToDate=false
		  curoper = CreerOperation(EL)
		  can.Mousecursor = system.cursors.wait
		  can.ClearOffscreen
		  CurOper.RedoOperation(EL)
		  
		  if WorkWindow.mousedispo then
		    WorkWindow.refresh
		    if curoper isa lier or curoper isa delier then
		      curoper.paint(can.BackgroundPicture.graphics)
		    end if
		    isaundoredo = false
		    can.Mousecursor = System.Cursors.StandardPointer
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemettreTsfAvantPlan()
		  dim s as shape
		  dim i as integer
		  
		  for i = 0 to TheTransfos.count-1
		    s = TheTransfos.item(i).supp
		    if s = nil then
		      return
		    elseif s isa point and ubound(point(s).parents)> -1 then
		      point(s).parents(0).movetofront
		    else
		      s.MovetoFront
		    end if
		  next
		  
		  Exception err
		    dim d As Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("i", i)
		    d.setVariable("s", s)
		    err.message = err.message+d.getString
		    
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removeall()
		  TheObjects.RemoveAll
		  redim plans(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removeobject(s as shape)
		  if plans.indexof(s.id) <> -1 then
		    plans.remove  plans.indexof(s.id)
		  end if
		  TheObjects.removeobject s
		  UpdatePlans
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Save()
		  CurrentOperation=Nil
		  
		  if currentfile = nil then
		    saveas
		  else
		    dim Doc as XMLDocument
		    Doc = MakeXML
		    if Doc <> nil then
		      Doc.SaveXml(currentfile)
		    end if
		    TheObjects.unselectall
		    CurrentFileUpToDate=true
		    WorkWindow.refreshtitle
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveAs()
		  Dim Titre, Ext, s As String
		  dim n as integer
		  
		  Currentfile=GetSaveFolderItem(FileAGTypes.SAVE,"Figure_"+str(id)+".fag")
		  If Currentfile<>Nil Then
		    Titre = Currentfile.Name
		    n = Titre.Instr(".")
		    if n > 0 then
		      s = Left(Titre, n-1)
		      Ext = Right(Titre, 3)
		      Titre = s
		    end if
		    if Ext = ".fag" then
		      Currentfile.Name = Titre+".fag" 
		      'elseif Ext = "app" then
		      'Currentfile.Name = Titre+".fapp"
		    else
		      CurrentFile.Name = Titre+"."+Ext
		    end if
		    save
		    If FiHisto.Name <> s+".hag" Then
		      CreateHisto
		    End If
		  end if
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveHisto()
		  Dim fileStream As TextOutputStream
		  
		  
		  If TotalOperation = 1 Then
		    CreateHisto
		  End If
		  
		  
		  If  FiHisto <> Nil And TotalOperation > 1 Then 
		    fileStream = TextOutputStream.Create(FiHisto)
		    if fileStream = nil then
		      MsgBox Dico.Value("ErrorOnSave")
		      return
		    else
		      filestream.write OpList.tostring
		      fileStream.close
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setfleches(n as integer)
		  if n = 1 then
		    config.PolFleches = true
		  else
		    config.PolFleches = false
		  end if
		  if WorkWindow.MenuBar.Child("PrefsMenu").child("PrefsFleches") <> nil then
		    WorkWindow.MenuBar.Child("PrefsMenu").Child("PrefsFleches").HasCheckMark = config.PolFleches
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setpolygpointes(n as integer)
		  if n = 1 then
		    config.polpointes = true
		  else
		    config.polpointes = false
		  end if
		  if WorkWindow.MenuBar.Child("PrefsMenu").Child("PrefsPolyg")<> nil then
		    WorkWindow.MenuBar.Child("PrefsMenu").Child("PrefsPolyg").HasCheckMark  = config.polpointes
		  end if
		  
		  Exception err
		    
		    err.message = err.message+EndOfLine+str(n)
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetPosition(s as Shape, p as Integer)
		  plans.remove plans.indexof(s.id)
		  if p = -1 then
		    plans.insert ubound(plans)+1, s.id
		  else
		    plans.insert p, s.id
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoLastOperation()
		  Dim El As XMLElement
		  dim curoper as Operation
		  
		  isaundoredo = true
		  
		  if currentop = 0 or Histo.ChildCount = 0 then
		    return
		  end if
		  
		  EL = XMLElement(Histo.Child(currentop))
		  EL.SetAttribute("Undone","1")
		  SaveHisto
		  curoper = CreerOperation(EL)
		  CurrentFileUpToDate=false
		  can.Mousecursor = system.cursors.wait
		  CurOper.UndoOperation(EL)
		  currentop = currentop-1
		  
		  while currentop > 0 and Histo.Child(currentop) <> nil and val(XMLElement(Histo.child(currentop)).GetAttribute("Undone")) = 1
		    currentop = currentop-1
		  wend
		  
		  if WorkWindow.mousedispo then
		    if curoper isa lier or curoper isa delier then
		      curoper.paint(can.BackgroundPicture.graphics)
		    end if
		    isaundoredo = false
		    can.Mousecursor = System.Cursors.StandardPointer
		  end if
		  can.refreshbackground
		  
		  Exception err
		    var d as Debug
		    d = new Debug
		    d.setMessage(CurrentMethodName)
		    d.setVariable("EL", El)
		    d.setVariable("curoper", curoper)
		    d.setVariable("currentop", currentop)
		    d.setVariable("Histo.ChildCount", Histo.ChildCount)
		    err.message = err.message + d.getString
		    Raise err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdatePlans()
		  dim i as integer
		  
		  for i = 0 to TheObjects.count-1
		    TheObjects.item(i).plan = plans.indexof(TheObjects.item(i).id)
		  next
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
		bugfound As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		curoper As operation
	#tag EndProperty

	#tag Property, Flags = &h0
		Currentfile As folderitem
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentfileUpToDate As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentOp As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentOperation As Operation
	#tag EndProperty

	#tag Property, Flags = &h0
		drapabort As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drapaff As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drapeucli As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		FigsCreated As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		FigsDeleted As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		FigsModified As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		FigsMoved As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		FiHisto As Folderitem
	#tag EndProperty

	#tag Property, Flags = &h0
		Histo As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		IcotUL As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		id As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		isaundoredo As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Mac As Macro
	#tag EndProperty

	#tag Property, Flags = &h0
		MacCurop(-1) As MacroExe
	#tag EndProperty

	#tag Property, Flags = &h0
		MacInfos(-1) As MacConstructionInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		MacroCreation As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ndec As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		OperationDone As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Oplist As XMLDocument
	#tag EndProperty

	#tag Property, Flags = &h0
		plans() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		SHUA As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		SHUL As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		TheFigs As FigsList
	#tag EndProperty

	#tag Property, Flags = &h0
		TheGrid As Grid
	#tag EndProperty

	#tag Property, Flags = &h0
		TheIntersecs As IntersecList
	#tag EndProperty

	#tag Property, Flags = &h0
		TheMacros As MacrosList
	#tag EndProperty

	#tag Property, Flags = &h0
		TheObjects As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		TheTransfos As Transfoslist
	#tag EndProperty

	#tag Property, Flags = &h0
		TitreHisto As string
	#tag EndProperty

	#tag Property, Flags = &h0
		TotalOperation As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		TraceTraj As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		UA As double
	#tag EndProperty

	#tag Property, Flags = &h0
		UL As double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="bugfound"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentfileUpToDate"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentOp"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapabort"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapaff"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapeucli"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IcotUL"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="id"
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
			Name="isaundoredo"
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
			Name="MacroCreation"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="ndec"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OperationDone"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="TitreHisto"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
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
			Name="TotalOperation"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TraceTraj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="UA"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="UL"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
