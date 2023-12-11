using HorizonSideRobots
#r = Robot(animate = true)

#@enum HorizonSide Nord=0, West=1, Sud=2, Ost=3

#перемещает робота до упора в заданном направлении
function along!(robot, direct)::Nothing
    while !isborder(robot, direct)
        move!(robot, direct)
    end
end

#перемещает робота в заданном направлении до упора и возвращает число фактически сделанных им шагов
function num_steps_along!(robot, direct)::Int
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        num_steps += 1
    end
    return num_steps
end

#перемещает робота в заданном направлении на заданное число шагов (предполагается, что это возможно)
function along!(robot, direct, num_steps)::Nothing
    for _ in 1:num_steps
        move!(robot, direct)
    end
end

function mark_along_num!(robot, direct, num_steps)::Nothing
    for _ in 1:num_steps
        move!(robot, direct)
        putmarker!(robot)
    end
end

#делает попытку одного шага в заданном направлении и возвращает true, в случае, если это возможно,
#и false - в противном случае (робот остается в исходном положении)
function try_move!(robot, direct)::Bool
    if isborder(robot, direct)
        return false
    end
    move!(robot, direct)
    return true
end

#меняет направление на противоположное
inverse(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+2, 4))
#возвращает направление, следующее по часовой стрелке
right(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+1, 4))
#возвращает направление, следующее против часовой стрелки
left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)-1, 4))

#перемещает робота в заданном направлении до упора, после каждого шага ставя маркер, и возвращает число сделанных им шагов
function numsteps_mark_along!(robot, direct)::Int
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        putmarker!(robot)
        num_steps += 1
    end
    return num_steps
end

function mark_along!(robot, direct)::Nothing
    while !isborder(robot, direct)
        move!(robot, direct)
        putmarker!(robot)
    end
    return 
end

function mark_row!(robot, side)
    n=numsteps_mark_along!(robot,side)
    along!(robot,inverse(side),n)

    n=numsteps_mark_along!(robot,inverse(side))
    along!(robot,side,n)

    putmarker!(robot)
end
# переопределение базовых фунций для кортежа из двух направлений
HorizonSideRobots.move!(robot, side::NTuple{2,HorizonSide}) = for s in side move!(robot, s) end

HorizonSideRobots.isborder(robot, side::NTuple{2,HorizonSide}) = isborder(robot, side[1]) || isborder(robot, side[2])

inverse(direct::NTuple{2, HorizonSide}) = inverse.(direct)


function move_to_angle!(robot)
    return (side = Nord, num_steps = num_steps_along!(robot, Sud)),(side = Ost, num_steps = num_steps_along!(robot, West)),(side = Nord, num_steps = num_steps_along!(robot, Sud))
end

function move_to_back!(robot, back_path)
    for next in back_path
        along!(robot, next.side, next.num_steps)
    end
end

function find_internal_border!(robot)
    function find_in_row(side) # - это определение локальной вспомогательной функции
        while !isborder(robot, Nord) && !isborder(robot, side)
            move!(robot, side)
        end
    end
    side = Ost
    find_in_row(side)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        find_in_row(side)
    end
end

function move_to_internal_sudwest!(robot)
    while isborder(robot, Nord)
        move!(robot, West)
    end
end

function mark_external_rect!(robot)
    for side in (Ost, Nord, West, Sud)
        mark_along!(robot, side)
    end
end

function mark_internal_rect!(robot)
    for side in (Ost, Nord, West, Sud)
        mark_along!(robot, side, right(side))
    end
end

function mark_along!(robot, move_side, border_side)
    while true
        move!(robot, move_side)
        putmarker!(robot)
        if !isborder(robot, border_side)
            break
        end
    end
end

function move_to_angle_hard!(robot)
    back_path = []
    while true
        a = num_steps_along!(robot, Sud)
        if a != 0
            push!(back_path, (side = Nord, num_steps = a))
        end
        b = num_steps_along!(robot, West)
        if b != 0
            push!(back_path, (side = Ost, num_steps = b))
        end

        if a==0 && b==0
            break
        end
    end
    return reverse(back_path)
end

function move_to_angle_hard2!(robot)
    back_path = []
    sa=0
    sb=0
    while true
        a = num_steps_along!(robot, Sud)
        if a != 0
            push!(back_path, (side = Nord, num_steps = a))
            sa+=a
        end
        b = num_steps_along!(robot, West)
        if b != 0
            push!(back_path, (side = Ost, num_steps = b))
            sb+=b
        end

        if a==0 && b==0
            break
        end
    end
    return reverse(back_path), sa, sb
end


function find_pass!(robot, border_side)
    numsteps = 0
    bypass_side = left(border_side)
    while isborder(robot, border_side)
        numsteps += 1
        along!(robot, bypass_side, numsteps)
        bypass_side = inverse(bypass_side)
    end
    return numsteps, bypass_side
end

function find_marker!(robot)
    max_num_steps = 1
    side = Nord
    while !ismarker(robot)
        find_marker_along!(robot, side, max_num_steps)
        side = left(side)
        find_marker_along!(robot, side, max_num_steps)
        max_num_steps += 1
        side = left(side)
    end
end

function find_marker_along!(robot, side, max_num_steps)
    num_steps = 0
    while num_steps < max_num_steps && !ismarker(robot)
        move!(robot, side)
        num_steps += 1
    end
end