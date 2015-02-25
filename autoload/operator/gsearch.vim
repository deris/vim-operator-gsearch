" operators {{{
for name in keys(g:gsearch_config)
  let config = g:gsearch_config[name]
  let command = config['command']
  let noquote = get(config, 'noquote', 0)

  execute printf("function! operator#gsearch#%s(motion_wise)\n", substitute(name, '-', '_', 'g')) .
    \     printf("  call s:search_cmd%s('%s', a:motion_wise)\n", noquote ? '' : '_quote', command) .
    \            "endfunction\n"
endfor
"}}}
" internal {{{
function! s:search_cmd_quote(cmd, motion_wise)
  execute a:cmd . ' ' . s:ag_quote(s:operator_sel(a:motion_wise))
endfunction

function! s:search_cmd(cmd, motion_wise)
  execute a:cmd . ' ' . fnameescape(s:operator_sel(a:motion_wise))
endfunction

function! s:operator_sel(motion_wise)
  let v = operator#user#visual_command_from_wise_name(a:motion_wise)
  let [save_reg_k, save_regtype_k] = [getreg('k'), getregtype('k')]
  try
    execute 'normal!' '`[' . v . '`]"ky'
    " return s:get_visual_selection()
    return getreg('k')
  finally
    call setreg('k', save_reg_k, save_regtype_k)
  endtry
endfunction

" Stolen from: http://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
" currently not used as we are pasting to a random register instead
function! s:get_visual_selection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction
"}}}

function! s:ag_quote(str)
  " This was old escaping mechanism
  " return shellescape(fnameescape(str))
  return escape(fnameescape(escape(a:str, '#%')), '()')
endfunction
