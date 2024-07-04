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
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
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
      allowUnfree = true;
    };
  };

  home = {
    username = "bmorgan";
    homeDirectory = "/home/bmorgan";
  };

  programs.neovim.enable = true;
  home.packages = with pkgs; [
    hypridle
    hyprpaper
    hyprcursor
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
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    gamemode
    mangohud
  ];
  xdg.enable = true;

  programs = {
    firefox.enable = true;
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "QuantumGerbil";
      userEmail = "bpmorgan@pm.me";
    };
    hyprlock.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

#  home.sessionVariables = {
#    QT_QPA_PLATFORMTHEME = "qt6ct";
#  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.systemd.variables = ["--all"];
  wayland.windowManager.hyprland.systemd.enable = true;

  programs.hyprcursor-phinger.enable = true;
  catppuccin.flavor = "mocha";
  catppuccin.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";

  services.hyprpaper.settings = {
    preload = "~/.wallpaper/HDRshooter-AI-generated-wallpaper-3440x1440-001.jpg";
    wallpaper = [ "DP-1,~/.wallpaper/HDRshooter-AI-generated-wallpaper-3440x1440-001.jpg" ];
  };

  services.hypridle.settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";       # avoid starting multiple hyprlock instances.
      before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
      after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
    };

    listener = [
      {
        timeout = 150;                                # 2.5min.
        on-timeout = "brightnessctl -s set 10";         # set monitor backlight to minimum, avoid 0 on OLED monitor.
        on-resume = "brightnessctl -r";
      }                 # monitor backlight restore.

      # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
      { 
        timeout = 150;                                # 2.5min.
        on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
        on-resume = "brightnessctl -rd rgb:kbd_backlight";        # turn on keyboard backlight.
      }
      {
        timeout = 300;                                 # 5min
        on-timeout = "loginctl lock-session";            # lock screen when timeout has passed
      }
      {
        timeout = 330;                                 # 5.5min
        on-timeout = "hyprctl dispatch dpms off";        # screen off when timeout has passed
        on-resume = "hyprctl dispatch dpms on";          # screen on when activity is detected after timeout has fired.
      }
      {
        timeout = 1800;                                # 30min
        on-timeout = "systemctl suspend";                # suspend pc
      }
    ];
  };

  programs.hyprlock.extraConfig = ''
    background {
    monitor =
    #path = $HOME/Pictures/wallpapers/bgs/bocchi-new.png  # only png supported for now
    color = $color7

    # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
    blur_size = 5
    blur_passes = 3 # 0 disables blurring
    noise = 0.0117
    contrast = 1.3000 # Vibrant!!!
    brightness = 0.8000
    vibrancy = 0.2100
    vibrancy_darkness = 0.0
}

input-field {
    monitor =
    size = 250, 50
    outline_thickness = 3
    dots_size = 0.2 # Scale of input-field height, 0.2 - 0.8
    dots_spacing = 1.00 # Scale of dots' absolute size, 0.0 - 1.0
    dots_center = true
    outer_color = $color1
    inner_color = $color0
    font_color = $color7
    fade_on_empty = true
    placeholder_text = <i>Password...</i> # Text rendered in the input box when it's empty.
    hide_input = false
    position = 0, 50
    halign = center
    valign = bottom
}

#Top text
label {
    monitor =
    text = ぼっち・
    color = $color6
    font_size = 12
    font_family = JetBrains Mono Nerd Font 10
    position = -38, -45
    halign = center
    valign = top
}
label {
    monitor =
    text = ざ
    color = $color3
    font_size = 12
    font_family = JetBrains Mono Nerd Font 10
    position = 3, -45
    halign = center
    valign = top
}
label {
    monitor =
    text = ・ろっく！
    color = $color4
    font_size = 12
    font_family = JetBrains Mono Nerd Font 10
    position = 53, -45
    halign = center
    valign = top
}

# Current time
label {
    monitor =
    text = cmd[update:1000] echo "<b><big> $(date +"%H:%M:%S") </big></b>"
    color = $color3
    font_size = 64
    font_family = JetBrains Mono Nerd Font 10
    position = 0, 16
    halign = center
    valign = center
}

# User label
label {
    monitor =
    text = Hi there, <span size="larger">$USER</span>
    color = $color6
    font_size = 20
    font_family = JetBrains Mono Nerd Font 10
    position = 0, 0
    halign = center
    valign = center
}


