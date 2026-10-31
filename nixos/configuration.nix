{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";
  i18n.supportedLocales = [ "all" ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # ---------------------------------------------------------------------------
  # NVIDIA DRIVERS (GTX 1050, Pascal architecture)
  # ---------------------------------------------------------------------------
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    branch = "legacy_580";
    powerManagement.enable = false;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
  };

  # ---------------------------------------------------------------------------
  # DISPLAY MANAGER + DESKTOPS
  # ---------------------------------------------------------------------------
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.xkb = {
    layout = "ru";
    variant = "";
  };

  # ---------------------------------------------------------------------------
  # HYPRLAND
  # ---------------------------------------------------------------------------
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # ---------------------------------------------------------------------------
  # AUDIO
  # ---------------------------------------------------------------------------
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;
  documentation.doc.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ---------------------------------------------------------------------------
  # FLATPAK / NIX-LD
  # ---------------------------------------------------------------------------
  services.flatpak.enable = true;
  programs.nix-ld.enable = true;

  # --- GAMING / DEVOPS ---
  programs.steam.enable = true;
  virtualisation.docker.enable = true;
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  # ---------------------------------------------------------------------------
  # USER ACCOUNT
  # ---------------------------------------------------------------------------
  users.users."umka" = {
    isNormalUser = true;
    description = "umka";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    
    packages = with pkgs; [
      # --- мои пакеты ---
      cava
      git
      gh
      alacritty
      kitty
      fastfetch
      cmatrix
      vscode
      curl
      tree
      aalib
      peaclock
      gtop
      btop
      htop
      lavat
      gcc
      gnumake
      cmake
      stlink
      zed-editor
      python311
      flatpak
      steam
      nftables
      discord
      heroic
      qbittorrent
      lutris
      obs-studio
      krita
      prismlauncher
      usbutils
      usb-modeswitch
      libreoffice
      go
      obsidian
      wget
      vim
      neovim
      yandex-music
      file
      man-pages
      man-pages-posix
      docker
      telegram-desktop
      fd
      python3Packages.pywal
      chromium
      imagemagick
      chafa
      ani-cli
      timg
      gitlab
      opencode
      claude-code
      st


      # --- Hyprland ecosystem ---
      waybar
      rofi
      hyprpaper
      hyprlock
      hypridle
      dunst
      grim
      slurp
      wl-clipboard
      pavucontrol
      networkmanagerapplet
      thunar
      polkit_gnome
      bibata-cursors
      waytrogen
      ufetch

      # --- nice-to-have ---
      awww
      wlogout
      brightnessctl
    ];
  };

  # --- SYSTEM PACKAGES ---
  environment.systemPackages = with pkgs; [
    xarchiver
    thunar-archive-plugin
    unzip
    p7zip
    unrar
    gamescope
  ];

  system.stateVersion = "26.05";
}
