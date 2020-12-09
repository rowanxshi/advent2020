struct code
	op::Symbol
	num::Int
end

function (c::code)(acc, line)
	c.op == :nop && return (acc, line+1)
	c.op == :acc && return (acc + c.num, line+1)
	return (acc, line + c.num)
end

function process(filepath)
	map(eachline(filepath)) do line
		(op, num) = match(r"\b(\w+)\b ([-+\d]+)", line).captures
		code(Symbol(op), parse(Int, num))
	end
end

function execute(program)
	acc = 0
	line = 1
	executed = falses(length(program))
	
	@inbounds while 1==1
		(line > length(program)) && return (acc, false)
		(executed[line] == true) && return (acc, true)
		executed[line] = true
		(acc, line) = program[line](acc, line)
	end
end

function part2(program)
	for line in 2:(length(program)-1)
		program[line].op == :acc && continue
		if program[line].op == :jmp
			(acc, isloop) = execute([program[1:line-1]; code(:nop, program[line].num); program[line+1:end]])
		else
			(acc, isloop) = execute([program[1:line-1]; code(:acc, program[line].num); program[line+1:end]])
		end
		isloop && continue
		return acc
	end
end

function solve(filepath)
	program = process(filepath)
	(part1, _) = execute(program)
	part2(program)
end

