max_calorie = 0
cur_cal = 0

for line in eachline("input.txt")
    line = strip(line)
    if length(line) == 0
        global max_calorie = max(cur_cal, max_calorie)
        global cur_cal = 0
    else
        global cur_cal += parse(Float32, line)
    end
end

max_calorie = max(cur_cal, max_calorie)
println(max_calorie)

# Second Part

cur_cal = 0
top_cal = zeros(3)

function update_calorie!(cur_cal, top_cal)
    if cur_cal > top_cal[1]
        top_cal[1] = cur_cal
        if top_cal[1] > top_cal[2]
            top_cal[1], top_cal[2] = top_cal[2], top_cal[1]
            if top_cal[2] > top_cal[3]
                top_cal[2], top_cal[3] = top_cal[3], top_cal[2]
            end
        end
    end
end

for line in eachline("input.txt")
    line = strip(line)
    if length(line) == 0
        update_calorie!(cur_cal, top_cal)
        global cur_cal = 0
    else
        global cur_cal += parse(Float32, line)
    end
end

update_calorie!(cur_cal, top_cal)

for cal in top_cal
    println(cal)
end
println(sum(top_cal))
