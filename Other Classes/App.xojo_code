#tag Class
Protected Class App
Inherits Application
	#tag Event
		Function CancelClose() As Boolean
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Close()
		  'try
		  'mut.Leave
		  'Catch
		  '
		  'end try
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  CheckSystem
		  InitFolders
		  Dico = new Dictionnaire
		  Config = new Configuration
		  autoquit = true
		  api.checkUpdate 
		  themacros = new macroslist
		  initWindow.show
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub OpenDocument(item As FolderItem)
		  dim s As string
		  
		  #if TargetWindows then
		    s = item.ShellPath
		    if Right(s,1) = "\" then
		      s = s.mid(1,Len(s)-1)
		    end if
		    if FileName <> "" then
		      s = " "+s
		    end if
		    FileName = FileName+s
		    item = GetFolderItem(Filename)
		  #Endif
		  
		  if item.Exists then
		    WorkWindow.OpenFile(item)
		    initWindow.close
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Function UnhandledException(error As RuntimeException) As Boolean
		  dim st(-1), cre, Op,log as String
		  dim i as integer
		  dim curoper as Operation
		  dim NWI As  NetworkInterface
		  dim f as FolderItem
		  
		  
		  if CurrentContent = nil or CurrentContent.bugfound then
		    return true
		  end if
		  
		  app.bugtime = new date()
		  
		  curoper = CurrentContent.CurrentOperation
		  
		  
		  log = "BuildDate : " + str(self.BuildDate) + EndOfLine +EndOfLine
		  
		  log = log + "**** Runtime - Error Type****" + EndOfLine + EndOfLine
		  log = log + str(Runtime.ObjectCount) + " éléments actifs" + EndOfLine
		  log = log + str(Runtime.MemoryUsed/1000000) + " Mo en mémoire" + EndOfLine + EndOfLine
		  
		  if Config<>nil then
		    log = log + "**** Configuration ****" + EndOfLine + EndOfLine
		    log = log + "Formes standards : "+Config.stdfile + EndOfLine +EndOfLine
		    log = log + "**** Operation ****" + EndOfLine + EndOfLine
		    
		  end if
		  
		  if curoper <>nil then
		    CurrentContent.InsertInHisto(curoper)
		    log = log+ "Opération active : "+curoper.GetName + EndOfLine
		    if not curoper isa ReadHisto then
		      if curoper.CurrentShape <> nil then
		        log = log + "appliquée à  " + Curoper.CurrentShape.GetType +" n° " +str(curoper.CurrentShape.id) + EndOfLine
		      else
		        log = log + "Curoper.CurrentShape = nil"+ EndOfLine
		      end if
		    end if
		  else
		    log = log + "Ouverture de Fichier ou Operation Nil" + EndOfLine
		  end if
		  
		  log = log + EndOfLine
		  
		  log = log + "**** Debug message ****" + EndOfLine + EndOfLine
		  if error isa OutOfMemoryException then
		    log = log + "OutOfMemoryException" + EndOfLine
		  elseif error isa FunctionNotFoundException then
		    log = log + "FunctionNotFoundException" + EndOfLine
		  elseif error isa IllegalCastException then
		    log = log + "IllegalCastException" + EndOfLine
		  elseif error isa NilObjectException then
		    log = log + "NilObjectException" + EndOfLine
		  elseif error isa OutOfBoundsException then
		    log = log + "OutOfBoundsException" + EndOfLine
		  elseif error isa StackOverflowException then
		    log = log + "StackOverflowException" + EndOfLine
		  elseif error isa XmlException then
		    log = log + "XmlException "+XmlException(error).Line+" - "+XmlException(error).Node + EndOfLine
		  else
		    log = log + "Autre erreur" + EndOfLine
		  end if
		  log = log+ error.message + EndOfLine
		  log = log + "" + EndOfLine
		  log = log + "**** fin Debug message ****" + EndOfLine + EndOfLine
		  
		  log = log + "**** Error Stack ****" + EndOfLine + EndOfLine
		  st = error.Stack
		  
		  log = log + str(error.ErrorNumber) + EndOfLine
		  for i = 0 to UBound(St)
		    log = log + st(i) + EndOfLine
		  next
		  
		  f = SpecialFolder.Documents.Parent
		  if f <> nil then
		    cre = f.Name
		  end if
		  log = log + "Createur : " + cre + EndOfLine
		  NWI = System.GetNetworkInterface(0)
		  log = log + NWI.IPAddress + " " +  "Mac: "+ NWI.MACAddress + EndOfLine
		  
		  CurrentContent.bugfound = true
		  
		  app.ErrorType = NthField(st(1),"%",1)
		  app.log = log
		  api.SendBug
		  
		  BugFindW.showModal
		  
		  if not quitting then
		    if Workwindow.draphisto then
		      Workwindow.closeHisto
		    end if
		    
		    Workwindow.deleteContent
		    
		    if UBound (Workwindow.wcontent) = -1 then
		      Workwindow.NewContent(false)
		    end if
		    
		    currentcontent.bugfound = false 
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
		Sub CheckSystem()
		  #if TargetWin32 then
		    sys = "win32"
		  #elseif TargetLinux then
		    sys="Linux"
		  #elseif TargetMacOS then
		    sys = "Mac"
		  #else
		    sys = "MacOsX"
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Continuer()
		  Config.ChargerConfig
		  Tampon = new ObjectsList
		  WorkWindow.Show
		  
		  
		  
		  
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
		Function FullVersion() As String
		  if Target32Bit then
		    return app.LongVersion  + " " + app.StageCodeToString  + " (32 bits)"
		  else
		    return app.LongVersion + " " + app.StageCodeToString + " (64 bits)"
		  end if
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
		  
		  menus.append "Menu_A"
		  menus.append "Menu_B"
		  menus.append "Menu_C"
		  menus.append "Menu_AB"
		  menus.append "Menu_AC"
		  
		  for i=1 to MenusFolder.count
		    nom = MenusFolder.trueItem(i).Name
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
		  
		  stdfiles.append "jeu_de_base"
		  stdfiles.append "jeu_reduit"
		  stdfiles.append "cubes"
		  stdfiles.append "polyminos"
		  stdfiles.append "tangram"
		  stdfiles.append "reglettes"
		  stdfiles.append "etoiles"
		  
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
		bugtime As Date
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
		iw As Initwindow
	#tag EndProperty

	#tag Property, Flags = &h0
		log As String
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
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FileName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="log"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="majok"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="quiet"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="quitting"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="sys"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
