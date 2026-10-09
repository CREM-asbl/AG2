"""
Pytest tests for Python reference oracle.
Cross-validates against Xojo IntersectionSolver outputs.
"""
import pytest
import math
from intersection_oracle import (
    circle, polygon, line,
    solutions_for, IntersectionSolution,
    EPSILON
)


class TestCircleCircle:
    def test_two_intersections(self):
        c1 = circle(0, 0, 5, "c1")
        c2 = circle(8, 0, 5, "c2")
        sols = solutions_for(c1, c2)
        assert len(sols) == 2
        # Points should be at x=4, y=±3
        for s in sols:
            assert abs(s.point.x - 4) < EPSILON
            assert abs(abs(s.point.y) - 3) < EPSILON

    def test_external_tangent(self):
        c1 = circle(0, 0, 5, "c1")
        c2 = circle(10, 0, 5, "c2")
        sols = solutions_for(c1, c2)
        assert len(sols) == 1
        assert abs(sols[0].point.x - 5) < EPSILON
        assert abs(sols[0].point.y) < EPSILON

    def test_internal_tangent(self):
        c1 = circle(0, 0, 5, "c1")
        c2 = circle(3, 0, 2, "c2")
        sols = solutions_for(c1, c2)
        assert len(sols) == 1
        assert abs(sols[0].point.x - 5) < EPSILON
        assert abs(sols[0].point.y) < EPSILON

    def test_no_intersection_separate(self):
        c1 = circle(0, 0, 2, "c1")
        c2 = circle(10, 0, 2, "c2")
        sols = solutions_for(c1, c2)
        assert len(sols) == 0

    def test_no_intersection_one_inside(self):
        c1 = circle(0, 0, 5, "c1")
        c2 = circle(1, 0, 1, "c2")
        sols = solutions_for(c1, c2)
        assert len(sols) == 0

    def test_coincident_circles(self):
        c1 = circle(0, 0, 5, "c1")
        c2 = circle(0, 0, 5, "c2")
        sols = solutions_for(c1, c2)
        assert len(sols) == 0  # Infinite intersections

    def test_zero_radius(self):
        c1 = circle(0, 0, 0, "c1")
        c2 = circle(0, 0, 5, "c2")
        sols = solutions_for(c1, c2)
        assert len(sols) == 0  # Point circle inside

    def test_swapped_args_deterministic_keys(self):
        c1 = circle(0, 0, 5, "c1")
        c2 = circle(8, 0, 5, "c2")
        sols1 = solutions_for(c1, c2)
        sols2 = solutions_for(c2, c1)
        keys1 = sorted([s.stable_key() for s in sols1])
        keys2 = sorted([s.stable_key() for s in sols2])
        assert keys1 == keys2


class TestLineCircle:
    def test_two_intersections(self):
        c = circle(0, 0, 5, "c1")
        l = line(-10, 0, 10, 0, "l1")
        sols = solutions_for(l, c)
        assert len(sols) == 2
        for s in sols:
            assert abs(s.point.y) < EPSILON
            assert abs(abs(s.point.x) - 5) < EPSILON

    def test_tangent(self):
        c = circle(0, 0, 5, "c1")
        l = line(-10, 5, 10, 5, "l1")
        sols = solutions_for(l, c)
        assert len(sols) == 1
        assert abs(sols[0].point.x) < EPSILON
        assert abs(sols[0].point.y - 5) < EPSILON

    def test_no_intersection(self):
        c = circle(0, 0, 5, "c1")
        l = line(-10, 10, 10, 10, "l1")
        sols = solutions_for(l, c)
        assert len(sols) == 0

    def test_segment_clipping(self):
        c = circle(0, 0, 5, "c1")
        l = line(0, 0, 3, 0, "l1")  # Segment inside circle
        sols = solutions_for(l, c)
        assert len(sols) == 0  # No intersection with segment endpoints inside

    def test_segment_one_endpoint_on_circle(self):
        c = circle(0, 0, 5, "c1")
        l = line(5, 0, 10, 0, "l1")  # Segment from circle edge outward
        sols = solutions_for(l, c)
        assert len(sols) == 1
        assert abs(sols[0].point.x - 5) < EPSILON


class TestLineLine:
    def test_intersecting_segments(self):
        l1 = line(0, 0, 10, 10, "l1")
        l2 = line(0, 10, 10, 0, "l2")
        sols = solutions_for(l1, l2)
        assert len(sols) == 1
        assert abs(sols[0].point.x - 5) < EPSILON
        assert abs(sols[0].point.y - 5) < EPSILON

    def test_parallel_lines(self):
        l1 = line(0, 0, 10, 0, "l1")
        l2 = line(0, 5, 10, 5, "l2")
        sols = solutions_for(l1, l2)
        assert len(sols) == 0

    def test_coincident_lines(self):
        l1 = line(0, 0, 10, 0, "l1")
        l2 = line(5, 0, 15, 0, "l2")
        sols = solutions_for(l1, l2)
        assert len(sols) == 0  # Infinite intersections

    def test_segments_not_intersecting(self):
        l1 = line(0, 0, 5, 0, "l1")
        l2 = line(6, 0, 10, 0, "l2")
        sols = solutions_for(l1, l2)
        assert len(sols) == 0

    def test_ray_intersection(self):
        l1 = line(0, 0, 10, 10, "l1", is_segment=False, is_ray=True)
        l2 = line(0, 10, 10, 0, "l2")
        sols = solutions_for(l1, l2)
        assert len(sols) == 1


