{cfg}:
let
  modulesDir = cfg.projectRoot + "/modules";
  channel = cfg.channel;

  listModules = builtins.readDir modulesDir;

  modulesList = builtins.map (moduleName:
        import "${toString modulesDir}/${moduleName}/${channel}.nix"
    ) (builtins.attrNames listModules)
  ;
in
  modulesList
