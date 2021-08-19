#!/bin/bash
# Possibly useful if you use Fedora, probably not useful otherwise.

set -e
sudo true
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $DOTFILES_DIR

mkdir -p \
      "$HOME/.config" \
      "$HOME/.config/i3" \
      "$HOME/.emacs.d" \
      "$HOME/.doom.d" \
      "$HOME/.config/ncmpcpp" \
      "$HOME/.config/mpd" \
      "$HOME/mpd"

rm -rf "$HOME/.config/fish"
ln -s "$DOTFILES_DIR/config/fish" "$HOME/.config"
ln -sf "$DOTFILES_DIR/config/starship.toml" "$HOME/.config"
ln -sf "$DOTFILES_DIR/config/nvim" "$HOME/.config"
ln -sf "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/abcde.conf" "$HOME/.abcde.conf"
ln -sf "$DOTFILES_DIR/tmux-gruvbox-dark.conf" "$HOME/.config"
ln -sf "$DOTFILES_DIR/config/bashtop" "$HOME/.config"
ln -sf "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/config/i3/config" "$HOME/.config/i3/config"
rm -f "$HOME/.config/i3status-rust"
ln -sf "$DOTFILES_DIR/config/i3status-rust" "$HOME/.config/i3status-rust"
ln -sf "$DOTFILES_DIR/config/mpd/mpd.conf" "$HOME/.config/mpd/"
ln -sf "$DOTFILES_DIR/config/ncmpcpp/config" "$HOME/.config/ncmpcpp"
ln -sf "$DOTFILES_DIR/emacs/doom-emacs/config.el" "$HOME/.doom.d"
ln -sf "$DOTFILES_DIR/emacs/doom-emacs/custom.el" "$HOME/.doom.d"
ln -sf "$DOTFILES_DIR/emacs/doom-emacs/init.el" "$HOME/.doom.d"
ln -sf "$DOTFILES_DIR/emacs/doom-emacs/packages.el" "$HOME/.doom.d"
rm -rf "$HOME/.config/kitty"
ln -s "$DOTFILES_DIR/config/kitty" "$HOME/.config"
rm -rf "$HOME/.config/broot"
ln -s "$DOTFILES_DIR/config/broot" "$HOME/.config"
mkdir -p "$HOME/.ssh"
chmod o-rwx,g-rwx "$HOME/.ssh"

mkdir -p "$HOME/.local/share/fonts/caskaydia"
if test ! -e "$HOME/.local/share/fonts/caskaydia/CascadiaCode.zip"; then
    wget -O "$HOME/.local/share/fonts/caskaydia/CascadiaCode.zip" \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip"
    unzip -d "$HOME/.local/share/fonts/caskaydia" "$HOME/.local/share/fonts/caskaydia/CascadiaCode.zip"
    fc-cache -v
fi

# VSCode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo cp -f "$DOTFILES_DIR/vscode/vscode.repo" /etc/yum.repos.d/
mkdir -p "$HOME/.config/Code/User"
ln -sf "$DOTFILES_DIR/config/Code/User/settings.json" "$HOME/.config/Code/User"
ln -sf "$DOTFILES_DIR/config/Code/User/keybindings.json" "$HOME/.config/Code/User"

# RPM Fusion
FEDORA_VERSION=`rpm -E %fedora`
sudo dnf install -y \
         https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$FEDORA_VERSION".noarch.rpm \
         https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$FEDORA_VERSION".noarch.rpm

sudo dnf install -y \
    ImageMagick \
    PEGTL-devel \
    R \
    SDL2-devel \
    SDL2_image-devel \
    SDL2_ttf-devel \
    abcde \
    ansible \
    bat \
    boost-devel \
    bpytop \
    buildah \
    catch-devel \
    cc65 \
    clang \
    clang-tools-extra \
    cmake \
    code \
    dbus-devel \
    emacs \
    emacs-auctex \
    exa \
    fd-find \
    fish \
    fmt-devel \
    fontawesome-fonts \
    fzf \
    gcc-c++ \
    ghc-compiler \
    gimp \
    gnome-tweaks \
    gnuplot \
    gtk4 \
    gtk4-devel \
    hyperfine \
    i3 \
    info \
    kicad \
    kicad-doc \
    kitty \
    lame \
    libXaw-devel \
    libXdmcp-devel \
    libXres-devel \
    libXScrnSaver-devel \
    libXvMC-devel \
    libXv-devel \
    libXxf86vm-devel \
    libcurl-devel \
    libfontenc-devel \
    libheif \
    libnsl \
    libzstd-devel \
    lnav \
    lxi-tools \
    make \
    meson \
    minicom \
    mpd \
    mpdris2 \
    musl-gcc \
    ncmpcpp \
    neovim \
    ninja-build \
    openssl-devel \
    perl-FindBin \
    perl-Image-ExifTool \
    playerctl \
    prettyping \
    pv \
    python3-devel \
    python3-eyed3 \
    python3-virtualenv \
    ripgrep \
    tbb-devel \
    tealdeer \
    texlive \
    tmux-powerline \
    util-linux-user \
    valgrind \
    vlc \
    weechat \
    xcb-util-image-devel \
    xcb-util-renderutil-devel \
    xcb-util-wm-devel \
    xorg-x11-xtrans-devel \
    youtube-dl

