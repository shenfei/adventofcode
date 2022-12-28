# https://adventofcode.com/2022/day/8

function update_visible!(H::AbstractVector, V::AbstractVector{Bool})
    V[begin], V[end] = true, true
    L, R = firstindex(H), lastindex(H)
    cur_high = H[begin]
    for i in L + 1:R - 1
        if H[i] > cur_high
            V[i] = true
            cur_high = H[i]
        end
    end

    cur_high = H[end]
    for i in R-1:-1:L+1
        if H[i] > cur_high
            V[i] = true
            cur_high = H[i]
        end
    end
end


struct ViewDistance
    dist::Vector{Int}
    ViewDistance() = new(zeros(Int, 4))
end


function update_distance!(H::AbstractVector{Int}, D::AbstractVector{ViewDistance}, index::Int)
    L, R = firstindex(H), lastindex(H)
    # height can be only 0-9
    nearest_tree_idx = zeros(Int, 10)
    for k in 0:H[begin]
        nearest_tree_idx[k + 1] = L
    end
    for i in L + 1:R - 1
        j = nearest_tree_idx[H[i] + 1]
        D[i].dist[index] = j == 0 ? i - 1 : i - j
        for k in 0:H[i]
            nearest_tree_idx[k + 1] = i
        end
    end
end


function main(input)
    height = Vector{Vector{Int}}()

    fin = open(input)
    while !eof(fin)
        line = readline(fin)
        push!(height, [parse(Int, h) for h in line])
    end
    close(fin)

    # Part I
    height = reduce(hcat, height)  # Adjoint matrix doesn't change result
    M, N = size(height)
    visible = falses(M, N)

    @views for i in 2:M - 1
        update_visible!(height[i, :], visible[i, :])
    end
    @views for j in 2:N - 1
        update_visible!(height[:, j], visible[:, j])
    end
    # add 4 corners
    println(sum(visible) + 4)

    # Part II
    distance = reshape([ViewDistance() for _ in 1:M * N], (M, N))
    @views for i in 2:M - 1
        update_distance!(height[i, :], distance[i, :], 1)
        update_distance!(reverse(height[i, :]), reverse(distance[i, :]), 2)
    end
    @views for j in 2:N - 1
        update_distance!(height[:, j], distance[:, j], 3)
        update_distance!(reverse(height[:, j]), reverse(distance[:, j]), 4)
    end

    println(maximum(distance .|> (x) -> prod(x.dist)))
end

main(ARGS[1])
