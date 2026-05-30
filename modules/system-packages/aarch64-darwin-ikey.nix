{inputs,pkgs, lib, cfg, username, defaults ,...}: 
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
  environment.etc."nix/inputs/nixpkgs".source = "${pkgs}";

  # Align homebrew taps with nix-homebrew
  homebrew = {
    enable = lib.mkDefault true;
    taps = []; # 从 cfg.nix-homebrew.taps 改为空列表，因为 config.nix 中没有这个配置
    brews = cfg.brews or [];
    casks = cfg.casks or [];
    masApps = cfg.masApps or {};
  };

  nix-homebrew = {
    enable = true;
    # User owning the Homebrew prefix
    user = username;
    # Declarative tap management
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    # With mutableTaps disabled, taps can only be changed via nix config
    mutableTaps = false;
  };
  home-manager.users.${username} = {
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
    home.packages = with pkgs; [
      just
      nixpkgs-fmt
      direnv
      asciinema
    ];
  };

  
}
