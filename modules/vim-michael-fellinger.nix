{ pkgs, ... }:

let
  customizedVim = pkgs.neovim.override {
    configure = {
      customRC = ''
        set vb
        set gcr=a:blinkon0              " turn off blinking in gvim
        set t_Co=256                    " 256 Colors
        set t_vb=                       " turn off visual bell
        set mouse=a                     " disable mouse
        set hidden                      " don't abadon buffers
        set diffopt+=iwhite             " ignore whitespace in diff-mode
        set autoread                    " update changed files
        set hlsearch history=10000 incsearch
        set backspace=indent,eol,start
        set expandtab autoindent tabstop=2 shiftwidth=2
        set foldmethod=indent foldlevel=1000
        set updatetime=500
        set ignorecase smartcase        " better searching
        set undolevels=10000            " many undos
        set noshelltemp
        set noerrorbells                " no bells and whistles
        set novisualbell                " no bells and whistles
        set shortmess=a
        set rtp+=/usr/share/vim/addons
        set shell=bash
        set gdefault
        set colorcolumn=120
        set showmatch
        set matchtime=5
        set laststatus=2 linebreak
        set wrap
        set showbreak=«
        set relativenumber
        set scrolloff=5
        set sidescrolloff=5
        set sidescroll=1
        let g:deoplete#enable_at_startup = 1
        nnoremap <C-p> :FuzzyOpen<CR>
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          denite-nvim
          deoplete-nvim
          editorconfig-vim
          gruvbox
          neoformat
          neomake
          neoterm
          vim-abolish
          vim-airline
          vim-airline-themes
          vim-eunuch
          vim-fugitive
          vim-gitgutter
          vim-grepper
          vim-multiple-cursors
          vim-polyglot
          vim-repeat
          vim-surround
          vim-test
          vim-unimpaired
        ];

        opt = [
          vim-javascript
          vim-nix
          vim-addon-nix
        ];
      };
    };
  };
in {
  environment.systemPackages = [
    customizedVim
  ];
}
