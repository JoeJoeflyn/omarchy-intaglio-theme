return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      transparent = false,
      colors = {
        bg         = "#101112",
        dark_bg    = "#0A0A0C",
        darker_bg  = "#050506",
        lighter_bg = "#1A1B1D",

        fg         = "#F4F4EE",
        dark_fg    = "#888884",
        light_fg   = "#FAF9F5",
        bright_fg  = "#FFFFFF",
        muted      = "#666666",

        red        = "#E05545",
        orange     = "#E58A4B",
        yellow     = "#E5B84B",
        green      = "#6BAA75",
        cyan       = "#88B8B5",
        blue       = "#7D9BB8",
        purple     = "#B8869E",
        brown      = "#5C4838",

        bright_red    = "#FF6B5A",
        bright_yellow = "#FFD166",
        bright_green  = "#85C990",
        bright_cyan   = "#A0D8D5",
        bright_blue   = "#98BEE0",
        bright_purple = "#D8A4BE",

        accent               = "#F4F4EE",
        cursor               = "#FFFFFF",
        foreground           = "#F4F4EE",
        background           = "#101112",
        selection            = "#242424",
        selection_foreground = "#FFFFFF",
        selection_background = "#101112",
      },
      on_highlights = function(hl, c)
        hl.CursorLine = { bg = "#1A1B1D" }
        hl.CursorLineNr = { fg = c.accent, bold = true }
        hl.LspReferenceText = { bg = c.selection, fg = c.bright_fg }
        hl.LspReferenceRead = hl.LspReferenceText
        hl.LspReferenceWrite = hl.LspReferenceText
        hl.SnacksPickerDir         = { fg = c.muted }
        hl.SnacksPickerPathHidden  = { fg = c.muted }
        hl.SnacksPickerPathIgnored = { fg = c.muted }
        hl.SnacksPickerListCursorLine = { bg = "#1A1B1D" }
        hl["@markup.raw.markdown_inline"] = { bg = "NONE" }
        hl["@markup.raw.block.markdown"] = { bg = "NONE" }
        hl["@markup.quote"] = { bg = "NONE" }
      end,
    },
    config = function(_, opts)
      require("aether").setup(opts)
      vim.cmd("colorscheme aether")
    end,
  },
}
