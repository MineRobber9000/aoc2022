local f=fs.open("2022day2input","r")
local input=f.readAll():gsub("\r\n","\n"):gsub("\n+$","").."\n\n"
f.close()

local scores = {A=1,B=2,C=3,X=1,Y=2,Z=3}
local winning_moves = {A="C",B="A",C="B"}
local losing_moves = {}
for k,v in pairs(winning_moves) do losing_moves[v]=k end
local score = 0
for line in input:gmatch(".-\n") do
    line=line:gsub("\n+$","")
    if line ~= "" then
        local s, _, their_move, result = line:find("(.) (.)")
        if not s then error("check line: "..line) end
        if result=="X" then -- lose
            score = score + scores[winning_moves[their_move]] + 0
        elseif result=="Y" then -- draw
            score = score + scores[their_move] + 3
        elseif result=="Z" then -- win
            score = score + scores[losing_moves[their_move]] + 6
        else
            error("invalid state: "..line)
        end
    end
end

print(score)
