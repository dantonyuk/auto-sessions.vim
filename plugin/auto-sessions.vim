if exists('g:loaded_auto_sessions')
  finish
endif
let g:loaded_auto_sessions = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

let g:auto_sessions_dir = get(g:, 'auto_sessions_dir', '.vim-sessions')

augroup AutoSession
  autocmd!
  autocmd VimEnter * ++nested call RestoreSession()
  autocmd VimLeavePre * ++nested call SaveSession()
augroup END

augroup StdIn
  autocmd!
  autocmd StdinReadPre * let g:autosession_pager_mode = 1
augroup END

function! SaveSession() abort
  if s:IsEnabled()
    call autosessions#SaveOrDeleteSession()
  endif
endfunction

function! RestoreSession() abort
  if s:IsEnabled()
    call autosessions#RestoreSession()
  endif
endfunction

function! s:IsEnabled() abort
  return len(v:argv) < 2 && get(g:, 'autosession_pager_mode', 0) is# 0
endfunction

command! SaveSession call autosessions#SaveSession()
command! RestoreSession call autosessions#RestoreSession()
command! DeleteSession call autosessions#DeleteSession()

let &cpoptions = s:cpo_save
unlet s:cpo_save
