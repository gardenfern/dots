syntax enable
filetype plugin indent on
set noshowmode

set completeopt=menu,menuone,noselect

set tabstop=2
set shiftwidth=2
set expandtab
set number
set clipboard=unnamed,unnamedplus

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

colorscheme base16
set termguicolors
let g:airline_theme = 'base16_paradise'

call plug#begin()
	Plug 'VundleVim/Vundle.vim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'akinsho/bufferline.nvim'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'famiu/bufdelete.nvim'
  Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'vim-airline/vim-airline'
call plug#end()

lua << EOF
require('nvim-tree').setup {
  auto_close = true,
  open_on_setup = true,
  git = {
    enable = true,
    ignore = true
  },
  view = {
    auto_resize = true
  },
  trash = {
    cmd = "trash-cli",
    require_config = true
  }
}
EOF

lua << EOF
require('bufferline').setup {
  options = {
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left"
      }
    },
    close_command = function(bufnum)
      require('bufdelete').bufdelete(bufnum, true)
    end,
    left_mouse_command = "buffer %d",
    right_mouse_command = nil,
    middle_mouse_command = function(bufnum)
      require('bufdelete').bufdelete(bufnum, true)
    end,
    show_close_icon = false
  }
}
EOF

lua << EOF
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

local servers = { 'rls', 'pyright' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end
EOF

lua << EOF
local luasnip = require 'luasnip'

local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
EOF

let g:Hexokinase_highlighters = [ 'virtual' ]
let g:Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla,colour_names'

let g:airline_powerline_fonts = 1

map <leader>f :NvimTreeToggle<CR>
