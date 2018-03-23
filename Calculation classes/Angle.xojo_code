#tag Class
Protected Class Angle
	#tag Method, Flags = &h0
		Sub Constructor(Bib as BiBPoint, c as BasicPoint, ori as integer)
		  
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
		Sub constructor(tb as nBPoint)
		  dim c, bpf, bps as BasicPoint
		  dim fa, sa as double
		  
		  c = tb.tab(0)
		  
		  bpf = tb.tab(1) - c
		  fa  = bpf.anglepolaire
		  bps = tb.tab(2) - c
		  sa = bps.anglepolaire
		  alpha = sa - fa
		  ori = tb.orientation
		  'On ne normalise pas, en vue du calcul de l'aire
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
		alpha As double
	#tag EndProperty

	#tag Property, Flags = &h0
		c As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		ori As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="alpha"
			Group="Behavior"
			InitialValue="0"
			Type="double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
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
			Name="ori"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
