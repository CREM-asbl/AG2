#tag Class
Protected Class App
Inherits Application
	#tag Event
		Function CancelClose() As Boolean
		  if ipctransfert then
		    ipc.send(FileName)
		    ipctransfert = false
		  end if
		  Config.Save
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Close()
		  try
		    mut.Leave
		  Catch
		    
		  end try
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  CheckProcess
		  #if TargetWin32 then
		    UseGDIPlus=true
		  #endif
		  if not ipctransfert then
		    CheckSystem
		    InitFolders
		    Dico = new Dictionnaire
		    Config = new Configuration
		    autoquit = true
		    CheckUpdate
		    dim iw As InitWindow
		    iw=new initWindow
		    iw.Show
		  end if
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub OpenDocument(item As FolderItem)
		  'reste un problème avec accent
		  dim s As string
		  s = item.NativePath
		  
		  if Right(s,1) = "\" then
		    s = s.mid(1,Len(s)-1)
		  end if
		  if FileName <> "" then
		    s = " "+s
		  end if
		  
		  FileName = FileName+s
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function UnhandledException(error As RuntimeException) As Boolean
		  dim st(-1), cre, Op as String
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
		    NWI = System.GetNetworkInterface(0)
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
		          tos.WriteLine "appliquée à  " + Curoper.CurrentShape.GetType +" n° " +str(curoper.CurrentShape.id)
		        else
		          tos.WriteLine "Curoper.CurrentShape = nil"
		        end if
		      end if
		    else
		      tos.WriteLine "Ouverture de Fichier ou Operation Nil"
		    end if
		    
		    tos.WriteLine ""
		    tos.WriteLine "**** Debug message ****"
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
		    
		    Log = SpecialFolder.Documents.Parent
		    if Log <> nil then
		      cre = Log.Name
		    end if
		    tos.writeline "Createur :" + cre
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
		    'wnd.deleteContent
		    'if UBound (wnd.wcontent) = -1 then
		    'wnd.NewContent(false)
		    'end if
		    currentcontent.bugfound = false   'GN 17-08-2014
		  end if
		  return true
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub abortread()
		  MsgBox Dico.Value("MsgNovalidFile") + Dico.Value("Noread")
		  CurrentContent.currentoperation = nil
		  quit      'trouver un moyen de mettre un terme à la lecture sans sortir du programme en rétablissant la situation telle qu'avant le début de la lecture"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CheckProcess()
		  ipc = new IPC
		  mut = new Mutex("AG2")
		  
		  if not mut.TryEnter then
		    ipctransfert = true
		  else
		    ipc.listen
		  end if
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
		Sub Continuer()
		  dim ww as WorkWindow
		  
		  Config.ChargerConfig
		  themacros = new macroslist
		  Tampon = new ObjectsList
		  ww = new WorkWindow
		  ww.Show
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DicoDispo() As string()
		  dim dicos(-1), nom as String
		  dim i as integer
		  
		  dicos.append "Francais"
		  dicos.append "English"
		  dicos.append "PortuguesBr"
		  
		  for i=1 to DctFolder.count
		    nom = app.DctFolder.trueItem(i).Name
		    if right(nom,4)=".dct" then
		      dicos.append(Left(nom,len(nom)-4))
		    end if
		  next
		  
		  return dicos
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitFolders()
		  AppFolder=GetFolderItem("")
		  #if DebugBuild then
		    AppFolder = AppFolder.Parent
		  #endif
		  DocFolder = SpecialFolder.Documents.Child("Apprenti geometre")
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
		  StdFolder = DocFolder.Child("StdFiles")
		  if not StdFolder.Exists then
		    StdFolder.CreateAsFolder
		  end if
		  DctFolder = DocFolder.Child("Dictionaries")
		  if not DctFolder.Exists then
		    DctFolder.CreateAsFolder
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MenusDispo() As String()
		  dim menus(-1),nom as String
		  dim i as integer
		  
		  'for i=1 to AppFolder.count
		  'nom = app.AppFolder.trueItem(i).Name
		  'if right(nom,4)=".men" then
		  'menus.append(Left(nom,len(nom)-4))
		  'end if
		  'next
		  
		  menus.append "Menu_A"
		  menus.append "Menu_B"
		  menus.append "Menu_C"
		  menus.append "Menu_AB"
		  menus.append "Menu_AC"
		  
		  for i=1 to MenusFolder.count-1
		    nom = app.MenusFolder.trueItem(i).Name
		    if right(nom,4)=".men" then
		      menus.append(Left(nom,len(nom)-4))
		    end if
		  next
		  
		  return menus
		End Function
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
		Function StdFilesDispo() As string()
		  dim stdfiles(-1),nom as String
		  dim i as integer
		  
		  'for i=1 to AppFolder.count
		  'nom = app.AppFolder.trueItem(i).Name
		  'if right(nom,4)=".std" then
		  'stdfiles.append(Left(nom,len(nom)-4))
		  'end if
		  'next
		  
		  stdfiles.append "jeu_de_base"
		  stdfiles.append "cubes"
		  stdfiles.append "pentaminos"
		  stdfiles.append "tangram"
		  stdfiles.append "reglettes"
		  
		  for i=1 to StdFolder.count
		    nom = app.StdFolder.trueItem(i).Name
		    if right(nom,4)=".std" then
		      stdfiles.append(Left(nom,len(nom)-4))
		    end if
		  next
		  
		  return stdfiles
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
		currentfile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		DctFolder As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		DocFolder As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		ErrorType As String
	#tag EndProperty

	#tag Property, Flags = &h0
		FileName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ipc As IPC
	#tag EndProperty

	#tag Property, Flags = &h0
		ipctransfert As boolean = false
	#tag EndProperty

	#tag Property, Flags = &h0
		MacFolder As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		majok As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		MenusFolder As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mut As Mutex
	#tag EndProperty

	#tag Property, Flags = &h0
		prtsetup As printerSetup
	#tag EndProperty

	#tag Property, Flags = &h0
		quiet As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		quitting As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		stdfolder As folderitem
	#tag EndProperty

	#tag Property, Flags = &h0
		sys As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Tampon As Objectslist
	#tag EndProperty

	#tag Property, Flags = &h0
		TheMacros As MacrosList
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ErrorType"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FileName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ipctransfert"
			Group="Behavior"
			InitialValue="false"
			Type="boolean"
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
			Name="quitting"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="sys"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
