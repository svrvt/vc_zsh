if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zmodload zsh/zprof
fi


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
ZSHDDIR="${HOME}/.config/zsh"

# zsh_sourses=("exports" "options" "aliases" "functions" "zle" "bindings" "compctl" "style" "misc" "prompt")
zsh_sources=(
  "aliases"
  "prompt"
  "notify"
)

# zsh_submodule_dir="$HOME/src/submodules/zsh"
# submodule_plugin_sources=(
#   "zsh-notify"
#   "deer"
#   )

if [[ -o interactive ]]; then

  # for s in "${submodule_plugin_sources[@]}"; do
  #   [[ -d "$zsh_submodule_dir/$s" ]] &&
  #     plugs=$(find src/submodules/zsh/$s -type f -name \*.plugin.zsh -or -type f -name $s)
  #     source
  # done

  source ~/src/submodules/zsh/zsh-notify/notify.plugin.zsh
  source ~/src/submodules/zsh/conda-zsh-completion/conda-zsh-completion.plugin.zsh
  source ~/src/submodules/zsh/deer/deer

  zle -N deer
  bindkey '\ek' deer

  for m in "${zsh_sources[@]}"; do
    [[ -f "$ZSHDDIR/$m" ]] && source "$ZSHDDIR/$m"
  done


  #plugins
  if (( $+commands[sheldon] )); then
     export SHELDON_CONFIG_FILE="$HOME/.config/sheldon/plugins-zsh.toml"
     eval "$(sheldon --config-file $XDG_CONFIG_HOME/sheldon/plugins-zsh.toml source)"
  fi

  if (( $+commands[atuin] )); then
    eval "$(atuin init zsh)"
  fi

  if (( $+commands[navi] )); then
    eval "$(navi widget zsh)"
  fi
  bindkey -s "^n" "navi\n"

fi

# (switch to Emacs mode)
bindkey -e
# bindkey -v

zle -N deer
bindkey '\ek' deer
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

candidate=(\
  /usr/share/zsh/site-functions \
  ~/.local/share/zsh/vendor-completions \
  ~/.zfunc \
)
for r in $candidate; do
  [ -d $r ] && fpath+=$r
done

# Completion.
autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%F{YELLOW}%d%f%u'
zstyle ":completion:*:kill:*" command "ps -u ${USER} -o pid,%cpu,tty,cputime,cmd"

zstyle -e ':completion:*:hosts' hosts 'reply=(
  # ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

zstyle ':completion:*:users' ignored-patterns \
  adm amanda apache avahi backup beaglidx bin brltty cacti canna clamav \
  colord cups cups-pk-helper daemon dbus debian-tor dhcpcd distcache \
  dnscrypt-proxy dnsmasq dovecot earlyoom fax flatpak ftp fwupd-refresh \
  games gdm geoclue git gitlab-runner gkrellmd gluster gnats gopher hacluster \
  haldaemon halt hsqldb http i2psvc ident irc junkbust keydope landscape ldap \
  lightdm list lp lxd mail mailman mailnull man messagebus miniflux mldonkey \
  mpd mysql nagios named netdump news nfsnobody nm-openconnect nobody nscd ntp \
  nut nvidia-persistenced nx openvpn operator pcap polkitd pollinate postfix \
  postgres privoxy proxy pulse pvm quagga radvd root rpc rpcuser rpm rtkit \
  saned sddm shutdown squid sshd sync sys syslog 'systemd-*' tcpdump tor \
  transmission tss usbmux uucp uuidd vcsa www-data xfs '_*'

zstyle ':completion:*:(ssh|scp|rsync):*' tag-order \
  'hosts:-host:host hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' \
  group-order files all-files hosts-domain hosts-host
zstyle ':completion:*:ssh:*' group-order hosts-host
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns \
  '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns \
  '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns \
  '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' \
  '255.255.255.255' '::1' 'fe80::*'


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

autoload bashcompinit
bashcompinit

for b in pacstall awg; do
  (( $+commands[$b] )) && source /usr/share/bash-completion/completions/$b
done
# source /usr/share/bash-completion/completions/awg-quick

#принимает несколько слов или их частей (слово*ово)
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

# Hishtory Config:
# export PATH="$PATH:/home/ru/.hishtory"
# source /home/ru/.hishtory/config.zsh

# rest of .zshrc script

alias zt="time ZSH_DEBUGRC=1 zsh -i -c exit"

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi

