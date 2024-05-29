# awesome-client "local naughty=require('naughty'); require('awful').spawn.easy_async('env', function(out) naughty.notify({title="ENV", text=out})end)"

# export XDG_CURRENT_DESKTOP="KDE"
export XDG_CONFIG_HOME="$HOME/.config"
# export XDG_CURRENT_DESKTOP="KDE"

# GIT_HOME=$HOME/aggregate
# DOT_SHELL=$GIT_HOME/re_shell
# DOT_SHELL=$GIT_HOME/re_shell
# SHELLSOURCE=$DOT_SHELL/home/sources

ZDOTDIR=${ZDOTDIR:-${HOME}}
ZSHDDIR="${XDG_CONFIG_HOME}/zsh"


# SHELLSOURCE=$DOT_SHELL/home/sources
my_array=("functions" "zsh_functions" "exports_and_paths")
for m in "${my_array[@]}"; do
	[[ -f "$ZSHDDIR/my_$m" ]] && source "$ZSHDDIR/my_$m"
done
