-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")
local lain = require("lain")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")

-- Menubar
local menubar = require ("menubar")
menubar.cache_entries = true
menubar.app_folders = { "/usr/share/applications/" }
menubar.show_categories = true

require ("eminent")
require ("hints")
local keychains = require("keychains")
local revelation=require("revelation")
--local lognotify=require("lognotify")
--local dmenu=require("dmenu")
local drop = require("scratchdrop")

--require("aweror")
--require("shifty")

--{{{ currently not useful
--ilog = lognotify{
    --logs = { pacman = { file = "/var/log/pacman.log"},
    ---- Check, whether you have the permissions to read your log files!
    ---- You can fix this by configure syslog deamon in many case.
    --syslog = { file = "/var/log/dmesg.log", ignore = { "Changing fan level" }}
    --},
   ---- Delay between checking in seconds. Default: 1
   --interval = 1,
   ---- Time in seconds after which popup expires. Set 0 for no timeout. Default: 0
   --naughty_timeout = 25
--}
--}}}


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/home/dccf87/.config/awesome/themes/Darklooks/theme.lua")
--beautiful.init("/usr/share/awesome/themes/brown/theme.lua")
os.setlocale(os.getenv("LANG"))

--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
--beautiful.init(os.getenv("HOME").."/.config/awesome/themes/powerarrow-darker/theme.lua")
beautiful.init(os.getenv("HOME").."/.config/awesome/themes/zenburn-custom/theme.lua")
--beautiful.init("/usr/share/awesome/themes/zenburn-custom/theme.lua")

revelation.init()
hints.init()

-- This is used later as the default terminal and editor to run.
--terminal = "lxterminal"
--terminal = "lilyterm"
terminal = "terminator"
--terminal = "xfce-terminal"
editor = os.getenv("EDITOR") or "gvim"
editor_cmd = terminal .. " -e " .. editor
val = nil
browser1="firefox"

--local quake = require("quake")
--local quakeconsole = {}

--for s = 1, screen.count() do
    --quakeconsole[s] = quake({
        --terminal = "urxvt",
        --name = "tilda",
        --screen = s,
        --height = 0.7,
        --width = 0.6,
    --})
--end

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.

modkey = "Mod4"

lain.layout.termfair.nmaster = 2
lain.layout.termfair.ncol = 1
lain.layout.centerfair.nmaster = 2
lain.layout.centerfair.ncol = 1

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    lain.layout.uselessfair.horizontal,
    lain.layout.uselesstile,
    lain.layout.uselessfair,
    lain.layout.termfair,
    lain.layout.centerfair,
    lain.layout.uselesspiral.dwindle
}
--}}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.

-- old tags
 tags = {
   names  = { "1:work", "2:term", "3:www", "4:view", "5", 6, "7:mail", 8,"9:sys"},
   layout = { layouts[2], layouts[2], layouts[1], layouts[7], layouts[2],
              layouts[2], layouts[2], layouts[2], layouts[4]
 }}

for s = 1, screen.count() do
    -- Each screen has its own tag table.
    -- simple tagls
    --tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
    tags[s] = awful.tag(tags.names,s,tags.layout)
end
--commented by gq 
--}}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -x man awesome &" },
   { "edit config", "gvim".. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- Menubar configuration
menubar.utils.terminal = "xterm" -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock("%a %b %d, %H:%M")

-- orglendar
local orglendar = require('orglendar')
orglendar.files = {"/home/dccf87/org/work.org",
                   "/home/dccf87/org/home.org"}
orglendar.register(mytextclock)

markup = lain.util.markup

-- creat pomodoro widget

mypomo = awful.widget.progressbar()
mypomo:set_max_value(100)
--mypomo:set_background_color('#494B4F')
-- change to default beautiful.bg
mypomo:set_background_color(beautiful.bg_normal)
mypomo:set_color('#AECF96')
mypomo:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 20 }, stops = { { 0, "#AECF96" }, { 0.5, "#88A175" }, { 1, "#FF5656" } }})
mypomo:set_ticks(true)
mypomo:set_border_color('#474719')
mypomo:set_ticks_size(5)
mypomo:buttons(awful.util.table.join (
          awful.button ({}, 1, function()
            awful.util.spawn_with_shell("mypomo &")
          end),
          awful.button ({}, 3, function()
            awful.util.spawn_with_shell("pkill mypomo && mypomo -c")
          end)
      ))

