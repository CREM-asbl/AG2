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
			  if other Is Nothing then
			    return false
			  end if
			  return StableKey = other.StableKey
			End Function
		#tag EndMethod
	
		End Class
		#tag EndClass

#tag Class
Public Class IntersectionSolver
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit)) or  (TargetAndroid and (Target64Bit))
	
	#tag Method, Flags = &h0
		Function SolutionsFor(s1 as Shape, s2 as Shape) As IntersectionSolution()
		  // Main entry: returns all valid intersection solutions between two shapes
		  // Each solution has a stable branch key for continuity tracking
		  dim solutions(-1) as IntersectionSolution
		  
		  if s1 = nil or s2 = nil then
		    return solutions
		  end if
		  
		  // Normalize order for deterministic results (circle first if one is circle)
		  dim shapeA as Shape = s1
		  dim shapeB as Shape = s2
		  dim swapped as Boolean = false
		  
		  if s1 isa Circle and not s2 isa Circle then
		    shapeA = s2
		    shapeB = s1
		    swapped = true
		  elseif not s1 isa Circle and s2 isa Circle then
		    // already correct: shapeA = s1 (non-circle), shapeB = s2 (circle)
		  elseif s1 isa Circle and s2 isa Circle then
		    // Order by ID for determinism
		    if s1.id > s2.id then
		      shapeA = s2
		      shapeB = s1
		      swapped = true
		    end if
		  end if
		  
		  // Dispatch based on shape types
		  if shapeA isa Circle and shapeB isa Circle then
		    solutions = SolveCircleCircle(Circle(shapeA), Circle(shapeB), swapped)
		  elseif shapeA isa Circle and shapeB isa Lacet then
		    solutions = SolveCirclePolygon(Circle(shapeA), Lacet(shapeB), swapped)
		  elseif shapeA isa Lacet and shapeB isa Circle then
		    solutions = SolveCirclePolygon(Circle(shapeB), Lacet(shapeA), swapped)
		  elseif shapeA isa Lacet and shapeB isa Lacet then
		    solutions = SolvePolygonPolygon(Lacet(shapeA), Lacet(shapeB), swapped)
		  elseif shapeA isa Droite and shapeB isa Circle then
		    solutions = SolveLineCircle(Droite(shapeA), Circle(shapeB), swapped)
		  elseif shapeA isa Circle and shapeB isa Droite then
		    solutions = SolveLineCircle(Droite(shapeB), Circle(shapeA), swapped)
		  elseif shapeA isa Droite and shapeB isa Droite then
		    solutions = SolveLineLine(Droite(shapeA), Droite(shapeB), swapped)
		  elseif shapeA isa Droite and shapeB isa Lacet then
		    solutions = SolveLinePolygon(Droite(shapeA), Lacet(shapeB), swapped)
		  elseif shapeA isa Lacet and shapeB isa Droite then
		    solutions = SolveLinePolygon(Droite(shapeB), Lacet(shapeA), swapped)
		  end if
		  
		  return solutions
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function SolveCircleCircle(c1 as Circle, c2 as Circle, swapped as Boolean) As IntersectionSolution()
		  dim solutions(-1) as IntersectionSolution
		  dim bq() as BasicPoint
		  dim bib1, bib2 as BiBPoint
		  dim n as Integer
		  
		  bib1 = new BiBPoint(c1.GetGravityCenter, c1.GetGravityCenter + new BasicPoint(0, c1.GetRadius))
		  bib2 = new BiBPoint(c2.GetGravityCenter, c2.GetGravityCenter + new BasicPoint(0, c2.GetRadius))
		  
		  dim dist as Double = c1.GetGravityCenter.Distance(c2.GetGravityCenter)
		  dim r1 as Double = c1.GetRadius
		  dim r2 as Double = c2.GetRadius
		  
		  // Coincident circles
		  if dist < Epsilon and abs(r1 - r2) < Epsilon then
		    // Infinite solutions - return empty with special flag
		    return solutions
		  end if
		  
		  n = bib1.BibInterCercles(bib2, bq())
		  
		  if n = 0 then
		    return solutions
		  end if
		  
		  for i as Integer = 0 to n - 1
		    dim sol as new IntersectionSolution
		    sol.Position = bq(i)
		    sol.Shape1Side = 0
		    sol.Shape2Side = 0
		    sol.IsTangent = (n = 1)
		    sol.IsValid = true
		    sol.Shape1Id = if(swapped, c2.id, c1.id)
		    sol.Shape2Id = if(swapped, c1.id, c2.id)
		    sol.SolutionIndex = i
		    sol.StableKey = sol.ComputeStableKey()
		    solutions.Append sol
		  next
		  
		  return solutions
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function SolveCirclePolygon(c as Circle, poly as Lacet, swapped as Boolean) As IntersectionSolution()
		  dim solutions(-1) as IntersectionSolution
		  dim nSides as Integer = poly.npts - 1
		  if poly isa Polygon then nSides = poly.npts
		  
		  for sideIdx as Integer = 0 to nSides - 1
		    dim side as BiBPoint = poly.coord.GetBibSide(sideIdx)
		    if side = nil then continue
		    
		    dim inters() as BasicPoint
		    dim bq, w as BasicPoint
		    dim n as Integer = side.BiBDroiteInterCercle(new BiBPoint(c.GetGravityCenter, c.GetGravityCenter + new BasicPoint(0, c.GetRadius)), inters(), bq, w)
		    
		    if n = 0 then continue
		    
		    for i as Integer = 0 to n - 1
		      dim pt as BasicPoint = inters(i)
		      
		      // Check if point lies on the segment (not just the line)
		      dim onSegment as Boolean = pt.Between(side.First, side.Second)
		      
		      // For arcs, also check angular bounds
		      if poly isa Arc then
		        onSegment = onSegment and Arc(poly).Inside(pt)
		      end if
		      
		      if onSegment then
		        dim sol as new IntersectionSolution
		        sol.Position = pt
		        sol.Shape1Side = 0  // circle has no sides
		        sol.Shape2Side = sideIdx
		        sol.IsTangent = (n = 1)
		        sol.IsValid = true
		        sol.Shape1Id = if(swapped, poly.id, c.id)
		        sol.Shape2Id = if(swapped, c.id, poly.id)
		        sol.SolutionIndex = solutions.Ubound + 1
		        sol.StableKey = sol.ComputeStableKey()
		        solutions.Append sol
		      end if
		    next
		  next
		  
		  return solutions
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function SolvePolygonPolygon(p1 as Lacet, p2 as Lacet, swapped as Boolean) As IntersectionSolution()
		  dim solutions(-1) as IntersectionSolution
		  dim n1 as Integer = p1.npts - 1
		  dim n2 as Integer = p2.npts - 1
		  if p1 isa Polygon then n1 = p1.npts
		  if p2 isa Polygon then n2 = p2.npts
		  
		  for i as Integer = 0 to n1 - 1
		    dim side1 as BiBPoint = p1.coord.GetBibSide(i)
		    if side1 = nil then continue
		    
		    for j as Integer = 0 to n2 - 1
		      dim side2 as BiBPoint = p2.coord.GetBibSide(j)
		      if side2 = nil then continue
		      
		      dim r1, r2 as Double
		      dim inter as BasicPoint = side1.BiBInterDroites(side2, 2, 2, r1, r2)
		      
		      if inter = nil then continue
		      
		      // Check if intersection lies on both segments
		      dim onSeg1 as Boolean = inter.Between(side1.First, side1.Second)
		      dim onSeg2 as Boolean = inter.Between(side2.First, side2.Second)
		      
		      // For arcs, check angular bounds
		      if p1 isa Arc then
		        onSeg1 = onSeg1 and Arc(p1).Inside(inter)
		      end if
		      if p2 isa Arc then
		        onSeg2 = onSeg2 and Arc(p2).Inside(inter)
		      end if
		      
		      if onSeg1 and onSeg2 then
		        dim sol as new IntersectionSolution
		        sol.Position = inter
		        sol.Shape1Side = i
		        sol.Shape2Side = j
		        sol.IsTangent = false
		        sol.IsValid = true
		        sol.Shape1Id = if(swapped, p2.id, p1.id)
		        sol.Shape2Id = if(swapped, p1.id, p2.id)
		        sol.SolutionIndex = solutions.Ubound + 1
		        sol.StableKey = sol.ComputeStableKey()
		        solutions.Append sol
		      end if
		    next
		  next
		  
		  return solutions
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function SolveLineCircle(line as Droite, c as Circle, swapped as Boolean) As IntersectionSolution()
		  dim solutions(-1) as IntersectionSolution
		  dim inters() as BasicPoint
		  dim bq, w as BasicPoint
		  dim bibLine as BiBPoint = new BiBPoint(line.FirstP, line.SecondP)
		  dim bibCircle as BiBPoint = new BiBPoint(c.GetGravityCenter, c.GetGravityCenter + new BasicPoint(0, c.GetRadius))
		  
		  dim n as Integer = bibLine.BiBDroiteInterCercle(bibCircle, inters(), bq, w)
		  
		  if n = 0 then return solutions
		  
		  for i as Integer = 0 to n - 1
		    dim sol as new IntersectionSolution
		    sol.Position = inters(i)
		    sol.Shape1Side = 0
		    sol.Shape2Side = 0
		    sol.IsTangent = (n = 1)
		    sol.IsValid = true
		    sol.Shape1Id = if(swapped, c.id, line.id)
		    sol.Shape2Id = if(swapped, line.id, c.id)
		    sol.SolutionIndex = i
		    sol.StableKey = sol.ComputeStableKey()
		    solutions.Append sol
		  next
		  
		  return solutions
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function SolveLineLine(line1 as Droite, line2 as Droite, swapped as Boolean) As IntersectionSolution()
		  dim solutions(-1) as IntersectionSolution
		  dim r1, r2 as Double
		  dim inter as BasicPoint = line1.BiBInterDroites(line2, 2, 2, r1, r2)
		  
		  if inter = nil then return solutions
		  
		  dim sol as new IntersectionSolution
		  sol.Position = inter
		  sol.Shape1Side = 0
		  sol.Shape2Side = 0
		  sol.IsTangent = false
		  sol.IsValid = true
		  sol.Shape1Id = if(swapped, line2.id, line1.id)
		  sol.Shape2Id = if(swapped, line1.id, line2.id)
		  sol.SolutionIndex = 0
		  sol.StableKey = sol.ComputeStableKey()
		  solutions.Append sol
		  
		  return solutions
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function SolveLinePolygon(line as Droite, poly as Lacet, swapped as Boolean) As IntersectionSolution()
		  dim solutions(-1) as IntersectionSolution
		  dim nSides as Integer = poly.npts - 1
		  if poly isa Polygon then nSides = poly.npts
		  
		  for sideIdx as Integer = 0 to nSides - 1
		    dim side as BiBPoint = poly.coord.GetBibSide(sideIdx)
		    if side = nil then continue
		    
		    dim r1, r2 as Double
		    dim inter as BasicPoint = line.BiBInterDroites(side, 2, 2, r1, r2)
		    
		    if inter = nil then continue
		    
		    dim onSegment as Boolean = inter.Between(side.First, side.Second)
		    if poly isa Arc then
		      onSegment = onSegment and Arc(poly).Inside(inter)
		    end if
		    
		    if onSegment then
		      dim sol as new IntersectionSolution
		      sol.Position = inter
		      sol.Shape1Side = 0
		      sol.Shape2Side = sideIdx
		      sol.IsTangent = false
		      sol.IsValid = true
		      sol.Shape1Id = if(swapped, poly.id, line.id)
		      sol.Shape2Id = if(swapped, line.id, poly.id)
		      sol.SolutionIndex = solutions.Ubound + 1
		      sol.StableKey = sol.ComputeStableKey()
		      solutions.Append sol
		    end if
		  next
		  
		  return solutions
		End Function
	#tag EndMethod
	
		#tag Method, Flags = &h0
					Function Equals(other as IntersectionSolver) As Boolean
					  return false
					End Function
				#tag EndMethod

			End Class
			#tag EndClass