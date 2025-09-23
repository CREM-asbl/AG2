#tag Module
Protected Module OperationHelpers
	#tag Method, Flags = &h0
		Function IsPointValidForModification(p as point) As Boolean
		  Dim i, j As Integer
		  Dim sh As shape

		  if p = nil or p.fig = nil then
		    if p <> nil and p.id = 17 then
		      System.DebugLog "Point M (Id=17) invalid: p.fig = nil"
		    end if
		    return false
		  end if

		  p.mobility

		  if p.liberte = 0 or (p.fused and p.constructedby.shape = nil) then
		    if p.id = 17 then
		      System.DebugLog "Point M (Id=17) invalid: liberte=" + str(p.liberte) + ", fused=" + str(p.fused)
		    end if
		    return false
		  end if

		  if p.forme = 1 and p.constructedby <> nil and p.constructedby.oper = 10 and point(p.constructedby.shape).isextremityofaparaperpseg then
		    if p.id = 17 then
		      System.DebugLog "Point M (Id=17) invalid: extremity of paraperpseg"
		    end if
		    return false
		  end if

		  if p.forme = 1 and p.isextremityofaparaperpseg then
		    if p.id = 17 then
		      System.DebugLog "Point M (Id=17) invalid: is extremity of paraperpseg"
		    end if
		    return false
		  end if

		  for i = 0 to ubound(p.parents)
		    sh = p.parents(i)
		    if (sh isa arc) then
		      if (sh.getindexpoint(p) = 2) and (p.pointsur.count = 1) and not (p.pointsur.item(0) isa circle and (p.pointsur.item(0).getindex(sh.points(0)) = 0)) then
		        return false
		      end if
		    end if
		    for j = 0 to ubound(p.parents)
		      if i <> j and (sh.constructedby <> nil and (sh.constructedby.oper = 3 or sh.constructedby.oper = 5) and sh.constructedby.shape = p.parents(j)) then
		        return false
		      end if
		    next
		  next

		  if p.id = 17 then
		    System.DebugLog "Point M (Id=17) is VALID for modification"
		  end if
		  return true
		End Function
	#tag EndMethod
	#tag Method, Flags = &h0
		Sub FilterVisibleByChoixValide(ByRef visible as ObjectsList, op as SelectOperation)
		  dim i as integer
		  dim s as shape
		  if visible = nil or op = nil then
		    return
		  end if
		  for i = visible.count-1 downto 0
		    s = visible.item(i)
		    if not op.Choixvalide(s) then
		      visible.removeobject(s)
		    end if
		  next
		End Sub
	#tag EndMethod
	#tag Method, Flags = &h0
		Function ComputeAnimationDeltaForShape(s as shape) As BasicPoint
		  dim dep as BasicPoint
		  if s = nil then
		    return new BasicPoint(0,0)
		  end if
		  if s isa droite and droite(s).nextre = 0 then
		    dep = droite(s).extre2 - droite(s).extre1
		  else
		    if ubound(s.points) >= 1 then
		      dep = s.points(1).bpt - s.points(0).bpt
		    else
		      dep = new BasicPoint(1,0)
		    end if
		  end if
		  return dep
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnsureArcMovableIfNeeded(s as point)
		  dim i as integer
		  dim a as arc
		  dim M as Matrix
		  if s = nil then
		    return
		  end if
		  for i = 0 to ubound(s.parents)
		    if s.parents(i) isa arc then
		      a = arc(s.parents(i))
		      if a.getindex(s) = 2 and a.arcangle < PI/180 and s.modified = false then
		        M = new rotationmatrix(a.coord.tab(0), PI/90)
		        s.moveto M*s.bpt
		      end if
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FilterVisiblePoints(ByRef visible as ObjectsList)
		  dim i as integer
		  dim s as point
		  if visible = nil then
		    return
		  end if
		  for i = visible.count-1 downto 0
		    s = Point(Visible.item(i))
		    if not IsPointValidForModification(s) then
		      visible.removeobject(s)
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrepareParentPointers(s as point, ByRef tableau() as integer)
		  dim i as integer
		  if s = nil then
		    return
		  end if
		  for i = 0 to s.parents.count-1
		    if not s.parents(i).pointe then
		      tableau.append i
		      s.parents(i).pointe = true
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetParentPointers(s as point, ByRef tableau() as integer)
		  dim i as integer
		  if s = nil then
		    return
		  end if
		  for i = 0 to s.parents.count-1
		    if tableau.indexof(i) <> -1 then
		      s.parents(i).pointe = false
		    end if
		  next
		End Sub
	#tag EndMethod
End Module
#tag EndModule