mypomo_margin = wibox.layout.margin(mypomo, 2, 5)
mypomo_margin:set_top(4)
mypomo_margin:set_bottom(4)

mypomo_widget = wibox.widget.background(mypomo_margin)
mypomo_widget:set_bgimage(beautiful.widget_bg)


mypomo_tooltip = awful.tooltip({objects = {mypomo}})

local pomodoro_image_path = awful.util.getdir("config") .. "/pomodoro_icon.png"

mypomo_img = wibox.widget.imagebox()
mypomo_img:set_image(pomodoro_image_path)
mypomo_img:set_resize (true)


-- Mail updater
mailconf = '/home/dccf87/.config/mail_servers.conf'
local mails = { Gmail = {id = 'Gmail', file='/home/dccf87/.gunread', cnt=0},
          Durham = {id = 'Durham', file='/home/dccf87/.dunread', cnt=0},
          Icloud = {id = 'Icloud', file='/home/dccf87/.munread', cnt=0},
          AIP = {id = 'AIP', file='/home/dccf87/.aunread', cnt=0}}

local mailhoover = require("mailhoover")
for k, t in pairs(mails) do
    t.wibox= wibox.widget.textbox()
    t.wibox:set_text(k.."  ?  ")
    mailhoover.addToWidget(t.wibox, t.file, t.id)
end
-- Weather widget
yawn = lain.widgets.yawn(685783)

 --Alsa volume--{{{
---- my volume widget

vol = wibox.widget.textbox()
mc12 = wibox.widget.textbox()

alsacards = {main = {wibox = vol,
                    mixer = "xterm -e alsamixer",
                    header = 'Vol:',
                     card = "-c 0",
                  channel = "Master",
                     step = "5%" },
         mc12 = {  wibox  = mc12,
                    header = 'MC12:',
                    mixer = "xterm -e alsamixer -c 2",
                     card = "-c 2",
                  channel = "PCM",
                     step = "5%" }}

for k,t in pairs(alsacards) do 
    t.wibox:buttons(awful.util.table.join (
          awful.button ({}, 1, function()
            awful.util.spawn(t.mixer)
          end),
          awful.button ({}, 3, function()
            awful.util.spawn_with_shell(string.format("amixer %s set %s toggle", 
                t.card, t.channel))
            update_volume(t.wibox, t.header)
          end),
          awful.button ({}, 4, function()
            awful.util.spawn_with_shell(string.format("amixer %s set %s %s+", 
                t.card, t.channel, t.step))
            update_volume(t.wibox, t.header)
          end),
          awful.button ({}, 5, function()
            awful.util.spawn_with_shell(string.format("amixer %s set %s %s-", 
                t.card, t.channel, t.step))
            update_volume(t.wibox, t.header)
        end)
    ))
end

function update_volume(widget, header)
    if header == "MC12:" then 
       fd = io.popen("amixer get -c 2 PCM")
    else
       fd = io.popen("amixer sget Master")
    end
    local status = fd:read("*all")
    fd:close()
 
   local volume = string.match(status, "(%d?%d?%d)%%")
   volume_num = string.format("% 3d", volume)
 
   status = string.match(status, "%[(o[^%]]*)%]")

   if string.find(status, "on", 1, true) then
       -- For the volume numbers
       volume =header.."<span foreground='#7493d2'>"..volume_num.."% </span>"
   else
       -- For the mute button
       --
       volume =header.." <span foreground='#7493d2'> M </span>"
       
   end
   widget:set_markup(volume)
end
 
update_volume(vol, 'Vol:')
update_volume(mc12, 'MC12:')

local mytimer = timer({ timeout = 5.0 })
mytimer:connect_signal("timeout", function () 
    update_volume(vol, 'Vol:')
    update_volume(mc12, 'MC12:')
end)
--mytimer:stop()
mytimer:start()

------}}}





