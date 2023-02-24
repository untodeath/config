-- https://github.com/LazyVim/LazyVim
-- https://github.com/lunarvim/lunarvim
-- https://github.com/NvChad/NvChad
-- https://github.com/nvim-lua/kickstart.nvim
-- https://github.com/ThePrimeagen/init.lua

-- Leader: See `:help mapleader`
vim.g.mapleader = " "

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "folke/which-key.nvim", -- Key hints
	"mbbill/undotree", -- Undo
	"tpope/vim-fugitive", -- Git
	"tpope/vim-rhubarb", -- GitHub
	"tpope/vim-sensible", -- Defaults
	"tpope/vim-surround", -- Surroundings	

	{ -- Adds a buffer line
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				mode = "tabs",
				offsets = { { filetype = "NvimTree", padding = 1, text = ""} }
			}
		}
	},

  { -- Theme
    "ellisonleao/gruvbox.nvim",
    config = function()
      vim.cmd.colorscheme "gruvbox"
    end,
    priority = 1000
  },

  { -- Adds git releated signs to the gutter, as well as utilities for managing changes. See `:help gitsigns.txt`
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" }
      }
    }
  },

  { -- Add indentation guides even on blank lines: See `:help indent_blankline.txt`
    "lukas-reineke/indent-blankline.nvim",
    opts = {
			show_current_context = true,
      show_trailing_blankline_indent = false
    }
  },

	{ -- Set colorcolumn character
		"lukas-reineke/virt-column.nvim",
		opts = { 
			char = "-" 
		}
	},

	{ -- Prettier code formatting
		"MunifTanjim/prettier.nvim",
		dependencies = { "jose-elias-alvarez/null-ls.nvim" }
	},

  -- Comment visual regions/lines
  { "numToStr/Comment.nvim", opts = {} },

  { -- Set lualine as statusline: See `:help lualine.txt`
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = true,
        theme = "gruvbox",
        component_separators = " ",
        section_separators = ""
      }
    }
  },

  -- Fuzzy Finder (files, lsp, etc)
	{ "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },

	{ -- File Tree
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			view = {
				width = 36
			}
		}
	},

  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      pcall(require("nvim-treesitter.install").update { with_sync = true })
    end
  },

	{ -- LSP Configuration, Plugins, Autocomplete, & Snippets
    "VonHeikemen/lsp-zero.nvim",
    branch = "v1.x",
    dependencies = {
      -- LSP Support
      {"neovim/nvim-lspconfig"},             -- Required
      {"williamboman/mason.nvim"},           -- Optional
      {"williamboman/mason-lspconfig.nvim"}, -- Optional

      -- Autocompletion
      {"hrsh7th/nvim-cmp"},         -- Required
      {"hrsh7th/cmp-nvim-lsp"},     -- Required
      {"hrsh7th/cmp-buffer"},       -- Optional
      {"hrsh7th/cmp-path"},         -- Optional
      {"saadparwaiz1/cmp_luasnip"}, -- Optional
      {"hrsh7th/cmp-nvim-lua"},     -- Optional

      -- Snippets
      {"L3MON4D3/LuaSnip"},             -- Required
			{"rafamadriz/friendly-snippets"}  -- Optional
    }
  },
}, {})

-- Options: See `:help vim.o`

-- Remove background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NonText", { bg = "none" })

-- Close tree if last window
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd "quit"
    end
  end
})

-- Open tree on launch

local options = {
backup = false, -- Disable backups and set unto history folder
	swapfile = false,
	undodir = os.getenv("HOME") .. "/.vim/undodir",
breakindent = true, -- Enable break indent
colorcolumn = "80",
completeopt = "menuone,noselect", -- Set completeopt to have a better completion experience
hlsearch = false, -- Set highlight on search
	incsearch = true,
ignorecase = true, -- Case insensitive searching UNLESS /C or capital in search
  smartcase = true,
mouse = "a", -- Enable mouse mode
number = true, -- Line numbers
	relativenumber = true,
scrolloff = 8, -- Set minimum line overflow
signcolumn = "number",
tabstop = 2, -- Tab spacing
	softtabstop = 2,
	shiftwidth = 2,
	smartindent = true,
undofile = true, -- Save undo history
updatetime = 50, -- Decrease update time
  timeout = true,
  timeoutlen = 300,
termguicolors = true,
wrap = false -- Disable line wrap
}

