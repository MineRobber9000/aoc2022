local f=fs.open("2022day6input","r")
local input=f.readAll():gsub("\n+$","")
f.close()

for i=4,#input do
    local a,b,c,d = input:sub(i-3,i):match("(.)(.)(.)(.)")
    if a~=b and a~=c and a~=d and b~=c and b~=d and c~=d then
        print(i)
        return
    end
end
