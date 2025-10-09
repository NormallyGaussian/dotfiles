#!/bin/bash
# Neovim configuration installation script

set -e

echo "🚀 Installing Neovim Configuration..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NVIM_CONFIG="$HOME/.config/nvim"

echo "📁 Dotfiles location: $SCRIPT_DIR"

# Install Neovim if not already installed
if ! command -v nvim &> /dev/null; then
    echo -e "${YELLOW}Neovim is not installed. Installing...${NC}"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            echo "Installing Neovim via Homebrew..."
            brew install neovim
        else
            echo -e "${RED}Error: Homebrew is not installed.${NC}"
            echo "Please install Homebrew first: https://brew.sh"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command -v apt-get &> /dev/null; then
            echo "Installing Neovim via apt..."
            sudo apt-get update
            sudo apt-get install -y neovim
        elif command -v dnf &> /dev/null; then
            echo "Installing Neovim via dnf..."
            sudo dnf install -y neovim
        elif command -v pacman &> /dev/null; then
            echo "Installing Neovim via pacman..."
            sudo pacman -S --noconfirm neovim
        else
            echo -e "${RED}Error: Could not detect package manager.${NC}"
            echo "Please install Neovim manually and run this script again."
            exit 1
        fi
    else
        echo -e "${RED}Error: Unsupported operating system.${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓ Neovim installed successfully${NC}"
fi

# Check Neovim version
NVIM_VERSION=$(nvim --version | head -n 1 | sed -E 's/.*v([0-9]+\.[0-9]+).*/\1/')
echo "📦 Found Neovim version: $NVIM_VERSION"

# Backup existing config
if [ -e "$NVIM_CONFIG" ]; then
    BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}⚠️  Existing config found. Backing up to: $BACKUP_DIR${NC}"
    mv "$NVIM_CONFIG" "$BACKUP_DIR"
fi

# Create parent directory if it doesn't exist
mkdir -p "$HOME/.config"

# Copy config files
if [ -d "$SCRIPT_DIR/nvim" ]; then
    # If there's a nvim subdirectory in the dotfiles
    echo "📋 Copying config: $SCRIPT_DIR/nvim -> $NVIM_CONFIG"
    cp -r "$SCRIPT_DIR/nvim" "$NVIM_CONFIG"
elif [ -f "$SCRIPT_DIR/init.lua" ]; then
    # If init.lua is in the root of dotfiles
    echo "📋 Creating directory and copying init.lua..."
    mkdir -p "$NVIM_CONFIG"
    cp "$SCRIPT_DIR/init.lua" "$NVIM_CONFIG/init.lua"

    # Copy .gitignore if it exists
    if [ -f "$SCRIPT_DIR/.gitignore" ]; then
        cp "$SCRIPT_DIR/.gitignore" "$NVIM_CONFIG/.gitignore"
    fi
else
    echo -e "${RED}Error: Could not find nvim directory or init.lua${NC}"
    echo "Make sure you're running this script from your dotfiles directory"
    exit 1
fi

echo -e "${GREEN}✓ Config files copied successfully${NC}"

# Check for git (required by lazy.nvim)
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed.${NC}"
    echo "Git is required for plugin management. Please install it first."
    exit 1
fi

# Verify installation
if [ -f "$NVIM_CONFIG/init.lua" ]; then
    echo -e "${GREEN}✓ Config files verified${NC}"
fi

echo ""
echo -e "${GREEN}✨ Configuration installed successfully!${NC}"
echo ""
echo "📚 Next steps:"
echo "  1. Launch Neovim: nvim"
echo "  2. Wait for plugins to install (this may take a minute)"
echo "  3. Restart Neovim after installation completes"
echo ""
echo "💡 Helpful commands:"
echo "  :Lazy         - Manage plugins"
echo "  :Mason        - Manage LSP servers"
echo "  :checkhealth  - Check Neovim health"
echo "  :Tutor        - Learn Vim basics"
echo ""
echo "🎨 To customize the colorscheme, edit your dotfiles init.lua"
echo "   and change 'carbonfox' to: nightfox, nordfox, duskfox, or terafox"
echo ""

# Optional: Check for recommended tools
echo "🔍 Checking for recommended tools..."

if ! command -v rg &> /dev/null; then
    echo -e "${YELLOW}  ⚠️  ripgrep not found (recommended for Telescope live_grep)${NC}"
    echo "     Install: brew install ripgrep"
else
    echo -e "${GREEN}  ✓ ripgrep found${NC}"
fi

if ! command -v fd &> /dev/null; then
    echo -e "${YELLOW}  ⚠️  fd not found (optional, improves Telescope performance)${NC}"
    echo "     Install: brew install fd"
else
    echo -e "${GREEN}  ✓ fd found${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Setup complete! Launch nvim to get started.${NC}"
echo ""
echo "ℹ️  Your config has been copied to ~/.config/nvim"
echo "   To update, run this script again or edit files directly in ~/.config/nvim"
