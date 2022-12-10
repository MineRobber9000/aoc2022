local f=fs.open("2022day10input","r")
local input=f.readAll():gsub("\r\n","\n"):gsub("\n+$","").."\n"
f.close()

local x=1
local cc=0
local acc=0
function cycle()
    cc=cc+1
    if ((cc-20)%40)==0 then
        acc=acc+(cc*x)
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
print(acc)
