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
