-- Intaglio / 1-Bit — Hyprland decoration: real-time GLSL dither shader, 0px rounding, 1-bit borders

hl.config({
  general = {
    col = {
      active_border = "rgb(F4F4EE)",
      inactive_border = "rgb(242424)",
    },
    gaps_in = 6,
    gaps_out = 10,
    border_size = 2,
  },
  group = {
    col = {
      border_active = "rgb(F4F4EE)",
      border_inactive = "rgb(242424)",
    },
    groupbar = {
      col = {
        active = "rgba(F4F4EEff)",
        inactive = "rgba(101112ee)",
      },
      text_color = "rgb(101112)",
      text_color_inactive = "rgba(888884ee)",
      font_family = "monospace",
    },
  },
  decoration = {
    rounding = 0,
    shadow = {
      enabled = false,
    },
    blur = {
      enabled = false,
    },
    screen_shader = (os.getenv("HOME") or "") .. "/.config/hypr/shaders/dither.glsl",
  },
})
