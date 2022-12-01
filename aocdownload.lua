local year = "2022"
local day = tonumber(...)
if not day then error("needs day") end

local cookie=fs.open(".aoc_session","r")
local cookie_value=cookie.readAll():gsub("\n+$","")
cookie.close()

local h, err, herr = http.get("https://adventofcode.com/"..year.."/day/"..day.."/input",{["cookie"]=cookie_value})
if not h then
    printError("Error:")
    printError(err)
    printError(herr.readAll())
    herr.close()
    return
end

local f = fs.open(year.."day"..day.."input","w")
f.write(h.readAll())
f.close()
h.close()
