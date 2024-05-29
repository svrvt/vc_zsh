if systemctl -q is-active graphical.target \
&& [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  startx;
fi;
# export XDG_CURRENT_DESKTOP="KDE"
export TERMINAL="alacritty"

# export NIX_REMOTE=daemon
