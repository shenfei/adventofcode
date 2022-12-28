total = 0

function get_priority(char::Char)
    base_char, base_value = islowercase(char) ? ('a', 1) : ('A', 27)
    return Int(codepoint(char)) - Int(codepoint(base_char)) + base_value
end

for line in eachline(ARGS[1])
    L = length(line) ÷ 2
    res = intersect(line[1:L], line[L + 1:end])
    for char in res
        global total += get_priority(char)
    end
end

println(total)


# Part 2

total = 0

open(ARGS[1]) do fin
    while !eof(fin)
        rucksacks = Vector{String}(undef, 3)
        for i in 1:3
            global rucksacks[i] = readline(fin)
        end
        res = reduce(intersect, rucksacks)
        for char in res
            global total += get_priority(char)
        end
    end
end

println("Part 2:")
println(total)

