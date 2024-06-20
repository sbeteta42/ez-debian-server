#!/bin/bash
clear
iprinc=0
while [ $iprinc -lt 24 ]; do
clear
echo "--------------------------------------------------"
echo "              EASY DEBIAN SERVER                  "
echo "              sbeteta@beteta.org                  "
echo "--------------------------------------------------"
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
echo "--------------------------------------------------"
echo "Entrez le numéro du menu voulu"
read choix
if [ "$choix" == "1" ]; then
        clear
        j=0
        while [ $j -lt 24 ]; do
        clear
        echo "------------------------------"
        echo "#       Accès au réseau      #"
        echo "------------------------------"
        echo "[1] - Configurer le DNS"
        echo "[2] - Accès au réseau"
        echo "------------------------------"
        echo "[r] - RETOUR AU MENU PRECEDENT"
        echo "------------------------------"
        echo "Entrez le numéro du menu voulu"
        read choix11
        case "$choix11" in
            "1")
                clear
                echo "--------------------------------------"
                dnsactuel=`cat /etc/resolv.conf`
                echo "Votre DNS actuel est :"
                echo "$dnsactuel"
                echo "--------------------------------------"
                echo "Voulez-vous changer votre DNS ? [o/n]"
                read adns
                if [ "$adns" == "o" ]; then
                    echo "--------------------------------------"
                    echo "Entrez l'IP du DNS voulu (exemple : 1.1.1.1)"
                    read dnsserv
                    echo "nameserver $dnsserv" > /etc/resolv.conf
                    echo "--------------------------------------"
                    echo "Le DNS $dnsserv a bien été changé"
                    sleep 2s
                    clear
                fi
            ;;
            "2")
                clear
                echo "--------------------------------------"
                echo "Voulez-vous entrer une configuration IP statique ? [o/n]"
                read statc
                if [ "$statc" == "o" ]; then
                    clear
                    echo "--------------------------------------"
                    echo "j'ai exécuté pour vous la commande 'ip a' ci-dessous, pour vous aider à repérer le nom de l'interface réseau sur laquelle vous voulez appliquer le changement"
                    echo "--------------------------------------"
                    ip a
                    echo "--------------------------------------"
                    echo "Quel est le nom de votre interface réseau ? (exemple courrant : enp0s3 ...)"
                    read nintfx
                    echo "--------------------------------------"
                    echo "Entrez l'adresse IP voulue (exemple : 192.168.2.1)"
                    read ipstat
                    echo "--------------------------------------"
                    echo "Entrez le masque associé (exemple : 255.255.255.0)"
                    read maskstat
                    echo "--------------------------------------"
                    echo "Entrez la passerelle"
                    read gatestat
                    echo "# The loopback network interface" > /etc/network/interfaces.d/conf-script
                    echo "auto lo" >> /etc/network/interfaces.d/conf-script
                    echo "iface lo inet loopback" >> /etc/network/interfaces.d/conf-script
                    echo "#" >> /etc/network/interfaces.d/conf-script
                    echo "# The Primary network interface" >> /etc/network/interfaces.d/conf-script
                    echo "allow-hotplug $nintfx" >> /etc/network/interfaces.d/conf-script
                    echo "iface $nintfx inet static" >> /etc/network/interfaces.d/conf-script
                    echo "address $ipstat" >> /etc/network/interfaces.d/conf-script
                    echo "netmask $maskstat" >> /etc/network/interfaces.d/conf-script
                    echo "gateway $gatestat" >> /etc/network/interfaces.d/conf-script
                    ifdown $nintfx && ifup $nintfx
                    exit 0
                fi
                clear
                echo "--------------------------------------"
                echo "Voulez-vous que la configuration se fasse par DHCP ? [o/n]"
                read statc2
                if [ "$statc2" == "o" ]; then
                    clear
                    echo "--------------------------------------"
                    echo "j'ai exécuté pour vous la commande 'ip a' ci-dessous, pour vous aider à repérer le nom de l'interface réseau sur laquelle vous voulez appliquer le changement"
                    echo "--------------------------------------"
                    ip a
                    echo "--------------------------------------"
                    echo "Quel est le nom de votre interface réseau ? (exemple courrant : enp0s3 ...)"
                    read nintfx
                    echo "# The loopback network interface" > /etc/network/interfaces.d/conf-script
                    echo "auto lo" >> /etc/network/interfaces.d/conf-script
                    echo "iface lo inet loopback" >> /etc/network/interfaces.d/conf-script
                    echo "#" >> /etc/network/interfaces.d/conf-script
                    echo "# The Primary network interface" >> /etc/network/interfaces.d/conf-script
                    echo "allow-hotplug $nintfx" >> /etc/network/interfaces.d/conf-script
                    echo "iface $nintfx inet dhcp" >> /etc/network/interfaces.d/conf-script
                    echo "--------------------------------------"
                    echo "Voulez-vous redémarrer maintenant pour activer votre configuration ? [o/n]"
                    read astart
                        if [ "$astart" == "o" ] ; then
                            reboot
                        fi
                fi
            ;;
            "r")
                j=$((j+25))
            ;;
        esac
        done
iprinc=$((iprinc+1))
fi
if [ "$choix" == "2" ]; then
            i2=0
            while [ $i2 -lt 24 ]; do
            clear
            echo "--------------------------------------"
            echo "Votre nom d'hôte actuel est :"
            hostname
            echo "--------------------------------------"
            echo "Souhaitez-vous le modifier ? [o/n]"
            read hstm
                if [ "$hstm" == "o" ]; then
                    echo "Entrez votre nouveau nom d'hôte ?"
                    read nhstm
                    echo "$nhstm" > /etc/hostname
                    hostvar="$nhstm"
                fi
                if [ "$hstm" == "n" ]; then
                    hostvar=`hostname`
                fi
            echo "--------------------------------------"
            echo "Souhaitez-vous modifier votre FQDN ? [o/n]"
            read fqdna
            actualip=`hostname -I`
                if [ "$fqdna" == "o" ]; then
                    echo "Entrez votre nouveau FQDN"
                    read fqdnname
                    echo "127.0.0.1 localhost" > /etc/hosts
                    echo "$actualip $hostvar $fqdnname" >> /etc/hosts
                    echo "# The following lines are desirable for IPv6 capable hosts" >> /etc/hosts
                    echo "::1     localhost ip6-localhost ip6-loopback" >> /etc/hosts
                    echo "ff02::1 ip6-allnodes" >> /etc/hosts
                    echo "ff02::2 ip6-allrouters" >> /etc/hosts
                fi
            echo "--------------------------------------"
            echo "Vous devez à présent redémarrer pour appliquer le changement"
            echo "Souhaitez-vous redémarrer dès maintenant ? [o/n]"
            read redm
            case $redm in
                o)
                    reboot
                ;;
                n)
                    clear
                    break
                ;;
            esac
            done
iprinc=$((iprinc+1))
fi
if [ "$choix" == "3" ]; then
        apt update && apt upgrade -y
        clear
        echo "--------------------------------------"
        echo "La mise à jour est terminée"
        sleep 2s
