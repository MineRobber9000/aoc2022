local f=fs.open("2022day15input","r")
local input=f.readAll():gsub("\n+$","").."\n"
f.close()

local function dist(x1,y1,x2,y2)
    return math.abs(x1-x2)+math.abs(y1-y2)
end

local sensors=setmetatable({},{__index=function(t,k)
    t[k]={}
    return t[k]
end})

for sensor_x,sensor_y,beacon_x,beacon_y in input:gmatch("Sensor at x=(%-?%d+), y=(%-?%d+): closest beacon is at x=(%-?%d+), y=(%-?%d+)\n") do
    sensor_x,sensor_y,beacon_x,beacon_y=tonumber(sensor_x),tonumber(sensor_y),tonumber(beacon_x),tonumber(beacon_y)
    sensors[sensor_y][sensor_x]=dist(sensor_x,sensor_y,beacon_x,beacon_y)
end

local function iterate_sensors()
    return coroutine.wrap(function()
        for sensor_y, _y in pairs(sensors) do
            for sensor_x, dist in pairs(_y) do
                coroutine.yield(sensor_x,sensor_y,dist)
            end
        end
    end)
end

local function add_and_simplify(ranges,added)
    for i=1,#ranges do
        -- if the range overlaps with the added one, merge them
        if (not ((ranges[i][1]>added[2]) or (added[1]>ranges[i][2]))) then
            local new = {math.min(ranges[i][1],added[1]),math.max(ranges[i][2],added[2])}
            table.remove(ranges,i)
            return add_and_simplify(ranges,new)
        end
    end
    -- if there are no overlaps, add new range and return
    ranges[#ranges+1]=added
    return ranges
end

local function further_simplify(ranges)
    table.sort(ranges,function(a,b) return a[1]<b[1] end)
    for i=1,#ranges-1 do
        -- if two are touching, merge them and re-simplify
        if (ranges[i][2]+1)==ranges[i+1][1] then
            local new={ranges[i][1],ranges[i+1][2]}
            table.remove(ranges,i+1)
            table.remove(ranges,i)
            ranges[#ranges+1]=new
            return further_simplify(ranges)
        end
    end
    return ranges
end

local t=os.epoch"utc"
for y=0,4000000 do
    if (os.epoch"utc"-t)>3000 then sleep(0) write(".") t=os.epoch"utc" end
    -- sensor x/y/dist
    -- got tired of typing it all out
    local ranges={}
    for sx,sy,sd in iterate_sensors() do
        local d=sd-math.abs(sy-y)
        if d>=0 then
            ranges=add_and_simplify(ranges,{sx-d,sx+d})
        end
    end
    ranges=further_simplify(ranges)
    if #ranges==1 and ranges[1][1]<=0 and ranges[1][2]>=4000000 then
        -- entire row was eliminated, no spots to check
    else
        -- there's a hole, which is our solution
        local x=ranges[1][2]+1
        write("\n")
        print(x*4000000+y)
        return
    end
end
error"fuck"
