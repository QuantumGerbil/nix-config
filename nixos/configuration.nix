# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

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

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.swraid = {
    enable = true;
    mdadmConf = "MAILADDR root\nARRAY /dev/md127 level=raid1 num-devices=2 metadata=1.2 UUID=08d8a57a:ef52f4f5:e5fc20fd:829b63c6\n\tdevices=/dev/sda1,/dev/sdb1\nARRAY /dev/md126 level=raid1 num-devices=2 metadata=1.2 UUID=10dd753c:44d3438a:f64091ac:2af6d35e\n\tdevices=/dev/sdc1,/dev/sdd1\nARRAY /dev/md125 level=raid0 num-devices=2 metadata=1.2 UUID=fca4eab0:c1a869a1:aed93f8b:14e7f4e4\n\tdevices=/dev/md126,/dev/md127";
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "us";
  #  useXkbConfig = true; # use xkb.options in tty.
  #};

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.xkb.layout = "us";
  services.printing.enable = true;
  services.displayManager.sddm.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  hardware.graphics = {
    #driSupport = true;
    #driSupport32Bit = true;
    extraPackages = with pkgs; [
    rocmPackages.clr.icd
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.gamescope.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  #system.copySystemConfiguration = true;

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    bmorgan = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel audio networkmanager input"];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  networking.extraHosts = 
    ''
      0.0.0.0 overseauspider.yuanshen.com
      0.0.0.0 log-upload-os.hoyoverse.com
      0.0.0.0 log-upload-os.mihoyo.com
      0.0.0.0 dump.gamesafe.qq.com

      0.0.0.0 log-upload.mihoyo.com
      0.0.0.0 devlog-upload.mihoyo.com
      0.0.0.0 uspider.yuanshen.com
      0.0.0.0 sg-public-data-api.hoyoverse.com
      0.0.0.0 public-data-api.mihoyo.com

      0.0.0.0 prd-lender.cdp.internal.unity3d.com
      0.0.0.0 thind-prd-knob.data.ie.unity3d.com
      0.0.0.0 thind-gke-usc.prd.data.corp.unity3d.com
      0.0.0.0 cdp.cloud.unity3d.com
      0.0.0.0 remote-config-proxy-prd.uca.cloud.unity3d.com

      0.0.0.0 pc.crashsight.wetest.net
     '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
