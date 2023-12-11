using HorizonSideRobots

r=Robot("zd7.sit", animate=true)

include("functionS.jl")

"""a, b = find_pass!(r, Nord)
move!(r,Nord)
along!(r, b, div(a+1,2))"""   #<= робот с другой стороны перегородки

find_pass!(r,Nord)