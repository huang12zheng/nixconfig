{pkgs, inputs,cfg, username, ...}: 
let defaults = cfg.defaults;
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
  
  environment.shells = [pkgs.zsh];
  
  environment.systemPackages = with pkgs; [
    wget
    tree
    age
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.devenv
    cachix
  ];
  # Homebrew mirror environment variables
  environment.variables = cfg.mirrors or {};
  environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";

  # Align homebrew taps with nix-homebrew
  homebrew = {
    enable = lib.mkDefault true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = cfg.brews or [];
    casks = cfg.casks or [];
    masApps = cfg.masApps or {};
  };

  home.packages = with pkgs; [
    just
    nixpkgs-fmt
    direnv
    asciinema
  ];

  nix-homebrew = {
    enable = true;
    # User owning the Homebrew prefix
    user = username;
    # Declarative tap management
    taps = {
      "homebrew/homebrew-core" = cfg.homebrew-core;
      "homebrew/homebrew-cask" = cfg.homebrew-cask;
    };
    # With mutableTaps disabled, taps can only be changed via nix config
    mutableTaps = false;
  };

  programs = {
    bat.enable = true;
    fzf.enable = true;
    zoxide.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
  };

  
}
