#!/bin/bash

#Autor: Enrique Menjívar
#Dependencies: yay

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

function bspwm_installing_packeges(){

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Actualizando repositorios...${endColour}"
	sudo pacman -Sy > /dev/null 2>&1

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalando bspwm...${endColour}"
	sudo pacman -S bspwm sxhkd --noconfirm > /dev/null 2>&1
	
#	sudo pacman -S sxhkd --noconfirm > /dev/null 2>&1
#	sudo pacman -S terminus-font --noconfirm > /dev/null 2>&1
#	sudo pacman -S xorg-xset --noconfirm > /dev/null 2>&1

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalando dependencias...${endColour}"
	sudo pacman -S libxcb xcb-util xcb-util-wm xcb-util-keysyms --noconfirm > /dev/null 2>&1
	sudo pacman -S base-devel --noconfirm > /dev/null 2>&1

	mkdir -p ~/.config/{bspwm,sxhkd}
	cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
	cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/
	chmod u+x ~/.config/bspwm/bspwmrc

	sed -i "/sxhkd &/a wmname LG3D &\nbspc config pointer_modifier mod1" ~/.config/bspwm/bspwmrc
	echo -e "sxhkd &\nexec bspwm" > ~/.xinitrc

	#Picom es el compositor de ventanas
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalando picom...${endColour}"
	sudo pacman -S picom --noconfirm > /dev/null 2>&1

	#feh es un paquete que ayuda a configurar el fondo de pantalla
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalando feh...${endColour}"
	sudo pacman -S feh --noconfirm > /dev/null 2>&1

	#rofi es un paquete que ayuda a busar aplicaciones por medio de un menú
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalando rofi...${endColour}"
	sudo pacman -S rofi --noconfirm > /dev/null 2>&1

}

function bspwm_init_configuration(){

	#Configuración  de combinaciones en algunos atajaos que ya vienen por defecto (opcional)
	sed -i -e "s/urxvt.*/alacritty/" ~/.config/sxhkd/sxhkdrc
	sed -i -e "s/super + @space.*/super + d/" ~/.config/sxhkd/sxhkdrc
	sed -i -e "s/dmenu_run.*/rofi -show run/" ~/.config/sxhkd/sxhkdrc
	sed -i -e "s/super + {_,shift + }{h,j,k,l}.*/super + {_,shift + }{Left,Down,Up,Right}/" ~/.config/sxhkd/sxhkdrc
	sed -i -e "s/super + ctrl + {h,j,k,l}.*/super + ctrl + alt + {Left,Down,Up,Right}/" ~/.config/sxhkd/sxhkdrc
	sed -i -e "s/super + {Left,Down,Up,Right}.*/super + ctrl + {Left,Down,Up,Right}/" ~/.config/sxhkd/sxhkdrc

	#Indica que inicia la personalización del archivo
	echo -e "\n\n#---------------------------------------------------------------------------------------------" >> ~/.config/sxhkd/sxhkdrc
	echo -e "#CUSTOM" >> ~/.config/sxhkd/sxhkdrc
	echo -e "#---------------------------------------------------------------------------------------------" >> ~/.config/sxhkd/sxhkdrc

	#Agregando atajo para redimencionar las ventanas
	echo -e "\n#Custom move/resize" >> ~/.config/sxhkd/sxhkdrc
	echo -e "ctrl + alt + {Left,Down,Up,Right}" >> ~/.config/sxhkd/sxhkdrc
	echo -e "\t/home/$USER/.config/bspwm/scripts/bspwm_resize {west,south,north,east}" >> ~/.config/sxhkd/sxhkdrc

	#Creación de carpetas
	mkdir ~/.config/bspwm/scripts
	mkdir ~/.config/picom
	mkdir ~/.config/polybar

	#Agregando configuración de picom en el archivo bspwmrc
	sed -i "/sxhkd &/a picom --config /home/$USER/.config/picom/picom.conf &" ~/.config/bspwm/bspwmrc

	#Copiando archivos
	cp bspwm_resize ~/.config/bspwm/scripts/
	cp compton.conf ~/.config/compton/
	cp launch.sh ~/.config/polybar/
}

function bspwm_polybar(){

	#Verficar que yay este instalado
	test -f /usr/bin/yay
	if [ "$(echo $?)" != "0" ]; then
		echo -e "\n${redColour}[!]${endColour}${redColour} No se encontró yay${endColour}"
		exit 0;
	if

	#Descarga repositorio de polybar
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Descargando polybar${endColour}"
	yay -S polybar
#	yay -S --noconfirm polybar

	cp /usr/share/doc/polybar/config /home/$USER/.config/polybar
	cd /home/$USER/.config/polybar
	chown $USER:$USER -R *

	sed -i "/sxhkd &/a  ~/.config/polybar/launch.sh &" ~/.config/bspwm/bspwmrc
}

