{
  pkgs,
  lib,
  username,
  ...
}:

let
  # 镜像源切换: true = 国内源, false = 国际源
  # 注释掉下一行即可切换为国际源
  useChinaMirror = true;

  pinnedJDK = pkgs.jdk17;
  clang_path = pkgs.llvmPackages.libclang.lib;
in {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      just
      clang
      clang_path
      # protobuf
      cmake
      ninja
      pkg-config
      gtk3
      pinnedJDK
      flutter
      openssl
      gcc-unwrapped
    ];

    home.sessionVariables = {
      JAVA_HOME = pinnedJDK;
      CHROME_EXECUTABLE = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome";
      LIBCLANG_PATH = "${clang_path}/lib";
      OPENSSL_DIR = "${pkgs.openssl.out}";
      OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
      OPENSSL_NO_VENDOR = 1;
      OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
      PKG_CONFIG_PATH = "${pkgs.pkg-config.out}";
    } // lib.optionalAttrs useChinaMirror {
      # Flutter SDK 下载镜像
      FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn";
      # Dart Pub 包镜像
      PUB_HOSTED_URL = "https://pub.flutter-io.cn";
    };

    home.sessionPath = lib.mkAfter [
      "$HOME/Gist/alias_command"
      "$HOME/.local/bin"
    ];

    # CocoaPods 镜像自动切换 - 使用 home.file 而不是 activation
    home.file = lib.optionalAttrs useChinaMirror {
      ".cocoapods/repos/tuna".text = ''
        repo "https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git"
      '';
    };
  };
}
