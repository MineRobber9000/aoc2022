local f=fs.open("2022day1input","r")
local input=f.readAll():gsub("\r\n","\n"):gsub("\n+$","").."\n\n"
f.close()

local acc=0
local elves={}
for line in input:gmatch(".-\n") do
    line=line:gsub("\n+$","")
    if line=="" then
        elves[#elves+1]=acc
        acc=0
    else
        acc=acc+assert(tonumber(line),"invalid number "..line)
    end
end

table.sort(elves)
print(elves[#elves]+elves[#elves-1]+elves[#elves-2])
