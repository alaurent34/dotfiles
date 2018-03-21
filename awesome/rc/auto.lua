local awful = require("awful")
local utils = require("rc.utils")

-- {{{ Autostart applications
run_once("/home/drayer34/bin/set_keyboard")
run_once("nm-applet")
--run_once("system-config-printer-applet")
run_once("urxvtd")
run_once("xrdb ~/.Xresources")
run_once("xcompmgr -c -C -t-5 -l-5 -r4.2 -o.55 &")
run_once(redshift.." & disown")
run_once("keynav")

-- Conky: if started kill and start again, otherwise start.
if not pgrep("conky") then
    if screen:count() <= 1 then
        awful.spawn.easy_async("bash -c 'sleep 5 ; conky -c ~/.conkyrc-infos.lua -a top_right -x 30 -y 45 -d ; conky -c ~/.conkyrc-date.lua'", async_dummy_cb)
    else
        awful.spawn.easy_async("bash -c 'sleep 5 ; conky -c ~/.conkyrc-infos.lua -a top_right -x -1900 -y 45 -d ; conky -c ~/.conkyrc-date.lua'", async_dummy_cb)
    end
else
    pkill("conky")
    if screen:count() <= 1 then
        awful.spawn.easy_async("bash -c 'conky -c ~/.conkyrc-infos.lua -a top_right -x 30 -y 45 -d ; conky -c ~/.conkyrc-date.lua'", async_dummy_cb)
    else
        awful.spawn.easy_async("bash -c 'conky -c ~/.conkyrc-infos.lua -a top_right -x -1900 -y 45 -d ; conky -c ~/.conkyrc-date.lua'", async_dummy_cb)
    end
end
-- }}}
