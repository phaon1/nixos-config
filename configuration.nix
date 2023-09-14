{ config, pkgs, ... }:

let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      aagl-gtk-on-nix.module
    ];

# Bootloader.
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Enable networking
networking.networkmanager.enable = true;

# Set your time zone.
time.timeZone = "Europe/London";

# Select internationalisation properties.
i18n.defaultLocale = "en_GB.UTF-8";

i18n.extraLocaleSettings = {
  LC_ADDRESS = "en_GB.UTF-8";
  LC_IDENTIFICATION = "en_GB.UTF-8";
  LC_MEASUREMENT = "en_GB.UTF-8";
  LC_MONETARY = "en_GB.UTF-8";
  LC_NAME = "en_GB.UTF-8";
  LC_NUMERIC = "en_GB.UTF-8";
  LC_PAPER = "en_GB.UTF-8";
  LC_TELEPHONE = "en_GB.UTF-8";
  LC_TIME = "en_GB.UTF-8";
};

# Enable the X11 windowing system.
services.xserver.enable = true;

# Enable the KDE Plasma Desktop Environment.
services.xserver.displayManager.sddm.enable = true;
services.xserver.desktopManager.plasma5.enable = true;

# Configure keymap in X11
services.xserver = {
  layout = "us";
  xkbVariant = "";
};

# Enable CUPS to print documents.
services.printing.enable = true;

# Enable sound with pipewire.
sound.enable = true;
hardware.pulseaudio.enable = false;
security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
};

# Define a user account. Don't forget to set a password with ‘passwd’.
users.users.noah = {
  isNormalUser = true;
  description = "noah";
  extraGroups = [ "networkmanager" "wheel" ];
  packages = with pkgs; [
    firefox
    discord
    spotify
    podman
    distrobox
    git
    protonup-qt
    wine
  ];
};

home-manager.users.noah = { pkgs, ... }: {
  home.packages = [];
  programs.zsh = {
    enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "agnoster";
    };

    zplug = {
      enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
        ];    
    }; 
  };
    
  home.stateVersion = "23.05";
};

# Enable zsh
programs.zsh.enable = true;
users.defaultUserShell = pkgs.zsh;

# Enable dconf
programs.dconf.enable = true;

#Enable virtualisation
virtualisation.libvirtd.enable = true;

# Enable nur
nixpkgs.config.packageOverrides = pkgs: {
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    inherit pkgs;
  };
};

# Allow unfree packages
nixpkgs.config.allowUnfree = true;

#Enable flatpak
services.flatpak.enable = true;

# Enable flakes and nix command
nix.settings.experimental-features = [ "nix-command" "flakes" ];

#Enable aagl
programs.anime-game-launcher.enable = true;

environment.systemPackages = with pkgs; [
  virt-manager
  pkgs.libsForQt5.kate
];

system.stateVersion = "23.05";

}
