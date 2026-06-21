#!/data/data/com.termux/files/usr/bin/bash

# Termux Antigravity CLI Installer
# Sets up a custom glibc runtime using proot to run agy on Termux.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Termux Antigravity CLI Installer ===${NC}"

# 1. Environment and Arch Check
if [ ! -d "/data/data/com.termux" ]; then
    echo -e "${RED}Error: This script must be run inside Termux!${NC}"
    exit 1
fi

ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ]; then
    echo -e "${RED}Error: Currently, this precompiled package only supports aarch64 (ARM64) devices!${NC}"
    exit 1
fi

# 2. Install dependencies
echo -e "${BLUE}[1/5] Installing dependencies (proot, git, tmux, gzip)...${NC}"
pkg update -y
pkg install -y proot git tmux gzip curl

# 3. Create target directories
echo -e "${BLUE}[2/5] Creating directories...${NC}"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/glibc"

# 4. Copy glibc libraries
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo -e "${BLUE}[3/5] Setting up glibc environment...${NC}"
cp "$SCRIPT_DIR/glibc/"* "$HOME/.local/glibc/"
chmod +x "$HOME/.local/glibc/ld-linux-aarch64.so.1"
chmod +x "$HOME/.local/glibc/"*.so*

# 5. Extract agy binary
echo -e "${BLUE}[4/5] Decompressing Antigravity CLI...${NC}"
if [ -f "$SCRIPT_DIR/bin/agy.gz" ]; then
    gzip -d -c "$SCRIPT_DIR/bin/agy.gz" > "$HOME/.local/bin/agy"
    chmod +x "$HOME/.local/bin/agy"
else
    echo -e "${RED}Error: bin/agy.gz not found in installation source!${NC}"
    exit 1
fi

# 6. Add alias to shell profiles
echo -e "${BLUE}[5/5] Configuring shell aliases...${NC}"
ALIAS_LINE="alias agy='LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8 proot -b /data/data/com.termux/files/usr/etc/tls:/etc/ssl/certs -b /data/data/com.termux/files/usr/etc/resolv.conf:/etc/resolv.conf -b /data/data/com.termux/files/usr/etc/hosts:/etc/hosts -b /data/data/com.termux/files/home/.local/glibc:/lib /data/data/com.termux/files/home/.local/glibc/ld-linux-aarch64.so.1 /data/data/com.termux/files/home/.local/bin/agy'"

add_alias_to_file() {
    local file="$1"
    if [ -f "$file" ] || [ "${file##*/}" = ".bashrc" ]; then
        touch "$file"
        if ! grep -q "alias agy=" "$file"; then
            echo "" >> "$file"
            echo "# Antigravity CLI Alias" >> "$file"
            echo "$ALIAS_LINE" >> "$file"
            echo -e "${GREEN}Added 'agy' alias to $file${NC}"
        else
            echo -e "Alias 'agy' already configured in $file"
        fi
    fi
}

add_alias_to_file "$HOME/.bashrc"
add_alias_to_file "$HOME/.zshrc"

echo -e "\n${GREEN}=== Installation Completed Successfully! ===${NC}"
echo -e "Please restart your Termux app or run:"
echo -e "  ${BLUE}source ~/.bashrc${NC}  (or ${BLUE}source ~/.zshrc${NC} if you use Zsh)"
echo -e "Then start the agent by running:"
echo -e "  ${GREEN}agy${NC}"
echo "--------------------------------------------------"
