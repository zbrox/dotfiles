return require('lazy').setup({
    -- Fuzzy find
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            -- find files
            { 'n', '<leader>pf', function() require 'telescope.builtin'.find_files() end, { desc = "Find files in project" } },
            -- find within git files (project find)
            { 'n', '<leader>pg', function() require 'telescope.builtin'.git_files() end,  { desc = "Find files in git repo" } },
            -- ripgrep within the project files
            { 'n', '<leader>pr', function() require 'telescope.builtin'.live_grep() end,  { desc = "Ripgrep in project files" } },
            -- search within open buffers
            { 'n', '<leader>pb', function() require 'telescope.builtin'.buffers() end,    { desc = "Show open buffers" } },
        }
    },

    -- Color scheme
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    },

    -- Syntax highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                -- A list of parser names, or "all" (the five listed parsers should always be installed)
                ensure_installed = { "javascript", "typescript", "rust", "lua", "vim", "vimdoc", "query", "toml" },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = true,

                highlight = {
                    enable = true,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
            })
        end
    },
    { "nvim-treesitter/nvim-treesitter-context" },

    -- Better undo
    {
        'mbbill/undotree',
        keys = {
            { "n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Show undo history" } }
        }
    },
    -- Tree view
    {
        'kyazdani42/nvim-tree.lua',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        keys = {
            { "n", "<leader>tv", ':NvimTreeToggle<CR>', { desc = "Show tree view" } }
        },
        config = function()
            require('nvim-tree').setup {
                disable_netrw = true,
                hijack_netrw = true,
                view = {
                    number = true,
                    relativenumber = true,
                },
                filters = {
                    custom = { ".git" },
                }
            }
        end,
    },
    -- Pretty diagnostics
    {
        "folke/trouble.nvim",
        keys = {
            { "n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true, desc = "Toggle trouble quickfix" } },
        }
    },
    -- Git
    {
        'tpope/vim-fugitive',
        keys = {
            -- git status
            { "n", "<leader>gs", vim.cmd.Git, { desc = "Show git status" } },
        }
    },
    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            local cmp_action = lsp_zero.cmp_action()

            cmp.setup({
                formatting = lsp_zero.cmp_format(),
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                })
            })
        end
    },
    -- last part of the LSP setup
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function()
            -- This is where all the LSP shenanigans will live
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            --- if you want to know more about lsp-zero and mason.nvim
            --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                local opts = { buffer = bufnr, remap = false }

                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            end)

            require('mason-lspconfig').setup({
                ensure_installed = { 'tsserver',
                    'rust_analyzer', },
                handlers = {
                    lsp_zero.default_setup,
                }
            })
        end
    },

    -- GitHub Copilot
    { "github/copilot.vim" },

    -- Helper for keybindings
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },

    -- Enhance netrw
    { "tpope/vim-vinegar" },

    -- Give hints to improve workflows
    {
        "m4xshen/hardtime.nvim",
        dependencies = {
            { "MunifTanjim/nui.nvim" },
            { "nvim-lua/plenary.nvim" }
        },
    },

    -- Nicer buffer line
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            local bufferline = require("bufferline")

            bufferline.setup {
                options = {
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "Explorer",
                            separator = true,
                            text_align = "center"
                        }
                    },
                    diagnostics = "nvim_lsp",
                    separator_style = { "", "" },
                    modified_icon = '●',
                    buffer_close_icon = '×',
                }
            }
        end
    },

    -- Command palette
    {
        "mrjones2014/legendary.nvim",
        dependencies = "kkharji/sqlite.lua",
        -- since legendary.nvim handles all your keymaps/commands,
        -- its recommended to load legendary.nvim before other plugins
        priority = 10000,
        lazy = false,
        config = function()
            require("legendary").setup {
                extensions = {
                    nvim_tree = true,
                    which_key = {
                        auto_register = true
                    }
                },
            }
        end,
        keys = {
            { "n", "<C-p>", "<cmd>Legendary<cr>", { desc = "Command Palette" } }
        }
    },

    -- Improve default vim.ui elements
    { "stevearc/dressing.nvim" }
})
