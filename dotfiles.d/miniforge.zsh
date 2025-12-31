# ------------------------------------------------------------------------------
# Miniforge / Conda / Mamba Configuration
# ------------------------------------------------------------------------------
# curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && bash Miniforge3-$(uname)-$(uname -m).sh -b -p "$HOME/miniforge3" && rm Miniforge3-$(uname)-$(uname -m).sh

__conda_path="$HOME/miniforge3"

if [[ -d "$__conda_path" ]]; then
  __conda_env="$__miniforge_home/etc/profile.d/conda.sh"

  # Try to use the modern 'conda shell.zsh hook' (Fast & Clean)
  # This sets up the environment without manually modifying PATH heavily
  __conda_setup="$("$__conda_path/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
  
  if [[ $? -eq 0 ]]; then
    eval "$__conda_setup"
  else
    # Fallback: Source the profile script if hook fails
    if [[ -f "$__conda_env" ]]; then
      source "$__conda_env"
    else
      # Last Resort: Just add bin to PATH
      export PATH="$__conda_path/bin:$PATH"
    fi
  fi
  
  # Initialize mamba as well
  eval "$(mamba shell hook --shell zsh)"

fi

unset __conda_path __conda_setup __conda_env
