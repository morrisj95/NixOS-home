{ config, lib, pkgs, ... }:

let
  colorscheme = (import ./colorschemes/onedark.nix);

  custom-panel-launch = pkgs.writeScriptBin "custom-panel-launch" ''
    #!/${pkgs.stdenv.shell}

    killall -q polybar
    killall -q volumeicon

    polybar main &
    polybar powermenu &
    nm-applet &
    volumeicon &
  '';

  custom-script-sysmenu = pkgs.writeScriptBin "custom-script-sysmenu" ''
    #1/${pkgs.stdenv.shell}
    ${builtins.readFile ./polybar/scripts/sysmenu.sh}
  '';

  custom-browsermediacontrol =
    (import ./browser-media-control/default.nix) { pkgs = pkgs; };


in
{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    dconf
    nmap

    discord
    i3lock-fancy
    lxappearance
    arc-icon-theme
    arc-theme
    #dracula-theme
    gnome3.networkmanagerapplet
    volumeicon

    awscli
    git
    gitAndTools.gh
    ngrok
    gnumake
    gitAndTools.delta
    bat
    starship
    zsh-syntax-highlighting
    
    #bottom
    neofetch

    ranger

    scrot

    custom-script-sysmenu
    custom-panel-launch

    plasma-browser-integration
    custom-browsermediacontrol

    usbutils
    pciutils
    less

    (nerdfonts.override { fonts = [ "Hack" ]; })

    docker-compose

    openvpn
    gnome3.networkmanager-openvpn

    gcc
    go
    gopls
    ghc
    haskellPackages.cabal-install
    haskellPackages.stack
    haskellPackages.haskell-language-server
    nodejs
    nodePackages.livedown
    rnix-lsp
    (python3.withPackages (ps: with ps; [ setuptools ]))
    pipenv
    poetry
    python3Packages.pip
    python3Packages.pynvim
    python3Packages.ipython

  ];

  home.username = "jared";
  home.homeDirectory = "/home/jared";

  home.stateVersion = "20.09";

