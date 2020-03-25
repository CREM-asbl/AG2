#tag Class
Protected Class Debug
	#tag Method, Flags = &h0
		Function getString() As String
		  s = EndOfLine+s+EndOfLine
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub reset()
		  s=""
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
		Sub setVariable(name As String, valeur As Variant)
		  dim sValeur as String
		  
		  s = s+"  $"+name+" :  "
		  
		  if valeur <> nil then
		    try
		      Svaleur = str(valeur)
		    catch TypeMismatchException
		      svaleur = "toString pas encore implémenté"
		      var methods() as Introspection.MethodInfo
		      methods = Introspection.GetType(valeur).getMethods
		      for Each method as Introspection.MethodInfo in methods
		        if method.Name = "getString" then
		          sValeur = method.Invoke(valeur)
		          exit
		        end if
		      next
		    end 
		  else
		    Svaleur = "nil"
		  end if
		  
		  s = s+Svaleur+EndOfLine
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		s As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="s"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
