{ ... }:

{
  config = {
    home-manager.users.zander = ./home.nix;
    users.users.zander = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    description = "Zander";
    password = "temp"; # Todo: use some kind of secrets manager, local password however isn't that important.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRApMFBCUexnLHkzjW3QyUYRJSP50wVp4ojj8cdXGwz zander"
    ];
  };
  };
}
