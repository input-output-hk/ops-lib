{ config, options, pkgs, lib, name, ... }:

with lib;

let
  cfg = config.services.oauth2_proxy;
in {
  options = {
    services.oauth2_proxy.nginx.config = mkOption {
      type = types.str;
      default = optionalString cfg.enable ''
        auth_request /oauth2/auth;
        error_page 401 = /oauth2/sign_in;

        # pass information via X-User and X-Email headers to backend,
        # requires running with --set-xauthrequest flag
        auth_request_set $user   $upstream_http_x_auth_request_user;
        auth_request_set $email  $upstream_http_x_auth_request_email;
        proxy_set_header X-User  $user;
        proxy_set_header X-Email $email;

        # if you enabled --cookie-refresh, this is needed for it to work with auth_request
        auth_request_set $auth_cookie $upstream_http_set_cookie;
        add_header Set-Cookie $auth_cookie;
      '';
    };
  };

  config = {
    services = {
      oauth2_proxy = let staticConf = pkgs.globals.static.oauth or {}; in {
        setXauthrequest = mkDefault true;
      } // staticConf
      // (mapAttrsRecursive (_: mkDefault) (removeAttrs staticConf ["alphaConfig"]));
    };
  };
}
