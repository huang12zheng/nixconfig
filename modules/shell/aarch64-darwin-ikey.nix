{ username, lib, hostname, defaults, ... }:
let
  envExtra = ''
    export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"
  '';
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
  home-manager.users.${username} = {
    home = {
      shellAliases = {
        g = "git";
        gc = "git clone";
        l = "ls";
        ll = "ls -al";
        b = "bat";
        nix-gc = "sudo nix-collect-garbage -d";
        frb = "cd rust && cargo build --release && cd .. && flutter run --debug";
        nix-update = "sudo nix run nix-darwin -- switch --flake .#${hostname}";
        nix-push-build = "(nix build .#darwinConfigurations.${hostname}.system) && (cachix push macos-ikey $(nix path-info .#darwinConfigurations.${hostname}.system)  )";
        nix-push-inputs = "nix flake archive --json | jq -r '.path,(.inputs|to_entries[].value.path)' | cachix push macos-ikey";
      };
      # packages = with pkgs; [];
    };
    programs.bash = {
      enable = true;
    };
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings.user.name = defaults.fullname;
      settings.user.email = defaults.email;
      settings = {
        init.defaultBranch = "master";
        pull.rebase = false;
        credential.helper = "store --file ~/.git-credentials";
        alias = {
          co = "checkout";
          ci = "commit";
          cia = "commit --amend";
          s = "status";
          st = "status";
          b = "branch";
          pu = "push";
        };
      };
      includes = [{ path = "~/.config/git/extra.nix"; }];
      ignores = [ "*~" "*.swp" ];
    };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent = ''
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        ${envExtra}
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [
          "sudo"
          "web-search"
          "history-substring-search"
        ];
      };
      zplug = {
        enable = true;
        plugins = [
          {
            name = "romkatv/powerlevel10k";
            tags = ["as:theme" "depth:1"];
          }
          {
            name = "b4b4r07/enhancd";
          }
        ];
      };
    };

  };
}
