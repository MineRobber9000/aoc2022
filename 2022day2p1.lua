local f=fs.open("2022day2input","r")
local input=f.readAll():gsub("\r\n","\n"):gsub("\n+$","").."\n\n"
f.close()

local scores = {A=1,B=2,C=3,X=1,Y=2,Z=3}
local winning_moves = {A="Z",B="X",C="Y",X="C",Y="A",Z="B"}
local same_moves = {A="X",X="A",B="Y",Y="B",C="Z",Z="C"}
local score = 0
for line in input:gmatch(".-\n") do
    line=line:gsub("\n+$","")
    if line ~= "" then
        local s, _, their_move, our_move = line:find("(.) (.)")
        if not s then error("check line: "..line) end
        if winning_moves[our_move]==their_move then
            score = score + scores[our_move] + 6
        elseif winning_moves[their_move]==our_move then
            score = score + scores[our_move] + 0
        elseif same_moves[their_move]==our_move then
            score = score + scores[our_move] + 3
        else
            error("invalid state: "..line)
        end
    end
end

print(score)
