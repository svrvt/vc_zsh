# .zshrc
# Author: Piotr Karbowski <piotr.karbowski@gmail.com>
# License: beerware.

# Set the "umask" (see "man umask"):
# ie read and write for the owner only.
# umask 002 # relaxed   -rwxrwxr-x
# umask 022 # cautious  -rwxr-xr-x
# umask 027 # uptight   -rwxr-x---
# umask 077 # paranoid  -rwx------
# umask 066 # bofh-like -rw-------
umask 066

# If root set unmask to 022 to prevent new files being created group and world writable
if (( EUID == 0 )); then
    umask 022
fi

# If running as root and nice >0, renice to 0.
if [ "$USER" = 'root' ] && [ "$(cut -d ' ' -f 19 /proc/$$/stat)" -gt 0 ]; then
    renice -n 0 -p "$$" && echo "# Adjusted nice level for current shell to 0."
fi

# if [ -f ~/.alert ]; then echo '>>> Check ~/.alert'; fi

HISTFILE="${HOME}/.zsh_history"
HISTSIZE='128000'
SAVEHIST='128000'

# ZDOTDIR=${ZDOTDIR:-${HOME}}
# ZSHDDIR="${HOME}/.config/zsh"

DOT_SHELL=$GIT_HOME/re_shell

my_sourses=("aliases" "zsh_prompt")

if [[ -o interactive ]]; then
  for m in "${my_sourses[@]}"; do
    [[ -f "$ZSHDDIR/my_$m" ]] && source "$ZSHDDIR/my_$m"
  done
fi

# Test and then source exported variables.
# my_array=("exports" "options" "aliases" "functions" "zle" "bindings" "compctl" "style" "misc" "paths" "prompt")
#
# for m in "${my_array[@]}"; do
# 	[[ -f "$ZSHDDIR/zsh$m" ]] && source "$ZSHDDIR/zsh$m" || echo "Note: $ZSHDDIR/zsh$m in unavailable"
# done

# (switch to Emacs mode)
bindkey -e
# bindkey -v

## Стек Каталогов
DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}
DIRSTACKSIZE=20
setopt auto_pushd pushdsilent pushdtohome   ## Сохр. истории `cd` в `pushd` и обеспечение работы `cd -<TAB>`
setopt pushd_ignore_dups                    ## Удалить повторяющиеся записи
setopt pushd_minus                          ## oтменяет +/- операторы.
bindkey -s "q\t" "cd -\t"                   ## q<tab> - for open dirstack

# Completion.
autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%F{YELLOW}%d%f%u'

setopt interactivecomments  # Игнорировать записи с префиксом '#'.
setopt hist_ignore_dups     # Игнорируйте дубликаты в истории.
setopt hist_ignore_space    # Запрет записи в истории, если перед ней есть пробелы.

# extended globbing, awesome!
setopt extendedGlob

# Turn on command substitution in the prompt (and parameter expansion and arithmetic expansion).
setopt promptsubst

# zargs, as an alternative to find -exec and xargs.
autoload -U zargs

# Control-x-e to open current line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

#plugins
if (( $+commands[sheldon] )); then              # только для zsh
   eval "$(sheldon --config-file $XDG_CONFIG_HOME/sheldon/plugins-zsh.toml source)"
fi

if (( $+commands[atuin] )); then
  eval "$(atuin init zsh)"
fi

if (( $+commands[navi] )); then
  eval "$(navi widget zsh)"
fi

bindkey -s "^n" "navi\n"

#принимает несколько слов или их частей (слово*ово)  
bindkey "^R" history-incremental-pattern-search-backward 
bindkey "^S" history-incremental-pattern-search-forward

# if [ $SHELL = "/usr/bin/zsh" ] && ! grep -q "emulate sh -c 'source /etc/profile'" /etc/zsh/zprofile /etc/zsh/zlogin; then
#   echo -e "/etc/profile.d/* don't soursed"
#   echo -e "press 'y' for fix it"
#   read -r ask
#   case $ask in
#     y)
#     echo "emulate sh -c 'source /etc/profile'" | sudo tee /etc/zsh/zprofile
#     echo -e "emulate sh -c 'source /etc/profile' added to /etc/zsh/zprofile"
#     echo -e "reboot or"
#     echo "for i in /etc/profile.d/*.sh; do if [ -r \$i ]; then . \$i; fi; done"
#     ;;
#   esac
# fi

# fpath=(/home/ru/.local/share/zsh/plugins/zsh-completions/src $fpath)

