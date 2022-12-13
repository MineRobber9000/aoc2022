local f=fs.open("2022day13input","r")
local input=f.readAll():gsub("\n+$","").."\n\n"
f.close()

--[[ broken ass parser I can't be assed to fix
local function _parse(s)
    local list=s:match("%[(.*)%]")
    if list then
        local ret={}
        list=list..","
        local working=""
        local collect=0
        for item in list:gmatch("(.-),") do
            print(item)
            if item:sub(1,1)=="[" and item~="[]" then
                working=item..","
                collect=collect+select(2,item:gsub("%[",""))-select(2,item:gsub("%]",""))
                if collect==0 then
                    ret[#ret+1]=_parse(working)
                    working=""
                end
                if collect<0 then error("underflow") end
            elseif item:sub(-1,-1)=="]" then
                working=working..item
                collect=collect+select(2,item:gsub("%[",""))-select(2,item:gsub("%]",""))
                if collect==0 then
                    ret[#ret+1]=_parse(working)
                    working=""
                end
                if collect<0 then error("underflow") end
            elseif collect>0 then
                working=working..item..","
            else
                ret[#ret+1]=_parse(item)
            end
        end
        return ret
    elseif s:match("%d+") then
        return tonumber(s)
    elseif s=="" then
        return nil
    else
        error(s)
    end
end

local function parse(s)
    local packet = _parse(s)
    assert(type(packet)=="table","top level of packet is always list")
    return packet
end]]
local function parse(s) return loadstring("return "..s:gsub("%[","{"):gsub("%]","}"))() end

if false then return parse end

local packet_pairs={}
local stage=1
local working
for line in input:gmatch("(.-)\n") do
    if stage==1 then
        working={} -- create working pair
    end
    if stage==1 or stage==2 then
        assert(line:sub(1,1)=="[" and line:sub(-1,-1)=="]","packet must be list")
        working[#working+1]=parse(line)
        stage=stage+1
    elseif stage==3 then
        assert(line=="","packet pairs separated by empty lines")
        packet_pairs[#packet_pairs+1]=working
        working=nil
        stage=1
    end
end

print(#packet_pairs,"pairs")

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

if false then return compare end

local text={[0]="Equal",[1]="Right order",[2]="Wrong order"}
local acc=0
for i=1,#packet_pairs do
    print("Pair "..i)
    local result=compare(table.unpack(packet_pairs[i]))
    print(text[result])
    if result==1 then acc=acc+i end
end
print(acc)
