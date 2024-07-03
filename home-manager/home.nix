# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
#  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  aagl = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
 #     outputs.overlays.additions
 #     outputs.overlays.modifications
 #     outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # TODO: Set your username
  home = {
    username = "bmorgan";
    homeDirectory = "/home/bmorgan";
  };

  # Add stuff for your user as you see fit:
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    hyprland
    hypridle
    hyprpaper
    dunst
    waybar
    pwvucontrol
    blender
    gimp
    playerctl
    kitty
    discord
    aagl.anime-game-launcher
    aagl.anime-games-launcher
    aagl.anime-borb-launcher
    aagl.honkers-railway-launcher
    aagl.honkers-launcher
    aagl.wavey-launcher
    wofi
    taskwarrior
    vit
    cool-retro-term
    steamcmd
    tidal-hifi
    lutris
  ];
  xdg.enable = true;
  programs.firefox.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git.enable = true;
#  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
#  services.hypridle.enable = true;
#  services.hyprpaper.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
