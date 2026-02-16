#!/bin/bash

CONF_FILE="/etc/httpd/conf.d/tuning.conf"
while true; do
    clear
    echo -e "\033[1;33m"
    echo "  █████╗ ██████╗  █████╗  ██████╗██╗  ██╗███████╗"
    echo " ██╔══██╗██╔══██╗██╔══██╗██╔════╝██║  ██║██╔════╝"
    echo " ███████║██████╔╝███████║██║     ███████║█████╗  "
    echo " ██╔══██║██╔═══╝ ██╔══██║██║     ██╔══██║██╔══╝  "
    echo " ██║  ██║██║     ██║  ██║╚██████╗██║  ██║███████╗"
    echo " ╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝"
    echo -e "\033[0m"
    echo " [1] Aplicar Configurações Básicas     [2] Restart com Validação"
    echo " [V] Voltar ao Menu Principal"
    echo " ------------------------------------------------------------"
    echo -e "\033[0m"
    read -p "[Admin]: " t_opt

    case ${t_opt,,} in
        1)
            echo -e "\n\033[1;33m[!] A configurar mod_deflate, KeepAlive e MaxClients...\033[0m"

            sudo bash -c "cat > $CONF_FILE" <<EOF
# Otimização
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript
</IfModule>

KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5
Timeout 60

<IfModule mpm_event_module>
    MaxRequestWorkers      400
</IfModule>

Listen 443 https
EOF
            echo -e "\033[1;32mConfigurações gravadas com sucesso!\033[0m"
            read -p "Pressiona [ENTER] para prosseguir..." ;;
            
        2)
            echo -e "\n\033[1;33m[!] A validar sintaxe e reiniciar Apache...\033[0m"
            # Validação e restart seguro
            if sudo apachectl configtest; then
                sudo systemctl restart httpd
                echo -e "\033[1;32mSintaxe OK! Apache reiniciado com sucesso.\033[0m"
            else
                echo -e "\033[1;31mERRO: Falha na sintaxe. O serviço não foi reiniciado.\033[0m"
            fi
            read -p "Pressiona [ENTER] para prosseguir..." ;;
            
        v) break ;;
        *) echo -e "\033[1;31mOpção inválida!\033[0m" ; sleep 1 ;;
    esac
done