#tag Class
Protected Class Macro
	#tag Method, Flags = &h0
		Sub Macro()
		  dim MAG as XMLElement
		  
		  app.macrocreation = true
		  wnd.MenuBar.child("Fenetres").Item(wnd.GetNumWindow).text = Dico.Value("MacrosCreate")
		  wnd.mac = self
		  wnd.refreshtitle
		  wnd.refresh
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Sauvegarder()
		  
		  Dim file As FolderItem
		  Dim fileStream as TextOutputStream
		  dim place as integer
		  dim SaveMag as new FileType
		  SaveMag.Name = "Mag"
		  SaveMag.Extensions = "macag"
		  
		  CurrentContent.CurrentOperation = nil
		  
		  file=GetSaveFolderItem(SaveMag,"Macro"+str(wnd.GetNumWindow)+".macag")
		  place = Instr(file.name,".macag")
		  Caption=Left(file.name,place-1)
		  CurrentContent.Histo.SetAttribute("Name",Caption)
		  
		  fileStream=file.createTextFile
		  if fileStream=nil then
		    MsgBox "Erreur lors de la sauvegarde"
		    return
		  else
		    filestream.write CurrentContent.OpList.tostring
		    fileStream.close
		  end if
		  
		  wnd.close
		  app.macros.append CurrentContent.OpList
		  CreerMenuItem
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreerMenuItem()
		  dim mitem as Menuitem
		  dim k as integer
		  
		  MenuMenus.Child("MacrosMenu").Child("MacrosSave").checked = false
		  MenuMenus.Child("MacrosMenu").Child("MacrosQuit").checked = false
		  MenuMenus.Child("MacrosMenu").Child("MacrosChoose").checked = true
		  app.EraseMenuBar
		  app.CopyMenuBar
		  
		  
		  if app.pwok then
		    mitem = new MenuItem
		    mitem.Name = "Cfg"
		    mitem.Text = Dico.Value("Cfg")
		    app.MenuBar.append mitem
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
		Caption As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Doc As XMLDocument
	#tag EndProperty


	#tag ViewBehavior
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
			Name="Caption"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
