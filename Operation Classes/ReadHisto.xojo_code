#tag Class
Protected Class ReadHisto
Inherits Operation
	#tag Method, Flags = &h0
		Sub Constructor(f as folderitem)
		  Dim mitem As MenuItem
		  dim i as integer
		  
		  Histfile = f
		  
		  try
		    Currentcontent.OpList =new XMLDocument(Histfile)
		    CurrentContent.Histo = CurrentContent.OpList.DocumentElement
		    Histo = CurrentContent.Histo
		  catch err as XmlException
		    MsgBox Dico.Value("MsgNovalidFile")
		    return
		  end try
		  
		  if Currentcontent.OpList = nil or Histo.name <> "AG" then
		    MsgBox  Dico.Value("MsgNovalidFile")
		    return
		  end if
		  
		  super.constructor
		  OpId = 34
		  
		  Workwindow.Title = Histfile.Name
		  
		  HistMenu.Child("FileMenu").Text = Dico.Value("FileMenu")
		  HistMenu.Child("FileMenu").Child("HistClose").Text = Dico.Value("FileClose")
		  HistMenu.Child("FileMenu").Child("FileSaveEps").Text = Dico.Value("FileSaveEps")
		  HistMenu.Child("FileMenu").Child("FileSaveBitmap").Text = Dico.Value("FileSaveBitmap")
		  HistMenu.Child("FileMenu").Child("PrintSetUp").Text = Dico.Value("PrintSetUp")
		  HistMenu.Child("FileMenu").Child("FilePrint").Text = Dico.Value("FilePrint")
		  HistMenu.Child("FileMenu").Child("FileAfficher").Text = Dico.Value("Afficher Opérations")
		  
		  
		  While (HistMenu.Child("Fenetres").Count > 0)
		    HistMenu.Child("Fenetres").remove(HistMenu.Child("Fenetres").Count-1)
		  Wend
		  
		  for i = 0 to Workwindow.MenuBar.Child("Fenetres").Count-1
		    mitem = new MenuItem
		    mitem.Name = "winitem"
		    mitem.Text = Workwindow. MenuBar.Child("Fenetres").item(i).text
		    mitem.index =Workwindow. MenuBar.Child("Fenetres").item(i).index
		    HistMenu.Child("Fenetres").append mitem
		  next
		  
		  
		  Workwindow.MenuBar = HistMenu
		  Workwindow.draphisto = true
		  Workwindow.rh = self
		  
		  XMLLoadOperations(CurrentContent.OpList)
		  can.mousecursor = System.Cursors.StandardPointer
		  HistCmd.ShowWithin(Workwindow)
		  HistCmd.HistCtrl.rh = self
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Endoperation()
		  dim i As integer
		  dim El as XmlNode
		  dim fid As integer
		  
		  for i = 0 to CurrentContent.TheFigs.count-1
		    fid = max (fid, CurrentContent.TheFigs.item(i).idfig)
		  next
		  CurrentContent.TheFigs.previdfig = fid
		  
		  can.Mousecursor = system.Cursors.wait
		  CurrentContent.CurrentOperation=nil
		  CurrentContent.SaveHisto
		  CurrentContent.currentop = currentop
		  CurrentContent.totaloperation = currentop+1
		  Config.Trace = OldTrace
		  Workwindow.closeHisto
		  super.endoperation
		  can.Mousecursor = System.Cursors.StandardPointer
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FirstOper()
		  Dim i As Integer
		  
		  if noper = 1 then
		    MsgBox Dico.value("Empty_file")
		    return
		  end if
		  
		  
		  while currentop > 1
		    PrecOper
		  wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("ReadHisto")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LastOper()
		  dim i as integer
		  
		  Config.Trace = false
		  
		  while currentop < Noper-1
		    NextOper
		  wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NextOper()
		  Dim EL As XMLElement
		  
		  if currentop = Noper-1 then
		    return
		  end if
		  
		  currentop = currentop+1
		  
		  EL = XMLElement(Histo.Child(currentop))
		  
		  if EL <> nil then
		    if val(EL.Getattribute("Undone")) = 1 then
		      NextOper
		    else
		      curoper = CurrentContent.CreerOperation(EL)
		      if curoper <> nil then
		        CurOper.RedoOperation(EL)
		      end if
		    end if
		  end if
		  updateHistoControl
		  can.refreshbackground
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  if curoper isa lier or curoper isa delier then
		    curoper.paint(g)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrecOper()
		  dim EL as XMLElement
		  
		  if currentop = 0 then
		    return
		  end if
		  
		  EL = XMLElement(Histo.Child(currentop))
		  currentop = currentop-1
		  
		  if val(EL.Getattribute("Undone")) = 1 then
		    PrecOper
		  else
		    curoper= CurrentContent.CreerOperation(EL)
		    CurOper.UndoOperation(EL)
		    updateHistoControl
		    can.refreshbackground
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub updateHistoControl()
		  HistCmd.HistCtrl.First.Enabled = currentop > 1
		  HistCmd.HistCtrl.Prec.Enabled = currentop > 0
		  HistCmd.HistCtrl.BNext.Enabled = currentop < Noper-1
		  HistCmd.HistCtrl.Last.Enabled = currentop < Noper-1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLLoadOperations(Doc as XmlDocument)
		  dim NewLang As string
		  dim Cfg as string
		  dim n as integer
		  
		  OldTrace  = Config.Trace
		  
		  can.mousecursor = system.cursors.wait
		  NOper = Histo.Childcount
		  
		  NewLang = Histo.GetAttribute(Dico.Value("Langage"))
		  Config.SetLangue(NewLang)
		  
		  Config.Menu = Histo.GetAttribute(Dico.Value("Config"))
		  Config.ChargerConfig
		  
		  
		  n =val(Histo.GetAttribute(Dico.value("PrefsTrace")))
		  Config.Trace = (n=1)
		  Workwindow.refresh
		  
		  currentop = -1
		  NextOper  //Chargement du repère ou d'un fichier de formes
		  
		  
		  
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
		curoper As Operation
	#tag EndProperty

	#tag Property, Flags = &h0
		currentop As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		drann As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drref As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Histfile As folderitem
	#tag EndProperty

	#tag Property, Flags = &h0
		Histo As XMLElement
	#tag EndProperty

	#tag Property, Flags = &h0
		n As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		nop As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		NOper As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		OldTrace As Boolean
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
			Name="currentop"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="drann"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="drref"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
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
			Name="n"
			Visible=false
			Group="Behavior"
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
			Name="nop"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NOper"
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
			Name="OldTrace"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
