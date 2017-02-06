#tag Class
Protected Class SaveBitMap
Inherits Operation
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  finished = false
		  OpId = 2
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(x0 as integer, y0 as integer, x1 as integer, y1 as integer)
		  dim pic as Picture
		  
		  super.Constructor
		  finished = false
		  OpId = 2
		  
		  lux = x0
		  luy = y0
		  drx = x1
		  dry = y1
		  pic = New Picture(drx-lux-2,dry-luy-2,32)
		  pic.graphics.drawpicture can.BackgroundPicture, 0, 0, pic.width, pic.height, lux+1, luy+1,drx-lux-2,dry-luy-2
		  drap = not exportpicture(Pic)
		  EndOperation
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim pic as picture
		  dim temp as integer
		  
		  if lux > drx then
		    temp = lux
		    lux = drx
		    drx = temp
		  end if
		  
		  if luy >dry then
		    temp = luy
		    luy = dry
		    dry = temp
		  end if
		  can.RefreshBackground
		  pic = New Picture(drx-lux-2,dry-luy-2,32)
		  pic.graphics.drawpicture can.BackgroundPicture, 0, 0, pic.width, pic.height, lux+1, luy+1,drx-lux-2,dry-luy-2
		  finished = exportpicture(Pic)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Endoperation()
		  lux = 0
		  luy = 0
		  drx = 0
		  dry = 0
		  can.Mousecursor = System.Cursors.StandardPointer
		  drap = false
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return "SaveBitMap"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(p as BasicPoint)
		  dim q as basicpoint
		  
		  if not drap then
		    drap = true
		    
		    q = can.transform(p)
		    drx = q.x
		    dry = q.y
		    lux = q.x
		    luy = q.y
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDrag(p as BasicPoint)
		  RectLimit(p)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(p as BasicPoint)
		  RectLimit(p)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseUp(p as BasicPoint)
		  if drap and (drx <> lux) and (dry <> luy) then
		    can.Mousecursor = System.Cursors.Wait
		    DoOperation
		    EndOperation
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  Help g, cutawindow
		  g.drawrect lux, luy, drx-lux, dry - luy
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RectLimit(p as BasicPoint)
		  dim q as BasicPoint
		  
		  if drap then
		    q = can.transform(p)
		    if q.x <> drx or q.y <> dry then
		      drx = q.x
		      dry = q.y
		    end if
		  end if
		  can.refreshbackground
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
		drap As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drx As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		dry As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		lux As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		luy As Integer
	#tag EndProperty


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
			Name="drap"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drx"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="dry"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="lux"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="luy"
			Group="Behavior"
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
			Name="Std2flag"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
