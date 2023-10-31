#! /usr/bin/env nix-shell
#! nix-shell -i bash -p patchelf

# use: .scripts/fix_loader.sh ~/.local/share/nvim/mason/packages/lua-language-server/libexec/bin/lua-language-server

folder="$HOME/.local/share/nvim/mason/packages/rust-analyzer"

for binary in ${@}
do
  patchelf \
    --set-interpreter "$(cat ${NIX_CC}/nix-support/dynamic-linker)" \
    "${binary}"
done
