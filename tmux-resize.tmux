#!/usr/bin/env bash
set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

resize_script="${CURRENT_DIR}/tmux-resize.sh"
source "${resize_script}"

no_bindings=$(get_tmux_option @resize-no-bindings) || no_bindings=0

set_normal_bindings() {
  tmux bind-key -n M-H  run-shell -b "${resize_script} left"
  tmux bind-key -n M-J  run-shell -b "${resize_script} down"
  tmux bind-key -n M-K  run-shell -b "${resize_script} up"
  tmux bind-key -n M-L  run-shell -b "${resize_script} right"
}

main() {
  if [[ "${no_bindings}" -ne 1 ]]; then
    set_normal_bindings
  fi
}
main
