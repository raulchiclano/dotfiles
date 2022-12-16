# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{config, pkgs, ...}:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_ES.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.gnome = {
   extraGSettingsOverrides = ''
     # Change default background
     [org.gnome.desktop.background]
     picture-uri='file://${pkgs.nixos-artwork.wallpapers.mosaic-blue.gnomeFilePath}'

     # Favorite apps in gnome-shell
     [org.gnome.shell]
     favorite-apps=['org.gnome.Photos.desktop', 'org.gnome.Nautilus.desktop']
   '';

   extraGSettingsOverridePackages = [
     pkgs.gsettings-desktop-schemas # for org.gnome.desktop
     pkgs.gnome.gnome-shell # for org.gnome.shell
   ];
  }; 

  # Enable the Pantheon Desktop

  # programs.pantheon-tweaks.enable = true;
  # services.xserver.desktopManager.pantheon.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "es";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "es";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers=[pkgs.epson-escpr];
  # Set automatically find and configure wifi printer
  services.printing.browsing = true;
  services.printing.browsedConf = ''
  BrowseDNSSDSubTypes _cups,_print
  BrowseLocalProtocols all
  BrowseRemoteProtocols all
  CreateIPPPrinterQueues All

  BrowseProtocols all
      '';
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.raulchiclano = {
    isNormalUser = true;
    description = "raulchiclano";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox

    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    vscode
    tilix
    zsh
    gnome.gnome-disk-utility
    # pantheon-tweaks
    autoadb
    scrcpy
    git
    spotify
    zoom-us
    scrcpy
    vlc
    freeoffice
    whatsapp-for-linux
    bat
    lsd
    weylus
    zsh-powerlevel10k
    appeditor
    dbeaver
    droidcam
    #epson-inkjet-printer-escpr2-1.1.49
    kubectl
    kubecolor
    minikube
    neofetch
    pika-backup
    gnomeExtensions.pop-shell
    gnome.gnome-tweaks
    gnomeExtensions.appindicator
    wineWowPackages.stable
    wineWowPackages.waylandFull
    #gnomeExtensions.dash-to-dock
    # virtualbox
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
    networking.firewall.allowedTCPPorts = [5900];
  #  networking.firewall.allowedUDPPorts = [9001];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?


  # Mis configuraciones personales
  environment.shells = with pkgs; [ zsh ];

  # WEYLUS
  programs.weylus.openFirewall = true;
  programs.weylus.enable = true;
  programs.weylus.users = ["raulchiclano"];

  # ZSH
  programs.zsh.enable = true;
  users.users.raulchiclano.shell = pkgs.zsh;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.interactiveShellInit = ''

    # Personal aliases
   alias cat="bat"
   alias ls="lsd"
   alias k ="kubectl"

    # Customize your oh-my-zsh options here
   export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
   plugins=(git sudo )
   source $ZSH/oh-my-zsh.sh
  
  '';

  programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

#  environment.shellAliases = { ls = "lsd"; switch = "sudo nixos-rebuild switch"; boot = "sudo nixos-rebuild boot"; test = "sudo nixos-rebuild test"; };


  #V4L2LOOPBACK KERNEL MODULE FOR DROIDCAM  
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback
  ];
  boot.kernelModules = [ "v4l2loopback" ];  
  
  # Enable Flatpak services
  services.flatpak.enable = true;
  # Solo para Pantheon
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Install Virtualbox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "raulchiclano" ];
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.virtualbox.guest.x11 = true;

  # Install Docker
  virtualisation.docker.enable = true;
 
  # /etc/hosts
  networking.extraHosts=
    ''
     127.0.0.1:8888 miweb.com
    '';





}
