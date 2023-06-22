local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi
local markup = lain.util.markup
local os = os
local theme = {}

-- path to this theme
theme.confdir = 
os.getenv("HOME").."/.config/awesome/themes/multicolor"


-- path to wallpaper
theme.wallpaper = theme.confdir.."/wall.png"
-- default font syswide
theme.font = "Iosevka Term 16"

-- bar color
theme.bg_normal = "#000000"

-- tag number color
theme.fg_normal = "#666666"
-- focused tag number color
theme.fg_focus = "#aaaaaa"

-- window border width (in pixels)
theme.border_width  = dpi(1)
-- window border color
theme.border_normal = "#222222"
-- window border color when focused
theme.border_focus  = "#f7ca88"

-- menu width (in pixels)
theme.menu_width = dpi(200)
-- menu height (in pixels)
theme.menu_height = dpi(23)
-- menu text color
theme.menu_fg_normal =  "#666666"
-- menu background color
theme.menu_bg_normal = "#000000"
-- menu focused background color
theme.menu_bg_focus = "#666666"
-- menu focused text color
theme.menu_fg_focus = "#ffffff"


-- create clock widget
local mytextclock = wibox.widget.textclock(markup("#aaaaaa", "%H%M"))
mytextclock.font = theme.font

-- create battery widget
local bat = lain.widget.bat({
    settings = function()
        local bat_level = bat_now.perc

        if bat_now.ac_status == 1 then
            bat_status_clr = "#aaaaaa"
        else
            bat_status_clr = "#666666"
        end

        widget:set_markup(
            markup.fontfg(theme.font, bat_status_clr, bat_level))
    end
})

-- create volume widget
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            vol_status_clr = "#666666"
        else
            vol_status_clr = "#aaaaaa"
        end

        widget:set_markup(
                markup.fontfg(theme.font, vol_status_clr, volume_now.level))
    end
})


function theme.at_screen_connect(s)
    -- load the wallpaper
    gears.wallpaper.maximized(theme.wallpaper, s, true)

    -- tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- create prompt box widget
    s.mypromptbox = awful.widget.prompt()

    -- create taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- create the bar
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(25), bg = theme.bg_normal, fg = theme.fg_normal })

    -- create separator widgets
    local spr1 = wibox.widget.textbox(" ")
    local spr2 = wibox.widget.textbox(markup.fontfg(theme.font, "#aaaaaa", " | "))

    -- add widgets to bar
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        -- leftside
        {
            layout = wibox.layout.fixed.horizontal,
            --s.mylayoutbox,
            s.mytaglist,
            spr1,
            s.mypromptbox,
        },
        -- middle
        nil,
        -- rightside
        {
            layout = wibox.layout.fixed.horizontal,
            -- wibox.widget.systray(),
            mytextclock,
            spr2,
            bat.widget,
            spr2,
            theme.volume.widget,
        },
    }
end

return theme
