# Dotfiles

My personal configuration files, optimized for a cross-platform workflow between **Manjaro Linux (Sway)** and **macOS**.

Focused on performance, modularity, and a unified development environment.

## 📂 Project Structure

```text
.
├── bin/                   # Custom scripts & helpers (added to PATH)
├── config/                # App configurations (nvim, sway, alacritty, etc.)
├── dotfiles.d/            # Zsh modules (loaded by main.zsh)
│   ├── darwin.zsh         # macOS specific settings
│   ├── linux.zsh          # Linux specific settings
│   ├── keys.zsh           # Unified keybindings
│   └── ...
├── profile.zsh            # Entry point (sourced by .zshrc)
└── Makefile               # Installation orchestrator

```

## 🚀 Tech Stack

* **Shell:** Zsh + Powerlevel10k
* **Terminal:** Alacritty + Zellij (Multiplexer)
* **WM:** Sway + Waybar (Status) + SwayNC (Notifications)
* **Launcher:** Rofi (Linux) / Raycast (macOS)
* **Editor:** Neovim (primary) / VSCodium (Linux) / VSCode (macOS)
* **Tools:** Fastfetch, FZF, ASDF, Miniforge, Rust, SDKMAN!

---

## 📦 Dependencies & Setup

Before running the `make` installer, you need to set up the environment. Since I prefer not to let installers mess with my `.zshrc` automatically, some tools require manual installation flags.

### 1. System Packages

#### 🐧 Arch Linux / Manjaro

```bash
# Core tools, WM, and Terminal
yay -S sway swaybg swayidle swaylock waybar swaync
yay -S alacritty zellij neovim fastfetch fzf asdf-vm

# Launcher & Utilities
yay -S rofi-wayland brightnessctl wl-clipboard

# Screenshot Tools (Grim/Slurp/Swappy)
yay -S grim slurp swappy jq

# Editors
yay -S vscodium-bin

```

#### 🍎 macOS

```bash
brew install alacritty zellij neovim fastfetch fzf asdf
# Applications
brew install --cask visual-studio-code raycast

```

### 2. Zsh Plugins & Theme (Git Clone)

These are loaded manually by `dotfiles.d/main.zsh`.

```bash
# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k

# or Starship
curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin

# Zsh Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions

```

### 3. Development Tools (Manual Install)

These tools are installed in isolation. The dotfiles handle the `PATH` logic dynamically.

* **Rust (Cargo):**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

```


* **SDKMAN! (Java/Kotlin):**
*Installs without modifying shell config (`zsh_rc=false`).*
```bash
curl -s "https://get.sdkman.io?rcupdate=false" | bash

```


* **Miniforge (Python/Conda):**
*Installs to `~/miniforge3` without modifying shell config (`-b`).*
```bash
miniforge_installer="Miniforge3-$(uname)-$(uname -m).sh" && \
    curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/$miniforge_installer" && \
    bash $miniforge_installer -b -p "$HOME/miniforge3" && \
    rm $miniforge_installer
```


* **Google Cloud SDK:**
*Extracted to `~/Devel/Tools`.*
```bash
mkdir -p "$HOME/Devel/Tools"
curl -SL "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz" \
| tar xzvf - -C "$HOME/Devel/Tools/"

```


---

## 🛠️ Installation

Once dependencies are ready, use the **Makefile** to link configurations and set up the shell entry point.

### 1. Clone

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

```

### 2. Dry Run (Optional)

Check what the installer will do without changing anything:

```bash
make install DRY_RUN=1

```

### 3. Install

This will safe-link configs (making backups if needed) and append the source command to your `.zshrc`.

```bash
make install

```

> **Note:** The `install` target runs two sub-tasks:
> * `make link`: Symlinks apps (Nvim, Sway, Alacritty) and Editor Configs (VSCode/Codium JSONs).
> * `make shell`: Adds `source ~/dotfiles/profile.zsh` to your shell config.
> 

