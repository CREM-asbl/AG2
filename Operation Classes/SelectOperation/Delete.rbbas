#tag Class
Protected Class Delete
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Delete()
		  SelectOperation
		  OpId = 7
		  wnd.refreshtitle
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i as integer
		  dim ids(-1) as integer
		  
		  
		  if ubound(todelete) = -1 then
		    return
		  end if
		  
		  currenthighlightedshape = nil
		  for i = 0 to ubound(todelete)
		    ids.append todelete(i).id
		  next
		  
		  ids.sortwith todelete
		  
		  figs = new figslist
		  for i = 0 to ubound(todelete)
		    objects.selectobject todelete(i)
		    figs.addfigure todelete(i).fig
		  next
		  CurrentContent.Thefigs.Removefigures figs
		  
		  for i = ubound(todelete) downto 0
		    todelete(i).delete
		  next
		  
		  if CurrentContent.ForHisto and figs.count > 0 then
		    figs.restructurer
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As String
		  return Dico.Value("EditDelete")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim i as integer
		  
		  super.paint(g)
		  
		  
		  if CurrentHighlightedShape <> nil then
		    display = this +  " " +currenthighlightedshape.gettype + " ?"
		  elseif objects.count > 1 then
		    display = choose+aform+asupprimer
		  end if
		  Help g, display
		  
		  for i = 0 to ubound(todelete)
		    todelete(i).paint(g)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  ReDeleteCreatedFigures (Temp)
		  ReCreateDeletedFigures(Temp)
		  wnd.refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  dim i as integer
		  
		  SelectIdForms(Temp)
		  for i =  tempshape.count -1 downto 0
		    tempshape.element(i).delete
		  next
		  objects.unselectall
		  
		  ReDeleteDeletedFigures(Temp)
		  ReCreateCreatedFigures(Temp)
		  wnd.refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXML(Doc as XMLDocument) As XMLElement
		  return tempshape.XMLPutIdInContainer(Doc)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(P as BasicPoint) As shape
		  dim s as shape
		  dim i, j as integer
		  
		  s = super.getshape(p)
		  
		  if visible.count > 0 then
		    for i =  visible.count-1 downto 0
		      s = Visible.element(i)
		      if s isa point  and not point(s).isolated   then
		        for j = 0 to ubound(point(s).parents)
		          visible.addshape point(s).parents(j)
		        next
		        visible.removeshape s
		        nobj = visible.count
		      end if
		    next
		  end if
		  
		  if Visible.count > 0  then
		    return visible.element(iobj)
		  else
		    return nil
		  end if
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(P as BasicPoint)
		  redim todelete(-1)
		  dim s as shape
		  
		  objects.unhighlightall
		  s = Getshape(p)
		  if s <> nil then
		    highlight(s)
		    wnd.mycanvas1.refreshbackground
		    currenthighlightedshape = s
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub highlight(s as shape)
		  dim i, j as integer
		  dim p as point
		  dim sh as shape
		  dim t as boolean
		  
		  if s.highlighted then
		    return
		  end if
		  
		  if s isa point then
		    p = point(s)
		    for i = 0 to ubound(p.parents)
		      if p.parents(i).getindexpoint(p) <> -1 and  p.parents(i).id  < p.id  then  'and not p.parents(i).highlighted   then 'on n'enlève pas les points plus jeunes que leurs parents sans enlever ceux-ci
		        highlight(p.parents(i))
		        'return
		      end if
		    next
		  end if
		  
		  for i = Ubound(s.ConstructedShapes) downto 0
		    highlight(s.ConstructedShapes(i))
		  next
		  
		  for i = 0 to s.tsfi.count-1
		    for j = 0 to s.tsfi.element(i).constructedshapes.count -1
		      highlight(s.tsfi.element(i).constructedshapes.element(j))
		    next
		  next
		  
		  todelete.append s
		  s.highlight
		  
		  if not (s isa point) then
		    for i = 0 to ubound(s.childs)
		      if s.childs(i).id > s.id then
		        highlight(s.childs(i))  ' on  enlève les sommets et pointssur plus jeunes qu'une forme qu'on enlève
		      end if
		    next
		  else
		    p = point(s)  ' quand on arrive ici, le point p n'a plus de parents plus âgés que lui qui n'aient pas déjà été highlighted. On peut supprimer les parents plus jeunes
		    for i = 0 to ubound (p.parents)  'sauf ceux pour lesquels p est un pointsur
		      if p.parents(i).getindexpoint(p) <> -1 then
		        highlight(p.parents(i))
		      end if
		    next
		  end if
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.endoperation
		  currentcontent.optimize
		  redim todelete(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  
		  Finished = false
		  wnd.Mycanvas1.Mousecursor = System.Cursors.Wait
		  DoOperation
		  endoperation
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseWheel()
		  dim i as integer
		  dim pt as point
		  
		  redim todelete(-1)
		  
		  if visible <> nil and visible.count <> 0 then
		    nobj = visible.count
		    iobj = (iobj+1) mod nobj
		    if CurrentHighlightedShape<>nil then
		      CurrentHighlightedShape.UnHighLight
		      if currenthighlightedshape isa point then
		        pt = point(currenthighlightedshape)
		        for i = 0 to ubound (pt.parents)
		          pt.parents(i).unhighlight
		        next
		      end if
		    end if
		    
		    CurrentHighlightedShape = visible.element(iobj)
		    Highlight(CurrentHighlightedShape)
		    if currenthighlightedshape isa point then
		      pt = point(currenthighlightedshape)
		      for i = 0 to ubound (pt.parents)
		        highlight(pt.parents(i))
		      next
		    end if
		    
		    Wnd.mycanvas1.refreshbackground
		  end if
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
		todelete() As shape
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
	#tag EndViewBehavior
End Class
#tag EndClass
