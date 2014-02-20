#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Close()
		  try
		    mut.Leave
		  Catch
		    
		  end try
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function UnhandledException(error As RuntimeException) As Boolean
		  dim st(-1),Op as String
		  dim bugw as BugFindW
		  dim i as integer
		  dim curoper as Operation
		  dim tos as TextOutputStream
		  dim NWI As  NetworkInterface
		  dim Log as FolderItem
		  
		  
		  if CurrentContent = nil or CurrentContent.bugfound then
		    return true
		  end if
		  
		  
		  Log = DocFolder.Child("AG2.log")
		  tos = Log.CreateTextFile
		  curoper = CurrentContent.CurrentOperation
		  
		  if (System.Network.IsConnected or TargetLinux) and tos <> nil then
		    NWI = System.GetNetworkInterface
		    st = error.Stack
		    tos.WriteLine "BuildDate : "+str(self.BuildDate)
		    tos.WriteLine ""
		    tos.WriteLine "**** Runtime - Error Type****"
		    tos.WriteLine ""
		    tos.WriteLine str(Runtime.ObjectCount)+" éléments actifs"
		    tos.WriteLine str(Runtime.MemoryUsed/1000000)+" Mo en mémoire"
		    if Config<>nil then
		      tos.WriteLine ""
		      tos.WriteLine "**** Configuration ****"
		      tos.WriteLine ""
		      tos.WriteLine "Formes standards : "+Config.stdfile
		      tos.WriteLine ""
		      tos.WriteLine "**** Operation ****"
		      tos.WriteLine ""
		    end if
		    
		    if curoper <>nil then
		      tos.WriteLine "Opération active : "+curoper.GetName
		      if not curoper isa ReadHisto then
		        if curoper.CurrentShape <> nil then
		          tos.WriteLine "appliquée à  la forme : "+ str(CurrentContent.CurrentOperation.CurrentShape.id)
		        else
		          tos.WriteLine "appliquée à la forme : nil "
		        end if
		      end if
		    else
		      tos.WriteLine "Ouverture de Fichier ou Operation Nil"
		    end if
		    
		    tos.WriteLine ""
		    tos.WriteLine "**** Debug message ****"
		    tos.WriteLine""
		    
		    if error isa OutOfMemoryException then
		      tos.WriteLine "OutOfMemoryException"
		    elseif error isa FunctionNotFoundException then
		      tos.WriteLine "FunctionNotFoundException"
		    elseif error isa IllegalCastException then
		      tos.WriteLine "IllegalCastException"
		    elseif error isa NilObjectException then
		      tos.WriteLine "NilObjectException"
		    elseif error isa OutOfBoundsException then
		      tos.WriteLine "OutOfBoundsException"
		    elseif error isa StackOverflowException then
		      tos.WriteLine "StackOverflowException"
		    elseif error isa XmlException then
		      tos.WriteLine "XmlException "+XmlException(error).Line+" - "+XmlException(error).Node
		    else
		      tos.WriteLine "Autre erreur"
		    end if
		    
		    tos.WriteLine ""
		    tos.Write error.message
		    tos.WriteLine ""
		    tos.WriteLine "**** fin Debug message ****"
		    tos.WriteLine ""
		    tos.WriteLine "**** Error Stack ****"
		    tos.WriteLine ""
		    tos.WriteLine str(error.ErrorNumber)
		    for i = 0 to UBound(St)
		      tos.WriteLine st(i)
		    next
		    
		    tos.WriteLine NWI.IPAddress + " " +  "Mac: "+ NWI.MACAddress
		    tos.Close
		  end if
		  
		  if not curoper isa ReadHisto then
		    CurrentContent.currentfile = App.DocFolder.Child("Bug.fag")
		    if CurrentContent.currentfile.Exists then
		      CurrentContent.currentfile.Delete
		    end if
		    CurrentContent.Save
		    currentfile = CurrentContent.Currentfile
		  else
		    currentfile = ReadHisto(curoper).Histfile
		  end if
		  CurrentContent.bugfound = true
		  
		  ErrorType = NthField(st(0),"%",1)
		  
		  
		  bugw = new BugFindW
		  bugw.showModal
		  if not quitting then
		    if wnd.draphisto then
		      if curoper <> nil then
		        ReadHisto(curoper).Hcmd.close
		      end if
		      wnd.menubar = menu
		      wnd.draphisto = false
		      wnd.Refresh
		    end if
		    wnd.deleteContent
		    if UBound (wnd.wcontent) = -1 then
		      wnd.NewContent
		    end if
		  end if
		  return true
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  CheckProcess
		  CheckSystem
		  InitFolders
		  Dico = new Dictionnaire
		  Config = new Configuration
		  autoquit = true
		  init
		  themacros = new macroslist
		  CheckUpdate
		  
		  
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub OpenDocument(item As FolderItem)
		  if FileName ="" then
		    FileName = item.AbsolutePath
		  else
		    FileName = FileName+" "+item.AbsolutePath
		  end if
		  Currentfile = GetFolderItem(FileName)
		  if currentfile.Exists then
		    if ipctransfert then
		      ipc.send(currentfile)
		      ipctransfert = false
		    end if
		    FileName = ""
		  end if
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function CancelClose() As Boolean
		  if ipctransfert then
		    ipc.Send(nil)
		  else
		    Config.Save
		  end if
		End Function
	#tag EndEvent

	#tag Event
		Sub EnableMenuItems()
		  dim B, B1, B2 as boolean
		  dim item as MenuItem
		  dim i as integer
		  
		  
		  if currentcontent <> nil  then
		    MenuBar.Child("FileMenu").Child("FileNew").enabled = not currentcontent.macrocreation
		    MenuBar.Child("FileMenu").Child("FileOpen").enabled =  not currentcontent.macrocreation
		  end if
		  
		  if wnd<>nil and wnd.MyCanvas1.rep <> nil and currentcontent <> nil then
		    B =  CurrentContent.TheObjects.count > 1
		    B1 = CurrentContent.TheGrid <> nil
		    B2 = wnd.MyCanvas1.rep.labs.count > 0
		    B = (B or B1 or B2) and not currentcontent.macrocreation
		    MenuBar.Child("FileMenu").Child("FileSave").Enabled= B  and not CurrentContent.CurrentFileUptoDate
		    MenuBar.Child("FileMenu").Child("FileClose").enabled =   not currentcontent.macrocreation
		    if MenuMenus.Child("EditMenu").Child("EditUndo").Checked then
		      MenuBar.Child("EditMenu").Child("EditUndo").Enabled = (CurrentContent.Currentop > 0)
		      wnd.pushbutton1.enabled = (CurrentContent.Currentop > 0)
		    end if
		    if MenuMenus.Child("EditMenu").Child("EditRedo").Checked then
		      MenuBar.Child("EditMenu").Child("EditRedo").Enabled = (CurrentContent.currentop < CurrentContent.totaloperation -1)
		    end if
		  else
		    B = false
		    MenuBar.Child("FileMenu").Child("FileSave").Enabled= false
		    MenuBar.Child("FileMenu").Child("FileClose").enabled = false
		  end if
		  
		  MenuBar.Child("FileMenu").Child("PrintSetUp").Enabled = true
		  MenuBar.Child("FileMenu").Child("FilePrint").Enabled = B
		  MenuBar.Child("FileMenu").Child("FileSaveAs").Enabled = B
		  MenuBar.Child("FileMenu").Child("FileSaveEps").Enabled= B and (Config.username = Dico.Value("Enseignant"))
		  MenuBar.Child("FileMenu").Child("FileSaveBitmap").Enabled = B
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub init()
		  iw=new initWindow
		  iw.ShowModal
		  Tampon = new ObjectsList
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub abortread()
		  MsgBox Dico.Value("MsgNovalidFile") + Dico.Value("Noread")
		  CurrentContent.currentoperation = nil
		  quit      'trouver un moyen de mettre un terme à la lecture sans sortir du programme en rétablissant la situation telle qu'avant le début de la lecture"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CheckSystem()
		  #if TargetWin32 then
		    sys = "win32"
		  #elseif TargetLinux then
		    sys="Linux"
		  #elseif TargetMacOSClassic then
		    sys = "Mac"
		  #else
		    sys = "MacOsX"
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CheckUpdate()
		  'si on est en mode debug, la recherche de mise à jour n'est pas utile
		  #if DebugBuild then
		    return
		  #endif
		  
		  api.init
		  api.Connect
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CheckProcess()
		  ipc = new IPC
		  mut = new Mutex("AG2")
		  
		  if not mut.TryEnter then
		    ipctransfert = true
		    Quit
		  else
		    ipc.listen
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitFolders()
		  AppFolder=GetFolderItem("")
		  DocFolder = DocumentsFolder.Child("Apprenti geometre")
		  if not DocFolder.Exists then
		    DocFolder.CreateAsFolder
		  end if
		  MacFolder = DocFolder.Child("Macros")
		  if not MacFolder.Exists then
		    MacFolder.CreateAsFolder
		  end if
		  MenusFolder = DocFolder.Child("Menus")
		  if not MenusFolder.Exists then
		    MenusFolder.CreateAsFolder
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StageCodeToString() As String
		  select case app.StageCode
		  case 0
		    return "Dev"
		  case 1
		    return "Alpha"
		  case 2
		    return "Beta"
		  else
		    return ""
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MenusDispo() As String()
		  dim menus(-1),nom as String
		  dim i as integer
		  
		  for i=1 to AppFolder.count
		    nom = app.AppFolder.trueItem(i).Name
		    if right(nom,4)=".men" then
		      menus.append(Left(nom,len(nom)-4))
		    end if
		  next
		  
		  for i=1 to MenusFolder.count
		    nom = app.MenusFolder.trueItem(i).Name
		    if right(nom,4)=".men" then
		      menus.append(Left(nom,len(nom)-4))
		    end if
		  next
		  
		  return menus
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
		appfolder As folderitem
	#tag EndProperty

	#tag Property, Flags = &h0
		Tampon As Objectslist
	#tag EndProperty

	#tag Property, Flags = &h0
		prtsetup As printerSetup
	#tag EndProperty

	#tag Property, Flags = &h0
		currentfile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		ErrorType As String
	#tag EndProperty

	#tag Property, Flags = &h0
		iw As InitWindow
	#tag EndProperty

	#tag Property, Flags = &h0
		majok As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		quiet As boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mut As Mutex
	#tag EndProperty

	#tag Property, Flags = &h0
		ipc As IPC
	#tag EndProperty

	#tag Property, Flags = &h0
		ipctransfert As boolean = false
	#tag EndProperty

	#tag Property, Flags = &h0
		sys As String
	#tag EndProperty

	#tag Property, Flags = &h0
		FileName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		quitting As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		TheMacros As MacrosList
	#tag EndProperty

	#tag Property, Flags = &h0
		MacFolder As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		DocFolder As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		MenusFolder As FolderItem
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ErrorType"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="sys"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="majok"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="quiet"
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ipctransfert"
			Group="Behavior"
			InitialValue="false"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FileName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="quitting"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
