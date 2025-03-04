{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Enable EFI.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Canada/Eastern";

  users.users.zander = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    description = "Zander";
    password = "temp";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRApMFBCUexnLHkzjW3QyUYRJSP50wVp4ojj8cdXGwz zander"
    ];
  };

  users.mutableUsers = false;

  programs.sway.enable = true;
  programs.vim.enable = true;

  environment.systemPackages = with pkgs; [
     vim
     wget
     ffmpeg_6-full
     fish
     neofetch
  ];

  # Services

  # Enable pipwire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver.enable = true; # KDE

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.flatpak.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  system.stateVersion = "24.11";

}

