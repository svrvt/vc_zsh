if systemctl -q is-active graphical.target \
&& [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  # startx;
  startx -- -nolisten tcp;
fi;

# export NIX_REMOTE=daemon
