if exists('g:loaded_operator_search')
  finish
endif

" default values for settings(it's for compatibility) {{{
let g:gsearch_ag_command     = get(g:, 'gsearch_ag_command',     'Ag! -Q')
let g:gsearch_ack_command    = get(g:, 'gsearch_ack_command',    'Ack! -Q')
let g:gsearch_ctrlsf_command = get(g:, 'gsearch_ctrlsf_command', 'CtrlSF -Q')
"}}}

" default values for settings {{{
let s:gsearch_default_config = {
  \ 'ag': {
  \   'command': g:gsearch_ag_command,
  \ },
  \ 'ag-word': {
  \   'command': g:gsearch_ag_command . ' -w',
  \ },
  \ 'ack': {
  \   'command': g:gsearch_ack_command,
  \ },
  \ 'ggrep': {
  \   'command': 'Ggrep',
  \ },
  \ 'ctrlsf': {
  \   'command': g:gsearch_ctrlsf_command,
  \ },
  \ 'helpgrep': {
  \   'command': 'helpgrep',
  \   'noquote': 1,
  \ },
  \ 'dash': {
  \   'command': 'dash',
  \   'noquote': 1,
  \ },
  \ }
"}}}

" merge user custom values and default values for settings
let g:gsearch_config = get(g:, 'gsearch_config', {})
call extend(g:gsearch_config, s:gsearch_default_config, 'keep')
"}}}

" define operators
for name in keys(g:gsearch_config)
  execute printf("call operator#user#define('%s', 'operator#gsearch#%s')",
    \ name, substitute(name, '-', '_', 'g'))
endfor
"}}}

let g:loaded_operator_search = 1