-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    --mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    -- pamodoro

    if s == 1 then 
        right_layout:add(wibox.widget.systray())
    end

    right_layout:add(mypomo_img)
    right_layout:add(mypomo_widget)
    if s == 1 then
        right_layout:add(mails.Gmail.wibox)
        right_layout:add(mails.Durham.wibox)
    end

    if s == 2 then
        right_layout:add(mails.Icloud.wibox)
        right_layout:add(mails.AIP.wibox)
    end

    right_layout:add(vol)
    right_layout:add(mc12)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
--
globalkeys = awful.util.table.join(
    awful.key({}, "Print", function ()
        local conky = get_conky()
        if conky then 
            for k,c in  pairs(conky) do
                if c.hidden then
                    c.ontop = true
                    c.hidden = false
                else
                    c.ontop = false
                    c.hidden = true
                end
            end
        else
            naughty.notify({text="no conky"})
        end
    end),
    awful.key({ modkey, }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey, }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "a", function() 
                                revelation({rule={class="conky-semi"}, is_excluded=true, curr_tag_only=true}) 
                             end),
    awful.key({            }, "F12", function () awful.util.spawn_with_shell("wacom_led_select", mouse.screen) end),


    awful.key({ modkey }, "`",
        function () drop(terminal)  end),

    --awful.key({ modkey }, "`",
        --function () quakeconsole[mouse.screen]:toggle() end),

    awful.key({modkey, }, "e",
         function () hints.focus() end),

    awful.key({ modkey,           }, "j",
       --add by gq
        function ()
            awful.client.focus.bydirection('down')
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.bydirection('up')
            if client.focus then client.focus:raise() end
        end),

    awful.key({ modkey,           }, "l",
        function ()
            awful.client.focus.bydirection('right')
            if client.focus then client.focus:raise() end
        end),

    awful.key({ modkey,           }, "h",
        function ()
            awful.client.focus.bydirection('left')
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    -- client move and resize
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.moveresize(0,-20,0,0)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.moveresize(0, 20,0,0)    end),
    awful.key({ modkey, "Shift"   }, "h", function () awful.client.moveresize(-20,0,0,0) end),
    awful.key({ modkey, "Shift"   }, "l", function () awful.client.moveresize(20,0,0,0)    end),


    awful.key({ modkey, "Control"   }, "h", function ()
        local llayout=awful.layout.get(mouse.screen)
        if llayout  == layouts[1] then
            awful.client.moveresize(0,0,-20,0) 
        else
            awful.tag.incmwfact(-0.1)
        end
       end),
    awful.key({ modkey, "Control"   }, "l", function () 
     local llayout  = awful.layout.get(mouse.screen)
     if llayout == layouts[1] then
         awful.client.moveresize(0,0,20,0)  
        else
            awful.tag.incmwfact(0.1)
        end
         end),
    awful.key({ modkey, "Control"   }, "j", function () awful.client.moveresize(0,0,0,20)    end),
    awful.key({ modkey, "Control"   }, "k", function () awful.client.moveresize(0,0,0,-20)    end),
    -- no two screen yet  --gq
    --  no I have two screen
    awful.key({ modkey,  }, "[", function () awful.screen.focus(1) end),
    awful.key({ modkey,  }, "]", function () awful.screen.focus(2) end),
    --awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    --confict with gq naviate among cliens
    --awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    --awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    --awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    --awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    --
    --awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    --awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function ()
    awful.util.spawn_with_shell("dmenu_run -i -p 'Run command:' -nb '" .. 
                beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. 
                "' -sb '" .. beautiful.bg_focus .. 
                "' -sf '" .. beautiful.fg_focus .. "'") 
        end),
    --usefuleval, nil,
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  usefuleval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    awful.key({ modkey }, "p", function() menubar.show() end),

    awful.key({modkey,   }, "c", function ()
        awful.prompt.run({  text = val and tostring(val),
            selectall = true,
            fg_cursor = "black",bg_cursor = "orange",
            prompt = "<span color='#ffffff'>Calc:</span> " }, mypromptbox[mouse.screen].widget,
            function(expr)
	       awful.util.eval("val="..expr)
	     cal_nau=naughty.notify({ text = expr .. ' = <span color="white">' .. val .. "</span>",
			       timeout = 30,
			       run = function() io.popen("echo -n ".. val .. " | xsel -i"):close()
			       naughty.destroy(cal_nau) 
			   end, })
	   end,
	   nil, awful.util.getdir("cache") .. "/calc")
	end),

    awful.key({ modkey,  }, "d", function ()
        local f = io.popen("xsel -o")
        local new_word = f:read("*a")
        f:close()

        if frame ~= nil then
            naughty.destroy(frame)
            frame = nil
            if old_word == new_word  then
                return
            end
        end

        old_word = new_word

        local fc = ""
        local f = io.popen("sdcv -n --utf8-output -u '牛津现代英汉双解词典' "..new_word.." | fold -s")

        for line in f:lines() do
            fc = fc..line..'\n'
        end

        f:close()
	--frame=naughty.notify({ text = fc, 
            --timeout = 30, width = 400})
        frame=naughty.notify({ text = '<span font_desc="Sans 8" color="white">'..fc..'</span>', 
            timeout = 30, width = 500})
    end),

    awful.key({modkey, "Shift"}, "d", function()
        info = true
        awful.prompt.run({ fg_cursor = "black",bg_cursor="orange",
	prompt = "<span color='#008DFA'>Dict:</span> "} , 
        mypromptbox[mouse.screen].widget,
        function(word)
                local f = io.popen("dict -d wn " .. word .. " 2>&1")
                local fr = ""
                for line in f:lines() do
                fr = fr .. line .. '\n'
	end
	f:close()
	naughty.notify({ text = '<span font_desc="Sans 8">'..fr..'</span>', timeout = 30, width = 400
        })
        end,
        nil, awful.util.getdir("cache") .. "/dict") 
      end)
)

