defmodule Line.Point do
	@enforce_keys [:x, :y]
  defstruct [:x, :y]

  def manhattan_distance(p1, p2) do
  	x1 = Map.fetch!(p1, :x)
  	y1 = Map.fetch!(p1, :y)

  	x2 = Map.fetch!(p2, :x)
  	y2 = Map.fetch!(p2, :y)
  	abs((x1 - x2)) + abs((y1 - y2))
  end

  def colinear?(a, b, c) do
  	ax = Map.fetch!(a, :x)
  	ay = Map.fetch!(a, :y)
  	bx = Map.fetch!(b, :x)
  	by = Map.fetch!(b, :y)
  	cx = Map.fetch!(c, :x)
  	cy = Map.fetch!(c, :y)

  	cp = (cy - ay) * (bx - ax) - (cx - ax) * (by - ay)
  	cp != 0
  end

  def dotproduct(a, b, c) do
  	ax = Map.fetch!(a, :x)
  	ay = Map.fetch!(a, :y)
  	bx = Map.fetch!(b, :x)
  	by = Map.fetch!(b, :y)
  	cx = Map.fetch!(c, :x)
  	cy = Map.fetch!(c, :y)

  	(cx - ax) * (bx - ax) + (cy - ay) * (by - ay)
  end

  def squaredLength(a, b) do
  	ax = Map.fetch!(a, :x)
  	ay = Map.fetch!(a, :y)
  	bx = Map.fetch!(b, :x)
  	by = Map.fetch!(b, :y)

  	(bx - ax) * (bx - ax) + (by - ay) * (by - ay)
  end
end


defmodule Line do
	@enforce_keys [:point1, :point2]
  defstruct [:point1, :point2, :value]

  @doc """

  ## Examples
    iex> l = %Line{point1: %Line.Point{x: 0, y: 7}, point1: %Line.Point{x: 6, y: 7}}
  	iex> Line.contains?(l, %Line.Point{x: 3, 7})
  	true
  	iex> Line.contains?(l, %Line.Point{x: 10, 7})
  	false
  	iex> Line.contains?(l, %Line.Point{x: 5, y: 4})
  	false
  """
  def contains?(line, point) do
  	a = Map.fetch!(line, :point1)
  	b = Map.fetch!(line, :point2)

  	if Line.Point.colinear?(a, b, point) do
  		false
  	else
  		dp = Line.Point.dotproduct(a, b, point)
  		sl = Line.Point.squaredLength(a, b)

  		if dp < 0 or dp > sl do
  			false
  		else
  			true
  		end
  	end
  end
  
  def intersect?(line1, line2) do
  	p1 = Map.fetch!(line1, :point1)
  	p2 = Map.fetch!(line1, :point2)

  	p3 = Map.fetch!(line2, :point1)
  	p4 = Map.fetch!(line2, :point2)

  	x1 = Map.fetch!(p1, :x)
  	y1 = Map.fetch!(p1, :y)
  	x2 = Map.fetch!(p2, :x)
  	y2 = Map.fetch!(p2, :y)

  	x3 = Map.fetch!(p3, :x)
  	y3 = Map.fetch!(p3, :y)
  	x4 = Map.fetch!(p4, :x)
  	y4 = Map.fetch!(p4, :y) 

  	tDenominator(x1, x2, x3, x4, y1, y2, y3, y4) != 0
	end

	def intersection(line1, line2) do
		unless intersect?(line1, line2) do
			{:none, %{}}
		else
			p1 = Map.fetch!(line1, :point1)
	  	p2 = Map.fetch!(line1, :point2)

	  	p3 = Map.fetch!(line2, :point1)
	  	p4 = Map.fetch!(line2, :point2)

	  	x1 = Map.fetch!(p1, :x)
	  	y1 = Map.fetch!(p1, :y)
	  	x2 = Map.fetch!(p2, :x)
	  	y2 = Map.fetch!(p2, :y)

	  	x3 = Map.fetch!(p3, :x)
	  	y3 = Map.fetch!(p3, :y)
	  	x4 = Map.fetch!(p4, :x)
	  	y4 = Map.fetch!(p4, :y)

	  	t = calcT(x1, x2, x3, x4, y1, y2, y3, y4)
	  	u = calcU(x1, x2, x3, x4, y1, y2, y3, y4)

	  	res =
		  	cond do
		  		u <= 0.0 or u >= 1.0 or t <= 0.0 or t >= 1.0 ->
		  			%{}
		  		t >= 0.0 and t <= 1.0 ->
		  			tIntersection(x1, x2, y1, y2, t)
		  		u >= 0.0 and u <= 1.0 ->
		  			uIntersection(x3, x4, y3, y4, u)
		  		true ->
		  			%{}
		  	end
	  	{:ok, res}
		end
	end

	@doc """

	## Examples
		iex> l = %Line{point1: %Line.Point{x: 6,7}, %Line.Point{x: 6, y: 3}}
		iex> Line.distance_to_point(l, %Line.Point{6,5})
		2
		iex> l = %Line{point1: %Line.Point{x: 6,3}, %Line.Point{x: 6, y: 7}}
		iex> Line.distance_to_point(l, %Line.Point{6,5})
		4
	"""
	def distance_to_point(line, point) do
		p1 = Map.fetch!(line, :point1)
  	p2 = Map.fetch!(line, :point2)

  	x1 = abs(Map.fetch!(p1, :x))
  	y1 = abs(Map.fetch!(p1, :y))
  	x2 = abs(Map.fetch!(point, :x))
  	y2 = abs(Map.fetch!(point, :y))

  	cond do
  		x2 > x1 -> x2 - x1
  		x2 < x1 -> x1 - x2
  		y2 > y1 -> y2 - y1
  		y2 < y1 -> y1 - y2
  		true -> 0
  	end
	end

	defp tIntersection(x1, x2, y1, y2, t) do
		%Line.Point{x: intersectX(x1, x2, t),
								y: intersectY(y1, y2, t)}
	end

	defp uIntersection(x3, x4, y3, y4, u) do
		%Line.Point{x: intersectX(x3, x4, u),
								y: intersectY(y3, y4, u)}
	end

	defp calcT(x1, x2, x3, x4, y1, y2, y3, y4) do
		num = tNumerator(x1, x3, x4, y1, y3, y4)
		denom = tDenominator(x1, x2, x3, x4, y1, y2, y3, y4)
		num / denom
	end

	defp tNumerator(x1, x3, x4, y1, y3, y4) do
		(x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)
	end

	defp tDenominator(x1, x2, x3, x4, y1, y2, y3, y4) do
		(x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
	end

	defp calcU(x1, x2, x3, x4, y1, y2, y3, y4) do
		num = uNumerator(x1, x2, x3, y1, y2, y3)
		denom = uDenominator(x1, x2, x3, x4, y1, y2, y3, y4)
		(num / denom) * -1
	end

	defp uNumerator(x1, x2, x3, y1, y2, y3) do
		(x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)
	end

	defp uDenominator(x1, x2, x3, x4, y1, y2, y3, y4) do
		(x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
	end

	defp px(x1, x2, x3, x4, y1, y2, y3, y4) do
		nu = (x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)
		dn = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
		nu / dn
	end

	defp py(x1, x2, x3, x4, y1, y2, y3, y4) do
		nu = (x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)
		dn = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
		nu / dn
	end

	defp intersectX(x1, x2, t) do
		x1 + (t * (x2 - x1))
	end

	defp intersectY(y1, y2, t) do
		y1 + (t * (y2 - y1))
	end
end
