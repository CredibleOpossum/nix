{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./disko_config.nix
  ];

  networking.hostName = "raptor";

  # Enable flake support.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
  boot.supportedFilesystems = [ "ntfs" ];

  zramSwap.enable = true;

  # Non-free NVIDIA
  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;

  time.timeZone = "Canada/Eastern";

  users.users.root.hashedPassword = "!"; # Disables root login, not too important.

  users.mutableUsers = false;

  programs.sway.enable = true;
  programs.vim.enable = true;

  users.defaultUserShell = pkgs.bash;
   programs.bash.shellAliases = {
     "update"="sudo nixos-rebuild switch --flake /etc/nixos#nixos";
   };

  environment.systemPackages = with pkgs; [
    # Roughly sorted by most important -> least important
    git
    vim
    wget
    kdePackages.ark

    ffmpeg_6-full
    mpv

    nixfmt-rfc-style

    podman-desktop
    distrobox  

    neofetch
  ];

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Pipewire
  services.pulseaudio.enable = false;
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
  services.envfs.enable = true;
  programs.nix-ld.enable = true;

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
