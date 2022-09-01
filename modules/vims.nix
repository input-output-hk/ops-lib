{
  imports = [
    ./vim-michael-bishop.nix
    ./vim-michael-fellinger.nix
  ];
  environment = {
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
    };
    variables.EDITOR = "nvim";
  };
  programs.bash.shellAliases = {
    vim = "nvim";
    vi = "nvim";
  };
  local.commonGivesVim = false;
}
