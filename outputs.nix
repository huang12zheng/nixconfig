{
  cfg, version, username, projectRoot, 
  nixpkgs,nixpkgs-darwin,nix-darwin,home-manager,agenix,nix-homebrew,
  ...
}@inputs:

let
  getModules = import ./lib/getModules.nix;
  modules = getModules {inherit cfg;};
in

let
  system = cfg.hostPlatform;
  inherit (cfg) hostPlatform;
  inherit (cfg.defaults) hostname fullname email;
  inherit (cfg.nix) version darwinVersion;

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
    # 这行很重要?
    specialArgs = {
      inherit inputs pkgs cfg username  projectRoot;
    };
    # 这个有问题?
    # specialArgs = {inherit inputs;};
    modules = [
      # 导入 home-manager 模块
      home-manager.darwinModules.home-manager
      
      { 
        home-manager.users.${username}.home.stateVersion = version;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        
        nixpkgs.hostPlatform = hostPlatform; 
        system.stateVersion = 6;
        users.users.${username} = {
          home = "/Users/${username}";
        };
      }
    ] ++ modules;
  };
}
