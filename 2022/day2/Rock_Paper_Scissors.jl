# A for Rock, B for Paper, and C for Scissors
# X for Rock, Y for Paper, and Z for Scissors

shape = Dict([
    ("A", 1), ("B", 2), ("C", 3),
    ("X", 1), ("Y", 2), ("Z", 3),
])

win_check = Dict([
    (1, 1) => 3, (2, 2) => 3, (3, 3) => 3,
    (1, 2) => 6, (2, 3) => 6, (3, 1) => 6,
    (2, 1) => 0, (3, 2) => 0, (1, 3) => 0,
])


calc_score(x, y) = win_check[(shape[x], shape[y])] + shape[y]
total = 0

for line in eachline("input.txt")
    x, y = split(strip(line))
    global total += calc_score(x, y)
end

println(total)


# Part 2

gain = [0, 3, 6]

strategies = Dict([
    1 => (3, 1, 2),
    2 => (1, 2, 3),
    3 => (2, 3, 1),
])

function calc_score2(x, y)
    result = shape[y]
    strategies[shape[x]][result] + gain[result]
end

total = 0

for line in eachline("input.txt")
    x, y = split(strip(line))
    global total += calc_score2(x, y)
end

println(total)

