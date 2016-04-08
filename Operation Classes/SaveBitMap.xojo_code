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
		  pic.graphics.drawpicture wnd.mycanvas1.Background, 0, 0, pic.width, pic.height, lux+1, luy+1,drx-lux-2,dry-luy-2
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
		  'wnd.MyCanvas1.RefreshBackground
		  pic = New Picture(drx-lux-2,dry-luy-2,32)
		  pic.graphics.drawpicture wnd.mycanvas1.Background, 0, 0, pic.width, pic.height, lux+1, luy+1,drx-lux-2,dry-luy-2
		  drap = not exportpicture(Pic)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Endoperation()
		  lux = 0
		  luy = 0
		  drx = 0
		  dry = 0
		  wnd.Mycanvas1.Mousecursor = System.Cursors.StandardPointer
		  finished = true
		  
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
		  
		  drap = true
		  q = wnd.mycanvas1.transform(p)
		  drx = q.x
		  dry = q.y
		  lux = q.x
		  luy = q.y
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDrag(p as BasicPoint)
		  dim q as BasicPoint
		  
		  if drap then
		    q = wnd.mycanvas1.transform(p)
		    if q.x <> drx or q.y <> dry then
		      drx = q.x
		      dry = q.y
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseUp(p as BasicPoint)
		  if drap and (drx <> lux) and (dry <> luy) then
		    wnd.Mycanvas1.Mousecursor = System.Cursors.Wait
		    DoOperation
		    EndOperation
		  else
		    finished = false
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  if not finished  then
		    if not drap then
		      Help g, cutawindow
		    else
		      Help g,  wait
		    end if
		  else
		  end if
		  g.drawrect lux, luy, drx-lux, dry - luy
		  
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
			Name="SidetoPaint"
			Group="Behavior"
			InitialValue="0"
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