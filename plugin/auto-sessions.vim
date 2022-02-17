if exists('g:loaded_auto_sessions')
  finish
endif
let g:loaded_auto_sessions = 1

let s:cpo_save = &cpo
set cpo&vim

let g:auto_sessions_dir = get(g:, 'auto_sessions_dir', '.vim-sessions')

autocmd VimEnter * call autosessions#RestoreSession()
autocmd VimLeavePre * call autosessions#SaveSession()

command! SaveSession call autosessions#SaveSession()
command! RestoreSession call autosessions#RestoreSession()

let &cpo = s:cpo_save
unlet s:cpo_save
