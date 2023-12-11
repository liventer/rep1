using HorizonSideRobots

r=Robot("zd1.sit", animate=true)

include("functionS.jl")

function mark_all!(robot)
    n = num_steps_along!(robot,West)
    for i in 1:n
        mark_row!(robot,Nord)
        move!(robot,Ost)
    end

    n = num_steps_along!(robot,Ost)
    for i in 1:n   
        mark_row!(robot,Nord)
        move!(robot,West)
    end
    
    mark_row!(robot,Nord)
end

mark_all!(r)