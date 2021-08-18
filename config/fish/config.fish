zoxide init fish | source

alias ls="exa --time-style=long-iso"
alias ping="prettyping --nolegend"
alias icat="kitty +kitten icat --align=left"

if test -d /opt/boost
    set -gx BOOST_ROOT /opt/boost 
end

if test -d "$HOME/bin"
    set -gx PATH "$HOME/bin" $PATH
end

function checkiso -d "Compare an ISO file to what's been written to a USB drive"
    sudo true
    echo "reading file checksum from" $argv[1]
    echo "reading USB checksum from" $argv[2]

    set iso_size (stat -c '%s' $argv[1])
    set usb_sha (sudo dd bs=4096 if=$argv[2] | pv -p -b -s $iso_size -S | sha256sum)
    set file_sha (pv -p -b -s $iso_size $argv[1] | sha256sum)

    echo "File checksum:" $file_sha
    echo "USB checksum: " $usb_sha
end

# ghcup-env
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
test -f $HOME/.ghcup/env ; and set -gx PATH $HOME/.cabal/bin $HOME/.ghcup/bin $PATH
