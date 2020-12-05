function process(filepath)
	input = split(read(filepath, String), "\n\n")
	map(input) do passport_raw
		passport = Dict()
		for field in eachmatch(r"(\w+):([#]?\w+)", passport_raw)
			passport[field.captures[1]] = field.captures[2]
		end
		passport
	end
end

function part1(passports, needed_fields)
	count(passports) do passport
		issubset(needed_fields, keys(passport))
	end
end

function solve(filepath = "5day.txt")
	passports = process(filepath)
	raw_fields = "byr (Birth Year)
	iyr (Issue Year)
	eyr (Expiration Year)
	hgt (Height)
	hcl (Hair Color)
	ecl (Eye Color)
	pid (Passport ID)
	cid (Country ID)"
	fields = [m.captures[1] for m in eachmatch(r"\b([a-z]{3}) ", raw_fields)]
	part1(passports, fields[1:end-1])
end

solve()
