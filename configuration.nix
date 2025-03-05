{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./disko_config.nix
    ];

  # Enable flake support.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Portal support (mostly for flatpaks)
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # Enable EFI.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.enableCryptodisk = true;

  # Non-free NVIDIA
  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;
  

  time.timeZone = "Canada/Eastern";

  users.users.root.hashedPassword = "!"; # Disables root login, not too important.
  users.users.zander = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    description = "Zander";
    password = "temp"; # Todo: use some kind of secrets manager, local password however isn't that important.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRApMFBCUexnLHkzjW3QyUYRJSP50wVp4ojj8cdXGwz zander"
    ];
  };

  users.mutableUsers = false;

  programs.sway.enable = true;
  programs.vim.enable = true;

  environment.systemPackages = with pkgs; [
     git
     vim
     wget
     fish
     neofetch

     kdePackages.ark

     mpv
     ffmpeg_6-full
  ];  

  # Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Services
  services.xserver.enable = true; # KDE

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.flatpak.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  
  services.earlyoom.enable = true;
  
  # One shot scripts
  system.activationScripts = {
    flathub = ''
      /run/current-system/sw/bin/flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      '';
  };

  # Enviroment
  environment.variables.EDITOR = "VIM";

  system.stateVersion = "24.11";
}

