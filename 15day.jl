function part1(seq, run = 2020)
	while length(seq) < run
		i_last = findprev(==(seq[end]), seq, length(seq)-1)
		push!(seq, i_last == nothing ? 0 : length(seq)-i_last)
	end
	seq
end

function part2(seq, run = 2020)
	recent = Dict{Int}{Int}()
	for i in eachindex(seq)
		push!(recent, seq[i] => i)
	end
	said = seq[end]
	@inbounds for turn in length(seq)+1:run
		say = haskey(recent, said) ? recent[said]-1 : 0
	end
	said
end

function solve(input)
	seq0 = parse.(Int, split(input, ","))
#~ 	part1(seq0) |> println
	part2(seq0)
#~ 	seq0
end

#~ solve("0,3,6")
solve("20,9,11,0,1,2")
