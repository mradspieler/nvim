-- This comes first, because we have mappings that depend on leader
-- With a map leader it's possible to do extra key combinations
-- i.e: <leader>w saves the current file
vim.g.mapleader = ','

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
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
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
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
      require("gitsigns").setup({
        current_line_blame = false, -- Toggle with ,BB
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 100,
        },
        on_attach = function(bufnr)
          -- Set a visible highlight for blame text (after colorscheme loads)
          vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { 
            fg = '#928374', -- Gruvbox gray (visible but not too bright)
            italic = true,
            bold = false
          })
          local gs = package.loaded.gitsigns

          -- Navigation between hunks
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = "Next hunk" })

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = "Previous hunk" })

          -- Actions
          vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
          vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
          vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, { buffer = bufnr, desc = "Stage hunk" })
          vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, { buffer = bufnr, desc = "Reset hunk" })
          vim.keymap.set('n', '<leader>hS', gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
          vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
          vim.keymap.set('n', '<leader>hR', gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
          vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
          vim.keymap.set('n', '<leader>hb', function() gs.blame_line({full=true}) end, { buffer = bufnr, desc = "Blame line" })
          vim.keymap.set('n', '<leader>BB', '<cmd>Gitsigns toggle_current_line_blame<CR>', { buffer = bufnr, desc = "Toggle inline blame" })
          vim.keymap.set('n', '<leader>hd', gs.diffthis, { buffer = bufnr, desc = "Diff this" })
          vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end, { buffer = bufnr, desc = "Diff this ~" })
          vim.keymap.set('n', '<leader>td', gs.toggle_deleted, { buffer = bufnr, desc = "Toggle deleted" })

          -- Text object
          vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr, desc = "Select hunk" })
        end
      })
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
        -- 1. Sidebar appearance and "Fixed" behavior
        view = {
          width = 35,
          -- fixed_width = true,
          side = "left",
        },

        -- 2. Visuals and Icons
        renderer = {
          highlight_opened_files = "all", -- Highlights files you currently have open
          add_trailing = true,            -- Adds a / to folders
          group_empty = true,             -- Compacts empty folder hierarchies
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },

        -- 3. Behavior and Interactivity
        update_focused_file = {
          enable = true,      -- Automatically focus the file in the tree that you are currently editing
          update_root = true, -- Change the tree root if you switch to a file outside the current project
        },

        -- 4. Git Integration
        git = {
          enable = true,
          ignore = false, -- Set to true if you want to hide files in .gitignore
          timeout = 500,
        },

        -- 5. Helpful Diagnostics
        diagnostics = {
          enable = true, -- Shows LSP errors/warnings directly in the tree
          show_on_dirs = true,
        },
        sort_by = "case_sensitive",
        filters = {
          dotfiles = true,
        },
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

  -- nvim-jdtls for proper Java support (handles source attachments correctly)
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    config = function()
      -- Wird jedes Mal ausgeführt, wenn eine .java Datei geöffnet wird
      local jdtls = require("jdtls")
      -- Pfad zu jdtls (am besten über mason)

      local jdtls_path = os.getenv("HOME") .. '/.local/share/nvim/mason/packages/jdtls'
      -- local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      -- local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name

      local config = {

        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=WARN",
          "-Xmx2g",
          "-XX:+UseG1GC",
          "-XX:GCTimeRatio=4",
          "-XX:AdaptiveSizePolicyWeight=90",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-javaagent:" .. jdtls_path .. "/lombok.jar",
          "-jar", vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
          "-configuration", jdtls_path .. "/config_" .. (function()
            if vim.fn.has("mac") == 1 then
              return vim.fn.system("uname -m"):find("arm64") and "mac_arm" or "mac"
            end
            return "linux"
          end)(),
          "-data", vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
        },

        root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

        -- init_options ist wichtig für DAP/Debugging Support
        init_options = {
          bundles = vim.list_extend(
            -- java-debug extension für DAP
            vim.split(vim.fn.glob(os.getenv("HOME") .. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1), "\n"),
            -- java-test extension für Test-Debugging
            vim.split(vim.fn.glob(os.getenv("HOME") .. "/.local/share/nvim/mason/packages/java-test/extension/server/*.jar", 1), "\n")
          )
        },

        settings = {
          java = {
            eclipse = { downloadSources = true },
            maven = { downloadSources = true },
            references = { includeDecompiledSources = true },
            referencesCodeLens = { enabled = true },
            implementationsCodeLens = { enabled = true },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },

            configuration = {
              runtimes = {
                {
                  name = "JavaSE-21",
                  path = os.getenv("JAVA_HOME") or os.getenv("HOME") .. "/.sdkman/candidates/java/current",
                  default = true,
                },
              },
            },

            completion = {
              filteredTypes = {
                "com.sun.*",
                "sun.*",
                "jdk.internal.*",
                "org.graalvm.*",
                "io.micrometer.shaded.*",
              },
            },

            imports = {
              order = { "java", "javax", "com", "org" },
            },

            format = {
              enabled = true,
            },

            symbols = {
              includeSourceMethodDeclarations = true,
            },
          },
        },

        -- Wichtig für gute Performance & Features
        capabilities = require("cmp_nvim_lsp").default_capabilities(),

        on_attach = function(client, bufnr)
          -- Deine normalen on_attach Dinge (keymaps etc.)
          -- z. B. require("lspconfig").util.default_on_attach(client, bufnr)
          -- JDTLS-spezifische Befehle / extended capabilities
          jdtls.extendedClientCapabilities = jdtls.extendedClientCapabilities

          -- WICHTIG: DAP-Setup für Java-Debugging
          require('jdtls').setup_dap({ hotcodereplace = 'auto' })
          require('jdtls.dap').setup_dap_main_class_configs()
        end,
      }

      -- Starte oder verbinde
      jdtls.start_or_attach(config)
    end,

  },

  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
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

  -- debugger
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"

      require("dapui").setup()
      require("dap-go").setup()

      require("nvim-dap-virtual-text").setup {}

      -- Java DAP adapter wird von nvim-jdtls automatisch registriert via setup_dap()
      -- Konfigurationen für verschiedene Java Debug-Szenarien
      dap.configurations.java = {
        {
          name = "Debug Launch (2GB)";
          type = 'java';
          request = 'launch';
          vmArgs = "" ..
          "-Xmx2g "
        },
        {
          name = "Debug Attach (5005)";
          type = 'java';
          request = 'attach';
          hostName = "127.0.0.1";
          port = 5005;
        },
        {
          name = "My Custom Java Run Configuration",
          type = "java",
          request = "launch",
          -- You need to extend the classPath to list your dependencies.
          -- `nvim-jdtls` would automatically add the `classPaths` property if it is missing
          -- classPaths = {},

          -- If using multi-module projects, remove otherwise.
          -- projectName = "yourProjectName",

          -- javaExec = "java",
          mainClass = "com.example.App",

          -- If using the JDK9+ module system, this needs to be extended
          -- `nvim-jdtls` would automatically populate this property
          -- modulePaths = {},
          -- vmArgs = "" ..
          --   "-Xmx2g "
        },
      }

      vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set("n", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<F1>", dap.continue)
      vim.keymap.set("n", "<F2>", dap.step_into)
      vim.keymap.set("n", "<F3>", dap.step_over)
      vim.keymap.set("n", "<F4>", dap.step_out)
      vim.keymap.set("n", "<F5>", dap.step_back)
      vim.keymap.set("n", "<F13>", dap.restart)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },

  -- Mason for LSP server management
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 
          'gopls', 
          'jdtls', 
          'lua_ls', 
          'jsonls', 
          'yamlls', 
          'kotlin_language_server' 
        },
        automatic_installation = true,
        -- Don't auto-configure jdtls — nvim-jdtls handles it
        handlers = {
          function(server_name)
            if server_name == 'jdtls' then return end
          end,
        },
      })

      -- Ensure Java debugging tools are installed
      local mason_registry = require("mason-registry")
      local packages_to_install = {
        "java-debug-adapter",
        "java-test"
      }

      for _, pkg_name in ipairs(packages_to_install) do
        local pkg = mason_registry.get_package(pkg_name)
        if not pkg:is_installed() then
          vim.notify("Installing " .. pkg_name, vim.log.levels.INFO)
          pkg:install()
        end
      end
    end,
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
      require("fzf-lua").setup({
        -- 1. Globale Formatter-Einstellungen
        defaults = {
          formatter = "path.filename_first", -- Zeigt 'MyClass.java  [src/c/b/i]'
        },

        -- 2. Fenster-Layout (Vorschau links)
        winopts = {
          preview = {
            layout = 'horizontal',
            horizontal = 'right:65%',
          },
        },

        -- 3. Pfad-Kürzung erzwingen
        files = {
          path_shorten = 1,
          -- fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude '*.class' --exclude '*.exe'",
        },

        -- 4. Speziell für LSP (Referenzen, Definitionen)
        lsp = {
          path_shorten = 1, -- Hier muss es für 'gr' und 'gd' oft extra stehen
          includeDeclaration = false,
        }
      })
    end
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
      require('nvim-treesitter').setup({
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
          "gosum",
          "gotmpl",
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
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
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

  -- AI autocompletion
  {
    "Exafunction/windsurf.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
        -- Optionally disable cmp source if using virtual text only
        enable_cmp_source = false,
        virtual_text = {
          enabled = true,

          -- These are the defaults

          -- Set to true if you never want completions to be shown automatically.
          manual = false,
          -- A mapping of filetype to true or false, to enable virtual text.
          filetypes = {},
          -- Whether to enable virtual text of not for filetypes not specifically listed above.
          default_filetype_enabled = true,
          -- How long to wait (in ms) before requesting completions after typing stops.
          idle_delay = 75,
          -- Priority of the virtual text. This usually ensures that the completions appear on top of
          -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
          -- desired.
          virtual_text_priority = 65535,
          -- Set to false to disable all key bindings for managing completions.
          map_keys = true,
          -- The key to press when hitting the accept keybinding but no completion is showing.
          -- Defaults to \t normally or <c-n> when a popup is showing. 
          accept_fallback = nil,
          -- Key bindings for managing completions in virtual text mode.
          key_bindings = {
            -- Accept the current completion.
            accept = "<C-j>",
            -- Accept the next word.
            accept_word = false,
            -- Accept the next line.
            accept_line = false,
            -- Clear the virtual text.
            clear = false,
            -- Cycle to the next completion.
            next = "<M-n>",
            -- Cycle to the previous completion.
            prev = "<M-p>",
          }
        }
      })
    end
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
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
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") ==
        nil
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
          { name = "path" },
        },
        performance = {
          -- It is recommended to increase the timeout duration due to
          -- the typically slower response speed of LLMs compared to
          -- other completion sources. This is not needed when you only
          -- need manual completion.
          fetching_timeout = 500,
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
})


