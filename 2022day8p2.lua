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

local function scenicScore(x,y)
    local tree=getTree(x,y)
    local _x,_y,_nope,acc,scenic=x,y,false,0,1
    repeat
        _y=_y-1
        if _y==0 or getTree(_x,_y)>=tree then _nope=true else acc=acc+1 end
    until _nope or _y==0
    if _nope and _y>0 then acc=acc+1 end
    _nope=false
    _y=y
    scenic=scenic*acc
    acc=0
    repeat
        _y=_y+1
        if _y>#forest or getTree(_x,_y)>=tree then _nope=true else acc=acc+1 end
    until _nope or _y>#forest
    if _nope and _y<=#forest then acc=acc+1 end
    _nope=false
    _y=y
    scenic=scenic*acc
    acc=0
    repeat
        _x=_x-1
        if _x==0 or getTree(_x,_y)>=tree then _nope=true else acc=acc+1 end
    until _nope or _x==0
    if _nope and _x>0 then acc=acc+1 end
    _nope=false
    _x=x
    scenic=scenic*acc
    acc=0
    repeat
        _x=_x+1
        if _x>#forest[y] or getTree(_x,_y)>=tree then _nope=true else acc=acc+1 end
    until _nope or _x>#forest[y]
    if _nope and _x<=#forest[y] then acc=acc+1 end
    scenic=scenic*acc
    return scenic
end

local best,last_best,best_x,best_y=-1,-1,-1,-1
for y=1,#forest do
    for x=1,#forest[y] do
        last_best=best
        best=math.max(best,scenicScore(x,y))
        if last_best~=best then best_x,best_y=x,y end
    end
end
print(best,best_x,best_y)
