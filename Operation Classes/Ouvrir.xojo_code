#tag Class
Protected Class Ouvrir
Inherits Operation
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit)) or  (TargetAndroid and (Target64Bit))
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  OpId = -1
		  currentcontent.currentoperation = self



		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
			Sub Constructor(f as folderitem)
				' Refactoring : gestion centralisée des erreurs, extraction de méthodes, vérification attributs, renommage
				Dim Doc As XmlDocument
				Dim Cfg As String

				constructor()

				Try
					Doc = New XMLDocument(f)
				Catch err As XmlException
					AfficherErreurEtReset(Dico.Value("MsgNovalidFile"))
					Return
				End Try

				FagTitle = f.name
				RootElement = Doc.DocumentElement
				' Vérification du type de fichier AG
				If Doc.FirstChild.name <> "AG" Then
					AfficherErreurEtReset(Dico.Value("Nofagfile"))
					Return
				End If

				' Vérification de la présence de l'attribut Version (non utilisé ici)
				' Dim version As String = ""
				' If RootElement.HasAttribute("Version") Then
				'   version = RootElement.GetAttribute("Version")
				' End If

					' Gestion de la langue
					Dim langAttr As String = RootElement.GetAttribute(Dico.Value("Langage"))
					If langAttr <> "" Then
						Config.setLangue(langAttr)
					End If

					' Gestion du menu
					Dim cfgAttr As String = RootElement.GetAttribute(Dico.Value("Config"))
					If cfgAttr <> "" Then
						Config.setMenu(cfgAttr)
					End If

				' Chargement des macros, préférences et objets
				ChargerMacros(RootElement)
				ChargerPreferencesEtObjets(RootElement, f)

				currentcontent.CurrentFile = f
				currentcontent.CurrentFileUpToDate = true

				CurrentContent.AddOperation(self)
				currentcontent.CurrentOperation = nil
				can.mousecursor = System.Cursors.StandardPointer
				Workwindow.refreshtitle
				can.refreshbackground
				finished = true
			End Sub
	' Méthode privée : gestion centralisée des erreurs et reset d'état
	Private Sub AfficherErreurEtReset(msg As String)
		MsgBox msg
		currentcontent.currentoperation = nil
	End Sub

	' Méthode privée : chargement des macros
	Private Sub ChargerMacros(RootElement As XMLElement)
		If app.themacros <> Nil Then
			app.themacros.XMLLoadMacros(RootElement)
		End If
	End Sub

	' Méthode privée : chargement des préférences et objets
	Private Sub ChargerPreferencesEtObjets(RootElement As XMLElement, f As FolderItem)
		If currentcontent <> Nil Then
			currentcontent.ChargerPrefs(RootElement, f)
			currentcontent.ChargerObjets(RootElement)
		End If
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

				List = RootElement.XQL(Dico.Value("Forms"))
				If List.length = 0 Then
					List = RootElement.XQL(Dico.Value("Objects"))
				End If
				If List.Length > 0 Then
					Obj = XMLElement(List.Item(0))
					For i = 0 To Obj.ChildCount - 1
						EN = Doc.ImportNode(Obj.Child(i), True)
						Temp.AppendChild EN
					Next
				End If
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
			' Renommage pour plus de clarté
			RootElement As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
			FagTitle As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="canceling"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="colsep"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="display"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FagTitle"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finished"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HistId"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="info"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iobj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="itsf"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
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
			Name="nobj"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ntsf"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpId"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="side"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
