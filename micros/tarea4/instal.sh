#! /bin/bash
. inst.h

echo -e "\e[41m red"
clear
echo -e "\e[1m\t\t\t\t\t\t\t\tBIENVENIDOS\n\n"
echo -e "\e[1m \e[97m\t\tShell Script: Instalación de Sistema Operativo en memoria micro SD para BeagleBoard Black y Raspberry PI 3.\n\t\t\t\t\tCreadores: Deimer Andres Morales y Juan Camilo Montilla."
while [[ true ]]; do
  m_inicio
  read acci
  while [[ true ]]; do
    case $acci in
      1)  m_placa
          read tarjeta
          case $tarjeta in
            1)  while [[ true ]]; do
                clear
                while [[ true ]]; do
                    m_puerto
                    read M
                    case $M in
                       1) puerto="sdb"
                          break;;
                       2) puerto="mmcblk0p"
                          break;;
                       3) clear
			                    break;;
                       *) echo -e "por favor ingrese un numero entre 1,2 y 3\npresione enter para continuar"
                          read enter
                          clear;;
                    esac
                done
                m_instal
                read instal
                case $instal in
                  1)  Download_B
                      direccion=~/bone-debian-8.7-lxqt-4gb-armhf-2017-03-19-4gb.img
                      Install_B $direccion ${"puerto:0:7"}
                      Partition_B $puerto
                      break;;
                  2)  echo -e "ingrese la direccion de la imagen"
                      read direccion
                      Install_B $direccion $puerto
                      Partition_B $puerto
                      break;;
                  3)  clear
		      break;;
                  *)  echo -e "Por favor elegir entre 1,2 o 3 \npresione enter para continuar"
                      read enter;;
                esac
              done;;
            2)  while [[ true ]]; do
                clear
                  while [[ true ]]; do
                    m_puerto
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
                  m_instal
                  instal=$?
                  case instal in
                     1) Download_R
                        direccion=~/2017-04-10-raspbian-jessie.img
                        Install_R $direccion $puerto
                        Partition_R $puerto                       break;;
                     2) echo "Ingrese la direccion de la imagen"
                        read direccion
                        Install_R $direccion $puerto
                        Partition_R $puerto
                        break;;
                     3) clear
			break;;
                     *) echo -e "Por favor elegir entre 1,2 y 3\npresione enter para continuar"
                        read enter;;
                  esac
                done;;
            3)  clear
		            break;;
            *)  echo -e "Por favor elegir entre 1,2 y3\npresione enter para continuar"
                read enter;;
          esac;;
          2)  m_placa
              read tarjeta
              case $tarjeta in
                  1)  confg_VNC_B
                      break;;
                  2)  confg_VNC_R
                      break;;
              esac
	      clear
              break;;
          3)  echo -e "Adios\e[0m"
	      clear
              exit;;
        esac
  done
done
