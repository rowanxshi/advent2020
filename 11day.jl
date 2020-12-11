function process(filepath)
	rows = 0
	columns = 0
	floor = Set{Int}()
	
	for line in eachline(filepath)
		columns = length(line)
		break
	end
	for line in eachline(filepath)
		union!(floor, rows*columns .+ findall(isequal('.'), line))
		rows += 1
	end
	
	return (floor, rows, columns)
end

function simulate(adjacencies, seatmap, empty_rule::Int = 4, noisy::Bool = false)
	(floor, rows, columns) = seatmap
	filled = Set{Int}()
	to_fill = Set{Int}()
	to_empty = Set{Int}()
	done = false
	iter = 0
	while !done
		iter += 1
		noisy && println("iter $iter")
		empty!(to_fill)
		empty!(to_empty)
		
		done = true
		for place in 1:(rows*columns)
			place in floor && continue
			if place in filled
				if count(seat -> in(seat, filled), adjacencies[place]) >= empty_rule
					push!(to_empty, place)
					done = false
				end
			else
				if count(seat -> in(seat, filled), adjacencies[place]) == 0
					push!(to_fill, place)
					done = false
				end
			end
		end
		done && break
		
		union!(setdiff!(filled, to_empty), to_fill)
	end
	
	return filled
end

function part1(seatmap)
	(floor, rows, columns) = seatmap
	adjacents = Set{Int}()
	adjacencies = Dict{Int}{Set{Int}}()
	for r in 1:rows, c in 1:columns
		place = (r-1)*columns+c
		place in floor && continue
		
		empty!(adjacents)
		if c < columns
			push!(adjacents, place+1)
			r > 1 && union!(adjacents, (place-columns):(place-columns+1))
			r < rows && union!(adjacents, (place+columns):(place+columns+1))
		end
		if c > 1
			push!(adjacents, place-1)
			r > 1 && union!(adjacents, (place-columns-1):(place-columns))
			r < rows && union!(adjacents, (place+columns-1):(place+columns))
		end
		setdiff!(adjacents, floor)
		push!(adjacencies, place => copy(adjacents))
	end
	
	filled = simulate(adjacencies, seatmap)
	return length(filled)
end

function part2(seatmap)
	(floor, rows, columns) = seatmap
	adjacents = Set{Int}()
	adjacencies = Dict{Int}{Set{Int}}()
	for r in 1:rows, c in 1:columns
		place = (r-1)*columns + c
		place in floor && continue
		
		empty!(adjacents)
		
		max_e = columns-c
		max_w = c-1
		max_n = r-1
		max_s = rows-r
		
		for look_n in (place-columns):(-columns):0
			if !(look_n in floor)
				push!(adjacents, look_n)
				break
			end
		end
		for look_s in (place+columns):columns:(columns*rows)
			if !(look_s in floor)
				push!(adjacents, look_s)
				break
			end
		end
		for look_e in (place+1):(place + max_e)
			if !(look_e in floor)
				push!(adjacents, look_e)
				break
			end
		end
		for look_w in (place-1):-1:(place-max_w)
			if !(look_w in floor)
				push!(adjacents, look_w)
				break
			end
		end
		for steps_nw in 1:min(max_w, max_n)
			look = place + steps_nw*(-1 - columns)
			if !(look in floor)
				push!(adjacents, look)
				break
			end
		end
		for steps_ne in 1:min(max_e, max_n)
			look = place + steps_ne*(1-columns)
			if !(look in floor)
				push!(adjacents, look)
				break
			end
		end
		for steps_sw in 1:min(max_w, max_s)
			look = place + steps_sw*(-1 + columns)
			if !(look in floor)
				push!(adjacents, look)
				break
			end
		end
		for steps_se in 1:min(max_e, max_s)
			look = place + steps_se*(1+columns)
			if !(look in floor)
				push!(adjacents, look)
				break
			end
		end
		setdiff!(adjacents, floor)
		push!(adjacencies, place => copy(adjacents))
	end
	println("adjacency map filled")
	
	filled = simulate(adjacencies, seatmap, 5)
	return length(filled)
end

function solve(filepath="11day.txt")
	seatmap = process(filepath)
	part1(seatmap)
	part2(seatmap)
end
