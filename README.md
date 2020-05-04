# tmux-resize

Built upon [tmux-navigate](https://github.com/sunaku/tmux-navigate).

Intelligently resize tmux panes and Vim splits using the same keys.
This also supports SSH tunnels where Vim is running on a remote host.

  | inside Vim? | is Zoomed? | Action taken by key binding  |
  | ----------- | ---------- | ---------------------------- |
  | No          | No         | Resize tmux pane             |
  | No          | Yes        | Nothing: ignore key binding  |
  | Yes         | No         | Seamlessly resize Vim / tmux |
  | Yes         | Yes        | Resize directional Vim split |


Depends on [tmux-navigate](https://github.com/ayyess/tmux-navigate).
Be sure to source tmux-navigate in tmux and vim *before* tmux-resize.

## Installation

1. Install the [TPM] framework for tmux.

[TPM]: https://github.com/tmux-plugins/tpm

2. Add this line to your `~/.tmux.conf`:
```sh
set -g @plugin 'ayyess/tmux-resize'
```

3. Configure your own resizing shortcuts:
```sh
set -g @resize-no-bindings 1
bind-key -n M-H  run-shell -b "#{resize_pane} left"
bind-key -n M-J  run-shell -b "#{resize_pane} down"
bind-key -n M-K  run-shell -b "#{resize_pane} up"
bind-key -n M-L  run-shell -b "#{resize_pane} right"
```

3.5 Left/upper edge control

The first half of the mappings are identical to the mappings above but with the
controlled edge explicitly specified.

```sh
set -g @resize-no-bindings
# move right/bottom edge of current pane
bind-key -n M-H    run-shell -b "#{resize_pane} right shrink"
bind-key -n M-J    run-shell -b "#{resize_pane} down  expand"
bind-key -n M-K    run-shell -b "#{resize_pane} down  shrink"
bind-key -n M-L    run-shell -b "#{resize_pane} right expand"
# move left/top edge of current pane
bind-key -n C-M-h  run-shell -b "#{resize_pane} left  expand"
bind-key -n C-M-j  run-shell -b "#{resize_pane} up    shrink"
bind-key -n C-M-k  run-shell -b "#{resize_pane} up    expand"
bind-key -n C-M-l  run-shell -b "#{resize_pane} left  shrink"
```

### Vim integration - when using Vim remotely via SSH

```vim
Plug 'ayyess/tmux-resize'
```

## Alternatives

See [Vim-tmux-resizer](https://github.com/melonmanchan/vim-tmux-resizer) and [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) for a vim-centric approach to navigation and resizing.

## License

(the ISC license)

Copyright 2018 Suraj N. Kurapati <https://github.com/sunaku>  
Copyright 2020 Andrew Scott <https://github.com/ayyess>  

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
