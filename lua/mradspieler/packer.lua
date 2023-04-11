-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { "ellisonleao/gruvbox.nvim" }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    -- use("nvim-treesitter/nvim-treesitter-context");
    use("theprimeagen/harpoon")
    -- use("theprimeagen/refactoring.nvim")
    use("mbbill/undotree")
    -- use("tpope/vim-fugitive")
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
    use('ray-x/go.nvim')
    use('ray-x/guihua.lua') -- recommended if need floating window support
    use('ray-x/navigator.lua')
    use('mfussenegger/nvim-dap')
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use('dstein64/vim-startuptime')
    use({
        "gbprod/cutlass.nvim",
        config = function()
            require("cutlass").setup({
                cut_key = "m",
            })
        end
    })
    use({
        "gbprod/yanky.nvim",
        config = function()
            require("yanky").setup({
                ring = {
                    history_length = 100,
                    storage = "shada",
                    sync_with_numbered_registers = true,
                    cancel_event = "update",
                },
                picker = {
                    select = {
                        action = nil, -- nil to use default put action
                    },
                    telescope = {
                        mappings = nil, -- nil to use default mappings
                    },
                },
                system_clipboard = {
                    sync_with_ring = true,
                },
                highlight = {
                    on_put = true,
                    on_yank = true,
                    timer = 500,
                },
                preserve_cursor_position = {
                    enabled = true,
                },
            })
        end
    })
    use({
        "gbprod/substitute.nvim",
        config = function()
            require("substitute").setup({
                on_substitute = nil,
                yank_substituted_text = false,
                highlight_substituted_text = {
                    enabled = true,
                    timer = 500,
                },
                range = {
                    prefix = "s",
                    prompt_current_text = false,
                    confirm = false,
                    complete_word = false,
                    motion1 = false,
                    motion2 = false,
                    suffix = "",
                },
                exchange = {
                    motion = false,
                    use_esc_to_cancel = true,
                }
            })
        end
    })
    use {
        'declancm/cinnamon.nvim',
        config = function() require('cinnamon').setup() end
    }
    use('beauwilliams/statusline.lua')
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    use { 'ibhagwan/fzf-lua',
        requires = { 'nvim-tree/nvim-web-devicons' }
    }
end)
