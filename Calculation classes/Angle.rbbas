#tag Class
Protected Class Angle
	#tag Method, Flags = &h0
		Sub Angle(Bib as BiBPoint, c as BasicPoint, ori as integer)
		  
		  dim bpf, bps as BasicPoint
		  dim fa, sa as double
		  
		  self.c = c
		  self.ori = ori
		  
		  bpf = Bib.first - c
		  fa  = bpf.anglepolaire
		  bps = Bib.second - c
		  sa = bps.anglepolaire
		  alpha = sa - fa
		  Normalize
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Normalize()
		  if ori >0 then
		    if alpha < 0 then
		      alpha = alpha + 2*PI
		    end if
		  elseif ori <0 then
		    if alpha >0 then
		      alpha = alpha -2*PI
		    end if
		  end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		c As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		alpha As double
	#tag EndProperty

	#tag Property, Flags = &h0
		ori As Integer
	#tag EndProperty


	#tag ViewBehavior
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
			Name="alpha"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ori"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