iprinc=$((iprinc+1))
fi
if [ "$choix" == "4" ]; then
            i4=0
            while [ $i4 -lt 24 ]; do
            clear
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
            read choix4
            case "$choix4" in
                "1")
                    clear
                    apt install openssh-server -y
                    systemctl start sshd && systemctl enable sshd
                    clear
                    echo "--------------------------------------"
                    echo "Il s'agît d'un script de configuration basique"
                    echo "--------------------------------------"
                    echo "Voulez-vous vous générer une clef publique pour que ce serveur puisse se connecter sans mot de passe à un autre serveur ? [o/n]"
                    read cp
                    mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
                    if [ "$cp" == "o" ]; then
                        ssh-keygen -t ed25519
                        wait
                        echo "Votre clef publique a été générée"
                        echo "--------------------------------------"
                        echo "Souhaitez-vous l'envoyer à un autre serveur ? [o/n]"
                        echo "L'envoi se fait par ssh-copy-id. Si le serveur de destination n'est pas compatible, mieux vaut répondre [n] et le faire vous-même via scp.. je rajouterai cette fonction plus tard"
                        read akpsd
                            case "$akpsd" in
                                "o")
                                    echo "--------------------------------------"
                                    echo "Entrez le chemin absolu de la clef publique à transmettre"
                                    echo "le chemin par défaut généré par le script est /root/.ssh/id_ed25519.pub." 
                                    echo "Entrez celui-ci en entier si c'est le cas, sinon entrez un autre chemin"
                                    read kppath
                                    echo "--------------------------------------"
                                    echo "Entrez l'adresse IP du serveur distant"
                                    read ipdist
                                    echo "--------------------------------------"
                                    echo "Entrez le port d'accès au serveur distant (exemple : 22, 52333 ...)"
                                    read pdist
                                    echo "--------------------------------------"
                                    echo "Entrez l'utilisateur sur le serveur distant"
                                    read updist
                                    echo "--------------------------------------"
                                    ssh-copy-id -p $pdist -i $kppath $updist@$ipdist
                                    wait
                                    echo "--------------------------------------"
                                    clear
                                ;;
                                "n")
                            esac
                    fi       
                    echo "#### CONFIG SSH SCRIPT ####" > /etc/ssh/sshd_config
                    echo "--------------------------------------"
                    echo "Voulez-vous activer la connexion par clé publique sur ce serveur ? [o/n]"
                    read keyp
                    if [ "keyp" == "o" ]; then
                        echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
                    fi
                    echo "--------------------------------------"
                    echo "Voulez-vous interdire les connexions par mot de passe ? [o/n]"
                    read apd
                    if [ "$apd" == "o" ]; then
                        echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
                    fi
                    echo "--------------------------------------"
                    echo "Voulez-vous changer le numéro de port de connexion ? [o/n]"
                    read op
                    if [ "$op" == "o" ]; then
                        echo "Quel numéro de port voulez-vous ? (exemple : 52333)"
                        read portn
                        echo "Port $portn" >> /etc/ssh/sshd_config
                    fi
                    echo "--------------------------------------"
                    echo "Voulez-vous désactiver la connexion par root ? [o/n]"
                    read np
                    if [ "$np" == "o" ]; then
                        echo "PermitRootLogin no" >> /etc/ssh/sshd_config
                    fi
                    echo "--------------------------------------"
                    echo "Voulez-vous configurer un nombre maximal de tentatives de connexions échouées par IP ? [o/n]"
                    read ntt
                    if [ "$ntt" == "o" ]; then
                        echo "Combien de tentatives échouées au maximum ?"
                        read nttm
                        echo "MaxAuthTries $nttm" >> /etc/ssh/sshd_config
                    fi
                    echo "--------------------------------------"
                    echo "Voulez-vous configurer un nombre maximal de sessions simultanées ? [o/n]"
                    read ss
                    if [ "$ss" == "o" ]; then
                        echo "Combien de sessions ?"
                        read ssn
                        echo "MaxSessions $ssn" >> /etc/ssh/sshd_config
                    fi
                    echo "--------------------------------------"
                    echo "Voulez-vous interdire un ou plusieurs utilisateur(s) de se connecter au serveur ? [o/n]"
                    read forba
                    case $forba in 
                        o)
                            echo "--------------------------------------"
                            echo "Voici la liste des utilisateurs pour vous aider à vérifier leur existance"
                            echo "Tappez la lettre q pour quitter cette liste et revenir au script"
                            compgen -u | less
                            echo "--------------------------------------"
                            echo "Inscrivez le(s) nom(s) de(s) (l')utilisateur(s) que vous souhaitez voir interdits de connexion. Dans le cas d'utilisateurs multiples, espacez chaque nom"
                            echo "(exemple : pierre roger admin)"
                            read forbuser
                            echo "DenyUsers $forbuser" >> /etc/ssh/sshd_config
                        ;;
                        n)
                        ;;
                    esac
                    echo "--------------------------------------"
                    echo "Voulez-vous préciser l(es) utilisateur(s) seuls autorisés à se connecter en SSH ? [o/n]"
                    read anauths
                    case $anauths in
                        o)
                            echo "--------------------------------------"
                            echo "Veuillez entrer le(s) nom(s) de(s) utilisateur(s) seuls autorisés à se connecter en ssh".
                            echo "Dans le cas de plusieurs utilisateurs, espacez les noms"
                            echo "(exemple : adminWEB antoine roger marcel)"
                            read usallowssh
                            echo "AllowUsers $usallowssh" >> /etc/ssh/sshd_config
                        ;;
                        n)
                        ;;
                    esac
                    clear
                    echo "--------------------------------------"
                    echo "Voulez-vous n'autoriser qu'une/plusieurs IP à se connecter en SSH ? [o/n]
                    read ipans"
                        if [ "$ipans" == "o" ]; then
                            echo "Entrez le(s) IP(s) que vous souhaitez voir autorisées seules à ce connecter"
                            echo "(espacez les IP dans le cas de plusieurs IP)"
                            read allipad
                            echo "AddressFamily $allipad" >> /etc/ssh/sshd_config
                        fi
                    systemctl restart sshd
                    clear
                    echo "La configuration est effective"
                    sleep 2s
                    i4=$((i4+1))
                    clear
                ;;
                "2")
                    k=0
                    while [ $k -lt 24 ]; do
                    clear
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
                    read choix42
                    case "$choix42" in
                        "1")
                            apt install shorewall -y
                            clear
                            echo "--------------------------------------"
                            echo "j'ai exécuté pour vous la commande 'ip a' ci-dessous, pour vous aider à repérer le nom de l'interface réseau sur laquelle vous voulez appliquer des règles de pare-feu"
                            echo "--------------------------------------"
                            ip a
                            echo "--------------------------------------"
                            echo "Quel est le nom de votre interface réseau ? (exemple courrant : enp0s3 ...)"
                            read nintfx
                            echo "net ipv4" >> /etc/shorewall/zones
                            echo "fw firewall" >> /etc/shorewall/zones
                            echo "net $nintfx detect" >> /etc/shorewall/interfaces
                            echo "fw net ACCEPT" >> /etc/shorewall/policy
                            echo "net all DROP info" >> /etc/shorewall/policy
                            echo "all all REJECT info" >> /etc/shorewall/policy
                            echo "--------------------------------------"
                            echo "Par défaut, je rejetterai tous les paquets en provenance de ports que vous n'aurez pas spécifié."
                            i=0
                            while [ $i -lt 24 ]; do
                                echo "--------------------------------------"
                                echo "Veuillez entrer le numéro de port et son protocole associé que vous souhaitez autoriser, en suivant l'un des modèles ci-dessous :"
                                echo "tcp 80   'ou'   udp 53"
                                read portnumbpc
                                echo "ACCEPT all fw $portnumbpc" >> /etc/shorewall/rules
                                k=$((k+1))
                                echo "--------------------------------------"
                                echo "Souhaitez-vous ajouter un autre port ? [o/n]"
                                read anajout
                                    if [ "$anajout" == "n" ]; then
                                        k=$((k+25))
                                    fi
                            done
                            systemctl restart shorewall && systemctl enable shorewall
                            clear
                            echo "--------------------------------------"
                            echo "La configuration du pare-feu est effective"
                            sleep 2s
                            k=$((k+1))
                            clear
                        ;;
                        "2")
                            clear
                            echo "--------------------------------------"
                            echo "Voici les règles présentes :"
                            cat /etc/shorewall/rules
                            echo "--------------------------------------"
                            echo "Souhaitez-vous ajouter [o] ou ôter une règle [n] ?"
                            read ajrsh
                            case "$ajrsh" in
                                "o")
                                    echo "--------------------------------------"
                                    echo "Veuillez entrer le numéro de port et son protocole associé que vous souhaitez autoriser, en suivant l'un des modèles ci-dessous :"
                                    echo "tcp 80   'ou'   udp 53"
                                    read portumbpc
                                    echo "ACCEPT all fw $portumbpc" >> /etc/shorewall/rules
                                    systemctl restart shorewall
                                    i=$((i+1))
                                    echo "--------------------------------------"
                                    echo "La règle a bien été ajoutée"
                                    sleep 2s
                                    clear
                                ;;
                                "n")
                                    echo "--------------------------------------"
                                    echo "Veuillez entrer le numéro de port et son protocole associé que vous souhaitez retirer, en suivant l'un des modèles ci-dessous :"
                                    echo "tcp 80   'ou'   udp 53"
                                    read portnub
                                    sed -i "s/ACCEPT all fw $portnub//" /etc/shorewall/rules
                                    systemctl restart shorewall
                                    k=$((k+1))
                                    echo "--------------------------------------"
                                    echo "La règle a bien été ajoutée"
                                    sleep 2s  
                                    clear                          
                                ;;
                            esac
                        ;;
                        "3")
                            clear
                            echo "--------------------------------------"
                            echo "Voulez-vous arrêter [o] ou redémarrer le pare-feu [n] ?"
                            read recsh
                            case "$recsh" in
                                "o")
                                    systemctl stop shorewall
                                    k=$((k+1))
                                    clear
                                    echo "--------------------------------------"
                                    echo "Le pare-feu a bien été arrêté"
                                    sleep 2s
                                    clear
                                ;;
                                "n")
                                    systemctl restart shorewall
                                    k=$((k+1))
                                    clear
                                    echo "--------------------------------------"
                                    echo "Le pare-feu a bien été redémaré"
                                    sleep 2s
                                    clear
                                ;;
                            esac
                        ;;
                        "4")
                            clear
                            echo "--------------------------------------"
                            echo "Vous devez disposer d'une connexion internet pour éxecuter ce script."
                            echo "Vous devez vous tenir prêt à entrer vos règles de pare-feu, l'ajout ultérieur de règles devra être fait manuellement."
                            echo "--------------------------------------"
                            echo "AVERTISSEMENT SANS FRAIS : si vous utilisez une connexion SSH pour vous connecter à ce serveur, n'oubliez surtout pas de créer la règle d'entrée lors de la création de vos règles dans ce script ou vous perdrez l'accès au serveur !!"
                            echo "Je vous recommande vivement de configurer sshd_config AVANT de continuer ce script"
                            echo "--------------------------------------"
                            echo "Souhaitez-vous continuer ? [o/n]"
                            read choix
                            case $choix in
                                o)
                                ;;
                                n) 
                                    k=$((k+1))
                                ;;
                            esac
                            clear 
                            echo "--------------------------------------"
                            echo "Il est vivement recommandé d'utiliser un gros DNS type Cloudflare (1.1.1.1) pour les installations sous Linux et BSD"
                            echo "Ce script ne vérifie pas votre connexion internet, ni la bonne installation des paquets (d'où cette recommandation)"
                            echo "Voulez-vous changer le DNS actuel de votre serveur pour Cloudflare ? [o/n]"
                            read choix0
                            case $choix0 in
                                o)
                                    echo "nameserver 1.1.1.1" > /etc/resolv.conf
                                ;;
                                n)
                                ;;
                            esac

                            clear
                            echo "--------------------------------------"
                            echo "Nous installons iptables, veuillez patienter"
                            sleep 1

                            apt remove --auto-remove nftables -y
                            apt purge nftables -y
                            apt update
                            apt install iptables -y

                            clear
                            echo "--------------------------------------"
                            echo "Je vais vous afficher les interfaces réseau présentes sur ce serveur"
                            echo "Veuillez noter leur nom (exemple : enp0s3, enp0s8 etc...) pour la configuration à venir des règles"
                            echo         "--------------------------------------"
                            echo "Appuyez sur ENTRER pour afficher ip a"
                            read choix2

                            ip a

                            echo "--------------------------------------"
                            echo "Appuyez sur ENTRER lorsque vous avez noté ces noms"
                            read choix3

                            clear
                            echo "--------------------------------------"
                            echo "Souhaitez-vous autoriser le trafic sur l'interface de bouclage ? [o/n]"
                            echo "(vivement recommandé si vous utilisez SQL)"
                            read choix4
                            case $choix4 in
                                o)
                                    iptables -A INPUT -i lo -j ACCEPT
                                ;;
                                n)
                                ;;
                            esac

                            # Ajout par défaut de la règle autorisant les connexions établies et relatives
                            iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

                            clear
                            echo "--------------------------------------"
                            echo "Par défaut, ce script vous propose d'écrire uniquement les règles autorisants les flux entrants sur votre serveur (par exemple les flux http et https pour un serveur web)."
                            echo "Il autorisera par défaut tous les flux sortants du serveur (vous devrez, si nécessaire, configurer manuellement vous-même des règles bloquantes dans ce sens après l'exécution de ce script)"
                            echo "En ce qui concerne le forwarding et d'autres options plus avancées, elles resteront à configurer manuellement, après l'exécution de ce script"
                            echo "Lorsque vous aurez terminé d'ajouter vos règles dans ce script, le pare-feu sera refermé, et tout autre flux sera rejeté"
                            echo "--------------------------------------"
                            echo "SECOND AVERTISSEMENT SANS FRAIS : N'oubliez pas la règle SSH !!!"
                            echo "--------------------------------------"
                            echo "Appuyez sur ENTRER pour commencer à écrire vos règles"
                            read choix5

                            i=1
                            while [ $i -lt 150 ]; do 
                                clear
                                echo "--------------------------------------"
                                echo "Pour ajouter une règle d'entrée de flux sur votre serveur, veuillez tout d'abord entrer le nom de l'interface réseau concernée"
                                read intname
                                echo "--------------------------------------"
                                echo "Veuillez entrer le protocole concerné"
                                echo "(exemple : tcp ou udp)"
                                read prot
                                echo "--------------------------------------"
                                echo "Veuillez entrer le numéro de port concerné"
                                echo "(exemple : 22)"
                                echo "(pour l'étendue de ports comprise entre 6000 et 6050, tapez 6000:6050"
                                read portn
                                
                                iptables -A INPUT -i $intname -p $prot --dport $portn -j ACCEPT
                                
                                echo "--------------------------------------"
                                echo "Votre règle est en place"
                                echo "Voulez-vous en ajouter une autre ? [o/n]"
                                read choix6
                                case $choix6 in
                                    o)
                                        i=$((i+1))
                                    ;;
                                    n)
                                        i=$((i+150))
                                    ;;
                                esac
                            done

                            clear
                            echo "--------------------------------------"
                            echo "Je referme à présent le pare-feu"
                            sleep 2

                            iptables -P INPUT DROP
                            iptables -P FORWARD DROP
                            iptables -P OUTPUT ACCEPT

                            clear
                            echo "--------------------------------------"
                            echo "Voulez-vous rendre cette configuration persistante ? [o/n]"
                            echo "(autrement vos règles auront disparu au redémarrage du serveur)"
                            read choix7
                            case $choix7 in
                                o)
                                    echo "--------------------------------------"
                                    echo "Veuillez répondre OUI lorsque la fenêtre apparaîtra"
                                    sleep 3
                                    apt install iptables-persistent -y
                                ;;
                                n)
                                ;;
                            esac

                            clear
                            echo "--------------------------------------"
                            echo "Votre pare-feu est en place"
                            sleep 2
                            clear
                            k=$((k+1))
                        ;;
                        "r")
                            break
                        ;;
                    esac
                    done
                ;;
                "3")
                    clear
                    echo "--------------------------------------"
                    echo "Vous devez disposer d'une connexion internet pour exécuter ce script."
                    echo "Vous devez avoir préalablement installé iptables sur votre serveur (voir le script concerné) avant d'exécuter ce script"
                    echo "--------------------------------------"
                    echo "Souhaitez-vous continuer ? [o/n]"
                    read choix
                    case $choix in
                        o)
                        ;;
                        n) 
                            i4=$((i4+1))
                        ;;
                    esac

                    clear
                    echo "--------------------------------------"
                    echo "Nous installons fail2ban, patience"
                    printf "\n"
                    sleep 2
                    apt install fail2ban -y
                    systemctl start fail2ban && systemctl enable fail2ban

                    echo "[DEFAULT]" > /etc/fail2ban/jail.local
                    
                    clear
                    echo "--------------------------------------"
                    echo "Veuillez spécifier une durée de bannissement générale par défaut"
                    echo "(exemple : 5m pour 5 minutes)"
                    echo "(exemple, entrez la valeur par défaut si vous ne savez pas : 10m)"
                    read failb

                    echo "bantime = $failb" >> /etc/fail2ban/jail.local

                    echo "--------------------------------------"
                    echo "Veuillez spécifier une durée pour le findtime général par défaut"
                    echo "(exemple : 5m pour 5 minutes)"
                    echo "(exemple, entrez la valeur par défaut si vous ne savez pas : 5m)"
                    read failf

                    echo "findtime = $failf" >> /etc/fail2ban/jail.local

                    echo "--------------------------------------"
                    echo "Veuillez spécifier un nombre de tentatives ratées avant bannissement général par défaut"
                    echo "(exemple : 3 pour 3 tentatives ratées)"
                    read failr

                    echo "maxretry = $failr" >> /etc/fail2ban/jail.local
                    echo "maxmatches = %(maxretry)s" >> /etc/fail2ban/jail.local
                    printf "\n" >> /etc/fail2ban/jail.local

                    echo "backend = auto" >> /etc/fail2ban/jail.local
                    echo "usedns = warn" >> /etc/fail2ban/jail.local
                    echo "logencoding = auto" >> /etc/fail2ban/jail.local
                    echo "port = 0:65535" >> /etc/fail2ban/jail.local

                    echo 'fail2ban_agent = Fail2Ban/%(fail2ban_version)s' >> /etc/fail2ban/jail.local
                    echo 'banaction_allports = iptables-allports' >> /etc/fail2ban/jail.local
                    echo 'action_ = %(banaction)s[port="%(port)s", protocol="%(protocol)s", chain="%(chain)s"]' >> /etc/fail2ban/jail.local
                    echo 'action_mw = %(action_)s' >> /etc/fail2ban/jail.local
                    echo '            %(mta)s-whois[sender="%(sender)s", dest="%(destemail)s", protocol="%(protocol)s", chain="%(chain)s"]' >> /etc/fail2ban/jail.local
                    echo 'action_mwl = %(action_)s' >> /etc/fail2ban/jail.local
                    echo '             %(mta)s-whois-lines[sender="%(sender)s", dest="%(destemail)s", logpath="%(logpath)s", chain="%(chain)s"]' >> /etc/fail2ban/jail.local
                    echo 'action_xarf = %(action_)s' >> /etc/fail2ban/jail.local
                    echo '             xarf-login-attack[service=%(__name__)s, sender="%(sender)s", logpath="%(logpath)s", port="%(port)s"]' >> /etc/fail2ban/jail.local
                    echo 'action_cf_mwl = cloudflare[cfuser="%(cfemail)s", cftoken="%(cfapikey)s"]' >> /etc/fail2ban/jail.local
                    echo '                %(mta)s-whois-lines[sender="%(sender)s", dest="%(destemail)s", logpath="%(logpath)s", chain="%(chain)s"]' >> /etc/fail2ban/jail.local
                    echo 'action_blocklist_de  = blocklist_de[email="%(sender)s", service="%(__name__)s", apikey="%(blocklist_de_apikey)s", agent="%(fail2ban_agent)s"]' >> /etc/fail2ban/jail.local
                    echo 'action_badips = badips.py[category="%(__name__)s", banaction="%(banaction)s", agent="%(fail2ban_agent)s"]' >> /etc/fail2ban/jail.local
                    echo 'action_badips_report = badips[category="%(__name__)s", agent="%(fail2ban_agent)s"]' >> /etc/fail2ban/jail.local
                    echo 'action_abuseipdb = abuseipdb' >> /etc/fail2ban/jail.local
                    printf "\n" >> /etc/fail2ban/jail.local
                    printf "\n" >> /etc/fail2ban/jail.local
                    


                    clear
                    echo "--------------------------------------"
                    echo "Paramétrage des prisons à présent"
                    sleep 2

                    echo "### PRISONS ###" >> /etc/fail2ban/jail.local
                    printf "\n" >> /etc/fail2ban/jail.local

                    clear
                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une protection contre les attaques DDoS sur les ports http et https (serveur apache) ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo "--------------------------------------"
                            echo "Veuillez entrer le(s) port(s) http utilisé(s) sur ce serveur"
                            echo "(exemple : 80,8081,8082)"
                            read porthttp

                            echo "--------------------------------------"
                            echo "Veuillez entrer le(s) port(s) https utilisé(s) sur ce serveur"
                            echo "(exemple : 443,4443)"
                            read porthttps

                            echo "--------------------------------------"
                            echo "Veuillez entrer un nombre maximal de tentatives de connexion"
                            echo "(exemple : 500 est une bonne mesure)"
                            read maxretry                           

                            echo "--------------------------------------"
                            echo "Veuillez entrer un intervalle de temps au cours duquel ce nombre maximal de connexions défini provoquera un bannissement"
                            echo "(exemple : 4m est une bonne mesure)"
                            read findtime 

                            echo "--------------------------------------"
                            echo "Veuillez entrer une durée de bannissement"
                            echo "(exemple : 6m est une bonne mesure)"
                            read banddos  

                            echo '[apache-ddos]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "port = $porthttp,$porthttps" >> /etc/fail2ban/jail.local
                            echo 'filter = apache-ddos' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/apache2/*.log' >> /etc/fail2ban/jail.local
                            echo "maxretry = $maxretry" >> /etc/fail2ban/jail.local
                            echo "findtime = $findtime" >> /etc/fail2ban/jail.local
                            echo "bantime = $banddos" >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            # Générer le fichier de filtre
                            echo "[Definition]" > /etc/fail2ban/filter.d/apache-ddos.conf
                            echo 'failregex = ^<HOST> -.*"(GET|POST).*' >> /etc/fail2ban/filter.d/apache-ddos.conf
                            echo "ignoreregex =" >> /etc/fail2ban/filter.d/apache-ddos.conf

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac




                    clear
                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour SSH ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo "--------------------------------------"
                            echo "Veuillez choisir le mode que vous souhaitez mettre en place"
                            echo "(vous avez le choix entre normal, ddos, agressive, extra)"
                            read mode

                            echo '[sshd]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local
                            echo 'port = ssh' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(sshd_log)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(sshd_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac
                    
                    clear
                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour Dropbear ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo "--------------------------------------"
                            echo "Veuillez choisir le mode que vous souhaitez mettre en place"
                            echo "(vous avez le choix entre normal, ddos, agressive, extra)"
                            read mode

                            echo '[dropbear]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local                            
                            echo 'logpath  = %(dropbear_log)s' >> /etc/fail2ban/jail.local
                            echo 'backend  = %(dropbear_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    clear
                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour selinux-ssh ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo "--------------------------------------"
                            echo "Veuillez choisir le mode que vous souhaitez mettre en place"
                            echo "(vous avez le choix entre normal, ddos, agressive, extra)"
                            read mode

                            echo '[selinux-ssh]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local                              
                            echo 'port = ssh' >> /etc/fail2ban/jail.local
                            echo 'logpath  = %(auditd_log)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    clear
                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour openhab-auth ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo "--------------------------------------"
                            echo "Veuillez choisir le mode que vous souhaitez mettre en place"
                            echo "(vous avez le choix entre normal, ddos, agressive, extra)"
                            read mode

                            echo '[openhab-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local                              
                            echo 'filter = openhab' >> /etc/fail2ban/jail.local
                            echo 'banaction = %(banaction_allports)s' >> /etc/fail2ban/jail.local
                            echo 'logpath = /opt/openhab/logs/request.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac                            

                    clear
                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour Apache ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo "--------------------------------------"
                            echo "Veuillez choisir le mode que vous souhaitez mettre en place"
                            echo "(vous avez le choix entre normal, ddos, agressive, extra)"
                            read mode

                            echo '[apache-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath  = %(apache_error_log)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            echo '[apache-badbots]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath  = %(apache_access_log)s' >> /etc/fail2ban/jail.local
                            echo 'bantime  = 48h' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 1' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            echo '[apache-noscript]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath  = %(apache_error_log)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            echo '[apache-overflows]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath  = %(apache_error_log)s' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 2' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            echo '[apache-nohome]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath  = %(apache_error_log)s' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 2' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            echo '[apache-botsearch]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath  = %(apache_error_log)s' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 2' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            echo '[apache-fakegooglebot]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local                            
                            echo 'logpath  = %(apache_access_log)s' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 1' >> /etc/fail2ban/jail.local
                            echo 'ignorecommand = %(ignorecommands_dir)s/apache-fakegooglebot <ip>' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            echo '[apache-modsecurity]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath  = %(apache_error_log)s' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 2' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            echo '[apache-shellshock]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath  = %(apache_error_log)s' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 1' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    clear
                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour Nginx ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo "--------------------------------------"
                            echo "Veuillez choisir le mode que vous souhaitez mettre en place"
                            echo "(vous avez le choix entre normal, ddos, agressive, extra)"
                            read mode

                            echo '[nginx-http-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local                            
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(nginx_error_log)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            echo "--------------------------------------"
                            echo "Avez-vous installé et configuré ngx_http_limit_req_module ? [o/n]"
                            read answer
                            case $answer in
                                o)
                                    echo '[nginx-limit-req]' >> /etc/fail2ban/jail.local
                                    echo 'enabled = true' >> /etc/fail2ban/jail.local
                                    echo 'port = http,https' >> /etc/fail2ban/jail.local
                                    echo 'logpath = %(nginx_error_log)s' >> /etc/fail2ban/jail.local
                                    printf "\n" >> /etc/fail2ban/jail.local
                                ;;
                                n)
                                ;;
                            esac

                            echo '[nginx-botsearch]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local                            
                            echo 'logpath = %(nginx_error_log)s' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 2' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac                    

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour php-url-fopen ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[php-url-fopen]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local                             
                            echo 'logpath = %(nginx_access_log)s' >> /etc/fail2ban/jail.local
                            echo '          /var/log/apache2/*.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac  

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour suhosin ? [o/n]"
                    read choix
                    case $choix in
                        o)                                                
                            echo '[suhosin]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local                              
                            echo 'logpath = %(suhosin_log)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac 

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour Lighthttpd ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo "--------------------------------------"
                            echo "Veuillez choisir le mode que vous souhaitez mettre en place"
                            echo "(vous avez le choix entre normal, ddos, agressive, extra)"
                            read mode

                            echo '[lighttpd-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local                                                 
                            echo 'logpath = %(lighttpd_error_log)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour Roundcube ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[roundcube-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local  
                            echo 'logpath = %(roundcube_errors_log)s' >> /etc/fail2ban/jail.local
                            echo '#backend = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour OpenWebMail ? [o/n]"
                    read choix
                    case $choix in
                        o)                                               
                            echo '[openwebmail]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local                            
                            echo 'logpath = /var/log/openwebmail.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour Horde ? [o/n]"
                    read choix
                    case $choix in
                        o)         
                            echo '[horde]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local                              
                            echo 'logpath  = /var/log/horde/horde.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac  

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour groupoffice ? [o/n]"
                    read choix
                    case $choix in
                        o)      
                            echo '[groupoffice]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local                             
                            echo 'logpath = /home/groupoffice/log/info.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour sogo-auth ? [o/n]"
                    read choix
                    case $choix in
                        o)      
                            echo '[sogo-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local   
                            echo 'logpath = /var/log/sogo/sogo.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac               

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour tine20 ? [o/n]"
                    read choix
                    case $choix in
                        o)                                     
                            echo '[tine20]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath  = /var/log/tine20/tine20.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour Drupal ? [o/n]"
                    read choix
                    case $choix in
                        o)      
                            echo '[drupal-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local  
                            echo 'logpath = %(syslog_daemon)s' >> /etc/fail2ban/jail.local     
                            echo 'backend = %(syslog_backend)s' >> /etc/fail2ban/jail.local                                                   
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour guacamole ? [o/n]"
                    read choix
                    case $choix in
                        o)  
                            echo '[guacamole]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath  = /var/log/tomcat*/catalina.out' >> /etc/fail2ban/jail.local
                            echo '#logpath  = /var/log/guacamole.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour monit ? [o/n]"
                    read choix
                    case $choix in
                        o)  
                            echo '[monit]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = 2812' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/monit' >> /etc/fail2ban/jail.local
                            echo '           /var/log/monit.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour Webmin (port 10000 par défaut) ? [o/n]"
                    read choix
                    case $choix in
                        o)  
                            echo '[webmin-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = 10000' >> /etc/fail2ban/jail.local                            
                            echo 'logpath = %(syslog_authpriv)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour Froxlor ? [o/n]"
                    read choix
                    case $choix in
                        o)  
                            echo '[froxlor-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local                             
                            echo 'logpath = %(syslog_authpriv)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour Squid ? [o/n]"
                    read choix
                    case $choix in
                        o)                                                  
                            echo '[squid]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port =  80,443,3128,8080' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/squid/access.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour 3proxy ? [o/n]"
                    read choix
                    case $choix in
                        o)                            
                            echo '[3proxy]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = 3128' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/3proxy.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour ProFTPd ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[proftpd]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = ftp,ftp-data,ftps,ftps-data' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(proftpd_log)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(proftpd_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac 

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour Pure-ftpd ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[pure-ftpd]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = ftp,ftp-data,ftps,ftps-data' >> /etc/fail2ban/jail.local                            
                            echo 'logpath = %(pureftpd_log)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(pureftpd_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac   

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour gssftpd ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[gssftpd]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = ftp,ftp-data,ftps,ftps-data' >> /etc/fail2ban/jail.local 
                            echo 'logpath  = %(syslog_daemon)s' >> /etc/fail2ban/jail.local
                            echo 'backend  = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac 

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour Wuftpd ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[wuftpd]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = ftp,ftp-data,ftps,ftps-data' >> /etc/fail2ban/jail.local                            
                            echo 'logpath  = %(wuftpd_log)s' >> /etc/fail2ban/jail.local
                            echo 'backend  = %(wuftpd_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac   

                    clear
                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour vsftpd ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo "--------------------------------------"
                            echo "Veuillez choisir le mode que vous souhaitez mettre en place"
                            echo "(vous avez le choix entre normal, ddos, agressive, extra)"
                            read mode

                            echo "--------------------------------------"
                            echo "Veuillez définir une durée de bannissement"
                            echo "(exemple : 5m pour 5 minutes)"
                            read bant
                            
                            echo "--------------------------------------"
                            echo "Veuillez spécifier un nombre de tentatives ratées avant bannissement"
                            echo "(exemple : 3 pour 3 tentatives ratées)"
                            read failr

                            echo '[vsftpd]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo "mode = $mode" >> /etc/fail2ban/jail.local
                            echo 'port = ftp,ftp-data,ftps,ftps-data' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(vsftpd_log)s' >> /etc/fail2ban/jail.local
                            echo "bantime = $bant" >> /etc/fail2ban/jail.local
                            echo "maxretry = $failr" >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour aasp ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[assp]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = smtp,465,submission' >> /etc/fail2ban/jail.local
                            echo 'logpath  = /root/path/to/assp/logs/maillog.txt' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour courier-smtp ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[courier-smtp]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = smtp,465,submission' >> /etc/fail2ban/jail.local
                            echo 'logpath  = %(syslog_mail)s' >> /etc/fail2ban/jail.local
                            echo 'backend  = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour postfix ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[postfix]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'mode = more' >> /etc/fail2ban/jail.local
                            echo 'port = smtp,465,submission' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(postfix_log)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(postfix_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            echo '[postfix-rbl]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'filter = postfix[mode=rbl]' >> /etc/fail2ban/jail.local
                            echo 'port = smtp,465,submission' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(postfix_log)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(postfix_backend)s' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 1' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            echo '[postfix-sasl]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = smtp,465,submission,imap,imaps,pop3,pop3s' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(postfix_log)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(postfix_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local                            

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac                           

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour sendmail ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[sendmail-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = submission,465,smtp' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(syslog_mail)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            echo '[sendmail-reject]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo '#mode = normal' >> /etc/fail2ban/jail.local
                            echo 'port = smtp,465,submission' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(syslog_mail)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour qmail-rbl ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[qmail-rbl]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'filter = qmail' >> /etc/fail2ban/jail.local
                            echo 'port = smtp,465,submission' >> /etc/fail2ban/jail.local
                            echo 'logpath = /service/qmail/log/main/current' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour dovecot ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[dovecot]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = pop3,pop3s,imap,imaps,submission,465,sieve' >> /etc/fail2ban/jail.local                            
                            echo 'logpath = %(dovecot_log)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(dovecot_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour sieve ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[sieve]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = smtp,465,submission' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(dovecot_log)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(dovecot_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour solid-pop3d ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[solid-pop3d]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = pop3,pop3s' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(solidpop3d_log)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac       

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour exim ? [o/n]"
                    read choix
                    case $choix in
                        o)                    
                            echo '[exim]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo '#mode = normal' >> /etc/fail2ban/jail.local
                            echo 'port = smtp,465,submission' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(exim_main_log)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            echo '[exim-spam]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = smtp,465,submission' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(exim_main_log)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour kerio ? [o/n]"
                    read choix
                    case $choix in
                        o)                                                                              
                            echo '[kerio]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = imap,smtp,imaps,465' >> /etc/fail2ban/jail.local
                            echo 'logpath = /opt/kerio/mailserver/store/logs/security.log' >> /etc/fail2ban/jail.local                            
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac 

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour courier-auth ? [o/n]"
                    read choix
                    case $choix in
                        o)  
                            echo '[courier-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = smtp,465,submission,imap,imaps,pop3,pop3s' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(syslog_mail)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac 

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour perdition ? [o/n]"
                    read choix
                    case $choix in
                        o)                   
                            echo '[perdition]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = imap,imaps,pop3,pop3s' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(syslog_mail)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac 

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour squirrelmail ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[squirrelmail]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = smtp,465,submission,imap,imap2,imaps,pop3,pop3s,http,https,socks' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/lib/squirrelmail/prefs/squirrelmail_access_log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac                            

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour cyrus-imap ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[cyrus-imap]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = imap,imaps' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(syslog_mail)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour uwimap ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[uwimap-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = imap,imaps' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(syslog_mail)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour named-refused ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[named-refused]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = domain,953' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/named/security.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour nsd ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[nsd]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = 53' >> /etc/fail2ban/jail.local
                            echo 'action_  = %(default/action_)s[name=%(__name__)s-tcp, protocol="tcp"]' >> /etc/fail2ban/jail.local
                            echo '           %(default/action_)s[name=%(__name__)s-udp, protocol="udp"]' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/nsd.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour asterisk ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[asterisk]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = 5060,5061' >> /etc/fail2ban/jail.local
                            echo 'action_  = %(default/action_)s[name=%(__name__)s-tcp, protocol="tcp"]' >> /etc/fail2ban/jail.local
                            echo '           %(default/action_)s[name=%(__name__)s-udp, protocol="udp"]' >> /etc/fail2ban/jail.local
                            echo 'logpath  = /var/log/asterisk/messages' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 10' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac                 

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour freeswitch ? [o/n]"
                    read choix
                    case $choix in
                        o)                                
                            echo '[freeswitch]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = 5060,5061' >> /etc/fail2ban/jail.local
                            echo 'action_  = %(default/action_)s[name=%(__name__)s-tcp, protocol="tcp"]' >> /etc/fail2ban/jail.local
                            echo '           %(default/action_)s[name=%(__name__)s-udp, protocol="udp"]' >> /etc/fail2ban/jail.local
                            echo 'logpath  = /var/log/freeswitch.log' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 10' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac 

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour znc-adminlog ? [o/n]"
                    read choix
                    case $choix in
                        o)                                                 
                            echo '[znc-adminlog]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = 6667' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/lib/znc/moddata/adminlog/znc.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac 

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour mysql (port par défaut 3306) ? [o/n]"
                    read choix
                    case $choix in
                        o)                       
                            echo '[mysqld-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = 3306' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(mysql_log)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(mysql_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour mongodb (port par défaut 27017) ? [o/n]"
                    read choix
                    case $choix in
                        o)   
                            echo '[mongodb-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = 27017' >> /etc/fail2ban/jail.local
                            echo 'logpath  = /var/log/mongodb/mongodb.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour xinetd ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[xinetd-fail]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'banaction = iptables-multiport-log' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(syslog_daemon)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 2' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour stunnel ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[stunnel]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/stunnel4/stunnel.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour ejabberd ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[ejabberd-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = 5222' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/ejabberd/ejabberd.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour counter-strike ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[counter-strike]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'logpath = /opt/cstrike/logs/L[0-9]*.log' >> /etc/fail2ban/jail.local
                            echo 'tcpport = 27030,27031,27032,27033,27034,27035,27036,27037,27038,27039' >> /etc/fail2ban/jail.local
                            echo 'udpport = 1200,27000,27001,27002,27003,27004,27005,27006,27007,27008,27009,27010,27011,27012,27013,27014,27015' >> /etc/fail2ban/jail.local
                            echo 'action_  = %(default/action_)s[name=%(__name__)s-tcp, port="%(tcpport)s", protocol="tcp"]' >> /etc/fail2ban/jail.local
                            echo '           %(default/action_)s[name=%(__name__)s-udp, port="%(udpport)s", protocol="udp"]' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac                            

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour softethervpn ? [o/n]"
                    read choix
                    case $choix in
                        o)                             
                            echo '[softethervpn]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = 500,4500' >> /etc/fail2ban/jail.local
                            echo 'protocol = udp' >> /etc/fail2ban/jail.local
                            echo 'logpath = /usr/local/vpnserver/security_log/*/sec.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour gitlab ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[gitlab]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/gitlab/gitlab-rails/application.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour grafana ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[grafana]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/grafana/grafana.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour bitwarden ? [o/n]"
                    read choix
                    case $choix in
                        o)                     
                            echo '[bitwarden]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/grafana/grafana.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour centreon ? [o/n]"
                    read choix
                    case $choix in
                        o)                                                
                            echo '[centreon]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/centreon/login.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour nagios ? [o/n]"
                    read choix
                    case $choix in
                        o)          
                            echo '[nagios]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'logpath  = %(syslog_daemon)s     ; nrpe.cfg may define a different log_facility' >> /etc/fail2ban/jail.local
                            echo 'backend  = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 1' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour orcaleims ? [o/n]"
                    read choix
                    case $choix in
                        o)   
                            echo '[oracleims]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'logpath = /opt/sun/comms/messaging64/log/mail.log_current' >> /etc/fail2ban/jail.local
                            echo 'banaction = %(banaction_allports)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour directadmin ? [o/n]"
                    read choix
                    case $choix in
                        o)  
                            echo '[directadmin]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/directadmin/login.log' >> /etc/fail2ban/jail.local
                            echo 'port = 2222' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour portsentry ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[portsentry]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'logpath  = /var/lib/portsentry/portsentry.history' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 1' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour pass2allow-ftp ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[pass2allow-ftp]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = ftp,ftp-data,ftps,ftps-data' >> /etc/fail2ban/jail.local
                            echo 'knocking_url = /knocking/' >> /etc/fail2ban/jail.local
                            echo 'filter = apache-pass[knocking_url="%(knocking_url)s"]' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/apache2/*.log' >> /etc/fail2ban/jail.local
                            echo 'blocktype = RETURN' >> /etc/fail2ban/jail.local
                            echo 'returntype = DROP' >> /etc/fail2ban/jail.local
                            echo 'action = %(action_)s[blocktype=%(blocktype)s, returntype=%(returntype)s,' >> /etc/fail2ban/jail.local
                            echo '                        actionstart_on_demand=false, actionrepair_on_unban=true]' >> /etc/fail2ban/jail.local
                            echo 'bantime = 1h' >> /etc/fail2ban/jail.local
                            echo 'maxretry = 1' >> /etc/fail2ban/jail.local
                            echo 'findtime = 1' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac                            

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour murmur ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[murmur]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = 64738' >> /etc/fail2ban/jail.local
                            echo 'action_  = %(default/action_)s[name=%(__name__)s-tcp, protocol="tcp"]' >> /etc/fail2ban/jail.local
                            echo '           %(default/action_)s[name=%(__name__)s-udp, protocol="udp"]' >> /etc/fail2ban/jail.local
                            echo 'logpath  = /var/log/mumble-server/mumble-server.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac 

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour screensharingd ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[screensharingd]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'logpath  = /var/log/system.log' >> /etc/fail2ban/jail.local
                            echo 'logencoding = utf-8' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac  

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour haproxy-http ? [o/n]"
                    read choix
                    case $choix in
                        o)                                              
                            echo '[haproxy-http-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/haproxy.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour slapd ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[slapd]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = ldap,ldaps' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/slapd.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour domino-smtp ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[domino-smtp]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = smtp,ssmtp' >> /etc/fail2ban/jail.local
                            echo 'logpath = /home/domino01/data/IBM_TECHNICAL_SUPPORT/console.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac                            
                            
                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour phpmyadmin-syslog ? [o/n]"
                    read choix
                    case $choix in
                        o)                             
                            echo '[phpmyadmin-syslog]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath = %(syslog_authpriv)s' >> /etc/fail2ban/jail.local
                            echo 'backend = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour zoneminder ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[zoneminder]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/apache2/*.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour traefik-auth ? [o/n]"
                    read choix
                    case $choix in
                        o) 
                            echo '[traefik-auth]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'port = http,https' >> /etc/fail2ban/jail.local
                            echo 'logpath = /var/log/traefik/access.log' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local
                            
                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac                                                 

                    echo "--------------------------------------"
                    echo "Voulez-vous configurer une prison pour PAM ? [o/n]"
                    read choix
                    case $choix in
                        o)
                            echo '[pam-generic]' >> /etc/fail2ban/jail.local
                            echo 'enabled = true' >> /etc/fail2ban/jail.local
                            echo 'banaction = %(banaction_allports)s' >> /etc/fail2ban/jail.local
                            echo 'logpath  = %(syslog_authpriv)s' >> /etc/fail2ban/jail.local
                            echo 'backend  = %(syslog_backend)s' >> /etc/fail2ban/jail.local
                            printf "\n" >> /etc/fail2ban/jail.local

                            clear
                            echo "--------------------------------------"
                            echo "La prison est en place"
                            sleep 2
                        ;;
                        n)
                        ;;
                    esac

                    systemctl restart fail2ban

                    clear
                    echo "--------------------------------------"
                    echo "La configuration de fail2ban est terminée"
                    echo "Appuyez sur ENTRER pour revenir au menu précédent"
                    read enter 
                    i4=$((i4+1))
                ;;
                "r")
                    i4=$((i4+25))
                ;;
            esac
       done     
fi
if [ "$choix" == "5" ]; then
    clear
    i=0
    while [ $i -lt 24 ]; do
        clear
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
        echo "Entrez le numéro du menu voulu"
        read choix61
            case "$choix61" in
                "1")
                    clear
                    echo "--------------------------------------"
                    echo "Veuillez entrer le nom de l'utilisateur"
                    read tryus
                    countus=`compgen -u | grep $tryus | wc -l`
                        case "$countus" in
                            "0")
                                echo "--------------------------------------"
                                echo "Cet utilisateur n'existe pas"
                                sleep 2s
                            ;;
                            "1")
                                echo "--------------------------------------"
                                echo "Cet utilisateur existe"
                                sleep 2s
                            ;;
                        esac
                        i=$((i+1))
                        clear
                ;;
                "2")
                    clear
                    echo "--------------------------------------"
                    echo "La liste des utilisateurs va apparaître"
                    echo "Vous pouvez parcourir la liste avec les flèches du bas et du haut"
                    echo "Tappez la lettre q pour quitter cette liste et revenir au script"
                    sleep 4s
                    compgen -u | less
                    wait
                    i=$((i+1))
                ;;
                "3")
                    clear
                    echo "--------------------------------------"
                    echo "La liste des groupes va apparaître"
                    echo "Vous pouvez parcourir la liste avec les flèches du bas et du haut"
                    echo "Tappez la lettre q pour quitter cette liste et revenir au script"
                    sleep 4s
                    getent group | awk -F: '{ print $1}' | less
                    wait
                    i=$((i+1))
                ;;
                "4")
                    clear
                    echo "--------------------------------------"
                    echo "Veuillez entrer le nom de l'utilisateur"
                    read tryugr
                    echo "--------------------------------------"
                    echo "L'utilisateur appartient au(x) groupe(s) suivant(s)"
                    groups
                    sleep 3s
                    clear
                    i=$((i+1))
                ;;
                "5")
                    clear
                    echo "--------------------------------------"
                    echo "Entrez le nom de l'utilisateur à créer"
                    read ustocreate
                    useradd $ustocreate -m
                    echo "--------------------------------------"
                    echo "Entrez son mot de passe"
                    passwd $ustocreate
                    wait
                    clear
                    i=$((i+1))
                ;;
                "6")
                    clear
                    echo "--------------------------------------"
                    echo "Entrez le nom du groupe à créer"
                    read crtgrp
                    addgroup $crtgrp
                    sleep 2s
                    i=$((i+1))
                ;;
                "7")
                    clear
                    echo "--------------------------------------"
                    echo "Entrez le nom de l'utilisateur"
                    read usaddtgrp
                    echo "--------------------------------------"
                    echo "Entrez le nom du groupe"
                    read grptous
                    echo "--------------------------------------"
                    echo "Souhaitez-vous ajouter $usaddtgrp au groupe $grptous [o] ou l'en retirer [n] ?"
                    read ansgr
                        case "$ansgr" in
                            "o")
                                adduser $usaddtgrp $grptous
                                echo "L'utilisateur a bien été rajouté"
                                sleep 2s
                                clear
                            ;;
                            "n")
                                deluser $usaddtgrp $grptous
                                echo "L'utilisateur a bien été retiré"
                                sleep 2s
                                clear
                            ;;
                        esac
                        i=$((i+1))
                ;;
                "8")
                    clear
                    echo "--------------------------------------"
                    echo "Entrez le nom de l'utilisateur concerné"
                    read ustoc
                    echo "--------------------------------------"
                    echo "Entrez le chemin absolu du dossier sur lequel changer les droits (exemple : /var/www/)"
                    read pathc
                    echo "--------------------------------------"
                    echo "Souhaitez-vous appliquer une récursivité ? [o/n]"
                    echo "(que les droits s'appliquent aussi au contenu du dossier)"
                    read recc
                    case "$recc" in
                        "o")
                            recc='-R'
                        ;;
                        "n")
                            recc=''
                        ;;
                    esac
                    echo "--------------------------------------"
                    echo "Voulez-vous attribuer le droit de LECTURE du dossier à votre utilisateur ? [o/n]"
                    read awrt
                    case "$awrt" in
                        "o")
                            chmod $recc g+r $pathc
                        ;;
                        "n")
                            chmod $recc g-r $pathc
                        ;;
                    esac
                    echo "--------------------------------------"
                    echo "Voulez-vous attribuer le droit d'ECRITURE sur le dossier à votre utilisateur ? [o/n]"
                    read awrt1
                    if [ "$awrt1" == "o" ]; then
                        chmod $recc g+w $pathc
                    else
                        chmod $recc g-w $pathc
                    fi
                    echo "--------------------------------------"
                    echo "Voulez-vous attribuer le droit d'EXECUTION/TRAVERSER sur le dossier à votre utilisateur ? [o/n]"
                    read axrt
                    if [ "$axrt" == "o" ]; then
                        chmod $recc g+x $pathc
                    else
                        chmod $recc g-x $pathc
                    fi
                    grpf=`stat -c "%G" $pathc`
                    adduser $ustoc $grpf
                    echo "--------------------------------------"
                    echo "Les droits ont bien été appliqué"
                    sleep 2s
                    i=$((i+1))
                ;;
                "9")
                    clear
                    echo "--------------------------------------"
                    echo "Entrez le nom de l'utilisateur concerné"
                    read ustoca
                    echo "--------------------------------------"
                    echo "Entrez le chemin absolu du dossier (exemple : /var/www/)"
                    read pathca
                    chown $ustoca $pathca
                    echo "--------------------------------------"
                    echo "Le changement de propriétaire a bien été appliqué"
                    sleep 2s
                    i=$((i+1))
                ;;
                "r")
                    i=$((i+25))
                ;;
            esac
            
        done
iprinc=$((iprinc+1))
fi
if [ "$choix" == "6" ]; then
            i6=0
            while [ $i6 -lt 24 ]; do
            clear
            echo "--------------------------------------"
            echo "Souhaitez-vous installer [o] ou désinstaller un programme [n] ?"
            read apbw
                case "$apbw" in
                    "o")
                    echo "--------------------------------------"
                    echo "Connaissez-vous le nom du programme que vous souhaitez installer ? [o/n]"
                    read anprg
                        if [ "$anprg" == "o" ]; then
                            echo "Quel est le nom du programme que vous souhaitez installer ?"
                            echo "(Vous pouvez en installer plusieurs en même temps, en inscrivant les noms des programmes séparés d'un espace)"
                            read nprogram
                            apt update
                            apt install $nprogram -y
                            echo "--------------------------------------"
                            echo "le/les programme/s $nprogramm ont été installé"
                            i6=$((i6+25))
                        else
                            i=0
                            while [ $i -lt 4 ]; do
                                echo "--------------------------------------"
                                echo "Ecrivez le nom du programme si vous souhaitez vérifier qu'il existe"
                                read seprg
                                apt search $seprg
                                echo "--------------------------------------"
                                echo "Avez-vous obtenu un résultat ? [o/n]"
                                read resulo
                                case "$resulo" in
                                    "o")
                                    echo "Entrer le nom du (des) programmes que vous souhaitez installer"
                                    echo "(Vous pouvez en installer plusieurs en même temps, en inscrivant les noms des programmes séparés d'un espace)"
                                    read nrprogramm2
                                    apt install $nrprogramm2 -y
                                    echo "--------------------------------------"
                                    echo "le/les programme/s $nrprogramm2 sont installés"
                                    exit 0
                                ;;
                                    "n")
                                    echo "--------------------------------------"
                                    echo "Vous m'en voyez désolé"
                                    i=$((i+1))
                                    echo "Voulez-vous faire une nouvelle recherche ? [o/n]"
                                    read ainsea
                                        if [ "$ainsea" == "n" ]; then
                                            i=$((i+25))
                                        fi
                                            i=$((i+1))
                                ;;
                                esac
                            done
                        fi
                    ;;
                    "n")
                    echo "--------------------------------------"
                    echo "Entrez le nom du programme que vous souhaitez désinstaller"
                    echo "Vous pouvez en désinstaller plusieurs en même temps, en inscrivant les noms des programmes séparés d'un espace"
                    read todel
                    apt remove $todel -y
                    echo "--------------------------------------"
                    echo "le/les programme/s $todel ont été désinstallés"
                    i6=$((i6+25))
                ;;
                esac
            i6=$((i6+25))
            done
iprinc=$((iprinc+1))
fi

if [ "$choix" == "7" ]; then
        clear
        i7=0
        while [ $i7 -lt 24 ]; do
        clear
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
        read choix6
        case $choix6 in
            1)
                clear
                echo "--------------------------------------"
                echo "Quel nom voulez-vous donner à votre site ?"
                echo "(exemple : www.bonbon.com)"
                read d
                i=0
                while [ $i -lt 4 ]; do
                if [ -d "/var/www/$d" ]; then
                echo "--------------------------------------"
                echo "Ce nom de domaine est déjà présent sur votre serveur"
                echo "Veuillez en choisir un autre"
                i=$((i+1))
                read d
                else
                i=$((i+25))
                fi
                done
                if [ $i -eq 4 ]; then
                exit 0
                fi 

                apt update
                apt upgrade -y
                apt install apache2 libapache2-mod-evasive -y

                rm /etc/apache2/sites-enabled/000-default.conf

                clear
                echo "---------------------------------"
                echo "Entrez une ligne de texte à afficher dans votre index.html (en attendant que vous fassiez votre site !)"
                echo "(exemple : Bienvenue sur la page $d)"
                read l

                clear
                echo "--------------------------------------"
                echo "Voulez-vous changer le port http par défaut d'apache ? [o/n]"
                echo "(si vous souhaitez qu'un site soit contactable sur un autre port que 80, cette modification est indispensable)"
                read choix 
                case $choix in
                    o)
                        echo "--------------------------------------"
                        echo "Quel port voulez-vous utiliser ?"
                        echo "(exemple : 8081)"
                        read choixhttp

                        sed -i "s/80/$choixhttp/" /etc/apache2/ports.conf

                        echo "--------------------------------------"
                        echo "Le port a bien été modifié"
                        sleep 1
                    ;;
                    n)
                        choixhttp="80"
                    ;;
                esac
                clear
                echo "--------------------------------------"
                echo "Veuillez entrer le socket d'écoute de ce vhost (l'adresse IP:PORT sur laquelle apache répondra pour ce site - ceci dans le cas où votre serveur aurait plusieurs interfaces réseaux)"
                echo "(exemple : 192.168.0.201:80)"
                echo "(dans le cas où vous souhaiteriez qu'apache réponde quelle que soit l'interface réseau, tapez *:PORT - remplacer PORT par le numéro du port choisi !!"
                echo "(exemple : *:8081)"
                read socket

                mkdir /var/www/$d
                echo "$l" > /var/www/$d/index.html

                echo "### VHOST $d ###" > /etc/apache2/sites-available/$d.conf
                printf "\n" >> /etc/apache2/sites-available/$d.conf
                echo "<VirtualHost $socket>" >> /etc/apache2/sites-available/$d.conf
                echo "     ServerName $d" >> /etc/apache2/sites-available/$d.conf
                echo "     ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/$d.conf
                echo "     DocumentRoot /var/www/$d" >> /etc/apache2/sites-available/$d.conf
                echo "     ErrorLog \${APACHE_LOG_DIR}/$d-error.log" >> /etc/apache2/sites-available/$d.conf
                echo "     CustomLog \${APACHE_LOG_DIR}/$d-access.log combined" >> /etc/apache2/sites-available/$d.conf
                echo "</VirtualHost>" >> /etc/apache2/sites-available/$d.conf
                a2ensite $d.conf

                # Redémarrage du serveur
                apachectl graceful

                clear
                echo "--------------------------------------"
                echo "L'installation est terminée"
                echo "Il ne vous reste plus qu'à faire un enregistrement DNS sur votre hôte ou votre AD avec le nom de domaine choisi ($d)"
                echo "----------------------------------"
                echo "Petit résumé"
                echo "-----vous avez créé un DocumentRoot /var/www/$d"
                echo "-----vous avez activé un vhost /etc/apache2/sites-enabled/$d.conf"
                echo "-----une fois votre enregistrement DNS effectué, vous pourrez vous connecter à"
                echo "-----http://$d:$choixhttp"
                sleep 5s
                i7=$((i7+1))
            ;;
            2)
                clear
                echo "----------------------------------"
                echo "Quel nom voulez-vous donner à votre site ?"
                echo "(exemple : www.bonbon.com)"
                read d
                i=0
                while [ $i -lt 4 ]; do
                if [ -d "/var/www/$d" ]; then
                echo "Ce nom de domaine est déjà présent sur votre serveur"
                echo "Veuillez en choisir un autre"
                i=$((i+1))
                read d
                else
                i=$((i+25))
                fi
                done
                if [ $i -eq 4 ]; then
                exit 0
                fi 
                echo "---------------------------------"
                echo "Entrez une ligne de texte à afficher dans votre index.html"
                echo "exemple : Bienvenue sur la page $d"
                read l
                apt update
                apt upgrade -y
                apt install nginx -y
                mkdir /var/www/$d
                echo "$l" > /var/www/$d/index.html
                clear
                echo "--------------------------------------"
                echo "Veuillez entrer le socket d'écoute de ce vhost (l'adresse IP:PORT sur laquelle nginx répondra pour ce site - ceci dans le cas où votre serveur aurait plusieurs interfaces réseaux)"
                echo "(exemple : 192.168.0.201:80)"
                echo "(dans le cas où vous souhaiteriez qu'nginx réponde quelle que soit l'interface réseau, tapez simplement le port)"
                echo "(exemple : 8081)"
                read socket

                echo "### VHOST $d ###" > /etc/nginx/sites-available/$d
                printf "\n" >> /etc/nginx/sites-available/$d
                echo "server {" >> /etc/nginx/sites-available/$d
                echo "     listen $socket;" >> /etc/nginx/sites-available/$d
                echo "     server_name $d;" >> /etc/nginx/sites-available/$d
                echo "     access_log /var/log/nginx/$d-access.log combined;" >> /etc/nginx/sites-available/$d
                echo "     root /var/www/$d;" >> /etc/nginx/sites-available/$d
                echo "     index index.html;" >> /etc/nginx/sites-available/$d
                echo "}" >> /etc/nginx/sites-available/$d
                ln -s /etc/nginx/sites-available/$d /etc/nginx/sites-enabled/$d
                service nginx restart
                clear
                echo "----------------------------------"
                echo "L'installation est terminée"
                echo "Il ne vous reste plus qu'à faire un enregistrement DNS sur votre hôte ou votre AD avec le nom de domaine choisi ($d)"
                echo "----------------------------------"
                echo "Petit résumé"
                echo "-----vous avez créé un DocumentRoot /var/www/$d"
                echo "-----vous avez activé un vhost /etc/nginx/sites-enabled/$d"
                echo "-----une fois votre enregistrement DNS effectué, vous pourrez vous connecter à"
                echo "-----http://$d (n'oubliez pas le :PORT si vous avez changé le port http par défaut)"
                sleep 5s
                i7=$((i7+1))
            ;;
            3)
                clear
                echo "Bienvenue sur le script d'installation de wordpress sur Debian 11"
                echo "----------------------------------"
                echo "Quel nom voulez-vous donner à votre base de données ?"
                echo "(exemple : wordpressdb)"
                read dbname
                echo "----------------------------------"
                echo "Quel nom voulez-vous donner à l'utilisateur de cette base ?"
                echo "(exemple : admin)"
                read dbuser
                echo "----------------------------------"
                echo "Quel mot de passe voulez-vous attribuer à cet utilisateur"
                read passwd
                echo "----------------------------------"
                echo "Souhaitez-vous créer un vhost (-> http://vhost) [o] ? Ou utiliser le vhost par défaut d'apache (-> http://IP) [n] ?"
                read answer
                if [ $answer == n ]; then
                    clear
                    echo "L'installation commence"
                    apt update && apt upgrade -y
                    apt install apache2 libapache2-mod-evasive mariadb-server mariadb-client php libapache2-mod-php php-cli php-mysql php zip php-curl php-xml wget -y
                    systemctl start apache2 && systemctl enable apache2
                    rm /etc/apache2/sites-enabled/000-default.conf
                    systemctl start mysqld && systemctl enable mysql
                    mysql_secure_installation
                    wait
                    mysqladmin -uroot create $dbname
                    mysql -uroot -e"GRANT ALL ON $dbname.* TO $dbuser@localhost IDENTIFIED BY '$passwd'" $dbname
                    apt install wget -y
                    wget https://wordpress.org/latest.tar.gz -P /tmp
                    tar -xvzf /tmp/latest.tar.gz
                    mv wordpress/* /var/www/html
                    chown -R www-data: /var/www/
                    cd /var/www/html
                    cp wp-config-sample.php wp-config.php
                    sed -i "s/database_name_here/$dbname/" wp-config.php
                    sed -i "s/username_here/$dbuser/" wp-config.php
                    sed -i "s/password_here/$passwd/" wp-config.php
                    rm /var/www/html/index.html
                    systemctl restart apache2
                    clear
                    echo "installation terminée"
                    echo "via navigateur http://IP:port/"
                fi
    
                    if [ $answer == o ]; then  
                    echo "------------------------------------"
                    echo "Quel nom de domaine voulez-vous créer (pour le vhost) ?"
                    echo "(exemple : monwordpress.com)"
                    read vhost
                    clear
                    echo "on commence"
                    apt update && apt upgrade -y
                    apt install apache2 libapache2-mod-evasive mariadb-server mariadb-client php libapache2-mod-php php-cli php-mysql             100%  109KB  70.6MB/s   00:00    
[theophile@localhost ~]$ scp /home/theophile/Desktop/global-DEB2.sh theophile@172.20.51.51:/tmp
php-zip php-curl php-xml wget -y
                    systemctl start apache2 && systemctl enable apache2

                    rm /etc/apache2/sites-enabled/000-default.conf

                    systemctl start mysqld && systemctl enable mysql
                    mysql_secure_installation
                    wait
                    mysqladmin -uroot create $dbname
                    mysql -uroot -e"GRANT ALL ON $dbname.* TO $dbuser@localhost IDENTIFIED BY '$passwd'" $dbname
                    echo "<VirtualHost *:80>" > /etc/apache2/sites-available/$vhost.conf
                    echo "  ServerName $vhost" >> /etc/apache2/sites-available/$vhost.conf
                    echo "  ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/$vhost.conf
                    echo "  DocumentRoot /var/www/$vhost" >> /etc/apache2/sites-available/$vhost.conf
                    echo "  ErrorLog \${APACHE_LOG_DIR}/error.log" >> /etc/apache2/sites-available/$vhost.conf
                    echo "  CustomLog \${APACHE_LOG_DIR}/access.log combined" >> /etc/apache2/sites-available/$vhost.conf
                    echo "</VirtualHost>" >> /etc/apache2/sites-available/$vhost.conf
                    a2ensite $vhost.conf

                    # Masquage de la version du service :
                    sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                    # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                    echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                    echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                    echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf

                    mkdir /var/www/$vhost
                    apt install wget -y
                    wget https://wordpress.org/latest.tar.gz -P /tmp
                    tar -xvzf /tmp/latest.tar.gz
                    mv wordpress/* /var/www/$vhost
                    chown -R www-data: /var/www/$vhost
                    cd /var/www/$vhost
                    cp wp-config-sample.php wp-config.php
                    sed -i "s/database_name_here/$dbname/" wp-config.php
                    sed -i "s/username_here/$dbuser/" wp-config.php
                    sed -i "s/password_here/$passwd/" wp-config.php
                    systemctl restart apache2
                    clear
                    echo "installation terminée"
                    echo "via navigateur http://$vhost"
                    fi

                ;;
                4)
                    clear
                    n=$(find /var -name "*glpi*" | wc -l)
                    if [ $(command -v glpi) ] || [ $n -ge 1 ]; then
                    clear
                    echo "GLPI est déjà installé ou bien des fichiers d'une précédente configuration sont encore présents"
                    echo "Il est dangereux de continuer sans supprimer la configuration précédente (doublons)"
                    echo "Souhaitez-vous effacer la configuration précédente ? [O/n]"
                    read e
                    if [ $e == o ] || [ $e == O ]; then
                    rm -r /tmp/glpi-10.0.9.tgz
                    rm -r /tmp/glpi
                    find /var -name "*glpi*" -exec rm -r {} \; 
                    fi
                    fi
                    clear
                    echo "------------------------------"
                    echo "Bienvenue sur le script d'installation de GLPI pour Debian 12"
                    echo "Ce script va installer la pile LAMP ainsi que GLPI 10.0.9"
                    echo "----------------------------------"
                    echo "Votre machine doit pouvoir accéder à internet et au serveur des dépôts Debian"
                    echo "Souhaitez-vous tester votre connexion ? [O/n]"
                    read x
                    if [ $x == O ]; then
                    apt update
                    echo "------------------------------"
                    echo "L'opération a-t-elle réussi ? [O/n]"
                    read v
                    if [ $v == n ] || [ $v == N ]; then
                    clear
                    echo "Ré-exécutez le script lorsque vous aurez réglé vos problèmes de connexion"
                    exit 0
                    fi
                    fi
                    clear
                    echo "----------------------------------"
                    echo "L'installation peut commencer"
                    echo "Quel nom voulez-vous donner à votre base SQL pour GLPI ? (Exemple : glpi)"
                    read b
                    i=0
                    while [ $i -lt 4 ]; do
                    if [ "${b//[A-Za-z0-9.-_]}" ]; then
                    echo "Ce nom n'est pas possible"
                    echo "Veuillez utiliser uniquement les caractères suivants :"
                    echo "(A-Z) (a-z) (0-9) (.,) (-_)"
                    i=$((i+1))
                    echo "----------------------------------"
                    echo "Veuillez donc entrer un nouveau nom pour votre base SQL pour GLPI"
                    read b
                    else
                    i=$((i+25))
                    fi
                    done

                    if [ $i -eq 4 ]; then
                    exit 0
                    fi
                    echo "----------------------------------"
                    echo "Quel nom voulez-vous donner à l'administrateur de la base SQL pour GLPI ?(Exemple : admin)"
                    read a
                    i=0
                    while [ $i -lt 4 ]; do
                    if [ "${a//[A-Za-z0-9.-_]}" ]; then
                    echo "Ce nom n'est pas possible"
                    echo "Veuillez utiliser uniquement les caractères suivants :"
                    echo "(A-Z) (a-z) (0-9) (.,) (-_)"
                    i=$((i+1))
                    echo "----------------------------------"
                    echo "Veuillez donc entrer un nouveau nom pour l'administrateur de votre base SQL pour GLPI"
                    read b
                    else
                    i=$((i+25))
                    fi
                    done

                    if [ $i -eq 4 ]; then
                    exit 0
                    fi

                    echo "----------------------------------"
                    echo "Quel mot de passe voulez-vous configurer pour cet administrateur ?"
                    read m
                    echo "----------------------------------"
                    echo "Souhaitez-vous utiliser le vhost par défaut [d] d'Apache ou créer votre propre vhost [c] ?"
                    read choix
                    case $choix in
                        d)
                            clear
                            echo "----------------------------------"
                            echo "Vous êtes prêt ? [Y/n]"
                            read p
                            apt update
                            apt upgrade -y
                            apt install net-tools -y
                            apt install mariadb-server -y
                            mysqladmin -uroot create $b
                            mysql -uroot -e"GRANT ALL ON $b.* TO "$a"@localhost IDENTIFIED BY '$m'" $b
                            apt install apache2 -y


                            wget https://github.com/glpi-project/glpi/releases/download/10.0.9/glpi-10.0.9.tgz -P /tmp
                            tar -xvzf /tmp/glpi-10.0.9.tgz
                            rm /var/www/html/index.html
                            cp -r glpi/* /var/www/html
                            chown -R www-data:www-data /var/www/html
                            chmod 755 /var/www/html
                            apt install php libapache2-mod-php php-mysql php-mbstring php-curl php-json php-gd php-xml php-intl php-ldap php-apcu php-xmlrpc php-cas php-zip php-bz2 php-imap php-soap php-opcache php-php-gettext php-dev -y
                            
                            # Masquage de la version du service :
                            sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                            # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                            echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                            echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                            echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf
                            
                            apachectl graceful
                            clear
                            echo "L'installation est terminée"
                            echo "vous pouvez vous connecter via un navigateur web, à l'adresse  http://IP"
                            echo "----------------------------------"
                            echo "Petit résumé" 
                            echo "-----vous avez créé la base SQL    $b"
                            echo "-----l'administrateur              $a"
                            echo "-----le mot de passe               $m"
                            echo "-----vous avez utilisé le vhost par défaut d'Apache"
                            #i7=$((i7+1))
                        ;;
                        c)
                            echo "----------------------------------"
                            echo "Quel nom de domaine voulez-vous donner à votre site web pour GLPI ? (Exemple : glpi.jurabois.lan)"
                            read n
                            clear
                            echo "----------------------------------"
                            echo "Vous êtes prêt ? [Y/n]"
                            read p
                            apt update
                            apt upgrade -y
                            apt install net-tools -y
                            apt install mariadb-server -y
                            mysqladmin -uroot create $b
                            mysql -uroot -e"GRANT ALL ON $b.* TO "$a"@localhost IDENTIFIED BY '$m'" $b
                            apt install apache2 -y
                            systemctl enable apache2 && systemctl apache2 start
                            rm /etc/apache2/sites-enabled/000-default.conf
                            mkdir /var/www/$n
                            echo "<VirtualHost *:80>" > /etc/apache2/sites-available/$n.conf
                            echo "  ServerName $n" >> /etc/apache2/sites-available/$n.conf
                            echo "  ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/$n.conf
                            echo "  DocumentRoot /var/www/$n" >> /etc/apache2/sites-available/$n.conf
                            echo "  ErrorLog \${APACHE_LOG_DIR}/error.log" >> /etc/apache2/sites-available/$n.conf
                            echo "  CustomLog \${APACHE_LOG_DIR}/access.log combined" >> /etc/apache2/sites-available/$n.conf
                            echo "</VirtualHost>" >> /etc/apache2/sites-available/$n.conf
                            a2ensite $n.conf

                            # Masquage de la version du service :
                            sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                            # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                            echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                            echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                            echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf

                            wget https://github.com/glpi-project/glpi/releases/download/10.0.9/glpi-10.0.9.tgz -P /tmp
                            tar -xvzf /tmp/glpi-10.0.9.tgz
                            cp -r glpi/* /var/www/$n
                            chown -R www-data:www-data /var/www/$n
                            chmod 755 /var/www/$n
                            apt install php libapache2-mod-php php-mysql php-mbstring php-curl php-json php-gd php-xml php-intl php-ldap php-apcu php-xmlrpc php-cas php-zip php-bz2 php-imap php-soap php-opcache php-php-gettext php-dev -y
                            apachectl graceful
                            clear
                            echo "L'installation est terminée"
                            echo "Il vous reste encore à faire un enregistrement DNS sur votre hôte, avec le nom de domaine choisi ($n)"
                            echo "Puis, vous pourrez vous connecter via un navigateur web, à l'adresse  http://$n"
                            echo "----------------------------------"
                            echo "Petit résumé" 
                            echo "-----vous avez créé la base SQL    $b"
                            echo "-----l'administrateur              $a"
                            echo "-----le mot de passe               $m"
                            echo "-----le nom de domaine             $n"
                            #i7=$((i7+1))
                        ;;
                    esac
                ;;
                5)
                    clear
                    echo "--------------------------------------------"
                    echo "Votre machine doit être connectée à internet pour pouvoir exécuter ce script"
                    echo "Tapez ENTRER pour continuer ou [q] pour quitter"
                    read choix
                    case $choix in
                        q)
                            exit 0
                        ;;
                    esac
                    clear
                    echo "--------------------------------------------"
                    echo "Nous installons Apache et OpenSSL avant de commencer, patience !"
                    echo "--------------------------------------------"
                    apt update && apt upgrade -y 
                    apt install apache2 libapache2-mod-evasive wget openssl -y
                    systemctl start apache2 && systemctl enable apache2
                    rm /etc/apache2/sites-enabled/000-default.conf
                    a2enmod ssl
                    mkdir /etc/apache2/ssl
                    clear
                    echo "Bienvenue dans le script de création d'un vhost HTTPS apache2 sur Debian 11+"
                    echo "--------------------------------------------"
                    echo "Si vous exécutez le script pour la première fois, tapez ENTREE, sinon tapez [i] pour l'intégration d'un certificat signé par une autorité distante"
                    read f
                    if [ "$f" == "i" ]; then
                        echo "--------------------------------------------"
                        echo "Indiquez-moi le chemin absolu de votre certificat signé"
                        echo "(exemple : /tmp/certisigne.crt)"
                        read chemcert
                        echo "--------------------------------------------"
                        echo "Aviez-vous créé automatiquement votre clé privée [o] ? ou aviez-vous créé votre clé vous-même [n] ?"
                        read g
                        if [ "$g" == "o" ]; then
                            echo "--------------------------------------------"
                            echo "Aviez-vous créé un vhost [o] ? Ou aviez-vous utilisé le vhost par défaut d'apache [n] ?"
                            read h
                                if [ "$h" == "o" ]; then
                                    echo "--------------------------------------------"
                                    echo "Entrez le nom de votre site (exemple : www.beaubois-entreprise.com)"
                                    read nom

                                        clear
                                        echo "--------------------------------------"
                                        echo "Voulez-vous changer les ports http et/ou https par défaut d'apache ? [o/n]"
                                        echo "(si vous souhaitez qu'un site soit contactable sur un autre port que 80 ou 443, cette modification est indispensable)"
                                        read choix 
                                        case $choix in
                                            o)
                                                echo "--------------------------------------"
                                                echo "Voulez-vous modifier le port http par défaut (80) ? [o/n]"
                                                read choix2 
                                                case $choix2 in
                                                    o)
                                                        echo "--------------------------------------"
                                                        echo "Quel port voulez-vous utiliser ?"
                                                        echo "(exemple : 8081)"
                                                        read choixhttp

                                                        sed -i "s/80/$choixhttp/" /etc/apache2/ports.conf

                                                        echo "--------------------------------------"
                                                        echo "Le port a bien été modifié"
                                                        sleep 1
                                                    ;;
                                                    n)
                                                        choixhttp="80"
                                                    ;;
                                                esac
                                                echo "--------------------------------------"
                                                echo "Voulez-vous modifier le port https par défaut (443) ? [o/n]"
                                                read choix23 
                                                case $choix23 in
                                                    o)
                                                        echo "--------------------------------------"
                                                        echo "Quel port voulez-vous utiliser ?"
                                                        echo "(exemple : 4443)"
                                                        read choixhttps

                                                        sed -i "s/443/$choixhttps/" /etc/apache2/ports.conf

                                                        echo "--------------------------------------"
                                                        echo "Le port a bien été modifié"
                                                        sleep 1                             
                                                    ;;
                                                    n)
                                                        choixhttps="443"
                                                    ;;
                                                esac
                                            ;;
                                            n)
                                            ;;
                                        esac
                                        clear
                                        echo "--------------------------------------"
                                        echo "Veuillez entrer le socket d'écoute de ce vhost (l'adresse IP:PORT sur laquelle apache répondra pour ce site - ceci dans le cas où votre serveur aurait plusieurs interfaces réseaux)"
                                        echo "(exemple : 192.168.0.201:80)"
                                        echo "(dans le cas où vous souhaiteriez qu'apache réponde quelle que soit l'interface réseau, tapez *:PORT - remplacer PORT par le numéro du port choisi !!"
                                        echo "(exemple : *:8081)"
                                        read socket
                                        echo "--------------------------------------"
                                        echo "Voulez-vous mettre en place une redirection http -> https pour ce vhost ? [o/n]"
                                        read redir 
                                        case $redir in 
                                            o)
                                                echo "--------------------------------------"
                                                echo "Veuillez m'indiquer le socket d'écoute pour http"
                                                echo "(exemple : 192.168.0.201:8081)"
                                                echo "(dans le cas où vous souhaiteriez qu'apache réponde quelle que soit l'interface réseau, tapez *:PORT - remplacer PORT par le numéro du port choisi !!"
                                                echo "(exemple : *:8081)"
                                                read socketredir

                                                echo "--------------------------------------"
                                                echo "Veuillez m'indiquer le port d'écoute pour https"
                                                echo "(exemple : 4443)"
                                                read porthttps

                                                echo "### VHOST $nom ###" > /etc/apache2/sites-available/$nom.conf
                                                printf "\n" >> /etc/apache2/sites-available/$nom.conf
                                                echo "<VirtualHost $socketredir>" >> /etc/apache2/sites-available/$nom.conf
                                                echo "     ServerName $nom" >> /etc/apache2/sites-available/$nom.conf
                                                echo "     Redirect permanent / https://$nom:$porthttps/" >> /etc/apache2/sites-available/$nom.conf
                                                echo "</VirtualHost>" >> /etc/apache2/sites-available/$nom.conf
                                                printf "\n" >> /etc/apache2/sites-available/$nom.conf
                                            ;;
                                            n)
                                                echo "### VHOST $nom ###" > /etc/apache2/sites-available/$nom.conf
                                                printf "\n" >> /etc/apache2/sites-available/$nom.conf
                                            ;;
                                        esac

                                        echo "### VHOST $nom ###" >> /etc/apache2/sites-available/$nom.conf
                                        echo "<VirtualHost $socket>
                                        ServerName $nom
                                        DocumentRoot /var/www/$nom" >> /etc/apache2/sites-available/$nom.conf
                                        echo "ErrorLog \${APACHE_LOG_DIR}/$nom-error.log
                                        CustomLog \${APACHE_LOG_DIR}/$nom-access.log combined
                                        SSLEngine on" >> /etc/apache2/sites-available/$nom.conf
                                        echo "SSLCertificateFile $chemcert
                                        SSLCertificateKeyFile /etc/apache2/ssl/clefprivapache.key" >> /etc/apache2/sites-available/$nom.conf
                                        echo '<FilesMatch "\.(cgi|shtml|phtml|php)$">
                                        SSLOptions +StdEnvVars
                                        </FilesMatch>
                                        <Directory /usr/lib/cgi-bin>
                                        SSLOptions +StdEnvVars
                                        </Directory>
                                        </VirtualHost>' >> /etc/apache2/sites-available/$nom.conf
                                        cd /etc/apache2/sites-available/
                                        a2ensite $nom.conf

                                        # Masquage de la version du service :
                                        sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                                        # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                                        echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                                        echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                                        echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf

                                        systemctl restart apache2
                                        clear
                                        echo "L'installation est terminée"
                                        echo "Il ne vous reste plus qu'à faire un enregistrement DNS sur votre hôte ou votre AD avec le nom de domaine choisi ($d)"
                                        echo "----------------------------------"
                                        echo "Petit résumé"
                                        echo "-----vous avez créé le DocumentRoot /var/www/$nom"
                                        echo "-----vous avez activé le vhost /etc/apache2/sites-available/default-ssl.conf"
                                        echo "-----une fois votre enregistrement DNS effectué, vous pourrez vous connecter à"
                                        echo "-----https://$nom (n'oubliez pas le :PORT dans le cas où vous avez changé le port par défaut)"
                                        exit 0
                
                                fi
                    echo "<VirtualHost _default_:443>
                    ServerAdmin webmaster@localhost

                    DocumentRoot /var/www/html
                    ErrorLog \${APACHE_LOG_DIR}/error.log
                    CustomLog \${APACHE_LOG_DIR}/access.log combined

                    SSLEngine on" > /etc/apache2/sites-available/default-ssl.conf
                
                    echo "SSLCertificateFile      $chemcert
                    SSLCertificateKeyFile /etc/apache2/ssl/cleprivapache.key" >> /etc/apache2/sites-available/default-ssl.conf

                    echo '<FilesMatch "\.(cgi|shtml|phtml|php)$">
                    SSLOptions +StdEnvVars
                    </FilesMatch>
                    <Directory /usr/lib/cgi-bin>
                    SSLOptions +StdEnvVars
                    </Directory>
                    </VirtualHost>' >> /etc/apache2/sites-available/default-ssl.conf
                    cd /etc/apache2/sites-available/
                    a2ensite default-ssl.conf
                    systemctl restart apache2
                    clear
                    echo "L'installation est terminée"
                    echo "Vous pouvez accéder au site via https://IP-SERVEUR"
                    exit 0
                        fi
                    echo "--------------------------------------------"
                    echo "Indiquez-moi le chemin absolu de votre clé privée (exemple : /tmp/cleprivapache.key)"
                    read nol
                    echo "---------------------------------------------"
                    echo "Aviez-vous créé un vhost [o] ? Ou aviez-vous utilisé le vhost par défaut d'apache [n] ?"
                    read k
                    if [ "$k" == "o" ]; then
                    echo "--------------------------------------------"
                    echo "Entrez le nom de votre site (exemple : www.beaubois-entreprise.com)"
                    read nom2

                    clear
                    echo "--------------------------------------"
                    echo "Voulez-vous changer les ports http et/ou https par défaut d'apache ? [o/n]"
                    echo "(si vous souhaitez qu'un site soit contactable sur un autre port que 80 ou 443, cette modification est indispensable)"
                    read choix 
                    case $choix in
                        o)
                            echo "--------------------------------------"
                            echo "Voulez-vous modifier le port http par défaut (80) ? [o/n]"
                            read choix2 
                            case $choix2 in
                                o)
                                    echo "--------------------------------------"
                                    echo "Quel port voulez-vous utiliser ?"
                                    echo "(exemple : 8081)"
                                    read choixhttp

                                    sed -i "s/80/$choixhttp/" /etc/apache2/ports.conf

                                    echo "--------------------------------------"
                                    echo "Le port a bien été modifié"
                                    sleep 1
                                ;;
                                n)
                                ;;
                            esac
                            echo "--------------------------------------"
                            echo "Voulez-vous modifier le port https par défaut (443) ? [o/n]"
                            read choix23 
                            case $choix23 in
                                o)
                                    echo "--------------------------------------"
                                    echo "Quel port voulez-vous utiliser ?"
                                    echo "(exemple : 4443)"
                                    read choixhttps

                                    sed -i "s/443/$choixhttps/" /etc/apache2/ports.conf

                                    echo "--------------------------------------"
                                    echo "Le port a bien été modifié"
                                    sleep 1                             
                                ;;
                                n)
                                ;;
                            esac
                        ;;
                        n)
                        ;;
                    esac
                    clear
                    echo "--------------------------------------"
                    echo "Veuillez entrer le socket d'écoute de ce vhost (l'adresse IP:PORT sur laquelle apache répondra pour ce site - ceci dans le cas où votre serveur aurait plusieurs interfaces réseaux)"
                    echo "(exemple : 192.168.0.201:443)"
                    echo "(dans le cas où vous souhaiteriez qu'apache réponde quelle que soit l'interface réseau, tapez *:PORT - remplacer PORT par le numéro du port choisi !!"
                    echo "(exemple : *:4443)"
                    read socket
                    echo "--------------------------------------"
                    echo "Voulez-vous mettre en place une redirection http -> https pour ce vhost ? [o/n]"
                    read redir 
                    case $redir in 
                        o)
                            echo "--------------------------------------"
                            echo "Veuillez m'indiquer le socket d'écoute pour http"
                            echo "(exemple : 192.168.0.201:8081)"
                            echo "(dans le cas où vous souhaiteriez qu'apache réponde quelle que soit l'interface réseau, tapez *:PORT - remplacer PORT par le numéro du port choisi !!"
                            echo "(exemple : *:8081)"
                            read socketredir

                            echo "--------------------------------------"
                            echo "Veuillez m'indiquer le port d'écoute pour https"
                            echo "(exemple : 4443)"
                            read porthttps

                            echo "### VHOST $nom2 ###" > /etc/apache2/sites-available/$nom2.conf
                            printf "\n" >> /etc/apache2/sites-available/$nom2.conf
                            echo "<VirtualHost $socketredir>" >> /etc/apache2/sites-available/$nom2.conf
                            echo "     ServerName $nom2" >> /etc/apache2/sites-available/$nom2.conf
                            echo "     Redirect permanent / https://$nom2:$porthttps/" >> /etc/apache2/sites-available/$nom2.conf
                            echo "</VirtualHost>" >> /etc/apache2/sites-available/$nom2.conf
                            printf "\n" >> /etc/apache2/sites-available/$nom2.conf
                        ;;
                        n)
                            echo "### VHOST $nom2 ###" > /etc/apache2/sites-available/$nom2.conf
                            printf "\n" >> /etc/apache2/sites-available/$nom2.conf
                        ;;
                    esac




                    echo "<VirtualHost $socket>
                    ServerName $nom2
                    DocumentRoot /var/www/$nom2" >> /etc/apache2/sites-available/$nom2.conf
                    echo "ErrorLog \${APACHE_LOG_DIR}/$nom2-error.log
                    CustomLog \${APACHE_LOG_DIR}/$nom2-access.log combined" >> /etc/apache2/sites-available/$nom2.conf
                    echo "SSLEngine on
                    SSLCertificateFile $chemcert
                    SSLCertificateKeyFile $nol" >> /etc/apache2/sites-available/$nom2.conf
                    echo '<FilesMatch "\.(cgi|shtml|phtml|php)$">
                    SSLOptions +StdEnvVars
                    </FilesMatch>
                    <Directory /usr/lib/cgi-bin>
                    SSLOptions +StdEnvVars
                    </Directory>
                    </VirtualHost>' >> /etc/apache2/sites-available/$nom2.conf
                    cd /etc/apache2/sites-available/
                    a2ensite $nom2.conf

                    # Masquage de la version du service :
                    sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                    # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                    echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                    echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                    echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf

                    systemctl restart apache2
                    clear
                    echo "L'installation est terminée"
                    echo "Il ne vous reste plus qu'à faire un enregistrement DNS sur votre hôte ou votre AD avec le nom de domaine choisi ($nom2)"
                    echo "----------------------------------"
                    echo "Petit résumé"
                    echo "-----vous avez créé le DocumentRoot /var/www/$nom2"
                    echo "-----vous avez activé le vhost /etc/apache2/sites-available/default-ssl.cong"
                    echo "-----une fois votre enregistrement DNS effectué, vous pourrez vous connecter à"
                    echo "-----https://$nom2 (n'oubliez pas le :PORT dans le cas où vous avez changé le port par défaut)"
                    exit 0
                    fi  
         
                    echo '<VirtualHost _default_:443>
                    ServerAdmin webmaster@localhost

                    DocumentRoot /var/www/html
                    ErrorLog ${APACHE_LOG_DIR}/error.log
                    CustomLog ${APACHE_LOG_DIR}/access.log combined

                    SSLEngine on' > /etc/apache2/sites-available/default-ssl.conf
                
                    echo "SSLCertificateFile $chemcert
                    SSLCertificateKeyFile /etc/apache2/ssl/cleprivapache.key" >> /etc/apache2/sites-available/default-ssl.conf

                    echo '<FilesMatch "\.(cgi|shtml|phtml|php)$">
                    SSLOptions +StdEnvVars
                    </FilesMatch>
                    <Directory /usr/lib/cgi-bin>
                    SSLOptions +StdEnvVars
                    </Directory>
                    </VirtualHost>' >> /etc/apache2/sites-available/default-ssl.conf
                    cd /etc/apache2/sites-available/
                    a2ensite default-ssl.conf
                    
                    # Masquage de la version du service :
                    sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                    # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                    echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                    echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                    echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf
                    
                    
                    systemctl restart apache2
                    clear
                    echo "L'installation est terminée"
                    echo "Vous pouvez accéder au site via https://IP-SERVEUR"
                    exit 0
         
                    fi
         
         
         
         
                    echo "--------------------------------------------"
                    echo "Voulez-vous créer un vhost spécifique [o] ? Ou utiliser le vhost par défaut d'apache [n] ?"
                    read v
                    if [ "$v" == "o" ]; then
                    echo "--------------------------------------------"
                    echo "Quel nom voulez-vous donc donner à votre site ? (exemple : www.beaubois-entreprise.com)"
                    read d
                    mkdir /var/www/$d
                    echo "--------------------------------------------"
                    echo "Entrer une petite phrase à afficher dans votre index.html ? (exemple : Bienvenue sur la page du site $d)"
                    read l
                    echo "$l" > /var/www/$d/index.html
                    echo "--------------------------------------------"
                    echo "Voulez-vous auto-certifier votre serveur web [o] ou faire signer votre certificat par une autorité distante [n] ?"
                    read b
                    if [ "$b" == "o" ]; then
                    cd /etc/apache2/ssl
                    openssl genrsa 4096 > ca.key
                    openssl req -new -x509 -days 365 -nodes -key ca.key > ca.crt
                    wait
                    openssl genrsa 4096 > cleprivapache.key
                    openssl req -new -key cleprivapache.key > demandesignature.csr
                    wait
                    openssl x509 -req -in demandesignature.csr -out certifapache.crt -CA ca.crt -CAkey ca.key -CAcreateserial -days 365
                    chmod -R 600 /etc/apache2/ssl 
            
                                        clear
                    echo "--------------------------------------"
                    echo "Voulez-vous changer les ports http et/ou https par défaut d'apache ? [o/n]"
                    echo "(si vous souhaitez qu'un site soit contactable sur un autre port que 80 ou 443, cette modification est indispensable)"
                    read choix 
                    case $choix in
                        o)
                            echo "--------------------------------------"
                            echo "Voulez-vous modifier le port http par défaut (80) ? [o/n]"
                            read choix2 
                            case $choix2 in
                                o)
                                    echo "--------------------------------------"
                                    echo "Quel port voulez-vous utiliser ?"
                                    echo "(exemple : 8081)"
                                    read choixhttp

                                    sed -i "s/80/$choixhttp/" /etc/apache2/ports.conf

                                    echo "--------------------------------------"
                                    echo "Le port a bien été modifié"
                                    sleep 1
                                ;;
                                n)
                                ;;
                            esac
                            echo "--------------------------------------"
                            echo "Voulez-vous modifier le port https par défaut (443) ? [o/n]"
                            read choix23 
                            case $choix23 in
                                o)
                                    echo "--------------------------------------"
                                    echo "Quel port voulez-vous utiliser ?"
                                    echo "(exemple : 4443)"
                                    read choixhttps

                                    sed -i "s/443/$choixhttps/" /etc/apache2/ports.conf

                                    echo "--------------------------------------"
                                    echo "Le port a bien été modifié"
                                    sleep 1                             
                                ;;
                                n)
                                ;;
                            esac
                        ;;
                        n)
                        ;;
                    esac
                    clear
                    echo "--------------------------------------"
                    echo "Veuillez entrer le socket d'écoute de ce vhost (l'adresse IP:PORT sur laquelle apache répondra pour ce site - ceci dans le cas où votre serveur aurait plusieurs interfaces réseaux)"
                    echo "(exemple : 192.168.0.201:443)"
                    echo "(dans le cas où vous souhaiteriez qu'apache réponde quelle que soit l'interface réseau, tapez *:PORT - remplacer PORT par le numéro du port choisi !!"
                    echo "(exemple : *:4443)"
                    read socket
                    echo "--------------------------------------"
                    echo "Voulez-vous mettre en place une redirection http -> https pour ce vhost ? [o/n]"
                    read redir 
                    case $redir in 
                        o)
                            echo "--------------------------------------"
                            echo "Veuillez m'indiquer le socket d'écoute pour http"
                            echo "(exemple : 192.168.0.201:8081)"
                            echo "(dans le cas où vous souhaiteriez qu'apache réponde quelle que soit l'interface réseau, tapez *:PORT - remplacer PORT par le numéro du port choisi !!"
                            echo "(exemple : *:8081)"
                            read socketredir

                            echo "--------------------------------------"
                            echo "Veuillez m'indiquer le port d'écoute pour https"
                            echo "(exemple : 4443)"
                            read porthttps

                            echo "### VHOST $d ###" > /etc/apache2/sites-available/$d.conf
                            printf "\n" >> /etc/apache2/sites-available/$d.conf
                            echo "<VirtualHost $socketredir>" >> /etc/apache2/sites-available/$d.conf
                            echo "     ServerName $d" >> /etc/apache2/sites-available/$d.conf
                            echo "     Redirect permanent / https://$d:$porthttps/" >> /etc/apache2/sites-available/$d.conf
                            echo "</VirtualHost>" >> /etc/apache2/sites-available/$d.conf
                            printf "\n" >> /etc/apache2/sites-available/$d.conf
                        ;;
                        n)
                            echo "### VHOST $d ###" > /etc/apache2/sites-available/$d.conf
                            printf "\n" >> /etc/apache2/sites-available/$d.conf
                        ;;
                    esac



                    echo "<VirtualHost $socket>" >> /etc/apache2/sites-available/$d.conf
                    echo "     ServerName $d" >> /etc/apache2/sites-available/$d.conf
                    echo "     DocumentRoot /var/www/$d" >> /etc/apache2/sites-available/$d.conf
                    echo "     ErrorLog \${APACHE_LOG_DIR}/$d-error.log" >> /etc/apache2/sites-available/$d.conf
                    echo "     CustomLog \${APACHE_LOG_DIR}/$d-access.log combined" >> /etc/apache2/sites-available/$d.conf
                    echo "     SSLEngine on" >> /etc/apache2/sites-available/$d.conf
                    echo "     SSLCertificateFile /etc/apache2/ssl/certifapache.crt" >> /etc/apache2/sites-available/$d.conf
                    echo "     SSLCertificateKeyFile /etc/apache2/ssl/cleprivapache.key" >> /etc/apache2/sites-available/$d.conf
                    echo '     <FilesMatch "\.(cgi|shtml|phtml|php)$">' >> /etc/apache2/sites-available/$d.conf
                    echo "          SSLOptions +StdEnvVars" >> /etc/apache2/sites-available/$d.conf
                    echo "     </FilesMatch>" >> /etc/apache2/sites-available/$d.conf
                    echo "     <Directory /usr/lib/cgi-bin>" >> /etc/apache2/sites-available/$d.conf
                    echo "          SSLOptions +StdEnvVars" >> /etc/apache2/sites-available/$d.conf
                    echo "     </Directory>" >> /etc/apache2/sites-available/$d.conf
                    echo "</VirtualHost>" >> /etc/apache2/sites-available/$d.conf
                    cd /etc/apache2/sites-available/
                    a2ensite $d.conf
                    
                    # Masquage de la version du service :
                    sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                    # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                    echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                    echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                    echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf
                    
                    
                    systemctl restart apache2
                    clear
                    echo "----------------------------------"
                    echo "L'installation est terminée"
                    echo "Il ne vous reste plus qu'à faire un enregistrement DNS sur votre hôte ou votre AD avec le nom de domaine choisi ($d)"
                    echo "----------------------------------"
                    echo "Petit résumé"
                    echo "-----vous avez créé le DocumentRoot /var/www/$d"
                    echo "-----vous avez activé le vhost /etc/apache2/sites-available/defaul-ssl.conf"
                    echo "-----une fois votre enregistrement DNS effectué, vous pourrez vous connecter à"
                    echo "-----https://$d (n'oubliez pas le :PORT dans le cas où vous avez changé le port par défaut)"
                    exit 0
                    fi      
                    clear
                    echo "La procédure de signature par une autorité de certification distante se fait en 3 temps"
                    echo "1) Vous devez créer une clé privée pour apache"
                    echo "2) Vous devez émettre une demande de signature que vous transmettrez à l'autorité afin qu'elle vous renvoie un certificat signé"
                    echo "3) Vous devrez ensuite relancer le script et aller directement à l'étape d'intégration afin de paramétrer votre clef privée et ce certificat reçu dans les paramètres de votre vhost"
                    echo "----------------------------------"
                    echo "1) Souhaitez-créer votre clé privée pour Apache [o] ou utiliser une clef déjà existante [n] ?"
                    read c
                    if [ "$c" == "o" ]; then
                    cd /etc/apache2/ssl
                    openssl genrsa 4096 > cleprivapache.key
                    openssl req -new -key cleprivapache.key > demandesignature.csr
                    wait
                    echo "Votre demande de signature /etc/apache2/ssl/demandesignature.csr est prête"
                    echo "Vous devez la transmettre à l'autorité compétente"
                    echo "----------------------------------"
                    echo "Le script s'arrête ici. Lorsque vous aurez récupéré votre certificat signé par l'autorité distante, vous pourrez relancer le script pour l'intégrer à votre vhost"
                    exit 0
                    fi
                    cd /etc/apache2/ssl
                    clear
                    echo "Indiquez-moi le chemin absolu de votre clé privée afin que je génère la demande de signature pour une autorité distante"
                    echo "(exemple : /etc/apache2/ssl/cleprivapache.key)"
                    read chem
                    openssl req -new -key $chem > demandesignature.csr
                    clear
                    echo "Votre demande de signature /etc/apache2/ssl/demandesignature.csr est prête"
                    echo "Vous devez la transmettre à une autorité compétente"
                    echo "----------------------------------"
                    echo "Le script a terminé. Lorsque vous aurez récupéré votre certificat signé par une autorité distante, vous pourrez relancer le script pour intégration à votre vhost"
                    exit 0
                    fi
                    echo "----------------------------------"
                    echo "Voulez-vous auto-certifier votre serveur web [o] ? Ou faire signer votre certificat par une autorité distante [n] ?"
                    read b
                    if [ "$b" == "o" ]; then
                    cd /etc/apache2/ssl
                    openssl genrsa 4096 > ca.key
                    openssl req -new -x509 -days 365 -nodes -key ca.key > ca.crt
                    wait
                    openssl genrsa 4096 > cleprivapache.key
                    openssl req -new -key cleprivapache.key > demandesignature.csr
                    wait
                    openssl x509 -req -in demandesignature.csr -out certifapache.crt -CA ca.crt -CAkey ca.key -CAcreateserial -days 365
                    chmod -R 600 /etc/apache2/ssl 
            
                    echo '<VirtualHost _default_:443>
                    ServerAdmin webmaster@localhost

                    DocumentRoot /var/www/html
                    ErrorLog ${APACHE_LOG_DIR}/error.log
                    CustomLog ${APACHE_LOG_DIR}/access.log combined

                    SSLEngine on
                    SSLCertificateFile /etc/apache2/ssl/certifapache.crt
                    SSLCertificateKeyFile /etc/apache2/ssl/cleprivapache.key
                    <FilesMatch "\.(cgi|shtml|phtml|php)$">
                    SSLOptions +StdEnvVars
                    </FilesMatch>
                    <Directory /usr/lib/cgi-bin>
                    SSLOptions +StdEnvVars
                    </Directory>
                    </VirtualHost>' > /etc/apache2/sites-available/default-ssl.conf
                    cd /etc/apache2/sites-available/
                    a2ensite default-ssl.conf


                    # Masquage de la version du service :
                    sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                    # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                    echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                    echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                    echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf

                    systemctl restart apache2
                    clear
                    echo "Installation terminée"
                    echo "Vous pouvez à présent accéder au site via https://IP-SERVEUR"
                    exit 0
                    fi
                    clear
                    echo "La procédure de signature par une autorité de certification distante se fait en 3 temps"
                    echo "1) Vous devez créer une clé privée pour apache"
                    echo "2) Vous devez émettre une demande de signature que vous transmettrez à une autorité afin qu elle vous renvoie un certificat signé"
                    echo "3) Vous devrez ensuite relancer le script et aller directement l'intégrer afin de paramétrer      votre clef privée et ce certificat reçu dans les paramètres de votre vhost"
                    echo "----------------------------------"
                    echo "1) Souhaitez-vous créer votre clé privée pour Apache [o] ou utiliser une clef déjà existante [n] ?"
                    read c
                    if [ "$c" == "o" ]; then
                    cd /etc/apache2/ssl
                    openssl genrsa 4096 > cleprivapache.key
                    openssl req -new -key cleprivapache.key > demandesignature.csr
                    wait
                    clear
                    echo "Votre demande de signature /etc/apache2/ssl/demandesignature.csr est prête"
                    echo "Vous devez la transmettre à une autorité compétente"
                    echo "----------------------------------"
                    echo "Le script a terminé. Lorsque vous aurez récupéré votre certificat signé par une autorité distante, vous pourrez relancer le script pour intégration à votre vhost"
                    exit 0
                    fi
                    cd /etc/apache2/ssl
                    clear
                    echo "Indiquez-moi le chemin absolu de votre clé privée afin que je génère la demande de signature pour une autorité distante"
                    echo "(exemple : /etc/apache2/ssl/cleprivapache.key)"
                    read chem
                    openssl req -new -key $chem > demandesignature.csr
                    clear
                    echo "Votre demande de signature /etc/apache2/ssl/demandesignature.csr est prête"
                    echo "Vous devez la transmettre à une autorité compétente"
                    echo "----------------------------------"
                    echo "Le script a terminé. Lorsque vous aurez récupéré votre certificat signé par une autorité distante, vous pourrez relancer le script pour intégrer à votre vhost"
                    exit 0
                ;;
                6)
                    clear
                    echo "--------------------------------------------"
                    echo "Votre machine doit être connectée à internet pour pouvoir exécuter ce script"
                    echo "Tapez ENTRER pour continuer ou [q] pour quitter"
                    read choix
                    case $choix in
                        q)
                            exit 0
                        ;;
                    esac
                    echo "--------------------------------------------"
                    echo "Nous installons Nginx, patience !"
                    printf "\n"
                    sleep 1
                    apt update && apt upgrade -y
                    apt install nginx wget openssl -y
                    systemctl start nginx
                    systemctl enable nginx
                    mkdir /etc/nginx/ssl
                    rm /etc/nginx/sites-enabled/default
                    clear
                    echo "--------------------------------------------"
                    echo "Bienvenue dans le script de création d'un vhost HTTPS Nginx sur Debian 11+"
                    echo "--------------------------------------------"
                    echo "Si vous exécutez le script pour la première fois, tapez ENTREE, sinon tapez [i] pour l'intégration d'un certificat signé par une autorité distante"
                    read facf
                    if [ "$facf" == "i" ]; then
                        echo "--------------------------------------------"
                        echo "Indiquez-moi le chemin absolu de votre certificat signé"
                        echo "(exemple : /tmp/certisigne.crt)"
                        read chemcert
                        echo "--------------------------------------------"
                        echo "Aviez-vous créé automatiquement votre clé privée [o] ? ou aviez-vous créé votre clé vous-même [n] ?"
                        read g
                        case $g in
                            o)
                                echo "--------------------------------------------"
                                echo "Entrez le nom de votre site (exemple : www.beaubois-entreprise.com)"
                                read nom
                                clear
                                echo "--------------------------------------"
                                echo "Veuillez entrer le socket d'écoute de ce vhost (l'adresse IP:PORT sur laquelle nginx répondra pour ce site - ceci dans le cas où votre serveur aurait plusieurs interfaces réseaux)"
                                echo "(exemple : 192.168.0.201:443)"
                                echo "(dans le cas où vous souhaiteriez qu'nginx réponde quelle que soit l'interface réseau, tapez simplement le port)"
                                echo "(exemple : 4443)"
                                read socket

                                echo "--------------------------------------"
                                echo "Voulez-vous mettre en place une redirection http -> https pour ce vhost ? [o/n]"
                                read redir 
                                case $redir in 
                                    o)
                                        echo "--------------------------------------"
                                        echo "Veuillez m'indiquer le socket d'écoute pour http"
                                        echo "(exemple : 192.168.0.201:8081)"
                                        echo "(dans le cas où vous souhaiteriez que nginx réponde quelle que soit l'interface réseau, tapez *:PORT - remplacer PORT par le numéro du port choisi !!"
                                        echo "(exemple : *:8081)"
                                        read socketredir

                                        echo "--------------------------------------"
                                        echo "Veuillez m'indiquer le port d'écoute pour https"
                                        echo "(exemple : 4443)"
                                        read porthttps

                                        echo "### VHOST $nom ###" > /etc/nginx/sites-available/$nom.conf
                                        printf "\n" >> /etc/nginx/sites-available/$nom.conf
                                        echo "server {" >> /etc/nginx/sites-available/$nom.conf
                                        echo " listen $socketredir;" >> /etc/nginx/sites-available/$nom.conf
                                        echo " server_name $nom;" >> /etc/nginx/sites-available/$nom.conf
                                        echo " return 301 https://$nom:$porthttps;" >> /etc/nginx/sites-available/$nom.conf
                                        echo "}" >> /etc/nginx/sites-available/$nom.conf
                                        printf "\n" >> /etc/nginx/sites-available/$nom.conf
                                    ;;
                                    n)
                                        echo "### VHOST $nom ###" > /etc/nginx/sites-available/$nom.conf
                                        printf "\n" >> /etc/nginx/sites-available/$nom.conf
                                    ;;
                                esac
                    
                                echo "server {" >> /etc/nginx/sites-available/$nom.conf
                                echo " listen       $socket ssl;" >> /etc/nginx/sites-available/$nom.conf
                                echo " server_name  $nom;" >> /etc/nginx/sites-available/$nom.conf
                                echo " access_log /var/log/nginx/$nom-access.log combined;" >> /etc/nginx/sites-available/$nom.conf
                                print "\n" >> /etc/nginx/sites-available/$nom.conf
                                echo " ssl_certificate      $chemcert;" >> /etc/nginx/sites-available/$nom.conf
                                echo " ssl_certificate_key  /etc/nginx/ssl/cleprivnginx.key;" >> /etc/nginx/sites-available/$nom.conf
                                echo " ssl_session_cache    shared:SSL:1m;" >> /etc/nginx/sites-available/$nom.conf
                                echo " ssl_session_timeout  5m;" >> /etc/nginx/sites-available/$nom.conf
                                echo " ssl_ciphers  HIGH:!aNULL:!MD5;" >> /etc/nginx/sites-available/$nom.conf
                                echo " ssl_prefer_server_ciphers  on;" >> /etc/nginx/sites-available/$nom.conf
                                printf "\n" >> /etc/nginx/sites-available/$nom.conf
                                echo " location / {" >> /etc/nginx/sites-available/$nom.conf
                                echo "  root   /var/www/$nom;" >> /etc/nginx/sites-available/$nom.conf
                                echo "  index  index.html index.htm;" >> /etc/nginx/sites-available/$nom.conf
                                echo " }" >> /etc/nginx/sites-available/$nom.conf
                                echo "}" >> /etc/nginx/sites-available/$nom.conf
                                ln -s /etc/nginx/sites-available/$nom.conf /etc/nginx/sites-enabled/$nom.conf
                                service nginx restart
                                clear
                                echo "---------------------------------"
                                echo "L'installation est terminée"
                                echo "Il ne vous reste plus qu'à faire un enregistrement DNS sur votre hôte ou votre AD avec le nom de domaine choisi ($d)"
                                echo "----------------------------------"
                                echo "Petit résumé"
                                echo "-----vous avez créé le DocumentRoot /var/www/$nom"
                                echo "-----vous avez activé le vhost $nom"
                                echo "-----une fois votre enregistrement DNS effectué, vous pourrez vous connecter à"
                                echo "-----https://$nom (n'oubliez pas le :PORT dans le cas où vous avez changé le port par défaut)"
                                #i7=$((i7+1))
                                exit 0
                            ;;
                            n)
                                echo "--------------------------------------------"
                                echo "Indiquez-moi le chemin absolu de votre clé privée (exemple : /tmp/cleprivnginx.key)"
                                read nol
                                echo "---------------------------------------------"
                                echo "Entrez le nom de votre site (exemple : www.beaubois-entreprise.com)"
                                read nom

                                echo "--------------------------------------"
                                echo "Veuillez entrer le socket d'écoute de ce vhost (l'adresse IP:PORT sur laquelle nginx répondra pour ce site - ceci dans le cas où votre serveur aurait plusieurs interfaces réseaux)"
                                echo "(exemple : 192.168.0.201:443)"
                                echo "(dans le cas où vous souhaiteriez qu'nginx réponde quelle que soit l'interface réseau, tapez simplement le port)"
                                echo "(exemple : 4443)"
                                read socket

                                echo "--------------------------------------"
                                echo "Voulez-vous mettre en place une redirection http -> https pour ce vhost ? [o/n]"
                                read redir 
                                case $redir in 
                                    o)
                                        echo "--------------------------------------"
                                        echo "Veuillez m'indiquer le socket d'écoute pour http"
                                        echo "(exemple : 192.168.0.201:8081)"
                                        echo "(dans le cas où vous souhaiteriez que nginx réponde quelle que soit l'interface réseau, tapez *:PORT - remplacer PORT par le numéro du port choisi !!"
                                        echo "(exemple : *:8081)"
                                        read socketredir

                                        echo "--------------------------------------"
                                        echo "Veuillez m'indiquer le port d'écoute pour https"
                                        echo "(exemple : 4443)"
                                        read porthttps

                                        echo "### VHOST $nom ###" > /etc/nginx/sites-available/$nom.conf
                                        printf "\n" >> /etc/nginx/sites-available/$nom.conf
                                        echo "server {" >> /etc/nginx/sites-available/$nom.conf
                                        echo " listen $socketredir;" >> /etc/nginx/sites-available/$nom.conf
                                        echo " server_name $nom;" >> /etc/nginx/sites-available/$nom.conf
                                        echo " return 301 https://$nom:$porthttps;" >> /etc/nginx/sites-available/$nom.conf
                                        echo "}" >> /etc/nginx/sites-available/$nom.conf
                                        printf "\n" >> /etc/nginx/sites-available/$nom.conf
                                    ;;
                                    n)
                                        echo "### VHOST $nom ###" > /etc/nginx/sites-available/$nom.conf
                                        printf "\n" >> /etc/nginx/sites-available/$nom.conf
                                    ;;
                                esac

                                echo "server {" >> /etc/nginx/sites-available/$nom.conf
                                echo " listen       $socket ssl;" >> /etc/nginx/sites-available/$nom.conf
                                echo " server_name  $nom;" >> /etc/nginx/sites-available/$nom.conf
                                echo " access_log /var/log/nginx/$nom-access.log combined;" >> /etc/nginx/sites-available/$nom.conf
                                print "\n" >> /etc/nginx/sites-available/$nom.conf
                                echo " ssl_certificate      $chemcert;" >> /etc/nginx/sites-available/$nom.conf
                                echo " ssl_certificate_key  $nol;" >> /etc/nginx/sites-available/$nom.conf
                                echo " ssl_session_cache    shared:SSL:1m;" >> /etc/nginx/sites-available/$nom.conf
                                echo " ssl_session_timeout  5m;" >> /etc/nginx/sites-available/$nom.conf
                                echo " ssl_ciphers  HIGH:!aNULL:!MD5;" >> /etc/nginx/sites-available/$nom.conf
                                echo " ssl_prefer_server_ciphers  on;" >> /etc/nginx/sites-available/$nom.conf
                                printf "\n" >> /etc/nginx/sites-available/$nom.conf
                                echo " location / {" >> /etc/nginx/sites-available/$nom.conf
                                echo "  root   /var/www/$nom;" >> /etc/nginx/sites-available/$nom.conf
                                echo "  index  index.html index.htm;" >> /etc/nginx/sites-available/$nom.conf
                                echo " }" >> /etc/nginx/sites-available/$nom.conf
                                echo "}" >> /etc/nginx/sites-available/$nom.conf
                                ln -s /etc/nginx/sites-available/$nom.conf /etc/nginx/sites-enabled/$nom.conf
                                service nginx restart
                                clear
                                echo "---------------------------------"
                                echo "L'installation est terminée"
                                echo "Il ne vous reste plus qu'à faire un enregistrement DNS sur votre hôte ou votre AD avec le nom de domaine choisi ($d)"
                                echo "----------------------------------"
                                echo "Petit résumé"
                                echo "-----vous avez créé le DocumentRoot /var/www/$nom"
                                echo "-----vous avez activé le vhost $nom"
                                echo "-----une fois votre enregistrement DNS effectué, vous pourrez vous connecter à"
                                echo "-----https://$nom (n'oubliez pas le :PORT dans le cas où vous avez changé le port par défaut)"
                                sleep 5
                                #i7=$((i7+1))
                                exit 0
                            ;;
                        esac
                    fi
                    clear                  
                    echo "--------------------------------------------"
                    echo "Quel nom voulez-vous donc donner à votre site ? (exemple : www.beaubois-entreprise.com)"
                    read d
                    mkdir -p /var/www/$d
                    echo "--------------------------------------------"
                    echo "Entrer une petite phrase à afficher dans votre index.html ? (exemple : Bienvenue sur la page du site $d)"
                    read l
                    echo "$l" > /var/www/$d/index.html
                    echo "--------------------------------------------"
                    echo "Voulez-vous auto-certifier votre serveur web [o] ou faire signer votre certificat par une autorité distante [n] ?"
                    read b
                    case $b in 
                        o)
                            cd /etc/nginx/ssl
                            openssl genrsa 4096 > ca.key
                            clear
                            echo "--------------------------------------------"
                            echo "Veuillez renseigner les éléments pour la création de votre propre authorité de certification"
                            printf "\n"
                            sleep 2
                            openssl req -new -x509 -days 365 -nodes -key ca.key > ca.crt
                            wait
                            openssl genrsa 4096 > cleprivnginx.key
                            clear
                            echo "--------------------------------------------"
                            echo "Veuillez renseigner les éléments pour votre demande de signature"
                            printf "\n"
                            sleep 2
                            openssl req -new -key cleprivnginx.key > demandesignature.csr
                            wait
                            openssl x509 -req -in demandesignature.csr -out certifnginx.crt -CA ca.crt -CAkey ca.key -CAcreateserial -days 365
                            chmod -R 600 /etc/nginx/ssl 
                            clear
                            echo "--------------------------------------"
                            echo "Veuillez entrer le socket d'écoute de ce vhost (l'adresse IP:PORT sur laquelle nginx répondra pour ce site - ceci dans le cas où votre serveur aurait plusieurs interfaces réseaux)"
                            echo "(exemple : 192.168.0.201:443)"
                            echo "(dans le cas où vous souhaiteriez qu'nginx réponde quelle que soit l'interface réseau, tapez simplement le port)"
                            echo "(exemple : 4443)"
                            read socket

                            echo "--------------------------------------"
                            echo "Voulez-vous mettre en place une redirection http -> https pour ce vhost ? [o/n]"
                            read redir 
                            case $redir in 
                                o)
                                    echo "--------------------------------------"
                                    echo "Veuillez m'indiquer le socket d'écoute pour http"
                                    echo "(exemple : 192.168.0.201:8081)"
                                    echo "(dans le cas où vous souhaiteriez que nginx réponde quelle que soit l'interface réseau, tapez *:PORT - remplacer PORT par le numéro du port choisi !!"
                                    echo "(exemple : *:8081)"
                                    read socketredir

                                    echo "--------------------------------------"
                                    echo "Veuillez m'indiquer le port d'écoute pour https"
                                    echo "(exemple : 4443)"
                                    read porthttps

                                    echo "### VHOST $d ###" > /etc/nginx/sites-available/$d.conf
                                    printf "\n" >> /etc/nginx/sites-available/$d.conf
                                    echo "server {" >> /etc/nginx/sites-available/$d.conf
                                    echo "     listen $socketredir;" >> /etc/nginx/sites-available/$d.conf
                                    echo "     server_name $d;" >> /etc/nginx/sites-available/$d.conf
                                    echo "     return 301 https://$d:$porthttps;" >> /etc/nginx/sites-available/$d.conf
                                    echo "}" >> /etc/nginx/sites-available/$d.conf
                                    printf "\n" >> /etc/nginx/sites-available/$d.conf
                                ;;
                                n)
                                    echo "### VHOST $d ###" > /etc/nginx/sites-available/$d.conf
                                    printf "\n" >> /etc/nginx/sites-available/$d.conf
                                ;;
                            esac
                            
                            echo "server {" >> /etc/nginx/sites-available/$d.conf
                            echo "     listen       $socket ssl;" >> /etc/nginx/sites-available/$d.conf
                            echo "     server_name  $d;" >> /etc/nginx/sites-available/$d.conf
                            echo "     access_log /var/log/nginx/$d-access.log combined;" >> /etc/nginx/sites-available/$d.conf
                            print "\n" >> /etc/nginx/sites-available/$d.conf
                            echo "     ssl_certificate      /etc/nginx/ssl/certifnginx.crt;" >> /etc/nginx/sites-available/$d.conf
                            echo "     ssl_certificate_key  /etc/nginx/ssl/cleprivnginx.key;" >> /etc/nginx/sites-available/$d.conf
                            echo "     ssl_session_cache    shared:SSL:1m;" >> /etc/nginx/sites-available/$d.conf
                            echo "     ssl_session_timeout  5m;" >> /etc/nginx/sites-available/$d.conf
                            echo "     ssl_ciphers  HIGH:!aNULL:!MD5;" >> /etc/nginx/sites-available/$d.conf
                            echo "     ssl_prefer_server_ciphers  on;" >> /etc/nginx/sites-available/$d.conf
                            printf "\n" >> /etc/nginx/sites-available/$d.conf
                            echo "     location / {" >> /etc/nginx/sites-available/$d.conf
                            echo "          root   /var/www/$d;" >> /etc/nginx/sites-available/$d.conf
                            echo "          index  index.html index.htm;" >> /etc/nginx/sites-available/$d.conf
                            echo "     }" >> /etc/nginx/sites-available/$d.conf
                            echo "}" >> /etc/nginx/sites-available/$d.conf
                            ln -s /etc/nginx/sites-available/$d.conf /etc/nginx/sites-enabled/$d.conf 
                            service nginx restart
                            clear
                            echo "---------------------------------"
                            echo "L'installation est terminée"
                            echo "Il ne vous reste plus qu'à faire un enregistrement DNS sur votre hôte ou votre AD avec le nom de domaine choisi ($d)"
                            sleep 2
                            #i7=$((i7+1))
                            exit 0
                        ;;
                        n)
                            clear
                            echo "---------------------------------"
                            echo "La procédure de signature par une autorité de certification distante se fait en 3 temps"
                            echo "1) Vous devez créer une clé privée pour nginx"
                            echo "2) Vous devez émettre une demande de signature que vous transmettrez à l'autorité afin qu'elle vous renvoie un certificat signé"
                            echo "3) Vous devrez ensuite relancer le script et aller directement à l'étape d'intégration afin de paramétrer votre clef privée et ce certificat reçu dans les paramètres de votre vhost"
                            echo "----------------------------------"
                            echo "1) Souhaitez-vous créer votre clé privée pour Nginx [o] ou utiliser une clef déjà existante [n] ?"
                            read c
                            case $c in
                                o)
                                    cd /etc/nginx/ssl
                                    openssl genrsa 4096 > cleprivnginx.key
                                    clear
                                    echo "--------------------------------------------"
                                    echo "Veuillez renseigner les éléments pour votre demande de signature"
                                    printf "\n"
                                    sleep 2
                                    openssl req -new -key cleprivnginx.key > demandesignature.csr
                                    wait
                                    clear
                                    echo "---------------------------------"
                                    echo "Votre demande de signature /etc/nginx/ssl/demandesignature.csr ainsi que votre clef privée sont prêtes"
                                    echo "Vous devez transmettre votre demande de signature à l'autorité compétente"
                                    echo "----------------------------------"
                                    echo "Le script s'arrête ici. Lorsque vous aurez récupéré votre certificat signé par l'autorité distante, vous pourrez relancer le script pour l'intégrer à votre vhost"
                                    sleep 5
                                    exit 0
                                ;;
                                n)
                                    cd /etc/nginx/ssl
                                    clear
                                    echo "Indiquez-moi le chemin absolu de votre clé privée afin que je génère la demande de signature pour une autorité distante"
                                    echo "(exemple : /etc/nginx/ssl/cleprivnginx.key)"
                                    read chem
                                    clear
                                    echo "--------------------------------------------"
                                    echo "Veuillez renseigner les éléments pour votre demande de signature"
                                    printf "\n"
                                    sleep 2
                                    openssl req -new -key $chem > demandesignature.csr
                                    clear
                                    echo "---------------------------------"
                                    echo "Votre demande de signature /etc/nginx/ssl/demandesignature.csr est prête"
                                    echo "Vous devez la transmettre à une autorité compétente"
                                    echo "----------------------------------"
                                    echo "Le script a terminé. Lorsque vous aurez récupéré votre certificat signé par une autorité distante, vous pourrez relancer le script pour intégration à votre vhost"
                                    sleep 5
                                    exit 0
                                ;;
                            esac
                        ;;
                    esac


                ;;
                7)
                    clear
                    echo "--------------------------------------------"
                    echo "Nous installons la pile LAMP avant de commencer, patience !"
                    echo "--------------------------------------------"
                    apt update && apt upgrade -y 
                    apt install apache2 openssl mariadb-server mariadb-client php libapache2-mod-php php-cli php-mysql php-zip php-curl php-xml wget -y

                    systemctl start apache2 && systemctl enable apache2
                    systemctl start mysqld && systemctl enable mysql
                    a2enmod ssl
                    mkdir /etc/apache2/ssl

                    clear
                    echo "--------------------------------------------"
                    echo "Bienvenue dans le script de création d'un site wordpress sur apache2 pour Debian 11"
                    echo "--------------------------------------------"
                    echo "Si vous exécutez le script pour la première fois, tapez ENTREE, sinon tapez [i] pour l'intégration d'un certificat signé par une autorité distante"
                    read f
                    if [ "$f" == "i" ]; then
                            echo "--------------------------------------------"
                            echo "Indiquez-moi le chemin absolu de votre certificat signé"
                            echo "(exemple : /tmp/certisigne.crt)"
                            read chemcert
                            echo "--------------------------------------------"
                            echo "Aviez-vous créé automatiquement votre clé privée [o] ? ou aviez-vous créé votre clé vous-même [n] ?"
                            read g
                            if [ "$g" == "o" ]; then
                                echo "--------------------------------------------"
                                echo "Aviez-vous créé un vhost [o] ? Ou aviez-vous utilisé le vhost par défaut d'apache [n] ?"
                                read h
                                if [ "$h" == "o" ]; then
                                    echo "--------------------------------------------"
                                    echo "Entrez le nom de votre site (exemple : www.beaubois-entreprise.com)"
                                    read nom
                                       
                
echo "<VirtualHost _default_:443>
ServerName $nom
DocumentRoot /var/www/$nom" > /etc/apache2/sites-available/default-ssl.conf
echo "ErrorLog \${APACHE_LOG_DIR}/$nom-error.log
CustomLog \${APACHE_LOG_DIR}/$nom-access.log combined
SSLEngine on" >> /etc/apache2/sites-available/default-ssl.conf
echo "SSLCertificateFile $chemcert
SSLCertificateKeyFile /etc/apache2/ssl/clefprivapache.key" >> /etc/apache2/sites-available/default-ssl.conf
echo '<FilesMatch "\.(cgi|shtml|phtml|php)$">
SSLOptions +StdEnvVars
</FilesMatch>
<Directory /usr/lib/cgi-bin>
SSLOptions +StdEnvVars
</Directory>
</VirtualHost>' >> /etc/apache2/sites-available/default-ssl.conf
                                cd /etc/apache2/sites-available/
                                a2ensite default-ssl.conf

                                # Masquage de la version du service :
                                sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                                # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                                echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                                echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                                echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf

                                systemctl restart apache2
                                
								clear
                    			echo "--------------------------------------------"
                                echo "L'installation est terminée"
                                echo "Il ne vous reste plus qu'à faire un enregistrement DNS sur votre hôte ou votre AD avec le nom de domaine choisi ($d)"
                                echo "----------------------------------"
                                echo "Petit résumé"
                                echo "-----vous avez créé le DocumentRoot /var/www/$nom"
                                echo "-----vous avez activé le vhost /etc/apache2/sites-available/default-ssl.conf"
                                echo "-----une fois votre enregistrement DNS effectué, vous pourrez vous connecter à"
                                echo "-----https://$nom (n'oubliez pas le :PORT dans le cas où vous avez changé le port par défaut)"
                                exit 0
                
                                fi
echo '<VirtualHost _default_:443>
ServerAdmin webmaster@localhost

DocumentRoot /var/www/html
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined

SSLEngine on' > /etc/apache2/sites-available/default-ssl.conf
                
echo "SSLCertificateFile      $chemcert
SSLCertificateKeyFile /etc/apache2/ssl/cleprivapache.key" >> /etc/apache2/sites-available/default-ssl.conf

echo '<FilesMatch "\.(cgi|shtml|phtml|php)$">
SSLOptions +StdEnvVars
</FilesMatch>
<Directory /usr/lib/cgi-bin>
SSLOptions +StdEnvVars
</Directory>
</VirtualHost>' >> /etc/apache2/sites-available/default-ssl.conf
                                cd /etc/apache2/sites-available/
                                a2ensite default-ssl.conf

                                # Masquage de la version du service :
                                sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                                # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                                echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                                echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                                echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf

                                systemctl restart apache2
                                clear
                    			echo "--------------------------------------------"
                                echo "L'installation est terminée"
                                echo "Vous pouvez accéder au site via https://IP-SERVEUR"
                                exit 0
                            fi
                            echo "--------------------------------------------"
                            echo "Indiquez-moi le chemin absolu de votre clé privée (exemple : /tmp/cleprivapache.key)"
                            read nol
                            echo "---------------------------------------------"
                            echo "Aviez-vous créé un vhost [o] ? Ou aviez-vous utilisé le vhost par défaut d'apache [n] ?"
                                read k
                                if [ "$k" == "o" ]; then
                                    echo "--------------------------------------------"
                                    echo "Entrez le nom de votre site (exemple : www.beaubois-entreprise.com)"
                                    read nom2
echo "<VirtualHost _default_:443>
ServerName $nom2
DocumentRoot /var/www/$nom2" > /etc/apache2/sites-available/default-ssl.conf
echo "ErrorLog \${APACHE_LOG_DIR}/$nom2-error.log
CustomLog \${APACHE_LOG_DIR}/$nom2-access.log combined" >> /etc/apache2/sites-available/default-ssl.conf
echo "SSLEngine on
SSLCertificateFile $chemcert
SSLCertificateKeyFile $nol" >> /etc/apache2/sites-available/default-ssl.conf
echo '<FilesMatch "\.(cgi|shtml|phtml|php)$">
SSLOptions +StdEnvVars
</FilesMatch>
<Directory /usr/lib/cgi-bin>
SSLOptions +StdEnvVars
</Directory>
</VirtualHost>' >> /etc/apache2/sites-available/default-ssl.conf
                                cd /etc/apache2/sites-available/
                                a2ensite default-ssl.conf
                                
                                # Masquage de la version du service :
                                sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                                # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                                echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                                echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                                echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf

                                systemctl restart apache2
                                clear
                    			echo "--------------------------------------------"
                                echo "L'installation est terminée"
                                echo "Il ne vous reste plus qu'à faire un enregistrement DNS sur votre hôte ou votre AD avec le nom de domaine choisi ($nom2)"
                                echo "----------------------------------"
                                echo "Petit résumé"
                                echo "-----vous avez créé le DocumentRoot wordpress /var/www/$nom2"
                                echo "-----vous avez activé le vhost /etc/apache2/sites-available/default-ssl.conf"
                                echo "-----une fois votre enregistrement DNS effectué, vous pourrez vous connecter à"
                                echo "-----https://$nom2 (n'oubliez pas le :PORT dans le cas où vous avez changé le port par défaut)"
                                exit 0
                             fi  
         
echo '<VirtualHost _default_:443>
ServerAdmin webmaster@localhost

DocumentRoot /var/www/html
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined

SSLEngine on' > /etc/apache2/sites-available/default-ssl.conf
                
echo "SSLCertificateFile $chemcert
SSLCertificateKeyFile /etc/apache2/ssl/cleprivapache.key" >> /etc/apache2/sites-available/default-ssl.conf

echo '<FilesMatch "\.(cgi|shtml|phtml|php)$">
SSLOptions +StdEnvVars
</FilesMatch>
<Directory /usr/lib/cgi-bin>
SSLOptions +StdEnvVars
</Directory>
</VirtualHost>' >> /etc/apache2/sites-available/default-ssl.conf
                                cd /etc/apache2/sites-available/
                                a2ensite default-ssl.conf
                                
                                # Masquage de la version du service :
                                sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                                # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                                echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                                echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                                echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf

                                systemctl restart apache2
                                clear
                    			echo "--------------------------------------------"
                                echo "L'installation est terminée"
                                echo "Vous pouvez accéder au site via https://IP-SERVEUR"
                                exit 0
         
                    fi
         
         
         
         
                    echo "--------------------------------------------"
                    echo "Voulez-vous créer un vhost spécifique [o] ? Ou utiliser le vhost par défaut d'apache [n] ?"
                    read v
                    if [ "$v" == "o" ]; then
                            echo "--------------------------------------------"
                            echo "Quel nom voulez-vous donc donner à votre site ? (exemple : www.beaubois-entreprise.com)"
                            read d
                            mkdir /var/www/$d
                            echo "--------------------------------------------"
                            echo "Veuillez à présent configurer le script mysql_secure_installation"
                            mysql_secure_installation
                            wait

                            clear
                    		echo "--------------------------------------------"
                            echo "Quel nom voulez-vous donner à la base SQL de wordpress ? (exemple : wordpressdb)"
                            read dbname
                            echo "--------------------------------------------"
                            echo "Quel nom d'utilisateur privilégié de la base $dbname voulez-vous créer ? (exemple : admin)"
                            read dbuser
                            echo "--------------------------------------------"
                            echo "Quel mot de passe pour l'utilisateur $dbuser voulez-vous créer ?"
                            read dbpasswd
                            mysqladmin -uroot create $dbname
                            mysql -uroot -e"GRANT ALL ON $dbname.* TO $dbuser@localhost IDENTIFIED BY \"$dbpasswd\""
                            wget http://wordpress.org/latest.tar.gz -P /tmp
                            tar -xvzf /tmp/latest.tar.gz
                            mv wordpress/* /var/www/$d
                            cd /var/www/$d
                            cp wp-config-sample.php wp-config.php
                            sed -i "s/database_name_here/$dbname/" wp-config.php
                            sed -i "s/username_here/$dbuser/" wp-config.php
                            sed -i "s/password_here/$dbpasswd/" wp-config.php
                            chown -R www-data:www-data /var/www
                            clear
                            echo "--------------------------------------------"
                            echo "Voulez-vous auto-certifier votre serveur web [o] ou faire signer votre certificat par une autorité distante [n] ?"
                            read b
                            if [ "$b" == "o" ]; then
                               cd /etc/apache2/ssl
                                openssl genrsa 4096 > ca.key
                                openssl req -new -x509 -days 365 -nodes -key ca.key > ca.crt
                                wait
                                openssl genrsa 4096 > cleprivapache.key
                                openssl req -new -key cleprivapache.key > demandesignature.csr
                                wait
                                openssl x509 -req -in demandesignature.csr -out certifapache.crt -CA ca.crt -CAkey ca.key -CAcreateserial -days 365
                                chmod -R 600 /etc/apache2/ssl 
            
echo "<VirtualHost _default_:443>
ServerName $d
DocumentRoot /var/www/$d" > /etc/apache2/sites-available/default-ssl.conf
echo 'ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
SSLEngine on
SSLCertificateFile /etc/apache2/ssl/certifapache.crt
SSLCertificateKeyFile /etc/apache2/ssl/cleprivapache.key
<FilesMatch "\.(cgi|shtml|phtml|php)$">
SSLOptions +StdEnvVars
</FilesMatch>
<Directory /usr/lib/cgi-bin>
SSLOptions +StdEnvVars
</Directory>
</VirtualHost>' >> /etc/apache2/sites-available/default-ssl.conf
                                cd /etc/apache2/sites-available/
                                a2ensite default-ssl.conf
                                
                                # Masquage de la version du service :
                                sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                                # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                                echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                                echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                                echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf
                                
                                systemctl restart apache2
                                clear
                    			echo "--------------------------------------------"
                                echo "L'installation est terminée"
                                echo "Il ne vous reste plus qu'à faire un enregistrement DNS sur votre hôte ou votre AD avec le nom de domaine choisi ($d)"
                                echo "----------------------------------"
                                echo "Petit résumé"
                                echo "-----vous avez créé le DocumentRoot wordpress /var/www/$d"
                                echo "-----vous avez activé le vhost /etc/apache2/sites-available/defaul-ssl.conf"
                                echo "-----une fois votre enregistrement DNS effectué, vous pourrez vous connecter à"
                                echo "-----https://$d (n'oubliez pas le :PORT dans le cas où vous avez changé le port par défaut)"
                                exit 0
                            fi
                                clear
                    			echo "--------------------------------------------"
                                echo "La procédure de signature par une autorité de certification distante se fait en 3 temps"
                                echo "1) Vous devez créer une clé privée pour apache"
                                echo "2) Vous devez émettre une demande de signature que vous transmettrez à l'autorité afin qu'elle vous renvoie un certificat signé"
                                echo "3) Vous devrez ensuite relancer le script et aller directement à l'étape d'intégration afin de paramétrer votre clef privée et ce certificat reçu dans les paramètres de votre vhost"
                                echo "----------------------------------"
                                echo "1) Souhaitez-créer votre clé privée pour Apache [o] ou utiliser une clef déjà existante [n] ?"
                                read c
                                if [ "$c" == "o" ]; then
                                    cd /etc/apache2/ssl
                                    openssl genrsa 4096 > cleprivapache.key
                                    openssl req -new -key cleprivapache.key > demandesignature.csr
                                    wait
                    				echo "--------------------------------------------"
                                    echo "Votre demande de signature /etc/apache2/ssl/demandesignature.csr est prête"
                                    echo "Vous devez la transmettre à l'autorité compétente"
                                    echo "----------------------------------"
                                    echo "Le script s'arrête ici. Lorsque vous aurez récupéré votre certificat signé par l'autorité                     distante, vous pourrez relancer le script pour l'intégrer à votre vhost"
                                    exit 0
                               fi
                                    cd /etc/apache2/ssl
                                    clear
                    				echo "--------------------------------------------"
                                    echo "Indiquez-moi le chemin absolu de votre clé privée afin que je génère                     la demande de signature pour une autorité distante"
                                    echo "(exemple : /etc/apache2/ssl/cleprivapache.key)"
                                    read chem
                                    openssl req -new -key $chem > demandesignature.csr
                                    clear
                    				echo "--------------------------------------------"
                                    echo "Votre demande de signature /etc/apache2/ssl/demandesignature.csr est prête"
                                    echo "Vous devez la transmettre à une autorité compétente"
                                    echo "----------------------------------"
                                    echo "Le script a terminé. Lorsque vous aurez récupéré votre certificat signé par une autorité distante, vous pourrez relancer le script pour intégration à votre vhost"
                                    exit 0
                    fi                    
                        echo "----------------------------------"
                        echo "Veuillez à présent configurer le script mysql_secure_installation"
                            mysql_secure_installation
                            wait
                            clear
                    		echo "--------------------------------------------"
                            echo "Quel nom voulez-vous donner à la base SQL de wordpress ? (exemple : wordpressdb)"
                            read dbname
                            echo "--------------------------------------------"
                            echo "Quel nom d'utilisateur privilégié de la base $dbname voulez-vous créer ? (exemple : admin)"
                            read dbuser
                            echo "--------------------------------------------"
                            echo "Quel mot de passe pour l'utilisateur $dbuser voulez-vous créer ?"
                            read dbpasswd
                            mysqladmin -uroot create $dbname
                            mysql -uroot -e"GRANT ALL ON $dbname.* TO $dbuser@localhost IDENTIFIED BY \"$dbpasswd\""
                            wget http://wordpress.org/latest.tar.gz -P /tmp
                            tar -xvzf /tmp/latest.tar.gz
                            rm /var/www/html/index.html
                            mv wordpress/* /var/www/html
                            cd /var/www/html
                            cp wp-config-sample.php wp-config.php
                            sed -i "s/database_name_here/$dbname/" wp-config.php
                            sed -i "s/username_here/$dbuser/" wp-config.php
                            sed -i "s/password_here/$dbpasswd/" wp-config.php
                            chown -R www-data:www-data /var/www
                            clear
                    	echo "--------------------------------------------"
                        echo "Voulez-vous auto-certifier votre serveur web [o] ? Ou faire signer votre certificat par une autorité distante [n] ?"
                            read b
                            if [ "$b" == "o" ]; then
                                cd /etc/apache2/ssl
                                openssl genrsa 4096 > ca.key
                                openssl req -new -x509 -days 365 -nodes -key ca.key > ca.crt
                                wait
                                openssl genrsa 4096 > cleprivapache.key
                                openssl req -new -key cleprivapache.key > demandesignature.csr
                                wait
                                openssl x509 -req -in demandesignature.csr -out certifapache.crt -CA ca.crt -CAkey ca.key -CAcreateserial -days 365
                                chmod -R 600 /etc/apache2/ssl 
            
echo '<VirtualHost _default_:443>
ServerAdmin webmaster@localhost

DocumentRoot /var/www/html
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined

SSLEngine on
SSLCertificateFile /etc/apache2/ssl/certifapache.crt
SSLCertificateKeyFile /etc/apache2/ssl/cleprivapache.key
<FilesMatch "\.(cgi|shtml|phtml|php)$">
SSLOptions +StdEnvVars
</FilesMatch>
<Directory /usr/lib/cgi-bin>
SSLOptions +StdEnvVars
</Directory>
</VirtualHost>' > /etc/apache2/sites-available/default-ssl.conf
                                cd /etc/apache2/sites-available/
                                a2ensite default-ssl.conf
                                
                                # Masquage de la version du service :
                                sed -i 's/ServerSignature On/ServerSignature Off/g' /etc/apache2/conf-enabled/security.conf

                                # Désactiver la lisibilité des fichiers présents  dans les dossiers.
                                echo '<Directory /var/www>' >> /etc/apache2/conf-enabled/security.conf
                                echo '  Options -Indexes' >> /etc/apache2/conf-enabled/security.conf
                                echo '</Directory>' >> /etc/apache2/conf-enabled/security.conf


                                systemctl restart apache2
                                clear
                    			echo "--------------------------------------------"
                                echo "Installation terminée"
                                echo "Vous pouvez à présent accéder au site via https://IP-SERVEUR"
                                exit 0
                            fi
                                clear
                    			echo "--------------------------------------------"
                                echo 'La procédure de signature par une autorité de certification distante se fait en 3 temps'
                                echo '1) Vous devez créer une clé privée pour apache'
                                echo '2) Vous devez émettre une demande de signature que vous transmettrez à une autorité afin qu elle vous renvoie un certificat signé'
                                echo '3) Vous devrez ensuite relancer le script et aller directement lintégrer afin de paramétrer votre clef privée et ce certificat reçu dans les paramètres de votre vhost'
                                echo "----------------------------------"
                                echo "1) Souhaitez-vous créer votre clé privée pour Apache [o] ou utiliser une clef déjà existante [n] ?"
                                read c
                                if [ "$c" == "o" ]; then
                                   cd /etc/apache2/ssl
                                    openssl genrsa 4096 > cleprivapache.key
                                    openssl req -new -key cleprivapache.key > demandesignature.csr
                                    wait
                                    clear
                                    echo "Votre demande de signature /etc/apache2/ssl/demandesignature.csr est prête"
                                    echo "Vous devez la transmettre à une autorité compétente"
                                    echo "----------------------------------"
                                    echo "Le script a terminé. Lorsque vous aurez récupéré votre certificat signé par une autorité distante, vous pourrez relancer le script pour intégration à votre vhost"
                                    exit 0
                                fi
                                    cd /etc/apache2/ssl
                                    clear
                    				echo "--------------------------------------------"
                                    echo "Indiquez-moi le chemin absolu de votre clé privée afin que je génère la demande de signature pour une autorité distante"
                                    echo "(exemple : /etc/apache2/ssl/cleprivapache.key)"
                                    read chem
                                    openssl req -new -key $chem > demandesignature.csr
                                   clear
                    				echo "--------------------------------------------"
                                    echo "Votre demande de signature /etc/apache2/ssl/demandesignature.csr est prête"
                                    echo "Vous devez la transmettre à une autorité compétente"
                                    echo "----------------------------------"
                                    echo "Le script a terminé. Lorsque vous aurez récupéré votre certificat signé par une autorité distante, vous pourrez relancer le script pour intégrer à votre vhost"
                                    exit 0
                ;;
                8)
                    clear
                    echo "----------------------------------"
                    echo "1) Souhaitez-vous créer votre clé privée [o] ou utiliser une clé déjà existante [n] ?"
                    read c
                    if [ "$c" == "o" ]; then
                        mkdir /SSL-tmp
                        cd /SSL-tmp
                        openssl genrsa 4096 > cleprivee.key
                        openssl req -new -key cleprivee.key > demandesignature.csr
                        wait
                        clear
                        echo "----------------------------------"
                        echo "Votre clé privée et votre demande de signature sont prêts"
                        echo "Vous les trouverez dans le dossier /SSL-tmp"
                        echo "Vous devez transmettre votre demande de signature à une autorité compétente"
                        echo "----------------------------------"
                        echo "Appuyez sur ENTRER pour revenir au menu principal"
                        read prcen1
                        break
                    fi
                        clear
                        mkdir /SSL-tmp
                        cd /SSL-tmp
                        echo "----------------------------------"
                        echo "Indiquez-moi le chemin absolu de votre clé privée afin que je génère la demande de signature pour une autorité distante"
                        echo "(exemple : /etc/apache2/ssl/cleprivapache.key)"
                        read chem
                        openssl req -new -key $chem > demandesignature.csr
                        clear
                        echo "----------------------------------"
                        echo "Votre demande de signature est prête"
                        echo "Vous la trouverez dans le dossier /SSL-tmp"
                        echo "Vous devez la transmettre à une autorité compétente"
                        echo "----------------------------------"
                        echo "Appuyez sur ENTRER pour revenir au menu principal"
                        read prcen
                        break
                    
                ;;
                r)
                    i7=$((i7+25))
                ;;
                esac
                done
iprinc=$((iprinc+1))
fi
if [ "$choix" == "8" ]; then
    clear
    i8=0
    while [ $i8 -lt 24 ]; do
    echo "-----------------------------------"
    echo "Ce script ne permet pour l'instant que de (re)créer une seule partition par disque"
    echo "Pour du partitionnement plus poussé, veuillez quitter ce script et utiliser fdisk"
    echo "-----------------------------------"    
    echo "Tapez sur ENTREE pour continuer, q pour quitter"
    read atd
        if [ "$atd" == "q" ]; then
            break
        fi
    clear
    echo "-----------------------------------"
    echo "Nous installons les outils nécessaires, patience !"
    echo "-----------------------------------"
    sleep 2s
    apt install ntfs-3g -y
    clear
    echo "-----------------------------------"
    echo "Repérez le disque sur lequel vous souhaitez créer la partition (exemple : /dev/sdb)"
    echo "-----------------------------------"
    fdisk -l | grep Disque
    echo "-----------------------------------"
    echo "Entrez le chemin du disque (exemple : /dev/sdb)"
    read pathdi
    umount -a
    clear
    echo "-----------------------------------"
    echo "Voulez-vous créer un point de montage [o] ou utiliser un répertoire déjà existant [n] ?"
    read mntp
    case "$mntp" in
        "o")
            echo "-----------------------------------"
            echo "Veuillez indiquer le chemin absolu du point de montage à créer (exemple : /mnt/path)"
            read pthm
            rm -rf $pthm
            mkdir -p $pthm
            echo "-----------------------------------"
            echo "Votre point de montage a été créé"
            sleep 1s
        ;;
        "n")
            echo "-----------------------------------"
            echo "Veuillez indiquer le chemin absolu du point de montage à utiliser (exemple : /mnt)"
            read pthm
            rm -rf $pthm
            mkdir -p $pthm
        ;;
    esac
    clear
    echo "-----------------------------------"
    echo "Quel type de partition voulez-vous créer ? ('ext4' ou 'ntfs' uniquement)"
    read extnt
    echo "-----------------------------------"
    case "$extnt" in
        "ext4")
            printf "d\nn\np\n\n\n\nO\n\nw\n" | fdisk $pathdi --wipe auto
            pathdi1="$pathdi""1"
            mkfs.ext4 $pathdi1
            mount $pathdi1 $pthm
        ;;
        "ntfs")
            printf "d\nn\np\n\n\n\nO\n\nt\n07\nw\n" | fdisk $pathdi --wipe auto
            pathdi1="$pathdi""1"
            umount $pathdi1
            mkntfs $pathdi1
            mount -t auto $pathdi1 $pthm
        ;;
    esac
    clear
    echo "-----------------------------------"
    fdisk -l | grep $pathdi1
    echo "-----------------------------------"
    echo "Votre partition a bien été créée et montée"
    sleep 2s
    break
    done
iprinc=$((iprinc+1))
fi
if [ "$choix" == "9" ]; then
        clear
        i9=0
        while [ $i9 -lt 24 ]; do
        clear
        echo "--------------------------------------"
        echo "#         Programmes divers          #"
        echo "--------------------------------------"
        echo "[1] - Serveur FTP(S) VsFTPd"
        echo "[2] - Serveur mail Postfix"
        echo "[3] - Webmin"
        echo "--------------------------------------"
        echo "[r] - REVENIR AU MENU PRECEDENT"
        echo "--------------------------------------"
        echo "Entrez le numéro du menu voulu"
        read choix91
            case "$choix91" in
                "1")
                    clear
                    echo "-------------------------------------"
                    echo "Nous installons VsFTPd, Patience !"
                    echo "-------------------------------------"
                    echo "Par défaut, les utilisateurs du service seront les utilisateurs linux créés sur votre serveur."
                    echo "Ils seront chrootés dans leur dossier racine linux respectif (ils ne pourront pas en sortir)"
                    echo "Appuyez sur ENTRER pour continuer"
                    read ENTER
                    apt install vsftpd openssl -y
		    systemctl enable vsftpd
                    cp /etc/vsftpd.conf /etc/vsftpd.conf.BAK
                    printf "\n" >> /etc/vsftpd.conf

		    clear
		    echo "-------------------------------------"
		    echo "Voulez-vous configurer un serveur pour anonymes ? [o/n]"
	            read answer
   		    case $answer in
		    	"o")
				mkdir -p /srv/ftp/ANON/PUBLIC
				chown nobody:nogroup /srv/ftp/ANON
				chmod a+rwx /srv/ftp/ANON/PUBLIC

                    		echo "### CONFIG SCRIPT ###" > /etc/vsftpd.conf
				echo "listen=NO" >> /etc/vsftpd.conf
				echo "listen_ipv6=YES" >> /etc/vsftpd.conf
				echo "" >> /etc/vsftpd.conf

				echo "anonymous_enable=YES" >> /etc/vsftpd.conf
				echo "anon_root=/srv/ftp/ANON" >> /etc/vsftpd.conf
				echo "no_anon_password=YES" >> /etc/vsftpd.conf
				echo "hide_ids=YES" >> /etc/vsftpd.conf

				echo "-------------------------------------"
				echo "Voulez-vous donner aux anonymes le droit d'écrire et de téléverser ? [o/n]"
				read answer2

				case $answer2 in
					"o")
						echo "write_enable=YES" >> /etc/vsftpd.conf
						echo "anon_upload_enable=YES" >> /etc/vsftpd.conf
						echo "anon_mkdir_write_enable=YES" >> /etc/vsftpd.conf
						echo "anon_umask=022" >> /etc/vsftpd.conf
						echo "anon_other_write_enable=YES" >> /etc/vsftpd.conf
					;;
					"n")
					;;
				esac

				echo "local_enable=YES" >> /etc/vsftpd.conf
				echo "dirmessage_enable=YES" >> /etc/vsftpd.conf
				echo "use_localtime=YES" >> /etc/vsftpd.conf
				echo "xferlog_enable=YES" >> /etc/vsftpd.conf
				echo "connect_from_port_20=YES" >> /etc/vsftpd.conf
				echo "secure_chroot_dir=/var/run/vsftpd/empty" >> /etc/vsftpd.conf
				echo "pam_service_name=vsftpd" >> /etc/vsftpd.conf

				# Bon à savoir, pas de session anonyme en FTPS !
				echo "rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem" >> /etc/vsftpd.conf
				echo "rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key" >> /etc/vsftpd.conf
				echo "ssl_enable=NO" >> /etc/vsftpd.conf

                                    echo "-------------------------------------"
                                    echo "Voulez-vous ajouter une ou plusieurs IP spécifique(s) sur la(les)quelle(s) le serveur sera en écoute ? [o/n]"
                                    echo "Il ne répondra QUE sur l'(es) IP(s) spécifiée(s)"
                                    echo "Il s'agît, bien évidemment d'IP(s) de VOTRE SERVEUR ! (dans le cas où ce dernier aurait plusieurs interfaces)"
				    echo "Par défaut, si vous répondez n, VsFTPd répondra sur toutes les interfaces du serveur"
                                    read choix  
                                    case $choix in
                                        "o")   
                                            echo "-------------------------------------"
                                            echo "Veuillez entrer l'IP (ou les IPs, séparées d'une virgule)"
                                            echo "Attention, pas d'IP réseau !"
                                            echo "(exemple : 192.168.0.10)"
                                            echo "(exemple : 192.168.0.10,172.16.0.25)"
                                            read listenaddress
					    echo "" >> /etc/vsftpd.conf
                                            echo "listen=YES" >> /etc/vsftpd.conf
                                            echo "listen_address=$listenaddress" >> /etc/vsftpd.conf
					;;
					"n")
				esac

	
				systemctl restart vsftpd

				clear
		    		echo "-------------------------------------"
				echo "L'installation est terminée"
				echo "Le répertoire des anonymes se trouvent dans /srv/ftp/ANON"
				echo "Ils peuvent écrire et téléverser dans /srv/ftp/ANON/PUBLIC"
				echo "Appuyez sur [ENTRER] pour quitter"
				read enter
				break
   			  ;;
   			"n")
			;;
		    esac
                    echo "### CONFIG SCRIPT ###" >> /etc/vsftpd.conf
                    echo "write_enable=YES" >> /etc/vsftpd.conf
                    echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf
                    echo "chroot_local_user=YES" >> /etc/vsftpd.conf
                    #chmod 701 /home
                    #chmod 701 /
                    clear
                    echo "-------------------------------------"
                    echo "Souhaitez-vous configurer l'accès over SSL (FTPS) ? [o/n]"
                    read ovss
                    case "$ovss" in
                        "o")
                            sed -i "s/ssl_enable=NO/ssl_enable=YES/" /etc/vsftpd.conf
                            echo "force_local_data_ssl=YES" >> /etc/vsftpd.conf
                            #echo "write_enable=YES" >> /etc/vsftpd.conf
                            #echo "allow_writeable_chroot=NO" >> /etc/vsftpd.conf
                            #echo "chroot_local_user=NO" >> /etc/vsftpd.conf
                            echo "ssl_sslv2=YES" >> /etc/vsftpd.conf
                            echo "ssl_sslv3=YES" >> /etc/vsftpd.conf
                            echo "ssl_tlsv1=YES" >> /etc/vsftpd.conf
                            echo "-------------------------------------"
                            echo "Souhaitez-vous autoriser les connexions anonymes ? [o/n]"
                            read ano
                            case "$ano" in
                                "o")
                                    sed -i "s/anonymous/#anonymous/" /etc/vsftpd.conf
                                    echo "anonymous_enable=YES" >> /etc/vsftpd.conf
                                    echo "allow_anon_ssl=YES" >> /etc/vsftpd.conf
                                    echo "force_anon_data_ssl=YES" >> /etc/vsftpd.conf
                                    echo "no_anon_password=YES" >> /etc/vsftpd.conf
                                    clear
                                    echo "-------------------------------------"
                                    echo "Je configure le répertoire /var/FTP/PUBLIC pour les anonymes"
				    sleep 2
				    mkdir -p /var/FTP/PUBLIC
				    chown nobody:nogroup /var/FTP/PUBLIC
                                    echo "anon_root=/var/FTP/PUBLIC" >> /etc/vsftpd.conf
				    echo "hide_ids=YES" >> /etc/vsftpd.conf
              			    clear
                                    echo "-------------------------------------"
                                    echo "Voulez-vous autoriser les anonymes à écrire dans le répertoire /var/FTP/PUBLIC ? [o/n]"
                                    read answer
				    case $answer in
    				    	"o")
						echo "write_enable=YES" >> /etc/vsftpd.conf
						echo "anon_upload_enable=YES" >> /etc/vsftpd.conf
					;;
					"n")
					;;
				    esac
                                    clear
                                    echo "-------------------------------------"
                                    echo "Voulez-vous ajouter une ou plusieurs IP spécifique(s) sur la(les)quelle(s) le serveur sera en écoute ? [o/n]"
                                    echo "Il ne répondra QUE sur l'(es) IP(s) spécifiée(s)"
                                    echo "Il s'agît, bien évidemment d'IP(s) de VOTRE SERVEUR ! (dans le cas où ce dernier aurait plusieurs interfaces)"
                                    read choix  
                                    case $choix in
                                        o)   
                                            echo "-------------------------------------"
                                            echo "Veuillez entrer l'IP (ou les IPs, séparées d'une virgule)"
                                            echo "Attention, pas d'IP réseau !"
                                            echo "(exemple : 192.168.0.10)"
                                            echo "(exemple : 192.168.0.10,172.16.0.25)"
                                            read listenaddress
                                            echo "listen=YES" >> /etc/vsftpd.conf
                                            echo "listen_address=$listenaddress" >> /etc/vsftpd.conf
                                        ;;
                                        n)
                                        ;;
                                    esac
                                    systemctl restart vsftpd
                                    clear       
                                    echo "-------------------------------------"
                                    echo "L'installation est terminée"
                                    sleep 2s
                                    clear
                                ;;
                                "n")
                                    clear
                                    echo "-------------------------------------"
                                    echo "Voulez-vous ajouter une ou plusieurs IP spécifique(s) sur la(les)quelle(s) le serveur sera en écoute ? [o/n]"
                                    echo "Il ne répondra QUE sur l'(es) IP(s) spécifiée(s)"
                                    echo "Il s'agît, bien évidemment d'IP(s) de VOTRE SERVEUR ! (dans le cas où ce dernier aurait plusieurs interfaces)"
                                    read choix  
                                    case $choix in
                                        o)   
                                            echo "-------------------------------------"
                                            echo "Veuillez entrer l'IP (ou les IPs, séparées d'une virgule)"
                                            echo "Attention, pas d'IP réseau !"
                                            echo "(exemple : 192.168.0.10)"
                                            echo "(exemple : 192.168.0.10,172.16.0.25)"
                                            read listenaddress
                                            echo "listen=YES" >> /etc/vsftpd.conf
                                            echo "listen_address=$listenaddress" >> /etc/vsftpd.conf
                                        ;;
                                        n)
                                        ;;
                                    esac
                                    clear 
                                    systemctl restart vsftpd
                                    clear
                                    echo "-------------------------------------"
                                    echo "L'installation est terminée"
                                    sleep 2s
                                    clear
                                ;;
                            esac
                        ;;
                        "n")
                            echo "Souhaitez-vous autoriser les connexions anonymes ? [o/n]"
                            read ano1
                            case "$ano1" in
                                "o")
                                    sed -i "s/anonymous/#anonymous/" /etc/vsftpd.conf
                                    echo "anonymous_enable=YES" >> /etc/vsftpd.conf
                                    echo "no_anon_password=YES" >> /etc/vsftpd.conf
                                    clear
                                    echo "-------------------------------------"
                                    echo "Je configure le répertoire /var/FTP/PUBLIC pour les anonymes"
				    sleep 2
				    mkdir -p /var/FTP/PUBLIC
				    chown nobody:nogroup /var/FTP/PUBLIC
                                    echo "anon_root=/var/FTP/PUBLIC" >> /etc/vsftpd.conf
				    echo "hide_ids=YES" >> /etc/vsftpd.conf
				    clear
                                    echo "-------------------------------------"
                                    echo "Voulez-vous autoriser les anonymes à écrire dans le répertoire /var/FTP/PUBLIC ? [o/n]"
                                    read answer
				    case $answer in
    				    	"o")
						echo "write_enable=YES" >> /etc/vsftpd.conf
						echo "anon_upload_enable=YES" >> /etc/vsftpd.conf
					;;
					"n")
					;;
				    esac
                                    clear
                                    echo "-------------------------------------"
                                    echo "Voulez-vous ajouter une ou plusieurs IP spécifique(s) sur la(les)quelle(s) le serveur sera en écoute ? [o/n]"
                                    echo "Il ne répondra QUE sur l'(es) IP(s) spécifiée(s)"
                                    echo "Il s'agît, bien évidemment d'IP(s) de VOTRE SERVEUR ! (dans le cas où ce dernier aurait plusieurs interfaces)"
                                    read choix  
                                    case $choix in
                                        o)   
                                            echo "-------------------------------------"
                                            echo "Veuillez entrer l'IP (ou les IPs, séparées d'une virgule)"
                                            echo "Attention, pas d'IP réseau !"
                                            echo "(exemple : 192.168.0.10)"
                                            echo "(exemple : 192.168.0.10,172.16.0.25)"
                                            read listenaddress
                                            sed -i 's/listen=NO/listen=YES/' /etc/vsftpd.conf
                                            echo "listen_address=$listenaddress" >> /etc/vsftpd.conf
                                        ;;
                                        n)
                                        ;;
                                    esac
                                    clear 
                                    systemctl restart vsftpd
                                    clear                        
                                    echo "-------------------------------------"
                                    echo "L'installation est terminée"
                                    sleep 2s 
                                    clear
                                ;;
                                "n")
                                    clear
                                    clear
                                    echo "-------------------------------------"
                                    echo "Voulez-vous ajouter une ou plusieurs IP spécifique(s) sur la(les)quelle(s) le serveur sera en écoute ? [o/n]"
                                    echo "Il ne répondra QUE sur l'(es) IP(s) spécifiée(s)"
                                    echo "Il s'agît, bien évidemment d'IP(s) de VOTRE SERVEUR ! (dans le cas où ce dernier aurait plusieurs interfaces)"
                                    read choix  
                                    case $choix in
                                        o)   
                                            echo "-------------------------------------"
                                            echo "Veuillez entrer l'IP (ou les IPs, séparées d'une virgule)"
                                            echo "Attention, pas d'IP réseau !"
                                            echo "(exemple : 192.168.0.10)"
                                            echo "(exemple : 192.168.0.10,172.16.0.25)"
                                            read listenaddress
                                            sed -i 's/listen=NO/listen=YES/' /etc/vsftpd.conf
                                            echo "listen_address=$listenaddress" >> /etc/vsftpd.conf
                                        ;;
                                        n)
                                        ;;
                                    esac
                                    clear 
                                    systemctl restart vsftpd
                                    echo "-------------------------------------"
                                    echo "L'installation est terminée"
                                    sleep 2s
                                    clear
                                ;;
                            esac                    
                        ;;
                    esac
                    i9=$((i9+1))
                ;;
                "2")
                    clear
                    echo "--------------------------------------"
                    echo "Pour fonctionner convenablement, votre machine doit avoir un FQDN complet"
                    echo "Il peut advenir que ça ne fonctionne pas derrière une box internet privée"
                    echo "--------------------------------------"
                    echo "Lors de l'installation de Postfix, un écran va apparaître."
                    echo "Vous devrez sélectionnez 'Site Web'"
                    echo "A l'écran suivant, votre FQDN devrait appaître en temps que Nom de Courrier."
                    echo "(pour rappel, votre FQDN est votre hostname.nom-de-domaine)."
                    echo "Laissez inchangé si votre FQDN s'affiche, sinon vous devrez l'indiquer manuellement"
                    echo "--------------------------------------"
                    echo "Appuyez sur ENTRER pour commencer"
                    read zz
                    clear
                    echo "--------------------------------------"
                    echo "L'installation de Postfix va commencer"
                    sleep 2s
                    apt install postfix -y
                    wait
                    systemctl restart postfix && systemctl enable postfix
                    clear
                    echo "--------------------------------------"
                    echo "Postfix est à présent installé"
                    echo "Souhaitez-vous procéder à l'envoi d'un message pour tester ? [o/n]"
                    read pstans
                    case "$pstans" in
                        "o")
                            clear
                            echo "--------------------------------------"
                            echo "Veuillez entrer l'adresse email du destinataire"
                            read desta
                            echo "--------------------------------------"
                            echo "Quel est l'objet de cet email ?"
                            read objm
                            echo "--------------------------------------"        
                            echo "Veuillez entrer le texte de votre message"
                            read bodym
                            mail -s $objm $desta <<< $bodym
                            echo "--------------------------------------"
                            echo "Votre email a bien été envoyé"
                            echo "--------------------------------------"
                            i9=$((i9+1))
                        ;;
                        "n")
                            i9=$((i9+25))
                        ;;
                    esac
                    i9=$((i9+1))
                ;;
                "3")
                    clear
                    echo "--------------------------------------------------"
                    echo "L'installation de Webmin est en cours, patience !"
                    echo "--------------------------------------------------"
                    sleep 2s
                    
                    #Vérification installation précedente
                    n=$(find /var -name "*webmin*" | wc -l)
                    if [ $(command -v webmin) ] || [ $n -ge 1 ]; then
                            clear
                    echo "Webmin est déjà installé ou bien des fichiers d'une précédente configuration sont encore présents"
                    fi

                    apt -y install python3 shared-mime-info unzip apt-show-versions libapt-pkg-perl libauthen-pam-perl libio-pty-perl libnet-ssleay-perl curl -y
                    curl -L -O https://www.webmin.com/download/deb/webmin-current.deb
                    dpkg -i webmin-current.deb

                    systemctl restart webmin

                    clear
                    echo "-----------------------------------------"
                    echo "L'installation est terminée"
                    echo "Vous pouvez accéder à Webmin depuis un navigateur, via https://IP-SERVEUR:10000"
                    echo "Identifiez-vous en root, avec vos identifiants root du serveur"
                    sleep 5s
                    clear
                    i9=$((i9+1))
                    
                ;;
                "r")
                    break
                ;;
            esac
            i9=$((i9+1))
            done
iprinc=$((iprinc+1))
fi
if [ "$choix" == "10" ]; then
    clear
iprinc=$((iprinc+1))
fi
if [ "$choix" == "q" ]; then
    clear
    exit 0
fi
done
