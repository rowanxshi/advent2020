function process(filepath)
	input = split(read(filepath, String),"\n\n")
	map(input) do line
		getproperty.(eachmatch(r"(\S+):(\S+)", line), :captures)
	end
end

function enough_fields(passport)
	length(passport) < 7 && return false
	length(passport) == 8 && return true
	(count(passport) do field
		field[1] == "cid"
	end) > 0 && return false
	true
end

function part1(input)
	count(input) do passport
		enough_fields(passport)
	end
end

function part2(input)
	eye_colours = ["amb"; "blu"; "brn"; "gry"; "grn"; "hzl"; "oth"]
	sort!(eye_colours)
	count(input) do passport
		!enough_fields(passport) && return false
		sort!(passport, lt = (a,b) -> a[1] < b[1], rev = true)
		
		pid = passport[1][2]
		length(pid) != 9 && return false
		(tryparse(Int, pid) == nothing) && return false

		iyr = passport[2][2]
		length(iyr) != 4 && return false
		iyr = tryparse(Int, iyr)
		(iyr == nothing) && return false
		!(2010 <= iyr <= 2020) && return false
		
		hgt = passport[3][2]
		hgt_parsed = match(r"(\d+)(cm|in)", hgt)
		hgt_parsed == nothing && return false
		hgt_num = parse(Int, hgt_parsed.captures[1])
		if hgt_parsed.captures[2] == "cm"
			!(150 <= hgt_num <= 193) && return false
		end
		if hgt_parsed.captures[2] == "in"
			!(59 <= hgt_num <= 76) && return false
		end
		
		hcl = passport[4][2]
		length(hcl) != 7 && return false
		(match(r"#[A-fa-f0-9]{6}", hcl) == nothing) && return false
		
		eyr = passport[5][2]
		length(eyr) != 4 && return false
		eyr = tryparse(Int, eyr)
		(eyr == nothing) && return false
		!(2020 <= eyr <= 2030) && return false
		
		ecl = passport[6][2]
		!(ecl in eye_colours) && return false
		
		byr = passport[end][2]
		length(byr) != 4 && return false
		byr = tryparse(Int, byr)
		(byr == nothing) && return false
		!(1920 <= byr <= 2002) && return false
		
		true
	end
end

function solve(filepath="5day.txt")
	input = process(filepath)
	part1(input)
	part2(input)
end
solve("5day.txt")
