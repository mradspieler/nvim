# Neovim Commands Reference

Complete list of all commands, keybindings, and features configured in init.lua.

**Leader key: `,` (comma)**

---

## General Keybindings

### File Operations
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,w` | Normal/Insert | `:write!` | Save file |
| `,q` | Normal/Insert | `:q!` | Quit |
| `jj` | Insert | `<ESC>` | Exit insert mode |

### Navigation
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `<C-j>` | Normal | `<C-W>j` | Move to split below |
| `<C-k>` | Normal | `<C-W>k` | Move to split above |
| `<C-h>` | Normal | `<C-W>h` | Move to split left |
| `<C-l>` | Normal | `<C-W>l` | Move to split right |
| `<Up>` | Normal | `gk` | Move up (visual line) |
| `<Down>` | Normal | `gj` | Move down (visual line) |

### Search
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `*` | Normal | Custom | Search word under cursor (stay in place) |
| `n` | Normal | `nzzzv` | Next search result (centered) |
| `N` | Normal | `Nzzzv` | Previous search result (centered) |

### Editing
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `Y` | Normal | `y$` | Yank to end of line |
| `J` | Visual | Move selected lines down | |
| `K` | Visual | Move selected lines up | |
| `J` | Normal | `mzJ`z` | Join lines (preserve cursor) |
| `p` | Visual | `"_dP` | Paste without replacing clipboard |
| `,rw` | Normal | `:%s/\<<C-r><C-w>\>/...` | Rename word under cursor |
| `<C-c>` | Insert | `<ESC>` | Exit insert mode (ctrl-v safe) |
| `gx` | Normal | `jobstart(["open", ...])` | Open URL under cursor in browser |

### Quickfix List
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `<A-j>` | Normal | `:cnext` | Next quickfix item |
| `<A-k>` | Normal | `:cprev` | Previous quickfix item |
| `<A-J>` | Normal | `:clast` | Last quickfix item |
| `<A-K>` | Normal | `:cfirst` | First quickfix item |
| `,a` | Normal | `:cclose` | Close quickfix window |

---

## Plugin Commands

### File Explorer (nvim-tree)
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,n` | Normal | `:NvimTreeToggle` | Toggle file explorer |
| `,f` | Normal | `:NvimTreeFindFile!` | Find current file in tree |

### Fuzzy Finder (fzf-lua)

#### File Navigation
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,gf` | Normal | `:FzfLua git_files` | Find Git tracked files |
| `,ff` | Normal | `:FzfLua files` | Find all files |
| `,fb` | Normal | `:FzfLua buffers` | Find open buffers |

#### Search
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,gs` | Normal | `:FzfLua grep_project` | Grep in project |
| `,lg` | Normal | `:FzfLua live_grep` | Live grep (interactive) |
| `,td` | Normal | `:FzfLua diagnostics_workspace` | Show all diagnostics |

#### History
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,fh` | Normal | `:FzfLua command_history` | Show command history |
| `,fy` | Normal | Custom yanky picker | Yank history picker |

