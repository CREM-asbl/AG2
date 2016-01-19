#tag Class
Protected Class TsfTimer
Inherits Timer
	#tag Event
		Sub Action()
		  dim i, j as integer
		  dim s as shape
		  dim  p as BasicPoint
		  
		  
		  
		  if self isa RetTimer then
		    RetTimer(self).agir
		  else
		    can.MouseCursor = System.Cursors.wait
		    for i=0 to ncop
		      s=copies.element(i)
		      s.Transform(M1)
		      if s isa circle then
		        circle(s).coord.MoveExtreCtrl(M1)
		      end if
		      for j = 0 to ubound(s.childs)
		        s.childs(j).modified = true
		      next
		      if s isa Lacet then
		        Lacet(s).coord.MoveExtreCtrl(M1)
		      end if
		    next
		    can.RefreshBackground
		    copies.enablemodifyall
		    pas = pas-1
		    
		    
		    if pas =  0 then
		      for i = 0 to ncop
		        s = copies.element(i)
		        s.unhighlight
		        if s isa point and point(s).pointsur.count = 1 then
		          point(s).puton Point(s).pointsur.element(0)
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
		  
		  can = wnd.Mycanvas1
		  objects = CurrentContent.Theobjects
		  
		  self.copies = copies
		  ncop = copies.count-1
		  for i = 0 to ncop
		    s = copies.element(i)
		    if s isa circle then
		      s.coord.createextreandctrlpoints(s.ori)
		    end if
		  next
		  niter = 60
		  pas = niter
		  
		  Mode=2
		  period=50
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(copies as ObjectsList, curop as AppliquerTsf)
		  dim q, v as BasicPoint
		  dim u1, u2, u3, u4 As  BasicPoint
		  dim Mat as SimilarityMatrix
		  dim bib1, Bib2 as BiBPoint
		  dim r1, r2 as double
		  
		  constructor(copies)
		  curoper = AppliquerTsf(curop)
		  self.tsf = curop.tsf
		  
		  select case Tsf.type
		  case 1
		    v = tsf.sp -tsf.fp
		    v = v/niter
		    M1 = new TranslationMatrix(v*tsf.ori)
		  case 2
		    M1 = new rotationmatrix (tsf.supp.points(0).bpt, arc(tsf.supp).arcangle/niter)
		  case 3
		    M1 = new rotationmatrix(point(tsf.supp).bpt, PI/niter)
		  case 4
		    M1 = new rotationmatrix(point(tsf.supp).bpt,PIDEMI/niter)
		  case 5
		    M1 = new rotationmatrix(point(tsf.supp).bpt, -PIDEMI/niter)
		  case 7,71,72
		    Mat = SimilarityMatrix(tsf.M)
		    M1 = new HomothetyMatrix(Mat.centre,  (Mat.rapport)^(1/niter))
		  case 8, 81, 82
		    Mat = SimilarityMatrix(tsf.M)
		    if abs(Mat.angle) < epsilon and abs(Mat.rapport-1) < epsilon then
		      M1 = new TranslationMatrix(Mat.v3/niter)
		    else
		      M1 = new Similaritymatrix (Mat.centre, (Mat.rapport)^(1/niter), Mat.angle/niter)
		    end if
		  case 9
		    u1= tsf.supp.points(0).bpt
		    u2= tsf.supp.points(1).bpt
		    u3= tsf.supp.points(3).bpt
		    u4 = tsf.supp.points(2).bpt
		    Bib1 = new BiBPoint(u1,u2)
		    Bib2 = new BiBPoint(u3,u4)
		    q = Bib2.BibInterdroites(bib1,0,0,r1,r2)
		    u4 = q + (u3 -q)*(((r1-1)/r1)^(1/niter))
		    M1 = new AffinityMatrix(u1,u2,u3,u1,u2,u4)
		  case 10
		    Mat = SimilarityMatrix(tsf.M)
		    if Mat.angle <> 0 then
		      M1 = new Similaritymatrix (Mat.centre, 1, Mat.angle/niter)
		    else
		      M1 = new Matrix(Mat.v1, Mat.v2, Mat.v3/niter)
		    end if
		  case 11
		    u1= tsf.supp.points(0).bpt
		    u2= tsf.supp.points(1).bpt
		    u3= tsf.supp.points(3).bpt
		    u4 = tsf.supp.points(2).bpt
		    u4 = u3 + (u4-u3)/niter
		    M1 = new AffinityMatrix(u1,u2,u3,u1,u2,u4)
		  end select
		  enabled = true
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
		can As Mycanvas
	#tag EndProperty

	#tag Property, Flags = &h0
		copies As objectslist
	#tag EndProperty

	#tag Property, Flags = &h0
		curoper As Operation
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

	#tag Property, Flags = &h1
		Protected Tsf As Transformation
	#tag EndProperty


	#tag ViewBehavior
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
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
