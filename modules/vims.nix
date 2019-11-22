{
  imports = [
    ./vim-michael-bishop.nix
    ./vim-michael-fellinger.nix
  ];
  environment = {
    shellAliases = {
      vim = "vim-mb";
      vi = "vim-mb";
    };
    variables.EDITOR = "vim-mb";
  };
  programs.bash.shellAliases = {
    vim = "vim-mb";
    vi = "vim-mb";
  };
  local.commonGivesVim = false;
}