### Git (LazyGit, vim-fugitive, gitsigns)
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,gi` | Normal | `:LazyGit` | Open LazyGit UI |
| `,gp` | Normal | `:Gdiff` | Git diff current file |
| `,gb` | Normal | `:G blame` | Git blame |
| `,BB` | Normal | `:Gitsigns toggle_current_line_blame` | Toggle inline git blame (virtual text) |

#### Gitsigns - Hunk Navigation & Actions
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `]c` | Normal | `next_hunk` | Go to next git hunk |
| `[c` | Normal | `prev_hunk` | Go to previous git hunk |
| `,hs` | Normal/Visual | `stage_hunk` | Stage current hunk |
| `,hr` | Normal/Visual | `reset_hunk` | Reset current hunk |
| `,hS` | Normal | `stage_buffer` | Stage entire buffer |
| `,hR` | Normal | `reset_buffer` | Reset entire buffer |
| `,hu` | Normal | `undo_stage_hunk` | Undo stage hunk |
| `,hp` | Normal | `preview_hunk` | Preview hunk in floating window |
| `,hb` | Normal | `blame_line` | Show full blame for current line |
| `,hd` | Normal | `diffthis` | Diff against index |
| `,hD` | Normal | `diffthis('~')` | Diff against last commit |
| `,td` | Normal | `toggle_deleted` | Toggle deleted lines display |
| `ih` | Operator/Visual | `select_hunk` | Select hunk text object |

### Undo History (undotree)
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,u` | Normal | `:UndotreeToggle` | Toggle undo tree |

### Formatting
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,jq` | Normal | `:%!jq .` | Format JSON with jq |
| `,sq` | Normal | `:%!pg_format --spaces 2 --function-case 2` | Format SQL |

### Terminal
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,tv` | Normal | `:vnew term://zsh` | Open terminal (vertical split) |
| `,ts` | Normal | `:split term://zsh` | Open terminal (horizontal split) |
| `,q` | Terminal | Exit terminal | Close terminal |
| `<ESC>` | Terminal | `<C-\><C-n>` | Exit terminal insert mode |
| `<C-h/j/k/l>` | Terminal | Move to adjacent split | Navigate from terminal |

---

## LSP Commands

### Navigation
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `gd` | Normal | `lsp_definitions` | Go to definition (fzf picker) |
| `gr` | Normal | `lsp_references` | Find references (fzf picker) |
| `gR` | Normal | `TroubleToggle lsp_references` | References in Trouble |
| `gi` | Normal | `lsp.buf.implementation` | Go to implementation |
| `K` | Normal | `lsp.buf.hover` | Show hover documentation |
| `,v` | Normal | `vsplit + definition` | Open definition in vertical split |
| `,s` | Normal | `split + definition` | Open definition in horizontal split |

### Symbols & Structure
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,ld` | Normal | `lsp_document_symbols` | List document symbols (current file) |
| `,lw` | Normal | `lsp_live_workspace_symbols` | Live workspace symbol search |

### Code Actions & Refactoring
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,ca` | Normal/Visual | `lsp_code_actions` | Show code actions |
| `,rn` | Normal | `lsp.buf.rename` | Rename symbol |

### Diagnostics
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,do` | Normal | `vim.diagnostic.open_float` | Show diagnostic in floating window |
| `,dp` | Normal | `vim.diagnostic.goto_prev` | Previous diagnostic |
| `,dn` | Normal | `vim.diagnostic.goto_next` | Next diagnostic |
| `,ds` | Normal | `vim.diagnostic.setqflist` | Send diagnostics to quickfix |

---

## Language-Specific Commands

### Go (go.nvim)

#### Build & Run
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,b` | Normal | `:GoBuild` | Build Go project |
| `,r` | Normal | `:GoRun -F` | Run Go program |
| `,t` | Normal | `:GoTest -n` | Run tests (nearest) |
| `,gv` | Normal | `:GoAltV!` | Toggle to test file (vertical split) |
| `,tt` | Normal | `:GoAlt!` | Toggle between implementation/test |
| `,gc` | Normal | `:GoCoverage` | Show Go test coverage |
| `,gC` | Normal | `:GoCoverageClear` | Clear coverage display |

#### Available Ex Commands
- `:GoBuild` - Build project
- `:GoRun` - Run program
- `:GoTest` - Run tests in current file
- `:GoTestFunc` - Run single test under cursor
- `:GoTestFile` - Run all tests in file
- `:GoTestPkg` - Run all tests in package
- `:GoAlt` - Toggle between implementation and test file
- `:GoAltV` - Toggle (vertical split)
- `:GoCoverage` - Show test coverage
- `:GoCoverageClear` - Clear coverage

**Auto-format**: Go files auto-format on save with `goimport`

### Java (nvim-jdtls)

#### Build & Test
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,jb` | Normal | Maven build | Run `mvn clean compile` in terminal |
| `,jt` | Normal | Maven test | Run `mvn test` in terminal |
| `,jc` | Normal | JDTLS compile | Full compile via JDTLS |

#### Debugging (Java-specific)
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,df` | Normal | `jdtls.test_class()` | Debug entire test class |
| `,dn` | Normal | `jdtls.test_nearest_method()` | Debug nearest test method |

#### Available Ex Commands
- `:JdtCompile` - Compile via JDTLS
- `:JdtShowLogs` - Show JDTLS logs
- And other nvim-jdtls commands (added by `jdtls.setup.add_commands()`)

**Auto-organize imports**: Java files auto-organize imports on save

---

## Debugging (nvim-dap)

### Breakpoints
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `<Space>b` | Normal | `dap.toggle_breakpoint` | Toggle breakpoint |
| `<Space>gb` | Normal | `dap.run_to_cursor` | Run to cursor |
| `<Space>?` | Normal | `dapui.eval()` | Evaluate expression under cursor |

### Debug Controls
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `<F1>` | Normal | `dap.continue` | Continue/Start debugging |
| `<F2>` | Normal | `dap.step_into` | Step into |
| `<F3>` | Normal | `dap.step_over` | Step over |
| `<F4>` | Normal | `dap.step_out` | Step out |
| `<F5>` | Normal | `dap.step_back` | Step back |
| `<F13>` | Normal | `dap.restart` | Restart debugging |

**Note**: DAP UI opens automatically on debug start and closes on exit.

---

## Diagnostics & Trouble

### Trouble.nvim
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `,xx` | Normal | `:TroubleToggle` | Toggle Trouble |
| `,xw` | Normal | `:TroubleToggle workspace_diagnostics` | Workspace diagnostics |
| `,xd` | Normal | `:TroubleToggle document_diagnostics` | Document diagnostics |
| `,xl` | Normal | `:TroubleToggle loclist` | Location list |
| `,xq` | Normal | `:TroubleToggle quickfix` | Quickfix list |
| `gR` | Normal | `:TroubleToggle lsp_references` | LSP references |

---

## Text Objects (Treesitter)

### Selection
| Key | Mode | Description |
|-----|------|-------------|
| `<Space>` | Normal | Init/increment treesitter selection |
| `<Tab>` | Visual | Increment to upper scope |
| `<BS>` | Visual | Decrement to previous node |

### Text Objects
| Key | Mode | Description |
|-----|------|-------------|
| `aa` | Visual/Operator | Parameter (outer) |
| `ia` | Visual/Operator | Parameter (inner) |
| `af` | Visual/Operator | Function (outer) |
| `if` | Visual/Operator | Function (inner) |
| `ac` | Visual/Operator | Class (outer) |
| `ic` | Visual/Operator | Class (inner) |
| `aB` | Visual/Operator | Block (outer) |
| `iB` | Visual/Operator | Block (inner) |

### Navigation
| Key | Mode | Description |
|-----|------|-------------|
| `]]` | Normal | Next function start |
| `][` | Normal | Next function end |
| `[[` | Normal | Previous function start |
| `[]` | Normal | Previous function end |

### Parameter Swapping
| Key | Mode | Description |
|-----|------|-------------|
| `,sn` | Normal | Swap with next parameter |
| `,sp` | Normal | Swap with previous parameter |

---

## Code Manipulation

### Split/Join (splitjoin.nvim)
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `gJ` | Normal | Join object under cursor | Join multiline to single line |
| `gS` | Normal | Split object under cursor | Split single line to multiline |

### Commenting (Comment.nvim)
Default Comment.nvim keybindings are available (block commenting disabled):
- `gcc` - Toggle line comment
- `gc` + motion - Comment motion
- `gc` in visual mode - Comment selection

---

## Clipboard & Yanking

### Yanky.nvim (Enhanced Yank/Paste)
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `p` | Normal/Visual | Yanky put after | Paste after cursor (yanky-enhanced) |
| `P` | Normal/Visual | Yanky put before | Paste before cursor (yanky-enhanced) |
| `gp` | Normal/Visual | Yanky gPut after | Paste after and move cursor |
| `gP` | Normal/Visual | Yanky gPut before | Paste before and move cursor |
| `<C-p>` | Normal | Previous yank | Cycle to previous yank in history |
| `<C-n>` | Normal | Next yank | Cycle to next yank in history |
| `,fy` | Normal | Yank history picker | Open fzf picker for yank history |

### Cutlass.nvim (Cut Operations)
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `m` | Normal | Cut (delete to register) | Use `m` for cutting (instead of `d`) |

**Note**: Standard `d` deletes without affecting yank register.

---

## AI Completion (GitHub Copilot)

### Copilot.vim
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `<C-J>` | Insert | Accept suggestion | Accept Copilot suggestion |
| `<C-L>` | Insert | Accept word | Accept next word from suggestion |

**Enterprise endpoint**: `https://bmw.ghe.com`

---

## Autocompletion (nvim-cmp)

### Completion Menu
| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `<C-n>` | Insert | Next item | Select next completion item |
| `<C-p>` | Insert | Previous item | Select previous completion item |
| `<CR>` | Insert | Confirm | Confirm completion |
| `<Tab>` | Insert | Next/expand snippet | Next item or expand snippet |
| `<S-Tab>` | Insert | Previous | Previous item or jump back in snippet |

---

## Mason (LSP/Tool Management)

### Ex Commands
- `:Mason` - Open Mason UI
- `:MasonUpdate` - Update Mason packages
- `:MasonInstall <package>` - Install package
- `:MasonUninstall <package>` - Uninstall package

### Installed LSP Servers
- `gopls` - Go
- `jdtls` - Java
- `lua_ls` - Lua
- `jsonls` - JSON
- `yamlls` - YAML
- `kotlin_language_server` - Kotlin

### Debug Adapters
- `java-debug-adapter` - Java debugging
- `java-test` - Java test debugging
- Go debugger (via nvim-dap-go)

---

## Other Features

### Database (vim-dadbod-ui)
Commands available after loading:
- `:DBUI` - Open database UI
- `:DBUIToggle` - Toggle database UI

### Markdown Rendering
- `render-markdown.nvim` automatically renders markdown files

### Last Cursor Position
- `nvim-lastplace` automatically restores cursor position when opening files

### Smooth Scrolling
- `cinnamon.nvim` provides smooth scrolling animations

---

## Ex Commands Summary

### Native Vim/Neovim
- `:write` / `:w` - Save file
- `:quit` / `:q` - Quit
- `:help <topic>` - Get help
- `:LspInfo` - Show LSP server status
- `:LspRestart` - Restart LSP servers

### Plugin-Provided
See respective plugin sections above for:
- Go commands (`:GoBuild`, `:GoTest`, etc.)
- Java/JDTLS commands (`:JdtCompile`, etc.)
- Mason commands (`:Mason`, `:MasonUpdate`)
- Trouble commands (`:TroubleToggle`)
- File tree commands (`:NvimTreeToggle`)
- Fzf commands (`:FzfLua <action>`)
- Database commands (`:DBUI`)
- Git commands (`:LazyGit`, `:G <git-command>`)

---

## Notes

### Diagnostics Configuration
- **Virtual text**: Disabled (no inline diagnostic text)
- **Signs**: Enabled (icons in gutter)
- **Underlines**: Enabled
- **Float window**: Available via `,do`

### Auto-formatting
- **Go**: Auto-formats with `goimport` on save
- **Java**: Auto-organizes imports on save
- **JSON**: Manual with `,jq`
- **SQL**: Manual with `,sq`

### Indentation Rules
- **Default**: 2 spaces
- **Go**: Tabs (width 4)
- **Java**: 2 spaces

### Terminal Behavior
- Auto-enters insert mode for zsh, Maven, and Gradle terminals
- Does not auto-enter for vim-test terminals

### Folding
- Method: Treesitter expression-based
- Folds disabled by default (can be enabled manually)

---

## Quick Reference Card

### Most Common Operations

**Files**: `,w` save | `,q` quit | `,ff` find files | `,fb` buffers  
**Navigation**: `gd` definition | `gr` references | `K` hover | `,n` file tree  
**Search**: `,gs` grep | `,lg` live grep | `*` search word  
**Git**: `,gi` lazygit | `,gb` blame | `,gp` diff | `,BB` inline blame  
**Go**: `,b` build | `,r` run | `,t` test | `,tt` toggle test  
**Java**: `,jb` maven build | `,jt` maven test | `,jc` jdtls compile  
**Debug**: `<Space>b` breakpoint | `<F1>` continue | `<F2>` step into | `<F3>` step over  
**LSP**: `,ca` code actions | `,rn` rename | `,do` show diagnostic  
**Trouble**: `,xx` toggle | `,xw` workspace diagnostics | `,xd` document diagnostics  
**Split nav**: `<C-h/j/k/l>` move between splits  
**Terminal**: `,tv` vertical | `,ts` horizontal | `<ESC>` exit insert  

---

*Generated from init.lua - Last updated: 2026-02-11*
