{ cfg }:
let
  modulesDir = cfg.projectRoot + "/modules";
  channel = cfg.channel;

  listModules = builtins.readDir modulesDir;

  # 安全地导入模块
  importModule = moduleName:
    let
      modulePath = "${toString modulesDir}/${moduleName}/${channel}.nix";
      entryType = builtins.getAttr moduleName listModules;
    in
    # 检查：是否为目录
    if entryType != "directory"
    then null
    # 检查：对应的 channel 文件是否存在
    else if !builtins.pathExists modulePath
    then null
    # 安全导入
    else import modulePath;

  modulesList = builtins.filter (m: m != null) (
    builtins.map importModule (builtins.attrNames listModules)
  );
in
modulesList
