# aoc2022
2022 Advent of Code solutions in ComputerCraft Lua.

## `aocdownload.lua`

`aocdownload` is a downloader for Advent of Code inputs. [Don't use it in a loop](), just run it once (the input is saved to `[year]day[day]input`). Takes one argument, the day (the year is a separate variable within the program that can be changed). Example for day 1 input:

```
aocdownload 1
```

Requires you to [get your session cookie](https://www.reddit.com/r/adventofcode/comments/a2vonl/how_to_download_inputs_with_a_script/) and place it in `.aoc_session` in the root directory.

## `2022day[day]p[part].lua`

Solutions. Requires input files saved in the `2022day[day]input` format in the root directory.
