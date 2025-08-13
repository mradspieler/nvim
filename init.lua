local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

----------------
--- plugins ---
----------------
require("lazy").setup({

  -- colorscheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      --change_background()
      require("gruvbox").setup({
        -- contrast = "hard"
      })
      vim.cmd([[colorscheme gruvbox]])
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("lualine").setup({
        options = { theme = 'gruvbox' },
        sections = {
          lualine_c = {
            {
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 2            -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
          }
        }
      })
    end,
  },

  -- search selection via *
  { 'bronson/vim-visual-star-search' },

  -- sql
  {
    "tpope/vim-dadbod",
    "kristijanhusak/vim-dadbod-completion",
    "kristijanhusak/vim-dadbod-ui",
  },

  -- git
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    'tpope/vim-fugitive',
  },
  {
    'lewis6991/gitsigns.nvim',
    -- tag = 'release', -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
    config = function()
      require("gitsigns").setup({})
    end,
  },

  {
    'mbbill/undotree',
  },

  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        filters = {
          dotfiles = true,
        },
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')

          local function opts(desc)
            return {
              desc = 'nvim-tree: ' .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end

          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
          vim.keymap.set('n', 'i', api.node.open.horizontal, opts('Open: Horizontal Split'))
          vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
        end
      })
    end,
  },

  -- save my last cursor position
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true
      })
    end,
  },

  -- markdown
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },

  {
    "mason-org/mason.nvim",
    opts = {}
  },

  {
    "ray-x/navigator.lua",
    config = function()
      require("navigator").setup({
        mason = true,
        lsp = {
          gopls = { cmd = { os.getenv("HOME") .. '/.local/share/nvim/mason/bin/gopls' } }
        }
      })
    end,
  },

  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "ray-x/navigator.lua",
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        luasnip = true,
        trouble = true
      })
      local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require('go.format').goimport()
        end,
        group = format_sync_grp,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  { "rcarriga/nvim-dap-ui",          requires = { "mfussenegger/nvim-dap" } },

  -- java section
  {
    'nvim-java/nvim-java',
    dependencies = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'mfussenegger/nvim-dap',
      {
        'mason-org/mason.nvim',
        opts = {
          registries = {
            'github:nvim-java/mason-registry',
            'github:mason-org/mason-registry',
          },
        },
      }
    },
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xq",
        "<cmd>Trouble quickfix toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- commenting out lines
  {
    "numToStr/Comment.nvim",
    config = function()
      require('Comment').setup({
        opleader = {
          ---Block-comment keymap
          block = '<Nop>',
        },
      })
    end
  },

  {
    'bennypowers/splitjoin.nvim',
    lazy = false,
    keys = {
      { 'gJ', function() require 'splitjoin'.join() end,  desc = 'Join the object under cursor' },
      { 'gS', function() require 'splitjoin'.split() end, desc = 'Split the object under cursor' },
    },
  },

  -- fzf lua extension
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end
  },

  -- fzf extension for telescope with better speed
  {
    "nvim-telescope/telescope-fzf-native.nvim", run = 'make'
  },

  { 'nvim-telescope/telescope-ui-select.nvim' },

  {
    "benfowler/telescope-luasnip.nvim",
    module = "telescope._extensions.luasnip", -- if you wish to lazy-load
  },

  -- fuzzy finder framework
  {
    "nvim-telescope/telescope.nvim",
    --  tag = '0.1.4',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("telescope").setup({
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          }
        }
      })

      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require('telescope').load_extension('fzf')

      -- To get ui-select loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require("telescope").load_extension("ui-select")

      require('telescope').load_extension('luasnip')
    end,
  },

  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
    },
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          "vim",
          "vimdoc",
          "javascript",
          "typescript",
          --          "c",
          "lua",
          --          "rust",
          "go",
          "gomod",
          "diff",
          "dockerfile",
          "bash",
          "toml",
          "sql",
          --          "svelte",
          "regex",
          --          "python",
          "make",
          "markdown",
          "markdown_inline",
          "kotlin",
          "java",
          "json",
          --          "jq",
          "html",
          "http",
          "gitcommit",
          "git_rebase",
          "yaml"
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<space>",   -- maps in normal mode to init the node/scope selection with space
            node_incremental = "<space>", -- increment to the upper named parent
            node_decremental = "<bs>",    -- decrement to the previous node
            scope_incremental = "<tab>",  -- increment to the upper scope (as defined in locals.scm)
          },
        },
        autopairs = {
          enable = true,
        },
        highlight = {
          enable = true,
          -- Disable slow treesitter highlight for large files
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ["iB"] = "@block.inner",
              ["aB"] = "@block.outer",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']]'] = '@function.outer',
            },
            goto_next_end = {
              [']['] = '@function.outer',
            },
            goto_previous_start = {
              ['[['] = '@function.outer',
            },
            goto_previous_end = {
              ['[]'] = '@function.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>sn'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>sp'] = '@parameter.inner',
            },
          },
        },
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {
        check_ts = true,
      }
    end
  },

  -- autocompletion
  { "github/copilot.vim" },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      luasnip.config.setup {}

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and
            vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      require('cmp').setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          format = lspkind.cmp_format {
            with_text = true,
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
            },
          },
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        -- don't auto select item
        preselect = cmp.PreselectMode.None,
        window = {
          documentation = cmp.config.window.bordered(),
        },
        view = {
          entries = {
            name = "custom",
            selection_order = "near_cursor",
          },
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Insert,
        },
        sources = {
          { name = "nvim_lsp", }, -- priority = 9 },
          { name = "luasnip",  keyword_length = 2 },
          { name = "buffer",   keyword_length = 5 },
        },
        performance = {
          -- It is recommended to increase the timeout duration due to
          -- the typically slower response speed of LLMs compared to
          -- other completion sources. This is not needed when you only
          -- need manual completion.
          fetching_timeout = 2000,
        },
      })
    end,
  },

  {
    'declancm/cinnamon.nvim',
    config = function() require('cinnamon').setup() end
  },

  {
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
  },

  {
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
  },

  {
    "gbprod/cutlass.nvim",
    config = function()
      require("cutlass").setup({
        cut_key = "m",
      })
    end
  },

  { 'akinsho/toggleterm.nvim', version = "*", config = true },

  {
    "ryanmsnyder/toggleterm-manager.nvim",
    dependencies = {
      "akinsho/nvim-toggleterm.lua",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
    },
    config = true,
  },

  {

    {
      "Davidyz/VectorCode",
      version = "*",                     -- optional, depending on whether you're on nightly or release
      build = "pipx upgrade vectorcode", -- optional but recommended. This keeps your CLI up-to-date.
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
      "olimorris/codecompanion.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "ravitemer/codecompanion-history.nvim",
      },
      config = function()
        require("codecompanion").setup({
          strategies = {
            chat = {
              adapter = {
                name = "copilot",
                -- model = "claude-sonnet-4",
              },
            },
          },
          prompt_library = {
            ["EmailImprover"] = {
              strategy = "chat",
              description = "Please improve my german email.",
              opts = {
                short_name = "emailImprover",
                auto_submit = true,
                stop_context_insertion = false,
              },
              prompts = {
                {
                  role = "system",
                  content = function(context)
                    return
                    "Act as a professional business communication expert. Enhance the following German email by adding easy-to-understand foreign words as synonyms where appropriate. Use short sentences, each with a maximum of 25 words. Avoid the subjunctive mood. Ensure the tone is assertive, confident, and authoritative."
                  end,
                },
                {
                  role = "user",
                  content = function(context)
                    return "Please write the new email:\n"
                  end,
                },
              },
            },
            ["EmailToEnglish"] = {
              strategy = "chat",
              description = "Please translate into english and improve email.",
              opts = {
                short_name = "emailToEnglisch",
                auto_submit = true,
                stop_context_insertion = false,
              },
              prompts = {
                {
                  role = "system",
                  content = function(context)
                    return
                    "Act as a professional business translator. Translate the following email into English. Enrich the translation with easy-to-understand synonyms and foreign words where appropriate. Use short sentences with a maximum of 25 words each. Avoid using the subjunctive mood. The tone must be assertive, confident, and professional, suitable for business communication. Present the translation in clear, well-structured English. "
                  end,
                },
                {
                  role = "user",
                  content = function(context)
                    return "Please write the new email:\n"
                  end,
                },
              },
            },
            ["Summarize"] = {
              strategy = "chat",
              description = "Please summarize the following text.",
              opts = {
                short_name = "summarize",
                auto_submit = true,
                stop_context_insertion = false,
              },
              prompts = {
                {
                  role = "system",
                  content = function(context)
                    return
                    "I want you to act as a professional technical writer. Please summarize the following text, focusing on clarity and conciseness. Present the summary in plain language using Markdown formatting."
                  end,
                },
                {
                  role = "user",
                  content = function(context)
                    return "Please summarize the following text:\n"
                  end,
                },
              },
            },
            ["BetterNaming"] = {
              strategy = "inline",
              description = "Find better names",
              opts = {
                short_name = "naming",
                auto_submit = true,
                stop_context_insertion = false,
              },
              prompts = {
                {
                  role = "system",
                  content = function(context)
                    return
                    "I want you to act as a naming expert and senior software developer. Please review the following code and suggest more descriptive and meaningful names for all variables and functions. For each suggested name, briefly explain why it is better. Then, provide the improved code with the new names applied. Use Markdown formatting and include the programming language name at the start of the code block."
                  end,
                },
                {
                  role = "user",
                  content = function(context)
                    return "<user_prompt>Please create better names</user_prompt>"
                  end,
                  opts = {
                    contains_code = true,
                  }
                },
              },
            },
            ["Swagger"] = {
              strategy = "chat",
              description = "Create a swagger ui description as YAML",
              opts = {
                short_name = "swagger",
                auto_submit = true,
                stop_context_insertion = false,
              },
              prompts = {
                {
                  role = "system",
                  content = function(context)
                    return
                    "I want you to act as a software developer. Please generate a Swagger (OpenAPI 3.0) YAML specification for the selected Go HTTP server code. The documentation should include all endpoints, HTTP methods, response formats, and example responses. Output only the YAML content.\n"
                  end,
                },
                {
                  role = "user",
                  content = function(context)
                    return "Please create a swagger doc for\n\n"
                  end,
                  opts = {
                    contains_code = true,
                  }
                },
              },
            },
            ["Review"] = {
              strategy = "chat",
              description = "Make a review for the provided code",
              opts = {
                short_name = "review",
                auto_submit = true,
              },
              prompts = {
                {
                  role = "system",
                  content = function(context)
                    local bufnr = vim.api.nvim_get_current_buf()
                    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                    local code = table.concat(lines, "\n")

                    return "I want you to act as a senior " ..
                        context.filetype ..
                        " developer. Please review the following code and provide suggestions for improvements regarding clarity, readability, and simplicity.\n" ..
                        code .. "\n```\n\n"
                  end,
                },
                {
                  role = "user",
                  content = function(context)
                    return "Please review the code...\n"
                  end,
                  opts = {
                    contains_code = true,
                  }
                },
              },
            },
          },
          extensions = {
            vectorcode = {
              opts = {
                add_tool = true,
              }
            },
            history = {
              enabled = true,
              opts = {
                -- Keymap to open history from chat buffer (default: gh)
                keymap = "gh",
                -- Keymap to save the current chat manually (when auto_save is disabled)
                save_chat_keymap = "sc",
                -- Save all chats by default (disable to save only manually using 'sc')
                auto_save = true,
                -- Number of days after which chats are automatically deleted (0 to disable)
                expiration_days = 0,
                -- Picker interface (auto resolved to a valid picker)
                picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
                ---Automatically generate titles for new chats
                auto_generate_title = true,
                title_generation_opts = {
                  ---Adapter for generating titles (defaults to current chat adapter)
                  adapter = "copilot",       -- "copilot"
                  ---Model for generating titles (defaults to current chat model)
                  model = "claude-sonnet-4", -- "gpt-4o"
                },
                ---On exiting and entering neovim, loads the last chat on opening chat
                continue_last_chat = false,
                ---When chat is cleared with `gx` delete the chat from history
                delete_on_clearing_chat = false,
                ---Directory path to save the chats
                dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
                ---Enable detailed logging for history extension
                enable_logging = false,
              }
            }
          }
        })
      end,
    }
  },
})

