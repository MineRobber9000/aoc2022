local f=fs.open("2022day3input","r")
local input=f.readAll():gsub("\r\n","\n"):gsub("\n+$","").."\n"
f.close()

local priority="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
local acc=0
for line1,line2,line3 in input:gmatch("(.-)\n(.-)\n(.-)\n") do
    for i=1,#priority do
        local c = priority:sub(i,i)
        if line1:match(c) and line2:match(c) and line3:match(c) then
            acc=acc+i
        end
    end
end

print(acc)
