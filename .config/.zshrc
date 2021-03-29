# Fix Java problem
export _JAVA_AWT_WM_NONREPARETING=1

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Manual configuration
PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl

# Manual aliases
alias ls='lsd --group-dirs=first'
alias cat='/usr/bin/bat --paging=never'
alias less='/usr/bin/bat'
alias vim='/usr/bin/nvim'
#alias vi='/usr/bin/nvim'
alias copy='xclip -selection clipboard'

# History configuration
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
HISTTIMEFORMAT="[%F %T] "
#HISTDUP=erase               #Erase duplicates in the history file
setopt INC_APPEND_HISTORY #Agrega el comando inmediatamente al historial (sin que se temrine de ejecutar)
setopt EXTENDED_HISTORY #Agrega el tiempo a cada comando del historial
setopt HIST_FIND_NO_DUPS #Elimina los duplicado al buscar en el historial (ctrl + r)
#setopt HIST_IGNORE_ALL_DUPS #No agrega los comandos duplicadps al historial
#export HISTORY_IGNORE="(ls|cat|AWS|SECRET)" #Comandos que no se guardaran en el historial

# Functions

# fzf improvement
function fzf-lovely(){
 
        if [ "$1" = "h" ]; then
                fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] &&
                        echo {} is a binary file ||
                         (bat --style=numbers --color=always {} ||
                          highlight -O ansi -l {} ||
                          coderay {} ||
                          rougify {} ||
                          cat {}) 2> /dev/null | head -500'
 
        else
                fzf -m --preview '[[ $(file --mime {}) =~ binary ]] &&
                                 echo {} is a binary file ||
                                 (bat --style=numbers --color=always {} ||
                                  highlight -O ansi -l {} ||
                                  coderay {} ||
                                  rougify {} ||
                                  cat {}) 2> /dev/null | head -500'
        fi
}

# Set 'man' colors
function man() {
    env \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    man "$@"
}

#Guardar comandos en un archivo
function mkc(){
    dir=/home/enrique/MEGAsync/Commands/commands.txt
    echo -ne "Command: " && read -r command
    echo -ne "Comment: " && read -r comment
    echo -e "\n#//$comment\n$command" >> $dir
}

#Actualizar cambios en los archivos de configuración de bspwm
funciton update_dotfiles(){
	repo_path=~/Documents/github/linux/bspwm-wm/.config/
	cp -r ~/.config/alacritty/ $repo_path
	cp -r ~/.config/bspwm $repo_path
	cp -r ~/.config/picom $repo_path
	cp -r ~/.config/polybar/ $repo_path
	cp -r ~/.config/sxhkd $repo_path
	cp -r ~/.config/nvim $repo_path
	cp -r ~/.config/dunst $repo_path
	cp -r ~/.fonts/* ~/Documents/github/linux/bspwm-wm/fonts
	cp ~/.zshrc $repo_path
	cp ~/.p10k.zsh $repo_path
	echo "[*] Hecho"
}

#Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#Configuración para el funcionamiento de algunas teclas/atajos en zsh - arch linux
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

bindkey "5C" forward-word
bindkey "5D" backward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$PATH:/home/enrique/flutter/bin"
ANDROID_HOME="$PATH:/home/enrique/Android/Sdk"
export PATH="$PATH:/home/enrique/Android/Sdk/platform-tools"

# Tell FZF to use ripgrep
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 100% --border'
fi
