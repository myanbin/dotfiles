#!/usr/bin/env bash

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
NORMAL="$(tput sgr0)"


# Checking the environment and download dotfiles

if [ -d $HOME/.dotfiles ]; then
	echo "${YELLOW}You already have dotfiles installed.${NORMAL}"
	echo "Please remove $HOME/.dotfiles if you want to re-install."
	exit
fi

echo "${BLUE}Cloning dotfiles...${NORMAL}"
git clone --quiet --depth=1 https://github.com/myanbin/dotfiles.git $HOME/.dotfiles || {
	echo "${RED}error: git clone failed${NORMAL}"
	exit 1
}


# Creating the symbolic link

function main() {
	declare -a FILES=(
		".gitconfig"
		".vimrc"
	)

	echo "Creating symbolic link"
	for file in "${FILES[@]}"; do
		sourceFile="$HOME/.dotfiles/$file"
		targetFile="$HOME/$file"
		ln -sf $sourceFile $targetFile

		printf "${GREEN}\t$targetFile\t → $sourceFile${NORMAL}\n"
	done

	echo ""
	echo "dotfiles now is installed!";
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	main;
else
	read -p "This will overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		main;
	fi;
fi

unset main
