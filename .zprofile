if systemctl -q is-active graphical.target \
&& [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  startx; 
  # startx -- -nolisten tcp; 
fi;


# export XDG_CURRENT_DESKTOP="KDE"

# export NIX_REMOTE=daemon
