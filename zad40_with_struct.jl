using HorizonSideRobots
include("struct40.jl")

r = Robot("zd40.2.sit", animate=true)
r = CordRobot(r)


#S+=-y-1 - стенка свепху
#S+=y - стенка снизу

function score(r)
    if isborder(r,Nord)
        r.S += -1-r.coordinates.y
    end
    if isborder(r,Sud)
        r.S += r.coordinates.y
    end
end

#=function side_to_coord(coord, side)
    if side==Nord
        coord[2]+=1
    elseif side==Sud
        coord[2]-=1
    elseif side==West
        coord[1]-=1
    else 
        coord[1]+=1
    end
    return coord
end=#

function obhod!(r::CordRobot, side)
    fl=false    
    path_coord = []
    while r.coordinates != Coordinates(0, 0)
        println(r.coordinates)
        if isborder(r, side) && !isborder(r, right(side))
            move!(r,right(side))
        elseif !isborder(r, side)
            move!(r,side)
            side=left(side)
        elseif isborder(r, side) && isborder(r, right(side)) && isborder(r, inverse(side))
            move!(r,left(side))
            side=inverse(side)
        elseif isborder(r, side) && isborder(r, right(side))
            move!(r,inverse(side))
            side=right(side)
        end
        if !(r.coordinates in path_coord)  
            score(r)
            push!(path_coord, r.coordinates)
        end
        fl=true
    end
    println(s) 
end

obhod!(r, Nord)