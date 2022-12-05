local f=fs.open("2022day5input","r")
local input=f.readAll():gsub("\r\n","\n"):gsub("\n+$","\n")
f.close()

local s,e = input:find("\n\n",1,true)
if not s then error"cannot find empty line" end

-- I'll come back and rewrite this to do the "correct" thing eventually
-- for now we'll just ignore the fancy ascii art and focus on solving the directions
input=input:sub(e+1)

local function stack(s)
    local ret={}
    s:gsub("(.)",function(c) table.insert(ret,c) end)
    return ret
end

stacks = {
    stack"WMLF",
    stack"BZVMF",
    stack"HVRSLQ",
    stack"FSVQPMTJ",
    stack"LSW",
    stack"FVPMRJW",
    stack"JQCPNRF",
    stack"VHPSZWRB",
    stack"BMJCGHZW"
}

local function move(n,from,to)
    if #from<n then error("not enough items in stack") end
    local tmp={}
    for i=1,n do
        table.insert(tmp,table.remove(from))
    end
    while #tmp>0 do
        table.insert(to,table.remove(tmp))
    end
end

for n, from, to in input:gmatch("move (%d+) from (%d+) to (%d+)\n") do
    n, from, to = tonumber(n), tonumber(from), tonumber(to)
    print(n,from,to)
    move(n,stacks[from],stacks[to])
end

local answer=""
for i=1,#stacks do
    answer=answer..stacks[i][#stacks[i]]
end
print(answer)
