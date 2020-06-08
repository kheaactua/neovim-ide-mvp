# nvim-android-ide
Small example project showing neovim as an IDE with Android using the new LSP features of neovim.

## Pre-reqs
- [clangd](https://llvm.org/) - This is provided with AOSP, but you can also install it using apt or any other method.  *This is the language server*.
- [neovim 0.5](https://neovim.io/) - Pre-release of neovim 0.5.  There is a PPA for a nightly, or you can build it manually ([script I use](https://github.com/kheaactua/system-setup-scripts/blob/master/install_neovim.sh))
- vim package manager - There are many, this repo uses [dein](https://github.com/Shougo/dein.vim) to leverage whatever dark power is.

## Steps

### Generate a `compile_configs.json` file

Code completion depends on knowing how to build every target, this is described in a `compile_configs.json` file.  To create this, in your session run:
```bash
export SOONG_GEN_COMPDB 1
export SOONG_GEN_COMPDB_DEBUG 1

export SOONG_LINK_COMPDB_TO=$ANDROID_HOST_OUT

make nothing
```
([source](https://android.googlesource.com/platform/build/soong/+/HEAD/docs/compdb.md))

This will generate the file and symlink place it in the top of your source directory.

### Setup neovim

Running the include `setup.sh` should install dein and fzf and symlink your `.vimrc` to neovim's `init.vim`

## Notes

- This is based on my vimrc, so there is likely some extra stuff
- Run `setup.sh` off the VPN/proxy.  If you need to run it on the proxy you may have to tweak the script.
- The "_bundles_" path is in both `setup.sh` and `init.vim`, if you alter it, alter it in both places.
