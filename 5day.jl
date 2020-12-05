function process(filepath)
	seats = @inbounds map(eachline(filepath)) do seat
		seat = replace(seat, r"B|R" => 1)
		seat = replace(seat, r"F|L" => 0)
		(parse(Int, seat[1:7], base = 2), parse(Int, seat[8:end], base = 2))
	end
	sort!(seats)
end

seatid(seat) = seat[1]*8 + seat[2]

function part1(seats)
	seatid(seats[end])
end

function part2(seats)
	@inbounds for i in 2:(length(seats)-1)
		id = seatid(seats[i])
		(id == seatid(seats[i-1]) + 2) && return (id - 1)
	end
end

process("5day.txt")
