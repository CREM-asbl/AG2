#tag Class
Protected Class Ouvrir
Inherits Operation
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  OpId = -1
		  currentcontent.currentoperation = self
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(f as folderitem)
		  Dim Doc As XmlDocument
		  dim Cfg as string
		  dim v1, v2, v3 as integer
		  dim version as string
		  dim msg as MessageDialog
		  dim but as MessageDialogButton
		  
		  
		  constructor()
		  
		  try
		    Doc=new XMLDocument(f)
		  catch err as XmlException
		    MsgBox Dico.Value("MsgNovalidFile")
		    return
		  end try
		  
		  
		  FagTitle = f.name
		  FAG = Doc.DocumentElement
		  if Doc.FirstChild.name <> "AG" then
		    MsgBox Dico.Value("Nofagfile")
		    return
		  end if
		  
		  
		  version = FAG.GetAttribute("Version") 
		  
		  Config.setLangue (FAG.GetAttribute(Dico.Value("Langage")))
		  Cfg = FAG.GetAttribute(Dico.Value("Config"))
		  Config.setMenu(Cfg)
		  app.themacros.XMLLoadMacros(FAG)
		  currentcontent.ChargerPrefs(FAG, f)
		  currentcontent.ChargerObjets(FAG)
		  currentcontent.CurrentFile = f
		  currentcontent.CurrentFileUpToDate=true
		  
		  CurrentContent.AddOperation(self)
		  currentcontent.CurrentOperation=nil
		  can.mousecursor = System.Cursors.StandardPointer
		  Workwindow.refreshtitle
		  can.refreshbackground
		  finished = true
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  Return dico.value("Ouvrir")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedoOperation(EL as XMLElement)
		  dim Temp, Obj as XMLElement
		  dim List as XmlNodeList
		  
		  
		  Temp = XMLElement(EL.Child(0))
		  Objects.XMLLoadObjects(Temp)
		  Objects.updateids
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToXml(Doc as XMLDocument) As XMLElement
		  dim EL, Obj, Temp as XMLElement
		  dim EN as XMLNode
		  dim i, j as integer
		  dim List as XMLNodeList
		  
		  CurrentContent.CreateFigs
		  
		  for i = 0 to CurrentContent.TheFigs.count-1
		    CurrentContent.TheFigs.item(i).XMLPutIncontainer(1,CurrentContent.OpList)
		  next
		  
		  EL = Doc.CreateElement(Dico.value("ObjectsLus"))
		  EL.SetAttribute("Fichier", FagTitle)
		  Temp = Doc.CreateElement(Dico.value("Forms"))
		  
		  List = FAG.XQL(Dico.Value("Forms"))
		  If List.length = 0 Then
		    List = FAG.XQL(Dico.Value("Objects"))
		  end if
		  If list.Length > 0 then
		    Obj= XMLElement(List.Item(0))
		    for i = 0 to Obj.ChildCount-1
		      EN = Doc.ImportNode(Obj.Child(i), true)
		      Temp.Appendchild EN
		    next
		  end if
		  EL.AppendChild Temp
		  return EL
		  
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
		FAG As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		FagTitle As string
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
			Name="FagTitle"
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
