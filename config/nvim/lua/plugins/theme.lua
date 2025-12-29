return {
  {
    "catppuccin/nvim", 
    name = "catppuccin", 
    priority = 1000 -- Importante para carregar antes da interface renderizar
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}