if systemctl -q is-active graphical.target \
&& ! systemctl -q is-active display-manager.service \
&& [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  startx;
  # startx -- -nolisten tcp -nolisten local; ### add to ~/.xserverrc
fi;
