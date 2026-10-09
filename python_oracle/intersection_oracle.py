"""
Python reference oracle for IntersectionSolver.
Implements the same geometric algorithms in pure Python for cross-validation.
"""
import math
from dataclasses import dataclass
from typing import List, Tuple, Optional
from enum import Enum


EPSILON = 1e-12


class ShapeType(Enum):
    CIRCLE = "circle"
    POLYGON = "polygon"
    LINE = "line"


@dataclass
class Point:
    x: float
    y: float

    def __eq__(self, other):
        if not isinstance(other, Point):
            return False
        return abs(self.x - other.x) < EPSILON and abs(self.y - other.y) < EPSILON

    def __hash__(self):
        return hash((round(self.x / EPSILON) * EPSILON, round(self.y / EPSILON) * EPSILON))

    def distance_to(self, other: 'Point') -> float:
        return math.hypot(self.x - other.x, self.y - other.y)


@dataclass
class Circle:
    center: Point
    radius: float
    shape_id: str = ""

    def __post_init__(self):
        if not self.shape_id:
            self.shape_id = f"circle_{id(self)}"


@dataclass
class Polygon:
    vertices: List[Point]
    shape_id: str = ""
    closed: bool = True

    def __post_init__(self):
        if not self.shape_id:
            self.shape_id = f"polygon_{id(self)}"

    def edges(self) -> List[Tuple[Point, Point]]:
        edges = []
        n = len(self.vertices)
        if n < 2:
            return edges
        for i in range(n - 1):
            edges.append((self.vertices[i], self.vertices[i + 1]))
        if self.closed and n > 2:
            edges.append((self.vertices[-1], self.vertices[0]))
        return edges


@dataclass
class Line:
    p1: Point
    p2: Point
    shape_id: str = ""
    is_segment: bool = True
    is_ray: bool = False

    def __post_init__(self):
        if not self.shape_id:
            self.shape_id = f"line_{id(self)}"


@dataclass
class IntersectionSolution:
    point: Point
    shape1_id: str
    shape2_id: str
    side1: int
    side2: int
    solution_index: int

    def stable_key(self) -> str:
        """Deterministic key for branch continuity."""
        # Sort shape IDs for deterministic ordering
        id1, id2 = sorted([self.shape1_id, self.shape2_id])
        # Also sort sides to match
        if self.shape1_id <= self.shape2_id:
            s1, s2 = self.side1, self.side2
        else:
            s1, s2 = self.side2, self.side1
        return f"{id1}|{id2}|{s1}|{s2}|{self.solution_index}"


def solve_circle_circle(c1: Circle, c2: Circle) -> List[IntersectionSolution]:
    """Circle-circle intersection."""
    solutions = []
    d = c1.center.distance_to(c2.center)

    if d > c1.radius + c2.radius + EPSILON:
        return solutions  # Separate
    if d < abs(c1.radius - c2.radius) - EPSILON:
        return solutions  # One inside other
    if d < EPSILON and abs(c1.radius - c2.radius) < EPSILON:
        return solutions  # Coincident - infinite intersections

    # Tangent or two intersections
    a = (c1.radius**2 - c2.radius**2 + d**2) / (2 * d) if d > EPSILON else 0
    h_sq = c1.radius**2 - a**2

    if h_sq < -EPSILON:
        return solutions

    # Base point
    px = c1.center.x + a * (c2.center.x - c1.center.x) / d if d > EPSILON else c1.center.x
    py = c1.center.y + a * (c2.center.y - c1.center.y) / d if d > EPSILON else c1.center.y

    if h_sq < EPSILON:
        # Tangent
        solutions.append(IntersectionSolution(
            point=Point(px, py),
            shape1_id=c1.shape_id, shape2_id=c2.shape_id,
            side1=0, side2=0, solution_index=0
        ))
    else:
        h = math.sqrt(h_sq)
        rx = -(c2.center.y - c1.center.y) * (h / d) if d > EPSILON else 0
        ry = (c2.center.x - c1.center.x) * (h / d) if d > EPSILON else 0

        solutions.append(IntersectionSolution(
            point=Point(px + rx, py + ry),
            shape1_id=c1.shape_id, shape2_id=c2.shape_id,
            side1=0, side2=0, solution_index=0
        ))
        solutions.append(IntersectionSolution(
            point=Point(px - rx, py - ry),
            shape1_id=c1.shape_id, shape2_id=c2.shape_id,
            side1=0, side2=0, solution_index=1
        ))

    return solutions


