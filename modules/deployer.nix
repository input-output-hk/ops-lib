{ pkgs, lib, name, config, ... }:
let
  inherit (pkgs.iohk-ops-lib.ssh-keys) allKeysFrom devOps;
  devOpsKeys = allKeysFrom devOps;
in {

  imports = [ ./common.nix ];

  environment.systemPackages = with pkgs; [
    (ruby.withPackages (ps: with ps; [ sequel pry sqlite3 nokogiri ]))
    screen
    sqlite-interactive
    tmux
    gnupg
    pinentry
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.screen.screenrc = ''
    defscrollback 10000
    #caption always
    maptimeout 5
    escape ^aa  # default
    autodetach            on              # default: on
    crlf                  off             # default: off
    hardcopy_append       on              # default: off
    startup_message       off             # default: on
    vbell                 off             # default: ???
    defmonitor            on
    defscrollback         1000            # default: 100
    silencewait           15              # default: 30
    shelltitle "Shell"
    hardstatus alwayslastline "%{b}[ %{B}%H %{b}][ %{w}%?%-Lw%?%{b}(%{W}%n*%f %t%?(%u)%?%{b})%{w}%?%+Lw%?%?%= %{b}][%{B} %Y-%m-%d %{W}%c %{b}]"
    sorendition   gk  #red    on white
    bell                  "%C -> %n%f %t Bell!~"
    pow_detach_msg        "BYE"
    vbell_msg             " *beep* "
    bind .
    bind ^\
    bind \\
    bind e mapdefault
    msgwait 2
  '';
}
