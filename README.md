### my nvim cheatsheet
#### File-tree mappings
| Command | Description |
| --- | --- |
|,n|NvimTreeToggle|

#### undotree
| Command | Description |
| --- | --- |
|,u|UndotreeToggle|

#### go.nvim
| Command | Description |
| --- | --- |
|,b|:GoBuild|
|,r|:GoRun|
|,gv|:GoAltV|
|,tt|:GoAlt|

#### telescope
| Command | Description |
| --- | --- |
|,gf|builtin.git_files|
|,ff|builtin.find_files|
|,ld|builtin.lsp_document_symbols|
|,td|builtin.diagnostics|
|,gs|builtin.grep_string|
|,lg|builtin.live_grep|
|,fb|builtin.buffers|
|,fh|builtin.command_history|
|,ls|:Telescope luasnip|

#### diagnostics
| Command | Description |
| --- | --- |
|,do|vim.diagnostic.open_float|
|,dp|vim.diagnostic.goto_prev|
|,dn|vim.diagnostic.goto_next|
|,ds|vim.diagnostic.setqflist|

#### LSP
| Command | Description |
| --- | --- |
|gd|definition|
|,v|vsplit definition|
|,s|belowright split definition|
|gr|references|
|gD|declaration|
|K|Hover - Documentation|
|gi|implementation|
|,cl|codelens.run|
|,rn|rename|
|,ca|code_action|

#### Trouble
| Command | Description |
| --- | --- |
|,xx|TroubleToggle|
|,xw|TroubleToggle workspace_diagnostics|
|,xd|TroubleToggle document_diagnostics|
|,xl|TroubleToggle loclist|
|,xq|TroubleToggle quickfix|
|gR|TroubleToggle lsp_references|

#### General
| Command | Description |
| --- | --- |
|gJ|Join the object under cursor|
|gS|Split the object under cursor|
|gcc|Toggles the current line using linewise comment|
|gbc|Toggles the current line using blockwise comment|

#### Copilot
| Command | Description |
| --- | --- |
|,ah|Help actions|
|,ap|Prompt actions|
|,ae|Explain code|
|,at|Generate tests|
|,ar|Review code|
|,aR|Refactor code|
|,an|Better Naming|
|,av|Open in vertical split - Toggle|
|,ax|Inline chat|
|,ai|Ask input|
|,am|Generate commit message for all changes|
|,aM|Generate commit message for staged changes|
|,aq|Quick chat|
|,al|Clear buffer and chat history|
