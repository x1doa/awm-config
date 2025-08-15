local gears = require 'gears'
local beautiful = require 'beautiful'
local awful = require 'awful'
local wibox = require 'wibox'

-- Taken from the PR number 132 at https://github.com/raexera/yoru/pull/132

local pfp_imgbox =
    wibox.widget(
    {
        image = beautiful.pfp,
        resize = true,
        id = "image",
        clip_shape = gears.shape.circle,
        halign = "center",
        valign = "center",
        widget = wibox.widget.imagebox
    }
)

	local function pfp(name)
		local path = "/var/lib/AccountsService/icons/" .. name
		local img = gears.surface.load_uncached(path)
		if img ~= nil then pfp_imgbox:set_image(img) end
	end



awful.spawn.easy_async_with_shell(
    [[
    sh -c 'whoami'
    ]],
    function(stdout)
        local stdout = stdout:gsub("%\n", "")
        pfp(stdout)
    end
)

return wibox.widget {
  pfp_imgbox,
  widget = wibox.container.place
}
