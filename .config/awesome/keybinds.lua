local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local naughty       = require("naughty")
local menubar       = require("menubar")
local beautiful     = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
                      require("awful.hotkeys_popup.keys")


globalkeys = gears.table.join(
-- Awesome Keybinds
awful.key({super       }, "s", hotkeys_popup.show_help, {description="show help",      group="awesome"}),
awful.key({super, ctrl }, "r", awesome.restart,         {description="reload awesome", group="awesome"}),
awful.key({super, shift}, "q", awesome.quit,            {description="quit awesome",   group="awesome"}),

-- Layout Keybinds
awful.key({super       }, "l",     function() awful.tag.incmwfact(0.05)           end, {description="increase master width factor",     group="layout"}),
awful.key({super       }, "h",     function() awful.tag.incmwfact(-0.05)          end, {description="decrease master width factor",     group="layout"}),
awful.key({super       }, "space", function() awful.layout.inc( 1)                end, {description="select next",                      group="layout"}),
awful.key({super, shift}, "space", function() awful.layout.inc(-1)                end, {description="select previous",                  group="layout"}),
awful.key({super, shift}, "h",     function() awful.tag.incnmaster( 1, nil, true) end, {description="inc the number of master clients", group="layout"}),
awful.key({super, shift}, "l",     function() awful.tag.incnmaster(-1, nil, true) end, {description="dec the number of master clients", group="layout"}),
awful.key({super, ctrl}, "h",      function() awful.tag.incncol( 1, nil, true)    end, {description="increase the number of columns",   group="layout"}),
awful.key({super, ctrl}, "l",      function() awful.tag.incncol(-1, nil, true)    end, {description="decrease the number of columns",   group="layout"}),

-- Client Keybinds
awful.key({super},        "tab", function() awful.client.focus.history.previous()
						 if client.focus then
						   client.focus:raise()
						 end
				    end,                                      {description = "go back",                            group = "client"}),
awful.key({super},        "j",   function() awful.client.focus.byidx( 1) end, {description = "focus next by index",                group = "client"}),
awful.key({super},        "k",   function() awful.client.focus.byidx(-1) end, {description = "focus previous by index",            group = "client"}),
awful.key({super, shift}, "j",   function() awful.client.swap.byidx( 1)  end, {description = "swap with next client by index",     group = "client"}),
awful.key({super, shift}, "k",   function() awful.client.swap.byidx(-1)  end, {description = "swap with previous client by index", group = "client"}),
awful.key({super},        "u",   awful.client.urgent.jumpto,                  {description = "jump to urgent client",              group = "client"}),

-- Launchers
awful.key({super}, "Return", function() awful.spawn(terminal)         end, {description = "open a terminal",              group = "launcher"}),
awful.key({super}, "p",      function() awful.util.spawn("dmenu_run") end, {description = "show the menubar",             group = "launcher"}),


-- Screen Keybinds
awful.key({super, ctrl}, "j", function() awful.screen.focus_relative( 1) end, {description = "focus the next screen",     group = "screen"}),
awful.key({super, ctrl}, "k", function() awful.screen.focus_relative(-1) end, {description = "focus the previous screen", group = "screen"}),

-- Tags Keybinds
awful.key({super}, "Left" ,  awful.tag.viewprev,        {description = "view previous", group = "tag"}),
awful.key({super}, "Right",  awful.tag.viewnext,        {description = "view next",     group = "tag"}),
awful.key({super}, "Escape", awful.tag.history.restore, {description = "go back",       group = "tag"})
)
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({super}, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
	-- Toggle tag display.
        awful.key({super, ctrl}, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({super, shift}, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({super, ctrl, shift}, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
	)
	end

clientkeys = gears.table.join(
awful.key({super       }, "f",      function(c) c.fullscreen = not c.fullscreen c:raise() end,	{description="toggle fullscreen",        group="client"}),
awful.key({super, shift}, "c",      function(c) c:kill() end,					{description="close",                    group="client"}),
awful.key({super, ctrl }, "space",  awful.client.floating.toggle,				{description="toggle floating",          group="client"}),
awful.key({super, ctrl }, "Return", function(c) c:swap(awful.client.getmaster()) end,		{description="move to master",           group="client"}),
awful.key({super       }, "o",      function(c) c:move_to_screen()               end,		{description="move to screen",           group="client"}),
awful.key({super       }, "t",      function(c) c.ontop = not c.ontop            end,		{description="toggle keep on top",       group="client"}),
awful.key({super       }, "n",      function(c) c.minimized = true               end,		{description="minimize",                 group="client"}),
awful.key({super       }, "m",      function(c) c.maximized = not c.maximized c:raise() end,	{description="(un)maximize",             group="client"}),
awful.key({super, ctrl }, "m",      function(c) c.maximized_vertical = not c.maximized_vertical c:raise()  end,
												{description="(un)maximize vertically",  group="client"}),
awful.key({super, shift}, "m",      function(c) c.maximized_horizontal = not c.maximized_horizontal c:raise() end,
												{description="(un)maximize horizontally", group="client"})
)

clientbuttons = gears.table.join(
    awful.button({     }, 1, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}) end),
    awful.button({super}, 1, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}) awful.mouse.client.move(c) end),
    awful.button({super}, 3, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}) awful.mouse.client.resize(c) end)
)

-- Set keys
root.keys(globalkeys)