for key, value in pairs(options) do
	vim.opt[key] = value
end

-- Plugin configuration

-- LSP
local lsp = require("lsp-zero").preset({
  manage_nvim_cmp = true,
  name = "minimal",
  set_lsp_keymaps = true,
  suggest_lsp_servers = false
})

lsp.ensure_installed({
	"rust_analyzer",
	"tsserver"
})
lsp.nvim_workspace()
lsp.setup()

-- Null
local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.keymap.set("n", "<Leader>f", function()
				vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
			end, { buffer = bufnr, desc = "[lsp] format" })

			-- format on save
			vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
			vim.api.nvim_create_autocmd(event, {
				buffer = bufnr,
				group = group,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr, async = async })
				end,
				desc = "[lsp] format on save",
			})
		end

		if client.supports_method("textDocument/rangeFormatting") then
			vim.keymap.set("x", "<Leader>f", function()
				vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
			end, { buffer = bufnr, desc = "[lsp] format" })
		end
	end,
})

-- Prettier
require("prettier").setup()

-- Tree
require("nvim-tree.api").tree.open()

-- Treesitter
require("nvim-treesitter.configs").setup {
  auto_install = true,
  ensure_installed = { "c", "go", "help", "javascript", "lua", "rust", "tsx", "typescript", "vim" },
  highlight = {
    additional_vim_regex_highlighting = false,
    enable = true
  },
	indent = true,
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = "<c-s>",
      node_decremental = "<M-space>"
    },
  },
	sync_install = false
}

-- Keymaps: See `:help nmap()`
local builtin = require("telescope.builtin")

local nmap = function(keys, func, desc)
	if desc then
		desc = "LSP: " .. desc
	end

	vim.keymap.set("n", keys, func, { desc = desc })
end

vim.keymap.set({ "n", "v" }, "<space>", "<nop>", { silent = true })
nmap("Q", "<nop>")

nmap("<leader>d", vim.cmd.NvimTreeToggle, "[D]irectory")
nmap("<leader>s", vim.cmd.vsplit, "[S]plit window")
nmap("<leader>u", vim.cmd.UndotreeToggle, "[U]ndo")

nmap("<leader>ff", builtin.find_files, "[F]ind [F]iles")
nmap("<leader>fg", builtin.git_files, "[F]ind [G]it")
nmap("<leader>fh", builtin.help_tags, "[F]ind [H]elp")
nmap("<leader>fr", builtin.oldfiles, "[F]ind [R]ecent")
nmap("<leader>fs", function() builtin.grep_string({ search = vim.fn.input("Search > ") }) end, "[F]ind by [S]earch")
nmap("<leader>ft", builtin.buffers, "[F]ind [T]ab")
nmap("<leader>fw", builtin.grep_string, "[F]ind current [W]ord")

nmap("<leader>gs", vim.cmd.Git, "[G]it [S]tatus")

nmap("<leader>gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
nmap("<leader>gI", vim.lsp.buf.implementation,"[G]oto [I]mplementation")
nmap("<leader>gr", builtin.lsp_references, "[G]oto [R]eferences")
nmap("<leader>gt", vim.lsp.buf.type_definition, "[G]oto [T]ype")

nmap("<leader>me", "<cmd>!chmod +x %<CR>", "[M]ake [E]xecutable")

nmap("<leader>rw", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>", "[R]eplace [W]ord")

-- Keep cursor in middle when jumping
nmap("<C-d>", "<C-d>zz", "[D]own")
nmap("<C-u>", "<C-u>zz", "[U]p")

-- Keep search terms in the middle
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

-- Quick fix navigation
nmap("<C-k>", "<cmd>cnext<CR>zz")
nmap("<C-j>", "<cmd>cprev<CR>zz")
nmap("<leader>k", "<cmd>lnext<CR>zz")
nmap("<leader>j", "<cmd>lnext<CR>zz")

-- Access system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y", { desc = "[y]ank" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "[Y]ank" })
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d", { desc = "[D]elete" })

-- Paste without replacing clip
vim.keymap.set("x", "<leader>p", "\"_dp", { desc = "[P]aste" })

vim.keymap.set("v", "H", "<gv") -- Move selection left
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Move selection up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- Move selection down
vim.keymap.set("v", "L", ">gv") -- Move selection right
