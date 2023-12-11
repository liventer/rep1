using HorizonSideRobots

r=Robot("zd1.sit", animate=true)

include("functionS.jl")

function perimetr!(robot)
    num_x::Int = num_steps_along!(robot, West)
    num_y::Int = num_steps_along!(robot, Sud)
    mark_external_rect!(robot)
    along!(robot,Nord,num_y)
    along!(robot,Ost,num_x)
end

perimetr!(r)