----------------
--- SETTINGS ---
----------------

-- disable netrw at the very start of our init.lua, because we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true                      -- Enable 24-bit RGB colors
vim.opt.signcolumn = "yes"                        -- Always show sign column to avoid gutter jumps

vim.opt.relativenumber = true                     -- Show line numbers
vim.opt.showmatch = true                          -- Highlight matching parenthesis
vim.opt.splitright = true                         -- Split windows right to the current windows
vim.opt.splitbelow = true                         -- Split windows below to the current windows
vim.opt.autowrite = true                          -- Automatically save before :next, :make etc.
vim.opt.autochdir = false                         -- Change CWD when I open a file

vim.opt.mouse = 'a'                               -- Enable mouse support
vim.opt.clipboard = 'unnamedplus'                 -- Copy/paste to system clipboard
vim.opt.swapfile = false                          -- Don't use swapfile
vim.opt.ignorecase = true                         -- Search case insensitive...
vim.opt.smartcase = true                          -- ... but not it begins with upper case
vim.opt.completeopt = 'menuone,noinsert,noselect' -- Autocomplete options

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

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
-- (mapleader is set at the top of the file, before lazy.setup)

-- global cwd
vim.g.mycwd = vim.fn.getcwd()

-- json formatting
vim.keymap.set("n", "<leader>jq", function()
  if vim.fn.executable("jq") == 0 then
    vim.notify("jq not installed", vim.log.levels.ERROR)
    return
  end
  vim.cmd(":%!jq .")
end, { desc = "Format JSON with jq" })

