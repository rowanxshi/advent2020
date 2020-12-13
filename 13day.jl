function process(filepath)
	input = readlines(filepath)
	buses = Vector{Int}()
	places = similar(buses)
	place = 0
	for bus in eachmatch(r"\b[x\d]+?\b", input[2])
		if !isnothing(tryparse(Int, bus.match))
			push!(buses, parse(Int, bus.match))
			push!(places, place)
		end
		place += 1
	end
	(parse(Int, input[1]), buses, places)
end

function part1((arr, buses))
	wait = 0
	while 1==1
		for bus in buses
			if mod(arr+wait, bus) == 0
				println("bus!!!")
				return wait*bus
			end
		end
		wait += 1
	end
end

function part2((buses, places))
	Mods = Vector{AbstractMod}()
	for i in eachindex(buses)
		push!(Mods, Mod{buses[i]}(buses[i]-places[i]))
	end
	CRT(Mods...)
end

using Mods
function solve(filepath="13day_test.txt")
	d = process(filepath)
	part1(d[1:2])
	part2(d[2:3])
end
solve()
