struct section
    left::Int
    right::Int

    function section(range::AbstractString)
        l, r = split(range, "-")
        new(parse(Int, l), parse(Int, r))
    end
end


within(x::section, y::section) = x.left >= y.left && x.right <= y.right
overlap(x::section, y::section) = x.right >= y.left && x.left <= y.right

function main(input)
    n_within = 0
    n_overlap = 0

    for line in eachline(input)
        range1, range2= split(line, ",")
        x = section(range1)
        y = section(range2)
        if within(x, y) || within(y, x)
            n_within += 1
        end
        if overlap(x, y)
            n_overlap += 1
        end
    end

    println(n_within)
    println(n_overlap)
end

main(ARGS[1])
