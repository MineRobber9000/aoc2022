local f=fs.open("2022day7input","r")
local input=f.readAll():gsub("\n+$","\n")
f.close()

local afs={}
local cwd={}

local function getdir(dir)
    local t=afs
    for i=1,#dir do t=t[dir[i]] end
    return t
end

local function set(name,val)
    local t=(#cwd==0 and afs or getdir(cwd))
    t[name]=val
end

local function cd(dir)
    if dir==".." then
        -- go up
        cwd[#cwd]=nil
    elseif dir=="/" then
        cwd={}
    else
        cwd[#cwd+1]=dir
    end
end

local function sizeof(dir)
    local ret=0
    for k,v in pairs(dir) do
        if type(v)=="number" then
            ret=ret+v
        else
            ret=ret+sizeof(v)
        end
    end
    return ret
end

for line in input:gmatch("(.-)\n") do
    local dir = line:match("%$ cd (.+)")
    local size, fn = line:match("(%d+) (.+)")
    local listeddir = line:match("dir (.+)")
    if dir then
        cd(dir)
    elseif listeddir then
        set(listeddir,{})
    elseif size then
        set(fn,tonumber(size))
    elseif line~="$ ls" then
        error(line)
    end
end

local function copy(t)
    local ret={}
    for i=1,#t do ret[i]=t[i] end
    return ret
end

local target = 30000000-(70000000-sizeof(afs))

local dirs = {}
local queue = {{}}
while #queue>0 do
    local dir = table.remove(queue,1)
    local dir_obj = getdir(dir)
    local size = sizeof(dir_obj)
    if size>=target then
        dirs[#dirs+1]=size
    end
    for k,v in pairs(dir_obj) do
        if type(v)=="table" then
            local new_entry = copy(dir)
            new_entry[#new_entry+1]=k
            queue[#queue+1]=new_entry
        end
    end
end
table.sort(dirs)
print(dirs[1])
