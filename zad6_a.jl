using HorizonSideRobots

r=Robot("zd6.sit", animate=true)

include("functionS.jl")

back_path = move_to_angle_hard!(r)
mark_external_rect!(r)
move_to_back!(r, back_path)