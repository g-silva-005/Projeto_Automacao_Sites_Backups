#!/bin/bash
 
while true; do
        clear
        echo -e "\033[1;32m"
        echo "  ██████╗███████╗███╗   ██╗████████╗ ██████╗ ███████╗"
        echo " ██╔════╝██╔════╝████╗  ██║╚══██╔══╝██╔═══██╗██╔════╝"
        echo " ██║     █████╗  ██╔██╗ ██║   ██║   ██║   ██║███████╗"
        echo " ██║     ██╔══╝  ██║╚██╗██║   ██║   ██║   ██║╚════██║"
        echo " ╚██████╗███████╗██║ ╚████║   ██║   ╚██████╔╝███████║"
        echo "  ╚═════╝╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚══════╝"
        echo -e "\033[0m"
        echo " [A] Check PHP Engine                            [D] Static IP Config"
        echo " [B] Ativar ou Desativar portas de firewall      [E] RAID 10 Status"
        echo " [C] MariaDB Overview                            [F] Fail2Ban e SElinux"
		echo " [Q] Terminate "
        echo " ---------------------------------------------------"
        read -p ": " acao
        case $acao in
			a|A) 
			echo "---- A verificar se os módulos PHP de facto se encontram na Máquina ----"
			PHP_INI="/etc/php.ini"
			echo ""
			if [ -f "$PHP_INI" ]; then
				echo "---- Módulos instalados e ficheiro encontrado com sucesso! ----"
				sleep 1
				sudo tee -a $PHP_INI << END
				
 --- Configuracoes personalizadas via Script de Gestao ---
date.timezone = Europe/Lisbon
upload_max_filesize = 20M
post_max_size = 25M
memory_limit = 256M
 ---------------------------------------------------------	
END
				echo ""
				echo "---- Valores configurados e adicionados com sucesso ----"
				sleep 1
			else
				echo "---- ERRO: O ficheiro $PHP_INI não foi encontrado ----"
				echo "---- Não deves ter instalado os módulos PHP, volta para o menu de instalação (prime Q) e instala os módulos ----"
				read -p "! Pressione ENTER para voltar ao menu !"
				continue 
			fi 
			echo "---- Criação dos arquivos -----"
			echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php
			echo "---- A ajustar permissões -----"
			sudo chown apache:apache /var/www/html/info.php
			echo " ----- A reiniciar o apache para carregar o php -----"
			sudo chown apache:apache /var/www/html/info.php
			echo ""
			cat << END
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	!!!!!!!!!!!! PARA VER A INFO DO PHP ACEDA DESTE MODO:  !!!!!!!!!!!!!!!!
	!!!!!!!!!!!!!!!!!!!http://<seu-ip>/info.php!!!!!!!!!!!!!!!!!!!!!!!!!!!
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
END
		  read -p "! Pressione ENTER para continuar !"  
		  ;;
          b) 
		  echo ""
		  cat << END
Escolha, por favor, uma das seguintes opções:
1: Ativar porta/s 
2: Desativar porta/s
3: Sair 
END
			while true; do 
				read -p ": " w
				case $w in
					1)
					read -p "Ativar todas ou somente alguma porta em especifíco? Escreva todas (para ativar todas) ou alguma (para ativar apenas alguma porta em especifíco): " porta
					if [ $porta = todas ]; then
						echo "----- A ativar portas de firewall ------"
						sudo firewall-cmd --permanent --add-port=22/tcp
						sudo firewall-cmd --permanent --add-port=80/tcp
						sudo firewall-cmd --permanent --add-port=443/tcp
						echo "----- Todas as Portas ativadas com sucesso -----"
						break
					
					elif [ $porta = alguma ]; then
						echo ""
						cat << END
