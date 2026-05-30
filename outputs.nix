{
  cfg,
  version,
  username,
  projectRoot,
  nixpkgs,
  nixpkgs-darwin,
  nix-darwin,
  home-manager,
  agenix,
  nix-homebrew,
  ...
}@inputs:

let
  getModules = import ./lib/getModules.nix;
  modules = getModules { inherit cfg; };
in

let
  system = cfg.hostPlatform;
  inherit (cfg) hostPlatform;
  inherit (cfg.defaults) hostname;

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    android_sdk.accept_license = true;
  };

  lib = nixpkgs.lib;
in
{
  darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs pkgs cfg username hostname projectRoot lib agenix home-manager;
      defaults = cfg.defaults;
      darwinState = cfg.nix.darwinVersion;
    };
    modules = [
      # 导入 home-manager 模块
      home-manager.darwinModules.home-manager

      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = {
          home.stateVersion = version;
        };
        nix.enable = false;
        nixpkgs.hostPlatform = hostPlatform;
        system.stateVersion = 6;
        users.users.${username} = {
          home = "/Users/${username}";
        };
      }
    ] ++ modules;
  };
}
