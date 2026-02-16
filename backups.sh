#!/bin/bash
while true; do
    clear
    echo -e "\033[1;31m" 
    echo "  ██████╗  █████╗  ██████╗██╗  ██╗██╗   ██╗██████╗ ███████╗"
    echo "  ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██║   ██║██╔══██╗██╔════╝"
    echo "  ██████╔╝███████║██║     █████╔╝ ██║   ██║██████╔╝███████╗"
    echo "  ██╔══██╗██╔══██║██║     ██╔═██╗ ██║   ██║██╔═══╝ ╚════██║"
    echo "  ██████╔╝██║  ██║╚██████╗██║  ██╗╚██████╔╝██║     ███████║"
    echo "  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚══════╝"
    echo -e "\033[0m"

    echo " [1] Backup DB (Simples)           [3] Backup Incremental DB"
    echo " [2] Backup Web (Simples)          [4] Backup Incremental Web"
    echo " [V] Voltar ao Menu Principal"
    echo " ------------------------------------------------------------"
    read -p "[Admin]: " b_opt

    sudo mkdir -p /backups/web/incremental /backups/db/incremental /backups/logs

    case ${b_opt,,} in
        1)
            echo "A iniciar backup simples da MariaDB..."
            sudo sh -c "mysqldump -u root -p --all-databases | gzip > /backups/db/db_full.sql.gz"
            echo "Sucesso! Backup guardado em /backups/db/" ;;
        2)
            echo "A iniciar backup simples do WordPress..."
            sudo rsync -av --delete /var/www/html/ /backups/web/site_full/ > /dev/null
            echo "Sucesso! Backup guardado em /backups/web/" ;;
        3)
            echo "A iniciar Backup Incremental da DB..."
            sudo sh -c "mysqldump -u root -p --all-databases | gzip > /backups/db/incremental/db_inc_$(date +%F).sql.gz"
            echo "Backup guardado em /backups/db/incremental/" ;;
        4)
            echo "A iniciar Backup Incremental Web (Apenas alterados)..."
            sudo rsync -av --delete /var/www/html/ /backups/web/incremental/ > /dev/null
            echo "Sincronização concluída em /backups/web/incremental/" ;;
        v) break ;;
        *) echo "Opção inválida!" ; sleep 1 ;;
    esac

    echo -e "\n\033[1;32mESTRUTURA DE BACKUPS NO RAID 10:\033[0m"
    ls -R /backups | grep "/backups" 
    echo "------------------------------------------------------------"
    read -p "! ENTER para continuar..."
done