#tag Class
Protected Class CustomCanvas1
Inherits Canvas
	#tag Event
		Function ConstructContextualMenu(base as MenuItem, x as Integer, y as Integer) As Boolean
		  Dim p As BasicPoint
		  dim s as shape
		  Dim m As MenuItem
		  Dim curop As operation
		  
		  CurrentContent.TheTransfos.DrapShowAll = false //On cache les tsf hidden2
		  CurrentContent.TheTransfos.ShowAll                     //On montre les autres
		  currentcontent.thetransfos.unhighlightall
		  
		  curop =  currentcontent.currentoperation
		  If  dret <> Nil Then
		    dret.enabled = false
		    dret = Nil
		  else
		    If Curop IsA ShapeConstruction And Curop.CurrentShape.isinconstruction And Shapeconstruction(Curop).currentitemtoset > 1 Then
		      CurrentContent.abortconstruction
		    End If
		    If curop IsA modifier Then
		      curop.endoperation
		    end if
		  End If
		  
		  if curop isa readhisto or currentcontent.macrocreation   then
		    Return False
		  End If
		  
		  
		  if sctxt = nil then
		    return false
		  end if
		  
		  p = mouseuser
		  If  sctxt IsA Lacet  Then
		    side = sctxt.side
		  Elseif sctxt IsA circle And (Not sctxt IsA arc) And circle(sctxt).inside(p) Then
		    side = -1
		  Elseif sctxt IsA arc And arc(sctxt).inside(p) Then
		    side = 0
		  Elseif sctxt IsA point Then
		    side=-1
		  End If
		  
		  workwindow.refreshtitle
		  Refreshbackground
		  
		  base.Name= sctxt.GetType
		  If side <> -1   Then
		    tit = "Côté n°"+Str(sctxt.side) + " du " + sctxt.identifiant 
		  Else
		    tit = sctxt.identifiant
		  End If
		  
		  base.append (New MenuItem(tit))
		  base.append( New MenuItem(MenuItem.TextSeparator))
		  base.append(New MenuItem(Dico.Value("ToolsLabel")))
		  base.append( New MenuItem(Dico.Value("ToolsColorBorder")))
		  
		  'If side = -1 Then
		  'f sctxt.Ti <> nil and (not sctxt isa droite) and (not sctxt isa arc) then
		  'base.append(New MenuItem(Dico.value("ToolsColorFill") + Dico.value("Fororientedarea")))
		  'end if
		  'end if
		  
		  If side = -1 And  (Not sctxt IsA point) And (Not sctxt IsA droite) And (Not sctxt IsA arc) Then
		    m = new MenuItem(Dico.value("ToolsColorTransparent"))
		    base.append m
		    m.append(New MenuItem(Dico.value("ToolsOpq")))
		    m.append(New MenuItem(Dico.value("ToolsSTsp")))
		    m.append(New MenuItem(Dico.value("ToolsTsp")))
		    base.append( New MenuItem(Dico.value("ToolsColorFill")))
		  end if
		  
		  if (not sctxt isa point) or (ubound(point(sctxt).parents) = -1) then
		    base.append(New MenuItem(Dico.Value("ToolsAVPlan")))
		    base.append(New MenuItem(Dico.Value("ToolsARPlan")))
		  end if
		  
		  If sctxt IsA polygon Then
		    base.append(New MenuItem(Dico.Value("AutoIntersec")))
		  End If
		  
		  if sctxt.borderwidth = config.thickness then
		    base.append( New MenuItem(Dico.Value("Epais")))
		  else
		    base.append(New MenuItem(Dico.Value("Mince")))
		  end if
		  
		  
		  if not sctxt.std and sctxt.fam < 10  then
		    base.append(New MenuItem(Dico.Value("Rigidifier")))
		  else
		    base.append(New MenuItem(Dico.Value("Derigidifier")))
		  end if
		  
		  
		  if not sctxt isa point then
		    if not sctxt.pointe then
		      base.append(New MenuItem(Dico.Value("Pointer")))
		    else
		      base.append(New MenuItem(Dico.Value("DePointer")))
		    end if
		    if  sctxt.ti = nil and not sctxt isa Bande and not sctxt isa secteur  then
		      base.append( New MenuItem(Dico.Value("Flecher")))
		    elseif  sctxt.ti <> nil   then
		      base.append(New MenuItem(Dico.Value("DeFlecher")))
		    end if
		  end if
		  
		  if sctxt.tracept then
		    base.append(New MenuItem(Dico.Value("DeTracer")))
		  else
		    base.append(New MenuItem(Dico.Value("Tracer")))
		  end if
		  
		  if sctxt.conditionedby = nil then
		    base.append( New MenuItem(Dico.Value("Condition")))
		  else
		    base.append(New MenuItem(Dico.Value("Decondition")))
		  end if
		  
		  if sctxt isa point and point(sctxt).pointsur.count = 1 then
		    s = point(sctxt).pointsur.item(0)
		    if s isa polygon  and not point(sctxt).surseg  then
		      base.Append (New MenuItem(Dico.Value("Limiter")))
		    end if
		    if (s isa droite and droite(s).nextre = 2) or (s isa freecircle) or (s isa arc) then
		      base.append (New MenuItem(Dico.Value("Animer")))
		    end if
		  end if
		  
		  if sctxt isa droite and  sctxt.fig.shapes.count = 1 and sctxt.constructedby = nil and ubound(sctxt.constructedshapes) = -1 then
		    base.append (New MenuItem("Rectifier l'horizontale"))
		  end if
		  
		  Return True//display the contextual menu
		  
		  
		  
		End Function
	#tag EndEvent

	#tag Event
		Function ContextualMenuAction(hitItem as MenuItem) As Boolean
		  Dim colo As Color
		  dim coul as couleur
		  dim txt as TextWindow
		  Dim dr As droite
		  Dim oldside As Integer
		  
		  
		  Select Case hitItem.Text
		  case tit
		    txt = new TextWindow
		    txt.visible = true
		  Case Dico.value("ToolsLabel")
		    currentoper = New AddLabel
		    currentoper.currentshape = sctxt
		    currentcontent.currentoperation = currentoper
		    currentoper.MouseDown(MouseUser)
		    currentoper.MouseUp(MouseUser)
		  Case Dico.Value("Epais"), Dico.Value("Mince")
		    currentoper = New Epaisseur
		    currentoper.currentshape = sctxt
		    currentcontent.currentoperation = currentoper
		    EndOperMenuContext
		  Case Dico.Value("ToolsColorBorder")
		    If sctxt IsA circle Then
		      side = -1
		    End If
		    colo = sctxt.bordercolor.col
		    oldside = side
		    If HelpMess And TargetMacOS Then
		      OKMess=Help("Choisis la nouvelle couleur, ensuite ferme la palette de couleurs en cliquant sur le point rouge, en haut à gauche") 
		    End If
		    If  OKMess And Color.SelectedFromDialog(colo,"choose")  Then
		      side = oldside
		      sctxt.side = oldside
		      currentcontent.currentoperation  =  New ColorChange(True, colo, side) 
		    End If
		    currentoper = ColorChange(currentcontent.currentoperation)
		    currentoper.currentshape = sctxt
		    EndOperMenuContext
		    'case Dico.Value("ToolsColorFill")+Dico.Value("Fororientedarea")
		    'if sctxt.aire >0 then
		    'coul = poscolor
		    'Else
		    'coul = negcolor
		    'End If
		    'sctxt.FillColor = coul
		    //If SelectColor(colo,Dico.Value("choose")+Dico.Value("acolor")) Then
		    //currentcontent.currentoperation = New ColorChange(False, colo, side)
		    //currentoper = colorchange(currentcontent.currentoperation)
		    //end if
		    //EndOperMenuContext
		  Case Dico.Value("ToolsColorFill")
		    colo = sctxt.FillColor.col
		    side =-1
		    If HelpMess  Then
		      OKMess=Help("Choisis la nouvelle couleur, ensuite ferme la palette en cliquant sur le point rouge, en haut à gauche") 
		    End If
		    If OKMess And Color.SelectedFromDialog(colo,"choose") Then
		      currentcontent.currentoperation =  New ColorChange(False, colo,side)
		    End If
		    currentoper = ColorChange(currentcontent.currentoperation)
		    currentoper.currentshape = sctxt
		    EndOperMenuContext
		  case Dico.Value("ToolsOpq")
		    currentcontent.currentoperation = new TransparencyChange(100)
		    currentoper = Transparencychange(currentcontent.currentoperation)
		    EndOperMenuContext
		  case Dico.Value("ToolsSTsp")
		    currentcontent.currentoperation = new TransparencyChange(50)
		    currentoper = Transparencychange(currentcontent.currentoperation)
		    EndOperMenuContext
		  case Dico.Value("ToolsTsp")
		    currentcontent.currentoperation = new TransparencyChange(0)
		    currentoper = Transparencychange(currentcontent.currentoperation)
		    EndOperMenuContext
		  case Dico.Value("ToolsAVPlan")
		    CurrentContent.CurrentOperation=new ChangePosition(1)
		    currentoper = ChangePosition(CurrentContent.Currentoperation)
		    EndOperMenuContext
		  case Dico.Value("ToolsARPlan")
		    CurrentContent.CurrentOperation=new ChangePosition(0)
		    currentoper = ChangePosition(CurrentContent.Currentoperation)
		    EndOperMenuContext
		  case Dico.Value("Rigidifier"), Dico.Value("Derigidifier")
		    currentcontent.currentoperation = new Rigidifier
		    currentoper = SelectOperation(currentcontent.currentoperation)
		    EndOperMenuContext
		  case Dico.Value("Pointer"), Dico.Value("DePointer")
		    currentcontent.currentoperation = New Pointer
		    currentoper = SelectOperation(currentcontent.currentoperation)
		    EndOperMenuContext
		  Case Dico.Value("Tracer"), Dico.Value("DeTracer")
		    currentcontent.currentoperation = new Tracer
		    currentoper = SelectOperation(currentcontent.currentoperation)
		    EndOperMenuContext
		  case Dico.Value("Flecher"), Dico.Value("DeFlecher")
		    currentcontent.currentoperation = new Flecher
		    currentoper = SelectOperation(currentcontent.currentoperation)
		    EndOperMenuContext
		  case Dico.Value("Condition"), Dico.Value("DeCondition")
		    currentcontent.currentoperation = new Conditionner(sctxt)
		    currentoper = SelectOperation(currentcontent.currentoperation)
		    currentoper.currenthighlightedshape = sctxt
		    currentoper.selection
		  Case Dico.Value("Limiter")
		    point(sctxt).surseg = True
		  Case Dico.Value("AutoIntersec")
		    'polygon(sctxt).autointer.s = polygon(sctxt)
		    currentcontent.currentoperation = New AutoIntersec(sctxt)
		    currentoper = SelectOperation(currentcontent.currentoperation)
		    'EndOperMenuContext          ' Instruction inutile et même nuisible dans ce cas
		  case Dico.Value("Animer")
		    currentcontent.currentoperation = New Modifier
		    currentoper = Modifier(currentcontent.currentoperation)
		    ClearOffscreen
		    Modifier(currentoper).Animer(point(sctxt))
		  case "Rectifier l'horizontale"
		    dr = droite(sctxt)
		    dr.points(1).bpt.y = dr.points(0).bpt.y
		    dr.updatecoord
		  end select
		  WorkWindow.refreshtitle
		  RefreshBackground
		  ctxt = false
		  sctxt = Nil
		  if currentcontent.currentoperation <> nil and not (currentoper isa Conditionner) and not (currentoper isa modifier) then
		    currentcontent.currentoperation = nil
		  End If
		  workwindow.refreshtitle
		  
		  return true
		End Function
	#tag EndEvent

	#tag Event
		Sub DoubleClick(X As Integer, Y As Integer)
		  dim s as shape
		  
		  if  CurrentContent.currentoperation isa shapeconstruction then
		    s =  CurrentContent.CurrentOperation.currentshape
		    if (s.fam > 10 and s.IndexConstructedPoint = 0)  then
		      CurrentContent.undolastoperation
		    elseif  (s.fam <=10 and s.IndexConstructedpoint > 1) then
		      CurrentContent.abortconstruction
		    end if
		  end if
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(Key As String) As Boolean
		  if asc(key)  = 32 then
		    choixcontextmenu
		  end if
		End Function
	#tag EndEvent

	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  Dim p, pp As BasicPoint
		  Dim curop As operation
		  
		  p = New BasicPoint(x,y)
		  pp = itransform(p)
		  curop = currentcontent.currentoperation
		  
		  Formswindow.close
		  If Not IsContextualClick Then
		    If dret = Nil And Curop<>Nil Then
		      p = New BasicPoint(x,y)
		      Curop.MouseDown(pp)
		    End If
		    Return True
		  End If
		  
		  CurrentContent.AbortConstruction
		  refreshbackground
		  If currenthighlightedshape <> Nil Then
		    AfficherChoixContext
		  End If
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(X As Integer, Y As Integer)
		  if dret = nil then
		    if CurrentContent.CurrentOperation<>nil then
		      CurrentContent.CurrentOperation.MouseDrag(itransform(new BasicPoint(x,y)))
		    end if
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseMove(X As Integer, Y As Integer)
		  //On passe d'abord dans le mousemove du canvas, puis dans celui de la fenêtre (qui n'existe plus)
		  dim p as BasicPoint
		  
		  'Note: CurrentOper n'est <>  nil que dans les méthodes ReadHisto.NextOper, RedHisto.PrecOper, Windcontent.RedoLastOperation et 
		  'Windcontent.UndoLastOperation. Donc la plupart du temps, on passe dans les lignes 12 à 30
		  
		  
		  If  CurrentContent.curoper <> Nil  Then 
		    Return
		  End If
		  
		  p =mouseuser
		  Mousecursor =   System.Cursors.StandardPointer
		  If dret = Nil And CurrentContent.CurrentOperation<>Nil Then
		    currentcontent.currentoperation.mousemove(p)
		    refreshbackground
		    Return
		  End If
		  
		  oldp = p
		  If currenthighlightedshape<> Nil Then
		    currenthighlightedshape.unhighlight
		  End If
		  currenthighlightedshape = GetShape(p)
		  If currenthighlightedshape <> Nil  Then
		    sctxt=currenthighlightedshape
		    sctxt.highlight
		  End If
		  
		  refreshbackground
		  
		  if currenthighlightedshape <> nil and not currentcontent.macrocreation then
		    AfficherChoixContext
		    ctxt = True    'Branche le "MouseWheel 
		  Else
		    info = Dico.value("click")+Dico.value("onabuttonoramenu")+EndOfLine+Dico.value("chgTextSize")
		    ctxt=False
		  End If
		  
		  refreshbackground
		  
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  // Le mouseup attend que les opérations lancées par le mousedown soient terminées avant de s'exécuter
		  
		  if CurrentContent.currentoperation<> nil and  (CurrentContent.currentoperation isa selectanddragoperation  or CurrentContent.currentoperation isa savebitmap) then
		    CurrentContent.CurrentOperation.MouseUp(itransform(new BasicPoint(x,y)))
		  end if
		  
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseWheel(X As Integer, Y As Integer, deltaX as Integer, deltaY as Integer) As Boolean
		  
		  if CurrentContent.CurrentOperation <> nil then
		    CurrentContent.CurrentOperation.MouseWheel
		  elseif ctxt then
		    ChoixContextMenu
		  end if
		  return true
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  If config <> Nil Then
		    zone = new ovalshape
		    zone.width = 2*config.magneticdist
		    zone.height= zone.width
		    zone.bordercolor = noir
		    zone.fill = 0
		    zone.border = 100
		  end if
		  
		  OffscreenPicture=New Picture(width,height,Screen(0).Depth)
		  OffscreenPicture.Transparent = 1
		  HelpMess = True
		  OKMess = True
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  
		  if OffscreenPicture <> nil and BackgroundPicture <> nil  then
		    BackgroundPicture.graphics.DrawPicture OffscreenPicture , 0, 0 
		    g.drawPicture(BackgroundPicture, 0, 0)
		  end if
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AfficherChoixContext()
		  If sctxt <> Nil Then
		    If sctxt.side =-1 Then
		      info = sctxt.Identifiant 
		    Else
		      info = "Côté n°"+ " "+Str(sctxt.side) +" du "+ sctxt.identifiant
		    End If
		    info = info + ", " + Dico.Value("rightclick")+Dico.Value("toseecontextmenu")
		    If nobj > 1 Then
		      info = info + " (" + str(nobj) + "," + str(iobj+1) + ")"
		    end if
		    RefreshBackGround
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub alignFondEcran(align as String)
		  FondsEcran.align = align
		  RefreshBackground
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub calculcoins()
		  if invctm <> nil then
		    csg = new BasicPoint(0,0)
		    csg = itransform(csg)
		    csd = new BasicPoint(width,0)
		    csd = itransform(csd)
		    cig = new BasicPoint(0,height)
		    cig = itransform(cig)
		    cid = new BasicPoint(width,height)
		    cid =itransform(cid)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChoixContextMenu()
		  
		  if vis <> nil and nobj > 1 then
		    iobj = (iobj+1) mod nobj
		    If sctxt<>Nil Then
		      sctxt.UnHighLight
		    end if
		    sctxt = vis.item(iobj)
		    AfficherChoixContext
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClearOffscreen()
		  if offscreenpicture <> nil then
		    OffscreenPicture.graphics.ForeColor= blanc
		    OffscreenPicture.graphics.FillRect(0,0,width,height)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub coins(Byref gsc as BasicPoint, Byref dsc as BasicPoint, Byref gic as BasicPoint, Byref dic as BasicPoint)
		  gsc = csg
		  dsc = csd
		  gic = cig
		  dic = cid
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub computescaling()
		  scaling = sqrt(abs(CTM.det))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRepere()
		  rep.delete
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawFondEcran()
		  if FondsEcran = nil then
		    return
		  end if
		  
		  dim image As Picture
		  dim fondLeft, fondTop, fondWidth, fondHeight as Double
		  
		  image= FondsEcran.image
		  fondLeft = 0
		  fondTop = 0
		  fondWidth = image.width
		  fondHeight = image.height
		  
		  Select Case FondsEcran.align 
		  Case "stretched" 
		    fondWidth = width
		    fondHeight = height 
		  Case "topCenter", "centerCenter", "bottomCenter"
		    fondLeft = (Width - image.width)/2
		  Case "topRight", "centerRight", "bottomRight"
		    fondLeft = Width - image.width
		  end Select
		  
		  Select Case FondsEcran.align 
		  Case "centerLeft", "centerCenter", "centerRight"
		    fondTop = (Height - image.Height)/2
		  Case "bottomLeft", "bottomCenter", "bottomRight"
		    fondTop = Height - image.Height
		  end Select
		  
		  BackgroundPicture.graphics.drawpicture image,fondLeft,fondTop,fondWidth,fondHeight,0,0,image.width,image.height
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub drawzone(bp as BasicPoint)
		  if currentcontent.currentoperation <> nil then
		    BackgroundPicture.graphics.drawobject zone, bp.x, bp.y
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function dtransform(bp as basicpoint) As basicpoint
		  dim u1, u2  as basicpoint
		  u1 = (CTM.v1)*(round(1000*bp.x)/1000)
		  u2 =  (CTM.v2)*(round(1000*bp.y)/1000)
		  return u1 + u2
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperMenuContext()
		  
		  currentoper.currenthighlightedshape = sctxt 
		  currentoper.selection
		  currentoper.immediatedooperation
		  currentoper.currenthighlightedshape = Nil
		  currentoper = nil
		  workwindow.refreshtitle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EraseBackground()
		  if BackgroundPicture <> nil then
		    BackgroundPicture.graphics.ForeColor= Bkcol
		    BackgroundPicture.graphics.FillRect(0,0,width,height)
		    DrawFondEcran
		    BackgroundPicture.graphics.forecolor = Config.bordercolor.col
		    BackgroundPicture.graphics.TextSize = Config.TextSize
		    BackgroundPicture.graphics.Bold = true
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRepere() As repere
		  return rep
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  Dim s As shape
		  
		  iobj = 0
		  
		  vis = CurrentContent.TheObjects.findobject(p)
		  if vis <> nil and vis.count <> 0 then
		    nobj = vis.count
		    s = vis.item(iobj)
		    s.highlighted = False
		    s.side = -2
		    if s isa Lacet  or s isa Bande or s isa secteur then
		      s.side = s.pointonside(p)
		      If s.side <> -1 Then
		        Lacet(s).nsk.paintside(BackgroundPicture.graphics,s.side,2,Config.HighlightColor)
		      Else
		        s.highlighted = True
		        Lacet(s).nsk.paint(BackgroundPicture.graphics,Config.HighlightColor)
		      End If
		      refreshbackground
		    Elseif s IsA Bipoint  Or s IsA Circle  Or s IsA point Then
		      s.side = -1
		    End If
		  else
		    s = nil
		  end if
		  
		  Return s
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Help(mess As string) As Boolean
		  Var SuppMess As New MessageDialog
		  Var b As MessageDialogButton
		  SuppMess.ActionButton.Caption = "OK"
		  SuppMess.CancelButton.Visible = True
		  SuppMess.AlternateActionButton.Visible = True
		  SuppMess.AlternateActionButton.Caption = "Ne plus afficher cette aide"
		  SuppMess.Message = mess
		  
		  b = SuppMess.ShowModal
		  Select Case b
		  Case SuppMess.ActionButton
		    Return True
		  Case SuppMess.CancelButton
		    Return False
		  Case SuppMess.AlternateActionButton
		    HelpMess = False
		    Return True
		  End Select
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function idtransform(bp as basicpoint) As basicpoint
		  dim u1,u2 as basicpoint
		  
		  if invctm <> nil then
		    u1 = INVCTM.v1*bp.x
		    u2 = INVCTM.v2*bp.y
		    return  u1+u2
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function itransform(bp as basicpoint) As basicpoint
		  if invctm <> nil then
		    return INVCTM*bp
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MouseCan() As basicpoint
		  return new basicpoint(MouseX-left, MouseY-top)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MouseUser() As basicpoint
		  return itransform (MouseCan)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub oldsaveAsPict()
		  
		  dim fi as folderItem
		  
		  #if targetMacOS
		    fi=GetSaveFolderItem("application/pict","Sauvegarde.pict")
		  #endif
		  #if targetWin32
		    fi=GetSaveFolderItem("bmp","Sauvegarde.bmp")
		  #endif
		  If fi<>Nil then
		    fi.saveAsPicture BackgroundPicture
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RefreshBackground()
		  
		  dim op As operation
		  
		  
		  if BackgroundPicture = nil or CurrentContent = nil or CurrentContent.GetRepere = nil then
		    return
		  end if
		  
		  EraseBackground
		  
		  if drapzone then
		    drawzone(MouseCan)
		  end if
		  
		  if IdContent <> CurrentContent.id then
		    Setrepere(CurrentContent.GetRepere)
		    ClearOffscreen
		    IdContent = CurrentContent.id
		  End If
		  
		  if CurrentContent.TheGrid<>nil then
		    CurrentContent.TheGrid.Paint(BackgroundPicture.Graphics)
		  End If
		  
		  op = CurrentContent.currentoperation
		  If op = Nil Then 
		    workwindow.drapshowall = False
		  End If
		  
		  CurrentContent.TheObjects.paint(BackgroundPicture.Graphics)
		  
		  if op <> nil  then
		    op.Paint(BackgroundPicture.Graphics)
		  elseif CurrentContent.curoper <> nil and (CurrentContent.curoper isa lier or CurrentContent.curoper isa delier)  then
		    CurrentContent.curoper.paint(BackgroundPicture.graphics)
		  Elseif currentcontent.curoper = Nil And currenthighlightedshape <> Nil Then
		    side = currenthighlightedshape.side
		    If side = -1 Then
		      currenthighlightedshape.paintall(BackgroundPicture.graphics)
		    Elseif  side <> -1 Then
		      currenthighlightedshape.PaintSide(BackgroundPicture.Graphics,side,2,config.HighlightColor)
		    end if
		    if info <> "" then
		      BackgroundPicture.graphics.drawstring info, MouseCan.x, MouseCan.y  'Notif concernant taille des fontes
		    end if
		  end if
		  
		  refresh
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Resize()
		  me.left = 122
		  me.top = 0
		  me.width = WorkWindow.width - me.left
		  me.height = WorkWindow.height 
		  
		  BackgroundPicture=New Picture(width,height,screen(0).depth) 
		  BackgroundPicture.graphics.ForeColor= &cFFFFFF
		  BackgroundPicture.graphics.FillRect(0,0,width,height)
		  if config <> nil then
		    BackgroundPicture.graphics.forecolor = Config.bordercolor.col
		    BackgroundPicture.graphics.TextSize = Config.TextSize
		    bkcol = Config.Fillcolor.col
		  end if
		  BackgroundPicture.graphics.Bold = true
		  
		  OffscreenPicture=New Picture(width,height,screen(0).depth)
		  OffscreenPicture.Transparent = 1
		  
		  
		  calculcoins
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setFondEcran(image as Picture, name as string)
		  if FondsEcran = nil then
		    FondsEcran = new FondEcran
		  end if
		  
		  FondsEcran.image = image
		  FondsEcran.Name = Name
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetMagneticDist()
		  MagneticDist = abs(Config.magneticdist/scaling)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Setrepere(r as repere)
		  Rep = r
		  CTM = new matrix(r.IdX, r.Idy, r.origine)
		  INVCTM = CTM.inv
		  computescaling
		  setmagneticdist
		  calculcoins
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function transform(bp as basicPoint) As basicpoint
		  
		  return CTM*bp
		End Function
	#tag EndMethod


	#tag Note, Name = CTM et Transform
		CTM est la matrice de transformation des coordonnées utilisateurs en coordonnées canvas (pixels)
		INVCTM est la matrice inverse
		CTM est calculée à partir du repère
		
		transform convertit un point-utilisateur en un point canvas en mutlipliant par CTM
		itransform opère la conversion inverse
		dtransform convertit un vecteur-utilisateur en un point canvas en mutlipliant par CTM0: matrice CTM dont la dernière colonne est remplacée par (0 0)
		idtransform opère la conversion inverse
		
		Ces conventions sont les m^emes qu'en postscript.
	#tag EndNote

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
		BackgroundPicture As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		Bkcol As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		cid As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		cig As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		csd As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		csg As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected CTM As matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		ctxt As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		currenthighlightedshape As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		currentoper As SelectOperation
	#tag EndProperty

	#tag Property, Flags = &h0
		drapCH As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drapzone As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		FondsEcran As FondEcran
	#tag EndProperty

	#tag Property, Flags = &h0
		HelpMess As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		IdContent As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		info As string
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected INVCTM As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		iobj As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		MagneticDist As double
	#tag EndProperty

	#tag Property, Flags = &h0
		n As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		NeedsRefresh As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		nobj As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ObjectsTraced As Group2D
	#tag EndProperty

	#tag Property, Flags = &h0
		OffscreenPicture As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		OKMess As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		oldp As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		Rep As repere
	#tag EndProperty

	#tag Property, Flags = &h0
		scaling As double
	#tag EndProperty

	#tag Property, Flags = &h0
		sctxt As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		side As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		tit As string
	#tag EndProperty

	#tag Property, Flags = &h0
		vis As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		zone As ovalshape
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocus"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowTabs"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackgroundPicture"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Bkcol"
			Visible=false
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ctxt"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapzone"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IdContent"
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
			InitialValue=""
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
			Name="InitialParent"
			Visible=false
			Group=""
			InitialValue=""
			Type="String"
			EditorType=""
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
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
			Name="n"
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
			Name="NeedsRefresh"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="OffscreenPicture"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="scaling"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="double"
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
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="tit"
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
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpMess"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OKMess"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapCH"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
