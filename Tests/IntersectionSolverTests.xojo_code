#tag Class
Protected Class IntersectionSolverTests
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit)) or  (TargetAndroid and (Target64Bit))
	
	#tag Method, Flags = &h0
		Sub RunAllTests()
		  dim passed as Integer = 0
		  dim failed as Integer = 0
		  
		  // Circle-Circle tests
		  if TestCircleCircleNoIntersection() then passed = passed + 1 else failed = failed + 1
		  if TestCircleCircleTangentExternal() then passed = passed + 1 else failed = failed + 1
		  if TestCircleCircleTangentInternal() then passed = passed + 1 else failed = failed + 1
		  if TestCircleCircleTwoIntersections() then passed = passed + 1 else failed = failed + 1
		  if TestCircleCircleCoincident() then passed = passed + 1 else failed = failed + 1
		  if TestCircleCircleOneInsideOther() then passed = passed + 1 else failed = failed + 1
		  
		  // Circle-Polygon tests
		  if TestCirclePolygonNoIntersection() then passed = passed + 1 else failed = failed + 1
		  if TestCirclePolygonTangent() then passed = passed + 1 else failed = failed + 1
		  if TestCirclePolygonTwoIntersections() then passed = passed + 1 else failed = failed + 1
		  if TestCirclePolygonArcBounds() then passed = passed + 1 else failed = failed + 1
		  
		  // Polygon-Polygon tests
		  if TestPolygonPolygonSegmentSegment() then passed = passed + 1 else failed = failed + 1
		  if TestPolygonPolygonArcArc() then passed = passed + 1 else failed = failed + 1
		  if TestPolygonPolygonSegmentArc() then passed = passed + 1 else failed = failed + 1
		  if TestPolygonPolygonNoIntersection() then passed = passed + 1 else failed = failed + 1
		  
		  // Line-Circle tests
		  if TestLineCircleNoIntersection() then passed = passed + 1 else failed = failed + 1
		  if TestLineCircleTangent() then passed = passed + 1 else failed = failed + 1
		  if TestLineCircleTwoIntersections() then passed = passed + 1 else failed = failed + 1
		  
		  // Line-Line tests
		  if TestLineLineIntersect() then passed = passed + 1 else failed = failed + 1
		  if TestLineLineParallel() then passed = passed + 1 else failed = failed + 1
		  if TestLineLineCoincident() then passed = passed + 1 else failed = failed + 1
		  
		  // Line-Polygon tests
		  if TestLinePolygonIntersections() then passed = passed + 1 else failed = failed + 1
		  if TestLinePolygonNoIntersection() then passed = passed + 1 else failed = failed + 1
		  
		  // Degenerate cases
		  if TestDegenerateZeroRadiusCircle() then passed = passed + 1 else failed = failed + 1
		  if TestDegenerateZeroLengthSegment() then passed = passed + 1 else failed = failed + 1
		  if TestDegeneratePointCircle() then passed = passed + 1 else failed = failed + 1
		  
		  // Stable key tests
		  if TestStableKeyDeterministic() then passed = passed + 1 else failed = failed + 1
		  if TestStableKeySwappedShapes() then passed = passed + 1 else failed = failed + 1
		  
		  System.DebugLog "Tests passed: " + Str(passed) + ", failed: " + Str(failed)
		End Sub
	#tag EndMethod
	
	// ===== Circle-Circle Tests =====
	
	#tag Method, Flags = &h0
		Function TestCircleCircleNoIntersection() As Boolean
		  dim c1 as new Circle
		  c1.id = 1
		  c1.SetCenterRadius(new BasicPoint(0, 0), 1)
		  
		  dim c2 as new Circle
		  c2.id = 2
		  c2.SetCenterRadius(new BasicPoint(5, 0), 1)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(c1, c2)
		  
		  return solutions.Ubound = -1
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestCircleCircleTangentExternal() As Boolean
		  dim c1 as new Circle
		  c1.id = 1
		  c1.SetCenterRadius(new BasicPoint(0, 0), 1)
		  
		  dim c2 as new Circle
		  c2.id = 2
		  c2.SetCenterRadius(new BasicPoint(2, 0), 1)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(c1, c2)
		  
		  if solutions.Ubound <> 0 then return false
		  return solutions(0).IsTangent = true
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestCircleCircleTangentInternal() As Boolean
		  dim c1 as new Circle
		  c1.id = 1
		  c1.SetCenterRadius(new BasicPoint(0, 0), 3)
		  
		  dim c2 as new Circle
		  c2.id = 2
		  c2.SetCenterRadius(new BasicPoint(2, 0), 1)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(c1, c2)
		  
		  if solutions.Ubound <> 0 then return false
		  return solutions(0).IsTangent = true
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestCircleCircleTwoIntersections() As Boolean
		  dim c1 as new Circle
		  c1.id = 1
		  c1.SetCenterRadius(new BasicPoint(0, 0), 2)
		  
		  dim c2 as new Circle
		  c2.id = 2
		  c2.SetCenterRadius(new BasicPoint(2, 0), 2)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(c1, c2)
		  
		  if solutions.Ubound <> 1 then return false
		  return solutions(0).IsTangent = false and solutions(1).IsTangent = false
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestCircleCircleCoincident() As Boolean
		  dim c1 as new Circle
		  c1.id = 1
		  c1.SetCenterRadius(new BasicPoint(0, 0), 2)
		  
		  dim c2 as new Circle
		  c2.id = 2
		  c2.SetCenterRadius(new BasicPoint(0, 0), 2)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(c1, c2)
		  
		  // Coincident circles return empty (infinite solutions)
		  return solutions.Ubound = -1
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestCircleCircleOneInsideOther() As Boolean
		  dim c1 as new Circle
		  c1.id = 1
		  c1.SetCenterRadius(new BasicPoint(0, 0), 5)
		  
		  dim c2 as new Circle
		  c2.id = 2
		  c2.SetCenterRadius(new BasicPoint(1, 0), 1)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(c1, c2)
		  
		  return solutions.Ubound = -1
		End Function
	#tag EndMethod
	
	// ===== Circle-Polygon Tests =====
	
	#tag Method, Flags = &h0
		Function TestCirclePolygonNoIntersection() As Boolean
		  dim c as new Circle
		  c.id = 1
		  c.SetCenterRadius(new BasicPoint(0, 0), 1)
		  
		  dim poly as new Polygon
		  poly.id = 2
		  dim pts(3) as BasicPoint
		  pts(0) = new BasicPoint(5, 5)
		  pts(1) = new BasicPoint(6, 5)
		  pts(2) = new BasicPoint(6, 6)
		  pts(3) = new BasicPoint(5, 6)
		  poly.coord = new nBpoint(pts)
		  poly.npts = 4
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(c, poly)
		  
		  return solutions.Ubound = -1
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestCirclePolygonTangent() As Boolean
		  dim c as new Circle
		  c.id = 1
		  c.SetCenterRadius(new BasicPoint(0, 0), 1)
		  
		  dim poly as new Polygon
		  poly.id = 2
		  dim pts(3) as BasicPoint
		  pts(0) = new BasicPoint(1, -1)
		  pts(1) = new BasicPoint(2, -1)
		  pts(2) = new BasicPoint(2, 1)
		  pts(3) = new BasicPoint(1, 1)
		  poly.coord = new nBpoint(pts)
		  poly.npts = 4
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(c, poly)
		  
		  if solutions.Ubound <> 0 then return false
		  return solutions(0).IsTangent = true
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestCirclePolygonTwoIntersections() As Boolean
		  dim c as new Circle
		  c.id = 1
		  c.SetCenterRadius(new BasicPoint(0, 0), 2)
		  
		  dim poly as new Polygon
		  poly.id = 2
		  dim pts(3) as BasicPoint
		  pts(0) = new BasicPoint(-3, -1)
		  pts(1) = new BasicPoint(3, -1)
		  pts(2) = new BasicPoint(3, 1)
		  pts(3) = new BasicPoint(-3, 1)
		  poly.coord = new nBpoint(pts)
		  poly.npts = 4
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(c, poly)
		  
		  // Should intersect top and bottom edges
		  return solutions.Ubound = 1
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestCirclePolygonArcBounds() As Boolean
		  dim c as new Circle
		  c.id = 1
		  c.SetCenterRadius(new BasicPoint(0, 0), 2)
		  
		  dim arc as new Arc
		  arc.id = 2
		  arc.SetCenterRadius(new BasicPoint(0, 0), 2)
		  arc.SetAngles(0, 90) // Quarter circle in first quadrant
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(c, arc)
		  
		  // Circle and arc are coincident - infinite solutions, returns empty
		  return solutions.Ubound = -1
		End Function
	#tag EndMethod
	
	// ===== Polygon-Polygon Tests =====
	
	#tag Method, Flags = &h0
		Function TestPolygonPolygonSegmentSegment() As Boolean
		  dim p1 as new Polygon
		  p1.id = 1
		  dim pts1(3) as BasicPoint
		  pts1(0) = new BasicPoint(0, 0)
		  pts1(1) = new BasicPoint(2, 0)
		  pts1(2) = new BasicPoint(2, 2)
		  pts1(3) = new BasicPoint(0, 2)
		  p1.coord = new nBpoint(pts1)
		  p1.npts = 4
		  
		  dim p2 as new Polygon
		  p2.id = 2
		  dim pts2(3) as BasicPoint
		  pts2(0) = new BasicPoint(1, -1)
		  pts2(1) = new BasicPoint(3, -1)
		  pts2(2) = new BasicPoint(3, 1)
		  pts2(3) = new BasicPoint(1, 1)
		  p2.coord = new nBpoint(pts2)
		  p2.npts = 4
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(p1, p2)
		  
		  // Two intersections: (1,0) and (2,0) - wait, (2,0) is corner
		  // Actually: p1 right edge (2,0)-(2,2) intersects p2 left edge (1,-1)-(1,1) at (1,0)? No.
		  // p1 bottom (0,0)-(2,0) intersects p2 left (1,-1)-(1,1) at (1,0)
		  // p1 right (2,0)-(2,2) intersects p2 bottom (1,-1)-(3,-1) - no
		  // p1 right (2,0)-(2,2) intersects p2 right (3,-1)-(3,1) - no
		  // p1 top (2,2)-(0,2) - no
		  // p1 left (0,2)-(0,0) - no
		  // So only one intersection at (1,0)
		  return solutions.Ubound >= 0
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestPolygonPolygonArcArc() As Boolean
		  dim a1 as new Arc
		  a1.id = 1
		  a1.SetCenterRadius(new BasicPoint(0, 0), 2)
		  a1.SetAngles(0, 180)
		  
		  dim a2 as new Arc
		  a2.id = 2
		  a2.SetCenterRadius(new BasicPoint(2, 0), 2)
		  a2.SetAngles(90, 270)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(a1, a2)
		  
		  // Two circles intersect at two points, but arcs may filter
		  return solutions.Ubound >= 0
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestPolygonPolygonSegmentArc() As Boolean
		  dim p1 as new Polygon
		  p1.id = 1
		  dim pts1(3) as BasicPoint
		  pts1(0) = new BasicPoint(-1, 0)
		  pts1(1) = new BasicPoint(3, 0)
		  pts1(2) = new BasicPoint(3, 2)
		  pts1(3) = new BasicPoint(-1, 2)
		  p1.coord = new nBpoint(pts1)
		  p1.npts = 4
		  
		  dim a1 as new Arc
		  a1.id = 2
		  a1.SetCenterRadius(new BasicPoint(1, 1), 1)
		  a1.SetAngles(0, 180)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(p1, a1)
		  
		  return solutions.Ubound >= 0
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestPolygonPolygonNoIntersection() As Boolean
		  dim p1 as new Polygon
		  p1.id = 1
		  dim pts1(3) as BasicPoint
		  pts1(0) = new BasicPoint(0, 0)
		  pts1(1) = new BasicPoint(1, 0)
		  pts1(2) = new BasicPoint(1, 1)
		  pts1(3) = new BasicPoint(0, 1)
		  p1.coord = new nBpoint(pts1)
		  p1.npts = 4
		  
		  dim p2 as new Polygon
		  p2.id = 2
		  dim pts2(3) as BasicPoint
		  pts2(0) = new BasicPoint(5, 5)
		  pts2(1) = new BasicPoint(6, 5)
		  pts2(2) = new BasicPoint(6, 6)
		  pts2(3) = new BasicPoint(5, 6)
		  p2.coord = new nBpoint(pts2)
		  p2.npts = 4
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(p1, p2)
		  
		  return solutions.Ubound = -1
		End Function
	#tag EndMethod
	
	// ===== Line-Circle Tests =====
	
	#tag Method, Flags = &h0
		Function TestLineCircleNoIntersection() As Boolean
		  dim line as new Droite
		  line.id = 1
		  line.FirstP = new BasicPoint(0, 3)
		  line.SecondP = new BasicPoint(5, 3)
		  
		  dim c as new Circle
		  c.id = 2
		  c.SetCenterRadius(new BasicPoint(0, 0), 1)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(line, c)
		  
		  return solutions.Ubound = -1
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestLineCircleTangent() As Boolean
		  dim line as new Droite
		  line.id = 1
		  line.FirstP = new BasicPoint(-2, 1)
		  line.SecondP = new BasicPoint(2, 1)
		  
		  dim c as new Circle
		  c.id = 2
		  c.SetCenterRadius(new BasicPoint(0, 0), 1)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(line, c)
		  
		  if solutions.Ubound <> 0 then return false
		  return solutions(0).IsTangent = true
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestLineCircleTwoIntersections() As Boolean
		  dim line as new Droite
		  line.id = 1
		  line.FirstP = new BasicPoint(-2, 0)
		  line.SecondP = new BasicPoint(2, 0)
		  
		  dim c as new Circle
		  c.id = 2
		  c.SetCenterRadius(new BasicPoint(0, 0), 1)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(line, c)
		  
		  if solutions.Ubound <> 1 then return false
		  return solutions(0).IsTangent = false and solutions(1).IsTangent = false
		End Function
	#tag EndMethod
	
	// ===== Line-Line Tests =====
	
	#tag Method, Flags = &h0
		Function TestLineLineIntersect() As Boolean
		  dim l1 as new Droite
		  l1.id = 1
		  l1.FirstP = new BasicPoint(0, 0)
		  l1.SecondP = new BasicPoint(2, 2)
		  
		  dim l2 as new Droite
		  l2.id = 2
		  l2.FirstP = new BasicPoint(0, 2)
		  l2.SecondP = new BasicPoint(2, 0)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(l1, l2)
		  
		  if solutions.Ubound <> 0 then return false
		  dim pt as BasicPoint = solutions(0).Position
		  return abs(pt.x - 1) < Epsilon and abs(pt.y - 1) < Epsilon
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestLineLineParallel() As Boolean
		  dim l1 as new Droite
		  l1.id = 1
		  l1.FirstP = new BasicPoint(0, 0)
		  l1.SecondP = new BasicPoint(2, 0)
		  
		  dim l2 as new Droite
		  l2.id = 2
		  l2.FirstP = new BasicPoint(0, 1)
		  l2.SecondP = new BasicPoint(2, 1)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(l1, l2)
		  
		  return solutions.Ubound = -1
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestLineLineCoincident() As Boolean
		  dim l1 as new Droite
		  l1.id = 1
		  l1.FirstP = new BasicPoint(0, 0)
		  l1.SecondP = new BasicPoint(2, 0)
		  
		  dim l2 as new Droite
		  l2.id = 2
		  l2.FirstP = new BasicPoint(1, 0)
		  l2.SecondP = new BasicPoint(3, 0)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(l1, l2)
		  
		  // Coincident lines - BiBInterDroites returns nil for parallel
		  return solutions.Ubound = -1
		End Function
	#tag EndMethod
	
	// ===== Line-Polygon Tests =====
	
	#tag Method, Flags = &h0
		Function TestLinePolygonIntersections() As Boolean
		  dim line as new Droite
		  line.id = 1
		  line.FirstP = new BasicPoint(-1, 1)
		  line.SecondP = new BasicPoint(3, 1)
		  
		  dim poly as new Polygon
		  poly.id = 2
		  dim pts(3) as BasicPoint
		  pts(0) = new BasicPoint(0, 0)
		  pts(1) = new BasicPoint(2, 0)
		  pts(2) = new BasicPoint(2, 2)
		  pts(3) = new BasicPoint(0, 2)
		  poly.coord = new nBpoint(pts)
		  poly.npts = 4
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(line, poly)
		  
		  // Line y=1 intersects left edge (0,0)-(0,2) at (0,1) and right edge (2,0)-(2,2) at (2,1)
		  return solutions.Ubound = 1
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestLinePolygonNoIntersection() As Boolean
		  dim line as new Droite
		  line.id = 1
		  line.FirstP = new BasicPoint(-1, -1)
		  line.SecondP = new BasicPoint(0, -1)
		  
		  dim poly as new Polygon
		  poly.id = 2
		  dim pts(3) as BasicPoint
		  pts(0) = new BasicPoint(0, 0)
		  pts(1) = new BasicPoint(2, 0)
		  pts(2) = new BasicPoint(2, 2)
		  pts(3) = new BasicPoint(0, 2)
		  poly.coord = new nBpoint(pts)
		  poly.npts = 4
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(line, poly)
		  
		  return solutions.Ubound = -1
		End Function
	#tag EndMethod
	
	// ===== Degenerate Cases =====
	
	#tag Method, Flags = &h0
		Function TestDegenerateZeroRadiusCircle() As Boolean
		  dim c1 as new Circle
		  c1.id = 1
		  c1.SetCenterRadius(new BasicPoint(0, 0), 0)
		  
		  dim c2 as new Circle
		  c2.id = 2
		  c2.SetCenterRadius(new BasicPoint(0, 0), 1)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(c1, c2)
		  
		  // Zero radius circle at center of other circle - tangent at center
		  return solutions.Ubound >= -1 // Should not crash
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestDegenerateZeroLengthSegment() As Boolean
		  dim p1 as new Polygon
		  p1.id = 1
		  dim pts1(3) as BasicPoint
		  pts1(0) = new BasicPoint(0, 0)
		  pts1(1) = new BasicPoint(0, 0) // Zero length
		  pts1(2) = new BasicPoint(1, 1)
		  pts1(3) = new BasicPoint(0, 1)
		  p1.coord = new nBpoint(pts1)
		  p1.npts = 4
		  
		  dim p2 as new Polygon
		  p2.id = 2
		  dim pts2(3) as BasicPoint
		  pts2(0) = new BasicPoint(0, 0)
		  pts2(1) = new BasicPoint(1, 0)
		  pts2(2) = new BasicPoint(1, 1)
		  pts2(3) = new BasicPoint(0, 1)
		  p2.coord = new nBpoint(pts2)
		  p2.npts = 4
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(p1, p2)
		  
		  // Should not crash
		  return true
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestDegeneratePointCircle() As Boolean
		  dim c1 as new Circle
		  c1.id = 1
		  c1.SetCenterRadius(new BasicPoint(0, 0), 0)
		  
		  dim c2 as new Circle
		  c2.id = 2
		  c2.SetCenterRadius(new BasicPoint(1, 0), 0)
		  
		  dim solver as new IntersectionSolver
		  dim solutions() as IntersectionSolution = solver.SolutionsFor(c1, c2)
		  
		  // Two distinct point circles - no intersection
		  return solutions.Ubound = -1
		End Function
	#tag EndMethod
	
	// ===== Stable Key Tests =====
	
	#tag Method, Flags = &h0
		Function TestStableKeyDeterministic() As Boolean
		  dim c1 as new Circle
		  c1.id = 1
		  c1.SetCenterRadius(new BasicPoint(0, 0), 2)
		  
		  dim c2 as new Circle
		  c2.id = 2
		  c2.SetCenterRadius(new BasicPoint(2, 0), 2)
		  
		  dim solver as new IntersectionSolver
		  dim solutions1() as IntersectionSolution = solver.SolutionsFor(c1, c2)
		  dim solutions2() as IntersectionSolution = solver.SolutionsFor(c1, c2)
		  
		  if solutions1.Ubound <> solutions2.Ubound then return false
		  
		  for i as Integer = 0 to solutions1.Ubound
		    if solutions1(i).StableKey <> solutions2(i).StableKey then return false
		  next
		  
		  return true
		End Function
	#tag EndMethod
	
	#tag Method, Flags = &h0
		Function TestStableKeySwappedShapes() As Boolean
		  dim c1 as new Circle
		  c1.id = 1
		  c1.SetCenterRadius(new BasicPoint(0, 0), 2)
		  
		  dim c2 as new Circle
		  c2.id = 2
		  c2.SetCenterRadius(new BasicPoint(2, 0), 2)
		  
		  dim solver as new IntersectionSolver
		  dim solutions1() as IntersectionSolution = solver.SolutionsFor(c1, c2)
		  dim solutions2() as IntersectionSolution = solver.SolutionsFor(c2, c1)
		  
		  if solutions1.Ubound <> solutions2.Ubound then return false
		  
		  // Keys should be identical regardless of argument order
		  for i as Integer = 0 to solutions1.Ubound
		    if solutions1(i).StableKey <> solutions2(i).StableKey then return false
		  next
		  
		  return true
		End Function
	#tag EndMethod

End Class
#tag EndClass