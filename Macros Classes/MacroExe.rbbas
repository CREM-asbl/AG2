#tag Class
Protected Class MacroExe
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub MacroExe(n as integer)
		  MultipleSelectOperation()
		  OpId = 43
		  app.drapmac = true
		  Mac = app.TheMacros.element(n)
		  NumberOfItemsToSelect = ubound(mac.obinit) +1
		  MacInfo = new MacConstructionInfo(Mac)
		  Histo = Mac.Histo
		  mw = new MacWindow
		  mw.Title = Mac.GetName + " : " + Dico.Value("MacroDescription")
		  mw.EditField1.Text = Mac.expli
		  wnd.setfocus
		  
		  //Cette classe a pour objet de choisir de nouveaux objets initiaux et de construire la MacConstructionInfo associée
		  //Dans SetItem, complété par "InstructionsSuivantes", on se borne à créer les "InfoMac" associés aux différentes opérations de la macro et d'y placer
		  //les informations ne changeant pas d'une instance de la macro à une autre (essentiellement les id-macros et les numéros de forme et de famille).
		  
		  //Dans le DoOperation, on appelle la méthode MacExe de la classe Macro qui se charge de calculer tous les bpt des objets intermédiaires et finaux
		  // Quand on revient à MacroExe, il reste à créer les objets finaux et mettre en place les informations à utiliser lors d'une modification.
		  
		  //La routine MacExe  de Macro est également utilisée lors des modifications d'une figure contenant des macros.
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Mac.Caption
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetItem(s as shape) As Boolean
		  MacInfo.RealInit.append s.id
		  MacInfo.RealSide.append side
		  s.init = true
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim obj as string
		  dim cot as integer
		  
		  if currenthighlightedshape <> nil then
		    if side <> -1 then
		      currenthighlightedshape.paintside(g, side, 2, config.highlightcolor)
		      currenthighlightedshape = nil
		      display = thissegment
		    else
		      super.paint(g)
		      obj = lowercase(currenthighlightedshape.gettype)
		      if obj = "arc" then
		        display = cet + " " + obj + " ?"
		      else
		        display = ce + " " + obj + " ?"
		      end if
		    end if
		  else
		    display = choose + un + " " +lowercase(identifier(fa, fo))
		  end if
		  
		  Help g, display
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i, j, k, n, m, index, p, type,oper, fa, fo, side as integer
		  dim EL, EL0, EL1, EL2 as XMLElement
		  dim codesoper() as integer
		  dim ifmac As InfoMac
		  dim s, newshape as shape
		  dim bp() as BasicPoint
		  dim pt as Point
		  
		  
		  codesoper = Array(0,1,14,16,19,28,35,37,39,17,24,25,26,27,45)  //codes des opérations
		  
		  
		  for i = 0 to Histo.Childcount-1  // i: numéro de l'opération
		    EL = XMLElement(Histo.Child(i))
		    if EL.Name = Dico.Value("Operation") then
		      EL0 = XMLElement(EL.Child(0))
		      fa = val(EL0.GetAttribute(Dico.Value("NrFam")))
		      fo = val(EL0.GetAttribute(Dico.Value("NrForm")))
		      ifmac = new InfoMac(fa, fo)
		      ifmac.ptsur = val(EL0.GetAttribute("PointSur"))       //Pour les points d'intersection, ptsur = 0 (ils sont traités comme résultant d'une opération d'inter (code 45))
		      oper = val(EL.GetAttribute("OpId"))                           //oper: code de l'opération
		      if codesoper.indexof(oper) <> -1 then                       //est-ce une opération de construction ? prévoir le cas contraire!
		        n = val(EL.Child(0).GetAttribute("Id"))                    //numéro pour la macro de la forme construite (à placer dans la MacId)
		        if (Mac.ObInit.indexof(n) <> -1) or  (Mac.ObInterm.indexof(n) <> -1) or  (Mac.ObFinal.indexof(n)  <> -1) then
		          ifmac.MacId = n
		          if Mac.ObFinal.indexof(n) <> -1 then                                 // A-t-on affaire  à un objet final?
		            newshape = objects.createshape(ifmac.fa,ifmac.fo)
		            newshape.SetMacConstructedBy MacInfo
		            newshape.initconstruction
		            if oper = 0 then
		              EL1 = XMLElement(EL0.Child(0))
		              for j = 0 to newshape.ncpts-1
		                EL2 = XMLElement(EL1.Child(j))
		                m = val(EL2.GetAttribute("Id"))
		                p = -1
		                index = -1
		                Mac.GetInfoSommet(m, p, index)
		                if p <> -1 then
		                  p = Mac.Obinit.indexof(p)
		                  side = MacInfo.RealSide(p)
		                  p = MacInfo.RealInit(p)
		                  s = currentcontent.TheObjects.GetShape(p)
		                  if side <> -1 then
		                    pt = s.points((index+side) mod s.npts)
		                  end if
		                  newshape.substitutepoint(pt,newshape.points(j))
		                end if
		              next
		            end if
		            currentcontent.addshape newshape
		            MacInfo.RealFinal.append newshape.id
		          end if
		          MacInfo.IfMacs.append ifmac
		        end if
		      end if
		    end if
		  next
		  mac.macexe(macinfo)                                       //Exécution de la macro: calcul des positions de tous les points
		  for i = 0 to ubound(MacInfo.RealFinal)           //Création des skulls des objets finaux
		    n = MacInfo.RealFinal(i)
		    s = objects.GetShape(n)
		    if s isa point then
		      s.createskull(point(s).bpt)
		      point(s).mobility
		    else
		      for j = 0 to s.npts-1
		        s.createskull(s.points(j).bpt)
		        s.points(j).mobility
		      next
		    end if
		    s.endconstruction
		    s.CreateExtreAndCtrlPoints
		    s.updateskull
		  next
		  
		  
		  
		  wnd.mycanvas1.refreshbackground
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  
		  super.EndOperation
		  mw.close
		  
		  MacInfo = new MacConstructionInfo(Mac)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim n,i as integer
		  dim  sh as shape
		  dim b as boolean
		  n = CurrentItemToSet
		  
		  sh = super.getshape(p)
		  fa = mac.fainit(n-1)
		  fo = mac.foinit(n-1)
		  nobj = visible.count
		  
		  for i = visible.count-1 downto 0
		    sh = visible.element(i)
		    b = (sh.fam <> fa)
		    
		    select case fa   //une macro valable pour (par ex) un Triangle doit pouvoir être appliquée à un triangiso ou un triangrect ou...
		    case 1               //une macro valable pour un segment  (fa = 1, fo < 3) doit pouvoir être appliquée à un côté de polygone
		      select case fo
		      case 0
		        b = not sh.validsegment(p, side)   ' b or (sh.forme  > 2)
		      case 3
		        b = b or ((sh.forme <3) or (sh.forme > 5))
		      case 6,7,8
		        b = b or (sh.forme  <> fo)
		      end select
		    case 2
		      select case fo
		      case 0
		        b = b and not (sh.fam=6 and sh.forme = 0)
		      case 1
		        b = b or (sh.forme =0) or (sh.forme = 3)
		      case 2
		        b = not (sh isa polreg and sh.npts = 3)
		      case 3
		        b = b or (sh.fam < 3)
		      case  4
		        b = b or (sh.forme <> fo)
		      end select
		    case 3
		      select case fo
		      case 0
		        b = b and not (sh.fam=6 and sh.forme = 1)
		      case 1
		        b = b or (sh.forme > 3)
		      case 2, 3, 5, 6
		        b = b or (sh.forme <> fo)
		      case 4
		        b = b or (sh.fam < 4)
		      case 7
		        b = not (sh isa polreg and sh.npts = 4)
		      end select
		    case 4
		      b = not (sh isa polreg and sh.npts = fo+3)
		    case 5
		      b = b or sh.forme <> fo
		    case 6
		      b = not (sh isa polygon and sh.npts = fo+3)
		    end select
		    
		    if b then
		      visremove(sh)
		    end if
		  next
		  
		  nobj = visible.count
		  
		  if nobj > 0 then
		    side = visible.element(iobj).pointonside(p)
		    return visible.element(iobj)
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Mac As Macro
	#tag EndProperty

	#tag Property, Flags = &h0
		MacInfo As MacConstructionInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		Histo As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		NOp As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ListInit() As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		mw As MacWindow
	#tag EndProperty

	#tag Property, Flags = &h0
		fa As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		fo As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		side As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ntsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentItemToSet"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="MultipleSelectOperation"
		#tag EndViewProperty
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
			Name="Std2flag"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SidetoPaint"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="info"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NOp"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fa"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fo"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
