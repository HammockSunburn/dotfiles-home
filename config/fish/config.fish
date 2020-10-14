starship init fish | source
zoxide init fish | source

alias ls="exa --time-style=long-iso"
alias ping="prettyping --nolegend"
alias icat="kitty +kitten icat --align=left"

if test -e /opt/boost
   set -x BOOST_ROOT /opt/boost 
end

