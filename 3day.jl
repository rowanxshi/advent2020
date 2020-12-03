function part1(right = 3, down = 1, input = readlines("3day.txt"))
	l = length(input)
	w = length(input[1])
	trees = 0
	step = 0
	
	@inbounds for i in 1:down:l
		step += 1
		input[i][1+mod(right*(step-1), w)] == '#' && (trees += 1)
	end
	trees
end

part1() |> println
mapreduce(part1, *, 1:2:7)*part1(1,2) |> println
