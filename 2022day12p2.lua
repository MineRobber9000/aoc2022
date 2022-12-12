local f=fs.open("2022day12input","r")
local input=f.readAll():gsub("\n+$","").."\n"
f.close()

local grid={}
local start_x, start_y, end_x, end_y
local elev="abcdefghijklmnopqrstuvwxyz"
for line in input:gmatch("(.-)\n") do
    local row={}
    line:gsub("(.)",function(c)
        if c=="S" then
            row[#row+1]=1
            start_x=#row
            start_y=#grid+1
        elseif c=="E" then
            row[#row+1]=26
            end_x=#row
            end_y=#grid+1
        else
            row[#row+1] = assert(elev:find(c),c)
        end
    end)
    grid[#grid+1]=row
end
assert(start_x and start_y,"Unable to find start!")
assert(end_x and end_y,"Unable to find goal!")

local finder=require"a-star"

local starts={}
local basic_start,goal
local nodes={}
for y=1,#grid do
    for x=1,#grid[y] do
        local node={}
        node.x=x
        node.y=y
        node.elev=grid[y][x]
        if node.elev==1 and node.x<5 then -- modify this based on your input; should cut out most anything that doesn't have a b next to it
            starts[#starts+1]=node
            if node.x==start_x and node.y==end_y then basic_start=node end
        elseif node.x==end_x and node.y==end_y then
            goal=node
        end
        nodes[#nodes+1]=node
    end
end
local dist=finder.distance(basic_start.x,basic_start.y,goal.x,goal.y)

local function validNeighbor(node,neighbor)
    local found
    for _,d in ipairs{{-1,0},{1,0},{0,-1},{0,1}} do
        if neighbor.x==(node.x+d[1]) and neighbor.y==(node.y+d[2]) then
            found=true
        end
    end
    if not found then return false end
    return (neighbor.elev-node.elev)<2
end
print(#starts,"starts")
local best=math.huge
for i=1,#starts do
    write(starts[i].x) write(";") write(starts[i].y) write(": ")
    if false then --finder.distance(starts[i].x,starts[i].y,goal.x,goal.y)>dist then
        print("farther than I'm willing to test")
    else
    local path=finder.path(starts[i],goal,nodes,true,validNeighbor)
    if path then 
        local score=#path-1
        write(score)
        if score<best then write(" new best!") best=score end
    else
        write("no exit")
    end
    write("\n")
    end
    sleep(0)
end
print(best)
