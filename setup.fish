#!/usr/bin/fish
# Possibly useful if you use Fedora, probably not useful otherwise.

sudo true
set -x dotfiles_dir (dirname (readlink -m (status --current-filename)))

mkdir -p "$HOME/.local/share/fonts/caskaydia"
if test ! -e "$HOME/.local/share/fonts/caskaydia/CascadiaCode.zip"
    wget -O "$HOME/.local/share/fonts/caskaydia/CascadiaCode.zip" \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip"
    unzip -d "$HOME/.local/share/fonts/caskaydia" "$HOME/.local/share/fonts/caskaydia/CascadiaCode.zip"
    fc-cache -v
end

# Basic shell, editor, tmux configuration.
echo -n Basic shell, editor, tmux configuration...
mkdir -p "$HOME/.config" "$HOME/.config/i3" "$HOME/.emacs.d" "$HOME/.doom.d" "$HOME/.config/ncmpcpp" "$HOME/.config/mpd"
rm -rf "$HOME/.config/fish"; and ln -s "$dotfiles_dir/config/fish" "$HOME/.config"
ln -sf "$dotfiles_dir/config/starship.toml" "$HOME/.config"
ln -sf "$dotfiles_dir/config/nvim" "$HOME/.config"
ln -sf "$dotfiles_dir/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$dotfiles_dir/abcde.conf" "$HOME/.abcde.conf"
ln -sf "$dotfiles_dir/tmux-gruvbox-dark.conf" "$HOME/.config"
ln -sf "$dotfiles_dir/config/bashtop" "$HOME/.config"
ln -sf "$dotfiles_dir/gitconfig" "$HOME/.gitconfig"
ln -sf "$dotfiles_dir/config/i3/config" "$HOME/.config/i3/config"
ln -sf "$dotfiles_dir/config/mpd/mpd.conf" "$HOME/.config/mpd/"
ln -sf "$dotfiles_dir/config/ncmpcpp/config" "$HOME/.config/ncmpcpp"
ln -sf "$dotfiles_dir/emacs/init.el" "$HOME/.emacs.d"
ln -sf "$dotfiles_dir/emacs/doom-emacs/config.el" "$HOME/.doom.d"
ln -sf "$dotfiles_dir/emacs/doom-emacs/custom.el" "$HOME/.doom.d"
ln -sf "$dotfiles_dir/emacs/doom-emacs/init.el" "$HOME/.doom.d"
ln -sf "$dotfiles_dir/emacs/doom-emacs/packages.el" "$HOME/.doom.d"
ln -sf "$dotfiles_dir/emacs/spacemacs/spacemacs" "$HOME/.spacemacs"
ln -sf "$dotfiles_dir/emacs/emacs-profiles.el" "$HOME/.emacs-profiles.el"
rm -rf "$HOME/.config/kitty"; and ln -s "$dotfiles_dir/config/kitty" "$HOME/.config"
rm -rf "$HOME/.config/broot"; and ln -s "$dotfiles_dir/config/broot" "$HOME/.config"
mkdir -p "$HOME/.ssh"
chmod o-rwx,g-rwx "$HOME/.ssh"
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
dconf load /org/gnome/desktop/session/ < "$dotfiles_dir/gnome-session-prefs.dconf"
dconf load /org/gnome/settings-daemon/plugins/power/ < "$dotfiles_dir/gnome-power-prefs.dconf"
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
echo Done!

# RPM Fusion
sudo dnf install -y \
         https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-(rpm -E %fedora).noarch.rpm \
         https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-(rpm -E %fedora).noarch.rpm

# RPMs
# Starship in the Fedora repositories doesn't move fast enough.
sudo dnf remove -q -y tldr cascadia-code-fonts starship

sudo dnf install -y \
    ImageMagick \
    PEGTL-devel \
    R \
    SDL2-devel \
    abcde \
    ansible \
    bashtop \
    bat \
    boost-devel \
    bpytop \
    buildah \
    catch-devel \
    cc65 \
    clang \
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
    glyr \
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
    libzstd-devel \
    lnav \
    lxi-tools \
    make \
    meson \
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
    xorg-x11-xkb-utils-devel \
    xorg-x11-xtrans-devel \
    youtube-dl

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

# Emacs ligatures support until it's in MELPA
mkdir -p "$HOME/.emacs.d/local"
wget -O "$HOME/.emacs.d/local/ligature.el" https://raw.githubusercontent.com/mickeynp/ligature.el/master/ligature.el
emacs -batch -f batch-byte-compile $HOME/.emacs.d/local/*.el

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
    source $HOME/.cargo/env
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

cargo install \
    --git https://github.com/greshake/i3status-rust i3status-rs

# Enable sshd service
sudo systemctl enable sshd.service
sudo systemctl start sshd.service
systemctl --user enable mpDris2
systemctl --user start mpDris2

# Ensure I'm in the dialout and lock groups for Arduino.
sudo usermod -a -G dialout,lock (whoami)

# Setup email and name for this repository.
cd "$dotfiles_dir"
git config user.name "Hammock Sunburn"
git config user.email "hammocksunburn@gmail.com"

# Setup/pull chemacs.
if test ! -d "$HOME/chemacs"
    cd $HOME
    git clone https://github.com/plexus/chemacs.git
    cd $HOME/chemacs
    ./install.sh
else
    cd $HOME/chemacs
    git pull --rebase
end

# Setup/pull doom-emacs.
mkdir -p "$HOME/emacs"
if test ! -d "$HOME/emacs/doom-emacs"
    cd "$HOME/emacs"
    git clone https://github.com/hlissner/doom-emacs
    doom-emacs/bin/doom install -y
else
    cd "$HOME/emacs/doom-emacs"
    git pull --rebase
end

# Setup/pull spacemacs.
if test ! -d "$HOME/emacs/spacemacs"
    cd "$HOME/emacs"
    git clone https://github.com/syl20bnr/spacemacs
else
    cd "$HOME/emacs/spacemacs"
    git pull --rebase
end

# Synchronize any new emacs packages

emacs -batch -l $HOME/dotfiles-home/emacs/boostrap-straight.el --eval="(straight-pull-all)"
emacs -batch -l $HOME/.emacs.d/init.el
systemctl --user enable emacs
systemctl --user restart emacs

# Virtualenv for various python tools
cd $HOME
if test ! -d "$HOME/virtualenv"
    virtualenv "$HOME/virtualenv"
end

$HOME/virtualenv/bin/pip install --upgrade pip
$HOME/virtualenv/bin/pip install --upgrade conan
$HOME/virtualenv/bin/pip install --upgrade tinytag

# Update the locate db
sudo updatedb
