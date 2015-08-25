#tag Class
Protected Class SaveStd
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub SaveStd()
		  
		  SelectOperation
		  OpId = 47
		  if tempshape.count  = 0 then
		    objects.selectall
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation()
		  dim Tos as TextOutputStream
		  dim titre as string
		  dim n, i, j as integer
		  dim f as folderitem
		  dim stdw as StdFamWindow
		  dim Doc, NewDoc as XmlDocument
		  dim FStd, Temp, EL, EL1  As XmlElement
		  dim s as shape
		  dim Bib as BiBPoint
		  dim alpha, beta as double
		  Dim dlg as New MessageDialog
		  dim Mess as MessageDialogButton
		  dim dlg2 As SaveAsDialog
		  
		  if tempshape.count =  0 then
		    return
		  end if
		  
		  stdw = new stdfamwindow
		  stdw.ShowModal
		  if stdw.result = 0 then
		    return
		  end if
		  
		  if Nom = "" then
		    nom = "Untitled"
		  end if
		  
		  Doc = new XmlDocument
		  Doc.Preservewhitespace = true
		  FStd = Doc.CreateElement("FormesStandard")
		  Doc.Appendchild (FStd)
		  Temp = Doc.CreateElement("Famille")
		  Temp.setAttribute("Nom",Nom)
		  FStd.AppendChild Temp
		  if coul <> nil then
		    Temp.AppendChild coul.XMLPutInContainer(Doc,"Couleur")
		  end if
		  
		  for i = 0 to tempshape.count-1
		    s = tempshape.element(i)
		    EL = Doc.CreateElement("Forme")
		    EL.AppendChild s.FillColor.XMLPutInContainer(Doc,"Couleur")
		    EL.SetAttribute("Nom", "Forme "+str(i+1))
		    alpha = 0
		    for j = 0 to s.npts-2
		      EL1 = Doc.CreateElement("Arete")
		      Bib = s.GetBiBside(j)
		      EL1.SetAttribute("Longueur",str(BiB.longueur))
		      beta = BiB.anglepolaire*180/PI
		      EL1.SetAttribute("Angle",str(beta-alpha))
		      EL.AppendChild EL1
		      alpha = beta
		    next
		    Temp.Appendchild EL
		  next
		  
		  dlg.Message = "Pour sauvegarder la famille de formes standard créées :" +EndofLine  + "choisissez une action."
		  dlg.ActionButton.Caption = "Créer un nouveau fichier"
		  dlg.AlternateActionButton.Caption = "Adjoindre à un fichier existant"
		  dlg.AlternateActionButton.Visible = true
		  dlg.CancelButton.Visible = true
		  dlg.CancelButton.Caption = Dico.Value("Cancel")
		  dlg.Explanation = "Attention, il ne peut y avoir plus de 4 familles par fichier."
		  dlg.Title= Dico.Value("SaveStd")
		  mess = dlg.ShowModal()
		  
		  dlg2 = new SaveAsDialog
		  dlg2.filter=FileAGTypes.STD
		  dlg2.InitialDirectory = app.StdFolder
		  
		  select case mess
		  case dlg.ActionButton
		    dlg2.SuggestedFileName= "*.std"
		    dlg2.Title =  "Créez un nouveau fichier en remplaçant l'étoile par un nom. N'utilisez pas un nom déjà existant."
		    f = dlg2.ShowModal
		  case dlg.AlternateActionButton
		    dlg2.title = "Choisissez un nom dans la liste."
		    f = dlg2.ShowModal
		  case dlg.CancelButton
		    return
		  end select
		  
		  
		  
		  if f = nil then
		    return
		  end if
		  
		  n = f.name.Instr(".")
		  if n = 0 then
		    f.name = f.name +".std"
		  else
		    f.name = Left(f.name, n-1) +".std"
		  end if
		  if f <> nil  then
		    if f.exists then
		      NewDoc = new XMLDocument(f)
		      NewDoc.Child(0).appendchild NewDoc.ImportNode(temp, true)
		      tos = f.CreateTextFile
		      tos.write NewDoc.ToString
		    else
		      tos = f.CreateTextFile
		      tos.write Doc.ToString
		    end if
		    tos.close
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		coul As couleur
	#tag EndProperty

	#tag Property, Flags = &h0
		Nom As string
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
			InheritedFrom="Operation"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Nom"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
