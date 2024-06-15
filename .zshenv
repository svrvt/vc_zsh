# awesome-client "local naughty=require('naughty'); require('awful').spawn.easy_async('env', function(out) naughty.notify({title="ENV", text=out})end)"

# export XDG_CURRENT_DESKTOP="KDE"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# GIT_HOME=$HOME/aggregate

ZDOTDIR=${ZDOTDIR:-${HOME}}
ZSHDDIR="${XDG_CONFIG_HOME}/zsh"

zsh_sourses=("functions" "zsh_functions" "exports")
for m in "${zsh_sourses[@]}"; do
	[[ -f "$ZSHDDIR/$m" ]] && source "$ZSHDDIR/$m"
done
