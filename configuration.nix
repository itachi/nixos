# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    cpu.intel.updateMicrocode = true;
    opengl.extraPackages = [ pkgs.vaapiIntel ];
    opengl.driSupport32Bit = true;
  };  

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "yuzu"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Allow non-free apps
  nixpkgs.config.allowUnfree = true; 
  
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    #dev/system
    tmux 
    git
    vscode
    nano
    python
    python36
    dep
    screen
    htop
    wget
    iotop
    bashCompletion

    #apps
    firefox
    gimp
    inkscape
    ncmpcpp
    screenfetch
    discord
    libreoffice
    handbrake
#    telegram

    #audio / video
    mpv
    scrot
    vlc
    imagemagick
  ];

 fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = false;
    fonts = [
       pkgs.terminus_font_ttf
       pkgs.tewi-font
       pkgs.kochi-substitute-naga10
       pkgs.source-code-pro
       pkgs.corefonts
       pkgs.inconsolata
       pkgs.liberation_ttf
       pkgs.dejavu_fonts
       pkgs.bakoma_ttf
       pkgs.gentium
       pkgs.ubuntu_font_family
       pkgs.terminus_font
       pkgs.fira-mono
       pkgs.ipafont
       pkgs.powerline-fonts
       pkgs.kochi-substitute
       pkgs.carlito
       pkgs.ttf_bitstream_vera
       pkgs.vistafonts
    ];
};


  # Parallel building.
  nix.buildCores = 4;
  nix.maxJobs = 2;

  # Polkit.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
           action.id == "org.freedesktop.udisks2.encrypted-unlock-system"
          ) &&
          subject.local && subject.active && subject.isInGroup("users")) {
              return polkit.Result.YES;
      }
    });
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  #hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.videoDrivers = [ "intel amdgpu" ];

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  users.extraUsers.kana = {
  name = "kana";
  group = "users";
  extraGroups = [
    "wheel" "disk" "audio" "video"
    "networkmanager" "systemd-journal"
  ];
  createHome = true;
  uid = 1000;
  home = "/home/kana";
  shell = "/run/current-system/sw/bin/bash";
};



  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
