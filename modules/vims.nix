{
  imports = [
    ./vim-michael-bishop.nix
    ./vim-michael-fellinger.nix
  ];
  environment = {
    shellAliases = {
      vim = "neovim";
      vi = "neovim";
    };
    variables.EDITOR = "neovim";
  };
  programs.bash.shellAliases = {
    vim = "neovim";
    vi = "neovim";
  };
  local.commonGivesVim = false;
}
