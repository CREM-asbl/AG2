#tag Class
Protected Class Debug
	#tag Method, Flags = &h0
		Function getString() As String
		  s = s+"------"+EndOfLine
		  
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setVariable(name as String, valeur As Variant)
		  dim Svaleur as String
		  
		  s = s+"  $"+name+" :  "
		  
		  '#if not DebugBuild
		  if valeur <> nil then
		    try
		      'variant pouvant être retourné en string
		      Svaleur = valeur
		    catch err as TypeMismatchException
		      'variant ne pouvant pas retourner de string
		      if valeur isa StringProvider then
		        Svaleur = StringProvider(valeur).getString
		      else
		        Svaleur = "la donnée n'implémente pas encore StringProvider"
		      end if
		    end
		  else
		    Svaleur = "nil"
		  end if
		  '#endif
		  
		  
		  s = s+Svaleur+EndOfLine
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setMessage(message as String)
		  s = s+"   /*"+message+"*/"+EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setMethod(classe as string, name as String)
		  s = s+classe+"_"+name+EndOfLine
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub reset()
		  s=""
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		s As String
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
			Name="s"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
