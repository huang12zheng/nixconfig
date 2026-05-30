ip="192.168.1.204"
xcode-select --install
scp -r hzgood@${ip}:~/.ssh/id_ed25519 ~/.ssh/
scp -r hzgood@${ip}:~/.ssh/id_ed25519.pub ~/.ssh/
cp ./.p10k.zsh ~/

# brew install age
git config --global user.name "hzgood"
git config --global user.email "805104533@qq.com"
sh ./scripts/bootstrap-macos.sh
# nix-darwin 首次安装需要手动运行
sudo nix run nix-darwin -- switch --flake .#darwin-ikey
# nix-update
# nix run nixpkgs#age --  -R ~/.ssh/id_ed25519.pub -o ./gh_token.age ./gh_token # -R is for openssh public key
#INSTALL clash-verge-rev #wget https://github.com/Dreamacro/clash-verge/releases/download/v2.12.1/Clash.Verge-2.12.1-macos-arm64.dmg
mkdir -p ~/Library/Android/sdk
# sdkmanager "platform-tools" "platforms;android-37.0" "build-tools;37.0.0" "cmdline-tools;latest"
# 