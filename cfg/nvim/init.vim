" plugins list here
call plug#begin()
Plug 'savq/paq-nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'Yggdroo/indentLine'
Plug 'tpope/vim-commentary'
Plug 'christoomey/vim-system-copy'
Plug 'tpope/vim-surround'
call plug#end()

" minimal colorscheme
highlight Normal    ctermbg=none
highlight String    ctermfg=65
highlight Comment   ctermfg=58
highlight Todo      cterm=bold ctermfg=88 ctermbg=none

highlight! link EndOfBuffer Ignore
highlight! link SpecialChar String
highlight! link Character String
highlight! link Type Normal
highlight! link Statement Normal
highlight! link LineNr Normal
highlight! link PreProc Normal
highlight! link Function Normal
highlight! link Identifier Normal
highlight! link Constant Normal
highlight! link Error Normal
highlight! link Special Normal
highlight! link Underlined Normal

set background=dark

"rest is lua cuz that's what it was written in initially
lua << END

-- Line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- Improve search
vim.opt.ignorecase = true
vim.opt.hlsearch = false

-- Improve tabs and indentation
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true

-- Plugin customization
vim.g["deoplete#enable_at_startup"] = 1
vim.g["indentLine_char"] = "▏"
require("lualine").setup {
    options = {
        icons_enabled = false,
      theme = { -- grayscale status bar
          normal      = { a = { fg = "#ffffff", bg = "#808080", gui = 'bold' } },
          insert      = { a = { fg = "#ffffff", bg = "#808080", gui = 'bold' } },
          visual      = { a = { fg = "#ffffff", bg = "#808080", gui = 'bold' } },
          replace     = { a = { fg = "#ffffff", bg = "#808080", gui = 'bold' } },
          inactive    = { a = { fg = "#ffffff", bg = "#808080", gui = 'bold' } },
      }
  },
    sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {"filename"},
        lualine_x = {"encoding", "fileformat"},
        lualine_y = {"location"},
        lualine_z = {}
    },
}

END
