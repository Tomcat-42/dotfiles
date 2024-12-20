local system = require("colors.system")

function hex2rgb(hex)
  local hex = hex:gsub("#", "")
  return string.format("%s, %s, %s", tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)),
    tonumber("0x" .. hex:sub(5, 6)))
end

local theme                        = {}

-- Default settings
theme.fg                           = system.base00
theme.bg                           = system.base07

-- Genaral colours
theme.success_fg                   = system.base0C
theme.loaded_fg                    = system.base0D
theme.error_fg                     = system.base00
theme.error_bg                     = system.base08

-- Warning colours
theme.warning_fg                   = system.base00
theme.warning_bg                   = system.base0E

-- Notification colours
theme.notif_fg                     = system.base00
theme.notif_bg                     = system.base05

-- Menu colours
theme.menu_fg                      = system.base05
theme.menu_bg                      = system.base00
theme.menu_selected_fg             = system.base00
theme.menu_selected_bg             = system.base0B

theme.menu_title_bg                = system.base00
theme.menu_primary_title_fg        = system.base05
theme.menu_secondary_title_fg      = system.base04

theme.menu_disabled_fg             = system.base03
theme.menu_disabled_bg             = theme.menu_bg
theme.menu_enabled_fg              = theme.menu_fg
theme.menu_enabled_bg              = theme.menu_bg
theme.menu_active_fg               = system.base0F
theme.menu_active_bg               = theme.menu_bg

-- Proxy manager
theme.proxy_active_menu_fg         = system.base05
theme.proxy_active_menu_bg         = system.base00
theme.proxy_inactive_menu_fg       = system.base03
theme.proxy_inactive_menu_bg       = system.base00

-- Statusbar specific
theme.sbar_fg                      = system.base0F
theme.sbar_bg                      = system.base00

-- Downloadbar specific
theme.dbar_fg                      = system.base00
theme.dbar_bg                      = system.base0D
theme.dbar_error_fg                = system.base08

-- Input bar specific
theme.ibar_fg                      = system.base05
theme.ibar_bg                      = system.base00

-- Tab label
theme.tab_fg                       = system.base05
theme.tab_bg                       = system.base00
theme.tab_hover_bg                 = system.base0B
theme.tab_ntheme                   = system.base03
theme.selected_fg                  = system.base05
theme.selected_bg                  = system.base0E
theme.selected_ntheme              = system.base00
theme.loading_fg                   = system.base0D
theme.loading_bg                   = system.base00

theme.selected_private_tab_bg      = system.base05
theme.private_tab_bg               = system.base03

-- Trusted/untrusted ssl colours
theme.trust_fg                     = system.base0B
theme.notrust_fg                   = system.base0D

-- Follow mode hints
theme.hint_fg                      = system.base00
theme.hint_bg                      = system.base0A
theme.hint_border                  = string.format("1px dashed %s", system.base0A)

theme.hint_overlay_bg              = string.format("rgba(%s, 0.3)", hex2rgb(system.base07))
theme.hint_overlay_border          = string.format("1px dotted %s", system.base07)

theme.hint_overlay_selected_bg     = string.format("rgba(%s, 0.3)", hex2rgb(system.base0B))
theme.hint_overlay_selected_border = theme.hint_overlay_border

-- General colour pairings
theme.ok                           = { fg = system.base05, bg = system.base00 }
theme.warn                         = { fg = system.base00, bg = system.base0E }
theme.error                        = { fg = system.base08, bg = system.base00 }

-- Font
theme.font                         = "12px Iosevka Nerd Font, monospace"
theme.hint_font                    = "10px Iosevka Nerd Font, monospace, courier, sans-serif"

return theme