-- obsolete
--awful.key({ modkey, "Shift"   }, "r",      function (c) c:refresh()                       end),

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "f",      awful.client.floating.toggle),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        --awful.tag.viewidx(i)
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),

        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))

end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c.opacity=1; c:raise(); end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
-- add keychains 
--
-- {{{ keychains configuration

--root.keys(globalkeys)
keychains.init(globalkeys)

keychains.add({modkey, "Shift"},"w","Web pages","/usr/share/icons/hicolor/16x16/apps/chromium.png",{
        p   =   {
            func    =   function()
                open_url("http://awesome.naquadah.org/doc/api/")
            end,
            info    =   "awesome - api page"
        },
        a   =   {
            func    =   function()
                open_url("http://awesome.naquadah.org/")
            end,
            info    =   "awesome web page"
        },
        w   =   {
            func    =   function()
                open_url("http://awesome.naquadah.org/wiki/Main_Page")
            end,
            info    =   "awesome wiki"
        },
        u   =   {
            func    =   function()
                open_url("https://aur.archlinux.org/")
            end,
            info    =   "Arch aur"
        },
        k   =   {
            func    =   function()
                open_url("https://www.archlinux.org/packages/")
            end,
            info    =   "Arch packages"
        },
        t   =   {
            func = function()
                open_url("http://translate.google.com/")
            end,
            info    =   "Google translation"
        }
    })

keychains.add({modkey, "Shift"},"p","Pomodoro", "/home/dccf87/.config/awesome/pomodoro.png",{
        b   =   {
            func    =   function()
                awful.util.spawn_with_shell("mypomo &")
            end,
            info    =   "Pomodoro - start"
        },
        c   =   {
            func    =   function()
                awful.util.spawn_with_shell("pkill mypomo && mypomo -c")
            end,
            info    =   "Pomodoro - cancel"
        },
    })

keychains.add({modkey, "Shift"},"u","Utils", "",{
        c   =   {
            func    =   function()
                awful.util.spawn_with_shell("restart_conky.sh &")
            end,
            info    =   "Restart conky"
        },

        w = {
            func = function()
                yawn.show(18)
            end,
            info = "Weather"
        },
    })

keychains.add({modkey, }, "z", "Switch to Tag", "", {
    q   =   {
        func    =   function()
            awful.screen.focus_relative(1)
            awful.tag.viewonly(tags[mouse.screen][1])
        end,
        info    =   "Next screen tag - 1"
    },

    w   =   {
        func    =   function()
            awful.screen.focus_relative(1)
            awful.tag.viewonly(tags[mouse.screen][2])
        end,
        info    =   "Next screen tag - 2"
    },

    e   =   {
        func    =   function()
            awful.screen.focus_relative(1)
            awful.tag.viewonly(tags[mouse.screen][3])
        end,
        info    =   "Next screen tag - 3"
    },

    r   =   {
        func    =   function()
            awful.screen.focus_relative(1)
            awful.tag.viewonly(tags[mouse.screen][4])
        end,
        info    =   "Next screen tag - 4"
    },

    t   =   {
        func    =   function()
            awful.screen.focus_relative(1)
            awful.tag.viewonly(tags[mouse.screen][5])
        end,
        info    =   "Next screen tag - 5"
    },

    y   =   {
        func    =   function()
            awful.screen.focus_relative(1)
            awful.tag.viewonly(tags[mouse.screen][6])
        end,
        info    =   "Next screen tag - 6"
    },
    u   =   {
        func    =   function()
            awful.screen.focus_relative(1)
            awful.tag.viewonly(tags[mouse.screen][7])
        end,
        info    =   "Next screen tag - 7"
    },
    i   =   {
        func    =   function()
            awful.screen.focus_relative(1)
            awful.tag.viewonly(tags[mouse.screen][8])
        end,
        info    =   "Next screen tag - 8"
    },
    o   =   {
        func    =   function()
            awful.screen.focus_relative(1)
            awful.tag.viewonly(tags[mouse.screen][9])
        end,
        info    =   "Next screen tag - 9"
    },
})

-- }}}
--no need because that the keychinas.init will do it
--root.keys(globalkeys)
-- }}}
keychains.start(15)

