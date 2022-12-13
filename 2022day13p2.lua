local f=fs.open("2022day13input","r")
local input=f.readAll():gsub("\n+$","").."\n\n"
f.close()

-- broken ass parser I can't be assed to fix omitted for brevity
local function parse(s) return loadstring("return "..s:gsub("%[","{"):gsub("%]","}"))() end

local packets={}
local stage=1
for line in input:gmatch("(.-)\n") do
    if stage==1 or stage==2 then
        assert(line:sub(1,1)=="[" and line:sub(-1,-1)=="]","packet must be list")
        packets[#packets+1]=parse(line)
        stage=stage+1
    elseif stage==3 then
        assert(line=="","packet pairs separated by empty lines")
        stage=1
    end
end

local div1={{2}}
local div2={{6}}
packets[#packets+1]=div1
packets[#packets+1]=div2

-- 0 = equal
-- 1 = left packet before right
-- 2 = right packet before left
local function compare(left,right)
    --print(textutils.serialise(left,{compact=true}),textutils.serialise(right,{compact=true}))
    if type(left)=="number" and type(right)=="number" then
        if left==right then return 0 end
        if left<right then
            return 1
        else
            return 2
        end
    elseif type(left)=="table" and type(right)=="table" then
        local compare_to = math.min(#left,#right)
        for i=1,compare_to do
            local tmp=compare(left[i],right[i])
            if tmp~=0 then return tmp end
        end
        if #left<#right then
            return 1
        elseif #left>#right then
            return 2
        else -- #left==#right
            return 0
        end
    elseif type(left)=="number" and type(right)=="table" then
        return compare({left},right)
    elseif type(left)=="table" and type(right)=="number" then
        return compare(left,{right})
    else
        error(type(left).." vs "..type(right))
    end
end

local function compare_but_sort(a,b)
    local result=compare(a,b)
    return result==1
end
table.sort(packets,compare_but_sort)

local div1i=-1
local div2i=-1
for i=1,#packets do
    if packets[i]==div1 then div1i=i end
    if packets[i]==div2 then div2i=i end
end
print(div1i*div2i)
