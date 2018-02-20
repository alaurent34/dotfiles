local awful     = require("awful")
local beautiful = require("beautiful")
local menubar   = require("menubar")
local lain      = require("lain")
local wibox     = require("wibox")
local vicious   = require("vicious")

require("rc.utils")

-- {{{ Wibox
markup = lain.util.markup

--{{ Textclock }}
mytextclock = awful.widget.watch(
    "date +'%a %d %b, %R'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)

--{{ Calendar }}
theme.cal = lain.widget.calendar({
    attach_to = { mytextclock },
    notification_preset = {
        font = "Inconsolata 11",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})


-- {{ Time and Date Widget }} --
tdwidget = wibox.widget.textbox()
vicious.register(tdwidget, vicious.widgets.date, '<span font="Inconsolata 11" color="#AAAAAA" background="#1F2428"> %A, %b %d %H:%M </span>', 20)

--{{ Coretemp }} --
tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. coretemp_now .. "°C "))
    end
})

--{{ Memory }} --
memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end
})

--{{ CPU Load }}
cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
cpuwidget = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})

--{{ Storage }} -- 
fsicon = wibox.widget.imagebox(beautiful.widget_hdd)
theme.fs = lain.widget.fs({
    options  = "--exclude-type=tmpfs",
    notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = "Inconsolata", font_size = 9},
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. fs_now["/"].percentage .. "% "))
    end
})


--{{ Battery Widget }} --
baticon = wibox.widget.imagebox(beautiful.widget_battery)
batwidget = lain.widget.bat({
    ac = "AC",
    batteries = {"BAT0", "BAT1"},
    settings = function()
        if bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                widget:set_markup(markup.font(theme.font, " AC "))
                baticon:set_image(theme.widget_ac)
                return
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                baticon:set_image(theme.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                baticon:set_image(theme.widget_battery_low)
            else
                baticon:set_image(theme.widget_battery)
            end
            widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
        else
            widget:set_markup(markup.font(theme.font, " AC "))
            baticon:set_image(theme.widget_ac)
        end
    end
})

-- TODO: trouver la version de lain pour pas que ça plante.
-- {{ Volume Widget }} --
volicon = wibox.widget.imagebox(beautiful.widget_vol)
volumewidget = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(beautiful.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            volicon:set_image(beautiful.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            volicon:set_image(beautiful.widget_vol_low)
        else
            volicon:set_image(beautiful.widget_vol)
        end

        widget:set_text(" " .. volume_now.level .. "% ")
    end,
    timeout = 0.5
})

-- Mail IMAP check
-- mailicon = wibox.widget.imagebox(beautiful.widget_mail)
-- mailicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.spawn(mail) end)))
-- mailwidget = wibox.widget.background(lain.widget.imap({
--     timeout  = 180,
--     server   = "imap.gmail.com",
--     mail     = "", -- TODO use `pass` to get password from encrypted files.
--     password = "",
--     settings = function()
--         if mailcount > 0 then
--             widget:set_text(" " .. mailcount .. " ")
--             mailicon:set_image(beautiful.widget_mail_on)
--         else
--             widget:set_text("")
--             mailicon:set_image(beautiful.widget_mail)
--         end
--     end
-- }), "#313131")

-- MPD
-- function mpd_bar(pass)
--     local naughty = require("naughty")
--     naughty.notify({ title = "My password", text = pass })
-- TODO: need awesome v3.6
-- awful.spawn.easy_async("pass" .. " " .. "personnel/mpd", function(stdout, stderr, r, c)
--     if c == 0 then
--         mpd_pass = stdout
--     end
-- end)
mpdicon = wibox.widget.imagebox(beautiful.widget_music)
mpdicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.spawn_with_shell(terminal_cmd .. mpdclient) end)))
mpdwidget = lain.widget.mpd({
    music_dir = home_dir .. "/Musique",
    password = "q1w2e3r4", -- TODO use `pass` to get password from encrypted files.
    -- password = mpd_pass,
    settings = function()
        if mpd_now.state == "play" then
            artist = " " .. mpd_now.artist .. " "
            title  = mpd_now.title  .. " "
            mpdicon:set_image(beautiful.widget_music_on)
        elseif mpd_now.state == "pause" then
            artist = " mpd "
            title  = "paused "
        else
            artist = ""
            title  = ""
            mpdicon:set_image(beautiful.widget_music)
        end

        widget:set_markup(markup("#EA6F81", artist) .. title)
    end
})
-- mpdwidgetbg = wibox.container.background(mpdwidget, "#313131")
-- local glib = require( "lgi" ).GLib
-- glib.idle_add(glib.PRIORITY_HIGH_IDLE, function() mpdwidget.password = io.popen():lines()() end)
-- end
