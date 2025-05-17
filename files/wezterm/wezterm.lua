local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.disable_default_key_bindings = true
config.enable_scroll_bar = true
config.font = wezterm.font('JetBrains Mono', { weight = 'Medium' })
config.window_frame = {
    font = wezterm.font('Inter', { weight = 'Medium' })
}

config.leader = { key = "b", mods = "CTRL" }
config.keys = {
    { key = "b", mods = "LEADER|CTRL",  action = wezterm.action { SendString = "\x01" } },
    { key = "-", mods = "LEADER",       action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
    { key = "'", mods = "LEADER",       action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
    { key = "z", mods = "LEADER",       action = "TogglePaneZoomState" },
    { key = "c", mods = "LEADER",       action = wezterm.action { SpawnTab = "CurrentPaneDomain" } },
    { key = "h", mods = "LEADER",       action = wezterm.action { ActivatePaneDirection = "Left" } },
    { key = "j", mods = "LEADER",       action = wezterm.action { ActivatePaneDirection = "Down" } },
    { key = "k", mods = "LEADER",       action = wezterm.action { ActivatePaneDirection = "Up" } },
    { key = "l", mods = "LEADER",       action = wezterm.action { ActivatePaneDirection = "Right" } },
    { key = "H", mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Left", 5 } } },
    { key = "J", mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Down", 5 } } },
    { key = "K", mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Up", 5 } } },
    { key = "L", mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Right", 5 } } },
    { key = "1", mods = "LEADER",       action = wezterm.action { ActivateTab = 0 } },
    { key = "2", mods = "LEADER",       action = wezterm.action { ActivateTab = 1 } },
    { key = "3", mods = "LEADER",       action = wezterm.action { ActivateTab = 2 } },
    { key = "4", mods = "LEADER",       action = wezterm.action { ActivateTab = 3 } },
    { key = "5", mods = "LEADER",       action = wezterm.action { ActivateTab = 4 } },
    { key = "6", mods = "LEADER",       action = wezterm.action { ActivateTab = 5 } },
    { key = "7", mods = "LEADER",       action = wezterm.action { ActivateTab = 6 } },
    { key = "8", mods = "LEADER",       action = wezterm.action { ActivateTab = 7 } },
    { key = "9", mods = "LEADER",       action = wezterm.action { ActivateTab = 8 } },
    { key = "&", mods = "LEADER|SHIFT", action = wezterm.action { CloseCurrentTab = { confirm = true } } },
    { key = "x", mods = "LEADER",       action = wezterm.action { CloseCurrentPane = { confirm = true } } },
    { key = "f", mods = "LEADER",       action = wezterm.action.Search { CaseSensitiveString = '' } },
    { key = "[", mods = "LEADER",       action = "ActivateCopyMode" },
    { key = "n", mods = "SHIFT|CTRL",   action = "ToggleFullScreen" },
    { key = " ", mods = "SHIFT|CTRL",   action = "QuickSelect" },
    { key = "v", mods = "SHIFT|CTRL",   action = wezterm.action.PasteFrom 'Clipboard' },
    { key = "c", mods = "SHIFT|CTRL",   action = wezterm.action.CopyTo 'Clipboard' },
    { key = "l", mods = "SHIFT|CTRL",   action = wezterm.action.ShowDebugOverlay },
    { key = ",", mods = "LEADER",       action = wezterm.action.MoveTabRelative(-1) },
    { key = ".", mods = "LEADER",       action = wezterm.action.MoveTabRelative(1) },

}

local search_mode = wezterm.gui.default_key_tables().search_mode
table.insert(
    search_mode,
    { key = "c", mods = "CTRL", action = wezterm.action.CopyMode 'Close' }
)

config.key_tables = {
    search_mode = search_mode
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { 'powershell' }

    table.insert(
        config.keys,
        { key = "c", mods = "LEADER|SHIFT", action = "ShowLauncher" }
    )
end

if wezterm.target_triple == "x86_64-apple-darwin" or
    wezterm.target_triple == "aarch64-apple-darwin"
then
    config.font_size = 14

    -- honor mac os clipboard shortcuts
    table.insert(
        config.keys,
        { key = "v", mods = "CMD", action = wezterm.action.PasteFrom 'Clipboard' }
    )
    table.insert(
        config.keys,
        { key = "c", mods = "CMD", action = wezterm.action.CopyTo 'Clipboard' }
    )
end

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    -- on Windows, for some reason it would not select
    -- a DiscreteGpu automatically
    --
    -- if we don't use one, it will cause input lag
    -- when using the WebGpu frontend, so force it
    -- to use DiscreteGpu instead
    --
    -- code taken from:
    -- https://github.com/wez/wezterm/issues/4278#issuecomment-1726978476
    for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
        if gpu.device_type == "DiscreteGpu" then
            config.webgpu_preferred_adapter = gpu
            break
        end
    end
end

return config
