#!/usr/bin/env bash

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
NORMAL="$(tput sgr0)"


# Checking the environment

if [ -d $HOME/.dotfiles ]; then
	echo "${YELLOW}You already have dotfiles installed.${NORMAL}"
	echo "Please remove $HOME/.dotfiles if you want to re-install."
	exit
fi


# Creating the symbolic link

function main {
	declare -a SYMLINK_FILES=(
		".gitconfig"
		".tmux.conf"
		".vimrc"
	)

	echo "Creating symbolic link"
	for file in "${SYMLINK_FILES[@]}"; do
		sourceFile="$HOME/.dotfiles/$file"
		targetFile="$HOME/$file"
		ln -sf $sourceFile $targetFile

		printf "${GREEN}\t%-24s → %-24s${NORMAL}\n" $targetFile $sourceFile
	done
	if [ ! -f $HOME/.gitconfig.local ]; then
		echo "Creating local conf"
		cp -f $HOME/.dotfiles/.gitconfig.local $HOME/.gitconfig.local

		printf "${GREEN}\t$HOME/.gitconfig.local${NORMAL}\n"
	fi

	echo ""
	echo "dotfiles now is installed!";
}


read -p "This will overwrite existing files in your home directory. Are you sure? (y/n) ";
echo "";

if [[ $REPLY =~ ^[Yy] ]]; then

	echo "${BLUE}Cloning dotfiles...${NORMAL}"
	git clone --quiet --depth=1 https://github.com/myanbin/dotfiles.git $HOME/.dotfiles || {
		echo "${RED}error: git clone failed${NORMAL}"
		exit 1
	}

	main;
else
	echo "";
fi;

unset main
