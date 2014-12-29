if !exists("g:gsearch_ag_command")
  let g:gsearch_ag_command = 'Ag! -Q'
endif

if !exists("g:gsearch_ack_command")
  let g:gsearch_ack_command = 'Ack! -Q'
endif

if !exists("g:gsearch_ctrlsf_command")
  let g:gsearch_ctrlsf_command = 'CtrlSF -Q'
endif

function! operator#gsearch#ggrep(motion_wise)
  call s:search_cmd('Ggrep', a:motion_wise)
endfunction

function! operator#gsearch#ag(motion_wise)
  call s:search_cmd(g:gsearch_ag_command, a:motion_wise)
endfunction

function! operator#gsearch#ack(motion_wise)
  call s:search_cmd(g:gsearch_ack_command, a:motion_wise)
endfunction

function! operator#gsearch#ctrlsf(motion_wise)
  call s:search_cmd(g:gsearch_ctrlsf_command, a:motion_wise)
endfunction

function! s:search_cmd(cmd, motion_wise)
  execute a:cmd . ' ' . shellescape(s:operator_sel(a:motion_wise))
endfunction

function! s:operator_sel(motion_wise)
  let v = operator#user#visual_command_from_wise_name(a:motion_wise)
  execute 'normal!' '`[' . v . '`]'
  return s:get_visual_selection()
endfunction

" Stolen from: http://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
function! s:get_visual_selection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction