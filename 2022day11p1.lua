local f=fs.open("2022day11input","r")
local input=f.readAll():gsub("\n+$","").."\n\n"
f.close()

local monkeys={}
local stage=1
local current=nil
for line in input:gmatch("(.-)\n") do
    if stage==1 then
        local n=assert(tonumber(line:match("Monkey (%d+)")),line)
        monkeys[n]={}
        current=n
        stage=2
    elseif stage==2 then
        assert(line:match("(Starting items:)"),line)
        local items={}
        for item in line:gmatch("(%d+),") do
            items[#items+1]=tonumber(item)
        end
        items[#items+1]=tonumber(line:match("(%d+)$"))
        monkeys[current].items=items
        stage=3
    elseif stage==3 then
        assert(line:match("(Operation:)"))
        local fn=assert(loadstring("return function(old) "..line:match("Operation: (.+)"):gsub("new =","return").." end"))()
        monkeys[current].fn=fn
        stage=4
    elseif stage==4 then
        local n=assert(tonumber(line:match("Test: divisible by (%d+)")),line)
        monkeys[current].div=n
        stage=5
    elseif stage==5 then
        local n=assert(tonumber(line:match("If true: throw to monkey (%d+)")),line)
        monkeys[current].if_true=n
        stage=6
    elseif stage==6 then
        local n=assert(tonumber(line:match("If false: throw to monkey (%d+)")),line)
        monkeys[current].if_false=n
        stage=7
    elseif stage==7 then
        assert(line=="","not an empty line: "..line)
        current=nil
        stage=1
    end
end
if current then error("EOF when parsing monkey "..current) end

local items_scanned={}
for i=0,#monkeys do items_scanned[i+1]=0 end
for r=1,20 do
    for i=0,#monkeys do
        local monkey=monkeys[i]
        while #monkey.items>0 do
            local item=table.remove(monkey.items,1)
            items_scanned[i+1]=items_scanned[i+1]+1
            item=monkey.fn(item)
            item=math.floor(item/3)
            if (item%monkey.div)==0 then
                table.insert(monkeys[monkey.if_true].items,item)
            else
                table.insert(monkeys[monkey.if_false].items,item)
            end
        end
    end
end
table.sort(items_scanned)
print(items_scanned[#items_scanned]*items_scanned[#items_scanned-1])