def point_on_segment(p: Point, a: Point, b: Point) -> bool:
    """Check if point p lies on segment ab."""
    cross = (p.y - a.y) * (b.x - a.x) - (p.x - a.x) * (b.y - a.y)
    if abs(cross) > EPSILON:
        return False
    dot = (p.x - a.x) * (b.x - a.x) + (p.y - a.y) * (b.y - a.y)
    if dot < -EPSILON:
        return False
    sq_len = (b.x - a.x)**2 + (b.y - a.y)**2
    if dot > sq_len + EPSILON:
        return False
    return True


def solve_line_circle(line: Line, circle: Circle) -> List[IntersectionSolution]:
    """Line-circle intersection."""
    solutions = []

    # Line: p1 + t*(p2-p1)
    dx = line.p2.x - line.p1.x
    dy = line.p2.y - line.p1.y

    # Handle zero-length segment
    a = dx*dx + dy*dy
    if a < EPSILON:
        # Zero-length segment - check if endpoint is on circle
        dist = line.p1.distance_to(circle.center)
        if abs(dist - circle.radius) < EPSILON:
            solutions.append(IntersectionSolution(
                point=Point(line.p1.x, line.p1.y),
                shape1_id=line.shape_id, shape2_id=circle.shape_id,
                side1=0, side2=0, solution_index=0
            ))
        return solutions

    # Quadratic: (dx^2 + dy^2)t^2 + 2(dx*(p1.x-cx) + dy*(p1.y-cy))t + (p1-c)^2 - r^2 = 0
    fx = line.p1.x - circle.center.x
    fy = line.p1.y - circle.center.y

    b = 2 * (dx*fx + dy*fy)
    c = fx*fx + fy*fy - circle.radius*circle.radius

    disc = b*b - 4*a*c

    if disc < -EPSILON:
        return solutions

    if disc < EPSILON:
        disc = 0

    sqrt_disc = math.sqrt(disc)
    t1 = (-b + sqrt_disc) / (2*a)
    t2 = (-b - sqrt_disc) / (2*a)

    for idx, t in enumerate([t1, t2]):
        if disc < EPSILON and idx == 1:
            continue  # Tangent - only one solution

        px = line.p1.x + t * dx
        py = line.p1.y + t * dy
        pt = Point(px, py)

        if line.is_segment and not point_on_segment(pt, line.p1, line.p2):
            continue
        if line.is_ray and t < -EPSILON:
            continue

        solutions.append(IntersectionSolution(
            point=pt,
            shape1_id=line.shape_id, shape2_id=circle.shape_id,
            side1=0, side2=0, solution_index=len(solutions)
        ))

    return solutions


def solve_line_line(line1: Line, line2: Line) -> List[IntersectionSolution]:
    """Line-line intersection."""
    solutions = []

    x1, y1 = line1.p1.x, line1.p1.y
    x2, y2 = line1.p2.x, line1.p2.y
    x3, y3 = line2.p1.x, line2.p1.y
    x4, y4 = line2.p2.x, line2.p2.y

    denom = (x1 - x2)*(y3 - y4) - (y1 - y2)*(x3 - x4)

    if abs(denom) < EPSILON:
        return solutions  # Parallel or coincident

    t = ((x1 - x3)*(y3 - y4) - (y1 - y3)*(x3 - x4)) / denom
    u = -((x1 - x2)*(y1 - y3) - (y1 - y2)*(x1 - x3)) / denom

    px = x1 + t*(x2 - x1)
    py = y1 + t*(y2 - y1)
    pt = Point(px, py)

    # Check segment/ray constraints
    if line1.is_segment and not point_on_segment(pt, line1.p1, line1.p2):
        return solutions
    if line1.is_ray and t < -EPSILON:
        return solutions
    if line2.is_segment and not point_on_segment(pt, line2.p1, line2.p2):
        return solutions
    if line2.is_ray and u < -EPSILON:
        return solutions

    solutions.append(IntersectionSolution(
        point=pt,
        shape1_id=line1.shape_id, shape2_id=line2.shape_id,
        side1=0, side2=0, solution_index=0
    ))

    return solutions


