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
		  dim n, i, j,  nfam as integer
		  dim f as folderitem
		  dim stdw as StdFamWindow
		  dim Doc as XmlDocument
		  dim FStd, Temp, EL, EL1  As XmlElement
		  dim s as shape
		  dim Bib as BiBPoint
		  dim alpha, beta as double
		  Dim dlg as New SaveAsDialog
		  
		  if tempshape.count =  0 then
		    return
		  end if
		  
		  stdw = new stdfamwindow
		  stdw.ShowModal
		  
		  
		  Doc = new XmlDocument
		  Doc.Preservewhitespace = true
		  FStd = Doc.CreateElement("FormesStandard")
		  Doc.Appendchild (FStd)
		  Temp = Doc.CreateElement("Famille")
		  Temp.setAttribute("Nom",wnd.NomFam)
		  FStd.AppendChild Temp
		  Temp.AppendChild wnd.coul.XMLPutInContainer(Doc,"Couleur")
		  
		  nfam = 1
		  
		  for i = 0 to tempshape.count-1
		    s = tempshape.element(i)
		    EL = Doc.CreateElement("Forme")
		    EL.SetAttribute("Nom", "Piece"+str(i))
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
		  
		  dlg.InitialDirectory=app.AppFolder
		  dlg.promptText=""
		  dlg.Title= Dico.Value("SaveStd")
		  dlg.filter=FileAGTypes.STD
		  
		  f=dlg.ShowModal()
		  n = f.name.Instr(".")
		  if n = 0 then
		    f.name = f.name +".std"
		  else
		    f.name = Left(f.name, n-1) +".std"
		  end if
		  if f <> nil then
		    tos=f.createTextFile
		    tos.write Doc.ToString
		    tos.close
		  end if
		  
		End Sub
	#tag EndMethod


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
			Name="NomFam"
			Group="Behavior"
			Type="string"
		#tag EndViewProperty
		#tag ViewProperty
			Name="col"
			Group="Behavior"
			InitialValue="&h000000"
			Type="color"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
