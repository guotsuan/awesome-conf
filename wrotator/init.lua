#! /usr/bin/env lua
--
-- init.lua
-- Copyright (C) 2015 dccf87 <dccf87@gqlinux>
--
-- Distributed under terms of the MIT license.
--

-- Rotation the wallpapers in the given directory. 


local timer = (type(timer) == "table" and timer or require("gears.timer"))
local setmetatable = setmetatable
local gears = require("gears")


math.randomseed(os.time())

local wrotator = {}

-- shuffle the given table
local function shuffleTable(t)
    local rand = math.random 
    assert( t, "shuffleTable() expected a table, got nil" )
    local iterations = #t
    local j
    
    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then 
       io.close(f) 
       return true 
   else 
       return false 
   end
end



-- scan directory, and optionally filter outputs
local function scandir(directory, filter)
    local i, t, popen = 0, {}, io.popen
    if not filter then
        filter = function(s) return true end
    end
    for filename in popen('ls -a "'..directory..'"'):lines() do
        if filter(filename) then
            i = i + 1
            t[i] = filename
        end
    end
    return t
end

function wrotator.run (arg)
    local wp_path = arg.path  
    local timeout = arg.timeout or 600
    local filter = arg.filter or nil
    local wp_files = scandir(wp_path, filter)

    shuffleTable(wp_files)

    for s = 1, screen.count() do
        gears.wallpaper.maximized(wp_path .. wp_files[1], s)
        table.remove(wp_files, 1)
    end

    -- setup the timer
    wrotator.wp_timer = timer({timeout = timeout})

    wrotator.wp_timer:connect_signal("timeout", function()
     
      -- set wallpaper to current index for all screens
    if not next(wp_files) then
        wp_files = scandir(wp_path, filter)
        shuffleTable(wp_files)
    end

    for s = 1, screen.count() do
        while not file_exists(wp_path .. wp_files[1]) do
            table.remove(wp_files, 1)
        end

         gears.wallpaper.maximized(wp_path .. wp_files[1], s)
         table.remove(wp_files, 1)
    end

    --wp_timer 

    --if wp_timer.started then
      --wp_timer:stop()
    --else
      --wp_timer:start()
    --end

    end)

end

setmetatable(wrotator, { __call = function(_, ...) return wrotator.run(...) end })


return wrotator

    

