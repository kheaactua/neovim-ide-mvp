#!/bin/bash

declare -r DOTFILES_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
declare DFTMP="$(mktemp -d)"

if [[ "${WINHOME:-undefined}" == "undefined" ]]; then
	h="${HOME}"
else
	h="${WINHOME}"
fi

# Install dein
if [[ ! -e "${DOTFILES_DIR}/bundles/dein" ]]; then
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > "${DFTMP}/install_dein.sh"
    if [[ $? == 0 ]]; then
        sh "${DFTMP}/install_dein.sh" "${DOTFILES_DIR}/bundles/dein"
    else
        echo "Couldn't download dein installer.  Is there a proxy blocking it?  Proxy env is:"
        env | grep -i proxy
    fi
fi

# Make sure config directory exists
mkdir -p "${h}/.config"

# Setup nvim config (symlink entire directory)
ln -s "${DOTFILES_DIR}/config/nvim" "${h}/.config/"
ln -s "${DOTFILES_DIR}/vimrc" "${h}/.config/nvim/init.vim"

# Install fzf
if [[ ! -e "${h}/.fzf" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "${h}/.fzf"
    yes | "${h}/.fzf/install"
fi

# vim: ts=3 sw=3 sts=0 ff=unix noet :
