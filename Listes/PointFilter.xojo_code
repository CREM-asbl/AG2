#tag Class
Class PointFilter
Implements IShapeFilter
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target64Bit ) ) or ( TargetAndroid and ( Target64Bit ) )
	#tag Method, Flags = &h0
		Sub Filter(candidate as Shape, searchPoint as BasicPoint, results as Liste)
		  // Cherche le point lui-même s'il est un point
		  if candidate isa point and (not candidate.Hidden or WorkWindow.DrapShowALL) and point(candidate).pinshape(searchPoint) then
		    results.addobject(candidate)
		  else
		    // Cherche dans les enfants de la forme
		    dim j as integer
		    dim pt as point
		    if candidate.childs <> nil then
		      for j = 0 to ubound(candidate.childs)
		        pt = candidate.childs(j)
		        // Les enfants ne sont pas vérifiés par la boucle principale de findWithFilter,
		        // ils nécessitent donc leurs propres vérifications de validité.
		        if (not pt.invalid) and not (pt.deleted) and (not pt.Hidden or WorkWindow.DrapShowALL) and pt.pinshape(searchPoint) then
		          results.addobject(pt)
		        end if
		      next
		    end if
		  end if
		End Sub
	#tag EndMethod


End Class
#tag EndClass