def solve_polygon_polygon(poly1: Polygon, poly2: Polygon) -> List[IntersectionSolution]:
    """Polygon-polygon intersection (edge-edge)."""
    solutions = []
    edges1 = poly1.edges()
    edges2 = poly2.edges()

    for i, (a1, b1) in enumerate(edges1):
        for j, (a2, b2) in enumerate(edges2):
            line1 = Line(a1, b1, shape_id=poly1.shape_id, is_segment=True)
            line2 = Line(a2, b2, shape_id=poly2.shape_id, is_segment=True)
            sols = solve_line_line(line1, line2)
            for s in sols:
                s.side1 = i
                s.side2 = j
                s.solution_index = len(solutions)
                solutions.append(s)

    return solutions


def solve_circle_polygon(circle: Circle, poly: Polygon) -> List[IntersectionSolution]:
    """Circle-polygon intersection."""
    solutions = []
    edges = poly.edges()

    for i, (a, b) in enumerate(edges):
        line = Line(a, b, shape_id=poly.shape_id, is_segment=True)
        sols = solve_line_circle(line, circle)
        for s in sols:
            s.side1 = 0
            s.side2 = i
            s.solution_index = len(solutions)
            solutions.append(s)

    return solutions


def solve_line_polygon(line: Line, poly: Polygon) -> List[IntersectionSolution]:
    """Line-polygon intersection."""
    solutions = []
    edges = poly.edges()

    for i, (a, b) in enumerate(edges):
        edge_line = Line(a, b, shape_id=poly.shape_id, is_segment=True)
        sols = solve_line_line(line, edge_line)
        for s in sols:
            s.side1 = 0
            s.side2 = i
            s.solution_index = len(solutions)
            solutions.append(s)

    return solutions


def solutions_for(shape1, shape2) -> List[IntersectionSolution]:
    """Main dispatch function matching IntersectionSolver.SolutionsFor()."""
    if isinstance(shape1, Circle) and isinstance(shape2, Circle):
        return solve_circle_circle(shape1, shape2)
    elif isinstance(shape1, Circle) and isinstance(shape2, Polygon):
        return solve_circle_polygon(shape1, shape2)
    elif isinstance(shape2, Circle) and isinstance(shape1, Polygon):
        return solve_circle_polygon(shape2, shape1)
    elif isinstance(shape1, Polygon) and isinstance(shape2, Polygon):
        return solve_polygon_polygon(shape1, shape2)
    elif isinstance(shape1, Line) and isinstance(shape2, Circle):
        return solve_line_circle(shape1, shape2)
    elif isinstance(shape2, Line) and isinstance(shape1, Circle):
        return solve_line_circle(shape2, shape1)
    elif isinstance(shape1, Line) and isinstance(shape2, Line):
        return solve_line_line(shape1, shape2)
    elif isinstance(shape1, Line) and isinstance(shape2, Polygon):
        return solve_line_polygon(shape1, shape2)
    elif isinstance(shape2, Line) and isinstance(shape1, Polygon):
        return solve_line_polygon(shape2, shape1)

    return []


# Convenience functions for tests
def circle(x: float, y: float, r: float, shape_id: str = "") -> Circle:
    return Circle(Point(x, y), r, shape_id)


def polygon(vertices: List[Tuple[float, float]], shape_id: str = "", closed: bool = True) -> Polygon:
    return Polygon([Point(x, y) for x, y in vertices], shape_id, closed)


def line(x1: float, y1: float, x2: float, y2: float, shape_id: str = "", is_segment: bool = True, is_ray: bool = False) -> Line:
    return Line(Point(x1, y1), Point(x2, y2), shape_id, is_segment, is_ray)