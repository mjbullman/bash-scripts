#!/usr/bin/env bash

echo "Adding alias to .bashrc"

bash_alias_file="$HOME/.bash_aliases"

# create the bash_alias file if it does not exits.
if [ ! -f $bash_alias_file ]; then
    touch $bash_alias_file
fi

echo "alias uu='sudo apt update -y \
      && sudo apt upgrade -y \
      && sudo apt autoremove -y \
      && sudo apt clean -y'" >> "$bash_alias_file"
echo "alias c='clear" >> "$bash_alias_file"


source "$bash_alias_file"



