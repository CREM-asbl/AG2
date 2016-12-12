#tag Class
Protected Class RetTimer
Inherits TsfTimer
	#tag Method, Flags = &h0
		Sub agir()
		  dim i,j , j0, ntdbp as integer
		  dim s as shape
		  dim se as secteur
		  dim t as TriDShape
		  dim  p as BasicPoint
		  dim v as TriDPoint
		  dim M as Matrix
		  
		  
		  
		  for i = 0 to ncop
		    s = copies.item(i)
		    t = TriDCopies(i)
		    for j =0 to Ubound(t.TriDPts)
		      t.TriDPts(j) = M3D* (t.TriDPts(j))
		    next
		    if s isa point then
		      point(s).moveto t.TriDpts(0).Projplan+fp
		    else
		      ntdbp = ubound(s.childs)   'ntdbp : nombre de basicpoints (bp) à 3 dim (td)
		      for j = 0 to ntdbp
		        s.childs(j).moveto  t.TriDPts(j).ProjPlan + fp
		      next j
		    end if
		    s.updatecoord
		    
		    if s isa secteur then
		      secteur(s).computeextre
		    end if
		    
		    if (s isa circle or s.narcs >0) and not s isa secteur then
		      for j = 0 to ubound(s.coord.extre)
		        s.coord.extre(j) =  t.TriDPts(ntdbp+1+j).ProjPlan + fp
		      next
		      for j = 0 to ubound(s.coord.ctrl)
		        if not s isa circle then
		          s.coord.ctrl(j) =  t.TriDPts(ntdbp+2*s.narcs+1+j).ProjPlan + fp
		        else
		          s.coord.ctrl(j) =  t.TriDPts(ntdbp+3+j).ProjPlan + fp
		        end if
		      next
		    end if
		    
		    'if s isa secteur then
		    'se = secteur(s)
		    'for j = 0 to ubound(se.skullcoord.extre)
		    'se.skullcoord.extre(j) =  t.TriDPts(ntdbp+1+j).ProjPlan + fp
		    'next
		    'for j = 0 to ubound(se.skullcoord.ctrl)
		    'se.skullcoord.ctrl(j) =  t.TriDPts(ntdbp+2*se.narcs+1+j).ProjPlan + fp
		    'next
		    'end if
		    
		    if pas = niter/2  then
		      if Config.stdbiface or (s.Ti <> nil and (s.fillcolor.equal(poscolor) or s.fillcolor.equal(negcolor) )) then
		        s.fixecouleurfond(s.fillcolor.comp, s.fill)
		      end if
		    end if
		  next i
		  
		  if pas = niter/2  and  copies.count > 1 then
		    copies.inverserordre
		  end if
		  pas = pas -1
		  
		  if pas = 0 then
		    for i = 0 to ncop
		      s = copies.item(i)
		      s.ori = - s.ori
		      s.unhighlight
		      if s isa point and point(s).pointsur.count = 1 then
		        point(s).puton Point(s).pointsur.item(0)
		        point(s).mobility
		      end if
		      if s isa standardpolygon then
		        standardpolygon(s).updateangle
		      end if
		    next
		    
		    enabled = false
		    dret = nil
		    if curoper isa retourner  then
		      for i = 0 to ncop
		        s = copies.item(i)
		        s.ori = - s.ori
		      next
		      copies.inverserordre
		      M = new SymmetryMatrix(fp, fp+sp)
		      figs.movepoints(M)
		      Retourner(curoper).DoOper
		    end if
		    
		    if CurrentContent.ForHisto then
		      curoper.endoperation
		    end if
		    objects.unselectall
		    CurrentContent.isaundoredo = false
		    can.Mousecursor =System.Cursors.StandardPointer
		  end if
		  can.refreshbackground
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(tempshape as objectslist, curop as appliquertsf)
		  
		  dim p as BasicPoint
		  
		  curoper = curop
		  super.constructor(tempshape)
		  
		  curtsf = curop.tsf
		  fp = curtsf.fp
		  sp = curtsf.sp
		  p = sp- fp
		  beta = p.anglepolaire
		  if PI <  beta and beta < 2* PI then
		    beta = beta-PI
		  end if
		  if  PIDEMI  < beta then
		    beta = beta - PI
		  end if
		  alpha = PI/niter
		  type = 1
		  Initialisation
		  enabled = true
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(tempshape as Objectslist, curop As Retourner)
		  dim i, j as integer
		  
		  for i = 0 to tempshape.count-1
		    for j = 0 to ubound(tempshape.item(i).constructedshapes)
		      if tempshape.item(i).constructedshapes(j).centerordivpoint then
		        tempshape.addshape tempshape.item(i).constructedshapes(j)
		      end if
		    next
		  next
		  super.constructor(tempshape)
		  fp = curop.c
		  sp = curop.p
		  curoper = curop
		  beta = curop.angle
		  alpha = PI/niter
		  type = 0
		  figs = curop.figs
		  Initialisation
		  enabled = true
		  tempshape.unhighlightall
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Initialisation()
		  dim i, j as integer
		  dim td as TriDShape
		  dim s as shape
		  dim r as double
		  dim q as BasicPoint
		  
		  M3D = new Matrix3D(beta,alpha)
		  pas = niter
		  for i = 0 to ncop
		    s = copies.item(i)
		    s.tsp = false
		    if curoper isa Retourner then
		      Td = new TriDshape(s,fp)
		    else
		      Td = new TriDshape(s,curtsf.fp)
		    end if
		    TridCopies.append Td
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
		alpha As double
	#tag EndProperty

	#tag Property, Flags = &h0
		beta As double
	#tag EndProperty

	#tag Property, Flags = &h0
		dp As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		figs As figslist
	#tag EndProperty

	#tag Property, Flags = &h0
		fp As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		M3D As Matrix3D
	#tag EndProperty

	#tag Property, Flags = &h0
		sc As double
	#tag EndProperty

	#tag Property, Flags = &h0
		sp As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		TriDcopies(-1) As Tridshape
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="alpha"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="beta"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drap"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Mode"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Off"
				"1 - Single"
				"2 - Multiple"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncop"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="niter"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="pas"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Period"
			Visible=true
			Group="Behavior"
			InitialValue="1000"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="sc"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="type"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
