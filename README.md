# Neovim Configuration

A complete Neovim setup with LSP support for Lua, Python, Rust, and Java, along with terminal integration, diagnostics, git integration, file navigation, fuzzy finding, and modern UI.

## Features

- 🎨 **Nightfox Colorscheme** - Beautiful carbonfox theme
- 📁 **File Explorer** - nvim-tree for easy file navigation
- 🔍 **Fuzzy Finder** - Telescope for quick file/text search
- 🌳 **Treesitter** - Enhanced syntax highlighting
- 🔧 **LSP Support** - Language servers for Lua, Python, Rust, and Java
- ✨ **Autocompletion** - Intelligent code completion with nvim-cmp
- 🖥️ **Terminal Integration** - toggleterm for easy terminal access
- 🐛 **Diagnostics** - Trouble.nvim for better error/warning display
- 🎯 **Flash Navigation** - Quick cursor movement with flash.nvim
- 🎨 **Code Formatting** - Automatic formatting with conform.nvim
- 🔀 **Git Integration** - GitSigns for git hunks and blame
- ⌨️ **Which-Key** - On-screen keybinding help
- ⚡ **Fast** - Optimized for performance with lazy.nvim

## Prerequisites

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- For LSP: Python, Rust, and/or Java installed on your system

## Installation

### Recommended: Using install.sh (Symlinks)

The best way to install is using the provided installation script, which creates symlinks so your config stays in sync with your dotfiles repo:

```bash
# Clone this repository to your dotfiles location
git clone https://github.com/yourusername/nvim-config.git ~/dotfiles

# Run the installation script
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The script will:
- Backup any existing Neovim config
- Create symlinks from `~/.config/nvim` to your dotfiles
- Verify everything is set up correctly
- Check for recommended tools

After running the script:
```bash
# Start Neovim - plugins will auto-install
nvim
```

### Alternative: Manual Clone (No Symlinks)

If you prefer to clone directly without symlinks:

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone directly to Neovim config directory
git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim

# Start Neovim
nvim
```

**Note:** With this method, your config won't be in a central dotfiles location.

On first launch, lazy.nvim will automatically install all plugins. This may take a minute.

## Keybindings

Leader key is set to `Space`.

### General
- `Space + w` - Save file
- `Space + q` - Quit
- `Ctrl + h/j/k/l` - Navigate between windows
- `Shift + h/l` - Previous/Next buffer
- `Space + bd` - Delete buffer

### File Explorer (nvim-tree)
- `Space + e` - Toggle file tree
- Inside tree:
  - `Enter` - Open file (stay in tree)
  - `o` - Open file (move to file)
  - `a` - Create new file
  - `d` - Delete file
  - `r` - Rename file

### Fuzzy Finder (Telescope)
- `Space + ff` - Find files
- `Space + fg` - Live grep (search in files)
- `Space + fb` - Find buffers

### LSP
- `gd` - Go to definition
- `gr` - Find references
- `K` - Show hover documentation
- `Space + rn` - Rename symbol
- `Space + ca` - Code actions
- `[d` - Previous diagnostic
- `]d` - Next diagnostic

### Navigation
- `Ctrl + d` - Scroll down half page (centered)
- `Ctrl + u` - Scroll up half page (centered)
- `w` - Next word
- `b` - Previous word
- `}` - Next paragraph/block
- `{` - Previous paragraph/block
- `gg` - Go to top
- `G` - Go to bottom
- `/text` - Search forward
- `*` - Search word under cursor

### Autocompletion
- `Tab` - Next suggestion
- `Shift + Tab` - Previous suggestion
- `Enter` - Accept suggestion
- `Ctrl + Space` - Trigger completion

### Terminal
- `Ctrl + \` - Toggle terminal (horizontal split at bottom)
- `Esc` or `jk` - Exit terminal insert mode
- `Ctrl + h/j/k/l` - Navigate to other windows from terminal

### Diagnostics (Trouble)
- `Space + xx` - Toggle diagnostics panel
- `Space + xX` - Toggle buffer diagnostics
- `Space + cs` - Toggle symbols
- `Space + cl` - Toggle LSP definitions

### Git (GitSigns)
- `]c` - Next git hunk
- `[c` - Previous git hunk
- `Space + hs` - Stage hunk
- `Space + hr` - Reset hunk
- `Space + hp` - Preview hunk
- `Space + hb` - Blame line
- `Space + hd` - Diff this

### Flash Navigation
- `s` - Jump to location (flash)
- `S` - Jump to treesitter node
- `r` - Remote flash (in operator mode)
- `R` - Treesitter search

### Code Formatting
- `Space + mp` - Format file or selection (in visual mode)

### Command-line
- `Tab` - Show autocomplete suggestions
- `Ctrl + n/p` or `Tab/Shift+Tab` - Navigate suggestions

## Recommended Dotfiles Structure

For best results, organize your dotfiles like this:

```
dotfiles/
├── nvim/
│   ├── init.lua
│   └── .gitignore
├── install.sh
└── README.md
```

The `install.sh` script will create: `~/.config/nvim -> ~/dotfiles/nvim`

Any changes you make to files in your dotfiles directory will automatically apply to Neovim since they're symlinked.

### Change Colorscheme

In `init.lua`, change the colorscheme line:
```lua
vim.cmd("colorscheme carbonfox")
```

Available Nightfox variants:
- `nightfox` - Balanced, warm
- `carbonfox` - Dark, high contrast (default)
- `nordfox` - Cool, Nord-inspired
- `duskfox` - Muted, low contrast
- `terafox` - Green/blue tones

### Add More Language Servers

In the Mason setup section, add to `ensure_installed`:
```lua
ensure_installed = {
  "pyright",
  "rust_analyzer",
  "jdtls",
  "tsserver",  -- TypeScript
  "gopls",     -- Go
  -- etc.
}
```

Then add the setup:
```lua
lspconfig.tsserver.setup({ on_attach = on_attach })
```

## Troubleshooting

### Plugins not installing
- Check internet connection
- Run `:Lazy` to see plugin status
- Try `:Lazy sync` to reinstall

### LSP not working
- Run `:Mason` to check language server installation
- Ensure the programming language is installed on your system
- Check `:LspInfo` for active language servers
- Run `:LspRestart` to restart the language server

### Diagnostics/Warnings
- Press `K` on a line to see diagnostic details
- Use `Space + xx` to open the Trouble diagnostics panel
- Use `[d` and `]d` to navigate between diagnostics

### Icons not showing
- Install a [Nerd Font](https://www.nerdfonts.com/)
- Set your terminal to use the Nerd Font

## Learning Resources

### Essential Vim Motions
- [Vim Cheat Sheet](https://vim.rtorr.com/)
- Run `:Tutor` in Neovim for interactive tutorial

### Plugin Documentation
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)

## License

MIT License - Feel free to use and modify as you wish! 