tldr --update

# Bat theme configuration
mkdir -p `bat --config-dir`/themes
ln -sf "$DOTFILES_DIR"/gruvbox.tmTheme `bat --config-dir`/themes
bat cache --build

# Gnome
echo -n Gnome dconf...
dconf load /org/gnome/terminal/ < "$DOTFILES_DIR/gnome-terminal-prefs.dconf"
dconf load /org/gnome/desktop/wm/preferences/ < "$DOTFILES_DIR/gnome-wm-prefs.dconf"
dconf load /org/gnome/desktop/session/ < "$DOTFILES_DIR/gnome-session-prefs.dconf"
dconf load /org/gnome/settings-daemon/plugins/power/ < "$DOTFILES_DIR/gnome-power-prefs.dconf"
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
echo Done!

# Doom Emacs
systemctl --user enable emacs
systemctl --user restart emacs

if test ! -e "$HOME/.emacs.d/bin/doom"; then
    mv "$HOME/.emacs.d" "$HOME/.emacs.d.old"

    git clone --depth 1 https://github.com/hlissner/doom-emacs "$HOME/.emacs.d"
    "$HOME/.emacs.d/bin/doom" -y install
else
    "$HOME/.emacs.d/bin/doom" upgrade
fi

# neovim
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/config/nvim" "$HOME/.config"

# Setup vim-plug
if test ! -e "$HOME/.local/share/nvim/site/autoload/plug.vim"; then
    echo Installing vim-plug and getting plugins...
    curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" \
        --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    nvim +PlugInstall +qall 
else
    nvim --headless +PlugClean +qall
fi

# Install VS Code extensions
# It's a lot faster to do this as a single command rather than a for loop with a lot of
# invocations of 'code'.
code --force \
    --install-extension "asabil.meson" \
    --install-extension "bungcip.better-toml" \
    --install-extension "DavidAnson.vscode-markdownlint" \
    --install-extension "eamodio.gitlens" \
    --install-extension "ecmel.vscode-html-css" \
    --install-extension "GitHub.vscode-pull-request-github" \
    --install-extension "Ikuyadeu.r" \
    --install-extension "jdinhlife.gruvbox" \
    --install-extension "matklad.rust-analyzer" \
    --install-extension "mrorz.language-gettext" \
    --install-extension "ms-vscode.cmake-tools" \
    --install-extension "ms-vscode.cpptools" \
    --install-extension "serayuzgur.crates" \
    --install-extension "twxs.cmake" \
    --install-extension "yzhang.markdown-all-in-one" \
    --install-extension "Zignd.html-css-class-completion"

# Setup rust
if test ! -d "$HOME/.cargo"; then
    echo Installing rustup...
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | /bin/bash -s -- -y
    source $HOME/.cargo/env
fi

# Ensure rust is up-to-date
$HOME/.cargo/bin/rustup toolchain install nightly stable

$HOME/.cargo/bin/cargo install \
          broot \
          du-dust \
          git-delta \
          mdcat \
          procs \
          starship \
          tokei \
          xsv \
          zoxide

$HOME/.cargo/bin/cargo install \
    --git https://github.com/greshake/i3status-rust i3status-rs

# Stack
if test ! -d "$HOME/.ghcup"; then
    curl -sSL https://get.haskellstack.org/ | sh
fi

$HOME/.ghcup/bin/stack upgrade
$HOME/.ghcup/bin/stack install hindent
$HOME/.ghcup/bin/stack install hoogle

# Enable sshd service
sudo systemctl enable sshd.service
sudo systemctl start sshd.service
systemctl --user enable mpd
systemctl --user start mpd
systemctl --user enable mpDris2
systemctl --user start mpDris2

# Setup email and name for this repository.
cd "$DOTFILES_DIR"
git config user.name "Hammock Sunburn"
git config user.email "hammocksunburn@gmail.com"

# Ensure I'm in the dialout and lock groups for Arduino.
sudo usermod -a -G dialout,lock `whoami`

# Update the locate db
sudo updatedb

# Change shell if necessary
chsh -s /usr/bin/fish
