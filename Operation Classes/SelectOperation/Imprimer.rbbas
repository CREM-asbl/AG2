#tag Class
Protected Class Imprimer
Inherits SelectOperation
	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.value("FilePrint")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Imprimer()
		  SelectOperation
		  OpId = 9
		  dim g as Graphics
		  dim s as String
		  
		  Dim shell As Shell
		  shell= New Shell
		  #if TargetLinux
		    shell.execute "lp"
		    MsgBox shell.Result
		  #endif
		  
		  s = ""
		  g = OpenPrinter()
		  
		  if g <> nil then
		    s = "OpenPrinter"
		  end if
		  
		  g = OpenPrinterDialog()
		  if g  <> nil then
		    s = "OpenDialog"
		  end if
		  
		  
		  MsgBox s
		  
		  if tempshape.count  = 0 then
		    objects.selectobject objects.element(0)
		    objects.selectall
		  end if
		  
		  if app.prtsetup = nil then
		    app.prtsetup = New PrinterSetup
		    If not app.prtsetup.PageSetupDialog then
		      app.prtsetup = nil
		    end if
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim sc,sw,sh as double
		  dim i,copies as integer
		  dim o as shape
		  dim p as BasicPoint
		  dim d as date
		  dim gprint, test as graphics
		  dim Pict As Picture
		  
		  if app.prtsetup = nil then
		    return
		  end if
		  
		  sw = app.prtsetup.width/wnd.Mycanvas1.width
		  sh = app.prtsetup.height/wnd.Mycanvas1.height
		  sc = min(sw,sh)
		  Pict = new Picture(wnd.Mycanvas1.width,wnd.Mycanvas1.height,Screen(0).Depth)
		  
		  gprint = OpenPrinterDialog()
		  
		  if gprint <> nil then
		    if wnd.backcolor = noir then
		      switch = true
		      wnd.switchcolors
		    end if
		    wnd.Mycanvas1.mousecursor = system.Cursors.Wait
		    for copies=1 to gprint.Copies
		      for i=0 to tempshape.count-1
		        o = tempshape.Element(i)
		        if (not o.invalid  and not o.hidden and not o.deleted) or o isa repere then
		          o.print(Pict.Graphics)
		        end if
		      next
		      
		      if CurrentContent.thegrid <> nil then
		        CurrentContent.thegrid.paint(Pict.Graphics)
		      end if
		      
		      if CurrentContent.TheObjects.tracept then
		        Pict.Graphics.DrawPicture wnd.Mycanvas1.OffscreenPicture, 0, 0
		      end if
		      
		      d = new date
		      gprint.DrawPicture Pict,0,0,wnd.Mycanvas1.width*sc, wnd.Mycanvas1.height*sc,0,0,wnd.Mycanvas1.width,wnd.Mycanvas1.height
		      gprint.drawstring  wnd.Title+ " -- " + str(d.day)+"/"+str(d.month)+"/"+str(d.year) , 0,  -2
		      gprint.drawrect 0,0,wnd.Mycanvas1.width*sc, (wnd.Mycanvas1.height-1)*sc
		      if copies<gprint.Copies then
		        gprint.NextPage
		      end if
		    next
		    wnd.Mycanvas1.mousecursor = ArrowCursor
		  end if
		  if switch then
		    wnd.switchcolors
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
		switch As boolean
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
		#tag ViewProperty
			Name="switch"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
