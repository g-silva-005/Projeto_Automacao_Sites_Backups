#!/bin/bash
 
while true; do
    clear
    echo -e "\033[1;33m" # Amarelo para destacar que é o Setup
    echo "  ██████╗███████╗███╗   ██╗████████╗ ██████╗ ███████╗"
    echo " ██╔════╝██╔════╝████╗  ██║╚══██╔══╝██╔═══██╗██╔════╝"
    echo " ██║     █████╗  ██╔██╗ ██║   ██║   ██║   ██║███████╗"
    echo " ██║     ██╔══╝  ██║╚██╗██║   ██║   ██║   ██║╚════██║"
    echo " ╚██████╗███████╗██║ ╚████║   ██║   ╚██████╔╝███████║"
    echo "  ╚═════╝╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚══════╝"
    echo -e "\033[0m"
    echo " [1] Instalar Módulos PHP   [B] Menu de Backup"
    echo " [2] Instalar FAIL2BAN      [G] Menu De Gestão"
    echo " [T] Tuning apache 		  [S] Menu de Manutenção"
	echo " [Q] Sair   "
    echo " ----------------------------------------------------"
    read -p "[Admin]: " opt
    case ${opt,,} in
        1) echo "A instalar módulos PHP..." 
		sudo dnf install php php-mysqlnd php-cli -y
		echo "----- PHP e os seus módulos necessários instalados com sucesso ! -----"
		echo ""
		read -p "! ENTER para continuar..." 
		;;
        2) echo "A instalar Fail2Ban..." && sudo dnf install -y epel-release && sudo dnf install -y fail2ban && sudo systemctl enable --now fail2ban && read -p "! ENTER para continuar..."
		;;
        b|B)
		echo ""
		~/scripts/backups.sh
		;;
        g|G) ~/scripts/gestao.sh ;;
        q|Q) exit ;;
		s|S) ~/scripts/seguranca.sh ;;
		t|T) ~/scripts/tuning_apache.sh ;; 
        *) ;;
    esac
done
 