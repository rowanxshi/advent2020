function process(filepath)
	adaptors = map(eachline(filepath)) do adaptor
		parse(Int, adaptor)
	end
	sort!(adaptors)
	pushfirst!(adaptors, 0)
	push!(adaptors, adaptors[end]+3)
end

function part1(adaptors)
	jolt_diffs = diff(adaptors)
	*(count(==(1), jolt_diffs), count(==(3), jolt_diffs))
end

function part2(adaptors)
	paths_memory = Dict{Int}{Int}()
	socket = adaptors[end]
	function paths(adaptor)
		get!(paths_memory, adaptor) do
			adaptor == socket && return 1
			sum((adaptor+1):(adaptor+3)) do next_adaptor
				in(next_adaptor, adaptors) ? paths(next_adaptor) : 0
			end
		end
	end
	paths(0)
end

function part2_nomemo(adaptors)
#~ 	paths_memory = Dict{Int}{Int}()
	socket = adaptors[end]
	function paths(adaptor)
#~ 		get!(paths_memory, adaptor) do
			adaptor == socket && return 1
			sum((adaptor+1):(adaptor+3)) do next_adaptor
				in(next_adaptor, adaptors) ? paths(next_adaptor) : 0
			end
#~ 		end
	end
	paths(0)
end

function solve(filepath = "10day_test.txt")
	adaptors = process(filepath)
	part1(adaptors)
	part2(adaptors)
end
#~ solve("10day.txt")
