#tag Class
Public Class IntersectionSolution
	#tag Property, Flags = &h0
		Position As BasicPoint
	#tag EndProperty

	#tag Property, Flags = &h0
		Shape1Side As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Shape2Side As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		IsTangent As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		IsValid As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Shape1Id As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Shape2Id As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		SolutionIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		StableKey As String
	#tag EndProperty

	#tag Method, Flags = &h0
		Function ComputeStableKey() As String
		  // Deterministic key for branch continuity: shape1_id|shape2_id|side1|side2|solution_index
		  return Str(Shape1Id) + "|" + Str(Shape2Id) + "|" + Str(Shape1Side) + "|" + Str(Shape2Side) + "|" + Str(SolutionIndex)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Equals(other as IntersectionSolution) As Boolean
		  if other = nil then
		    return false
		  end if
		  return StableKey = other.StableKey
		End Function
	#tag EndMethod

End Class
#tag EndClass
