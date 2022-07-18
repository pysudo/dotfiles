" ---------------------------- General ----------------------------------------
set nocompatible
syntax on
set number
set incsearch
set hlsearch
set wildmenu
"set wildmode=list:longest

set cursorcolumn
hi CursorColumn cterm=NONE ctermbg=239
set cursorline
hi CursorLine cterm=NONE ctermbg=235
set colorcolumn=80
hi ColorColumn ctermbg=lightgrey guibg=lightgrey
hi Conceal ctermbg=DarkBlue


hi Pmenu ctermfg=Black ctermbg=238
hi PmenuSel ctermfg=Grey ctermbg=Black
hi PmenuSbar ctermbg=Black
hi PmenuThumb ctermbg=DarkGrey

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smartcase

" **************************** Plug coc.nvim **********************************
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

"                             
" ---------------------------- Plugin Manager ---------------------------------
" Initialize plugin system
call plug#begin()

" Full language server protocol
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Debug Adapter Protocol client implementation for Neovim
Plug 'mfussenegger/nvim-dap'

" Mappings to easily delete, change and add \"surroundings\" in pairs.
Plug 'tpope/vim-surround'

call plug#end()


" ---------------------------- Mappings ---------------------------------------
" **************************** Plug coc.nvim **********************************
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Symbol renaming.
nmap <Leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <Leader>f  <Plug>(coc-format-selected)
nmap <Leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<Leader>aap` for current paragraph
xmap <Leader>a  <Plug>(coc-codeaction-selected)
nmap <Leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <Leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <Leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <Leader>cl  <Plug>(coc-codelens-action)

" **************************** Plug vim.dap ***********************************
nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>


" ---------------------------- Config -----------------------------------------
" **************************** Plug vim.dap ***********************************
lua <<EOF
  local dap = require('dap')
  dap.adapters.node = {
    type = 'executable',
    command = 'node',
    -- Install vscode-node-debug2 on the specified path.
    args = {os.getenv('HOME') .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
  }
  dap.configurations.javascript = {
    {
      name = 'Launch',
      type = 'node',
      request = 'launch',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
    {
      -- For this to work you need to make sure the node process is started with the `--inspect` flag.
      name = 'Attach to process',
      type = 'node',
      request = 'attach',
      processId = require'dap.utils'.pick_process,
    },
  }
EOF

