require("awful.hotkeys_popup.keys")
require("awful.autofocus")
local gears         = require("gears")
local awful         = require("awful")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup")

local mytable       =   awful.util.table or gears.table


-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true
        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Error!",
            text = tostring(err)
        }
        in_error = false
    end)
end


-- run each command in cmd_arr on startup
cmd_arr = {}
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(
            string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end
run_once(cmd_arr)

local chosen_theme = "hika"
local terminal     = "alacritty"
local editor       = "nvim"
local browser      = "librewolf"
local modkey       = "Mod4"
local altkey       = "Mod1"
awful.util.terminal = terminal

-- list of tags
awful.util.tagnames = { "1", "2" }

-- list of layouts (first element will be the default)
awful.layout.layouts = {
    awful.layout.suit.tile,
}


-- initialize theme
beautiful.init(
    string.format(
        "%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))


-- setup the Awesome submenu
local myawesomemenu = {
   { "Keybindings", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "Manpage", string.format("%s -e man awesome", terminal) },
   { "Edit rc.lua", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
   { "Restart", awesome.restart },
   { "Quit", function() awesome.quit() end },
}

-- setup the menu
awful.util.mymainmenu = freedesktop.menu.build {
    -- items before program list
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        { "Open terminal", terminal },
        { "", "" }, -- separator
    },
    -- items after program list
    after = {
    }
}


-- reload wallpaper when resolution changes
screen.connect_signal("property::geometry", function(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)


-- if there is only one window open, change it's border size to 0
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)


-- create a bar for each screen
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)


-- mouse binds
root.buttons(mytable.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))


-- general keybindings
globalkeys = mytable.join(
    -- kill all notification popups
    awful.key({ "Control" }, "space",
        function()
            naughty.destroy_all_notifications()
        end,
            {description = "destroy all notifications", group = "hotkeys"}),


    -- view keybindings
    awful.key({ modkey }, "s",
        hotkeys_popup.show_help,
            {description="show help", group="awesome"}),


    -- focus window downwards to focused one
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
            {description = "focus down", group = "client"}),

    -- focus window upwards to focused one
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
            {description = "focus up", group = "client"}),

    -- focus window leftwards to focused one
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
            {description = "focus left", group = "client"}),

    -- focus window rigthwards to focused one
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
            {description = "focus right", group = "client"}),


    -- open the menu
    awful.key({ modkey }, "w",
        function ()
            awful.util.mymainmenu:show()
        end,
            {description = "show main menu", group = "awesome"}),


    -- focus previous screen
    awful.key({ modkey, "Control" }, "j",
        function ()
            awful.screen.focus_relative(1)
        end,
            {description = "focus the next screen", group = "screen"}),

    -- focus next screen
    awful.key({ modkey, "Control" }, "k",
        function ()
            awful.screen.focus_relative(-1)
        end,
            {description = "focus the previous screen", group = "screen"}),


    -- toggle bar visibility
    awful.key({ modkey }, "b",
        function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
            {description = "toggle bar", group = "awesome"}),


    -- restart awesomemwm
    awful.key({ modkey, "Control" }, "r",
        awesome.restart,
            {description = "reload awesome", group = "awesome"}),

    -- close awesomewm
    awful.key({ modkey, "Shift"   }, "q",
    awesome.quit,
            {description = "kill awesome", group = "awesome"}),


    -- increase master window's width
    awful.key({ modkey, altkey }, "l",
        function () 
            awful.tag.incmwfact( 0.05)
        end,
            {description = "increase master width factor", group = "layout"}),

    -- decrease master window's width
    awful.key({ modkey, altkey }, "h",
        function ()
            awful.tag.incmwfact(-0.05)
        end,
            {description = "decrease master width factor", group = "layout"}),


    -- raise main volume
    awful.key({ modkey, "Shift" }, "k",
        function ()
            os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end,
            {description = "volume up", group = "hotkeys"}),

    -- lower main volume
    awful.key({ modkey, "Shift" }, "j",
        function ()
            os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end,
            {description = "volume down", group = "hotkeys"}),

    -- mute main volume
    awful.key({ modkey, "Shift"}, "m",
        function ()
            os.execute(
                string.format(
                "amixer -q set %s toggle", 
                beautiful.volume.togglechannel or beautiful.volume.channel))

            beautiful.volume.update()
        end,
            {description = "toggle mute", group = "hotkeys"}),


    -- run the browser
    awful.key({ modkey }, "q",
        function ()
            awful.spawn(browser)
        end,
            {description = "open default browser ("..browser..")", group = "launcher"}),

    -- run the terminal
    awful.key({ modkey, }, "Return",
        function ()
            awful.spawn(terminal)
        end,
            {description = "open default terminal ("..terminal..")", group = "launcher"}),


    -- the run prompt
    awful.key({ modkey }, "r",
        function ()
            awful.screen.focused().mypromptbox:run()
        end,
            {description = "run prompt", group = "launcher"})


    -- commented out because i might want to use this at some point
    -- awful.key({ modkey }, "space",
    --     function ()
    --         awful.layout.inc( 1)
    --     end,
    --         {description = "switch to next screen layout", group = "layout"})
)


-- window keybindings
clientkeys = mytable.join(
    -- toggle fullscreen for focused window
    awful.key({ modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
            {description = "toggle fullscreen", group = "client"}),

    -- kill focused window
    awful.key({ modkey, "Shift" }, "c", 
        function (c)
            c:kill()
        end,
            {description = "close", group = "client"}),

    awful.key({ modkey, "Control" }, "space",
        awful.client.floating.toggle,
            {description = "toggle floating", group = "client"}),

    -- make the focused window a master window
    awful.key({ modkey, "Control" }, "Return",
        function (c)
            c:swap(awful.client.getmaster())
        end,
            {description = "move to master", group = "client"})
)


-- tag navigation keybindings
for i = 1, #awful.util.tagnames do
    globalkeys = mytable.join(globalkeys,
        -- focus a tag
        awful.key({ modkey }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view tag #"..i, group = "tag"}),

        -- move focused window to a tag
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                end
            end,
            {description = "move focused client to tag #"..i, group = "tag"})
    )
end


-- initialize the keybindings
root.keys(globalkeys)


-- rules
awful.rules.rules = {
    -- apply these rules to new windows
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
                callback = awful.client.setslave,
                focus = awful.client.focus.filter,
                keys = clientkeys,
                screen = awful.screen.preferred,
                placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                size_hints_honor = false
        }
    },

    -- these programs will always be floating
    { 
        rule_any = {
            instance = {},
            class = { "Tor Browser" },
            name = {},
            role = {}
        },
        properties = { floating = true }
    }
}


-- switch border color of focused window
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


-- switch to parent window after killing child
local function backham()
    local s = awful.screen.focused()
    local c = awful.client.focus.history.get(s, 0)
    if c then
        client.focus = c
        c:raise()
    end
end
