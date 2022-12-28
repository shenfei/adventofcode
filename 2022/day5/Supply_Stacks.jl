

function get_crate_stack(init_status::Vector{String})::Vector{Vector{String}}
    n_col = parse(Int, split(init_status[end])[end])
    stack = [Vector{String}() for i in 1:n_col]
    for i in length(init_status) - 1 : -1 : 1
        line = init_status[i]
        if line[2] != ' '
            push!(stack[1], SubString(line, 2, 2))
        end
        for j in 2:n_col
            k = (j - 1) * 4 + 2
            substr = SubString(line, k, k)
            if substr != " "
                push!(stack[j], substr)
            end
        end
    end
    return stack
end

function crane_move!(stack::Vector{Vector{String}}, move::String)
    match_res = match(r"move (\d+) from (\d+) to (\d+)", move)
    n, from, to = match_res.captures .|> (x) -> parse(Int, x)
    L = length(stack[from])
    # append!(stack[to], reverse(stack[from][L - n + 1:L]))
    append!(stack[to], stack[from][L - n + 1:L])
    deleteat!(stack[from], L - n + 1:L)
end

function show_stack(stack)
    for x in stack
        print(length(x), ' ')
        for v in x
            print(v, ' ')
        end
        println()
    end
end


function main(input, keep_order=false)
    init_status = Vector{String}()
    fin = open(input)
    while true
        line = readline(fin)
        if length(line) == 0
            break
        else
            push!(init_status, line)
        end
    end

    crate_stack = get_crate_stack(init_status)
    # show_stack(crate_stack)

    while !eof(fin)
        move_instruction = readline(fin)
        crane_move!(crate_stack, move_instruction)
        # println(move_instruction)
        # show_stack(crate_stack)
    end
    close(fin)

    top_crate = join([stack[end] for stack in crate_stack])
    println(top_crate)
end

main(ARGS[1])
