module vectorized
input = open("2day.txt") do file
	read(file, String)
end

input = replace(input, ": " => ",")
input = replace(input, " " => ",")
input = replace(input, "-" => ",")

open("2day_clean.txt","w") do file
	write(file, input)
end

import DelimitedFiles
input = DelimitedFiles.readdlm("2day_clean.txt",',')

function part1()
	count_times(string, letter) = length(findall(string, letter))
	counts = count_times.(input[:,3], input[:, 4])
	((counts .<= input[:,2]) .& (counts .>= input[:,1])) |> sum
end
part1()

function part2()
	check_match(col) = (string.(getindex.(input[:, 4], input[:, col])) .== input[:, 3])
	xor.(check_match(1), check_match(2)) |> sum
end
part2()
end

module loopdeloop
function read_in(filepath = "2day.txt")
	input = readlines(filepath)
	map(input) do line
		(i, j, letter, pw) = match(r"(\d+)-(\d+) (.): (.+)", line).captures
		parse.(Int, [i;j]), letter, pw
	end
end

function part1(input = read_in())
	count(input) do (num, letter, pw)
		num[1] <= count(letter, pw) <= num[2]
	end
end
part1() |> println

function part2(input = read_in())
	count(input) do (num, letter, pw)
		xor(pw[num[1]] == letter[1], pw[num[2]] == letter[1])
	end
end
part2() |> println
end
