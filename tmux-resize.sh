#!/usr/bin/env bash
set -euo pipefail

get_tmux_option() { tmux show-option -gqv "$@" | grep . ;}

navigate_script=$(tmux display-message -p "#{navigate_pane}")
if [[ ! -x ${navigate_script} ]]; then
  printf "tmux-navigate script is not available.\n" >&2;
  exit 1;
fi
# shellcheck source=../tmux-navigate/tmux-navigate.sh
source "${navigate_script}"

neighbour_pane_contains_vim() {
  local direction="${1}"
  # workaround for strange bash regex behaviour. https://stackoverflow.com/a/9793094
  # shellcheck disable=SC2116
  if [[ "$pane_title" =~ $(echo '.*neighbours:\w*:.*') ]]; then
    # shellcheck disable=SC2001 # A sed is fine here
    neighbours=$(echo "$pane_title" | sed 's/.*neighbours:\(l\):.*/\1/')
    case "$direction" in
      left)  [[ $neighbours == *h* ]] ;;
      down)  [[ $neighbours == *j* ]] ;;
      up)    [[ $neighbours == *k* ]] ;;
      right) [[ $neighbours == *l* ]] ;;
      * )
        printf "Unsupported direction: '%s'\n" "$direction" >&2; exit 1
    esac
  else
    # user hasn't setup vim plugin
    return 1
  fi
};
resize() {
  tmux_resizing_command=$1;
  vim_resizing_command=$2;
  vim_resizing_only_if=${3:-true};
  if pane_contains_vim && eval "$vim_resizing_only_if"; then
    in_terminal=0
    if pane_contains_neovim_terminal; then
      # TODO This currently does not detect being in a terminal
      in_terminal=1
      # escape terminal mode
      tmux send-keys C-\\ C-n;
    fi;
    in_insert_mode=0
    if [[ "$pane_title" == *"mode:i"* ]]; then
      in_insert_mode=1
      # enter insert-normal mode for one command
      # Doesn't seem keep up if holding down the resize key
      tmux send-keys 'C-o'
    fi
    if neighbour_pane_contains_vim "$direction"; then
      eval "$vim_resizing_command";
    else
      eval "$tmux_resizing_command";
    fi
    if [[ "${in_terminal}" -eq 1 ]] && [[ "${in_insert_mode}" -eq 1 ]]; then
      tmux send-keys i;
    fi;
  elif ! pane_is_zoomed; then
    eval "$tmux_resizing_command";
  fi;
};

main() {
  direction=${1:-}
  action=${2:-}
  if [ -z "${direction}" ]; then
    printf "Not enough arguments\n" >&2; exit 1
  fi
  if [ -z "${action}" ]; then
    # Capability mode
    # Tmux and Vim treat expanding left to mean shrinking the right edge(*). So
    # smooth this expected behaviour. (* unless in the rightmost pane, when the
    # left edge moves as expected)
    case "$direction" in
      down|right) action="expand" ;;
      up|left) 
        action="shrink"
        if [[ "$direction" == "left" ]]; then
          direction="right"
        else
          direction="down"
        fi
        ;;
      * )
        printf "Unsupported direction: '%s'\n" $direction >&2; exit 1
    esac
  fi
  case "$action" in
    expand )
      case "$direction" in
        down )
          resize 'tmux resize-pane -D'  'tmux send-keys C-w +' ;; 
        right )
          resize 'tmux resize-pane -R'  'tmux send-keys C-w \>' ;;
        * )
          printf "Unsupported direction for %sing: '%s'\n" $action $direction >&2; exit 1

          # TODO use `tmux -t{left-of}` for moving the left/top edge
          # TODO find workaround for the aboveleft in
          # `:aboveleft vertical resize +5` having no effect in vim
          # https://github.com/neovim/neovim/issues/8270
      esac
      ;;
    shrink ) 
      case "$direction" in
        down )
          resize 'tmux resize-pane -U'  'tmux send-keys C-w -' ;;
        right )
          resize 'tmux resize-pane -L'  'tmux send-keys C-w \<' ;;
        * )
          printf "Unsupported direction for %sing: '%s'\n" $action $direction >&2; exit 2
      esac
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