# Type to unlock
label {
    monitor =
    text = Type to unlock!
    color = $color4
    font_size = 16
    font_family = JetBrains Mono Nerd Font 10
    position = 0, 30
    halign = center
    valign = bottom
}
  '';

  wayland.windowManager.hyprland.extraConfig = ''
# You can split this configuration into multiple files
# Create your files separately and then link them to this file like this:
# source = ~/.config/hypr/myColors.conf


################
### MONITORS ###
################

# See https://wiki.hyprland.org/Configuring/Monitors/
monitor=DP-1,3440x1440@144,auto,auto


###################
### MY PROGRAMS ###
###################

# See https://wiki.hyprland.org/Configuring/Keywords/

# Set programs that you use
$terminal = kitty
$fileManager = dolphin
$menu = wofi --show drun


#################
### AUTOSTART ###
#################

# Autostart necessary processes (like notifications daemons, status bars, etc.)
# Or execute your favorite apps at launch like this:

exec-once = $terminal
#exec-once = nm-applet &
#exec-once = blueman-applet &
exec-once = hypridle
#exec-once = eww -c .config/eww/ daemon && eww open bar
exec-once = waybar &
exec-once = hyprpaper & firefox


#############################
### ENVIRONMENT VARIABLES ###
#############################

# See https://wiki.hyprland.org/Configuring/Environment-variables/

env = XCURSOR_SIZE,24
env = HYPRCURSOR_THEME,phinger-cursors-dark
env = HYPRCURSOR_SIZE,24
env = WLR_DRM_DEVICES,$HOME/.config/hypr/card:$HOME/.config/hypr/fallback

#####################
### LOOK AND FEEL ###
#####################

# Refer to https://wiki.hyprland.org/Configuring/Variables/

# https://wiki.hyprland.org/Configuring/Variables/#general
general { 
    gaps_in = 5
    gaps_out = 20

    border_size = 2

    # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    # Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false 

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false

    layout = dwindle
}

# https://wiki.hyprland.org/Configuring/Variables/#decoration
decoration {
    rounding = 10

    # Change transparency of focused and unfocused windows
    active_opacity = 1.0
    inactive_opacity = 0.8

    drop_shadow = true
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)

    # https://wiki.hyprland.org/Configuring/Variables/#blur
    blur {
        enabled = true
        size = 3
        passes = 1
        
        vibrancy = 0.1696
    }
}

# https://wiki.hyprland.org/Configuring/Variables/#animations
animations {
    enabled = true

    # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
dwindle {
    pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = true # You probably want this
}

# See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
#master {
#    new_is_master = true
#}

# https://wiki.hyprland.org/Configuring/Variables/#misc
misc { 
    force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
}


#############
### INPUT ###
#############

# https://wiki.hyprland.org/Configuring/Variables/#input
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

    touchpad {
        natural_scroll = false
    }
}

# https://wiki.hyprland.org/Configuring/Variables/#gestures
gestures {
    workspace_swipe = false
}

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
device {
    name = epic-mouse-v1
    sensitivity = -0.5
}


####################
### KEYBINDINGSS ###
####################

# See https://wiki.hyprland.org/Configuring/Keywords/
$mainMod = SUPER # Sets "Windows" key as main modifier

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, Q, exec, $terminal
bind = $mainMod, C, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, $fileManager
bind = $mainMod, V, togglefloating,
bind = $mainMod, R, exec, $menu
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle

# Move focus with mainMod + arrow keys
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Example special workspace (scratchpad)
bind = $mainMod, S, togglespecialworkspace, magic
bind = $mainMod SHIFT, S, movetoworkspace, special:magic

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

bindel=, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0
bindel=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindl=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindl=, XF86AudioPlay, exec, playerctl play-pause

##############################
### WINDOWS AND WORKSPACES ###
##############################

# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
# See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

# Example windowrule v1
# windowrule = float, ^(kitty)$

# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
windowrule = opaque, ^(firefox)$
windowrule = fullscreen, ^(gamescope)$
windowrule = noanim, ^(gamescope)$
windowrule = immediate, ^(gamescope)$
windowrule = idleinhibit always, ^(gamescope)$
#windowrule = float, ^(gamescope)$
windowrule = windowdance, ^(gamescope)$
windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.
'';
}