----------------
--- SETTINGS ---
----------------

-- disable netrw at the very start of our init.lua, because we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true                      -- Enable 24-bit RGB colors

vim.opt.relativenumber = true                     -- Show line numbers
vim.opt.showmatch = true                          -- Highlight matching parenthesis
vim.opt.splitright = true                         -- Split windows right to the current windows
vim.opt.splitbelow = true                         -- Split windows below to the current windows
vim.opt.autowrite = true                          -- Automatically save before :next, :make etc.
vim.opt.autochdir = true                          -- Change CWD when I open a file

vim.opt.mouse = 'a'                               -- Enable mouse support
vim.opt.clipboard = 'unnamedplus'                 -- Copy/paste to system clipboard
vim.opt.swapfile = false                          -- Don't use swapfile
vim.opt.ignorecase = true                         -- Search case insensitive...
vim.opt.smartcase = true                          -- ... but not it begins with upper case
vim.opt.completeopt = 'menuone,noinsert,noselect' -- Autocomplete options

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "undo"

-- Indent Settings
-- I'm in the Spaces camp (sorry Tabs folks), so I'm using a combination of
-- settings to insert spaces all the time.
vim.opt.expandtab = true  -- expand tabs into spaces
vim.opt.shiftwidth = 2    -- number of spaces to use for each step of indent.
vim.opt.tabstop = 2       -- number of spaces a TAB counts for
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.wrap = true

