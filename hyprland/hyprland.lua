-- Migrated from hyprland.conf for Hyprland 0.57+.
local home = os.getenv("HOME") or "/home/dan"

hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = 1.25,
})

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd(home .. "/.config/waybar/audio-device-watcher")
    hl.exec_cmd(home .. "/.config/hypr/compact-workspaces.py")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("mako")
    hl.exec_cmd("hyprpaper")
end)

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 0,
        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 0,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = { enabled = true, range = 4, render_power = 3, color = "rgba(1a1a1aee)" },
        blur = { enabled = true, size = 3, passes = 1, vibrancy = 0.1696 },
    },
    dwindle = {},
    master = { new_status = "master" },
    misc = { force_default_wallpaper = 0, disable_hyprland_logo = true },
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = false },
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

local mainMod = "SUPER"
local function bind(key, dispatcher, flags)
    hl.bind(mainMod .. " + " .. key, dispatcher, flags)
end

bind("T", hl.dsp.exec_cmd("kitty"))
bind("Q", hl.dsp.window.close())
bind("ESCAPE", hl.dsp.exit())
bind("E", hl.dsp.exec_cmd("env GTK_THEME=HyprBlack thunar"))
bind("M", hl.dsp.exec_cmd("env GTK_THEME=HyprBlack " .. home .. "/.config/waybar/audio-menu"))
bind("F", hl.dsp.exec_cmd("env GTK_THEME=HyprBlack firefox"))
bind("C", hl.dsp.exec_cmd("code --ozone-platform-hint=wayland --enable-features=WaylandWindowDecorations"))
bind("O", hl.dsp.exec_cmd("~/.local/bin/obsidian.AppImage --ozone-platform-hint=wayland --enable-features=WaylandWindowDecorations"))
bind("K", hl.dsp.exec_cmd("keepassxc"))
bind("S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
bind("B", hl.dsp.exec_cmd("env GTK_THEME=HyprBlack blueman-manager"))
bind("N", hl.dsp.exec_cmd("env GTK_THEME=HyprBlack nm-connection-editor"))

for key, direction in pairs({ left = "left", right = "right", up = "up", down = "down" }) do
    bind(key, hl.dsp.focus({ direction = direction }))
end

for i = 1, 10 do
    local key = tostring(i % 10)
    bind(key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("F9", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

local function rule(name, match, effects)
    effects.name = name
    effects.match = match
    hl.window_rule(effects)
end

rule("tile-kitty", { class = "^(kitty)$" }, { tile = true })
rule("float-network-editor", { class = "^(nm-connection-editor)$" }, { float = true })
rule("network-editor-size", { class = "^(nm-connection-editor)$" }, { size = { 760, 520 } })
rule("network-editor-opacity", { class = "^(nm-connection-editor)$" }, { opacity = "0.92 override 0.92 override 0.92 override" })
rule("float-blueman", { class = "^(blueman-manager)$" }, { float = true })
rule("blueman-size", { class = "^(blueman-manager)$" }, { size = { 640, 460 } })
rule("blueman-opacity", { class = "^(blueman-manager)$" }, { opacity = "0.92 override 0.92 override 0.92 override" })

rule("float-save-dialog", { title = "^(Save File|Save As)$" }, { float = true })
rule("center-save-dialog", { title = "^(Save File|Save As)$" }, { center = true })
rule("float-firefox-library", { class = "^(firefox)$", title = "^(Library)$" }, { float = true })
rule("center-firefox-library", { class = "^(firefox)$", title = "^(Library)$" }, { center = true })
rule("size-firefox-library", { class = "^(firefox)$", title = "^(Library)$" }, { size = { 1000, 700 } })
rule("opacity-firefox-library", { class = "^(firefox)$", title = "^(Library)$" }, { opacity = "0.92 override 0.92 override 0.92 override" })

local thunar = "^(thunar|Thunar|org\\.xfce\\.Thunar)$"
rule("float-thunar", { class = thunar }, { float = true })
rule("size-thunar", { class = thunar }, { size = { 900, 620 } })
rule("center-thunar", { class = thunar }, { center = true })
rule("opacity-thunar", { class = thunar }, { opacity = "0.92 override 0.92 override 0.92 override" })

local audioPicker = "^(org\\.dan\\.AudioPicker|audio-picker|AudioPicker)$"
rule("float-audio-picker", { class = audioPicker }, { float = true })
rule("size-audio-picker", { class = audioPicker }, { size = { 460, 360 } })
rule("center-audio-picker", { class = audioPicker }, { center = true })
rule("opacity-audio-picker", { class = audioPicker }, { opacity = "0.92 override 0.92 override 0.92 override" })
rule("float-audio-output-title", { title = "^(Audio output)$" }, { float = true })
rule("size-audio-output-title", { title = "^(Audio output)$" }, { size = { 460, 360 } })
rule("center-audio-output-title", { title = "^(Audio output)$" }, { center = true })
rule("opacity-audio-output-title", { title = "^(Audio output)$" }, { opacity = "0.92 override 0.92 override 0.92 override" })
