systemInfoScript="/var/local/scripts/sysinfo.sh";
if [[ -n $SSH_CONNECTION ]] && [ -x "$systemInfoScript" ]; then
  /bin/bash $systemInfoScript; echo "";
fi;
