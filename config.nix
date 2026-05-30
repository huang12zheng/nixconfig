# Single source of truth (flake input `iconfig`).
{
  defaults = {
    hostname = "darwin-ikey";
    username = "hzgood";
    fullname = "huangzheng";
    email = "805104533@qq.com";
    sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWX8SY0dI7YMifCWwU+eLpuJkI0OrC8W2GOExiOGmnF hzgood@nixos";
    sshAuthorizedKeys = [];
    networking = {
      ssh.extraConfig = "";
    };
  };
  system = "aarch64";
  hostPlatform = "aarch64-darwin";
  channel = "aarch64-darwin-ikey";

  projectRoot = ./.;

  repo = {
    owner = "huang12zheng";
    name = "nix-config";
  };

  nix = {
    substituters = [
      "https://macos-ikey.cachix.org"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
    trustedPublicKeys = [
      "macos-ikey.cachix.org-1:PFyh88wlNZ0aJLcSIqVtZ3D+6XyJtKaR0kLYPRHvsMo="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    version = "25.11";
    darwinVersion = "6";
  };

  homebrew = {
    mirrors = {
      HOMEBREW_API_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
      HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
      HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
      HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
      HOMEBREW_PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";
    };
  };
  flutter = {
    FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn";
    PUB_HOSTED_URL = "https://pub.flutter-io.cn";
  };
  cargo = {
    CONFIG_REGISTRY = "https://mirrors.ustc.edu.cn/crates.io-index";
  };
  pods = {};

  clash = {
    isMinimalConfig = true;
    proxyPort = 7890;
  };
  isCli = (builtins.getEnv "DISPLAY") == "";
  isGui = (builtins.getEnv "DISPLAY") != "";
  isNixOnDroid = (builtins.getEnv "USER") == "nix-on-droid";
  isWSL2 = (builtins.getEnv "WSL_DISTRO_NAME") != "";
  isDarwin = (builtins.currentSystem) == "aarch64-darwin";
}