-- {{{ Rules
--
       --callback = function (c)
            --local clients = client.get()
            --for i, c2 in pairs(clients) do
               --if c.class == c2.class then
                   --c.screen = c2.screen
               --end
            --end
            --end
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons },
        },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Gimp" },
      properties = { floating = true } },

      { rule = { class = "Display" },
      properties = { floating = true } },

    { rule = { class = "XVroot" },
      properties = { floating = true } },

    --{ rule = {class = "Terminal"},
      --properties = {slave=true},callback = function(c) awful.client.setslave(c) end},
    -- Set Firefox to always map on tags number 2 of screen 1.
     { rule = { class = "Firefox" },
       properties = {maximized_horizontal=false,maximized_vertical=false,floating=true},
       callback= function(c) awful.client.movetotag(tags[mouse.screen][3],c) 
            awful.tag.viewonly(tags[mouse.screen][3])
       end},

     { rule = { name = "Figure" },
        properties = {maximized_horizontal=false,maximized_vertical=false,floating=true,
        focus=true},
        callback=function(c) 
            add_titlebar(c)
        end
      },

     { rule = { name = "IDL" },
        properties = {maximized_horizontal=false,maximized_vertical=false,floating=true,
        focus=true},
        callback=function(c) add_titlebar(c) end 
      },

     { rule = { name = "Gnuplot" },
        properties = {maximized_horizontal=false,maximized_vertical=false,floating=true,
        focus=true},
        callback=function(c) add_titlebar(c) end
      },
     { rule = { name = "Choose a filename" },
        properties = {maximized_horizontal=false,maximized_vertical=false,
        focus=true},
        callback=function(c) add_titlebar(c) end
      },
    { rule = { type = "dialog"}, properties={}, 
        callback=function(c) add_titlebar(c) end},
    { rule = { class = "VirtualBox" },properties={}, callback=function(c) awful.client.movetotag(tags[mouse.screen][8],c)
      end},
    { rule = { name = "Windows7" },properties={maximized_horizontal=true,maximized_vertical=true}, callback=function(c) awful.client.movetotag(tags[mouse.screen][8],c)
      end},
    { rule = { name = "Windows8" },properties={},callback=function(c) awful.client.movetotag(tags[mouse.screen][8],c)
      end},
     { rule = { class = "Tilda" },
       properties = {maximized_horizontal=false,maximized_vertical=false,floating=true},
    },

     { rule = { name = "Guake!" },
       properties = {maximized_horizontal=false,maximized_vertical=false,floating=true},
    },

     { rule = { name = "Guake" },
       properties = {maximized_horizontal=false,maximized_vertical=false,floating=true},
    },
    { rule = { class = "conky-semi" },
       properties = {floating=true,
                     sticky = true,
                     ontop = false,
                     focusable = false,
                     hidden = true,
                     size_hints = {"program_position", "program_size"}
                     },
    },
     { rule = { name = "gqpc" },
       properties = {maximized_horizontal=false,maximized_vertical=false,floating=true},
    },
     { rule = { name = "PS3 Media Server" },
       properties = {maximized_horizontal=false,maximized_vertical=false,floating=true,
      tag=tags[1][9]},
    }

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)

    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
         awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    --local titlebars_enabled = true
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then--{{{
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end--}}}
end)
--{{{ mail updater
local mail_timer = timer({timeout = 60.0})
mail_timer:connect_signal("timeout", function()
    for k,t in pairs(mails) do 
        local fg = io.open(t.file)
        local l = nil
        if fg~= nil then 
            l = fg:read("*l")
            if l == nil or tonumber(l) == 0 then
                l = t.id..":<span> <b> 0 </b> </span>"
                t.cnt=0
            else
                if tonumber(l) > t.cnt then
                    tosay = "you got "..tostring(tonumber(l)-t.cnt)..t.id
                    --os.execute("esp "..tosay.." &")
                end
                t.cnt=tonumber(l)
                l = t.id..":<span color='red'> <b> "..l.." </b> </span>"
            end
        else
            l = t.id.." ? "
            t.cnt=0
        end
        fg:close()

        t.wibox:set_markup(l)
        os.execute("unread.py "..mailconf.." "..t.id.." > "..t.file .. " &")
    end
    os.execute("myip > ~/Dropbox/myip.txt &")
end)

--mail_timer:stop()
mail_timer:start()--}}}


