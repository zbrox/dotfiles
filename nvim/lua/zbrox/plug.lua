return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Fuzzy find
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.3',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Color scheme
  use({ 
	  'rose-pine/neovim', 
	  as = 'rose-pine', 
	  config = function()
		  vim.cmd('colorscheme rose-pine')
	  end
  })

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use("nvim-treesitter/nvim-treesitter-context")
  use('mbbill/undotree')
  use({                                              -- filesystem navigation
  'kyazdani42/nvim-tree.lua',
  requires = 'kyazdani42/nvim-web-devicons'        -- filesystem icons
  })
  use("folke/trouble.nvim")
  -- Git
  use('tpope/vim-fugitive')
  -- LSP
  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v1.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
  }

  use("github/copilot.vim")

  use("folke/which-key.nvim")

  use("tpope/vim-vinegar")
end)
