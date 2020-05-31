# Possibly useful if you use Fedora, probably not useful otherwise.

function _setup_gitconfig -a force
    set -l file "$HOME/.gitconfig"
    command ln -s $force "$PWD/gitconfig" "$file"
end

function _setup_starship_toml -a force
    set -l file "$HOME/.config/starship.toml"
    command ln -s $force "$PWD/config/starship.toml" "$HOME/.config"
end

function _setup_fish -a force
    command ln -s $force "$PWD/config/fish" "$HOME/.config"
end

function _setup_nvim -a force
    command ln -s $force "$PWD/config/nvim" "$HOME/.config"
end

function _setup_tmux -a force
    command ln -s $force "$PWD/tmux.conf" "$HOME/.tmux.conf"
end

function _setup_vscode -a force
    command sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    command sudo cp $force vscode/vscode.repo /etc/yum.repos.d/
    command mkdir -p $HOME/.config/Code/User
    command ln -s $force "$PWD/config/Code/settings.json" "$HOME/.config/Code/User"
end

_setup_gitconfig -f
_setup_starship_toml -f
_setup_fish -f
_setup_nvim -f
_setup_tmux -f
_setup_vscode -f

