#!/bin/bash
set -eux

# prevent apt-get et al from asking questions.
# NB even with this, you'll still get some warnings that you can ignore:
#     dpkg-preconfigure: unable to re-open stdin: No such file or directory
export DEBIAN_FRONTEND=noninteractive

# update the package cache.
apt-get update

# install jq.
apt-get install -y jq

# install vim.
apt-get install -y --no-install-recommends vim
cat >/etc/vim/vimrc.local <<'EOF'
syntax on
set background=dark
set esckeys
set ruler
set laststatus=2
set nobackup
EOF

# install xfce and virtualbox additions
sudo apt-get install -y --no-install-recommends xfce4 virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

# french keyboard
sudo localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
grep -q -F 'LANG=fr_FR.utf-8' /etc/environment || echo "LANG=fr_FR.utf-8" | sudo tee -a /etc/environment
grep -q -F 'LC_ALL=fr_FR.utf-8' /etc/environment || echo "LC_ALL=fr_FR.utf-8" | sudo tee -a /etc/environment
#sudo setxkbmap fr
#sudo sed -i 's/XKBLAYOUT=\"\w*"/XKBLAYOUT=\"fr\"/g' /etc/default/keyboard

# usefull dev tools
sudo apt-get install -y git python mlocate net-tools dnsutils bridge-utils htop tree telnet bmon nethogs iptraf sysstat iotop tcpdump

# Permit anyone to start the GUI
if [ ! -f /etc/X11/Xwrapper.config ]; then
  sudo sed -i 's/allowed_users=.*$/allowed_users=anybody/' /etc/X11/Xwrapper.config
fi

# configure the shell.
cat >/etc/profile.d/login.sh <<'EOF'
[[ "$-" != *i* ]] && return
export EDITOR=vim
export PAGER=less
alias l='ls -lF --color'
alias ll='l -a'
alias h='history 25'
alias j='jobs -l'
EOF

cat >/etc/inputrc <<'EOF'
set input-meta on
set output-meta on
set show-all-if-ambiguous on
set completion-ignore-case on
"\e[A": history-search-backward
"\e[B": history-search-forward
"\eOD": backward-word
"\eOC": forward-word
EOF

# configure the motd.
# NB this was generated at http://patorjk.com/software/taag/#p=display&f=Big&t=docker%20swarm.
#    it could also be generated with figlet.org.
cat >/etc/motd <<'EOF'

      _            _
     | |          | |
   __| | ___   ___| | _____ _ __   _____      ____ _ _ __ _ __ ___
  / _` |/ _ \ / __| |/ / _ \ '__| / __\ \ /\ / / _` | '__| '_ ` _ \
 | (_| | (_) | (__|   <  __/ |    \__ \\ V  V / (_| | |  | | | | | |
  \__,_|\___/ \___|_|\_\___|_|    |___/ \_/\_/ \__,_|_|  |_| |_| |_|


EOF
