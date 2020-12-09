function process(filepath)
	map(eachline(filepath)) do number
		parse(Int, number)
	end
end

validate(pool, target) = any(target .- pool) do partner
	in(partner, pool)
end
function part1(numbers, preamble)
	for i = (preamble+1):length(numbers)
		!validate(numbers[(i-preamble):(i-1)], numbers[i]) && return (numbers[i], i)
	end
end

function part2(numbers, target, i_target)
	max_long = cld(target, minimum(numbers))
	@inbounds for i_start in 1:(i_target-2)
		for long in 2:min(max_long, i_target-1-i_start)
			range = @views numbers[i_start:(i_start+long-1)]
			sum(range) == target && return minimum(range)+maximum(range)
		end
	end
end

function solve(filepath = "9day_test.txt", preamble = 5)
	numbers = process(filepath)
	(target, i_target) = part1(numbers, preamble)
	part2(numbers, target, i_target)
end
solve("9day.txt", 25)
