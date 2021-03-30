#!/bin/bash

declare DFTMP="$(mktemp -d)"

declare home="${HOME}"
declare bundles_dir="${home}/bundles"

if [[ ! -e "${bundles_dir}" ]]; then
	mkdir -p "${bundles_dir}"
fi

# Install dein
if [[ ! -e "${bundles_dir}/dein" ]]; then
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > "${DFTMP}/install_dein.sh"
    if [[ $? == 0 ]]; then
        sh "${DFTMP}/install_dein.sh" "${bundles_dir}/dein"
    else
        echo "Couldn't download dein installer.  Is there a proxy blocking it?  Proxy env is:"
        env | grep -i proxy
    fi
fi

# Install fzf
if [[ ! -e "${home}/.fzf" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "${home}/.fzf"
    yes | "${home}/.fzf/install"
fi

# Install the neovim configs
stow -d stow -t "${home}" neovim

# vim: ts=3 sw=3 sts=0 ff=unix noet :