-- This comes first, because we have mappings that depend on leader
-- With a map leader it's possible to do extra key combinations
-- i.e: <leader>w saves the current file
vim.g.mapleader = ','

-- global cwd
vim.g.mycwd = vim.fn.getcwd()

-- json formatting
vim.keymap.set("n", "<leader>jq", "<cmd>:%!jq .<CR>")

-- sql formatting
vim.keymap.set("n", "<leader>sq", "<cmd>:%!pg_format --spaces 2 --function-case 2<CR>")

-- Fast saving
vim.keymap.set("n", '<leader>w', ':write!<CR>')
vim.keymap.set("i", '<leader>w', '<C-o>:write!<CR>')
vim.keymap.set("n", '<leader>q', ':q!<CR>', { silent = true })
vim.keymap.set("i", '<leader>q', '<C-o>:q!<CR>', { silent = true })

-- Some useful quickfix shortcuts for quickfix
vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-m>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>a', '<cmd>cclose<CR>')

-- Exit mode in insert mode on jj
vim.keymap.set('i', 'jj', '<ESC>')

-- Remove search highlight
vim.keymap.set('n', '<leader><space>', ':nohlsearch<CR>')

-- Search mappings: These will make it so that going to the next one in a
-- search will center on the line it's found in.
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true })

