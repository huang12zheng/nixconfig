let
  cfg = import ./config.nix;
  version = cfg.nix.version;
  username = cfg.defaults.username;
  hostname = cfg.defaults.hostname;
  projectRoot = cfg.projectRoot;
in
{
  description = "huang12zheng/macos-nix — macOS nix-darwin configuration";

  outputs = inputs:
    import ./outputs (inputs // { inherit cfg version username projectRoot; });

  nixConfig = {
    extra-substituters = cfg.nix.substituters;
    extra-trusted-public-keys = cfg.nix.trustedPublicKeys;
  };

  inputs = {
    # nixpkgs.url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-${version}/nixexprs.tar.xz";
    nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-${version}/nixexprs.tar.xz";
    # nix-darwin 本身不提供独立二进制缓存，其依赖的软件包全部来自 Nixpkgs 通用仓库。
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-${version}-darwin";

    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-unstable/nixexprs.tar.xz";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    flake-parts.url = "github:hercules-ci/flake-parts";
    
    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-${version}";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-${version}";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    # Optional: Declarative tap management
    # 使用 USTC 镜像加速，shallow=1 避免克隆完整历史（homebrew-core 仓库极大）
    homebrew-core = {
      url = "git+https://mirrors.ustc.edu.cn/homebrew-core.git?shallow=1";
      flake = false;
    };
    homebrew-cask = {
      url = "git+https://mirrors.ustc.edu.cn/homebrew-cask.git?shallow=1";
      flake = false;
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
