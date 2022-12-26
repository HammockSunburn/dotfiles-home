zoxide init fish | source

# Use a hammer to get TERM set right.
set -gx TERM xterm-256color

alias icat="kitty +kitten icat --align=left"

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
