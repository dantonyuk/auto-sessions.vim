function! autosessions#SaveSession() abort
  let prev_session = s:SavePreviousSession()
  let session_path = s:GetSessionPath()
  if session_path isnot# prev_session 
    if s:IsStorable() == 1
      execute 'mksession! ' . s:GetSessionPath()
    endif
  endif
endfunction

function! autosessions#RestoreSession() abort
  let prev_session = s:SavePreviousSession()
  let session_path = s:GetSessionPath()
  if session_path isnot# prev_session 
    if filereadable(session_path)
      " Clean up first
      let v:this_session = ''
      bufdo update
      bufdo bwipeout!

      " Restore a session
      execute 'source ' . session_path
    else
      call autosessions#SaveSession()
    endif
  endif
endfunction

function! autosessions#DeleteSession() abort
  let session_path = s:GetSessionPath()
  if filereadable(session_path)
    call delete(session_path)
    let v:this_session = ''
  endif
endfunction

function! autosessions#SaveOrDeleteSession() abort
  if s:IsStorable() == 1
    call autosessions#SaveSession()
  else
    call autosessions#DeleteSession()
  endif
endfunction

function! s:SavePreviousSession() abort
  let current_session = get(v:, 'this_session', '')
  if type(current_session) == 1 && current_session isnot# ''
    if !s:IsStorable() == 1
      execute 'mksession! ' . current_session
    endif
  endif
  return current_session
endfunction

function! s:IsStorable() abort
  let project_dir = getcwd()
  let buffer_list = getbufinfo({'bufloaded': 1, 'buflisted': 1})

  for buffer in buffer_list
    if empty(buffer.name) || buffer.hidden
      continue
    endif
    if buffer.name[0 : len(project_dir) - 1] ==# project_dir
      return 1
    endif
  endfor

  return 0
endfunction

function! s:GetSessionPath() abort
  return s:GetSessionDirectory() . '/' . s:GetSessionFile()
endfunction

function! s:GetSessionDirectory() abort
  let dir = get(g:, 'auto_sessions_dir', '.vim-sessions')
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif

  return dir
endfunction

function! s:GetSessionFile() abort
  let head_file = '.git/HEAD'
  if filereadable(head_file)
    let branch = readfile(head_file)
    let extracted_branch = matchstr(branch[0], 'ref: refs/heads/\zs.\+\ze')
    if extracted_branch isnot# ''
      let branch = extracted_branch
    endif
    return 'Session-' . branch . '.vim'
  endif

  " Fallback
  return 'Session.vim'
endfunction
