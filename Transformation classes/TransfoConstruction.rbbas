#tag Class
Protected Class TransfoConstruction
Inherits MultipleSelectOperation
	#tag Method, Flags = &h0
		Sub TransfoConstruction(n as integer)
		  MultipleSelectOperation()
		  OPId = 17
		  type = n
		  select case Type
		  case 1
		    NumberOfItemsToSelect =2
		  case 2 to 6
		    NumberOfItemsToSelect=1
		  case 7,8,9,10
		    NumberOfItemsToSelect=4
		  end select
		  
		  ori = 1 //par défaut
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  
		  tsf = new transformation (currentshape, type, index(iobj) , ori)
		  currentshape.tsfi.addtsf tsf
		  if currentshape isa point then
		    currentshape.borderwidth = 2
		  end if
		  
		  // ori est destiné aux translations
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  super .paint(g)
		  
		  if currenthighlightedshape = nil then
		    select  case currentitemtoset
		    case 1
		      select case type
		      case 1
		        display =  choose + asegment + oroneofitsendpoints
		      case 2
		        display =  choose + anarc
		      case 3 to 5
		        display =  choose + apoint
		      case 6
		        display =  choose + asegmentoraline + orahalfline
		      case 7
		        display = choose + atrapezoid + orfourpoints
		      case 8
		        display = choose + aquad +  orfourpoints
		      case 9
		      end select
		    case 2
		      select case type
		      case 1
		        display = choose + theotherendpoint
		      case 7to 9
		        display = choose + anotherpoint
		      end select
		    case 3, 4
		      display = choose + apoint
		    end select
		  else
		    select case currentitemtoset
		    case 1
		      if currenthighlightedshape isa polygon and type < 7 then
		        polygon(currenthighlightedshape).paintside(g,index(iobj),2,Config.highlightcolor)
		      else
		        currenthighlightedshape.highlight
		      end if
		      if currenthighlightedshape isa point then
		        display = thispoint+" ?"
		      elseif currenthighlightedshape isa arc then
		        display = this + " "+ arc + " ?"
		      elseif  currenthighlightedshape isa droite then
		        display = thissegment + "/"+cette+" "+droite+" ?"
		      elseif currenthighlightedshape isa trap then
		        display = this+ " " +trap+" ?"
		      elseif currenthighlightedshape isa quadri then
		        display = this + " "+ quadri+" ?"
		      end if
		    else
		      display = thispoint+" ?"
		    end select
		  end if
		  Help g, display
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLelement
		  dim Temp  as XMLElement
		  
		  
		  Temp=Doc.CreateElement("Transformation")
		  if qp <> nil then
		    Temp.SetAttribute("NewSupp", str(1))
		  end if
		  Temp.appendchild tsf.supp.XMLPutIdINContainer(Doc)
		  Temp.SetAttribute("TsfType", str(type))
		  Temp.setattribute("Ori",str(ori))
		  if   tsf.supp isa Bande or tsf.supp isa polygon or tsf.supp isa secteur  then
		    Temp.setattribute("Index", str(index(iobj)))
		  end if
		  Temp.SetAttribute("NumTSF",str(tsf.GetNum))
		  
		  return Temp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  
		  return Dico.Value("DefinirTransformation")
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TransfoConstruction()
		  MultipleSelectOperation()
		  wnd.pointerpolyg
		  OPId = 17
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim supp as shape
		  dim EL as XMLElement
		  dim num as integer
		  
		  EL = XMLElement(Temp.firstchild)
		  supp = SelectForm(EL)
		  num = val(EL.Getattribute("NumTSF"))
		  CurrentContent.TheTransfos.RemoveTsf(supp.tsfi.element(num))
		  supp.tsfi.Transfos.Remove num
		  if supp.tsfi.count = 0 then
		    'if val(EL.GetAttribute("NewSupp")) = 1 then
		    'supp.delete
		    'end if
		    supp.bordercolor = Config.bordercolor
		    if supp isa point then
		      supp.borderwidth = 1
		    end if
		  end if
		  ReDeleteCreatedFigures (Temp)
		  ReCreateDeletedFigures(Temp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function setitem(s as shape) As Boolean
		  dim d, d2 as double
		  dim bp1, bp2 as BasicPoint
		  dim sh(-1) as shape
		  dim i, i0 as integer
		  dim qp2 as point
		  
		  if s = nil then
		    return false
		  end if
		  
		  s.unhighlight
		  select case currentitemtoset
		  case 1
		    return setfirst(s)
		  case 2
		    return setsecond(s)
		  case 3
		    tp = Point(s)
		    return true
		  case 4
		    qp = Point(s)
		    select case type
		    case 7
		      if fp = tp then
		        qp.moveto qp.bpt.projection(tp.bpt, sp.bpt)
		        currentshape = new Supphom(objects, fp,  sp, qp)
		        type = 71
		        index.append 0
		      else
		        qp.moveto qp.bpt.projection(tp.bpt, tp.bpt+sp.bpt-fp.bpt)
		        bp1 = sp.bpt - fp.bpt - qp.bpt+tp.bpt
		        if bp1*bp1 < epsilon then
		          return false
		        end if
		        currentshape = new Trap(objects, fp, sp, qp, tp)
		        type = 72
		        index.append -1
		      end if
		      
		    case 8
		      if fp = tp  and qp <> sp then
		        type = 81
		        currentshape = new  Triangle(objects, fp,  sp, qp)
		      elseif sp = tp and qp <> sp then
		        currentshape = new Triangle(objects, fp,  sp, qp)
		        type = 82
		      elseif fp <> qp and sp <>  qp and tp <> qp  then
		        currentshape = new Polyqcq(objects, fp,  sp, qp,  tp)
		      else
		        qp = nil
		        return false
		      end if
		      index.append-1
		    case 9
		      if fp <> sp then
		        currentshape = new Polyqcq(objects,fp,sp,tp,qp)
		        index.append -1
		      else
		        return false
		      end if
		    case 10
		      d = fp.DistanceTo(sp)
		      bp2 = qp.bpt - tp.bpt
		      bp2= bp2.normer
		      bp2 = bp2*d
		      qp2 = new point(objects,tp.bpt+bp2)
		      currentshape = new Polyqcq(objects,fp,sp,qp2,tp)
		      index.append -1
		    end select
		    return true
		  end select
		  return false
		  
		  // Types: 1 Translation 2 Rotation 3 Demi-tour,4 Quart G, 5 Quart D, 6 Symétrie 7 Homothétie 8 Similitude 9 Etirement 10 Déplacement
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetShape(p as basicPoint) As shape
		  dim q as point
		  
		  currentshape = super.getshape(p)  //on liste les objets visibles et on ramène le premier
		  if currentshape = nil then
		    return nil
		  end if
		  
		  select case CurrentItemToSet
		  case 1
		    return choix1(p)
		  case 2
		    return choix2(p)
		  case 3            // pour les homothéties, similitudes, étirements, isométries
		    visible= Objects.findPoint(p)
		    return point(visible.element(iobj))
		  case 4
		    visible = Objects.findpoint(p)
		    q = point( visible.element(iobj))
		    if q <> nil then
		      if fp = tp  and q = sp then
		        return nil
		      elseif sp = tp and q= sp then
		        return nil
		      elseif fp = q or sp = q or  tp = q  then
		        return nil
		      end if
		    end if
		    return q
		  end select
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.endoperation
		  
		  if type = 71 or type = 72 then
		    type = 7
		  end if
		  
		  if type = 81 or type = 82 then
		    type = 8
		  end if
		  fp = nil
		  sp = nil
		  tp = nil
		  qp = nil
		  
		  ori = 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Transfoconstruction(EL as XmlElement)
		  dim EL1 as XmlElement
		  dim num as integer
		  
		  TransfoConstruction(val(EL.GetAttribute("TsfType")))
		  ori = val(EL.GetAttribute("Ori"))
		  index.append val(EL.GetAttribute("Index"))
		  EL1 = XMLElement(EL.FirstChild)
		  CurrentShape =objects.Getshape(val(EL1.Getattribute("Id")))
		  num = val(EL.GetAttribute("Num"))
		  if CurrentShape.tsfi.count-1>=num then
		    tsf = CurrentShape.tsfi.element(num)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim supp as shape
		  dim EL, EL1 as XMLElement
		  dim n as integer
		  
		  EL = XMLElement(Temp.firstchild)
		  n = val(EL.Getattribute("NewSupp"))
		  if n = 0 then
		    supp = SelectForm(EL)
		  else
		    EL1 = XMLElement(EL.Child(0))
		    supp = Objects.XMLLoadObject(EL1)
		    ReDeleteDeletedFigures (Temp)
		    ReCreateCreatedFigures(Temp)
		  end if
		  tsf = new Transformation(supp,EL)
		  supp.tsfi.addtsf tsf
		  if supp isa point then
		    supp.borderwidth = 2
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function choix1(p as basicPoint) As shape
		  dim s as shape
		  dim i , j , k as integer
		  dim sf as figure
		  dim t as Boolean
		  
		  s = super.getshape(p)  //on liste les objets visibles et on ramène le premier
		  if s = nil then
		    return nil
		  end if
		  s.UnHighLight
		  
		  for i =  visible.count-1 downto 0
		    s = visible.element(i)
		    ExclureDoublons(s, p)
		    select case type
		    case  1 // translation
		      if s isa droite and droite(s).nextre = 2  then
		        index.insert 0, 0
		      elseif  S isa Polygon and polygon(s).pointonside(p) >-1 then
		        index.insert 0, s.pointonside(p) // index contient tous les numéros de côté
		      elseif  s isa point then
		        index.insert 0, 0
		      else
		        Visremove(s)
		      end if
		      
		    case 2          // rotations
		      if not  s isa Arc then
		        Visremove(s)                             // on ne garde que les cercles (ou arcs)
		      else
		        index.Append 0                         // index ne contient que des -1 Dans ce cas, index = -1 signifie que le support est une forme complète
		      end if
		      
		    case 3 to 5                                               // demi-tour et quarts de tour
		      if not s isa point then
		        visremove(s)
		      else
		        index.Append 0
		      end if
		      
		    case 6                                                      // symétries
		      if s isa Circle or s isa point then
		        Visremove(s)                          //on supprime tous les cercles
		      elseif s isa Bande or S isa Polygon or s isa secteur then
		        k = s.pointonside(p)
		        t = false
		        for j = s.tsfi.count-1 downto 0
		          t = (s.tsfi.element(j).type = 6) and  (s.tsfi.element(j).index = k)
		        next
		        if k > -1 and not t then
		          index.insert 0, s.pointonside(p)         // index contient les numéros de côtés
		        else
		          Visremove(s)
		        end if
		      else                                                   // cas des "droites"
		        index.insert 0, 0                          //index contient 0
		      end if
		      
		    case 7 // Homothétie
		      
		      if not s isa point and( (not s isa Polygon) or ( s.npts <> 4) or (type = 7 and not s isa Trap))  then
		        Visremove(s)                             // on élimine ceux qui ne conviennent pas
		      else
		        index.append -1
		      end if
		      
		    case  8, 9, 10 //  Similitude, Etirement
		      if not s isa point and( (not s isa Polygon) or (s.npts <> 4) )  then
		        Visremove(s)                             // on élimine ceux qui ne conviennent pas
		      else
		        index.append -1
		      end if
		      
		    end select
		  next
		  // index a autant d'éléments que visible
		  // un index de -1 désigne une absence d'ambigüité
		  // ne pas confondre l'index avec le numéro de la transformation quand plusieurs sont définies sur le même support
		  
		  nobj = visible.count
		  if nobj >0 then
		    return Visible.element(iobj)
		  else
		    return nil
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function setfirst(s as shape) As Boolean
		  select case type
		  case 1
		    if s isa point then
		      fp = Point(s)
		    else
		      currentshape = s
		      nextitem
		    end if
		  case 2  to 5
		    CurrentShape = s
		  case 6
		    currentshape = s
		  case 7 to 10
		    if s isa point then
		      fp = point(s)
		    else
		      currentshape = s
		      NextItem
		      NextItem
		      Nextitem
		    end if
		  end select
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function choix2(p as basicPoint) As shape
		  // Au cours du deuxième choix, on choisit toujours un point
		  // on ne passe dans cette méthode que si p = 1,  7, 8 ou 9 et on a choisi un point au premier tour
		  // on doit choisir un deuxième point
		  
		  dim s as shape
		  dim  i as integer
		  
		  
		  visible = Objects.FindPoint(p)
		  for i = visible.count-1 downto 0
		    s = visible.element(i)
		    if type = 1 and  not choixvalide(point(s)) then
		      visible.removeshape(s)
		    end if
		  next
		  
		  s = visible.element(iobj)
		  
		  if s = nil or s = fp then
		    return nil
		  end if
		  
		  select case type
		  case 1
		    return s
		  case 7 to 10
		    return s
		  end select
		  
		  
		  return nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function setsecond(s as shape) As Boolean
		  sp = Point(s)
		  if sp <> fp then
		    return true
		  else
		    sp = nil
		    return false
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function trap(byref s as shape) As boolean
		  dim i as integer
		  dim t as boolean
		  s = nil
		  
		  for i = 0 to ubound(fp.parents)
		    if fp.parents(i) isa trap then
		      s = fp.parents(i)
		      t = (s.points(0)=fp) and (s.points(1) = sp) and (s.points(2) = qp) and (s.points(3) = tp)
		      if t then
		        return true
		      end if
		    end if
		  next
		  
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Choixvalide(p as point) As Boolean
		  dim  i, j, h, k as integer
		  dim curshape as shape
		  //On ne passe ici que pour le choix du deuxième point d'une translation
		  
		  if p = nil then
		    return false
		  end if
		  
		  if fp.onsameshape(p,curshape) and  (curshape isa droite or curshape isa polygon) then
		    h = curshape.GetIndexPoint(fp)
		    k = curshape.GetIndexPoint(p)
		    if h=-1 or k=-1 then
		      return false
		    end if
		    if abs(k-h) = 1 or abs(k-h) = curshape.npts-1  then
		      currentshape = curshape
		      if curshape isa polygon then
		        if  h = curshape.npts-1 and k = 0  then
		          index.Append h
		        elseif k = curshape.npts-1 and h = 0 then
		          ori = - 1
		          index.Append k
		        elseif h > k  then
		          ori = -1
		          index.Append k
		        else
		          ori = 1
		          index.Append h
		        end if
		      else
		        // pour les segments
		        if h > k  then
		          ori = -1
		        end if
		        if curshape.tsfi.count > 0  then
		          for j = 0 to curshape.tsfi.count-1
		            if curshape.tsfi.element(j).ori = ori then
		              return false
		            end if
		          next
		        end if
		        index.Append 0
		      end if
		      return true
		    end if
		  end if
		  return false
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExclureDoublons(s as shape, p as Basicpoint)
		  dim j as integer
		  
		  if  s.tsfi.count > 0 then
		    for j = 0 to s.tsfi.count-1
		      if s.tsfi.element(j).type = type and s.tsfi.element(j).index = s.pointonside(p)  then
		        visremove(s)
		      end if
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetType(type As Integer) As string
		  select case Type
		  case 1
		    return Dico.Value("Translation")
		  case 2
		    return Dico.Value("Rotation")
		  case 3
		    return Dico.Value("Demitour")
		  case 4
		    return Dico.Value("QuartG")
		  case 5
		    return Dico.Value("QuartD")
		  case 6
		    return Dico.Value("Symmetrieaxiale")
		  case 7
		    return Dico.Value("Homothety")
		  case 8, 81, 82
		    return Dico.value("Similitude")
		  case 9
		    return Dico.value("Etirement")
		  case 10
		    return Dico.value("Deplacement")
		  end select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToMac(Doc as XMLDocument, EL as XMLElement) As XMLElement
		  EL.appendchild tsf.supp.XMLPutIdINContainer(Doc)
		  EL.SetAttribute("TsfType", str(type))
		  EL.setattribute("Ori",str(ori))
		  if   tsf.supp isa Bande or tsf.supp isa polygon or tsf.supp isa secteur  then
		    EL.setattribute("Index", str(index(iobj)))
		  end if
		  'EL.SetAttribute("NumTSF",str(tsf.GetNum))
		  return EL
		  
		End Function
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

	#tag Note, Name = Codes
		
		Codes des transfos:
		
		1: Translation
		2: Rotation
		3: Demi-tour
		4: Quart de tour à gauche
		5: Quart de tour à droite
		6: Symétrie axiale
		7, 71, 72: Homothétie
		8, 81, 82: Similitude
		9: Etirement
		10: Isométrie
		
		Si le code est >= 7, il est possible que le support soit un quadrilatère
		Si le code est 1 ou 6, le support peut être un polygone, il doit alors être accompagné d'un numéro de côté (propriété index de la tsf)
		
		Le code 0 est utilisé pour les pseudo-transformations associées aux paraperp
	#tag EndNote


	#tag Property, Flags = &h0
		type As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		tsf As transformation
	#tag EndProperty

	#tag Property, Flags = &h0
		fp As point
	#tag EndProperty

	#tag Property, Flags = &h0
		sp As point
	#tag EndProperty

	#tag Property, Flags = &h0
		ratio As double
	#tag EndProperty

	#tag Property, Flags = &h0
		ori As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		tp As Point
	#tag EndProperty

	#tag Property, Flags = &h0
		qp As Point
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
			Name="display"
			Group="Behavior"
			Type="string"
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
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="type"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ratio"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ori"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
