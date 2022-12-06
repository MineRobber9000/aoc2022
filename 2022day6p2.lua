local f=fs.open("2022day6input","r")
local input=f.readAll():gsub("\n+$","")
f.close()

local function hasRepeats(...)
    local seen = {}
    local values = table.pack(...)
    for i=1,#values do
        if seen[values[i]] then return true end
        seen[values[i]]=true
    end
end

for i=14,#input do
    if not hasRepeats(input:sub(i-13,i):match(("(.)"):rep(14))) then
        print(i)
        return
    end
end
