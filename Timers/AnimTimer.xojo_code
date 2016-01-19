#tag Class
Protected Class AnimTimer
Inherits Timer
	#tag Event
		Sub Action()
		  
		  
		  if s isa freecircle or s isa arc then
		    BPInter=M*(oper.pointmobile.bpt) - (oper.pointmobile.bpt)
		  end if
		  oper.DoOper(BPInter)
		  pas = pas-1
		  
		  if pas = 0 then
		    oper.figs.updateoldM
		    restart
		  end if
		  
		  can.RefreshBackground
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(oper as Modifier)
		  dim q as BasicPoint
		  self.oper = oper
		  can = wnd.Mycanvas1
		  niter = 60
		  Mode=2
		  period=100
		  enabled = true
		  s = oper.pointmobile.pointsur.element(0)
		  if s isa freecircle then
		    niter = 60*PI
		    M = new RotationMatrix(s.points(0).bpt, 2*PI*s.ori/niter)
		    oper.startpoint = oper.pointmobile.bpt
		    BPInter = M*(oper.startpoint) - oper.startpoint
		  elseif s isa arc then                                                                     //Introduit après le 19/08/2012
		    niter = 60
		    oper.startpoint = oper.pointmobile.bpt
		    q = oper.startpoint - s.Points(0).bpt
		    M = new RotationMatrix(s.points(0).bpt, (arc(s).endangle -q.anglepolaire)/niter)
		    BPInter = M*(oper.startpoint) - oper.startpoint
		  else
		    oper.StartPoint = oper.pointmobile.bpt
		    oper.EndPoint = droite(s).secondp
		    niter = 30*(oper.startpoint.distance(oper.endpoint))
		    BPInter = oper.VectInter(niter)
		  end if
		  pas = niter
		  oper.endpoint = oper.startpoint
		  
		  can.mousecursor = System.cursors.wait
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub restart()
		  
		  dim v as BasicPoint
		  
		  pas = 60
		  niter = 60
		  if s isa droite then
		    oper.StartPoint = droite(s).firstp
		    oper.EndPoint = droite(s).secondp
		    BPInter = oper.VectInter(niter)
		  elseif s isa arc then                                                           //Introduit après le 19/08/12
		    oper.StartPoint = arc(s).points(1).bpt
		    'oper.EndPoint = arc(s).points(2).bpt
		    M = new RotationMatrix(s.points(0).bpt, arc(s).arcangle/niter)
		    BPInter = M*(oper.startpoint) - oper.startpoint
		  Else
		    oper.startpoint = oper.pointmobile.bpt
		    BPInter = M*(oper.startpoint) - oper.startpoint
		  end if
		  oper.endpoint = oper.startpoint
		  
		  
		  
		  pas = niter
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		BPInter As basicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		can As mycanvas
	#tag EndProperty

	#tag Property, Flags = &h0
		M As RotationMatrix
	#tag EndProperty

	#tag Property, Flags = &h0
		niter As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		oper As Modifier
	#tag EndProperty

	#tag Property, Flags = &h0
		pas As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		s As shape
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Mode"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			EditorType="Enum"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="niter"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="pas"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Period"
			Visible=true
			Group="Behavior"
			InitialValue="1000"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
