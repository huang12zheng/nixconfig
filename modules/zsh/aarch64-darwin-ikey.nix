{username, ...}: 
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
  home-manager.users.${username}.programs.zsh = {
    # enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
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
        # {
        #   name = "romkatv/powerlevel10k";
        #   tags = ["as:theme" "depth:1"];
        # }
        {
          name = "b4b4r07/enhancd";
        }
      ];
    };
  };
}
