#tag Class
Protected Class WindContent
	#tag Method, Flags = &h0
		Sub openOpList()
		  CurrentOp = -1
		  totaloperation = 0
		  OpList = new XMLDocument
		  OpList.PreserveWhiteSpace = true
		  Histo = OpList.CreateElement("AG")
		  OpList.Appendchild (Histo)
		  if not app.macrocreation then
		    Histo.SetAttribute(Dico.Value("Langage"),Config.Langue)
		    Histo.SetAttribute(Dico.value("Config"),Config.Menu)
		    Histo.SetAttribute("Version",str(App.MajorVersion)+"."+str(App.MinorVersion)+"."+str(App.BugVersion))
		    if polygpointes then
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
		Sub Creerrepere()
		  CurrentOperation = new ShapeConstruction (-1,0)
		  addshape currentoperation.currentshape
		  AddOperation(CurrentOperation)
		  CurrentOperation = nil
		  wnd.mycanvas1.mousecursor = arrowcursor
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateFigs()
		  dim Temp as XMLElement
		  
		  'If not app.macrocreation then
		  FigsCreated = OpList.CreateElement("Created_Figures")
		  FigsDeleted = OpList.CreateElement("Deleted_Figures")
		  FigsMoved = OpList.CreateElement("MovedFigures")
		  FigsModified = OpList.CreateElement("ModifiedFigures")
		  'end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreerOperation(Temp as XMLElement) As Operation
		  dim nop as integer
		  dim curoper as Operation
		  dim EL as XMLElement
		  dim n as integer
		  dim mac as Macro
		  dim cap as string
		  
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
		    curoper = new Lier
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
		  case 11 //ChangePosition
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
		    curoper = new MacroExe(Mac)
		  case 44 //TransfosHide
		    curoper = new HideTsf
		  end select
		  
		  
		  return curoper
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WindContent(n as integer)
		  id = n
		  TheGrid = nil
		  TheFigs = new FigsList()
		  TheObjects = new ObjectsList
		  TheTransfos = new TransfosList
		  TheIntersecs = new IntersecList
		  OpenOpList
		  Etiquette=64
		  ndec = 2
		  Polygpointes = config.PolPointes
		  SHUA = nil
		  SHUL = nil
		  UA = 1
		  UL = 1
		  IcotUL = -1
		  currentoperation = nil
		  wnd.mycanvas1.sctxt = nil
		  wnd.mycanvas1.ctxt = false
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddOperation(o as Operation)
		  dim El as XMLElement
		  dim codes() as integer
		  
		  codes = Array(2,4,8,9,34,41,42) //SaveBitMap, SaveEps, Print, ReadHisto, Unit, ChooseFinal, Sélectionner
		  
		  if o <> nil and codes.indexof(o.OpId) = -1 then    // 34: on ne crée pas d'historique de la lecture d'un historique
		    currentop = totaloperation
		    if (Histo<> nil) and app.macrocreation then
		      o.AddOperationToMac(OpList, Histo)
		    elseif (Histo <> nil)  then    //On élimine la sélection
		      El=Oplist.CreateElement(Dico.Value("Operation"))
		      El.SetAttribute(Dico.Value("Numero"),str(TotalOperation))
		      El.SetAttribute(Dico.Value("Type"), o.GetName)
		      EL.SetAttribute("OpId", str(o.OpId))
		      El.AppendChild (o.ToXml(Oplist))
		      if not o isa Ouvrir then
		        if FigsDeleted.childcount > 0 then
		          EL.appendchild FigsDeleted
		        end if
		        if FigsCreated.childcount > 0 then
		          EL.appendchild FigsCreated
		        end if
		        if FigsMoved.childcount > 0 then
		          EL.appendchild FigsMoved
		        end if
		        if FigsModified.childcount > 0 then
		          EL.appendchild FigsModified
		        end if
		      end if
		      Histo.AppendChild El
		    end if
		    SaveHisto
		    TotalOperation  = TotalOperation +1
		    wnd.pushbutton1.enabled = true
		  end if
		End Sub
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
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub abortConstruction()
		  dim s as shape
		  
		  if currentoperation isa shapeconstruction then
		    drapabort = true
		    s = currentoperation.currentshape
		    if s.isinconstruction and (s.indexconstructedpoint = 0) then
		      s.points(0).delete
		    end if
		    if currentcontent.TheObjects.getposition(s) <> -1 then
		      s.delete
		    end if
		    
		    if s.indexConstructedPoint >= 1 and  FigsDeleted.Childcount > 0 then
		      Theobjects.XMLLoadObjects(FigsDeleted)
		    end if
		  elseif currentoperation isa macroexe then
		    macroexe(currentoperation).mw.close
		  end if
		  drapabort = false
		  currentoperation = nil
		  wnd.refreshtitle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveHisto()
		  Dim fileStream as TextOutputStream
		  
		  
		  if TotalOperation = 1 then
		    CreateHisto
		  end if
		  
		  if FiHisto <> nil then
		    fileStream=FiHisto.createTextFile
		    if fileStream=nil then
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
		Sub RedoLastOperation()
		  dim El as XMLElement
		  
		  isaundoredo = true
		  Currentop= currentop+1
		  EL = XMLElement(Histo.Child(currentop))
		  EL.SetAttribute("Undone","0")
		  SaveHisto
		  CurrentFileUpToDate=false
		  curoper = CreerOperation(EL)
		  wnd.Mycanvas1.Mousecursor = system.cursors.wait
		  wnd.MyCanvas1.ClearOffscreen
		  CurOper.RedoOperation(EL)
		  
		  if wnd.mousedispo then
		    wnd.refresh
		    if curoper isa lier or curoper isa delier then
		      curoper.paint(wnd.mycanvas1.graphics)
		    end if
		    isaundoredo = false
		    wnd.Mycanvas1.Mousecursor = ArrowCursor
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoLastOperation()
		  dim El as XMLElement
		  dim curoper as Operation
		  
		  isaundoredo = true
		  currentoperation = nil
		  wnd.closefw
		  
		  while currentop > 0 and  Histo.Child(currentop) <> nil and val(XMLElement(Histo.child(currentop)).GetAttribute("Undone")) = 1
		    currentop = currentop-1
		  wend
		  
		  if currentop = 0 then
		    return
		  end if
		  
		  EL = XMLElement(Histo.Child(currentop))
		  EL.SetAttribute("Undone","1")
		  SaveHisto
		  curoper = CreerOperation(EL)
		  CurrentFileUpToDate=false
		  wnd.Mycanvas1.Mousecursor = system.cursors.wait
		  CurOper.UndoOperation(EL)
		  currentop = currentop-1
		  
		  
		  
		  if wnd.mousedispo then
		    if curoper isa lier or curoper isa delier then
		      curoper.paint(wnd.mycanvas1.graphics)
		    end if
		    isaundoredo = false
		    wnd.Mycanvas1.Mousecursor = ArrowCursor
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MakeXML() As XMLDocument
		  dim Doc as XMLDocument
		  dim AG, TMP, EL, Grille as XmlElement
		  dim i as integer
		  dim s as shape
		  dim Mac as Macro
		  
		  Doc = new XmlDocument
		  Doc.Preservewhitespace = true
		  AG = Doc.CreateElement("AG")
		  Doc.Appendchild (AG)
		  AG.SetAttribute(Dico.Value("Langage"),Config.Langue)
		  AG.SetAttribute(Dico.value("Config"),Config.Menu)
		  AG.SetAttribute("Plans", str(1))
		  if wnd.backcolor = noir then
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
		  if polygpointes then
		    AG.SetAttribute(Replace(Dico.value("PrefsPolyg")," ","_"), str(1))
		  else
		    AG.SetAttribute(Replace(Dico.value("PrefsPolyg")," ","_"), str(0))
		  end if
		  if Config.Trace then
		    AG.SetAttribute(Replace(Dico.value("PrefsTrace")," ","_"), str(1))
		  else
		    AG.SetAttribute(Replace(Dico.value("PrefsTrace")," ","_"), str(0))
		  end if
		  if PolygFleches then
		    AG.SetAttribute(Replace(Dico.value("PrefsFleches")," ","_"), str(1))
		  else
		    AG.SetAttribute(Replace(Dico.value("PrefsFleches")," ","_"), str(0))
		  end if
		  AG.SetAttribute("NbrDec", str(ndec))
		  if App.TheMacros.Count > 0 then
		    TMP = Doc.CreateElement("Macros")
		    for i = 0 to App.TheMacros.count-1
		      Mac =App.TheMacros.element(i)
		      EL = XMLElement(Doc.importnode(mac.Histo,true))
		      Mac.ToXML(Doc,EL)
		      TMP.AppendChild EL
		    next
		    AG.appendchild TMP
		  end if
		  
		  if TheObjects.element(0) isa repere then
		    TMP = Doc.CreateElement(Dico.Value("Objects"))
		    TMP.AppendChild TheObjects.Element(0).XMLPutInContainer(Doc)
		  else
		    MsgBox Dico.value("CorruptedFile")
		    return nil
		  end if
		  TheObjects.unselectall //désélection  pour que les objets soient dans le même ordre que dans la mémoire
		  for i = 1 to TheObjects.count-1
		    s = TheObjects.element(i)
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
		Sub SaveAs()
		  dim file as folderitem
		  dim Titre as string
		  dim n as integer
		  
		  Currentfile=GetSaveFolderItem(FileAGTypes.SAVE,"Figure_"+str(id)+".fag")
		  If Currentfile<>Nil then
		    Titre = Currentfile.Name
		    n = Titre.Instr(".")
		    if n > 0 then
		      Titre = Left(Titre, n-1)
		    end if
		    Currentfile.Name = Titre+".fag"
		    save
		  end if
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Save()
		  CurrentOperation=nil
		  
		  if currentfile = nil then
		    saveas
		  else
		    Dim fileStream as TextOutputStream
		    dim Doc as XMLDocument
		    
		    Doc = MakeXML
		    
		    if Doc <> nil then
		      fileStream=currentfile.createTextFile
		      if fileStream=nil then
		        MsgBox  Dico.value("ErrorOnSave")
		        return
		      else
		        filestream.write Doc.tostring
		        fileStream.close
		      end if
		    end if
		    TheObjects.unselectall
		    CurrentFileUpToDate=true
		    wnd.refreshtitle
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRepere() As Repere
		  if TheObjects.element(0) isa repere then
		    return Repere(TheObjects.element(0))
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateHisto()
		  dim fi as Folderitem
		  dim d as Date
		  dim t as string
		  dim m, n as integer
		  d  = new Date
		  
		  fi = GetFolderHisto("Historiques/"+Config.username+"/"+str(d.day)+"-"+str(d.Month)+"-"+str(d.Year))
		  
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
		      FiHisto.MacType = FileAGTypes.HIST
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFolderHisto(directory as string) As folderItem
		  dim fi as FolderItem
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
		Sub setfleches(n as integer)
		  if n = 1 then
		    PolygFleches = true
		  else
		    PolygFleches = false
		  end if
		  if wnd.MenuBar.Child("PrefsMenu").child("PrefsFleches") <> nil then
		    wnd.MenuBar.Child("PrefsMenu").Child("PrefsFleches").checked  = PolygFleches
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setpolygpointes(n as integer)
		  if n = 1 then
		    currentcontent.polygpointes = true
		  else
		    currentcontent.polygpointes = false
		  end if
		  if wnd.MenuBar.Child("PrefsMenu").Child("PrefsPolyg")<> nil then
		    wnd.MenuBar.Child("PrefsMenu").Child("PrefsPolyg").checked  = currentcontent.polygpointes
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ForHisto() As Boolean
		  return  not isaundoredo and not (currentoperation isa ReadHisto)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FinInitialisation(Temp as XMLElement, f as folderitem)
		  dim n as integer
		  dim dr as droite
		  
		  n = val(Temp.GetAttribute("SHUA"))
		  if n <> 0 then
		    SHUA = TheObjects.Getshape(n)
		    UA = SHUA.aire
		  end if
		  n = val(Temp.GetAttribute("SHUL"))
		  if n <> 0 then
		    SHUL = TheObjects.Getshape(n)
		    if SHUL isa droite then
		      UL = droite(SHUL).longueur
		    elseif SHUL isa polygon then
		      IcotUL = val(Temp.GetAttribute("IcotUL"))
		      dr = Polygon(SHUL).Getside(IcotUL)
		      UL = dr.longueur
		    end if
		  end if
		  CurrentFile = f
		  CurrentFileUpToDate=true
		  CurrentOperation=nil
		  setpolygpointes(val(Temp.GetAttribute(Replace(Dico.value("PrefsPolyg")," ","_"))))
		  wnd.settrace(val(Temp.GetAttribute(Replace(Dico.value("PrefsTrace")," ","_"))))
		  SetFleches(val(Temp.GetAttribute(Replace(Dico.value("PrefsFleches")," ","_"))))
		  TheObjects.updatelabels(wnd.mycanvas1.rep.echelle)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub removeall()
		  TheObjects.RemoveAll
		  redim plans(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveBack(n as integer)
		  
		  
		  plans.remove  plans.indexof(n)
		  plans.insert 1,n
		  UpdatePlans
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveFront(n as integer)
		  
		  if plans.indexof(n) <> -1 then
		    plans.remove  plans.indexof(n)
		  end if
		  plans.append n
		  UpdatePlans
		  
		  
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
		Sub CreatePlans()
		  dim i, n as integer
		  dim s as shape
		  
		  n = TheObjects.count-1
		  redim plans(n)
		  plans(0)=0
		  for i = 1 to n
		    s = TheObjects.element(i)
		    if plans(s.plan) <> s.id or  s.plan = 0 or s.plan = -1 or s.plan > ubound(plans) then
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
		Sub Addshape(s as shape)
		  dim i as integer
		  
		  TheObjects.addshape s
		  
		  'if not s isa point then
		  'for i = 0 to s.npts-1
		  'if plans.indexof(s.childs(i).id) <> -1 and  (s.childs(i).constructedby = nil or s.childs(i).constructedby.oper = 10) then
		  'plans.remove plans.indexof(s.childs(i).id)
		  'end if
		  'next
		  'end if
		  if s.plan = -1 then
		    AddPlan(s)
		  else
		    Plans(s.plan) = s.id
		  end if
		  
		  #if TargetLinux then
		    EnableMenuItems
		  #endif
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Optimize()
		  
		  //Retire de la liste les points qui ont des parents
		  dim pt as point
		  dim i as Integer
		  
		  for i = TheObjects.count downto 0
		    if TheObjects.element(i) isa point then
		      pt = point(TheObjects.element(i))
		      if Ubound(pt.parents) >-1 and (pt.constructedby = nil or pt.constructedby.oper = 10)  then
		        RemoveShape pt
		      end if
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveShape(s as shape)
		  if plans.indexof(s.id) <> -1 then
		    plans.remove  plans.indexof(s.id)
		  end if
		  TheObjects.removeshape s
		  UpdatePlans
		  
		  #if TargetLinux then
		    EnableMenuItems
		  #endif
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
		Function OpToCancel() As XMLElement
		  dim n as integer
		  
		  
		  if not app.macrocreation then
		    n = currentop
		    while n > 0 and val(XMLElement(Histo.child(n)).GetAttribute("Undone")) = 1
		      n = n-1
		    wend
		    if n = 0 then
		      return nil
		    end if
		    return  XMLElement(Histo.Child(n))
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemettreTsfAvantPlan()
		  dim s as shape
		  dim i as integer
		  
		  for i = 0 to TheTransfos.count-1
		    s = TheTransfos.element(i).supp
		    if s isa point and ubound(point(s).parents)> -1 then
		      point(s).parents(0).movetofront
		    else
		      s.MovetoFront
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdatePlans()
		  dim i as integer
		  
		  for i = 0 to TheObjects.count-1
		    TheObjects.element(i).plan = plans.indexof(TheObjects.element(i).id)
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
		curoper As operation
	#tag EndProperty

	#tag Property, Flags = &h0
		Currentfile As folderitem
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentOp As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentOperation As Operation
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
		Histo As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		Oplist As XMLDocument
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
		TheObjects As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		TheTransfos As Transfoslist
	#tag EndProperty

	#tag Property, Flags = &h0
		TotalOperation As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FiHisto As Folderitem
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentfileUpToDate As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		isaundoredo As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		TitreHisto As string
	#tag EndProperty

	#tag Property, Flags = &h0
		id As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		bugfound As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		PolygFleches As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		PolygPointes As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		OperationDone As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		TraceTraj As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drapaff As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		SHUA As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		SHUL As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		UA As double
	#tag EndProperty

	#tag Property, Flags = &h0
		UL As double
	#tag EndProperty

	#tag Property, Flags = &h0
		IcotUL As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		drapeucli As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		plans() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ndec As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		drapabort As Boolean
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
			Name="CurrentOp"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TotalOperation"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentfileUpToDate"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="isaundoredo"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TitreHisto"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="id"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="bugfound"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PolygFleches"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Polygpointes"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OperationDone"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TraceTraj"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapaff"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UA"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UL"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IcotUL"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapeucli"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ndec"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapabort"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
