#tag Class
Protected Class AutoIntersec
Inherits Intersec
	#tag Method, Flags = &h0
		Sub computeinterlines()
		  dim i, j,k as integer
		  dim bp as basicpoint
		  dim d1, d2 as droite
		  dim r1,r2 as double
		  
		  
		  for i = 0 to nlig
		    d1 = sh1.getside(i)
		    for j = 0 to ncol
		      if j <> i then
		        d2 = sh2.getside(j)
		        bp = nil
		        k = d1.inter(d2,bp,r1,r2)
		        if bp <> nil then
		          bptinters(i,j) = bp
		        end if
		        if (k = 0)  or (r1 > 998) then
		          val(i,j) = false
		        end if
		        if r1 > 998 then
		          drappara = true
		        end if
		      else
		        val(i,j) = false
		      end if
		    next
		  next
		  
		  positionfalseinterpoints
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  super.constructor
		  OpId = 45
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(s as polygon)
		  Super.Constructor
		  
		  sh1 = s
		  sh2 = s
		  nlig = s.npts-1
		  ncol = s.npts-1
		  
		  redim bptinters(nlig, ncol)
		  redim ids(nlig,ncol)
		  redim val(nlig,ncol)
		  redim pts(-1)
		  
		  computeinter
		  s.autointer = self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Paint(g as graphics)
		  dim i, j as integer
		  dim sk as OvalSkull
		  
		  for i = 0 to sh1.npts-1
		    for j = 0 to sh2.npts-1
		      if i <> j and val(i,j) and not bezet(i,j) then
		        sk = new Ovalskull(3,can.transform(bptinters(i,j)))
		        sk.updatecolor(bleu,100)
		        sk.paint(g)
		      end if
		    next
		  next
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="display"
			Group="Behavior"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drap"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="drappara"
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
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
			Name="ncol"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="nlig"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
			Name="SidetoPaint"
			Group="Behavior"
			InitialValue="0"
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
