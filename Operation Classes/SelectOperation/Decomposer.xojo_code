#tag Class
Protected Class Decomposer
Inherits SelectOperation
	#tag Method, Flags = &h0
		Sub constructor(s as polygon)
		  Super.Constructor
		  OpId = 48
		  objects.unhighlightall
		  wnd.refreshtitle
		  DoOperation (s)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoOperation(s as polygon)
		  dim dec as autointersec
		  dim arpo() As point

		  dec = s.autointer
		  if dec = nil then
		    dec = new AutoIntersec(polygon(s))
		  end if
		  if dec.combien = 0 then
		    dec= nil
		    return
		  end if

		  s.autointer.createpoints
		  arpo()=s.completesides
		  s.createcomponents(arpo())


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetName() As string
		  return Dico.value("Decompose")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShape(p as BasicPoint) As shape
		  dim s as shape
		  dim i, j as integer
		  s = super.getshape(p)
		  dim dec as autointersec

		  if visible.count > 0 then
		    for i =  visible.count-1 downto 0
		      s = Visible.item(i)
		      if not s isa polygon then
		        visible.removeobject(s)
		      else
		        dec = polygon(s).autointer
		        if dec = nil then
		          dec = new AutoIntersec(polygon(s))
		        end if
		        if dec.combien = 0 then
		          dec= nil
		          visible.removeobject(s)
		        end if
		      end if
		    next
		  end if
		  nobj = visible.count
		  if nobj > 0  then
		    return visible.item(iobj)
		  else
		    return nil
		  end if

		End Function
	#tag EndMethod


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
