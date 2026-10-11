# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
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
  # Required to load the proprietary NVIDIA kernel module.
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  
  hardware.nvidia = {
    # KMS (Kernel Mode Setting) — REQUIRED for Wayland/Hyprland to work.
    # Without this, Hyprland will fail to start or show a black screen.
    modesetting.enable = true;

    # Pascal (GTX 10xx) does NOT support the open-source kernel module.
    # The open module is only for Turing (RTX 20xx) and newer.
    open = false;
   
    branch = "legacy_580";

    # Power management — harmless on desktop, useful if you ever move to laptop.
    powerManagement.enable = false;
  };

  # Force NVIDIA to use its own GBM/EGL implementations.
  # Needed for Hyprland on NVIDIA to render correctly.
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Makes Electron apps (Discord, VS Code, etc.) run natively on Wayland.
    NIXOS_OZONE_WL = "1";
  };

  # ---------------------------------------------------------------------------
  # DISPLAY MANAGER + DESKTOPS
  # ---------------------------------------------------------------------------
  # X11 is kept enabled because XFCE depends on it and it's a safe fallback.
  services.xserver.enable = true;

  # LightDM will let you choose between XFCE and Hyprland at login screen.
  services.xserver.displayManager.lightdm.enable = true;

  # XFCE kept as a FALLBACK desktop.
  # If Hyprland ever breaks, you can still log in and fix things.
  # You can remove this later once Hyprland is stable for you.
  services.xserver.desktopManager.xfce.enable = true;

  # Keyboard layout for X11 (XFCE). Hyprland uses its own config.
  services.xserver.xkb = {
    layout = "ru";
    variant = "";
  };

  # ---------------------------------------------------------------------------
  # HYPRLAND
  # ---------------------------------------------------------------------------
  # This installs Hyprland and registers a session in LightDM.
  programs.hyprland = {
    enable = true;
    # XWayland lets you run old X11 apps (Steam, some games, etc.) inside Hyprland.
    xwayland.enable = true;
  };

  # ---------------------------------------------------------------------------
  # AUDIO
  # ---------------------------------------------------------------------------
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  documentation.doc.enable = false;

  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ---------------------------------------------------------------------------
  # USER ACCOUNT
  # ---------------------------------------------------------------------------
    # флатпак для майнкравта и прочего
    services.flatpak.enable = true;
    programs.nix-ld.enable = true;
   
    environment.variables = {
  	NIX_LD = "/run/current-system/sw/share/nix-ld/lib/ld.so";
  	NIX_LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";
    };

    users.users."umka" = {
    isNormalUser = true;
    description = "umka";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # --- your existing personal CLI/TUI apps ---
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
      libreoffice
      go
      obsidian
      wget
      vim
      neovim
      yandex-music
      file

 
      # --- Hyprland ecosystem ---
      waybar             # status bar
      rofi               # app launcher
      hyprpaper          # wallpaper daemon
      hyprlock           # lock screen
      hypridle           # idle daemon (screen dim / lock / suspend)
      dunst              # notification daemon
      grim               # screenshot tool
      slurp              # region selector for grim
      wl-clipboard       # wl-copy / wl-paste
      pavucontrol        # GUI volume control
      networkmanagerapplet # nm-applet for tray
      thunar             # lightweight file manager
      polkit_gnome       # polkit agent (needed for GUI auth prompts)
      bibata-cursors
      waytrogen
      ufetch

      # --- nice-to-have ---
      awww               # animated wallpapers (alternative to hyprpaper)
      wlogout            # logout menu
      brightnessctl      # brightness control
    ];
  };
   
  #---GAMING---
  programs.steam = {
  	enable = true;
   
  };


  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages (NVIDIA drivers, Steam, etc. need this).
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # environment.systemPackages = with pkgs; [
  #   vim
  #   wget
  # ];

  # This option defines the first version of NixOS you have installed on this particular machine.
  # Do NOT change this value unless you know what you're doing.
  system.stateVersion = "26.05";
}
