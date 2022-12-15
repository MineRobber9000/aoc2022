local f=fs.open("2022day15input","r")
local input=f.readAll():gsub("\n+$","").."\n"
f.close()

local function dist(x1,y1,x2,y2)
    return math.abs(x1-x2)+math.abs(y1-y2)
end

local y2m={}

for sensor_x,sensor_y,beacon_x,beacon_y in input:gmatch("Sensor at x=(%-?%d+), y=(%-?%d+): closest beacon is at x=(%-?%d+), y=(%-?%d+)\n") do
    sensor_x,sensor_y,beacon_x,beacon_y=tonumber(sensor_x),tonumber(sensor_y),tonumber(beacon_x),tonumber(beacon_y)
    local _dist=dist(sensor_x,sensor_y,beacon_x,beacon_y)
    local dx=_dist-math.abs(sensor_y-2000000)
    for x=-dx,dx-1 do
        y2m[sensor_x+x]=true
    end
end

local acc=0
for x, count in pairs(y2m) do
    if count then acc=acc+1 end
end
print(acc)
