# ez-debian-server
Installation automatisée et personnalisée d'un serveur Debian 

# Présentation 
ce script bash permet de configurer simplement un serveur Debian de manière interactive.
PS: Des goodies comme l'installatiion et la configuraition de apache2, nginx, mariadb,  vsftpd, iptables, shorewall, fail2ban, postfix, webbmin, wordpress, glpi.

## le menu de départ

echo "--------------------------------------------------"
echo " Bienvenue dans ce script de configuration global "
echo "--------------------------------------------------"
echo "[1] - Réseau"
echo "[2] - Nom d'hôte, FQDN"
echo "[3] - Mettre à jour le système"
echo "[4] - Sécuriser le serveur"
echo "[5] - Utilisateurs, droits et propriété"
echo "[6] - Installer/Désinstaller un programme"
echo "[7] - Site internet/intranet - SSL"
echo "[8] - Partitionnement"
echo "[9] - Programmes divers"
echo "--------------------------------------------------"
echo "[q] - QUITTER"

## Configuration du réseau
        echo "------------------------------"
        echo "#       Accès au réseau      #"
        echo "------------------------------"
        echo "[1] - Configurer le DNS"
        echo "[2] - Accès au réseau"
        echo "------------------------------"
        echo "[r] - RETOUR AU MENU PRECEDENT"
        echo "------------------------------"
        echo "Entrez le numéro du menu voulu"

## Configurer la sécurité du serveur
 echo "---------------------------------------"
            echo "#         Sécuriser le serveur        #"       
            echo "---------------------------------------"
            echo "[1] - Configurer SSH"
            echo "[2] - Configurer le Pare-feu"
            echo "[3] - Mettre en place fail2ban"
            echo "--------------------------------------"
            echo "[r] - RETOUR AU MENU PRECEDENT"
            echo "--------------------------------------"
            echo "Entrez le numéro du menu voulu"

## Configuration du Pare-feu
                    echo "---------------------------------------------"
                    echo "##         Configurer le Pare-feu          ##"
                    echo "---------------------------------------------"
                    echo "[1] - Mettre en place le pare-feu Shorewall"
                    echo "[2] - Rajouter/Enlever des règles au pare-feu"
                    echo "[3] - Désactiver/réactiver le pare-feu" 
                    echo "---------------------------------------------"
                    echo "[4] - Mettre en place le pare-feu iptables"
                    echo "---------------------------------------------"
                    echo "[r] - RETOUR AU MENU PRECEDENT"
                    echo "---------------------------------------------"
                    echo "Entrez le numéro du menu voulu"
                    
## Gestion des utilisateurs
        echo "--------------------------------------"
        echo "[1] - Vérifier l'existence d'un utilisateur"
        echo "[2] - Afficher la liste des utilisateurs"
        echo "[3] - Afficher la liste des groupes"
        echo "[4] - Voir le(s) groupe(s) auquel appartient un utilisateur"
        echo "--------------------------------------"
        echo "[5] - Créer un utilisateur"
        echo "[6] - Créer un groupe"
        echo "[7] - Ajouter/Retirer un utilisateur à un groupe"
        echo "--------------------------------------"
        echo "[8] - Changez les droits d'un utilisateur sur un dossier/fichier"
        echo "[9] - Rendre un utilisateur propriétaire d'un dossier/fichier"
        echo "--------------------------------------"
        echo "[r] - RETOUR AU MENU PRECEDENT"
        echo "--------------------------------------"
        
## gestion des sites internet/intranet et du SSL
        echo "-------------------------------------------------------"
        echo "#         Site internet/intranet - SSL                #"
        echo "-------------------------------------------------------"        
        echo "[1] - Configurer un site en http sur apache2"
        echo "[2] - Configurer un site en http sur Nginx"
        echo "[3] - Consigurer un site wordpress en http sur apache2"
        echo "[4] - Configurer un GLPI en http sur apache2"
        echo "-------------------------------------------------------"
        echo "[5] - Configurer un site en https sur apache2"
        echo "[6] - Configurer un site en https sur nginx"
        echo "[7] - Configurer un site wordpress en https sur apache2"
        echo "-------------------------------------------------------"
        echo "[8] - Générer une clef privée SSL et une demande de signature"
        echo "-------------------------------------------------------"
        echo "[r] - RETOUR AU MENU PRECEDENT"
        echo "-------------------------------------------------------"
