# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  user,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  networking.proxy.allProxy = "http://192.168.49.1:8282/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = user;
    extraGroups = ["networkmanager" "wheel" "audio" "vboxusers"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #shell
  # zsh
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  programs.zsh.ohMyZsh.theme = "fishy";
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.autosuggestions.enable = true;

  # file system
  fileSystems."/drives/freeze" = {
    device = "/dev/disk/by-uuid/F21C2B081C2AC805";
    fsType = "ntfs-3g";
  };

  # sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;

  # display manager
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  # hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  #env var
  environment.sessionVariables = {
    WLR_MO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  hardware.opengl.enable = true;
  # flakes

  nix.settings.experimental-features = ["nix-command" "flakes"];

  #vbox
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    neovim
    emacs
    kitty
    swww
    rofi
    mako
    firefox
    discord
    curl
    gcc
    python311
    ripgrep
    bashmount
    xfce.thunar
    wineWowPackages.wayland
    proxychains
    networkmanagerapplet
    pfetch
    multimarkdown
    fd
    shellcheck
    ranger
    feh
    waybar
    cmus
    grim
    zip
    unzip
    cava
    git
    pavucontrol
    vlc
    nodejs
    ffmpeg
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # waybar
  nixpkgs = {
    overlays = [
      (self: super: {
        waybar = super.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true" "-Dmpd=enabled"];
        });
      })
    ];
  };

  # fonts
  fonts.fonts = with pkgs; [
    nerdfonts
    jetbrains-mono
    fira-code
    dejavu_fonts
    fira-code-symbols
    weather-icons
    material-design-icons
    emacsPackages.fontawesome
    emacsPackages.octicons
    emacs-all-the-icons-fonts
  ];
}
