local f=fs.open("2022day8input","r")
local input=f.readAll():gsub("\r\n","\n"):gsub("\n+$","\n")
f.close()

local forest = {}
for line in input:gmatch("(.-)\n") do forest[#forest+1]=line end

local function getTree(x,y)
    if y<1 or y>#forest then return -1 end
    if x<1 or x>#forest[y] then return -1 end
    return tonumber(forest[y]:sub(x,x))
end

local function isVisible(x,y)
    if y==1 or y==#forest then return true end
    if x==1 or x==#forest[y] then return true end
    local tree=getTree(x,y)
    local _x,_y,_nope=x,y,false
    repeat
        _y=_y-1
        if getTree(_x,_y)>=tree then _nope=true end
    until _nope or _y==0
    if not _nope then return true else _nope=false end
    _y=y
    repeat
        _y=_y+1
        if getTree(_x,_y)>=tree then _nope=true end
    until _nope or _y>#forest
    if not _nope then return true else _nope=false end
    _y=y
    repeat
        _x=_x-1
        if getTree(_x,_y)>=tree then _nope=true end
    until _nope or _x==0
    if not _nope then return true else _nope=false end
    _x=x
    repeat
        _x=_x+1
        if getTree(_x,_y)>=tree then _nope=true end
    until _nope or _x>#forest[y]
    return not _nope
end

local acc=0
for y=1,#forest do
    for x=1,#forest[y] do
        if isVisible(x,y) then acc=acc+1 end
    end
end
print(acc)