-- sql formatting
vim.keymap.set("n", "<leader>sq", function()
  if vim.fn.executable("pg_format") == 0 then
    vim.notify("pg_format not installed", vim.log.levels.ERROR)
    return
  end
  vim.cmd(":%!pg_format --spaces 2 --function-case 2")
end, { desc = "Format SQL with pg_format" })

-- Fast saving
vim.keymap.set("n", '<leader>w', ':write!<CR>')
vim.keymap.set("i", '<leader>w', '<C-o>:write!<CR>')
vim.keymap.set("n", '<leader>q', ':q!<CR>', { silent = true })
vim.keymap.set("i", '<leader>q', '<C-o>:q!<CR>', { silent = true })

-- Quickfix navigation (Alt-based to avoid conflict with yanky)
vim.keymap.set('n', '<A-j>', '<cmd>cnext<CR>zz', { desc = "Next quickfix" })
vim.keymap.set('n', '<A-k>', '<cmd>cprev<CR>zz', { desc = "Previous quickfix" })
vim.keymap.set('n', '<A-J>', '<cmd>clast<CR>zz', { desc = "Last quickfix" })
vim.keymap.set('n', '<A-K>', '<cmd>cfirst<CR>zz', { desc = "First quickfix" })
vim.keymap.set('n', '<leader>a', '<cmd>cclose<CR>', { desc = "Close quickfix" })

-- Exit mode in insert mode on jj
vim.keymap.set('i', 'jj', '<ESC>')

-- Remove search highlight
--vim.keymap.set('n', '<leader><space>', ':nohlsearch<CR>')

-- Search mappings: These will make it so that going to the next one in a
-- search will center on the line it's found in.
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true })

-- setup mapping to call :LazyGit
vim.keymap.set('n', '<leader>gi', ':LazyGit<CR>')

-- setup mapping for git
vim.keymap.set("n", "<leader>gp", ":Gdiff<CR>", {})
vim.keymap.set("n", "<leader>gb", ":G blame<CR>", {})

-- Global git blame toggle (works even if gitsigns hasn't attached)
vim.keymap.set('n', '<leader>BB', '<cmd>Gitsigns toggle_current_line_blame<CR>', { desc = "Toggle git blame (global)" })

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
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    -- Auto-insert for interactive shells (zsh), but NOT for vim-test terminals
    -- Also auto-insert for build tools (mvn, gradle) to enable auto-scrolling
    if vim.endswith(bufname, "zsh") or 
      bufname:match("mvn") or 
      bufname:match("gradle") then
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
vim.keymap.set('n', '<leader>gc', ':GoCoverage<CR>', { desc = "Go coverage" })
vim.keymap.set('n', '<leader>gC', ':GoCoverageClear<CR>', { desc = "Clear coverage" })
vim.keymap.set('n', '<leader>gat', ':GoAddTag<CR>', { desc = "Add struct tags" })
vim.keymap.set('n', '<leader>grt', ':GoRmTag<CR>', { desc = "Remove struct tags" })

-- Java build/run commands (non-blocking, live output in terminal split)
vim.keymap.set('n', '<leader>jb', '<cmd>write!<CR><cmd>belowright 15split | terminal mvn clean compile<CR>', { desc = "Maven build" })
vim.keymap.set('n', '<leader>jt', '<cmd>write!<CR><cmd>belowright 15split | terminal mvn test<CR>', { desc = "Maven test" })
vim.keymap.set('n', '<leader>jT', function()
  require('jdtls').test_class()
end, { desc = "Run test class (no debug)" })
vim.keymap.set('n', '<leader>jc', function()
  require('jdtls').compile('full')
end, { desc = "JDTLS full compile" })

-- fzf-lua
-- project navigation
vim.keymap.set('n', '<leader>gf', ':FzfLua git_files<CR>', {})
vim.keymap.set('n', '<leader>ff', ':FzfLua files<CR>', {})
vim.keymap.set('n', '<leader>fb', ':FzfLua buffers<CR>', {})
-- search
vim.keymap.set('n', '<leader>gs', ':FzfLua grep_project<CR>', {})
vim.keymap.set('n', '<leader>lg', ':FzfLua live_grep<CR>', {})
vim.keymap.set('n', '<leader>lm', function()
  require('fzf-lua').live_grep({
    prompt = 'Java Methods> ',
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g '*.java' -e '(public|private|protected|static|\\s) +[\\w\\<\\>\\[\\]]+\\s+(\\w+) *\\('",
  })
end, { desc = "Search Java methods" })
-- diagnostic
vim.keymap.set('n', '<leader>td', ':FzfLua diagnostics_workspace<CR>', {})
-- history
vim.keymap.set('n', '<leader>fh', ':FzfLua command_history<CR>', {})

-- diagnostics
vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>dd', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>ds', vim.diagnostic.setqflist)

