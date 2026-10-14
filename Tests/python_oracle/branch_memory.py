"""
Branch-memory overlay for intersection point re-placement.

Models the Intersec slot-assignment logic (nearest/replacerphase2) with
StableKey-based continuity. Pure geometry stays in intersection_oracle.py;
this module only decides which computed solution a tracked point binds to,
to stop point inversion/migration between branches.
"""
from dataclasses import dataclass, field
from typing import List, Optional, Tuple

from intersection_oracle import IntersectionSolution, Point

EPSILON = 1e-12


@dataclass
class TrackedPoint:
    """A construction point bound to an intersection branch."""
    point: Point
    stable_key: str = ""
    valid: bool = True


def _swap_pairs(sols: List[IntersectionSolution],
                tracked: List[TrackedPoint]) -> List[Tuple[float, int, int]]:
    """All (distance, tracked_idx, sol_idx) candidate pairs."""
    pairs = []
    for ti, t in enumerate(tracked):
        for si, s in enumerate(sols):
            pairs.append((t.point.distance_to(s.point), ti, si))
    return pairs


def assign_branches(
    sols: List[IntersectionSolution],
    tracked: List[TrackedPoint],
    magnetic_dist: float = float("inf"),
) -> List[Optional[int]]:
    """Bind each tracked point to a solution slot.

    Strategy:
      1. Stable-key pass: a tracked point whose remembered key matches a
         solution keeps that branch, regardless of distance (prevents
         migration when a nearer but different branch appears).
      2. Nearest pass: unbound points take the nearest free solution within
         magnetic_dist (legacy Intersec.nearest behaviour).

    Returns a list `out` where out[ti] = sol index, or None if unplaced.
    Each solution is bound to at most one tracked point.
    """
    n = len(tracked)
    out: List[Optional[int]] = [None] * n
    sol_taken = [False] * len(sols)

    # Pass 1 — stable-key memory
    for ti, t in enumerate(tracked):
        if not t.stable_key:
            continue
        for si, s in enumerate(sols):
            if sol_taken[si]:
                continue
            if s.stable_key() == t.stable_key:
                out[ti] = si
                sol_taken[si] = True
                break

    # Pass 2 — nearest free slot for the rest
    pairs = sorted(_swap_pairs(sols, tracked))
    for dist, ti, si in pairs:
        if out[ti] is not None:
            continue
        if sol_taken[si]:
            continue
        if dist > magnetic_dist:
            continue
        out[ti] = si
        sol_taken[si] = True

    return out


def update_tracked(
    sols: List[IntersectionSolution],
    tracked: List[TrackedPoint],
    magnetic_dist: float = float("inf"),
) -> List[TrackedPoint]:
    """Apply assign_branches: move tracked points onto bound solutions,
    refresh their stable keys, invalidate unplaced points."""
    out: List[Optional[int]] = assign_branches(sols, tracked, magnetic_dist)
    result: List[TrackedPoint] = []
    for ti, t in enumerate(tracked):
        si = out[ti]
        if si is None:
            result.append(TrackedPoint(t.point, t.stable_key, valid=False))
        else:
            s = sols[si]
            result.append(TrackedPoint(s.point, s.stable_key(), valid=True))
    return result
