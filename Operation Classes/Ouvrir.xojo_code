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
		  dim Doc as XmlDocument
		  dim Cfg as string
		  dim v1, v2, v3, n as integer
		  dim version as string
		  dim msg as MessageDialog
		  dim but as MessageDialogButton
		  dim BkCol as string
		  
		  constructor()
		  
		  try
		    Doc=new XMLDocument(f)
		  catch err as XmlException
		    MsgBox Dico.Value("MsgUnfoundable")+ ou + Dico.Value("MsgNovalidFile")
		    return
		  end try
		  
		  FagTitle = f.name
		  FAG = Doc.DocumentElement
		  if Doc.FirstChild.name <> "AG" then
		    MsgBox Dico.Value("Nofagfile")
		    return
		  end if
		  
		  version = FAG.GetAttribute("Version")
		  v1 = val(NthField(version,".", 1))
		  v2 = val(NthField(version,".",2))
		  v3 = val(NthField(version,".",3))
		  wnd.version = 100*v1+ 10*v2 + v3  'les trois numéros de version ne peuvent avoir qu'un chiffre
		  if wnd.version <  222 and not app.quiet then '100*App.MajorVersion + 10* App.MinorVersion + App.BugVersion then
		    msg = new MessageDialog
		    msg.Message = "Ce fichier a été enregistré avec une  version d'Apprenti Géomètre antérieure à la version 2.2.2." + EndOfLine + "S'il comporte des découpages, il est possible qu'il ne fonctionne pas correctement."
		    msg.AlternateActionButton.visible = true
		    msg.AlternateActionButton.Caption = "Ne plus afficher ce message"
		    but = msg.ShowModal
		    if but <> msg.ActionButton then
		      app.quiet = true
		    end if
		  end if
		  
		  Config.setLangue (FAG.GetAttribute(Dico.Value("Langage")))
		  
		  
		  Cfg = FAG.GetAttribute(Dico.Value("Config"))
		  if Cfg <> Config.Menu then
		    if left(cfg,6) = "Niveau" or left(cfg,5) = "Level" then
		      n = len(cfg)
		      cfg = "Menu"+right(cfg,n-6)
		    end if
		    Config.Menu = Cfg
		    Config.ChargerConfig
		  end if
		  
		  app.themacros.XMLLoadMacros(FAG)
		  
		  currentcontent.removeall
		  currentcontent.ndec = val(FAG.GetAttribute("NbrDec"))
		  if currentcontent.ndec =0 then
		    currentcontent.ndec = 2
		  end if
		  can.Mousecursor = system.cursors.wait
		  BkCol = FAG.GetAttribute("BkCol")
		  if BkCol = "noir" and wnd.BackColor = &cFFFFFF then
		    wnd.switchcolors
		  end if
		  Objects.drapplan = (val(FAG.GetAttribute("Plans")) = 1)
		  Objects.SetId(-1)
		  Objects.XMLLoadObjects(FAG)
		  Objects.updateids
		  currentcontent.FinInitialisation(FAG, f)
		  finished = true
		  CurrentContent.AddOperation(self)
		  can.mousecursor = System.Cursors.StandardPointer
		  can.refreshbackground
		  
		  
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
		  Temp = Doc.CreateElement(Dico.value("Objects"))
		  
		  List = FAG.XQL(Dico.Value("Objects"))
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
