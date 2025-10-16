source ~/.config/nushell/zoxide.nu

$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.EDITOR = "nvim"

fastfetch

mkdir ($nu.data-dir | path join "vendor/autoload")
~/.cargo/bin/starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

alias gclone = gh repo clone
alias og-cd = cd
alias cd = z
alias bat = ^bat -p --theme="Dracula"
alias c = clear
alias la = ls -a
alias ll = ls -l
alias lla = ls -l -a
alias lt = eza --icons=always --color=always --tree --level=3

# fedora
alias get = sudo dnf in -y
alias remove = sudo dnf rm -y
alias update = sudo dnf update -y
alias search = sudo dnf search

alias copy = wl-copy
alias paste = wl-paste

alias q = exit
alias lg = lazygit

alias fd = fd --color=always

alias grep = rg -e

alias untar = tar -xf
