
function detect_packet_marker(line)
    L = length(line)
    i, j = 1, 4
    while j <= L
        marker = Set(line[i:j])
        if length(marker) == 4
            return j
        end
        i += 1
        j += 1
    end
end

function detect_message_marker(line)
    K = 14
    marker = Dict{Char, Int}()
    for ch in line[1:K]
        marker[ch] = get!(marker, ch, 0) + 1
    end
    if length(marker) == K
        return K
    end

    L = length(line)
    i, j = 1, K
    while j <= L
        j += 1
        marker[line[j]] = get!(marker, line[j], 0) + 1
        marker[line[i]] -= 1
        if marker[line[i]] == 0
            pop!(marker, line[i])
        end
        i += 1

        if length(marker) == K
            return j
        end
    end
end

function main(input)
    for line in eachline(input)
        # println(detect_packet_marker(line))
        println(detect_message_marker(line))
    end
end

main(ARGS[1])
