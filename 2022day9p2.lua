local f=fs.open("2022day9input","r")
local input=f.readAll():gsub("\r\n","\n"):gsub("\n+$","\n")
f.close()

local head_x,head_y,tail_x,tail_y=0,0,0,0
local intermediate_spots={}
for i=1,8 do
    intermediate_spots[i]={0,0}
end
local tail_spots={}
local function add_spot(x,y)
    --print(tail_x,tail_y)
    --sleep(0.5)
    for i=1,#tail_spots do
        if tail_spots[i][1]==tail_x and tail_spots[i][2]==tail_y then return end
    end
    --print("[x]")
    tail_spots[#tail_spots+1]={tail_x,tail_y}
end
add_spot()

local function touching(hx,hy,tx,ty)
    return (math.abs(hx-tx)<=1 and math.abs(hy-ty)<=1)
end

local function sign(n)
    return (n==0 and 0) or (n>0 and 1) or -1
end

local function ensure_touching(hx,hy,tx,ty,dx,dy)
    if not touching(hx,hy,tx,ty) then
        --stop being cute (a la p1) and just go stepwise at the target
        --this took me longer than it should have
        tx=tx+sign(hx-tx)
        ty=ty+sign(hy-ty)
        if not touching(hx,hy,tx,ty) then error(textutils.serialise({head_x=hx,head_y=hy,tail_x=tx,tail_y=ty})) end
    end
    return tx,ty
end

local dirs={}
dirs.U={0,-1}
dirs.D={0,1}
dirs.L={-1,0}
dirs.R={1,0}
local start=os.epoch("utc")
for direction, n in input:gmatch("(.) (%d+)\n") do
    n=tonumber(n)
    --print(direction,n,head_x,head_y,tail_x,tail_y)
    local dx, dy = table.unpack(dirs[direction])
    for i=1,n do
        head_x=head_x+dx
        head_y=head_y+dy
        local uno=intermediate_spots[1]
        uno[1], uno[2] = ensure_touching(head_x,head_y,uno[1],uno[2],dx,dy)
        for i=2,8 do
            --print(i-1,i)
            local h=intermediate_spots[i-1]
            local t=intermediate_spots[i]
            t[1],t[2]=ensure_touching(h[1],h[2],t[1],t[2],dx,dy)
        end
        local ocho=intermediate_spots[8]
        tail_x,tail_y=ensure_touching(ocho[1],ocho[2],tail_x,tail_y,dx,dy)
        add_spot()
    end
    local now=os.epoch("utc")
    if (now-start)>3000 then
        start=now
        os.queueEvent("")
        os.pullEvent()
    end
end
print(#tail_spots)
