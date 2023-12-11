## nvim
#### File-tree mappings
| Command | Description |
| --- | --- |
|\<leader\>n|NvimTreeToggle|

#### undotree
| Command | Description |
| --- | --- |
|\<leader\>u|UndotreeToggle|

#### go.nvim
| Command | Description |
| --- | --- |
|\<leader\>b|:GoBuild|
|\<leader\>r|:GoRun|
|\<leader\>gv|:GoAltV|
|\<leader\>tt|:GoAlt|

#### telescope
| Command | Description |
| --- | --- |
|\<leader\>gf|builtin.git_files|
|\<leader\>ff|builtin.find_files|
|\<leader\>ld|builtin.lsp_document_symbols|
|\<leader\>td|builtin.diagnostics|
|\<leader\>gs|builtin.grep_string|
|\<leader\>lg|builtin.live_grep|
|\<leader\>fb|builtin.buffers|
|\<leader\>fh|builtin.command_history|
|\<leader\>fe|:Telescope file_browser|

#### diagnostics
| Command | Description |
| --- | --- |
|\<leader\>do|vim.diagnostic.open_float|
|\<leader\>dp|vim.diagnostic.goto_prev|
|\<leader\>dn|vim.diagnostic.goto_next|
|\<leader\>ds|vim.diagnostic.setqflist|

#### LSP
| Command | Description |
| --- | --- |
|gd|definition|
|\<leader\>v|vsplit definition|
|\<leader\>s|belowright split definition|
|gr|references|
|gD|declaration|
|K|Hover - Documentation|
|gi|implementation|
|\<leader\>cl|codelens.run|
|\<leader\>rn|rename|
|\<leader\>ca|code_action|

#### Trouble
| Command | Description |
| --- | --- |
|\<leader\>xx|TroubleToggle|
|\<leader\>xw|TroubleToggle workspace_diagnostics|
|\<leader\>xd|TroubleToggle document_diagnostics|
|\<leader\>xl|TroubleToggle loclist|
|\<leader\>xq|TroubleToggle quickfix|
|gR|TroubleToggle lsp_references|


| Command | Description |
| --- | --- |
|gJ|Join the object under cursor|
|gS|Split the object under cursor|
|gcc|Toggles the current line using linewise comment|
|gbc|Toggles the current line using blockwise comment|
