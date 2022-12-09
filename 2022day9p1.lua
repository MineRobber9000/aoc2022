local f=fs.open("2022day9input","r")
local input=f.readAll():gsub("\r\n","\n"):gsub("\n+$","\n")
f.close()

local head_x,head_y,tail_x,tail_y=0,0,0,0
local tail_spots={}
local function add_spot(x,y)
    --print(tail_x,tail_y)
    for i=1,#tail_spots do
        if tail_spots[i][1]==tail_x and tail_spots[i][2]==tail_y then return end
    end
    tail_spots[#tail_spots+1]={tail_x,tail_y}
end
add_spot()

local function tail_touching()
    return (math.abs(head_x-tail_x)<=1 and math.abs(head_y-tail_y)<=1)
end

local dirs={}
dirs.U={0,-1}
dirs.D={0,1}
dirs.L={-1,0}
dirs.R={1,0}
for direction, n in input:gmatch("(.) (%d+)\n") do
    n=tonumber(n)
    --print(direction,n,head_x,head_y,tail_x,tail_y)
    local dx, dy = table.unpack(dirs[direction])
    for i=1,n do
        head_x=head_x+dx
        head_y=head_y+dy
        if not tail_touching() then
            if head_y==tail_y then
                tail_x=tail_x+dx
                add_spot()
            elseif head_x==tail_x then
                tail_y=tail_y+dy
                add_spot()
            else
                if math.abs(head_x-tail_x)==1 then
                    --print("--",1)
                    tail_x=head_x
                    tail_y=tail_y+dy
                elseif math.abs(head_y-tail_y)==1 then
                    --print("--",2)
                    tail_x=tail_x+dx
                    tail_y=head_y
                end
                add_spot()
            end
            if not tail_touching() then error(textutils.serialise({head_x=head_x,head_y=head_y,tail_x=tail_x,tail_y=tail_y})) end
        end
    end
end
print(#tail_spots)
