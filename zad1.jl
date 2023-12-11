using HorizonSideRobots

r=Robot("zd1.sit", animate=true)

include("functionS.jl")
function mark_kross!(robot)
    putmarker!(robot)
    for side in (Nord, West, Sud, Ost)
        num_steps = numsteps_mark_along!(robot, side) 
        along!(robot, inverse(side), num_steps) 
    end
    
end

mark_kross!(r)