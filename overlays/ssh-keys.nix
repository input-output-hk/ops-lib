# -*- mode: nix; truncate-lines: t -*-

# If you need access, add your key here and make a pull request
# against the master branch.
# Keys are sorted alphabetically.

lib: {
  # DevOps keys:
  #
  devOps = {
    dermetfan      = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCu2OiuMR/T7lMWjlsBkF0yFKv0puqFctuHXmfMLaZeUU7ACkGwKnhY55pnEaWiSDiqjf1VsB7WvkW9Js/nF+cP2hVtwiHoVDJQeCv0v+b1vPNfhxTaEAk9+U82G3C5tD8Rzi7H2NNEv7MlEeqfdP5a4UKOMW+XTJT5XolwQvIFuYKz4sLl28uDBmHtz+WqQeHgthkldWrEAvVoGDq0qzfBhhAlC0xsghYGAWYAlIOtj0MrJoBWtQoqqEkO9+hXUAwUixMy8JUmSStzEblgXr8OMKaPiKKX7tyYencZp6PG8gva8HUd3drI6Kb+5NXBq5N2PAnWI12osuwXuntiUNQF" ];
    jlotoski       = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCogRPMTKyOIQcbS/DqbYijPrreltBHf5ctqFOVAlehvpj8enEE51VSjj4Xs/JEsPWpOJL7Ldp6lDNgFzyuL2AOUWE7wlHx2HrfeCOVkPEzC3uL4OjRTCdsNoleM3Ny2/Qxb0eX2SPoSsEGvpwvTMfUapEa1Ak7Gf39voTYOucoM/lIB/P7MKYkEYiaYaZBcTwjxZa3E+v7At4umSZzv8x24NV60fAyyYmt5hVZRYgoMW+nTU4J/Oq9JGgY7o+WPsOWcgFoSretRnGDwjM1IAUFVpI45rQH2HTKNJ6Bp6ncKwtVaP2dvPdBFe3x2LLEhmh1jDwmbtSXfoVZxbONtub2i/D8DuDhLUNBx/ROgal7N2RgYPcPuNdzfp8hMPjPGZVcSmszC/J1Gz5LqLfWbKKKti4NiSX+euy+aYlgW8zQlUS7aGxzRC/JSgk2KJynFEKJjhj7L9KzsE8ysIgggxYdk18ozDxz2FMPMV5PD1+8x4anWyfda6WR8CXfHlshTwhe+BkgSbsYNe6wZRDGqL2no/PY+GTYRNLgzN721Nv99htIccJoOxeTcs329CppqRNFeDeJkGOnJGc41ze+eVNUkYxOP0O+pNwT7zNDKwRwBnT44F0nNwRByzj2z8i6/deNPmu2sd9IZie8KCygqFiqZ8LjlWTD6JAXPKtTo5GHNQ== john.lotoski@iohk.io" ];
    jmgilman       = [ "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMo1U8c0SeSoe/vyRW7T6ogh9WjLJZFmcuHuASi9XMDFAAAABHNzaDo= josh@nixos" ];
    manveru        = [
     "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIG5Fs02XVS6HlI1H24xpDiCNEHZ/MeVdhIE2iWe5kqK3AAAABHNzaDo= michael.fellinger@iohk.io"
     "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJqRQMd6Ptlvv0msPoC97VNmrj2qjRrL2cnMEjZh2W8HAAAABHNzaDo= michael.fellinger@iohk.io"
    ];
    michalrus      = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCgQ3APfC88S6tKF/OirAci5xtATT1I6zAlBLJqD0v34LJfMjpZVPL3ocnLb1wYJep8xdMC0fkfvzyZG9bqpuIJT7fsHb6MyvZot4z6SL27tncxOAvVOj3Yfp473nAKEnnKcF8D9K0Tuyzz8g1pVFXZ9SRDHB9Kk5azmaGMwe6LFadiAcHc/z7dLF3Lkc3sIdWI8K1xhHTNjXoQ9l0xbrYh8tWEu7R6T5HclVRW17CiEBAe5RhHix36lOQ423roCYM5cniSb4jQaT2e8UXI9BXtZSaEVk39g6ulo+24XMwdm1CEl7UwgqyhTGm4HFFOl891dsqeodUyM3OuZKH+a8Gs0gsarUjLcbGNGVOYunzNxHzXiUtvm4VY+axsjOrCA0kPOBQwznNXYcJz6l/pLjeSeiSflT4eJZBJflz+MOgwYXaGK9HTUGup7Fsg+88oKevkB3x3x2y+8DWHAIDWSbtvts5b6yMjAhtUtg4O9GDrWgS7xcZulmk/TJo+IrgzQLKDqeSJUHnSkC3ocsbIK+Zev9XFutoXs6XJe3M3kzCIG6HGIYd3fAZcICuqvOx6bN2yBQJI2plWYj2TRq/zbK79LIduQx92geSo/DhchrIuVXdB56PDraMUOBJ82SRrm8M8o9M2yGNz2EXb7yLQkPbhFDpGL8GDrCS41Jv2H1K8Ww== michal.rus@iohk.io" ]; # for Deadalus signing/notarization
    sam            = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEPOLnk4+mWNGOXd309PPxal8wgMzKXHnn7Jbu/SpSUYEc1EmjgnrVBcR0eDxgDmGD9zJ69wEH/zLQLPWjaTusiuF+bqAM/x7z7wwy1nZ48SYJw3Q+Xsgzeb0nvmNsPzb0mfnpI6av8MTHNt+xOqDnpC5B82h/voQ4m5DGMQz60ok2hMeh+sy4VIvX5zOVTOFPQqFR6BGDwtALiP5PwMfyScYXlebWHhDRdX9B0j9t+cqiy5utBUsl4cIUInE0KW7Z8Kf6gIsmQnfSZadqI857kdozU3IbaLoJc1C6LyVjzPFyC4+KUC11BmemTGdCjwcoqEZ0k5XtJaKFXacYYXi1l5MS7VdfHldFDZmMEMvfJG/PwvXN4prfOIjpy1521MJHGBNXRktvWhlNBgI1NUQlx7rGmPZmtrYdeclVnnY9Y4HIpkhm0iEt/XUZTMQpXhedd1BozpMp0h135an4uorIEUQnotkaGDwZIV3mSL8x4n6V02Qe2CYvqf4DcCSBv7D91N3JplJJKt7vV4ltwrseDPxDtCxXrQfSIQd0VGmwu1D9FzzDOuk/MGCiCMFCKIKngxZLzajjgfc9+rGLZ94iDz90jfk6GF4hgF78oFNfPEwoGl0soyZM7960QdBcHgB5QF9+9Yd6QhCb/6+ENM9sz6VLdAY7f/9hj/3Aq0Lm4Q== samuel.leathers@iohk.io"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNyDMvuNLynMo0U257GWlU94eS021mtydfiVXofRzsR nix-on-droid@localhost"
    ];
  };

  # Cardano SL developer keys:
  #
  csl-developers = {
    alexesgen      = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4UVZ3UtjIHVpBcUTMDxygo0VTsc0po5ehp5lrlvoNmkHjYw7JB1Zb7jPKSI8a+1J+WFMRLuHClir+w0ADZ2wB8wu+ECuBPxk8XJHbFw8BnVt+Omgbdj7Dvhbuti7DLJuov34VpEdaJ/znJEpgFDnByaI1cr2mxzxwPvOES6B7sL5NWtzrtNdzx5pxWDLXCjhIF6+2wI6QsAymHNSonxU//8Gq50C+CAcyku89kLCzOaAiidj6MIEOeDv9RPdaidQvG8f2kx0UT4gBfwaEmBiTDRXVpW1mqeyPS1TQBJpt42/e6S5YxlbDn/0PRc24A7eAkYuZslXrOqm/wN/Jxa6vIlYoEw5PRpIFRMmxSxnHLCstRaqm5NNJtKPj3VnlR1ls49z2onR69stJF0iVKlGc6M+RPizNgSMCwkYjWyyhtg9vOw+45yn3EYa+OirfDgn8zP4+Q+YdC7SzVvGWKdgom9LTGFJPC9wkSSWB28SCdEVhvIHcvNwek487xrW7akH/GfMrOS2px5MNSMA+vXyjqMQ4VlVpgQt2OyOlBLwzOyenrFLKd7W3FyKYjCwzMRocOwaog8VsgFD9fsOND00vVWIhIZUC8bJnH6O2t3GAF1Hx8yB/GkwMErGpjmZDYKGrZNyzuDkCgGReY2pRpo9I+N1TTuST8vJ+97+eLuzIPQ==" ];

    angerman       = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7HhR8q5Hx8pMokhgF3MJFVwGPnQHebxJbTJ0IccbNQD/kuXPfWNPaocF3NQAgcJ4c/SIcHHS+iXH0SP2vhXY8SvqgrA8aiwCMEfC1Bcj0EUJxwJ/z2XohmECXqQFMp7e7Y9gbSdiltJPvhxB8VX/TeGWum/bBIMvVOIUX6qOywzxFEUA0y0zRiFUdMj1g4takEwFi4OyMqU8tPJw+s8VnWmMt/Tgeden5gO8rWEGKeWeozTYMX4zZw/fA6Au4R5QvcLsEgG12gR5nNnCHOB11OkiiweoLRY3cZx5JDk/eipn8jWMGPxzHBsy/vJR7PiJ591f2U1dbsMXbnNeTDlInChKgDsbrgAsvccmHC8TMucvdhjxnowwNS7Ay696fD2Q7Spel36kE+nWGNuygtLY6+RnY1LdrCkdyAZvU7D/WW7KLXUnCBW90+l/qJTb0p6UD56CcpCuZkAZAqUX4jIVeAbO5AOpt/AsC2bnM/8D3Nql/+MNHOqq4tDNTCE8hz0uBx39e2QlIwq16W5go3zaAYq1AWPGvuq3FBPAyo74d3BxA7fIU3wNjWuYZy7Q5mdwVTrf0Rdvpl0ldF4nm3wUW1kRSToT1FwIsKBfEVW3vB70IPMQfbngjLG160L7HaFzkVK1he5kcWpXdTi2id9/3GAHD7/lEaYZorJL+7Xz+vQ== angerman@rmbp13" ];
    antonio        = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEuAlDa0iIeYzPac5kAEZZJoV+lwjMlJJyWLg3ZH618oP2ByubL+M4gVW2pGCwk5YhdWZW8gvIHDTZMrRIIcyvhQQlBTpb26fBOgzB66uAFDQYkxkxUqagVa6+jggqd6bUA6E19GTLdPcPeb4LaUuLmRs1EVRdeIlHBWDsSbuJbW2I3/PFFmOilzZOplJmC7RJHbkwuHaQTNC8IKfXp5V4/y+4/eb9eDu9/NKVVNQJELZBQGBoNww4M+5gEmUMe1Nweza2Ez7RrzEbkugwUTJGZrb6/w3p8IWzFz6mFOmmflMCN0yHVXuWjGEmAj6Ux+bUs7NWexMENygbBk40qdXFeGJRRCZG6GjdLcKkcsa/AoTbQTwuZFYI6cdLuHNaV5Tw5FMTA57AX90EAxiltA334+8/K4NlHzmtTCPhBnKSzfv9J1KY/t1XklyOW2jo9+Kvmrp5RGKh/5Vo27haIUmnD1VqaFyOh6TYT8m4WAQ5QJ3Na2HWZbOqMtDMAxjfisk= antonio.ibarra@iohk.io" ];
    awiecz         = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCY/bSEjiddGXjDdsc+h8uPnHkviBtjnjWJ8Nm2sGjOND3qq2ARMgtYzbvkhtZdgZBjhkZzisrVXI/P5Nkmb2MY1hpAZIebo6vmgd1XfYkoGL03xRkikz8Qp72pvlUne2Io91DBEoqnvPgai7ogmDSd2Aoi7+idjQ4KU/6/JGE37r0LovEn//Y0dUKDXwCBzYaoISRkINq0TSigP9RM/if27KkOQqv/9d5HOWLCb+bUyBY29CixFl39Dyz/lRqVE5Ewznod3BpNIaYLpdR4sxiisgybtP8evJ1wA51m1lpLr/MXgA0t4tZcX8BKEv5Wz7wrzb+ZL3MEmMHTsXgEw9DH artur.wieczorek@iohk.io" ];
    coot           = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOU9P70MJadVoXtXWSEG4G/0kEfMtPqQKM9wUb2T2l70 coot@coot.me" ];
    crocodile-dentist
                   = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILzHwh2y+4KxJXI4Lx6KP1a0bh/iQFe2BZ7CU1HpY/Xp marcin.wojtowicz@iohk.io" ];
    dnadales       = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC79R4WdKcB34PamcmHkEnafstXd8KUMhgreye8txe99LTs0HKwbSrDlIQ47zu6o4TdU8MbjynGRfEuApy8IBRO9swjj+K9X0vcyWIXgWwIfFVqGyqLcdbzF2PAHzS4TPHzIfWMlaT9cKZ4a6e60xwL6fJwfFyWzxD6vGF5KuVnOGEoHMvVao5TV/bcO1lJ3WagFdw0MpVoYjwM3km/QwZiAOAl28HlVTe+j6vN1Io6EaTnRMEXppB4rhQnBFCdB4xmkxCFMZwKwXuUEfP4C+ob6j49PCg5694Ig+7y4QOZo9Dc9YQU77hOYlDNPLdvgmjceCFDKuDcFWAnM5aatZGHtZCwZAYboF5n/eMQu6+IastJ6ns4f2abg3DQkykIflO56XQ2LtZW7y8pNAiO5ttkYA4KZbcUUO1G7RK/qzH+tgaY/iE5ySbIuOFI145W02p8DEsJu/EPzRJlO1GcpBCO15cXBpJzkUko2sAdomN59stj5bhCB7ucCIRWFOz4CE3uiQAR51R4A/ZIL2jcIHalJskWV99XJVq9YuWq8HrFGMeiK1FyL+q1ycHmmXbWv81MZ/Y5Upf21s8NWyWIotLf+6HWFzs8oCnNwS2Xb/NXps9Y1OZDblQyMpnwSNT7cmitRjU3SGr1UFdpAEW56maSM6JfFtdCKs+xTtKfPmZUKw== damian.only@gmail.com" ];
    erikd          = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBz3TPhcOjxpnE6aTD6GNgXF2eKcOLdlp3ObtixhT4yN erikd@ada" ];
    fmaste         = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBZQcPdSFRwOl6rf/hJ0PDtbe8jCZiz2rW8XFJQeH82z fmaste@deployer" ];
    jmillar        = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC37IdiRVmNRlU7inGR+1ZL2lo/eJMSpSGSHHWq6YyJgvYFpGYiN3ybPXXOjZw3Oj82T35gqzeWSuBXUB1lgV2K/nOBlbicVAe2IJPte9rkJL47MH34z0d2pOtxgMdcFy/n4LaiczUejhr3W5ODuuq81GB3xozNxdy/4ECEQSpi9KxMgfwpaHtLk1rwAQcdPxoKFv1So/TP2u1TkmL231kA+2KqBECBs4iCqlmPodH1lFS9VuJpLgWp4W8xLdicLac1oOpfGGuMZfghIC8OPUuZ13b1EswP5HCpMEZvv8bpWRbQfeiruldV2mCL6jVo8SkNFQk6bft/xPU49gYYQjpZgzY9Is1oCvAXjRgArTKsLUP5Qb4UlrKzC+Px7TJHJJgBSXCsYoEjPezBJOR/fsD5WBUmFaOAlkqmgvFm4bF1octl4o6bKSjn3TrtwImU2JF2uH848SxhiDKigoFqvb+Z0gT1+7pMFh4YaAbRawJRCtQ5Y++HdelgD/QMsldNh84Ot4akJCiHun7DZA2ahd6dwCAI/xhR891JhFaeaMkX+UR89AwASHp3xe8gwylxrvskTPxYXmdMrKHk3UHOXf7Mq98dPVUETMTsbrtijkeLjocYOd731An4kWWQ/LqmzcGrPtFEPZ3qMNTqDwAzmoVJjfdQCJ42htyg2vli7IYweQ== jordan.millar@iohk.io" ];
    lars           = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7AM6TDijvz2LlW4OVJXFFoiPwtxUg47861kZgwQbUpgWRAC1er81KZrF7532x6/+MO1WyO29ckdwaVRNL7M04JQDNsVRNhwl6H32rZqdBpxvnSZce4LeR0yasddFpkQmnqB2AxiNmECkw4gbxHgaSLv59pi6vPTKihNlaxK338MkuwtorcO3eJ1NB0Ap2Cl+oBO8E9eDuhArFdWwX4BhqVwIWSI7KNzj+jNavO2qyjfr1CsJpc3qJLQEdX0Oy3VSFykSvSDsk5uldcv4eglgBLNSq9qiZ0K2WlYM+BZOUdVV6bQUq+WQdLX5siEy+ZLwhACSZ3PxTgynRY3BWrWIVsyWClAWixGedz6BBeNZekGymnrcy7ncQ3F1+Vgjhtld9qmLjQYxR4/fKTKT0LtG3aDYmv9gnlwqbenNepiefRsbVYhrsuX4meHg3CUmAc40tYASPghqpKxY+BM0QwXDLQD0qzbhzGzRmASkxFcvmgEzfXlVASvFduqZPRUoKOTiUiV6aVlPQewY81BevT6SB76GM4XqArfExqHKb3S/5cnLO+8tzoxxnRMbI846rSZzh5mNYPp2SDCrvbAkbxWGxlrPJgyZWC/QlGaWCju4pzLzTpVxs1X461NPzUetdc15IlGq44QNSHHM8sIYd2GA2d8khmplPW5UFVPwpk0emcQ== brunjlar@gmail.com" ];
    lehins         = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFwcox8AXieL9Nhqv1PTszaywCa1U2i/j58jNTIqN5ub" ];
    mkarg          = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcTVqOT1DL6bBYWa95mpJNf/O51iiEtABeSFGiKN5KpEcUyePWWxq+fE/2BsWlqlt/XJzlD5J1hhTY1+Ancu9HuHWxWZbbHf4Iydo7HE7wRF4vxFUzQXyWwB1cVIuE2/5Fkxvq7+O7adGC1NHbXjy/auD4kuTdCfNrKcdDQfd64l9VasCjG3Ii5AcCvn7nGUIFBp+sBH3Hur7CCqF/yX5tPuyGnCl2Lj5ElhHFfyd17ws2zyykD6CsGZq5+LhB5ZIy+377l0Od8LDWnxvFmTEkf3SPUUjBrR+PFwELZlebR0c6btyxwGK9xFaHF8m9lYTaU98XXaCXuxm5mqxyL99JbljhI3Vv6Vks03F9AUiqHeIUfaejpEBkL1WsJmT4YA8odsmc0mhXiM4qLE7siMc6aM/MgIzeLWvyZySBd+cZJOrV8FV02ZsS0qQPUovUWv4xWsUfiVNnPnYeZCjN/9ryfzg7os4z1RHiFNPlbV4gWdpMeCmwmRPidsWgZ4VO+lJX+kBkTPoUzizW388TmiUP1MuWh9N8Lcgh0j9KJWHQlkBjUza0DnVggUPxnleNdL2E0CwHxmi/oD+vu6QbEwegD7MzmMlJVULlxJeY91xDWPhhmC3ll1527HPlYasB6D3pbhIn7Rh2j0a6l7Em8ciOdmOtm/CdTdT/UGZIpvvnRQ== michael@Marias-MBP.fritz.box" ];
    mkourim        = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1ZbaJPH+tsZjF6/6rHCjG7lF+TZsN60lEBdSAnyqJ8j10UqvXctMYM45WT17eRPHhTyPuV4m/VkfeoI1wwZrZigkkLLHFX5nkJ77gKBPLVe3QAOF52/XnAcY1vUVuT0wxBTJtsnxJB1egN0N9ZwOXLpZNI539YtV8J0ipsMw4+fZSEhHyO3Jja6/DAP02WtvUh/tQHmMmEOUY2c2y5xhY4ar4LVS8EkzMV9r5FdwVrPrjeH7fxCN/5meGKFzazdDwbh3T7WqnQWERmjcOowVr4W8aRKh0miH6/5bmOKTsJth12vMg5dNfNppKJOXjp1AGBjgWx4JTsr5/XrYGT+xV martin.kourim@iohk.io" ];
    nchambers      = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCUHLPGiTLSeNSKS29exJvFC1H9EcE0rjXrEq9EWGoCKFSZi+tSDg0YzXioHUFcHyP8WP1D63pd9zw6Pzv5PdRKU8Ekpn8qdPMciKQNOOgwo8sPUJPE7OCNElf9PECCeXuK3JgpkF0L4STjwiXyspxSyutu7GLPfdDmu25Nq8PGPzCeylVr8ayL4+qFi60XfqFcHD8BOd5Nb6vBscl54+uybDNJlsxAvr2CP8cBPfQ8o74z39TE8ifmBQzo2jmYPRoyI/p2EcxYknxTBi42GADk8Xwfdotii6L5nwsaPKOtZcciaI7oKk4I/UlwcR2IBbjpJwJlXxIAeP/+E/j7wN6FgGRWvOatd9rREbr6fpP3C9OM3qmzcLI/YRxG+fmhOAgPlq3CE9fP20RWQFIs9QwENRswx9RIQ6v50MrSA7z+m1sY9KqC34A38/V9I6eB1t5myrDgeX9RTJZ25w4cRr9gqF/NdVWuZxTdn8ebx8qtDrvK/Bc4gth1K3Qgc0BIFug57bUjy0WXFnuU/xClhQP45K7WBRfCL5uQdltT8lCjr2M7yJ7OzOqxOHDNZJrQVB6q6vb2uCJxkCYUmSozNyES8/SqelhSDx5g+0zY7HBmLQ/d6THTW9eF1O25WbLl+JVoyyDVGL4btxgNp07UV313vJVfY9PUHmbLJvBHgqhOhQ== nyc@nyc-laptop" ];
    neil           = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKNIwb3P5/7abrv8jPjUTN6xGUlGrbzl90dt6OJaYM7w neil.davies@iohk.io" ];
    nfrisby        = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDgjGmjxShnFvHPp1nDCGRb9Mcs/D4mB9CN/4WkmRqoR7unRoTJ4SbhDLpAH7LqkgkEbOMl+bmr/B3yNNzgXFtrGombrzHLLPSx7sB7l0BHbCn+Lzd0FdpkD3TMlOsFhl6+y8B6TG/cgI9Mc9zck4jaEvx/+vF9Hj9zocLbMIvCRirsyHGwxrmVr61zXSUP5LnbeUEDhrKBcd5arSrlE59TkhapwtY77/twbziIz8E8AH5i5sQUVi3ApkhZp1jgawiRi/1PFLPgZCNLyU4Mkor45Mi+9JKronynWm/IJt/dcIDkaVusZl5DQO45Q6VBwODN3I/RQBpSy2C+WLjTF3za6LZgOg9rjWL9WDifW26J8Ji7iLyXlKqd3hOCIFxUTVNZCLaSuyID2YUTTlRj5suVtqfc7FKLS76mVjzdJRbie/U1SLpxABu3Iqj++SNAjZN02ULD8JDf434d4vtTi1rzGJ8emZADthVMM36XwxZLR/j3kcLUw/i0Ehdbj6fQ5QdiEdU9QTdQklsqu62kqpbPJI26aGKDpjqLWQKBxD0sL7F2CALRaUxFW9psh3aeovCpWvIIquP6Z8Xob+k3rkB1EJF0v7yUypmHiJXG/Ct4/RlS40cg82hBMZ5OtOsl4r+38E8QcdoGwmAfUy4abH9rNnEQum5s6hxE7Ry44HrBcw== nick.frisby@iohk.io" ];
    tsenguun       = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQBcbKV1ru917kk95p1GgEnjr185I+Rgq+xVHnHP7FCR3gRGm3o/QdotIFb5wQb7/jhNbF4lHNvpfvWOxPGHFfFJ7XU8DLW539YR4ed20btnpHl6DTfINpWl8I6lwzT/XWLooVSPhTky9ZvsuIihv9XffGcTf+GQyJ1KQxURHEe7roapih0ea++sw+DFf1uSGlNpV+XVFZgLi3iTEvTI0yzm33pZ2ZzYlWWrzf2AILRJ1A0mYW5bAPInmXOX0LcOW0c06s79JuZ9Co+sDVDSJbUXKJIkEt++SOwzc58aYRRFuTun3rNb0FBpAizjLNswQwSCVuPDKAKaIHEvOKGYJ6n5 tuvshintsenguun.erdenejargal@iohk.io" ];
    kchaires       = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICuEp7B+GEWg0jBAUG8wAo5BPhPGImf2dB//ySZvqgji karina.lopez@iohk.io" ];
    jasagredo      = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/VgQqHapAJ0ToCdhvarY84RD3BFMXsY16dEBeeKk0q jasataco@gmail.com" ];
  };

  # Mantis devops keys:
  #
  mantis-devOps = {
  };

  # Mantis developer keys:
  #
  mantis-developers = {
  };

  plutus-developers = {
    kenneth        = [ "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr/gslNL1LntKBlqbSGFn9soRwizJfYU2vM45oTMMbroKg9SrsMU9CtXElV5j4rAqSN/8wf5g0aP8E+u1B4IklT6qrnp9kTNq6YDqYXCi/39mqdl4rKvY/hRFrgaxMbQg6PU7lLaT+p2WPsMbjZ/Cr5hlT0PEspH1ucEnfs33RPYNwfN4HJt8zLjuZsHAWJCzRAr14CKze47yVhour5q18N5V668Gz54TW5vh9Af0jVleudgmMTw6uiIxVfCXDih5ir7iLrxCuLdY5+Ljm5ff2atcHehUTOYOhBAa71sKcvyiL21PF1PglHpp2+JOFmEXjzSOh1Ujt2alaUruE9NNjw== kwxm@pomegranate" ];
    roman          = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEh6j4ImWVuNRv5InE3havU9RTFJakBQvrDEkttmE/Bu effectfully@gmail.com" ];
    nikos          = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPOEwI1amjadX4pPxsYp7Ee1MAi8/tuPM+goiay089+t bezirg@lenovo" ];
    ziyang         = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQ0CTCsumV0DD+5JLIdaUpgZVvesWR7I/LExEoc1onh unsafeFixIO@gmail.com" ];
  };

  # Keys to allow remote nix-builds
  #
  remoteBuilderKeys = {
    buildfarm = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGnB2GWvJ4jnh07JbkIicLjR+JHl4VwkAhXToHFENZnA buildfarm-ng" ];
  };

  ############################################################################

  # Function to flatten the keys attrset
  allKeysFrom = keys: with lib; concatLists (attrValues keys);
}
