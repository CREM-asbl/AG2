#tag Class
Class BipointFilter
Implements IShapeFilter
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target64Bit ) ) or ( TargetAndroid and ( Target64Bit ) )
	#tag Method, Flags = &h0
		Sub Filter(candidate as Shape, searchPoint as BasicPoint, results as Liste)
		  dim found as boolean = false
		  if candidate isa droite and candidate.PinShape(searchPoint) then
		    found = true
		  elseif candidate isa polygon and polygon(candidate).pointonside(searchPoint) > -1 then
		    found = true
		  end if
		  if found then
		    results.addobject(candidate)
		  end if
		End Sub
	#tag EndMethod


End Class
#tag EndClass
