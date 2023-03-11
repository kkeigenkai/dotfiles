eval "$(/opt/homebrew/bin/brew shellenv)"
if status is-interactive
end
alias l="exa -abghHliS"
alias cat="bat -p --theme=TwoDark"
alias bat="bat -p --theme=TwoDark"
alias b="bat -p --theme=TwoDark"
alias config="/opt/homebrew/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias pinentry='pinentry-mac'

zoxide init fish | source
starship init fish | source

export GPG_TTY=$(tty)