#  home.file.".config/chromium/NativeMessagingHosts".source = pkgs.symlinkJoin {
#    name = "native-messaging-hosts";
#    paths = [
#      "{pkgs.plasma-browser-integration}/etc/var/empty/chrome/native-messaging-hosts"
#    ];
#  };

  gtk = {
    enable = true;
    font = { name = "TeX Gyre Heros 10"; };
    iconTheme = { name = colorscheme.gtk-icon-name; };
    theme = { name = colorscheme.gtk-name; };
  };

  programs.home-manager.enable = true;

  programs.alacritty = {
    enable = true;
    settings = (import ./alacritty/config.nix) { colors = colorscheme; };
  };

  programs.git = {
    enable = true;
    userName = "Jared Morris";
    userEmail = "morrisj95@outlook.com";
    extraConfig = {
      core = {
        pager = "delta";
      };
      delta = {
        features = "side-by-side line-numbers decorations";
      };
      "delta \"decorations\"" = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow";
        file-decoration-style = "none";
      };
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override {
      plugins = [ pkgs.rofi-emoji pkgs.rofi-calc pkgs.rofi-file-browser ];
    };
    lines = 7;
    width = 40;
    font = "hack 10";
  };
  home.file.".config/rofi/colors.rasi".text = ''
    * {
      accent: ${colorscheme.accent-primary};
      background: ${colorscheme.bg-primary};
      foreground: ${colorscheme.fg-primary};
    }
  '';
  home.file.".config/rofi/grid.rasi".source = ./rofi/grid.rasi;
  home.file.".config/rofi/sysmenu.rasi".source = ./rofi/sysmenu.rasi;

  home.file.".config/volumeicon/volumeicon".source = ./systray/volumeicon.cfg;

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-devicons
      awesome-vim-colorschemes
      vim-table-mode
      dracula-vim

      vim-grammarous

      vim-which-key
      vim-haskellConcealPlus
      vim-polyglot
    ];

    extraConfig = ''
      ${builtins.readFile ./nvim/sane_defaults.vim}
      ${builtins.readFile ./nvim/airline.vim}
      ${builtins.readFile ./nvim/navigation.vim}
      ${builtins.readFile ./nvim/coc.vim}
      ${builtins.readFile ./nvim/theme.vim}
      colorscheme ${colorscheme.vim-name}
    '';
  };

  programs.nushell = {
    enable = true;
    settings = {
      edit_mode = "vi";
      prompt = "echo $(starship prompt)";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    enableAutosuggestions = true;
    shellAliases = (import ./zsh/aliases.nix);
    history.extended = true;
    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "be3882aeb054d01f6667facc31522e82f00b5e94";
          sha256 = "0w8x5ilpwx90s2s2y56vbzq92ircmrf0l5x8hz4g1nx3qzawv6af";
        };
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "vi-mode" ];
    };
    initExtraBeforeCompInit = ''
      ${builtins.readFile ./zsh/session_variables.zsh}
      ${builtins.readFile ./zsh/functions.zsh}
      ${builtins.readFile ./zsh/secrets.zsh}
      #eval "$(direnv hook zsh)"
      #bindkey -M vicmd 'k' history-beginning-search-backward
      #bindkey -M vicmd 'j' history-beginning-search-forward
      #eval "$(jump shell zsh)"
      alias ls="ls --color=auto -F"
      eval "$(starship init zsh)"
    '';
  };

  services.random-background = {
    enable = true;
    imageDirectory = "%h/Pictures/backgrounds";
  };

  services.polybar = {
    enable = true;
    config = (import ./polybar/accented-pills.nix) { colors = colorscheme; };
    script = "polybar main &";
  };

   services.picom = {
    enable = true;
    # inactiveOpacity = "0.55";
    # activeOpacity = "0.85";
    blur = true;
    experimentalBackends = true;
    opacityRule = [
      "100:class_g   *?= 'Google-chrome'"
    ];
    extraOptions = ''
      # blur-method = "dual_kawase";
      # blur-strength = 8;
      # corner-radius = 8;
      # round-borders = 1;
      #
      # rounded-corners-exclude = [
      #   "class_g = 'Polybar'",
      #   "class_g = 'Google-chrome'"
      # ];
    '';
    fade = true;
    fadeDelta = 5;
    package = pkgs.picom.overrideAttrs(o: {
      src = pkgs.fetchFromGitHub {
        repo = "picom";
        owner = "ibhagwan";
        rev = "44b4970f70d6b23759a61a2b94d9bfb4351b41b1";
        sha256 = "0iff4bwpc00xbjad0m000midslgx12aihs33mdvfckr75r114ylh";
      };
    });
  };

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = pkgs.writeText "xmonad.hs" ''
        ${builtins.readFile ./xmonad/config.hs}
        myFocusedBorderColor = "${colorscheme.accent-primary}"
        myNormalBorderColor = "${colorscheme.bg-primary-bright}"
      '';
    };
  };

  xresources = {
    properties = {
      "*.foreground" = colorscheme.fg-primary;
      "*.background" = colorscheme.bg-primary;

      "*.color0"  = colorscheme.black;
      "*.color1"  = colorscheme.red;
      "*.color2"  = colorscheme.green;
      "*.color3"  = colorscheme.yellow;
      "*.color4"  = colorscheme.blue;
      "*.color5"  = colorscheme.magenta;
      "*.color6"  = colorscheme.cyan;
      "*.color7"  = colorscheme.white;

      "*.color8"  = colorscheme.bright-black;
      "*.color9"  = colorscheme.bright-red;
      "*.color10" = colorscheme.bright-green;
      "*.color11" = colorscheme.bright-yellow;
      "*.color12" = colorscheme.bright-blue;
      "*.color13" = colorscheme.bright-magenta;
      "*.color14" = colorscheme.bright-cyan;
      "*.color15" = colorscheme.bright-white;

      "XTerm*font" = "xft:Hack Nerd Font Mono:pixelsize=16";
      "*.internalBorder" = 4;

      "Xft.dpi" = 138;
      "Xft.antialias" = true;
      "Xft.hinting" = true;
      "Xft.rgba" = "rgb";
      "Xft.autohint" = false;
      "Xft.hintstyle" = "hintslight";
      "Xft.lcdfilter" = "lcddefault";
    };
  };
}

