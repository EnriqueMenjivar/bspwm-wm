#!/bin/bash

#Autor: Enrique Menjívar, @s4vitar

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Saliendo...${endColour}"; sleep 1
	exit 0;
}

function zsh_utils(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalando zsh...${endColour}"
	sudo pacman -S zsh --noconfirm > /dev/null 2>&1

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Clonando repositorio powerlevel10k...${endColour}"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k > /dev/null 2>&1

	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Agregue la configuración preferida para zsh${endColour}"
	zsh

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalacndo lsd ${endColour}"
	sudo pacman -S lsd --noconfirm > /dev/null 2>&1

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalacndo bat${endColour}"
	sudo pacman -S bat --noconfirm > /dev/null 2>&1

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalacndo fzf${endColour}"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf > /dev/null 2>&1
	~/.fzf/install

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalacndo plugins para zsh${endColour}"
	sudo pacman -S zsh-autosuggestions --noconfirm > /dev/null 2>&1
	sudo pacman -S zsh-syntax-highlighting --noconfirm > /dev/null 2>&1

	sudo chown $USER:$USER -R /usr/share/zsh/plugins/zsh-autosuggestions/
	sudo chown $USER:$USER -R /usr/share/zsh/plugins/zsh-syntax-highlighting/

	echo -e "\n${greenColour}[*]${endColour}${greenColour} Hecho${endColour}"
}


	echo -e "${blueColour}
======================================================
;
; Instalación y configuración de zsh
;  - powerlevel10k
;  - lsd
;  - bat
;  - fzf
;  - autosuggestions
;  - syntax-highlighting
;
======================================================
    ${endColour}"
echo -ne "\n${yellowColour}[*]${endColour}${grayColour} Proceder con la instalación [y/n] ${endColour}" && read v_option
if [ $v_option == "y" ]; then
	zsh_utils
	echo -e "\n${greenColour}[*] Hecho${endColour}\n"
else
	echo -e "\n${redColour}[!] Instalación cancelada ${endColour}\n"
fi
