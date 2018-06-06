#tag Class
Protected Class Coller
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  SelectOperation.Constructor
		  OpId = 6
		  objects.unselectall
		  copies = new ObjectsList
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub copiercenterordivpoint(s as shape, s2 as shape, i As integer)
		  dim i0, j, n as integer
		  dim fp, sp as point
		  dim s1 as shape
		  dim Bib as BiBPoint
		  dim Trib as TriBPoint
		  
		  i0 = -1
		  
		  s1 = s.constructedby.shape
		  
		  for j =0 to i-1
		    if s1 = tempshape.item(j) then
		      i0 = j
		    end if
		  next
		  
		  if i0 = -1 then
		    return
		  end if
		  
		  s2.setconstructedby(copies.item(i0),s.constructedby.oper)
		  select case s.constructedby.oper
		  case 0
		    point(s2).moveto copies.item(i0).getgravitycenter
		  case 4
		    fp =  point(s.constructedby.data(0))
		    n = s1.getindexpoint(fp)
		    fp = copies.item(i0).points(n)
		    s2.constructedby.data.append fp
		    sp =  point(s.constructedby.data(1))
		    n = s1.getindexpoint(sp)
		    sp = copies.item(i0).points(n)
		    s2.constructedby.data.append sp
		    s2.constructedby.data.append s.constructedby.data(2)
		    s2.constructedby.data.append s.constructedby.data(3)
		    if s2 isa circle then
		      TriB = new TriBPoint(copies.item(0).getgravitycenter,fp.bpt,sp.bpt)
		      point(s2).moveto Trib.subdiv (s1.ori,s.constructedby.data(2), s.constructedby.data(3))
		    else
		      bib = new BibPoint(fp.bpt,sp.bpt)
		      point(s2).moveto BiB.subdiv(s2.constructedby.data(2), s2.constructedby.data(3))
		    end if
		  end select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim i, j, h, n, i0 as integer
		  dim s,  s2, sj as shape
		  dim p0, v as BasicPoint
		  
		  n = tempshape.count
		  p0 = can.MouseUser
		  s = tempshape.item(0)
		  if not (s isa point)   then
		    v = p0 - s.Points(0).bpt
		  elseif s isa point then
		    v = p0-Point(s).bpt
		  end if
		  
		  if n=1 and s isa point then
		    s2 = s.Paste(Objects,v,currenthighlightedshape)
		    tempshape.objects(0) = s2
		    s2.endconstruction
		    return
		  end if
		  
		  for i = 0 to n-1
		    s = tempshape.item(i)
		    s2 = s.Paste(Objects,v)
		    copies.addshape s2
		    IdentifyPointsinCopies(s2,i) 'identification des sommets communs à deux formes
		    if s.centerordivpoint and s.constructedby.oper <> 7 then
		      copiercenterordivpoint(s,s2,i)
		    end if
		  next
		  for i = 0 to n-1
		    s = tempshape.item(i)
		    s2 = copies.item(i)
		    for h = 0 to s.npts-1
		      for j = 0 to n-1
		        sj = tempshape.item(j) 
		        if s.points(h).forme > 0 and s.points(h).pointsur.GetPosition(sj) <> -1 then
		          s2.points(h).puton copies.item(j)
		        end if
		      next
		    next
		    for h = 0 to s.npts-1
		      if s.points(h).forme=2 then
		        s2.points(h).adjustinter(s2.points(h).pointsur.element(0),s2.points(h).pointsur.element(1))
		      end if
		    next 
		    s2.endconstruction
		  next
		  LierGroupes
		  for i = 0 to n-1
		    s2.pastelabs(s)
		    's2.copierparams(s)
		    s2.updatecoord
		    tempshape.objects(i) = copies.item(i)
		  next
		  copies.removeall
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EndOperation()
		  super.endoperation
		  tempshape = app.tampon
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("EditPaste")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  
		  if app.tampon.count = 0 then
		    return
		  Else
		    tempshape = app.tampon
		    DoOperation
		    endoperation
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(Temp as XMLElement)
		  ReCreateCreatedFigures(Temp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UndoOperation(Temp as XMLElement)
		  dim i as integer
		  dim EL as XMLElement
		  objects.unselectall
		  
		  EL = XMLElement(Temp.FirstChild)
		  SelectIdForms(EL)
		  
		  for i =  tempshape.count-1 downto 0
		    tempshape.item(i).delete
		  next
		  
		  RedeleteCreatedFigures(Temp)
		  objects.unselectall
		  WorkWindow.Refresh
		  
		  
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


	#tag ViewBehavior
		#tag ViewProperty
			Name="canceling"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsep"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="info"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nobj"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ntsf"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
