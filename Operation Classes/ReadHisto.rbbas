#tag Class
Protected Class ReadHisto
Inherits Operation
	#tag Method, Flags = &h0
		Sub ReadHisto(f as folderitem)
		  dim mitem as MenuItem
		  dim i as integer
		  
		  Histfile = f
		  
		  try
		    Currentcontent.OpList =new XMLDocument(Histfile)
		    CurrentContent.Histo = CurrentContent.OpList.DocumentElement
		    Histo = CurrentContent.Histo
		  catch err as XmlException
		    MsgBox Dico.Value("MsgUnfoundable")+ ou + Dico.Value("MsgNovalidFile")
		    return
		  end try
		  
		  if Currentcontent.OpList = nil or Histo.name <> "AG" then
		    MsgBox  Dico.Value("MsgNovalidFile")
		    return
		  end if
		  
		  Operation()
		  OpId = 34
		  
		  wnd.Title = Histfile.Name
		  wnd.DisableToolBar
		  HistMenu.Child("FileMenu").Text = Dico.Value("FileMenu")
		  HistMenu.Child("FileMenu").Child("HistClose").Text = Dico.Value("FileClose")
		  HistMenu.Child("FileMenu").Child("FileSaveEps").Text = Dico.Value("FileSaveEps")
		  HistMenu.Child("FileMenu").Child("FileSaveBitmap").Text = Dico.Value("FileSaveBitmap")
		  HistMenu.Child("FileMenu").Child("PrintSetUp").Text = Dico.Value("PrintSetUp")
		  HistMenu.Child("FileMenu").Child("FilePrint").Text = Dico.Value("FilePrint")
		  HistMenu.Child("FileMenu").Child("FileAfficher").Text = Dico.Value("Afficher Opérations")
		  for i= 0 to HistMenu.Child("Fenetres").Count-1
		    HistMenu.Child("Fenetres").remove(i)
		  next
		  wnd.MenuBar.Child("Fenetres").item(wnd.GetNumWindow).Checked = false
		  for i = 0 to wnd.MenuBar.Child("Fenetres").Count-1
		    mitem = new MenuItem
		    mitem.Name = "winitem"
		    mitem.Text = wnd. MenuBar.Child("Fenetres").item(i).text
		    mitem.index =wnd. MenuBar.Child("Fenetres").item(i).index
		    if mitem.index = wnd.GetNumWindow then
		      mitem.Checked = true
		    end if
		    HistMenu.Child("Fenetres").append mitem
		  next
		  
		  wnd.MenuBar = HistMenu
		  wnd.draphisto = true
		  wnd.rh = self
		  
		  
		  'objects = CurrentContent.TheObjects
		  Hcmd = New HistCmd
		  Hcmd.ShowWithin(wnd)
		  Hcmd.HistCtrl.rh = self
		  XMLLoadOperations(CurrentContent.OpList)
		  wnd.mycanvas1.mousecursor = arrowcursor
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XMLLoadOperations(Doc as XmlDocument)
		  dim NewLang As string
		  dim Cfg as string
		  dim n as integer
		  
		  OldTrace  = Config.Trace
		  
		  wnd.mycanvas1.mousecursor = system.cursors.wait
		  NOper = Histo.Childcount
		  
		  NewLang = Histo.GetAttribute(Dico.Value("Langage"))
		  Config.SetLangue(NewLang)
		  
		  Config.Menu = Histo.GetAttribute(Dico.Value("Config"))
		  Config.ChargerConfig
		  
		  
		  n =val(Histo.GetAttribute(Dico.value("PrefsTrace")))
		  Config.Trace = (n=1)
		  wnd.refresh
		  
		  currentop = -1
		  NextOper  //Chargement du repère ou d'un fichier de formes
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NextOper()
		  dim EL as XMLElement
		  
		  if currentop = Noper-1 then
		    MsgBox Dico.Value("End_of_file")
		    return
		  end if
		  
		  
		  currentop = currentop+1
		  EL = XMLElement(Histo.Child(currentop))
		  while EL <> nil and  val(EL.Getattribute("Undone") ) = 1
		    currentop = currentop +1
		    EL = XMLElement(Histo.Child(currentop))
		  wend
		  if EL <> nil then
		    curoper = CurrentContent.CreerOperation(EL)
		    CurOper.RedoOperation(EL)
		  end if
		  
		  wnd.mycanvas1.refreshbackground
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FirstOper()
		  dim i as integer
		  
		  dim EL as XMLElement
		  
		  if noper = 1 then
		    MsgBox Dico.value("Empty_file")
		    return
		  end if
		  
		  if currentop = 0 then
		    nextoper
		  elseif currentop > 1 then
		    for i = currentop downto 2
		      precoper
		    next
		    currentop = 1
		  end if
		  curop1 = currentop
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrecOper()
		  dim EL as XMLElement
		  
		  if currentop = 0 then
		    MsgBox Dico.value("Start_of_file")
		    return
		  end if
		  if noper = 1 then
		    return
		  end if
		  
		  EL = XMLElement(Histo.Child(currentop))
		  curoper= CurrentContent.CreerOperation(EL)
		  CurOper.UndoOperation(EL)
		  currentop = currentop-1
		  wnd.mycanvas1.refreshbackground
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LastOper()
		  dim i as integer
		  
		  Config.Trace = false
		  for i = currentop to Noper-2
		    NextOper
		  next
		  MsgBox Dico.value("End_of_file")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Endoperation()
		  dim i As integer
		  dim El as XmlNode
		  dim fid As integer
		  
		  for i = 0 to CurrentContent.TheFigs.count-1
		    fid = max (fid, CurrentContent.TheFigs.element(i).idfig)
		  next
		  CurrentContent.TheFigs.previdfig = fid
		  
		  wnd.Mycanvas1.Mousecursor = system.Cursors.wait
		  CurrentContent.CurrentOperation=nil
		  wnd.menubar = menu
		  wnd.MenuBar.Child("Fenetres").Item(wnd.GetNumWindow).Checked = true
		  wnd.draphisto = false
		  wnd.refreshtitle
		  wnd.EnableToolbar
		  
		  CurrentContent.SaveHisto
		  CurrentContent.currentop = currentop
		  CurrentContent.totaloperation = currentop+1
		  Config.Trace = OldTrace
		  super.endoperation
		  wnd.Mycanvas1.Mousecursor = arrowcursor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.Value("ReadHisto")
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
		Histfile As folderitem
	#tag EndProperty

	#tag Property, Flags = &h0
		NOper As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		n As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		nop As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		curoper As Operation
	#tag EndProperty

	#tag Property, Flags = &h0
		Hcmd As HistCmd
	#tag EndProperty

	#tag Property, Flags = &h0
		OldTrace As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		currentop As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		curop1 As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		drann As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		drref As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Histo As XMLElement
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
			EditorType="MultiLineEditor"
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NOper"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="n"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nop"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OldTrace"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="currentop"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="curop1"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drann"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drref"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