--client.add_signal("focus", function(c) c.border_color = beautiful.border_focus
   --c.opacity=1 
   --end)
--client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal 
    --c.opacity=0.9
--end)

--awful.util.spawn("/home/dccf87/.scripts/get_dbus.sh")
--awful.util.spawn("tilda &")
--awful.util.spawn("udiskie &")


-- }}}
--
--{{{ Additonal functions


function open_url(url)
    awful.util.spawn_with_shell("ffurl "..url)
end

function run_once(prg,arg_string,pname)
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    if not arg_string then 
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " &)")
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " " .. arg_string .. " &)")
    end
end

function get_conky()
    local clients = client.get()
    local conky = {}
    local i = 1
    for key, c in pairs(clients) do
        if c.class == "conky-semi" then
            conky[i] = c
            i = i + 1
        end
    end
    return conky
end

function get_client(s)
    local clients = client.get()
    local mc = nil
    local i = 1
    while clients[i]
    do
        if clients[i].class == s
        then
            mc = clients[i]
        end
        i = i + 1
    end
    return mc
end

function raise_conky()
    local conky = get_conky()
    if conky
    then
        conky.ontop = true
    end
end

function lower_conky()
    local conky = get_conky()
    if conky
    then
        conky.ontop = false
    end
end

--}}}
--

