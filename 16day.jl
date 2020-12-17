function process(filepath)
	(rules, mine, others) = split(readchomp(filepath), "\n\n")
	rules = split(rules, "\n")
	others = split(others, "\n")
	
	rules = map(rules) do rule
		eachmatch(r"(\d+)-(\d+)", rule)
	end
	
	mine = eachmatch(r"\b\d+?\b", mine)
	others = @views map(others[2:end]) do ticket
		eachmatch(r"\b\d+?\b", ticket)
	end
	
	(rules, mine, others)
end
function part1((rules, mine, others))
	ok_ranges = Set{typeof(1:3)}()
	@inbounds for rule in rules
		for range in rule
			push!(ok_ranges, (:)(parse(Int, range.captures[1]), parse(Int, range.captures[2])))
		end
	end
	sum(others) do ticket
		sum(ticket) do field
			value = parse(Int, field.match)
			return any(range -> in(value, range), ok_ranges) ? 0 : value
		end
	end
end
function part2((rules, mine, others))
	ok_ranges = Dict{Symbol}{Set{typeof(1:3)}}()
	for rule in rules
		field_name = Symbol(match(r"([\w ]+):", rule.string).captures[1])
		ok_ranges[field_name] = Set{typeof(1:3)}()
		for range in rule
			push!(ok_ranges[field_name], mapreduce(num -> parse(Int, num), (:), range.captures))
		end
	end
	ok_ranges
	
	field_types = Vector{Set{Symbol}}(undef, length(keys(ok_ranges)))
	for i in eachindex(field_types)
		field_types[i] = Set(keys(ok_ranges))
	end
	(field_types, ok_ranges)
	
	all_ranges = reduce(union, values(ok_ranges))
	filter!(others) do ticket
		for value_str in ticket
			value = parse(Int, value_str.match)
			all(range -> !in(value, range), all_ranges) && return false
		end
		true
	end
	
	for ticket in others
		for (field_no, value_str) in enumerate(ticket)
			value = parse(Int, value_str.match)
			ruled_out = (filter(field -> !any(range -> (value in range), ok_ranges[field]) , field_types[field_no]))
			filter!(field_types[field_no]) do field
				any(range -> (value in range), ok_ranges[field])
			end
		end
	end
	
	i_elims = sortperm(length.(field_types))
	for (i, i_elim) in enumerate(i_elims)
		for j in @views(i_elims[i+1:end])
			setdiff!(field_types[j], field_types[i_elim])
		end
	end
	field_types = String.(first.(field_types))
	
	prod(enumerate(mine)) do (field_no, value)
		!occursin("departure", field_types[field_no]) && return 1
		parse(Int, value.match)
	end
end

function solve(filepath = "16day_test2.txt")
	(rules, mine, others) = process(filepath)
	part1((rules, mine, others)) |> println
	part2((rules, mine, others)) |> println
end
solve("16day.txt")
