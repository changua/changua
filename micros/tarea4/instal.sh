#! /bin/bash
function menu_inicio {
  echo -e "Bienvenido a instalacion y configuracion de placas de desarrollo"
  echo -e "¿Qué desea realizar?"
  echo -e "1. Instalar"
  echo -e "2. Configurar"
  echo -e "3. Salir"
  echo -n ": "
}
function menu_tarjeta {
  echo -e "¿Qué tarjeta posee"
  echo -e "1. Perro"
  echo -e "2. Mora"
  echo -e "3. Cancelar"
  echo -n ": "
}
function menu_puerto {
  echo "¿Qué puerto va usar?"
  echo "1. USB"
  echo "2.Adaptador micro SD"
}
function menu_instalacion {
  echo "¿Cómo desea instalar el sistema operativo?"
  echo "1. Descargar e instalar"
  echo "2. Instalar desde el ordenador"
  echo "3. Cancelar"
}
function Descargar_Beagle {
  wget https://debian.beagleboard.org/images/bone-debian-8.7-lxqt-4gb-armhf-2017-03-19-4gb.img.xz
  unar bone-debian-8-lxqt-4gb-armhf-2017-03-19-4gb.img.xz
}
function Install_Beagle {
  sudo umount /dev/$2*
  echo "El siguiente proceso debe llevar de 15 a 20 minutos"
  sudo dd bs=1M if=$1 |pv|sudo dd of=/dev/"$2"
}
function Particion_Beagle {
  echo -e "n\n\n\n\n\nn\n\n\n\n\nw\n" | sudo fdisk /dev/"${1:0:7}"
  sudo mkfs.ext4 /dev/"$1"2
  sudo mkfs.ext4 /dev/"$1"3
  sudo mount -a
}
function Descargar_Raspbian {
  wget https://downloads.raspberrypi.org/raspbian_latest
  mv ~/raspbian_latest raspbian_latest.zip
  unzip ~/raspbian_latest.zip #enable vnc server without raspi-config
}
function Install_Raspbian {
  sudo umount /dev/"$1"*
  echo "El siguiente proceso debe llevar unos 15 a 20 minutos"
  sudo dd bs=4M if=~/2017-04-10-raspbian-jessie.img |pv|sudo dd of=/dev/"${1:0:7}"
}
function Particion_Raspbian {
  echo -e "n\n\n\n\n\nn\n\n\n\n\nw\n" | sudo fdisk /dev/${1:0:7}
  sudo mkfs.ext4 /dev/"$1"3
  sudo mkfs.ext4 /dev/"$1"4
  sudo mount -a
  usa= `ls /media/`
  usa=${usa:1}
  sudo mkdir /media/$usa/root && sudo mount -t /dev/"$1"1 /media/$usr/root
  cd /media/$usa/root && sudo touch ssh
  sudo umount /dev/"$1"* && sudo rmdir /dev/$usa/root
}
function config_VNC_Raspbian {
  x=$`arp -a`
  x=(${x// / })
  lar=${#x[@]}
  for (( i = 0; i < $lar; i++ )); do
    if [[ ${x[i]}=pi ]]; then
    IP=${x[i+1]}
    fi
  done
  ssh pi@$IP
  sudo apt-get update
  sudo apt-get install realvnc-vnc-server realvnc-vnc-viwer
  cd /home/pi
  cd .config
  sudo mkdir autostart && cd autostart
  sudo touch tightvnc.desktop
  echo -e "[Desktop Entry]\nType=Application\nName=TightVNC\nExec=vncserver :1\nStartupNotify=false" >> tightvnc.desktop
}
function config_VNC_Beagle {
	ssh root@192.168.7.2
      	sudo apt-get update
     	sudo apt-get upgrade
      	sudo apt update
      	sudo apt upgrade
      	sudo apt-get install xauth
      	sudo apt-get install x11-xserver-utils
      	sudo apt-get update
      	sudo apt-get install x11vnc
      	cd /etc/xinetd.d/ && touch x11vnc
      	echo -e "service x11vnc\n{\ntype = UNLISTED\ndisable = no\nsocket_type = stream\nprotocol = tcp\nwait = no\nuser = machinekit\nserver = /usr/bin/x11vnc\nserver_args = -inetd -o /home/machinekit/.x11vnc.log.%VNCDISPLAY -display :0 -forever -bg -rfbauth /home/machinekit/.vnc/passwd  -shared -enablehttpproxy -forever -nolookup -auth /home/machinekit/.Xauthority\nport = 5902\n}" >> x11vnc
	sudo chmod a+x /etc/xinetd.d/x11vnc
	sudo shutdown -h 0
}
clear
echo -e "\e[1;46;82m\t\t\tInstalación sistema operativo para placas de desarrollo beagle y rhaspberry en memoria micro SD.\n\t\t\t\t\t\t\tScript realizado por ing. Changua"
while [[ true ]]; do
  menu_inicio
  read acci
  while [[ true ]]; do
    case $acci in
      1)  menu_tarjeta
          read tarjeta
          case $tarjeta in
            1)  while [[ true ]]; do
                clear
                while [[ true ]]; do
                    menu_puerto
                    read M
                    case $M in
                       1) puerto="sdb"
                          break;;
                       2) puerto="mmcblk0p"
                          break;;
                       3) break;;
                       *) echo -e "por favor ingrese un numero entre 1,2 y 3\npresione enter para continuar"
                          read enter
                          clear;;
                    esac
                done
                menu_instalacion
                read instal
                case $instal in
                  1)  Descargar_Beagle
                      direccion=~/bone-debian-8.7-lxqt-4gb-armhf-2017-03-19-4gb.img
                      Install_Beagle $direccion ${"puerto:0:7"}
                      Particion_Beagle $puerto
                      break;;
                  2)  echo -e "ingrese la direccion de la imagen"
                      read direccion
                      Install_Beagle $direccion $puerto
                      Particion_Beagle $puerto
                      break;;
                  3)  break;;
                  *)  echo -e "Por favor elegir entre 1,2 o 3 \npresione enter para continuar"
                      read enter;;
                esac
              done;;
            2)  while [[ true ]]; do
                clear
                  while [[ true ]]; do
                    menu_puerto
                    M=$?
                    if [[ $M=1 ]]; then
                      puerto="sdb"
                      break
                    elif [[ $M=2 ]]; then
                      puerto="mmcblk0p"
                      break
                    fi
                  done
                  clear
                  menu_instalacion
                  instal=$?
                  case instal in
                     1) Descargar_Raspbian
                        direccion=~/2017-04-10-raspbian-jessie.img
                        Install_Raspbian $direccion $puerto
                        Particion_Raspbian $puerto
                        break;;
                     2) echo "Ingrese la direccion de la imagen"
                        read direccion
                        Install_Raspbian $direccion $puerto
                        Particion_Raspbian $puerto
                        break;;
                     3) break;;
                     *) echo -e "Por favor elegir entre 1,2 y 3\npresione enter para continuar"
                        read enter;;
                  esac
                done;;
            3)  break;;
            *)  echo -e "Por favor elegir entre 1,2 y3\npresione enter para continuar"
                read enter;;
          esac;;
          2)  menu_tarjeta
              read tarjeta
              case $tarjeta in
                  1)  config_VNC_Beagle
                      break;;
                  2)  config_VNC_Raspbian
                      break;;
              esac
              break;;
          3)  echo "Adios"
              exit;;
        esac
  done
done
