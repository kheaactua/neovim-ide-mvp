# vimrc-buildroot-ide
Small example project showing vim as an IDE with buildroot.  This contains three linters/semantic code completers

- [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe) - Code complete engine.
 - Provides code completion with Ultisnips, can also jump and do symbol analysis
- [ccls](https://github.com/MaskRay/ccls) - Language server
  Great for identifying symbols, jumping around in code, refactoring, _etc_
- [ALE](https://github.com/dense-analysis/ale/) - Asynchronous Lint Engine
  In this project it is setup to use clang-tidy for code linting.  Specific checks aren't yet configured.

## Notes

- All of the plugins above seem to handle cross compiling poorly with regard to finding the std headers, to address this there are:
 - `.ccls` - adds the buildroot std search paths for ccls
 - `.ycm_extra_conf.py` - adds the buildroot std search paths for ccls
 - buildroot paths right in `vimrc`
- I might be able to remove `LanguageClient-neovim` and instead use ALE for ccls
- YCM has issues downloading sub sub git modules over the VPN (the sub sub module specifies an SSH remote rather than https)
