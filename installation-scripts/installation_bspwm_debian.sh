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

export DEBIAN_FRONTEND=noninteractive

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Saliendo...${endColour}"; sleep 1
	exit 0;
}

function bspwm_installing_packeges(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Actualizando repositorios...${endColour}"
	apt-get update > /dev/null 2>&1

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalando bspwm...${endColour}"
	apt-get install bspwm -y > /dev/null 2>&1

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalando dependencias...${endColour}"
	apt-get install libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev -y > /dev/null 2>&1
	apt-get install build-essential -y > /dev/null 2>&1
	apt-get install make -y > /dev/null 2>&1
	apt-get install cmake -y > /dev/null 2>&1

	git clone https://github.com/baskerville/bspwm.git > /dev/null 2>&1
	git clone https://github.com/baskerville/sxhkd.git > /dev/null 2>&1

	cd bspwm && make && sudo make install
	cd ../sxhkd && make && sudo make install

	su $v_user -c "mkdir -p ~/.config/{bspwm,sxhkd}"
	su $v_user -c "cp /usr/local/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/"
	su $v_user -c "cp /usr/local/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/"
	su $v_user -c "chmod u+x ~/.config/bspwm/bspwmrc"

	su $v_user -c 'sed -i "/sxhkd &/a wmname LG3D &\nbspc config pointer_modifier mod1" ~/.config/bspwm/bspwmrc'
	su $v_user -c 'echo -e "sxhkd &\nexec bspwm" > ~/.xinitrc'

	#Compton es un paquete para gestionar la transparencia de las ventanas
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalando compton...${endColour}"
	apt-get install compton -y > /dev/null 2>&1

	#feh es un paquete que ayuda a configurar el fondo de pantalla
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalando feh...${endColour}"
	apt-get install feh -y > /dev/null 2>&1

	#rofi es un paquete que ayuda a busar aplicaciones por medio de un menú
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalando rofi...${endColour}"
	apt-get install rofi -y > /dev/null 2>&1

	#Borrar repositorios clonados
	cd ..
	rm -r bspwm
	rm -r sxhkd

}

function bspwm_init_configuration(){

	#Configuración  de combinaciones en algunos atajaos que ya vienen por defecto
	su $v_user -c 'sed -i -e "s/urxvt.*/alacritty/" ~/.config/sxhkd/sxhkdrc'
	su $v_user -c 'sed -i -e "s/super + @space.*/super + d/" ~/.config/sxhkd/sxhkdrc'
	su $v_user -c 'sed -i -e "s/dmenu_run.*/rofi -show run/" ~/.config/sxhkd/sxhkdrc'
	su $v_user -c 'sed -i -e "s/super + {_,shift + }{h,j,k,l}.*/super + {_,shift + }{Left,Down,Up,Right}/" ~/.config/sxhkd/sxhkdrc'
	su $v_user -c 'sed -i -e "s/super + ctrl + {h,j,k,l}.*/super + ctrl + alt + {Left,Down,Up,Right}/" ~/.config/sxhkd/sxhkdrc'
	su $v_user -c 'sed -i -e "s/super + {Left,Down,Up,Right}.*/super + ctrl + {Left,Down,Up,Right}/" ~/.config/sxhkd/sxhkdrc'

	#Indica que inicia la personalización del archivo
	su $v_user -c 'echo -e "\n\n#---------------------------------------------------------------------------------------------" >> ~/.config/sxhkd/sxhkdrc'
	su $v_user -c 'echo -e "#CUSTOM" >> ~/.config/sxhkd/sxhkdrc'
	su $v_user -c 'echo -e "#---------------------------------------------------------------------------------------------" >> ~/.config/sxhkd/sxhkdrc'

	#Agregando atajo para redimencionar las ventanas
	su $v_user -c 'echo -e "\n#Custom move/resize" >> ~/.config/sxhkd/sxhkdrc'
	su $v_user -c 'echo -e "ctrl + alt + {Left,Down,Up,Right}" >> ~/.config/sxhkd/sxhkdrc'
	su $v_user -c 'echo -e "\t/home/$USER/.config/bspwm/scripts/bspwm_resize {west,south,north,east}" >> ~/.config/sxhkd/sxhkdrc'

	#Creación de carpetas
	su $v_user -c 'mkdir ~/.config/bspwm/scripts'
	su $v_user -c 'mkdir ~/.config/compton'
	su $v_user -c 'mkdir ~/.config/polybar'
	
	#Agregando configuración de compton en el archivo bspwmec
	su $v_user -c 'sed -i "/sxhkd &/a compton --config /home/$USER/.config/compton/compton.conf &" ~/.config/bspwm/bspwmrc'

	#Copiando archivos
	##su $v_user -c 'cp bspwm_resize ~/.config/bspwm/scripts/'
	##su $v_user -c 'cp compton.conf ~/.config/compton/'
	##su $v_user -c 'cp launch.sh ~/.config/polybar/'
}

function bspwm_polybar(){
	#Dependecnias del polybar
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalando dependencias del polybar...${endColour}"
	wget http://ftp.us.debian.org/debian/pool/main/x/xcb-proto/python3-xcbgen_1.14.1-1_all.deb > /dev/null 2>&1
	dpkg -i python3-xcbgen_1.14.1-1_all.deb > /dev/null 2>&1
	
	apt install build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev -y > /dev/null 2>&1
	apt install libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev -y > /dev/null 2>&1
	
	#Descarga repositorio de polybar
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Descargando polybar 3.4.0 ${endColour}"
	cd /opt
	wget https://github.com/jaagr/polybar/releases/download/3.4.0/polybar-3.4.0.tar > /dev/null 2>&1
	tar -xf polybar-3.4.0.tar
	
	rm polybar-3.4.0.tar
	rm python3-xcbgen_1.14.1-1_all.deb

	#Instalación de polybar
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Instalando polybar ...${endColour}"
	cd /opt/polybar
	mkdir build
	cd build
	cmake ..
	make -j$(nproc)
	sudo make install

	cp /opt/polybar/config /home/$v_user/.config/polybar
	cd /home/$v_user/.config/polybar
	chown $v_user:$v_user -R *

	su $v_user -c 'sed -i "/sxhkd &/a  ~/.config/polybar/launch.sh &" ~/.config/bspwm/bspwmrc'
}

