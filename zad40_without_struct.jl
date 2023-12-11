using HorizonSideRobots

r=Robot("zd40.sit", animate=true)

include("functionS.jl")
#S+=-y-1 - стенка свепху
#S+=y - стенка снизу

function score(r, coord, s)
    if isborder(r,Nord)
        s+=-coord[2]-1
    end
    if isborder(r,Sud)
        s+=coord[2]
    end
    return s
end

function side_to_coord(coord, side)
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
end

function obhod!(r, side, coord, s)
    fl=true
    path_coord = []
    push!(path_coord, [0,0])

    while coord!=[0,0] || fl
        if isborder(r, side) && !isborder(r, right(side))
            move!(r,right(side))
            coord = side_to_coord(coord, right(side))
        elseif !isborder(r, side)
            move!(r,side)
            coord = side_to_coord(coord, side)
            side=left(side)
        elseif isborder(r, side) && isborder(r, right(side)) && isborder(r, inverse(side))
            move!(r,left(side))
            coord = side_to_coord(coord, left(side))
            side=inverse(side)
        elseif isborder(r, side) && isborder(r, right(side))
            move!(r,inverse(side))
            coord = side_to_coord(coord, inverse(side))
            side=right(side)
        end

        if !(coord in path_coord)
            p=coord[1]
            k=coord[2]
            s = score(r, [p,k], s)
            push!(path_coord, [p,k])
        end
        fl=false
    end
    println(s) 
end

#если в изначальном положении робота стенка под ним, то r=0, если над ним, то -1
if isborder(r,Nord)
    a=-1
else
    a=0
end
obhod!(r, Nord, [0,0], a)