# --- Configuration ---
REPO_ROOT := $(shell pwd)
SHELL_CONFIG ?= $(HOME)/.zshrc

# Define Editor Paths based on OS
ifeq ($(OS),Darwin)
	CONFIG_PATH := $(HOME)/Library/Application Support/%s
else
	CONFIG_PATH := $(HOME)/.config/%s
endif

CODE_DIR ?= $(shell printf "$(CONFIG_PATH)" "Code/User")
CODIUM_DIR ?= $(shell printf "$(CONFIG_PATH)" "VSCodium/User")


install: ## Run full installation (Link + Shell config)
install: link shell


link: ## Link config files safely
	@echo "🔗 Linking Common Apps..."
	lns config/alacritty $(HOME)/.config/alacritty
	lns config/nvim $(HOME)/.config/nvim
	lns config/starship.toml $(HOME)/.config/starship.toml
	
ifeq ($(OS),Linux)
	@echo "🐧 Linking Linux Specifics..."
	lns config/sway $(HOME)/.config/sway
endif

	@echo "📝 Checking for Editors (Dynamic Linking)..."
	@# Loop over both editor paths. Quotes are CRITICAL for macOS paths with spaces.
	@for target_dir in "$(CODE_DIR)" "$(CODIUM_DIR)"; do \
		if [ -d "$$target_dir" ]; then \
			echo "   [Editor] Found at $$target_dir. Linking configs..."; \
			for src in config/vscode/*; do \
				lns "$$src" "$$target_dir/$$(basename "$$src")"; \
			done; \
		fi; \
	done


shell: ## Configure Zsh entrypoint
	@echo "🐚 Configuring shell in $(SHELL_CONFIG)..."
	@if [ -n "$(DRY_RUN)" ]; then \
		echo "   [DRY-RUN] Would check/append source to $(SHELL_CONFIG)"; \
	else \
		touch $(SHELL_CONFIG); \
		if grep -q "$(REPO_ROOT)/profile.zsh" "$(SHELL_CONFIG)"; then \
			echo "   [SKIP] Entrypoint already present."; \
		else \
			echo "" >> "$(SHELL_CONFIG)"; \
			echo "# 🔧 Dotfiles Entry Point" >> "$(SHELL_CONFIG)"; \
			echo "[ -f \"$(REPO_ROOT)/profile.zsh\" ] && source \"$(REPO_ROOT)/profile.zsh\"" >> "$(SHELL_CONFIG)"; \
			echo "   [OK] Added source command."; \
		fi \
	fi