function bspwm_fonts(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Configurando fuentes${endColour}"
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Descargando hack fonts ...${endColour}"
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip > /dev/null 2>&1
	
	mv Hack.zip /usr/local/share/fonts/
	cd /usr/local/share/fonts/
	unzip Hack.zip > /dev/null 2>&1
	rm /usr/local/share/fonts/Hack.zip

	polybar_dir=/home/$v_user/.config/polybar/config
	sed -i "/label-focused =/c\label-focused = " $polybar_dir
	sed -i "/label-occupied =/c\label-occupied = " $polybar_dir
	sed -i "/label-urgent =/c\label-urgent = " $polybar_dir
	sed -i "/label-empty =/c\label-empty = " $polybar_dir
	sed -i "/font-2 =/a font-3 = Hack Nerd Font Mono:pixelsize=15;2" $polybar_dir
	sed -i "/modules-center =/c\modules-center = xwindow" $polybar_dir
	sed -i "/^background = #/c\background = #aa2F343F" $polybar_dir
}

function bspwm_add_shortcut(){
	echo -e "${yellowColour}[*]${endColour}${grayColour} De clic sobre una ventana de la aplicación ${endColour}"
	wm_window=$(xprop WM_CLASS | cut -d ',' -f 2 | tr -d \")

	echo -ne "${yellowColour}[*]${endColour}${grayColour} Ingrese la combinación para la aplicación ${wm_window}: ${endColour}" && read v_shortcut
	
	su $v_user -c "echo -e \"\n#$wm_window\" >> ~/.config/sxhkd/sxhkdrc"
	su $v_user -c "echo -e \"$v_shortcut\" >> ~/.config/sxhkd/sxhkdrc"
	su $v_user -c "echo -e \"\t$wm_window\" >> ~/.config/sxhkd/sxhkdrc"
}

function bspwm_uninstall_enviroment(){
	echo -ne "\n${redColour}[!] ¿Desea remover todos los paquetes relacionados a BSPWM?${endColour}${grayColour} [s/n] ${endColour}" && read v_confirm
	
	if [ $v_confirm == "s" ]; then
		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Desinstalando bspwm ...${endColour}"
		apt-get remove --purge bspwm -y > /dev/null 2>&1
		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Desinstalando dependencias de bspwm ...${endColour}"
		apt-get remove --purge libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev -y > /dev/null 2>&1
		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Desinstalando compton ...${endColour}"
		apt-get remove --purge compton -y > /dev/null 2>&1
		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Desinstalando feh ...${endColour}"
		apt-get remove --purge feh -y > /dev/null 2>&1
		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Desinstalando rofi ...${endColour}"
		apt-get remove --purge rofi -y > /dev/null 2>&1
		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Desinstalando dependencias de polybar ...${endColour}"
		apt-get remove --purge build-essential cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev -y > /dev/null 2>&1
		apt-get remove --purge libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev -y > /dev/null 2>&1
		dpkg -r python3-xcbgen > /dev/null 2>&1

		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Removiendo directorios ...${endColour}"
		rm -r /usr/local/share/fonts/Hack* > /dev/null 2>&1
		rm -r /opt/polybar/ > /dev/null 2>&1
		rm -r /home/$v_user/.config/bspwm/ > /dev/null 2>&1
		rm -r /home/$v_user/.config/compton/ > /dev/null 2>&1
		rm -r /home/$v_user/.config/polybar/ > /dev/null 2>&1
		rm -r /home/$v_user/.config/sxhkd/ > /dev/null 2>&1
	fi
}

function bspw_verify_user(){
	echo -ne "\n${yellowColour}[*]${endColour}${grayColour} Ingrese el nombre de usuario: ${endColour}" && read v_user
	ls /home/$v_user > /dev/null 2>&1

	if [ "$(echo $?)" != "0" ]; then
		echo -e "\n${redColour}[!]${endColour}${redColour} El usuario ingresado no es válido${endColour}\n"
		exit 0;
	fi
}

function bspwm_verify_dependencies(){
	dependencies=(git wget)

	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Comprobando programas necesarios... ${endColour}"; sleep 2

	for program in "${dependencies[@]}"; do
		echo -ne "\n${yellowColour}[*]${endColour}${blueColour} Harramienta${endColour}${purpleColour} $program${endColour}${blueColuor}...${endColour}"

		test -f /usr/bin/$program

		if [ "$(echo $?)" == "0" ]; then
			echo -e " ${greenColour}(V)${endColour}"
		else
			echo -e " ${redColour}(X)${endColour}\n"
			echo -e "\t${yellowColour}[*]${endColour}${grayColour} Instalando herramienta ${endColour}${blueColour}$program${endColour}${yellowColour}...${endColour}"
			apt-get install $program -y > /dev/null 2>&1
		fi; sleep 1
	done

}

if [ "$(id -u)" == 0 ]; then
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
    bspw_verify_user

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
else
	echo -e "\n${redColour}[!] No eres usuario root${endColour}\n"
fi
