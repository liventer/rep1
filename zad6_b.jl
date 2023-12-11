using HorizonSideRobots

r=Robot("zd6.sit", animate=true)

include("functionS.jl")

function n6!(robot)
    back_path, sa, sb = move_to_angle_hard2!(r)

    along!(robot, Ost, sb-1)
    try_move!(robot,Ost)
    putmarker!(robot)
    sb = num_steps_along!(robot,Ost)

    along!(robot, Nord, sa-1)
    try_move!(robot,Nord)
    putmarker!(robot)
    sa = num_steps_along!(robot, Nord)

    along!(robot, West, sb-1)
    try_move!(robot,West)
    putmarker!(robot)
    along!(robot,West)

    along!(robot, Sud, sa-1)
    try_move!(robot,Sud)
    putmarker!(robot)
    along!(robot,Sud)

    move_to_back!(r, back_path)
end
n6!(r)