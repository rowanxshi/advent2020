function process(filepath)
	groups = split(read(filepath, String), "\n\n")
	map(groups) do group
		replace(group, r"\n$" => "")
	end
end

function part1(groups)
	mapreduce(+, groups) do group
		group = replace(group, "\n" => "")
		length(unique(group))
	end
end

function part2(groups)
	mapreduce(+, groups) do group
		people = split(group, r"[\n]+")
		length(intersect(people...))
	end
end

function solve()
	groups = process("6day.txt")
	part1(groups) |> println
	part2(groups) |> println
end

#~ for letter in 'a':'z'
#~ 	regex = "((?!$letter)[a-z\n])*[$letter]+[a-z\n]*?\n\n"
#~ 	eachmatch(Regex(regex), test) |> collect |> length |> println
#~ end