-- setup mapping to call :LazyGit
vim.keymap.set('n', '<leader>gi', ':LazyGit<CR>')

-- setup mapping for git
vim.keymap.set("n", "<leader>gp", ":Gdiff<CR>", {})
vim.keymap.set("n", "<leader>gb", ":G blame<CR>", {})

vim.keymap.set("n", "<leader>cc", ":CodeCompanionChat toggle<CR>", {})
vim.keymap.set("n", "<leader>co", ":CodeCompanionActions<CR>", {})

-- Don't jump forward if I higlight and search for a word
local function stay_star()
  local sview = vim.fn.winsaveview()
  local args = string.format("keepjumps keeppatterns execute %q", "sil normal! *")
  vim.api.nvim_command(args)
  vim.fn.winrestview(sview)
end
vim.keymap.set('n', '*', stay_star, { noremap = true, silent = true })

-- We don't need this keymap, but here we are. If I do a ctrl-v and select
-- lines vertically, insert stuff, they get lost for all lines if we use
-- ctrl-c, but not if we use ESC. So just let's assume Ctrl-c is ESC.
vim.keymap.set('i', '<C-c>', '<ESC>')

-- If I visually select words and paste from clipboard, don't replace my
-- clipboard with the selected word, instead keep my old word in the
-- clipboard
vim.keymap.set("x", "p", "\"_dP")