function add_titlebar(c) --{{{
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(awful.titlebar.widget.iconwidget(c))

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(awful.titlebar.widget.floatingbutton(c))
    right_layout:add(awful.titlebar.widget.maximizedbutton(c))
    right_layout:add(awful.titlebar.widget.stickybutton(c))
    right_layout:add(awful.titlebar.widget.ontopbutton(c))
    right_layout:add(awful.titlebar.widget.closebutton(c))

    -- The title goes in the middle
    local title = awful.titlebar.widget.titlewidget(c)
    title:buttons(awful.util.table.join(
            awful.button({ }, 1, function()
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
            end),
            awful.button({ }, 3, function()
                client.focus = c
                c:raise()
                awful.mouse.client.resize(c)
            end)
            ))

    -- Now bring it all together
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)
    layout:set_middle(title)

    awful.titlebar(c):set_widget(layout)
end

--}}}

--{{{ pomodoro functions
--
--local pomodoro_work_time = 60 * 30
--local pomodoro_rest_time = 60 * 5

--local pomo_timer = timer({timout = pomodoro_work_time})

--function pomodoro_star()
--}}}
 --{{{Auto Spawn
awful.util.spawn_with_shell("/home/dccf87/.scripts/get_dbus.sh")
awful.util.spawn_with_shell("/home/dccf87/bin/setcolor")
--run_once("guake", nil, "/usr/bin/python2 /usr/bin/guake")
run_once("offlineimap", nil, "/usr/bin/python2 /usr/bin/offlineimap")

-- replaced by systemd
--run_once("devmon","> ~/.devmon.log 2>&1", "/bin/bash /usr/bin/devmon")
run_once("fcitx")
run_once("clipit")
--run_once("dropboxd",nil, "/opt/dropbox/dropbox")
--run_once("conky -c /home/dccf87/.config/conky/conkyrc_grey")
--run_cone("conky -c /home/dccf87/.config/conky/conkyrc_grey")
--run_once("conky -c /home/dccf87/.config/conky/conkyrc2")
--run_once("emacs", "--daemon", "emacs --daemon")
--run_once("eamcs", "--daemon --with-x-toolkit=luci", "emacs --daemon --with-x-toolkit=luci")
--run_once_bg("dropboxd", "dropbox")
--run_once_bg("emacs-daemon", "emacs --daemon")

-- }}}

function usefuleval(s)--{{{
        local f, err = load("return "..s);
        ----local _ENV=_G
        if not f then
                f, err = load(s);
        end
        
        if f then
                --setfenv(f, _G);
                local ret = { pcall(f) };
                if ret[1] then
                        -- Ok
                        table.remove(ret, 1)
                        local highest_index = #ret;
                        for k, v in pairs(ret) do
                                if type(k) == "number" and k > highest_index then
                                        highest_index = k;
                                end
                                ret[k] = select(2, pcall(tostring, ret[k])) or "<no value>";
                        end
                        -- Fill in the gaps
                        for i = 1, highest_index do
                                if not ret[i] then
                                        ret[i] = "nil"
                                end
                        end
                        if highest_index > 0 then
                                --mypromptbox[mouse.screen].text = awful.util.escape("Result"..(highest_index > 1 and "s" or "")..": "..tostring(table.concat(ret, ", ")));
                                naughty.notify({ text=awful.util.escape("Result"..(highest_index > 1 and "s" or "")..": "..tostring(table.concat(ret, ", ")))
                                , screen = mouse.screen });
                        else
                                --mypromptbox[mouse.screen].text = "Result: Nothing";
                                naughty.notify({ text="Result: Nothing" , screen = mouse.screen });
                        end
                else
                        err = ret[2];
                end
        end
        if err then
                naughty.notify({ text=awful.util.escape("Error: "..tostring(err)) , screen = mouse.screen });
                --mypromptbox[mouse.screen].text = awful.util.escape("Error: "..tostring(err));
        end
end--}}}


os.execute("feh --bg-fill -z -r ~/.config/wallpapers &")

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


function debuginfo( message )
    nid = naughty.notify({ text = message, timeout = 10 })
end

function test_match()
    local clientlist = awful.client.visible()
    for i,thisclient in pairs(clientlist) do 
        --x = awful.rules.match
        x = awful.rules.match(thisclient, {class="Firefox"}, true)
        debuginfo(tostring(x))
    end
end

--ilog:start()