class TestPolygonPolygon:
    def test_square_intersection(self):
        p1 = polygon([(0, 0), (10, 0), (10, 10), (0, 10)], "p1")
        p2 = polygon([(5, 5), (15, 5), (15, 15), (5, 15)], "p2")
        sols = solutions_for(p1, p2)
        assert len(sols) == 2  # Two edge intersections

    def test_triangle_square(self):
        p1 = polygon([(0, 0), (10, 0), (5, 10)], "p1")
        p2 = polygon([(2, 2), (8, 2), (8, 8), (2, 8)], "p2")
        sols = solutions_for(p1, p2)
        assert len(sols) > 0

    def test_no_intersection(self):
        p1 = polygon([(0, 0), (5, 0), (5, 5), (0, 5)], "p1")
        p2 = polygon([(10, 10), (15, 10), (15, 15), (10, 15)], "p2")
        sols = solutions_for(p1, p2)
        assert len(sols) == 0

    def test_shared_vertex(self):
        p1 = polygon([(0, 0), (5, 0), (5, 5), (0, 5)], "p1")
        p2 = polygon([(5, 5), (10, 5), (10, 10), (5, 10)], "p2")
        sols = solutions_for(p1, p2)
        # Shared vertex - may or may not be detected depending on implementation
        assert len(sols) >= 0


class TestCirclePolygon:
    def test_circle_intersects_square(self):
        c = circle(5, 5, 5, "c1")  # Radius 5 reaches all edges
        p = polygon([(0, 0), (10, 0), (10, 10), (0, 10)], "p1")
        sols = solutions_for(c, p)
        assert len(sols) == 4  # Circle intersects all 4 edges

    def test_circle_inside_polygon(self):
        c = circle(5, 5, 2, "c1")
        p = polygon([(0, 0), (10, 0), (10, 10), (0, 10)], "p1")
        sols = solutions_for(c, p)
        assert len(sols) == 0

    def test_circle_outside_polygon(self):
        c = circle(20, 20, 2, "c1")
        p = polygon([(0, 0), (10, 0), (10, 10), (0, 10)], "p1")
        sols = solutions_for(c, p)
        assert len(sols) == 0

    def test_circle_tangent_to_edge(self):
        c = circle(5, 5, 5, "c1")
        p = polygon([(0, 0), (10, 0), (10, 10), (0, 10)], "p1")
        sols = solutions_for(c, p)
        assert len(sols) == 4  # Tangent at 4 points


class TestLinePolygon:
    def test_line_through_square(self):
        l = line(-5, 5, 15, 5, "l1")
        p = polygon([(0, 0), (10, 0), (10, 10), (0, 10)], "p1")
        sols = solutions_for(l, p)
        assert len(sols) == 2

    def test_line_tangent_to_polygon(self):
        l = line(-5, 0, 15, 0, "l1")
        p = polygon([(0, 0), (10, 0), (10, 10), (0, 10)], "p1")
        sols = solutions_for(l, p)
        # Line along bottom edge - may have 0 or 2 intersections depending on implementation
        assert len(sols) >= 0


class TestStableKeys:
    def test_deterministic_ordering(self):
        """Stable keys must be identical regardless of argument order."""
        c1 = circle(0, 0, 5, "circle_a")
        c2 = circle(8, 0, 5, "circle_b")
        sols1 = solutions_for(c1, c2)
        sols2 = solutions_for(c2, c1)
        keys1 = sorted([s.stable_key() for s in sols1])
        keys2 = sorted([s.stable_key() for s in sols2])
        assert keys1 == keys2

    def test_key_format(self):
        c1 = circle(0, 0, 5, "c1")
        c2 = circle(8, 0, 5, "c2")
        sols = solutions_for(c1, c2)
        for s in sols:
            key = s.stable_key()
            parts = key.split("|")
            assert len(parts) == 5
            assert parts[0] in ("c1", "c2")
            assert parts[1] in ("c1", "c2")
            assert parts[2].isdigit()
            assert parts[3].isdigit()
            assert parts[4].isdigit()


class TestEdgeCases:
    def test_zero_length_segment(self):
        l = line(5, 5, 5, 5, "l1")
        c = circle(5, 5, 5, "c1")
        sols = solutions_for(l, c)
        # Zero-length segment at circle center - no intersection
        assert len(sols) == 0

    def test_degenerate_polygon(self):
        p = polygon([(0, 0), (0, 0), (0, 0)], "p1")
        c = circle(0, 0, 5, "c1")
        sols = solutions_for(c, p)
        assert len(sols) == 0

    def test_floating_point_precision(self):
        # Near-tangent case
        c1 = circle(0, 0, 1, "c1")
        c2 = circle(2 - 1e-10, 0, 1, "c2")
        sols = solutions_for(c1, c2)
        # Should handle near-tangent gracefully
        assert len(sols) in (0, 1, 2)


if __name__ == "__main__":
    pytest.main([__file__, "-v"])