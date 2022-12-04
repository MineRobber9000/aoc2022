local f=fs.open("2022day4input","r")
local input=f.readAll():gsub("\r\n","\n"):gsub("\n+$","").."\n"
f.close()

local n=0
for p1, p2, p3, p4 in input:gmatch("(%d-)%-(%d-),(%d-)%-(%d-)\n") do
    p1, p2, p3, p4 = tonumber(p1), tonumber(p2), tonumber(p3), tonumber(p4)
    if (p1>=p3 and p2<=p4) or (p3>=p1 and p4<=p2) then
        n=n+1
    end
end
print(n)
