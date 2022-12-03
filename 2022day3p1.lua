local f=fs.open("2022day3input","r")
local input=f.readAll():gsub("\r\n","\n"):gsub("\n+$","").."\n"
f.close()

local priority="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
local acc=0
for line in input:gmatch(".-\n") do
    line=line:gsub("\n+$","")
    if (#line%2)==1 then error("check: "..line) end
    local comp_len = math.floor(#line/2)
    local comp1, comp2 = line:sub(1,comp_len), line:sub(comp_len+1)
    assert(#comp1==#comp2,"uhh "..comp_len..":"..#comp1..";"..#comp2)
    for i=1,#priority do
        local c = priority:sub(i,i)
        if comp1:match(c) and comp2:match(c) then
            acc=acc+i
        end
    end
end

print(acc)
