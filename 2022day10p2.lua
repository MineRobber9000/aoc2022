local f=fs.open("2022day10input","r")
local input=f.readAll():gsub("\r\n","\n"):gsub("\n+$","").."\n"
f.close()

local x=1
local cc=0
local crt={}
function cycle()
    cc=cc+1
    local diff=((cc-1)%40)-(x-1)
    if diff>=0 and diff<3 then
        crt[cc]="#"
    else
        crt[cc]="."
    end
end

local function startsWith(s,b)
    return s:sub(1,#b)==b
end

for line in input:gmatch("(.-)\n") do
    if line=="noop" then
        cycle()
    elseif startsWith(line,"addx ") then
        local n = tonumber(line:match("addx (%-?%d+)"))
        if not n then error(line) end
        cycle()
        cycle()
        x=x+n
    else
        error(line)
    end
end
for i=1,40*6 do
    if i>1 and ((i-1)%40)==0 then
        write("\n")
    end
    write(crt[i])
end
write("\n")
