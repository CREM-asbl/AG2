"""
TDD tests for branch-memory overlay (Intersec re-placement model).

Cases: branch swap (inversion), key memory wins over nearest, tangency,
disappearing branch, coincident/absent solutions, floating-point noise.
"""
import math

import pytest

from intersection_oracle import Point, circle, line, polygon, solutions_for
from branch_memory import TrackedPoint, assign_branches, update_tracked

EPS = 1e-12


class TestBranchMemory:
    def test_swap_prevented_by_key(self):
        """Two branches swap positions; key memory keeps each point on its own."""
        c1 = circle(0, 0, 5, "c1")
        c2 = circle(8, 0, 5, "c2")
        sols = solutions_for(c1, c2)
        assert len(sols) == 2

        # Initial binding: tracked points sit exactly on both solutions
        tracked = [TrackedPoint(s.point, s.stable_key()) for s in sols]

        # Shape moves so computed solutions arrive in swapped order
        sols2 = list(reversed(sols))

        out = assign_branches(sols2, tracked)
        # Point 0 must still bind to the solution with its own key
        assert sols2[out[0]].stable_key() == tracked[0].stable_key
        assert sols2[out[1]].stable_key() == tracked[1].stable_key

    def test_key_memory_beats_nearer_foreign_branch(self):
        """A remembered key wins even if another solution is closer."""
        s1 = solutions_for(circle(0, 0, 5, "c1"), circle(8, 0, 5, "c2"))
        assert len(s1) == 2

        # Tracked point remembers branch of s1[0]
        t = TrackedPoint(s1[0].point, s1[0].stable_key())

        # Next frame: s1[0] moved far away, s1[1] now near the tracked point
        moved = [
            type(s1[0])(Point(s1[0].point.x + 100, s1[0].point.y),
                        s1[0].shape1_id, s1[0].shape2_id,
                        s1[0].side1, s1[0].side2, s1[0].solution_index),
            s1[1],
        ]
        out = assign_branches(moved, [t])
        # Must bind to its own branch (index 0), not the nearer one (index 1)
        assert out[0] == 0

    def test_nearest_when_no_key(self):
        s1 = solutions_for(circle(0, 0, 5, "c1"), circle(8, 0, 5, "c2"))
        assert len(s1) == 2
        # Untracked point near the second solution
        t = TrackedPoint(Point(s1[1].point.x + 0.1, s1[1].point.y), "")
        out = assign_branches(s1, [t])
        assert out[0] == 1

    def test_one_solution_each_two_points(self):
        """Tangent circle-circle yields one solution; second point unplaced."""
        s1 = solutions_for(circle(0, 0, 5, "c1"), circle(10, 0, 5, "c2"))
        assert len(s1) == 1
        t1 = TrackedPoint(s1[0].point, s1[0].stable_key())
        t2 = TrackedPoint(Point(50, 50), "ghost|key|0|0|1")
        out = assign_branches(s1, [t1, t2])
        assert out[0] == 0
        assert out[1] is None

    def test_update_tracked_moves_and_refreshes_keys(self):
        s1 = solutions_for(circle(0, 0, 5, "c1"), circle(8, 0, 5, "c2"))
        tracked = [TrackedPoint(s.point, s.stable_key()) for s in s1]

        # Circle 2 moves: new solutions
        s2 = solutions_for(circle(0, 0, 5, "c1"), circle(8.5, 0, 5, "c2"))
        assert len(s2) == 2

        updated = update_tracked(s2, tracked)
        assert all(u.valid for u in updated)
        # Points moved onto new solutions
        for u, s in zip(updated, [s2[i] for i in assign_branches(s2, tracked)]):
            assert u.point == s.point
            assert u.stable_key == s.stable_key()

    def test_update_tracked_invalidates_orphan(self):
        s1 = solutions_for(circle(0, 0, 5, "c1"), circle(8, 0, 5, "c2"))
        tracked = [TrackedPoint(s.point, s.stable_key()) for s in s1]
        # Circles separate: no solutions
        s2 = solutions_for(circle(0, 0, 5, "c1"), circle(20, 0, 5, "c2"))
        assert len(s2) == 0
        updated = update_tracked(s2, tracked)
        assert not any(u.valid for u in updated)

    def test_magnetic_dist_limits_nearest_pass(self):
        s1 = solutions_for(circle(0, 0, 5, "c1"), circle(8, 0, 5, "c2"))
        t = TrackedPoint(Point(s1[0].point.x + 5, s1[0].point.y), "")
        out = assign_branches(s1, [t], magnetic_dist=1.0)
        assert out[0] is None

    def test_key_memory_ignores_magnetic_dist(self):
        """Stable-key binding is not subject to magnetic distance."""
        s1 = solutions_for(circle(0, 0, 5, "c1"), circle(8, 0, 5, "c2"))
        t = TrackedPoint(Point(s1[0].point.x + 500, s1[0].point.y),
                         s1[0].stable_key())
        out = assign_branches(s1, [t], magnetic_dist=1.0)
        assert out[0] == 0

    def test_floating_noise_does_not_break_key(self):
        c1 = circle(0, 0, 5, "c1")
        c2 = circle(8, 0, 5, "c2")
        s1 = solutions_for(c1, c2)
        # Tiny jitter of input coordinates recomputes nearly identical solutions
        s2 = solutions_for(circle(0, 0, 5, "c1"), circle(8 + 1e-15, 0, 5, "c2"))
        assert len(s2) == 2
        tracked = [TrackedPoint(s.point, s.stable_key()) for s in s1]
        out = assign_branches(s2, tracked)
        # Key strings are index-based and stable under tiny input noise
        assert out[0] is not None and out[1] is not None
        assert out[0] != out[1]

    def test_line_branches_stay_distinct(self):
        """Polygon crossing two branches keeps each point on its own side."""
        p1 = polygon([(0, 0), (10, 0), (10, 10), (0, 10)], "p1")
        p2 = polygon([(5, -1), (5, 11)], "p2", closed=False)
        sols = solutions_for(p1, p2)
        assert len(sols) == 2
        tracked = [TrackedPoint(s.point, s.stable_key()) for s in sols]
        s_rev = list(reversed(sols))
        out = assign_branches(s_rev, tracked)
        assert s_rev[out[0]].stable_key() == tracked[0].stable_key
        assert s_rev[out[1]].stable_key() == tracked[1].stable_key
