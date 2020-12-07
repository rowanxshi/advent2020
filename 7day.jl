function process(filepath)
	@inbounds map(eachline(filepath)) do line
		outer = match(r"(^[\w ]+?) bags", line).captures[1]
		within = Dict{String, Int}()
		occursin("no other bags", line) && return (outer, within)
		for match in eachmatch(r" (\d+) ([\w ]+) bags?(,|.)", line)
			within[match.captures[2]] = parse(Int, match.captures[1])
		end
		(outer, within)
	end
end

function find_outers(inners, rules)
	outers = Set{String}()
	for rule in rules
		!isempty(intersect(inners, keys(rule[2]))) && push!(outers, rule[1])
	end
	outers
end

function part1old(rules)
#~ 	initialise iteration
	checked = Set{String}()
	check = find_outers(Set(["shiny gold", ]), rules) 
	
	while !issubset(check, checked)
		push!(checked, check...)
		check = find_outers(setdiff(check, checked), rules)
	end
	
	length(checked)
end

function part1(rules)
	rules = Dict(rules)
	function cancontain(inner, outer)
		immediates = keys(rules[outer])
		in(inner, immediates) && return true
		any(immediates) do bag
			cancontain(inner, bag)
		end
	end
	sum(keys(rules)) do bag
		cancontain("shiny gold", bag)
	end
end

function part2(rules)
	rules = Dict(rules)
	function num_inner(outer)
		isempty(rules[outer]) && return 0
		sum(rules[outer]) do bag
			bag[2]*(1 + num_inner(bag[1]))
		end
	end
	num_inner("shiny gold")
end
