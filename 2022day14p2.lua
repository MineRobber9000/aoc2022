local f=fs.open("2022day14input","r")
local input=f.readAll():gsub("\n+$","").."\n"
f.close()

local EMPTY, WALL, SAND = 0,1,2

local maze = setmetatable({},{__index=function(t,k)
    local row=setmetatable({},{__index=function(t,k)
        return EMPTY
    end})
    t[k]=row
    return t[k]
end})

local last_y=0
for line in input:gmatch("(.-)\n") do
    local start_x, start_y = line:match("^(%d+),(%d+)")
    start_x=tonumber(start_x)
    start_y=tonumber(start_y)
    if not start_x then ccemux.setClipboard(line) error("look at line") end
    if start_y>last_y then last_y=start_y end
    for end_x, end_y in line:gmatch(" %-> (%d+),(%d+)") do
        end_x=tonumber(end_x)
        end_y=tonumber(end_y)
        if start_y==end_y then
            for x=math.min(start_x,end_x),math.max(start_x,end_x) do
                maze[start_y][x]=WALL
            end
        elseif start_x==end_x then
            for y=math.min(start_y,end_y),math.max(start_y,end_y) do
                maze[y][start_x]=WALL
            end
            if end_y>last_y then last_y=end_y end
        else
            printError(start_x,start_y,end_x,end_y)
            error()
        end
        start_x,start_y=end_x,end_y
    end
end

maze[last_y+2]=setmetatable({},{__index=function()
    return WALL
end})

local count=0
local px,py=500,0
while true do
    if maze[py][px]==SAND then print(count) return end
    if maze[py+1][px]==EMPTY then
        py=py+1
    elseif maze[py+1][px-1]==EMPTY then
        py=py+1
        px=px-1
    elseif maze[py+1][px+1]==EMPTY then
        py=py+1
        px=px+1
    else
        maze[py][px]=SAND
        px,py=500,0
        count=count+1
    end
end
