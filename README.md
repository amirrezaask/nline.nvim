# nline.nvim
Make neovim statusline in lua.

# Usage
take a look at my personal statusline configuration
[statusline.lua](https://github.com/amirrezaask/dotfiles/tree/master/nvim/lua/plugin/statusline.lua)

# Parts
## Vim
- modified: function({hl: Highlight group})
- readonly: function({hl: Highlight group})
- space: function({hl: Highlight group})
- pipe: function({hl: Highlight group})
- line: function({hl: Highlight group})
- col: function({hl: Highlight group})
- percentage_of_file: function({hl: Highlight group})
- filetype: function({hl: Highlight group})
- seperator: function({hl: Highlight group})
- colon: function({hl: Highlight group})
- filename: function({shorten: boolean}) -> function({hl: Highlight group})
- mode: function({
    hls = {
      normal = 'NormalMode',
      visual = 'VisualMode',
      visual_block = 'VisualBlockMode',
      insert = 'InsertMode',
      insert_complete = 'InsertMode',
      command = 'CommandMode',
      terminal = 'TerminalMode'
    },
    texts = {
      normal = 'Normal',
      visual = 'Visual',
      visual_block = 'VisualBlock',
      insert = 'Insert',
      insert_complete = 'IComplete',
      command = 'Command',
      terminal = 'Terminal'
    }
})

## Git
- changes: { changed, insertions, deletions: 'Symbol or icon to use as prefix of changed' }
- branch

## LSP
- progress
- diagnostics
- current_function

# Dependencies
- for git stuff: [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- for LSP stuff: [lsp-status](https://github.com/nvim-lua/lsp-status.nvim)
