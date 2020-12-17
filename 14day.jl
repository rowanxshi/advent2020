struct mask
	and
	or
	X
end

struct cmd
	mem
	num
end

function process(filepath)
	map(eachline(filepath)) do line
		if occursin("mask", line)
			mask_str = match(r"\b[X10]+\b", line).match
			and_mask = parse(Int, replace(mask_str, r"[^0]" => "1"), base=2)
			or_mask = parse(Int, replace(mask_str, r"[^1]" => "0"), base=2)
			X_mask = parse(Int, replace(replace(mask_str, r"[^X]" => "1"), "X" => "0"), base = 2)
			mask(and_mask, or_mask, X_mask)
		else
			(mem, num) = parse.(Int, getfield.(collect(eachmatch(r"\b\d+\b", line)), :match))
			cmd(mem, num)
		end
	end
end

function part1(program)
	memory = Dict{Int}{Int}()
	active_mask = program[1]
	@inbounds for line in program[2:end]
		if typeof(line) == mask
			active_mask = line
		else
			memory[line.mem] = (line.num & active_mask.and) | active_mask.or
		end
	end
	sum(values(memory))
end

function part2(program)
	memory = Dict{Int64}{Int64}()
	active_mask = program[findlast(line -> (typeof(line) == mask), program)]
	add_set = 36 .- findall(==('0'), bitstring(active_mask.X)[64-35:end])
	for i_line in length(program):-1:2
		line = program[i_line]
		if typeof(line) == mask
			active_mask = program[findprev(line -> (typeof(line)==mask), program, i_line-1)]
			add_set = 36 .- findall(==('0'), bitstring(active_mask.X)[64-35:end])
		else
			mem = ((line.mem | active_mask.or) & active_mask.X)
			for addresses in subsets(add_set)
				get!(memory, mem + mapreduce(position -> 2^position, +, addresses, init=0), line.num)
			end
		end
	end
	sum(values(memory))
end

using IterTools: subsets
function solve(filepath = "14day.txt")
	program = process(filepath)
	part1(program) |> println
	part2(program) 
	return program 
end
solve()
