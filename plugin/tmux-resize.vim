" Extends titlestring, as used by tmux-navigate, to list all the neighbours of
" a window. See https://github.com/sunaku/tmux-navigate/

function! Resize_neighbours()
  return join(filter(
        \ ['h', 'j', 'k', 'l'], {idx, val -> winnr() !=# winnr(val)}),
        \ '')
endfunction

"e.g. neighbours:hj:
set titlestring+=\ neighbours:%{Resize_neighbours()}:
