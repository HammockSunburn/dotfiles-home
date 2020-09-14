#!/usr/bin/fish
# Possibly useful if you use Fedora, probably not useful otherwise.

sudo true
set -x dotfiles_dir (dirname (readlink -m (status --current-filename)))

mkdir -p "$HOME/.local/share/fonts/caskaydia"
if test ! -e "$HOME/.local/share/fonts/caskaydia/CascadiaCode.zip"
    wget -O "$HOME/.local/share/fonts/caskaydia/CascadiaCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip
    unzip -d "$HOME/.local/share/fonts/caskaydia" "$HOME/.local/share/fonts/caskaydia/CascadiaCode.zip"
    fc-cache -v
end

# Basic shell, editor, tmux configuration.
echo -n Basic shell, editor, tmux configuration...
mkdir -p "$HOME/.config"
rm -rf "$HOME/.config/fish"; and ln -s "$dotfiles_dir/config/fish" "$HOME/.config"
ln -sf "$dotfiles_dir/config/starship.toml" "$HOME/.config"
ln -sf "$dotfiles_dir/config/nvim" "$HOME/.config"
ln -sf "$dotfiles_dir/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$dotfiles_dir/tmux-gruvbox-dark.conf" "$HOME/.config"
ln -sf "$dotfiles_dir/config/bashtop" "$HOME/.config"
ln -sf "$dotfiles_dir/gitconfig" "$HOME/.gitconfig"
rm -rf "$HOME/.config/kitty"; and ln -s "$dotfiles_dir/config/kitty" "$HOME/.config"
rm -rf "$HOME/.config/broot"; and ln -s "$dotfiles_dir/config/broot" "$HOME/.config"
echo Done!

# VSCode
echo -n VSCode setup...
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo cp -f "$dotfiles_dir/vscode/vscode.repo" /etc/yum.repos.d/
mkdir -p "$HOME/.config/Code/User"
ln -sf "$dotfiles_dir/config/Code/User/settings.json" "$HOME/.config/Code/User"
ln -sf "$dotfiles_dir/config/Code/User/keybindings.json" "$HOME/.config/Code/User"
echo Done!

# Gnome
echo -n Gnome dconf...
dconf load /org/gnome/terminal/ < "$dotfiles_dir/gnome-terminal-prefs.dconf"
dconf load /org/gnome/desktop/wm/preferences/ < "$dotfiles_dir/gnome-wm-prefs.dconf"
echo Done!

# RPM Fusion
sudo dnf install -y \
         https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-(rpm -E %fedora).noarch.rpm \
         https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-(rpm -E %fedora).noarch.rpm

# RPMs
sudo dnf install -y \
         bashtop \
         bat \
         buildah \
         cc65 \
         clang \
         cmake \
         code \
         exa \
         fd-find \
         fish \
         fzf \
         gcc-c++ \
         gimp \
         gnome-tweaks \
         gnuplot \
         hyperfine \
         ImageMagick \
         kicad \
         kicad-doc \
         kitty \
         lxi-tools \
         make \
         musl-gcc \
         neovim \
         ninja-build \
         openssl-devel \
         prettyping \
         R \
         ripgrep \
         SDL2-devel \
         texlive \
         tealdeer \
         tmux-powerline \
         util-linux-user \
         valgrind \
         vlc

sudo dnf remove -y cascadia-code-fonts

# Starship in the Fedora repositories doesn't move fast enough.
sudo dnf remove -y starship

tldr --update

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
# It's a lot faster to do this as a single command rather than a for loop with a lot of
# invocations of 'code'.
set ie --install-extension
code --force \
    $ie "asabil.meson" \
    $ie "bungcip.better-toml" \
    $ie "DavidAnson.vscode-markdownlint" \
    $ie "eamodio.gitlens" \
    $ie "ecmel.vscode-html-css" \
    $ie "GitHub.vscode-pull-request-github" \
    $ie "Ikuyadeu.r" \
    $ie "jdinhlife.gruvbox" \
    $ie "matklad.rust-analyzer" \
    $ie "mrorz.language-gettext" \
    $ie "ms-vscode.cmake-tools" \
    $ie "ms-vscode.cpptools" \
    $ie "serayuzgur.crates" \
    $ie "twxs.cmake" \
    $ie "yzhang.markdown-all-in-one" \
    $ie "Zignd.html-css-class-completion"

# Setup rust
if test ! -d "$HOME/.cargo"
    echo Installing rustup...
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | /bin/bash -s -- -y
end

# Ensure rust is up-to-date
rustup toolchain install nightly stable

# Install certain rust programs from source. I install "nu" from source, too, but it always rebuilds even when
# there are no changes, so for now, I just do that by hand when I want to update it.
cargo install \
          broot \
          du-dust \
          git-delta \
          mdcat \
          procs \
          starship \
          tokei \
          xsv \
          zoxide

# Enable sshd service
sudo systemctl enable sshd.service
sudo systemctl start sshd.service

# Ensure I'm in the dialout and lock groups for Arduino.
sudo usermod -a -G dialout,lock (whoami)

# Update the locate db
sudo updatedb

