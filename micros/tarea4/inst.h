#!/bin/bash
function m_inicio {
  echo -e "Bienvenido a instalacion y configuracion de placas de desarrollo"
  echo -e "¿Qué desea realizar?"
  echo -e "1. Instalar"
  echo -e "2. Configurar"
  echo -e "3. Salir"
  echo -n ": "
}
function m_placa {
  echo -e "¿Qué tarjeta posee"
  echo -e "1. Perro"
  echo -e "2. Mora"
  echo -e "3. Cancelar"
  echo -n ": "
}
function m_puerto {
  echo "¿Qué puerto va usar?"
  echo "1. USB"
  echo "2.Adaptador micro SD"
}
function m_instal {
  echo "¿Cómo desea instalar el sistema operativo?"
  echo "1. Descargar e instalar"
  echo "2. Instalar desde el ordenador"
  echo "3. Cancelar"
}
function Download_B {
  wget https://debian.beagleboard.org/images/bone-debian-8.7-lxqt-4gb-armhf-2017-03-19-4gb.img.xz
  unar bone-debian-8-lxqt-4gb-armhf-2017-03-19-4gb.img.xz
}
function Instal_B {
  sudo umount /dev/$2*
  echo "El siguiente proceso debe llevar de 15 a 20 minutos"
  sudo dd bs=1M if=$1 |pv|sudo dd of=/dev/"$2"
}
function Partition_B {
  echo -e "n\n\n\n\n\nn\n\n\n\n\nw\n" | sudo fdisk /dev/"${1:0:7}"
  sudo mkfs.ext4 /dev/"$1"2
  sudo mkfs.ext4 /dev/"$1"3
  sudo mount -a
}
function Download_R {
  wget https://downloads.raspberrypi.org/raspbian_latest
  mv ~/raspbian_latest raspbian_latest.zip
  unzip ~/raspbian_latest.zip #enable vnc server without raspi-config
}
function Install_R {
  sudo umount /dev/"$1"*
  echo "El siguiente proceso debe llevar unos 15 a 20 minutos"
  sudo dd bs=4M if=~/2017-04-10-raspbian-jessie.img |pv|sudo dd of=/dev/"${1:0:7}"
}
function Partition_R {
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
function Confg_VNC_R {
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
function Conf_VNC_B {
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
