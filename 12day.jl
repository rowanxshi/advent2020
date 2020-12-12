struct direction
	way::Symbol
	amt::Int
end

function (m::direction)((x, y, f), waypoint::Bool = false, (e, n) = (0, 0))
	if !waypoint
		m.way == :N && return (x, y+m.amt, f)
		m.way == :S && return (x, y-m.amt, f)
		m.way == :E && return (x+m.amt, y, f)
		m.way == :W && return (x-m.amt, y, f)
		m.way == :F && return (x+m.amt*cos(f), y+m.amt*sin(f), f)
		m.way == :R && return (x, y, f-(m.amt/180)*pi)
		m.way == :L && return (x, y, f+(m.amt/180)*pi)
	end
	
	m.way == :N && return ((x, y, f), (e, n+m.amt))
	m.way == :S && return ((x, y, f), (e, n-m.amt))
	m.way == :E && return ((x, y, f), (e+m.amt, n))
	m.way == :W && return ((x, y, f), (e-m.amt, n))
	m.way == :F && return ((x+m.amt*e, y+m.amt*n, f), (e, n))
	r = sqrt(e^2 + n^2)
	deg = atan(n/e) + (e > 0 ? 0 : pi) + (m.way == :L ? m.amt : -m.amt)*pi/180
	return ((x, y, f), (r*cos(deg), r*sin(deg)))
end

function process(filepath)
	holder = Vector{String}(undef, 2)
	map(eachline(filepath)) do line
		holder[:] = match(r"([A-Z]{1})(\d+)", line).captures
		direction(Symbol(holder[1]), parse(Int, holder[2]))
	end
end

function part1(moves)
	(x, y, f) = (0, 0, 0)
	for m in moves
		(x, y , f) =  m((x, y, f))
	end
	abs(x) + abs(y)
end

function part2(moves)
	(x, y, f) = (0, 0, 0)
	(e, n) = (10, 1)
	for m in moves
		((x, y, f), (e, n)) = m((x, y, f), true, (e, n))
	end
	abs(x) + abs(y)
end

function solve(filepath="12day_test.txt")
	moves = process(filepath)
	part1(moves)
	part2(moves)
end
solve()
