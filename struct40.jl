using HorizonSideRobots

HSR = HorizonSideRobots

abstract type AbstractRobot end

HSR.move!(robot::AbstractRobot, side) = move!(get_baserobot(robot), side)
HSR.isborder(robot::AbstractRobot, side) = isborder(get_baserobot(robot), side)
HSR.putmarker!(robot::AbstractRobot) = putmarker!(get_baserobot(robot))
HSR.ismarker(robot::AbstractRobot) = ismarker(get_baserobot(robot))
HSR.temperature(robot::AbstractRobot) = temperature(get_baserobot(robot))

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)-1, 4))
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

mutable struct Coordinates
    x::Int
    y::Int
end

function HorizonSideRobots.move!(coord::Coordinates, side::HorizonSide)
    if side == Ost
        coord.x +=1
    elseif side == West
        coord.x -=1
    elseif side == Nord
        coord.y +=1
    else
        coord.y -=1
    end
end

get(coord::Coordinates) = (coord.x, coord.y)


mutable struct CordRobot <: AbstractRobot
    robot::Robot
    coordinates::Coordinates
    S::Int
    CordRobot(r) = new(r, Coordinates(0,0), 0)
end

get_baserobot(robot::CordRobot) = robot.robot

function HSR.move!(robot::CordRobot, side)
    move!(robot.robot, side)
    move!(robot.coordinates, side)
    x, y = get(robot.coordinates)
    return x, y
end


function left(side, r::CordRobot)
    r.count-=1
    return left(side)
end

function right(side,r::CordRobot)
    r.count+=1
    return right(side)
end

function inverse(side,r::CordRobot)
    r.count-=2
    return inverse(side)
end
