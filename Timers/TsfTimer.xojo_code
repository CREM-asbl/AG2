#tag Class
Protected Class TsfTimer
Inherits Timer
	#tag Event
		Sub Action()
		  dim i, j as integer
		  dim s as shape
		  
		  if self isa RetTimer then
		    RetTimer(self).agir
		  else
		    for i=0 to ncop
		      s=copies.item(i)
		      s.Transform(M1)              
		      for j = 0 to ubound(s.childs)
		        s.childs(j).modified = true
		      next
		      if s.Hybrid or s isa circle then
		        s.coord.MoveExtreCtrl(M1)
		      end if
		    next
		    can.RefreshBackground
		    copies.enablemodifyall
		    pas = pas-1
		    
		    if pas =  0 then
		      for i = 0 to ncop
		        s = copies.item(i)
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
		      curoper.endoperation
		    end if
		  end if
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(copies as objectslist)
		  dim i as integer
		  dim s as shape
		  
		  objects = CurrentContent.Theobjects
		  
		  self.copies = copies
		  ncop = copies.count-1
		  for i = 0 to ncop
		    s = copies.item(i)
		    if s isa circle then
		      s.coord.createextreandctrlpoints(s.ori)
		    end if
		  next
		  niter = 60
		  Mode = ModeMultiple
		  period= 50
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(copies as ObjectsList, curop as AppliquerTsf)
		  
		  dim i as integer
		  dim s as shape
		  
		  objects =CurrentContent.Theobjects
		  enabled = false
		  self.copies = copies
		  ncop = copies.count-1
		  for i = 0 to ncop
		    s = copies.item(i)
		    if s isa circle then
		      s.coord.createextreandctrlpoints(s.ori)
		    end if
		  next
		  
		  curoper = AppliquerTsf(curop)
		  curtsf = curop.tsf
		  can.MouseCursor = system.Cursors.wait
		  niter = 60
		  if curop.tsf.type <> 9 and curop.tsf.type <> 11 then
		    M1 = curop.tsf.M.RacN(niter)
		  else
		    M1 = curop.tsf.RacN(niter)
		  end if
		  Mode = 2'ModeMultiple
		  period= 50
		  pas = niter
		  enabled = true
		  type = curtsf.type
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(copies as objectslist, curop as SelectAndDragOperation)
		  constructor(copies)
		  
		  dim p as Basicpoint
		  dim a as double
		  
		  
		  p = new BasicPoint(0,0)
		  
		  select case curop.GetName
		  case Dico.Value("Tourner")
		    M1= new RotationMatrix(p, a/niter)
		  case Dico.Value("Zoom")
		    curoper =  Redimensionner(curop)
		    a = Redimensionner(curoper).ratio
		    M1 = new HomothetyMatrix(p,Pow(a, 1/niter))
		  end select
		  drap = true
		  enabled = true
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
		copies As objectslist
	#tag EndProperty

	#tag Property, Flags = &h0
		curoper As Operation
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected curtsf As Transformation
	#tag EndProperty

	#tag Property, Flags = &h0
		drap As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		M1 As Matrix
	#tag EndProperty

	#tag Property, Flags = &h0
		ncop As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		niter As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		objects As objectslist
	#tag EndProperty

	#tag Property, Flags = &h0
		pas As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		type As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
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
			Name="Enabled"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunMode"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="RunModes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Off"
				"1 - Single"
				"2 - Multiple"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="drap"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ncop"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="niter"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="pas"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Period"
			Visible=true
			Group="Behavior"
			InitialValue="1000"
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
			Name="type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
