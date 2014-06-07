#tag Class
Protected Class MyCanvas
Inherits Canvas
	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  // Le mouseup attend que les opérations lancées par le mousedown soient terminées avant de s'exécuter
		  
		  Dim  currentClickTicks as Integer
		  
		  wnd.dblclic = false
		  
		  currentClickTicks = ticks
		  
		  //if the two clicks happened close enough together in time and the two clicks occured close enough together in space
		  if (currentClickTicks - lastClickTicks) <= 0.02*doubleClickTime and Abs(X - lastClickX) <= 5 And Abs(Y - LastClickY) <= 5 then
		    if  CurrentContent.currentoperation isa shapeconstruction then
		      MsgBox Dico.Value("Doubleclick")
		      DoubleClick //a double click has occured so call the event
		      return
		    end if
		  elseif CurrentContent.currentoperation<> nil and  (CurrentContent.currentoperation isa selectanddragoperation  or CurrentContent.currentoperation isa savebitmap) then
		    CurrentContent.CurrentOperation.MouseUp(itransform(new BasicPoint(x,y)))
		  end if
		  lastClickTicks =currentclickticks
		  lastClickX = X
		  lastClickY = Y
		  
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseMove(X As Integer, Y As Integer)
		  //On passe d'abord dans le mousemove du canvas, puis dans celui de la fenêtre
		  dim s as shape
		  dim p as BasicPoint
		  
		  p =mouseuser
		  sctxt = nil
		  
		  if dret = nil and not CurrentContent.bugfound then
		    if CurrentContent.CurrentOperation<>nil then
		      CurrentContent.CurrentOperation.MouseMove(itransform(new BasicPoint(x,y)))
		    elseif  CurrentContent.curoper = nil then
		      Mousecursor = arrowcursor
		      if oldp <> nil and p.distance(oldp) >magneticdist  then
		        oldp = p
		        if currenthighlightedshape<> nil then
		          currenthighlightedshape.unhighlight
		        end if
		        currenthighlightedshape = GetShape(p)
		        if currenthighlightedshape <> nil then
		          currenthighlightedshape.highlight
		        end if
		      end if
		      if currenthighlightedshape <> nil then
		        AfficherChoixContext
		        ctxt = true    'Branche le "MouseWheel "
		      else
		        info = Dico.value("click") + Dico.value("onabuttonoramenu")+EndOfLine+Dico.value("chgTextSize")
		        ctxt = false
		      end if
		    end if
		  end if
		  refreshBackground
		  
		  if currentcontent.currentoperation <> nil or currentcontent.currentoperation isa conditionner then
		    ctxt = false
		  end if
		  
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseDrag(X As Integer, Y As Integer)
		  if dret = nil then
		    if CurrentContent.CurrentOperation<>nil then
		      CurrentContent.CurrentOperation.MouseDrag(itransform(new BasicPoint(x,y)))
		      RefreshBackground
		    end if
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  dim p as BasicPoint
		  
		  if not IsContextualClick then
		    if dret = nil then
		      if CurrentContent.CurrentOperation<>nil then
		        p = new BasicPoint(x,y)
		        CurrentContent.CurrentOperation.MouseDown(itransform(p))
		      end if
		      return true
		    end if
		  else
		    oldp = new BasicPoint(x,y)
		    info = ""
		    refreshbackground
		  end if
		  
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics)
		  Resize
		  RefreshBackground
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  Readdblclicktime
		  resize
		  if config <> nil then
		    zone = new ovalshape
		    zone.width = 2*config.magneticdist
		    zone.height= zone.width
		    zone.bordercolor = noir
		    zone.fill = 0
		    zone.border = 100
		  end if
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function ConstructContextualMenu(base as MenuItem, x as Integer, y as Integer) As Boolean
		  dim p as BasicPoint
		  dim s as shape
		  dim i as integer
		  
		  ctxt = false
		  
		  if currentcontent.currentoperation isa readhisto then
		    return false
		  end if
		  
		  wnd.closefw
		  CurrentContent.TheTransfos.DrapShowAll = false //On cache les tsf hidden2
		  CurrentContent.TheTransfos.ShowAll                     //On montre les autres
		  currentcontent.thetransfos.unhighlightall
		  if dret <> nil then
		    dret.enabled = false
		    dret =nil
		  else
		    if CurrentContent.CurrentOperation isa ShapeConstruction and  CurrentContent.CurrentOperation.CurrentShape.isinconstruction and Shapeconstruction(CurrentContent.currentoperation).currentitemtoset > 1 then
		      CurrentContent.abortconstruction
		    end if
		    if currentcontent.currentoperation isa modifier then
		      currentcontent.currentoperation.endoperation
		    end if
		  end if
		  currentcontent.currentoperation = nil
		  wnd.refreshtitle
		  
		  
		  sctxt = CurrentHighLightedshape
		  currenthighlightedshape = nil
		  
		  if sctxt = nil then
		    return false
		  end if
		  
		  icot = -1
		  p = new Basicpoint(x,y)
		  if  sctxt isa Polygon  then
		    icot = sctxt.pointonside(p)
		  end if
		  
		  base.Name= sctxt.GetType
		  tit = sctxt.identifiant
		  base.append (New MenuItem(tit))
		  base.append( New MenuItem(MenuItem.TextSeparator))
		  base.append( New MenuItem(Dico.Value("ToolsColorBorder")))
		  
		  if icot = -1 then
		    if sctxt.Ti <> nil and (not sctxt isa droite) and (not sctxt isa arc)  then
		      base.append( New MenuItem(Dico.value("ToolsColorFill") + Dico.value("Fororientedarea")))
		    end if
		    
		    if (not sctxt isa point) and (not sctxt isa droite) and (not sctxt isa arc) then
		      base.append( New MenuItem(Dico.value("ToolsColorFill")))
		    end if
		    
		    base.append(New MenuItem(Dico.Value("ToolsAVPlan")))
		    base.append(New MenuItem(Dico.Value("ToolsARPlan")))
		    
		    if sctxt.borderwidth = 1 then
		      base.append( New MenuItem(Dico.Value("Epais")))
		    else
		      base.append(New MenuItem(Dico.Value("Mince")))
		    end if
		    
		    if sctxt isa point and  point(sctxt).pointsur.count = 0 then
		      if not Point(sctxt).std  then
		        base.append(New MenuItem(Dico.Value("Rigidifier")))
		      else
		        base.append(New MenuItem(Dico.Value("Derigidifier")))
		      end if
		    end if
		    
		    if not sctxt isa point then
		      if sctxt.nonpointed then
		        base.append(New MenuItem(Dico.Value("Pointer")))
		      else
		        base.append(New MenuItem(Dico.Value("DePointer")))
		      end if
		      if  sctxt.ti = nil   then
		        base.append( New MenuItem(Dico.Value("Flecher")))
		      else
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
		      s = point(sctxt).pointsur.element(0)
		      if s isa polygon  and not point(sctxt).surseg  then
		        base.Append (New MenuItem(Dico.Value("Limiter")))
		      end if
		      if (s isa droite and droite(s).nextre = 2) or (s isa freecircle) or (s isa arc) then
		        base.append (New MenuItem(Dico.Value("Animer")))
		      end if
		    end if
		  end if
		  
		  Return True//display the contextual menu
		  
		End Function
	#tag EndEvent

	#tag Event
		Function ContextualMenuAction(hitItem as MenuItem) As Boolean
		  dim col as color
		  dim coul as couleur
		  dim txt as TextWindow
		  
		  select case hitItem.Text
		  case tit
		    txt = new TextWindow
		    txt.visible = true
		  case Dico.Value("Epais"), Dico.Value("Mince")
		    currentcontent.currentoperation = new Epaisseur(3-sctxt.Borderwidth)
		    curoper = SelectOperation(currentcontent.currentoperation)
		    EndOperMenuContext
		  case Dico.Value("ToolsColorBorder")
		    if selectcolor(col,Dico.Value("choose")+Dico.Value("acolor"))  then
		      currentcontent.currentoperation = new ColorChange(true,new couleur(col))
		      curoper = colorchange(currentcontent.currentoperation)
		      if sctxt isa polygon then
		        colorchange(curoper).icot = icot
		      end if
		      EndOperMenuContext
		    end if
		  case Dico.Value("ToolsColorFill")+Dico.Value("Fororientedarea")
		    if sctxt.aire >0 then
		      coul = poscolor
		    else
		      coul = negcolor
		    end if
		    currentcontent.currentoperation = new ColorChange(false,coul)
		    curoper = colorchange(currentcontent.currentoperation)
		    EndOperMenuContext
		  case Dico.Value("ToolsColorFill")
		    if selectcolor(col,Dico.Value("choose")+Dico.Value("acolor"))  then
		      currentcontent.currentoperation = new ColorChange(false,new couleur(col))
		      curoper = colorchange(currentcontent.currentoperation)
		      EndOperMenuContext
		    end if
		  case Dico.Value("ToolsAVPlan")
		    CurrentContent.CurrentOperation=new ChangePosition(1)
		    curoper = ChangePosition(CurrentContent.Currentoperation)
		    EndOperMenuContext
		  case Dico.Value("ToolsARPlan")
		    CurrentContent.CurrentOperation=new ChangePosition(0)
		    curoper = ChangePosition(CurrentContent.Currentoperation)
		    EndOperMenuContext
		  case Dico.Value("Rigidifier"), Dico.Value("Derigidifier")
		    currentcontent.currentoperation = new Rigidifier
		    curoper = SelectOperation(currentcontent.currentoperation)
		    EndOperMenuContext
		  case Dico.Value("Pointer"), Dico.Value("DePointer")
		    currentcontent.currentoperation = new Pointer
		    curoper = SelectOperation(currentcontent.currentoperation)
		    EndOperMenuContext
		  case Dico.Value("Tracer"), Dico.Value("DeTracer")
		    currentcontent.currentoperation = new Tracer
		    curoper = SelectOperation(currentcontent.currentoperation)
		    EndOperMenuContext
		  case Dico.Value("Flecher"), Dico.Value("DeFlecher")
		    currentcontent.currentoperation = new Flecher
		    curoper = SelectOperation(currentcontent.currentoperation)
		    EndOperMenuContext
		  case Dico.Value("Condition"), Dico.Value("DeCondition")
		    currentcontent.currentoperation = new Conditionner(sctxt)
		    curoper = SelectOperation(currentcontent.currentoperation)
		    curoper.currenthighlightedshape = sctxt
		    curoper.selection
		  case Dico.Value("Limiter")
		    point(sctxt).surseg = true
		  case Dico.Value("Animer")
		    currentcontent.currentoperation = new Modifier
		    curoper = Modifier(currentcontent.currentoperation)
		    ClearOffscreen
		    Modifier(curoper).Animer(point(sctxt))
		  end select
		  
		  ctxt = false
		  sctxt = nil
		  if not curoper isa Conditionner and not curoper isa modifier then
		    currentcontent.currentoperation = nil
		  end if
		  wnd.refreshtitle
		End Function
	#tag EndEvent

	#tag Event
		Function MouseWheel(X As Integer, Y As Integer, deltaX as Integer, deltaY as Integer) As Boolean
		  dim nobj as integer
		  
		  if CurrentContent.CurrentOperation <> nil then
		    CurrentContent.CurrentOperation.MouseWheel
		  elseif ctxt then
		    ChoixContextMenu
		  end if
		  return true
		End Function
	#tag EndEvent

	#tag Event
		Function KeyDown(Key As String) As Boolean
		  if asc(key)  = 32 then
		    choixcontextmenu
		  end if
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Resize()
		  Background=NewPicture(width,height,Screen(0).Depth)
		  'Background.graphics.ForeColor= Bkcol
		  'Background.graphics.FillRect(0,0,width,height)
		  'Background.graphics.forecolor = Config.bordercolor.col
		  'Background.graphics.TextSize = Config.TextSize
		  'Background.graphics.Bold = true
		  
		  if currentcontent <> nil and not currentcontent.theobjects.tracept then
		    OffscreenPicture=NewPicture(width,height,Screen(0).Depth)
		    OffscreenPicture.Transparent = 1
		  end if
		  if config <> nil then
		    bkcol = Config.Fillcolor.col
		  end if
		  calculcoins
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RefreshBackground()
		  dim i, j as Integer
		  dim o as shape
		  dim op As operation
		  dim pt as point
		  
		  
		  if Background = nil or CurrentContent = nil or CurrentContent.GetRepere = nil then
		    return
		  end if
		  
		  cnt = cnt+1
		  EraseBackground
		  
		  if drapzone then
		    drawzone(MouseCan)
		  end if
		  
		  if IdContent <> CurrentContent.id then
		    Setrepere(CurrentContent.GetRepere)
		    ClearOffscreen
		    IdContent = CurrentContent.id
		  end if
		  
		  if CurrentContent.TheGrid<>nil then
		    CurrentContent.TheGrid.Paint(Background.Graphics)
		  end if
		  
		  CurrentContent.TheObjects.paint(Background.Graphics)
		  op = CurrentContent.currentoperation
		  if op <> nil  then
		    op.Paint(Background.Graphics)
		  elseif CurrentContent.curoper <> nil and (CurrentContent.curoper isa lier or CurrentContent.curoper isa delier)  then
		    CurrentContent.curoper.paint(Background.graphics)
		  elseif currentcontent.curoper = nil then
		    if sctxt <> nil then
		      sctxt.paint(Background.graphics)
		    end if
		    if info <> "" then
		      Background.graphics.drawstring info, MouseCan.x, MouseCan.y
		    end if
		  end if
		  
		  Background.graphics.DrawPicture OffscreenPicture, 0, 0
		  me.Graphics.drawpicture Background,0,0
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub saveAsPict()
		  dim p as Picture
		  dim fi as folderItem
		  dim i As integer
		  
		  #if targetMacOS
		    fi=GetSaveFolderItem("application/pict","Sauvegarde.pict")
		  #endif
		  #if targetWin32
		    fi=GetSaveFolderItem("bmp","Sauvegarde.bmp")
		  #endif
		  If fi<>Nil then
		    fi.saveAsPicture Background
		  end if
		  
		  
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
		Function dtransform(bp as basicpoint) As basicpoint
		  dim res, u1, u2  as basicpoint
		  u1 = (CTM.v1)*(round(1000*bp.x)/1000)
		  u2 =  (CTM.v2)*(round(1000*bp.y)/1000)
		  return u1 + u2
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
		Sub computescaling()
		  scaling = sqrt(abs(CTM.det))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetMagneticDist()
		  MagneticDist = abs(Config.magneticdist/scaling)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetRepere() As repere
		  return rep
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRepere()
		  rep.delete
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
		Sub ClearOffscreen()
		  if offscreenpicture <> nil then
		    OffscreenPicture.graphics.ForeColor= blanc
		    OffscreenPicture.graphics.FillRect(0,0,width,height)
		  end if
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
		Sub Doubleclick()
		  dim s as shape
		  
		  wnd.dblclic = true
		  s =  CurrentContent.CurrentOperation.currentshape
		  if (s.fam > 10 and s.IndexConstructedPoint = 0)  then
		    CurrentContent.undolastoperation
		    wnd.refreshtitle
		  elseif  (s.fam <=10 and s.IndexConstructedpoint >= 1) then
		    CurrentContent.abortconstruction
		  end if
		  CurrentContent.currentoperation = nil
		  lastClickTicks = 0
		  lastClickX = 0
		  lastClickY = 0
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Readdblclicktime()
		  
		  #If TargetMacOS then
		    #if TargetCarbon then
		      Declare Function GetDblTime Lib "Carbon" () as Integer
		    #endif
		    DoubleClickTime = GetDblTime()
		  #endif
		  
		  #if TargetWin32 then
		    Declare Function GetDoubleClickTime Lib "User32.DLL" () as Integer
		    doubleClickTime = GetDoubleClickTime()
		  #endif
		  
		  #if TargetLinux then
		    Declare Function gtk_settings_get_default lib "libgtk-x11-2.0.so" as Ptr
		    Declare Sub g_object_get lib "libgtk-x11-2.0.so" (Obj as Ptr, _
		    first_property_name as CString, byref doubleClicktime as Integer, _
		    Null as Integer)
		    
		    Dim gtkSettings as MemoryBlock
		    
		    gtkSettings = gtk_settings_get_default()
		    
		    g_object_get(gtkSettings,"gtk-double-click-time",doubleClickTime, 0)
		    // DoubleClickTime now holds the number of milliseconds
		    DoubleClickTime = DoubleClickTime / 1000.0 * 60
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperMenuContext()
		  curoper.currenthighlightedshape = sctxt
		  curoper.selection
		  curoper.immediatedooperation
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s as shape
		  
		  iobj = 0
		  
		  vis = CurrentContent.TheObjects.findobject(p)
		  if vis <> nil and vis.count <> 0 then
		    nobj = vis.count
		    s = vis.element(iobj)
		    if s isa polygon and polygon(s).pointonside(p ) <>-1 then
		      icot = polygon(s).pointonside(p)
		      polygon(s).paintside(graphics,icot,2,Config.highlightcolor)
		    else
		      icot = -1
		    end if
		  else
		    s = nil
		  end if
		  
		  return s
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChoixContextMenu()
		  
		  if vis <> nil and nobj > 1 then
		    iobj = (iobj+1) mod nobj
		    if CurrentHighlightedShape<>nil then
		      CurrentHighlightedShape.UnHighLight
		    end if
		    CurrentHighlightedShape = vis.element(iobj)
		    AfficherChoixContext
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AfficherChoixContext()
		  if currenthighlightedshape <> nil then
		    currenthighlightedshape.HighLight
		    sctxt = currenthighlightedshape
		    info = sctxt.Identifiant + ", " + Dico.Value("rightclick")+Dico.Value("toseecontextmenu")
		    if nobj > 1 then
		      info = info + " (" + str(nobj) + "," + str(iobj+1) + ")"
		    end if
		    RefreshBackGround
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub drawzone(bp as BasicPoint)
		  if currentcontent.currentoperation <> nil then
		    background.graphics.drawobject zone, bp.x, bp.y
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EraseBackground()
		  
		  Background.graphics.ForeColor= Bkcol
		  Background.graphics.FillRect(0,0,width,height)
		  if FondsEcran <> nil then
		    Background.graphics.drawpicture fondsecran,0,0,width,height,0,0,fondsecran.width,fondsecran.height
		  end if
		  Background.graphics.forecolor = Config.bordercolor.col
		  Background.graphics.TextSize = Config.TextSize
		  Background.graphics.Bold = true
		End Sub
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
		OffscreenPicture As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		Background As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		Rep As repere
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected CTM As matrix
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected INVCTM As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		scaling As double
	#tag EndProperty

	#tag Property, Flags = &h0
		MagneticDist As double
	#tag EndProperty

	#tag Property, Flags = &h0
		cig As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		cid As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		csg As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		csd As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		Bkcol As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		cmenu As contextualmenu
	#tag EndProperty

	#tag Property, Flags = &h0
		lastclickticks As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		lastclickx As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		lastclicky As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Doubleclicktime As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		IdContent As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		ctxt As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		vis As ObjectsList
	#tag EndProperty

	#tag Property, Flags = &h0
		iobj As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		sctxt As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		icot As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		currenthighlightedshape As shape
	#tag EndProperty

	#tag Property, Flags = &h0
		curoper As SelectOperation
	#tag EndProperty

	#tag Property, Flags = &h0
		tit As string
	#tag EndProperty

	#tag Property, Flags = &h0
		NeedsRefresh As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		n As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		nobj As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		oldp As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		info As string
	#tag EndProperty

	#tag Property, Flags = &h0
		drapzone As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		zone As ovalshape
	#tag EndProperty

	#tag Property, Flags = &h0
		FondsEcran As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		cnt As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ControlOrder"
			Visible=true
			Group="Position"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			Type="Picture"
			EditorType="Picture"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AcceptFocus"
			Visible=true
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AcceptTabs"
			Visible=true
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EraseBackground"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OffscreenPicture"
			Group="Behavior"
			InitialValue="0"
			Type="Picture"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Background"
			Group="Behavior"
			InitialValue="0"
			Type="Picture"
		#tag EndViewProperty
		#tag ViewProperty
			Name="scaling"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MagneticDist"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Bkcol"
			Group="Behavior"
			InitialValue="&h000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="lastclickticks"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="lastclickx"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="lastclicky"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Doubleclicktime"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IdContent"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ctxt"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="icot"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="tit"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NeedsRefresh"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="n"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="info"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drapzone"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FondsEcran"
			Group="Behavior"
			InitialValue="0"
			Type="Picture"
		#tag EndViewProperty
		#tag ViewProperty
			Name="cnt"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
