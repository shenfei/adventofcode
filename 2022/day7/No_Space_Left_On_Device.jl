# https://adventofcode.com/2022/day/7

mutable struct Dir
    path::Vector{String}
    sub_dirs::Set{String}
    dir_size::Int
    has_extended::Bool

    function Dir(cur_dir::Dir, sub_dir::AbstractString)
        path = deepcopy(cur_dir.path)
        push!(path, sub_dir)
        new(path, Set{String}(), 0, false)
    end

    Dir() = new([""], Set{String}(), 0, false)
end

get_path(dir::Dir) = join(dir.path, "/")
get_parent_path(dir::Dir) = join(dir.path[1:end-1], "/")

is_cmd = startswith('$')


function total_dir_within_size(dir_map::Dict{String, Dir}, limit::Int)
    total = 0
    stack = [dir_map[""]]
    while !isempty(stack)
        if stack[end].has_extended
            dir = pop!(stack)
            size = dir.dir_size
            if size <= limit
                total += size
            end
            cur_path = get_path(dir)
            if cur_path != ""
                dir_map[get_parent_path(dir)].dir_size += size
            end
            # println(cur_path, '\t', dir.dir_size)
        else
            dir = stack[end]
            if !isempty(dir.sub_dirs)
                for sub_dir in dir.sub_dirs
                    target_path = join([get_path(dir), sub_dir], "/")
                    push!(stack, dir_map[target_path])
                end
            end
            dir.has_extended = true
        end
    end

    return total
end


function change_dir!(dir_map::Dict{String, Dir}, cur_dir::Dir, cmd::String)
    cmd = lstrip(cmd, ['$', ' '])
    if cmd == "ls"
        return cur_dir
    end
    cd, sub_dir = split(cmd)
    if sub_dir == ".."
        cur_dir = dir_map[get_parent_path(cur_dir)]
    elseif sub_dir == "/"
        cur_dir = dir_map[""]
    else
        target_path = join([get_path(cur_dir), sub_dir], "/")
        cur_dir = get!(dir_map, target_path, Dir(cur_dir, sub_dir))
        dir_map[target_path] = cur_dir
    end
    return cur_dir
end


function find_min_to_del(dir_map::Dict{String, Dir})
    size_cap = 70000000
    min_unused = 30000000
    del_bar = dir_map[""].dir_size - (size_cap - min_unused)
    @assert del_bar > 0 "No need to delete directory!"

    return minimum([v.dir_size for (k, v) in dir_map if v.dir_size >= del_bar])
end


function main(input)
    dir_map = Dict{String, Dir}("" => Dir())

    fin = open(input)
    line = readline(fin)
    @assert line == "\$ cd /"
    cur_dir = dir_map[""]

    while !eof(fin)
        line = readline(fin)
        if is_cmd(line)
            cur_dir = change_dir!(dir_map, cur_dir, line)
        else
            first, name = split(line)
            if first == "dir"
                push!(cur_dir.sub_dirs, name)
            else
                cur_dir.dir_size += parse(Int, first)
            end
        end
    end
    close(fin)

    result = total_dir_within_size(dir_map, 100000)
    println(result)
    # tmp = sort([x for x in values(dir_map)], by=x -> x.dir_size)
    # for x in tmp
    #     println(get_path(x), '\t', x.dir_size)
    # end
    println("Minimum to del: ", find_min_to_del(dir_map))
end

main(ARGS[1])
