-- ~/.config/nvim/init.lua
-- Complete Neovim configuration with plugins, LSP, and keybindings

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key to space (must be set before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
vim.opt.number = true -- Show line numbers
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Unless you use capitals
vim.opt.hlsearch = false -- Don't highlight all search matches
vim.opt.tabstop = 4 -- Tab width
vim.opt.shiftwidth = 4 -- Indent width
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.wrap = false -- Don't wrap lines
vim.opt.termguicolors = true -- True color support
vim.opt.scrolloff = 8 -- Keep 8 lines visible when scrolling
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.updatetime = 50 -- Faster completion

-- Setup plugins
require("lazy").setup({
	-- Nightfox colorscheme
	{
		"EdenEast/nightfox.nvim",
		priority = 1000,
		config = function()
			require("nightfox").setup({
				options = {
					transparent = false,
					styles = {
						comments = "italic",
						keywords = "bold",
					},
				},
			})
			vim.cmd("colorscheme carbonfox") -- or nightfox, nordfox, duskfox, terafox
		end,
	},

	-- File explorer
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				view = {
					width = 30,
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = false,
				},
			})
		end,
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { "node_modules", ".git/" },
				},
			})
		end,
	},

	-- Better syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "vim", "vimdoc", "python", "rust", "java", "javascript", "typescript" },
				sync_install = false,
				auto_install = true,
				ignore_install = {},
				modules = {},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			-- Setup Mason (LSP installer)
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"pyright", -- Python
					"rust_analyzer", -- Rust
					"jdtls", -- Java
				},
				automatic_installation = true,
			})

			-- LSP keybindings setup
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf, silent = true }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				end,
			})

			-- Setup language servers using new vim.lsp.config API
			vim.lsp.config("lua_ls", {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = {
					".luarc.json",
					".luarc.jsonc",
					".luacheckrc",
					".stylua.toml",
					"stylua.toml",
					"selene.toml",
					"selene.yml",
					".git",
				},
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								vim.env.VIMRUNTIME,
								"${3rd}/luv/library",
							},
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			vim.lsp.config("pyright", {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
			})

			vim.lsp.config("rust_analyzer", {
				cmd = { "rust-analyzer" },
				filetypes = { "rust" },
				root_markers = { "Cargo.toml", ".git" },
			})

			vim.lsp.config("jdtls", {
				cmd = { "jdtls" },
				filetypes = { "java" },
				root_markers = { "pom.xml", "build.gradle", ".git" },
			})

			-- Enable the language servers
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("pyright")
			vim.lsp.enable("rust_analyzer")
			vim.lsp.enable("jdtls")
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},

	-- Which-key for keybinding help
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({
				preset = "modern",
				delay = 300,
			})
		end,
	},

	-- Buffer line
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					close_command = "bdelete! %d",
					right_mouse_command = "bdelete! %d",
					left_mouse_command = "buffer %d",
					middle_mouse_command = nil,
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							text_align = "left",
							separator = true,
						},
					},
					show_buffer_close_icons = false,
					show_close_icon = false,
					separator_style = "slant",
				},
			})
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- Git signs
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Next git hunk" })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Previous git hunk" })

					map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
					map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
					map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
					map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
					map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
					map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, { desc = "Blame line" })
					map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
				end,
			})
		end,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup({
				indent = {
					char = "│",
					tab_char = "│",
				},
				scope = { enabled = false },
				exclude = {
					filetypes = {
						"help",
						"alpha",
						"dashboard",
						"neo-tree",
						"Trouble",
						"trouble",
						"lazy",
						"mason",
						"notify",
						"toggleterm",
						"lazyterm",
					},
				},
			})
		end,
	},

	-- Better diagnostics
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup({
				modes = {
					preview_float = {
						mode = "diagnostics",
						preview = {
							type = "float",
							relative = "editor",
							border = "rounded",
							title = "Preview",
							title_pos = "center",
							position = { 0, -2 },
							size = { width = 0.3, height = 0.3 },
							zindex = 200,
						},
					},
				},
			})
		end,
	},

	-- Terminal integration
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<c-\>]],
				hide_numbers = true,
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "float",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
					winblend = 0,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
			})
		end,
	},

	-- Auto pairs
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		config = function()
			require("mini.pairs").setup()
		end,
	},

	-- Code formatting
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					rust = { "rustfmt" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},

	-- Enhanced navigation
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		config = function()
			require("flash").setup({
				modes = {
					search = {
						enabled = true,
					},
					char = {
						enabled = true,
						jump_labels = true,
					},
				},
			})
		end,
	},
})

-- Keybindings
-- File tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file tree" })

-- Telescope fuzzy finder
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { silent = true, desc = "Find files" })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { silent = true, desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { silent = true, desc = "Find buffers" })

-- Buffer navigation
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { silent = true, desc = "Delete buffer" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, desc = "Move to right window" })

-- Better navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true, desc = "Scroll up and center" })

-- Trouble diagnostics
vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { silent = true, desc = "Toggle diagnostics" })
vim.keymap.set(
	"n",
	"<leader>xX",
	":Trouble diagnostics toggle filter.buf=0<CR>",
	{ silent = true, desc = "Buffer diagnostics" }
)
vim.keymap.set("n", "<leader>cs", ":Trouble symbols toggle focus=false<CR>", { silent = true, desc = "Symbols" })
vim.keymap.set(
	"n",
	"<leader>cl",
	":Trouble lsp toggle focus=false win.position=right<CR>",
	{ silent = true, desc = "LSP definitions" }
)

-- Flash navigation
vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function()
	require("flash").remote()
end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function()
	require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function()
	require("flash").toggle()
end, { desc = "Toggle Flash Search" })

-- Code formatting
vim.keymap.set({ "n", "v" }, "<leader>mp", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	})
end, { desc = "Format file or range (in visual mode)" })

-- Quick save
vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true, desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { silent = true, desc = "Quit" })

-- Terminal keymaps
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*",
	callback = function()
		local opts = { buffer = 0 }
		vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
		vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
		vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
		vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
	end,
})
