# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''experimental-features = nix-command flakes'';
  

  boot.loader.systemd-boot.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver.layout = "us";
  services.xserver = {
    enable = true;
    displayManager.sessionCommands = ''
      xrandr --output DP-1 --mode 3840x2160
    '';
    desktopManager.session = [
      {
        name = "home-manager";
        start = ''
          ${pkgs.runtimeShell} $HOME/.hm-xsession &
          waitPID=$!
        '';
      }
    ];
  };
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = false;

  users.users.jared = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "docker" "dev" "plex" ];
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    neovim 
    chromium
    pulseaudio
    polybar
    rofi
    git
    i3lock-fancy
    home-manager
    docker
  ];
  environment.pathsToLink = ["/libexec"];
  programs.dconf.enable = true;


  services.openssh.enable = true;
  services.mongodb.enable = true;
  services.dockerRegistry.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "20.09";
}

