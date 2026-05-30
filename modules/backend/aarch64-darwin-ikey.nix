{ pkgs, lib, username,... }:

let
  useChinaMirror = true;
in {
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      rustup
      cargo-binstall
      cargo-insta
      rust-cbindgen
      gcc-unwrapped
      sccache
    ];

    home.sessionPath = [ "$HOME/.cargo/bin" ];

    home.sessionVariables = {
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      RUSTC_WRAPPER = lib.getExe pkgs.sccache;
      RUSTC_LINKER = "${pkgs.llvmPackages.clangUseLLVM}/bin/clang";
      GCC_LIB = "${pkgs.gcc-unwrapped.lib}/lib";
      OSO_URL = "http://localhost:3000";
      OSO_AUTH = "e_0123456789_12345_osotesttoken01xiIn";
      binstalls = lib.strings.concatStringsSep " " [
        "flutter_rust_bridge_codegen"
        "cargo-insta"
        "cargo-cache"
        #"rust"
        "cargo-component"
        "twiggy"
        "cargo-generate"
        "cargo-clean-all"
        "wit-bindgen-cli"
      ];
    };

    home.file = lib.mkIf useChinaMirror {
      ".cargo/config.toml".text = ''
        [registries.crates-io]
        index = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"
      '';
    };
  };
}
