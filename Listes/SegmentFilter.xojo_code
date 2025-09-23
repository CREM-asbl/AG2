#tag Class
Class SegmentFilter
Implements IShapeFilter
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target64Bit ) ) or ( TargetAndroid and ( Target64Bit ) )
	#tag Method, Flags = &h0
		Sub Filter(candidate as Shape, searchPoint as BasicPoint, results as Liste)
		  if candidate isa droite and droite(candidate).nextre = 2 and droite(candidate).pInShape(searchPoint) then
		    results.addobject(candidate)
		  elseif candidate isa polygon and polygon(candidate).pointonside(searchPoint) > -1 then
		    results.addobject(candidate)
		  end if
		End Sub
	#tag EndMethod


End Class
#tag EndClass