-- Configure diagnostics display (no inline text, but show signs and underlines)
vim.diagnostic.config({
  virtual_text = false,      -- No inline text noise
  signs = true,              -- Show icons in gutter
  underline = true,          -- Underline errors/warnings
  severity_sort = true,      -- Errors before warnings
  update_in_insert = false,  -- Only update in normal mode
})

-- Go uses gofmt, which uses tabs for indentation and spaces for aligment.
-- Hence override our indentation rules.
vim.api.nvim_create_autocmd('Filetype', {
  group = vim.api.nvim_create_augroup('setIndent', { clear = true }),
  pattern = { 'go' },
  command = 'setlocal noexpandtab tabstop=4 shiftwidth=4'
})

-- Java uses 2 spaces (already default, but explicit for clarity)
vim.api.nvim_create_autocmd('Filetype', {
  group = vim.api.nvim_create_augroup('setJavaIndent', { clear = true }),
  pattern = { 'java' },
  command = 'setlocal expandtab tabstop=2 shiftwidth=2'
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf, silent = true }
    local fzf = require('fzf-lua')

    -- Navigator-Ersatz: Definitionen & Referenzen mit Vorschau links
    vim.keymap.set('n', 'gd', fzf.lsp_definitions, opts)
    vim.keymap.set('n', 'gr', fzf.lsp_references, opts)
    vim.keymap.set('n', '<leader>v', "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set('n', '<leader>s', "<cmd>belowright split | lua vim.lsp.buf.definition()<CR>", opts)

    -- Struktur-Suche innerhalb der aktuellen Java-Datei
    vim.keymap.set('n', '<leader>ld', fzf.lsp_document_symbols, opts)

    -- Die "Google-Suche" für dein Java-Projekt (Methoden, Klassen, Enums)
    vim.keymap.set('n', '<leader>lw', fzf.lsp_live_workspace_symbols, opts)

    -- Code Actions & Refactoring
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', fzf.lsp_code_actions, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

    -- Standard LSP Funktionen
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

    -- Inlay hints toggle (if supported by LSP)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      -- Enable inlay hints by default for Go and Lua (Java enabled in jdtls on_attach)
      if vim.bo[ev.buf].filetype == 'go' or vim.bo[ev.buf].filetype == 'lua' then
        vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
      end
      
      -- Toggle keybinding
      vim.keymap.set('n', '<leader>lh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
      end, { buffer = ev.buf, desc = "Toggle inlay hints" })
    end

    -- Codelens support (if supported by LSP)
    if client and client.server_capabilities.codeLensProvider then
      -- Refresh codelens on certain events
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = ev.buf,
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = ev.buf })
        end,
      })
      
      -- Run codelens action under cursor
      vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, { buffer = ev.buf, desc = "Run codelens" })
    end

    -- Java-specific debugging keybindings
    if vim.bo.filetype == 'java' then
      vim.keymap.set('n', '<leader>df', "<cmd>lua require('jdtls').test_class()<CR>", { buffer = ev.buf, desc = "Debug test class" })
      vim.keymap.set('n', '<leader>dn', "<cmd>lua require('jdtls').test_nearest_method()<CR>", { buffer = ev.buf, desc = "Debug nearest test method" })
    end
  end,
})

-- Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { silent = true, noremap = true, desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { silent = true, noremap = true, desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "gR", "<cmd>Trouble lsp_references toggle<cr>", { silent = true, noremap = true })

-- folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- automatically resize all vim buffers if I resize the terminal window
vim.api.nvim_create_autocmd("VimResized", { command = "wincmd =" })
vim.keymap.set("n", "<leader>ls", "<cmd>lua require(\"luasnip.loaders\").edit_snippet_files()<cr>",
{ silent = true, noremap = true })
-- vim.lsp.set_log_level("debug")

-- yanky.nvim
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

-- fzf-lua yanky history picker
vim.keymap.set("n", "<leader>fy", function()
  local yanky = require("yanky.history")
  local fzf = require("fzf-lua")

  local entries = {}
  for _, entry in ipairs(yanky.all()) do
    table.insert(entries, entry.regcontents)
  end

  fzf.fzf_exec(entries, {
    prompt = "Yank History> ",
    previewer = "builtin",
    actions = {
      ["default"] = function(selected)
        if selected and selected[1] then
          vim.api.nvim_put({ selected[1] }, "c", true, true)
        end
      end,
    },
  })
end, { desc = "Yank history picker" })

vim.lsp.config('yamlls', {
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
  filetypes = { 'kotlin' },
})
vim.lsp.enable('kotlin_language_server')

vim.lsp.config('jsonls', {
  filetypes = { 'json' },
})
vim.lsp.enable('jsonls')

vim.lsp.config('lua_ls', {
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
  capabilities = capabilities,
  filetypes = { "go", "gomod", "gowork", "gohtml", "gotmpl", "go.html", "go.tmpl" },
  root_markers = { 'go.mod' },
  settings = {
    gopls = {
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        shadow = true,
        nilness = true,
        unusedwrite = true,
        useany = true,
      },
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


-- start workaround
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.lsp.start({ name = 'gopls', cmd = {'gopls'} })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.json" },
  callback = function()
    if vim.fn.executable("jq") == 1 then
      local cursor = vim.api.nvim_win_get_cursor(0)
      vim.cmd(":%!jq .")
      pcall(vim.api.nvim_win_set_cursor, 0, cursor)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {  "*.java" },
  callback = function(ev)
    -- Disable inlay hints before formatting (Neovim 0.11.x bug workaround)
    pcall(vim.lsp.inlay_hint.enable, false, { bufnr = ev.buf })

    -- Format if LSP supports it
    local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/formatting" })
    if #clients > 0 then
      vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
    end

    -- Synchronous organizeImports to avoid race condition with save
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
    for _, res in pairs(result or {}) do
      for _, action in pairs(res.result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
        elseif action.command then
          vim.lsp.buf.execute_command(action.command)
        end
      end
    end
  end,
})