Selecione a porta que deseja ativar:
1: Porta 22
2: Porta 80
3: Porta 443
4: Sair do programa
END
						while true; do
							read -p ": " L
							case $L in 
							1)
							echo "----- A ativar porta de firewall ------"
							sudo firewall-cmd --permanent --add-port=22/tcp
							echo "----- Todas as Portas ativadas com sucesso -----"
							break
							;;
							2)
							echo "----- A ativar porta de firewall ------"
							sudo firewall-cmd --permanent --add-port=80/tcp
							echo "----- Todas as Porta ativadas com sucesso -----"
							break
							;;
							3)
							echo "----- A ativar porta de firewall ------"
							sudo firewall-cmd --permanent --add-port=443/tcp
							
							echo "----- Todas as Porta ativadas com sucesso -----"
							break
							;;
							4)
							echo ""
							echo "A sair do programa..."
							sleep 1
							;;
							*)
							echo "Escolha inválida, escreva todas ou alguma."
							;;
							esac
						done 
					else
						echo " A sair do programa..."
						break
						exit 0
					fi
					;;
					2)
					read -p "Por segurança, escreva o nome da porta que quer desativar (ssh, http, https): " desativar
					if [ $desativar = ssh ]; then
					echo "----- A desativar porta de firewall ------"
					sudo firewall-cmd --permanent --remove-port=22/tcp
					echo "----- A porta selecionada foi desativada com sucesso!  -----"
					elif [ $desativar = http ]; then
					echo "----- A desativar porta de firewall ------"
					sudo firewall-cmd --permanent --remove-port=80/tcp
					echo "----- A porta selecionada foi desativada com sucesso!  -----"
					elif [ $desativar = https ]; then
					echo "----- A desativar porta de firewall ------"
					sudo firewall-cmd --permanent --remove-port=443/tcp 
					echo "----- A porta selecionada foi desativada com sucesso!  -----"
					else
					echo "Selecione uma das opção disponiveis. ssh | http | https "
					fi
					;;
					3)
					echo "A sair do programa..."
					break
					exit 0
					;;
					*)
					cat <<- 'END'
					Opcção inválida! Selecione uma opção válida.
					1: Ativar porta/s 
					2: Desativar porta/s
					3: Sair
					END
					;;
				esac
				read -p "! Pressione ENTER para continuar !"  
			done
			;;
          c|C) sudo mariadb -u root -e "STATUS; SHOW DATABASES;" && read -p "! Pressiona ENTER para continuar";;
		  d|D)
            echo "---- Configuração de IP Estático ----"
            nmcli connection show
            read -p "Introduza o nome da interface (ex: ens160): " interface
            read -p "Introduza o IP desejado com / desejada (ex: 192.168.1.100/24): " ip_mask
            read -p "Introduza o Gateway (ex: 192.168.1.1): " gateway
            read -p "Introduza o DNS (ex: 8.8.8.8, 1.1.1.1): " dns
            echo "--- A aplicar configurações em $interface ---" 
            sudo nmcli connection modify "$interface" ipv4.addresses "$ip_mask"
            sudo nmcli connection modify "$interface" ipv4.gateway "$gateway"
            sudo nmcli connection modify "$interface" ipv4.dns "$dns"
            sudo nmcli connection modify "$interface" ipv4.method manual
            sudo nmcli connection up "$interface"
            echo "----------------------------------------------------"
            echo "Configuração aplicada! O novo IP é: $(hostname -I)"
            read -p "! Pressione ENTER para continuar !"
            ;;
		  e|E) lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS | grep --color=always -E "raid10|$" | sed 's/raid10/\x1b[31mraid10\x1b[0m/g' && read -p "! Pressiona ENTER para continuar";;
          q|Q) exit ;;
		  f|F)
			while true; do
				clear
				echo "--- Menu Fail2Ban e SElinux ---"
				echo "1: Opções do SElinux"
				echo "2: Opções do Fail2Ban"
				echo "3: Voltar ao Menu Principal"
				echo ""
				read -p ": " opcao
				case $opcao in
					1)
						echo "1: Ativar 'Enforcing' (Permanente)"
						echo "2: Monitorizar logs"
						echo "3: Voltar"
						read -p ": " w
						case $w in
							1)
								sudo setenforce 1
								sudo sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
								echo "SELinux definido para Enforcing."
								sleep 2
								;;
							2)  
								echo "----- A verificar ferramentas de logs -----"
								if rpm -q setroubleshoot-server &> /dev/null; then
									echo "Já instalou! A passar para o próximo menu..."
									sleep 2 
								else
									echo "----- A instalar as ferramentas necessárias para ver os logs -----"
									sudo dnf install setroubleshoot-server -y
									echo "Instalação concluída!"
								fi
								echo ""
								read -p "Nas logs, queres ver os alertas ou ver alguma falha? Escreve alerta (para ver os alertas) ou falha (para ver alguma falha): " logs 
								if [ $logs = alerta ]; then
									echo ""
									echo " ----- A apresentar alertas ----- "
									sudo sealert -a /var/log/audit/audit.log
								elif [ $logs = falha ]; then
									echo ""
									echo " ----- A apresentar falhas recentes ----- "
									sudo ausearch -m avc -ts recent
								else
									echo ""
									echo "Inseriste alguma coisa de errado. Tenta escrever alerta (para ver os alertas) ou falha (para ver alguma falha)."
								fi
								read -p "Pressione ENTER para voltar"
								;;
							3) break ;; 
						esac
						;;
					2)
						echo "1: Ativar a proteção"
						echo "2: Voltar"
						read -p ": " l
						case $l in
							1)
								
								sudo systemctl enable --now fail2ban
								read -p "Configurado! Pressione ENTER"
								;;
							2) break ;; 
						esac
						;;
					3) 
						break 
						;;
					*)
						echo "Opção inválida!"
						sleep 1
						;;
				esac
			done
			;;
		  *)
		  echo ""
		  echo "Opção inválida. Selecione uma opção válida!"
		  sleep 1 
		  read -p "! Pressione enter para voltar ao menu !" ;;
        esac
done
 
 