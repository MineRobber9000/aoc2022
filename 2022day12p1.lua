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

local start,goal
local nodes={}
for y=1,#grid do
    for x=1,#grid[y] do
        local node={}
        node.x=x
        node.y=y
        node.elev=grid[y][x]
        if node.x==start_x and node.y==start_y then
            start=node
        elseif node.x==end_x and node.y==end_y then
            goal=node
        end
        nodes[#nodes+1]=node
    end
end

local path=finder.path(start,goal,nodes,true,function(node,neighbor)
    local found
    for _,d in ipairs{{-1,0},{1,0},{0,-1},{0,1}} do
        if neighbor.x==(node.x+d[1]) and neighbor.y==(node.y+d[2]) then
            found=true
        end
    end
    if not found then return false end
    return (neighbor.elev-node.elev)<2
end)
print(#path-1)