-- rename the word under the cursor
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Better split switching
vim.keymap.set('', '<C-j>', '<C-W>j')
vim.keymap.set('', '<C-k>', '<C-W>k')
vim.keymap.set('', '<C-h>', '<C-W>h')
vim.keymap.set('', '<C-l>', '<C-W>l')

-- Visual linewise up and down by default (and use gj gk to go quicker)
vim.keymap.set('n', '<Up>', 'gk')
vim.keymap.set('n', '<Down>', 'gj')

-- Yanking a line should act like D and C
vim.keymap.set('n', 'Y', 'y$')

-- Visually select lines, and move them up/down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")

-- Terminal
-- Clost terminal window, even if we are in insert mode
vim.keymap.set('t', '<leader>q', '<C-\\><C-n>:q<cr>')

-- switch to normal mode with esc
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')

-- Open terminal in vertical and horizontal split
vim.keymap.set('n', '<leader>tv', '<cmd>vnew term://zsh<CR>', { noremap = true })
vim.keymap.set('n', '<leader>ts', '<cmd>split term://zsh<CR>', { noremap = true })

-- Open terminal in vertical and horizontal split, inside the terminal
vim.keymap.set('t', '<leader>tv', '<c-w><cmd>vnew term://zsh<CR>', { noremap = true })
vim.keymap.set('t', '<leader>ts', '<c-w><cmd>split term://zsh<CR>', { noremap = true })

-- mappings to move out from terminal to other views
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l')

-- we don't use netrw (because of nvim-tree), hence re-implement gx to open
-- links in browser
vim.keymap.set("n", "gx", '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>')

-- automatically switch to insert mode when entering a Term buffer
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
  group = vim.api.nvim_create_augroup("openTermInsert", {}),
  callback = function(args)
    -- we don't use vim.startswith() and look for test:// because of vim-test
    -- vim-test starts tests in a terminal, which we want to keep in normal mode
    if vim.endswith(vim.api.nvim_buf_get_name(args.buf), "zsh") then
      vim.cmd("startinsert")
    end
  end,
})

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("help_window_right", {}),
  pattern = { "*.txt" },
  callback = function()
    if vim.o.filetype == 'help' then vim.cmd.wincmd("L") end
  end
})

-- don't show number
vim.api.nvim_create_autocmd("TermOpen", {
  command = [[setlocal nonumber norelativenumber]]
})

-- File-tree mappings
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', { noremap = true })
vim.keymap.set('n', '<leader>f', ':NvimTreeFindFile!<CR>', { noremap = true })

-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- go.nvim
vim.keymap.set('n', '<leader>b', ':write!<CR>:GoBuild<CR>')
vim.keymap.set('n', '<leader>r', ':write!<CR>:GoRun -F<CR>')
vim.keymap.set('n', '<leader>t', ':write!<CR>:GoTest -n<CR>')
vim.keymap.set('n', '<leader>gv', ':write!<CR>:GoAltV!<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tt', ':write!<CR>:GoAlt!<CR>', { noremap = true, silent = true })

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ cwd = vim.g.mycwd }) end, {})
vim.keymap.set('n', '<leader>ld', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>td', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>gs', builtin.grep_string, {})
vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.command_history, {})

-- diagnostics
vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>ds', vim.diagnostic.setqflist)

-- disable diagnostics, I didn't like them
vim.lsp.handlers["textDocument/publishDiagnostics"] = function()
end

-- Go uses gofmt, which uses tabs for indentation and spaces for aligment.
-- Hence override our indentation rules.
vim.api.nvim_create_autocmd('Filetype', {
  group = vim.api.nvim_create_augroup('setIndent', { clear = true }),
  pattern = { 'go' },
  command = 'setlocal noexpandtab tabstop=4 shiftwidth=4'
})

