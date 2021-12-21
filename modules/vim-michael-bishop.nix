{ pkgs, ... }:

let
  customizedVim = pkgs.vim_configurable.customize {
    name = "vim-mb";
    vimrcConfig = {
      customRC = ''
        syntax on
        set nu
        set foldmethod=syntax
        set listchars=tab:->,trail:·
        set list
        set ruler
        set backspace=indent,eol,start
        map <F7> :tabp<enter>
        map <F8> :tabn<enter>
        set expandtab
        set softtabstop=2
        set shiftwidth=2
        set autoindent
        set background=dark

        highlight ExtraWhitespace ctermbg=red guibg=red
        au ColorScheme * highlight ExtraWhitespace guibg=red
        au BufEnter * match ExtraWhitespace /\s\+$/
        au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
        au InsertLeave * match ExtraWhiteSpace /\s\+$/

        autocmd Filetype haskell set foldmethod=indent foldcolumn=2 softtabstop=2 shiftwidth=2

        let g:ycm_server_python_interpreter='${pkgs.python3.interpreter}'
      '';
      vam.pluginDictionaries = [
        {
          names = [
            "vim-nix"
            "Syntastic"
            "YouCompleteMe"
          ];
        }
      ];
    };
  };
in {
  environment.systemPackages = [
    customizedVim
  ];
}
