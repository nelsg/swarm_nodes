#!/bin/bash
set -eux

# prevent apt-get et al from asking questions.
# NB even with this, you'll still get some warnings that you can ignore:
#     dpkg-preconfigure: unable to re-open stdin: No such file or directory
export DEBIAN_FRONTEND=noninteractive

# update && upgrade the package cache.
apt-get update
apt-get upgrade -y

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

# usefull dev tools
sudo apt-get install -y git curl wget python mlocate net-tools dnsutils bridge-utils htop tree telnet bmon nethogs iptraf sysstat iotop tcpdump nano

# vagrant without password
cat >/etc/sudoers.d/vagrant <<'EOF'
%vagrant ALL=NOPASSWD:ALL
EOF

# oh-my-zsh
sudo apt-get install -y zsh
sudo chsh -s /bin/zsh vagrant
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo rsync -r /root/.oh-my-zsh/ /home/vagrant/.oh-my-zsh
sudo chown -R vagrant:vagrant /home/vagrant/.oh-my-zsh

cat >/home/vagrant/.zshrc <<'EOF'
export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"
HIST_STAMPS="yyyy-mm-dd"
plugins=(command-not-found common-aliases git docker docker-compose docker-machine fabric history history-substring-search jsontools pip python ssh-agent sudo yum)
source $ZSH/oh-my-zsh.sh
export LANG=fr_FR.UTF-8
export ARCHFLAGS="-arch x86_64"
export SSH_KEY_PATH="~/.ssh/rsa_id"
EOF
echo CCCC

sudo chown vagrant:vagrant /home/vagrant/.zshrc
echo DDDD

# Permit anyone to start the GUI
if [ -e /etc/X11/Xwrapper.config ]; then
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

 ______                         _   _               _____             _
|  ____|                       | | (_)             |  __ \           | |
| |__ ___  _ __ _ __ ___   __ _| |_ _  ___  _ __   | |  | | ___   ___| | _____ _ __
|  __/ _ \| '__| '_ ` _ \ / _` | __| |/ _ \| '_ \  | |  | |/ _ \ / __| |/ / _ \ '__|
| | | (_) | |  | | | | | | (_| | |_| | (_) | | | | | |__| | (_) | (__|   <  __/ |
|_|  \___/|_|  |_| |_| |_|\__,_|\__|_|\___/|_| |_| |_____/ \___/ \___|_|\_\___|_|


EOF
