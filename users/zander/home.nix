{ ... }:

{
  home.username = "zander";
  home.homeDirectory = "/home/zander";

  programs.alacritty.enable = true;
  programs.alacritty.settings.window.opacity = 0.7;
  programs.alacritty.settings.colors.primary.background = "#0E1415";
  programs.alacritty.settings.colors.primary.foreground = "#CECECE";

  # TODO: my gnome configuration needs to be reflected here

  programs.home-manager.enable = true;
  home.stateVersion = "22.05";
}
