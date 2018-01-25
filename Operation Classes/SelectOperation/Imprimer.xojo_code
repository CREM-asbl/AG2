#tag Class
Protected Class Imprimer
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  OpId = 9
		  
		  
		  if tempshape.count  = 0 then
		    objects.selectobject objects.element(0)
		    objects.selectall
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim printWidth, printHeight, sc, sw, sh as double
		  dim printLeft, printTop, i, copies as integer
		  dim o as shape
		  dim p as BasicPoint
		  dim d as date
		  dim gprint as graphics
		  dim Pict As Picture
		  dim prtsetup As PrinterSetup
		  
		  prtsetup = new PrinterSetup
		  dim PS as Boolean = prtsetup.PageSetupDialog 
		  
		  sw = prtsetup.Width/can.width
		  sh = prtsetup.Height/can.height
		  sc = min(sw,sh)
		  printLeft =  -prtsetup.PageLeft
		  printTop =  -prtsetup.PageTop
		  printWidth =  can.width*sc
		  printHeight =  can.height*sc
		  
		  Pict = new Picture(printWidth,printHeight,Screen(0).Depth)
		  
		  gprint = OpenPrinterDialog(prtsetup)
		  
		  if gprint <> nil then
		    if WorkWindow.backcolor = noir then
		      switch = true
		      WorkWindow.switchcolors
		    end if
		    can.mousecursor = system.Cursors.Wait
		    
		    'le gprint.copies est-il nécessaire étant donné que l'on dessine que dans l'espace d'une page ?(prtsetup.width, prtsetup.height)
		    for copies=1 to gprint.Copies
		      for i=0 to tempshape.count-1
		        o = tempshape.item(i)
		        if (not o.invalid  and not o.hidden and not o.deleted) or o isa repere then
		          o.print(Pict.Graphics, sc)
		        end if
		      next
		      
		      if CurrentContent.thegrid <> nil then
		        CurrentContent.thegrid.print(Pict.Graphics, sc)
		      end if
		      
		      'if CurrentContent.TheObjects.tracept then
		      'Pict.Graphics.DrawPicture can.OffscreenPicture, 0, 0
		      'end if
		      
		      d = new date
		      
		      gprint.DrawPicture Pict, printLeft, printTop+2, printWidth, printHeight, 0, 0, Pict.width, Pict.height
		      gprint.drawstring  WorkWindow.Title+ " -- " + str(d.day)+"/"+str(d.month)+"/"+str(d.year), printLeft, printTop 
		      gprint.drawrect printLeft, printTop+2, printWidth, printHeight-2
		      
		      if copies<gprint.Copies then
		        gprint.NextPage
		      end if
		    next
		    can.mousecursor = System.Cursors.StandardPointer
		  end if
		  if switch then
		    WorkWindow.switchcolors
		  end if
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.value("FilePrint")
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


	#tag Property, Flags = &h0
		prtsettings As string
	#tag EndProperty

	#tag Property, Flags = &h0
		switch As boolean
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
			Name="prtsettings"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
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
			Name="switch"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
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
