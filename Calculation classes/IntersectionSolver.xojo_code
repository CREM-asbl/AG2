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
		  elseif s1 isa Circle and s2 isa Circle then
		    // Order by ID for determinism
		    if s1.id > s2.id then
		      shapeA = s2
		      shapeB = s1
		      swapped = true
		    end if
		  end if

		  // Dispatch based on shape types (Lacet covers Polygon subclass)
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
		  elseif shapeA isa Droite and shapeB isa Droite then
		    solutions = SolveLineLine(Droite(shapeA), Droite(shapeB), swapped)
		  elseif shapeA isa Droite and shapeB isa Lacet then
		    solutions = SolveLinePolygon(Droite(shapeA), Lacet(shapeB), swapped)
		  end if

		  return solutions
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SolveCircleCircle(c1 as Circle, c2 as Circle, swapped as Boolean) As IntersectionSolution()
		  dim solutions(-1) as IntersectionSolution
		  dim p() as BasicPoint
		  dim bq, v as BasicPoint
		  dim bib1, bib2 as BiBPoint
		  dim n as Integer

		  bib1 = new BiBPoint(c1.GetGravityCenter, c1.GetGravityCenter + new BasicPoint(0, c1.GetRadius))
		  bib2 = new BiBPoint(c2.GetGravityCenter, c2.GetGravityCenter + new BasicPoint(0, c2.GetRadius))

		  dim dist as Double = c1.GetGravityCenter.Distance(c2.GetGravityCenter)
		  dim r1 as Double = c1.GetRadius
		  dim r2 as Double = c2.GetRadius

		  // Coincident circles: infinite solutions, return empty
		  if dist < Epsilon and abs(r1 - r2) < Epsilon then
		    return solutions
		  end if

		  n = bib1.BibInterCercles(bib2, p(), bq, v)

		  if n = 0 then
		    return solutions
		  end if

		  for i as Integer = 0 to n - 1
		    dim sol as new IntersectionSolution
		    sol.Position = p(i)
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
		  dim nSides as Integer = poly.npts
		  if not poly isa Polygon then nSides = poly.npts - 1

		  for sideIdx as Integer = 0 to nSides - 1
		    dim side as BiBPoint = poly.coord.GetBibSide(sideIdx)
		    if side = nil then continue

		    dim inters() as BasicPoint
		    dim bq, w as BasicPoint
		    dim bibCircle as BiBPoint = new BiBPoint(c.GetGravityCenter, c.GetGravityCenter + new BasicPoint(0, c.GetRadius))
		    dim n as Integer = side.BibDroiteInterCercle(bibCircle, inters(), bq, w)

		    if n = 0 then continue

		    for i as Integer = 0 to n - 1
		      dim pt as BasicPoint = inters(i)

		      // Check if point lies on the segment (not just the line)
		      dim onSegment as Boolean = pt.Between(side.First, side.Second)

		      if onSegment then
		        dim sol as new IntersectionSolution
		        sol.Position = pt
		        sol.Shape1Side = 0
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
		  dim n1 as Integer = p1.npts
		  dim n2 as Integer = p2.npts
		  if not p1 isa Polygon then n1 = p1.npts - 1
		  if not p2 isa Polygon then n2 = p2.npts - 1

		  for i as Integer = 0 to n1 - 1
		    dim side1 as BiBPoint = p1.coord.GetBibSide(i)
		    if side1 = nil then continue

		    for j as Integer = 0 to n2 - 1
		      dim side2 as BiBPoint = p2.coord.GetBibSide(j)
		      if side2 = nil then continue

		      dim r1, r2 as Double
		      dim bib1 as BiBPoint = new BiBPoint(side1.First, side1.Second)
		      dim bib2 as BiBPoint = new BiBPoint(side2.First, side2.Second)
		      dim inter as BasicPoint = bib1.BibInterdroites(bib2, 2, 2, r1, r2)

		      if inter = nil then continue

		      // Check if intersection lies on both segments
		      dim onSeg1 as Boolean = inter.Between(side1.First, side1.Second)
		      dim onSeg2 as Boolean = inter.Between(side2.First, side2.Second)

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

		  dim n as Integer = bibLine.BibDroiteInterCercle(bibCircle, inters(), bq, w)

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
		  dim bib1 as BiBPoint = new BiBPoint(line1.FirstP, line1.SecondP)
		  dim bib2 as BiBPoint = new BiBPoint(line2.FirstP, line2.SecondP)
		  dim inter as BasicPoint = bib1.BibInterdroites(bib2, 2, 2, r1, r2)

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
		  dim nSides as Integer = poly.npts
		  if not poly isa Polygon then nSides = poly.npts - 1

		  for sideIdx as Integer = 0 to nSides - 1
		    dim side as BiBPoint = poly.coord.GetBibSide(sideIdx)
		    if side = nil then continue

		    dim r1, r2 as Double
		    dim bibLine2 as BiBPoint = new BiBPoint(line.FirstP, line.SecondP)
		    dim bibSide2 as BiBPoint = new BiBPoint(side.First, side.Second)
		    dim inter as BasicPoint = bibLine2.BibInterdroites(bibSide2, 2, 2, r1, r2)

		    if inter = nil then continue

		    dim onSegment as Boolean = inter.Between(side.First, side.Second)

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

End Class
#tag EndClass
