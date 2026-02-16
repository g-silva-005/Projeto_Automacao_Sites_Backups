while true; do
    clear
    echo -e "\033[1;35m" # Roxo para destacar que é o Segurança
    echo "  ██████╗███████╗███╗   ██╗████████╗ ██████╗ ███████╗"
    echo " ██╔════╝██╔════╝████╗  ██║╚══██╔══╝██╔═══██╗██╔════╝"
    echo " ██║     █████╗  ██╔██╗ ██║   ██║   ██║   ██║███████╗"
    echo " ██║     ██╔══╝  ██║╚██╗██║   ██║   ██║   ██║╚════██║"
    echo " ╚██████╗███████╗██║ ╚████║   ██║   ╚██████╔╝███████║"
    echo "  ╚═════╝╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚══════╝"
    echo -e "\033[0m"
    echo " [1] Atualizar o sistema   [3] Sincronizar hora"
    echo " [2] Verificar Logs        [4] Configurar Backup Semanal"
    echo " [Q] Terminar"
    echo " ----------------------------------------------------"
    read -p "[Admin]: " opt
    case ${opt,,} in
		1)
			echo "---- A iniciar as Atualizações ----"
			sleep 1
			sudo dnf update -y
			read -p "! Pressione ENTER para voltar ao menu !"
			;;
		2)
			echo "---- Logs de acesso APACHE (a mostrar as ultimas 10 linhas) ----"
			sudo tail -n 10 /var/log/httpd/access_log
			echo ""
			echo "---- Tentativas de login ----"
			sudo tail -n 10 /var/log/secure
			echo ""
			read -p "! Pressione ENTER para voltar ao menu !"
			;;
		3)
			echo "---- A iniciar sincronização de hora (CentOS 10) ----"
			sudo timedatectl set-timezone Europe/Lisbon
			if ! grep -q "pool.ntp.org" /etc/chrony.conf; then
				echo "server 0.pt.pool.ntp.org iburst" | sudo tee -a /etc/chrony.conf
				echo "server 1.pt.pool.ntp.org iburst" | sudo tee -a /etc/chrony.conf
			fi
			sudo systemctl restart chronyd
			sudo chronyc burst 4/4 > /dev/null 2>&1
			echo -n "[PROCESSO]: A validar servidores NTP "
			for i in {1..10}; do
				echo -n "."
				sleep 1
			done
			echo " [CONCLUÍDO]"
			sudo chronyc makestep > /dev/null 2>&1
			echo -e "\n\033[1;32m--- Resultado da Sincronização ---\033[0m"
			sudo chronyc tracking
			echo -e "\n\033[1;34m--- Estado das Fontes (Procura o símbolo '*') ---\033[0m"
			sudo chronyc sources
			echo -e "\nNota: Se vires ^?, aguarda mais 1 minuto. Se vires ^*, está perfeito!"
			read -p "! Pressione ENTER para continuar !"
			;;		
		4)
            echo "---- A configurar Agendamento (Cron) ----"
            SCRIPT_BACKUP="tar -czf /backup/www_$(date +\%F).tar.gz /var/www/html > /var/log/backup_exec.log 2>&1"     
            (crontab -l 2>/dev/null; echo "00 03 * * 0 $SCRIPT_BACKUP") | crontab -
			sleep 1
			echo ""
			echo "------------------------------------------------"
			echo "Sucesso: Backup agendado para Domingo às 03:00!"
			echo "Log de execução será guardado em: /var/log/backup_exec.log"
			echo "------------------------------------------------"
			read -p "! Pressione ENTER para voltar ao menu !"
		;;
		q|Q)
			break
			;;
		*)
			;;
	esac
done 
	