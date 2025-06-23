#speed up load time
skip_global_compinit=1

# export XDG_DATA_DIRS=/usr/share:"$XDG_DATA_DIRS"
# export XDG_CURRENT_DESKTOP="KDE"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export ZDOTDIR=${ZDOTDIR:-${HOME}}
export ZSHDDIR=${XDG_CONFIG_HOME}/zsh

zsh_base=(
	"functions"
	"exports"
)
for zb in "${zsh_base[@]}"; do
	[[ -f "$ZSHDDIR/$zb" ]] && source "$ZSHDDIR/$zb"
done
