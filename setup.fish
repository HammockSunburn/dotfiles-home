# Possibly useful if you use Fedora, probably not useful otherwise.

sudo true
set -x dotfiles_dir (dirname (readlink -m (status --current-filename)))

# Basic shell, editor, tmux configuration.
echo -n Basic shell, editor, tmux configuration...
mkdir -p "$HOME/.config"
rm -rf "$HOME/.config/fish"; and ln -s "$dotfiles_dir/config/fish" "$HOME/.config"
ln -sf "$dotfiles_dir/config/starship.toml" "$HOME/.config"
ln -sf "$dotfiles_dir/config/nvim" "$HOME/.config"
ln -sf "$dotfiles_dir/tmux.conf" "$HOME/.config"
ln -sf "$dotfiles_dir/tmux-gruvbox-dark.conf" "$HOME/.config"
ln -sf "$dotfiles_dir/config/bashtop" "$HOME/.config"
echo Done!

# VSCode
echo -n VSCode setup...
sudo rpm --quiet --import https://packages.microsoft.com/keys/microsoft.asc
sudo cp -f "$dotfiles_dir/vscode/vscode.repo" /etc/yum.repos.d/
mkdir -p "$HOME/.config/Code/User"
ln -sf "$dotfiles_dir/config/Code/settings.json" "$HOME/.config/Code/User"
echo Done!

# Gnome
echo -n Gnome dconf...
dconf load /org/gnome/terminal/ < "$dotfiles_dir/gnome-terminal-prefs.dconf"
dconf load /org/gnome/desktop/wm/preferences/ < "$dotfiles_dir/gnome-wm-prefs.dconf"
echo Done!

# RPM Fusion
sudo dnf -q install \
         https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-(rpm -E %fedora).noarch.rpm \
         https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-(rpm -E %fedora).noarch.rpm

# RPMs
sudo dnf install -y \
         bashtop \
         bat \
         buildah \
         cascadia-code-fonts \
         cc65 \
         clang \
         cmake \
         code \
         exa \
         fd-find \
         fish \
         fzf \
         gcc-c++ \
         gnome-tweaks \
         make \
         musl-gcc \
         neovim \
         ninja-build \
         openssl-devel \
         ripgrep \
         SDL2-devel \
         starship \
         texlive \
         tmux-powerline \
         util-linux-user \
         vlc

# Bat theme configuration
mkdir -p (bat --config-dir)/themes
ln -sf $dotfiles_dir/gruvbox.tmTheme (bat --config-dir)/themes
bat cache --build

# Change shell if necessary
chsh -s /usr/bin/fish

# Setup vim-plug
if test ! -e "$HOME/.local/share/nvim/site/autoload/plug.vim"
    echo Installing vim-plug and getting plugins...
    curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" \
        --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    nvim +PlugInstall +qall 
else
    nvim --headless +PlugClean +qall
end

# Install VS Code extensions
for ext in \
    "DavidAnson.vscode-markdownlint" \
    "GitHub.vscode-pull-request-github" \
    "Zignd.html-css-class-completion" \
    "asabil.meson" \
    "bungcip.better-toml" \
    "eamodio.gitlens" \
    "ecmel.vscode-html-css" \
    "jdinhlife.gruvbox" \
    "matklad.rust-analyzer" \
    "mrorz.language-gettext" \
    "ms-vscode.cmake-tools" \
    "ms-vscode.cpptools" \
    "twxs.cmake" \
    "yzhang.markdown-all-in-one"
    code --install-extension "$ext"
end

# Setup rust
if test ! -d "$HOME/.cargo"
    echo Installing rustup...
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | /bin/bash -s -- -y
end

# Install certain rust programs from source
cargo install \
          du-dust \
          procs \
          tokei \
          xsv

# Enable sshd service
sudo systemctl enable sshd.service
sudo systemctl start sshd.service

# Update the locate db
sudo updatedb

