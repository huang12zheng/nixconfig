{
  inputs,
  cfg,
  pkgs,
  agenix,
  username,
  hostname,
  projectRoot,
  ...
}: 
{
  imports = [
    agenix.darwinModules.default
  ];

  environment.systemPackages = [
    agenix.packages.${pkgs.system}.default
  ];

  # Use your user SSH key for decryption
  age.identityPaths = [
    "/Users/${username}/.ssh/id_ed25519"
  ];

  # Define secrets - will be decrypted to /run/agenix/
  age.secrets = {
    "github_token" = {
      file =  "${projectRoot}/secrets/github_token.age";
      mode = "0600";
      owner = username;
    };
    "cachix_auth_hzgood" = {
      file = "${projectRoot}/secrets/cachix_auth_hzgood.age";
      mode = "0600";
      owner = username;
    };
  };

  # Set system-wide environment variables for GUI apps
  launchd.user.agents.set-secrets-env = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "launchctl setenv GITHUB_TOKEN $(cat /run/agenix/github_token); launchctl setenv CACHIX_AUTH_TOKEN $(cat /run/agenix/cachix_auth_hzgood)"
      ];
      RunAtLoad = true;
    };
  };

  # Set zsh environment variables for terminal (import from launchd)
  home-manager.users.${username}.programs.zsh.initContent = ''
    [[ -n $GITHUB_TOKEN ]] || export GITHUB_TOKEN=$(launchctl getenv GITHUB_TOKEN)
    [[ -n $CACHIX_AUTH_TOKEN ]] || export CACHIX_AUTH_TOKEN=$(launchctl getenv CACHIX_AUTH_TOKEN)
  '';
}