function bspwm_fonts(){
	polybar_path=/home/$USER/.config/polybar/config

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Configurando fuentes${endColour}"
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Descargando hack fonts ...${endColour}"
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip > /dev/null 2>&1

	sudo mkdir -p /usr/share/fonts/ > /dev/null 2>&1
	sudo mv Hack.zip /usr/share/fonts/
	cd /usr/share/fonts/
	sudo unzip Hack.zip > /dev/null 2>&1
	sudo rm /usr/share/fonts/Hack.zip

	sed -i "/label-focused =/c\label-focused = " $polybar_path
	sed -i "/label-occupied =/c\label-occupied = " $polybar_path
	sed -i "/label-urgent =/c\label-urgent = " $polybar_path
	sed -i "/label-empty =/c\label-empty = " $polybar_path
	sed -i "/font-2 =/a font-3 = Hack Nerd Font Mono:pixelsize=15;2" $polybar_path
	sed -i "/modules-center =/c\modules-center = xwindow" $polybar_path
	sed -i "/^background = #/c\background = #aa2F343F" $polybar_path
}

function bspwm_add_shortcut(){
	echo -e "${yellowColour}[*]${endColour}${grayColour} De clic sobre una ventana de la aplicación ${endColour}"
	wm_window=$(xprop WM_CLASS | cut -d ',' -f 2 | tr -d \")

	echo -ne "${yellowColour}[*]${endColour}${grayColour} Ingrese la combinación para la aplicación ${wm_window}: ${endColour}" && read v_shortcut
	
	echo -e \"\n#$wm_window\" >> ~/.config/sxhkd/sxhkdrc
	echo -e \"$v_shortcut\" >> ~/.config/sxhkd/sxhkdrc
	echo -e \"\t$wm_window\" >> ~/.config/sxhkd/sxhkdrc
}

function bspwm_uninstall_enviroment(){
	echo -ne "\n${redColour}[!] ¿Desea remover todos los paquetes relacionados a BSPWM?${endColour}${grayColour} [s/n] ${endColour}" && read v_confirm

	if [ $v_confirm == "s" ]; then
		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Desinstalando bspwm ...${endColour}"
		sudo pacman -R --noconfirm bspwm sxhkd > /dev/null 2>&1

		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Desinstalando dependencias de bspwm ...${endColour}"
		sudo pacman -R --noconfirm libxcb xcb-util xcb-util-wm xcb-util-keysyms > /dev/null 2>&1

		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Desinstalando compton ...${endColour}"
		sudo pacman -R --noconfirm picom -y > /dev/null 2>&1

		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Desinstalando feh ...${endColour}"
		sudo pacman -R --noconfirm feh -y > /dev/null 2>&1

		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Desinstalando rofi ...${endColour}"
		sudo pacman -R --noconfirm rofi -y > /dev/null 2>&1

		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Removiendo directorios ...${endColour}"
		sudo rm -r /usr/share/fonts/Hack* > /dev/null 2>&1
		rm -r /home/$USER/.config/bspwm/ > /dev/null 2>&1
		rm -r /home/$USER/.config/compton/ > /dev/null 2>&1
		rm -r /home/$USER/.config/polybar/ > /dev/null 2>&1
		rm -r /home/$USER/.config/sxhkd/ > /dev/null 2>&1
	fi
}

function bspwm_verify_dependencies(){
	dependencies=(git wget unzip)

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Comprobando programas necesarios... ${endColour}"; sleep 2

	for program in "${dependencies[@]}"; do
		echo -ne "\n${yellowColour}[*]${endColour}${blueColour} Harramienta${endColour}${purpleColour} $program${endColour}${blueColuor}...${endColour}"

		test -f /usr/bin/$program

		if [ "$(echo $?)" == "0" ]; then
			echo -e " ${greenColour}(V)${endColour}"
		else
			echo -e " ${redColour}(X)${endColour}\n"
			echo -e "\t${yellowColour}[*]${endColour}${grayColour} Instalando herramienta ${endColour}${blueColour}$program${endColour}${yellowColour}...${endColour}"
			sudo pacman -S $program --noconfirm > /dev/null 2>&1
		fi; sleep 1
	done

}

clear
echo -e "${blueColour}
======================================================
;
;	██████╗ ███████╗██████╗ ██╗    ██╗███╗   ███╗
;	██╔══██╗██╔════╝██╔══██╗██║    ██║████╗ ████║
;	██████╔╝███████╗██████╔╝██║ █╗ ██║██╔████╔██║
;	██╔══██╗╚════██║██╔═══╝ ██║███╗██║██║╚██╔╝██║
;	██████╔╝███████║██║     ╚███╔███╔╝██║ ╚═╝ ██║
;	╚═════╝ ╚══════╝╚═╝      ╚══╝╚══╝ ╚═╝     ╚═╝
;
;	1) Instalación y configuración de entorno con BSPWM
;	2) Agregar un shortcut
;	3) Desinstalar entorno BSPWM
;
======================================================
${endColour}"
echo -ne "\n${yellowColour}[*]${endColour}${grayColour} Elija una opción: ${endColour}" && read v_option

case $v_option in
	1)
		bspwm_verify_dependencies
		bspwm_installing_packeges
		bspwm_init_configuration
		bspwm_polybar
		bspwm_fonts
		echo -e "\n${greenColour}[*] Hecho ${endColour}"
		;;
	2)
		bspwm_add_shortcut
		echo -e "\n${greenColour}[*] Hecho ${endColour}"
		;;
	3)
		bspwm_uninstall_enviroment
		echo -e "\n${greenColour}[*] Hecho ${endColour}"
		;;
	*) echo -e "\n${redColour}[*] Opción no válida${endColour}\n" ;;
esac
