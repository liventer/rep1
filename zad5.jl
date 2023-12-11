using HorizonSideRobots

r=Robot("zd5.sit", animate=true)

include("functionS.jl")

function mark_external_internal!(robot)
    back_path = move_to_angle!(robot)
    mark_external_rect!(robot)

    find_internal_border!(robot)
    move_to_internal_sudwest!(robot)

    putmarker!(robot)

    mark_internal_rect!(robot)

    move_to_angle!(robot)
    move_to_back!(robot, back_path)
    end
    
mark_external_internal!(r)