-- Run gofmt/gofmpt, import packages automatically on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('setGoFormatting', { clear = true }),
  pattern = '*.go',
  callback = function()
    local params = vim.lsp.util.make_range_params(nil, "utf-16")
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 2000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end

    vim.lsp.buf.format()
  end
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('UserLspConfig', {}),
--   callback = function(ev)
--     -- Buffer local mappings.
--     -- See `:help vim.lsp.*` for documentation on any of the below functions
--     local opts = { buffer = ev.buf }
--
--     vim.keymap.set('n', 'gd', "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
--     vim.keymap.set('n', '<leader>v', "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
--     vim.keymap.set('n', '<leader>s', "<cmd>belowright split | lua vim.lsp.buf.definition()<CR>", opts)
--     vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--     vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--     vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--     vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--     vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
--     vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
--     vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
--   end,
-- })

-- Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*", -- or "*" for all types
  callback = function()
    vim.opt_local.foldmethod     = "expr"
    vim.opt_local.foldexpr       = "nvim_treesitter#foldexpr()"
    vim.opt_local.foldlevelstart = 99
    vim.opt.foldenable           = false
  end,
})

-- automatically resize all vim buffers if I resize the terminal window
vim.api.nvim_command('autocmd VimResized * wincmd =')
vim.keymap.set("n", "<leader>ls", "<cmd>lua require(\"luasnip.loaders\").edit_snippet_files()<cr>",
  { silent = true, noremap = true })
-- vim.lsp.set_log_level("debug")

-- copilot config
vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)')
-- vim.api.nvim_set_hl(0, 'CopilotSuggestion', { fg = '#E3242B', ctermfg = 8 })

-- folding
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*", -- or "*" for all types
  callback = function()
    vim.opt_local.foldmethod     = "expr"
    vim.opt_local.foldexpr       = "nvim_treesitter#foldexpr()"
    vim.opt_local.foldlevelstart = 99
    vim.opt.foldenable           = false
  end,
})

-- yanky.nvim
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

-- lspconfig
vim.lsp.config('jdtls', {
  cmd = { os.getenv("HOME") .. '/.local/share/nvim/mason/bin/jdtls' },
  filetypes = { 'java' },
})
vim.lsp.enable('jdtls')

vim.lsp.config('yamlls', {
  cmd = { os.getenv("HOME") .. '/.local/share/nvim/mason/bin/yaml-language-server', "--stdio" },
  filetypes = { 'yaml' },
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["../path/relative/to/file.yml"] = "/.github/workflows/*",
        ["/path/from/root/of/project"] = "/.github/workflows/*",
      },
    },
  },
})
vim.lsp.enable('yamlls')

vim.lsp.config('kotlin_language_server', {
  cmd = { os.getenv("HOME") .. '/.local/share/nvim/mason/bin/kotlin-language-server' },
  filetypes = { 'kotlin' },
})
vim.lsp.enable('kotlin_language_server')

vim.lsp.config('jsonls', {
  cmd = { os.getenv("HOME") .. '/.local/share/nvim/mason/bin/vscode-json-language-server', "--stdio" },
  filetypes = { 'json' },
})
vim.lsp.enable('jsonls')

vim.lsp.config('lua_ls', {
  cmd = { os.getenv("HOME") .. '/.local/share/nvim/mason/bin/lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      diagnostics = {
        enable = true,
        globals = { "vim", "describe", "it", "before_each", "after_each", "teardown", "pending" }
      },
      hint = {
        enable = true,
        typeCoverage = true
      },
    },
  },
})
vim.lsp.enable('lua_ls')

vim.lsp.config('gopls', {
  cmd = { os.getenv("HOME") .. '/.local/share/nvim/mason/bin/gopls' },
  filetypes = { "go", "gomod", "gowork", "gohtml", "gotmpl", "go.html", "go.tmpl" },
  root_markers = { 'go.mod' },
  settings = {
    gopls = {
      usePlaceholders = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      experimentalPostfixCompletions = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-node_modules" },
      semanticTokens = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  }
})
vim.lsp.enable('gopls')
