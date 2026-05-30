{ pkgs, cfg, lib, username,... }:

let
  useChinaMirror = true;
  inherit (cfg.cargo) CONFIG_REGISTRY;
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
      # LIBRARY_PATH = "${LIBRARY_PATH:+$LIBRARY_PATH:}:$(xcrun --show-sdk-path)/usr/lib";
      # binstalls 暂时禁用，网络连接问题
      binstalls = lib.strings.concatStringsSep " " [
        "flutter_rust_bridge_codegen"
        "cargo-insta"
        "cargo-cache"
        "cargo-component"
        "cargo-generate"
        "wit-bindgen-cli"
        #"cargo-clean-all"
      ];
    };

    home.file = lib.mkIf useChinaMirror {
      ".cargo/config.toml".text = ''
        [registries.crates-io]
        index = "${CONFIG_REGISTRY}"
        # 为什么加上就可以编译了?
        [target.aarch64-apple-darwin]
        rustflags = [ "-C", "link-arg=-undefined", "-C", "link-arg=dynamic_lookup", ]
      '';
    };
  };
}
