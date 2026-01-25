function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

end

starship init fish | source
#if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
#    cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
#end

alias pamcan pacman
alias ls 'eza --icons'
alias clear "printf '\033[2J\033[3J\033[1;1H'"
alias q 'qs -c ii'
alias pi 'yay -S --needed '
alias piq 'yay -S --noconfirm --needed '
alias pmi 'sudo pacman -S --needed '
alias clch 'sudo pacman -Scc'
alias pcc 'sudo pacman -Rcns $(pacman -Qtdq)'
alias xx exit
alias prem 'sudo pacman -Rsn '
alias hyr 'hyprctl reload'
alias ged 'gnome-text-editor '
alias bkl 'sudo timeshift --list'
alias cbk 'sudo timeshift --create '
alias sc 'pacman -Qq '
alias upd 'sudo pacman -Syu --needed --noconfirm'
alias update-grub 'sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias srch 'yay -Ss '
alias v 'nvim '
alias veww 'nvim ~/.config/eww'
alias vfish 'nvim ~/.config/fish/config.fish'
alias vmat 'nvim ~/.config/matugen/config.toml'

#alias cdwm 'nvim ~/suckless/dwm/config.h'
#alias mdwm 'cd ~/suckless/dwm; sudo make clean install; cd -'
#alias cst 'nvim ~/suckless/st/config.h'

# function fish_prompt
#   set_color cyan; echo (pwd)
#   set_color green; echo '> '
# end
zoxide init fish | source
