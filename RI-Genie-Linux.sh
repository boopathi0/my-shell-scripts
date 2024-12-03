# /*************************************************************************************************************************
#                  Created for: Install Zabbix web server, DB server, zabbix proxy, Jumpcloud and RedIron Branding
#                  Date: 02/10/2024
#                  Notes: Tested with OCI-dev2 and implemented to Trulieve
#
#       REVISIONS:
#      Ver        Date        Author                     Description
#      ---------  ----------  -------------------        --------------------------------------------------------------------
#      1.0         02/10/2024       Todd/Boopathi     All in one script to install and config RED Monitoring server.
#   *************************************************************************************************************************/
#!/bin/bash
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
HOSTNAME_VAR=$HOSTNAME

# Function to check OS version
# Function to check if firewalld or iptables is running and stop/disable them
disable_firewall() {

    echo -e "${RED}Checking OS version...${NC}"

if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VERSION=$VERSION_ID
    elif [ -f /etc/redhat-release ]; then
        OS=$(cat /etc/redhat-release)
        VERSION=""
    else
        OS="Unknown"
        VERSION=""
    fi
    echo -e "${RED}OS: $OS $VERSION${NC}"

    echo -e "${BLUE}Checking if firewalld or iptables is running...${NC}"

    if systemctl is-active --quiet firewalld; then
        echo -e "${YELLOW}Firewalld is running. Stopping and disabling it...${NC}"
        sudo systemctl stop firewalld
        sudo systemctl disable firewalld
    else
        echo -e "${GREEN}Firewalld is not running.${NC}"
    fi

    if systemctl is-active --quiet iptables; then
        echo -e "${YELLOW}Iptables is running. Stopping and disabling it...${NC}"
        sudo systemctl stop iptables
        sudo systemctl disable iptables
    else
        echo -e "${GREEN}Iptables is not running.${NC}"
    fi
}

# Function to set the timezone
set_timezone() {
    echo -e "${CYAN}Select the timezone you want to set:${NC}"
    echo -e "${YELLOW}1)${NC} ${GREEN}Mountain Time (America/Denver)${NC}"
    echo -e "${YELLOW}2)${NC} ${GREEN}Central Standard Time (America/Chicago)${NC}"
    echo -e "${YELLOW}3)${NC} ${GREEN}Eastern Standard Time (America/New_York)${NC}"
    echo -e "${YELLOW}4)${NC} ${GREEN}Pacific Time (America/Los_Angeles)${NC}"

    read -p "Enter your choice (1-4): " tz_choice

    case $tz_choice in
        1)
            timezone="America/Denver"
            ;;
        2)
            timezone="America/Chicago"
            ;;
        3)
            timezone="America/New_York"
            ;;
        4)
            timezone="America/Los_Angeles"
            ;;
        *)
            echo -e "${RED}Invalid choice. Please select a valid option.${NC}"
            set_timezone
            ;;
    esac

    sudo timedatectl set-timezone "$timezone"
    echo -e "${GREEN}Timezone set to: $(timedatectl | grep 'Time zone')${NC}"
}

function install_ri-monitoring  {

clear
                echo -e "${CYAN}╔═════════════════════════════════════════════════════════╗${NC}"
                echo -e "${CYAN}║   RI-Monitoring - Select an option below!               ║${NC}"
                echo -e "${CYAN}╠═════════════════════════════════════════════════════════╣${NC}"
                echo -e "${CYAN}║ ${YELLOW}1)${NC} ${GREEN}Install Database Server           ${CYAN}                   ║${NC}"
                echo -e "${CYAN}║ ${YELLOW}2)${NC} ${GREEN}Install Web Server                ${CYAN}                   ║${NC}"
                echo -e "${CYAN}║ ${YELLOW}3)${NC} ${GREEN}Install Proxy Server              ${CYAN}                   ║${NC}"
                echo -e "${CYAN}║ ${YELLOW}4)${NC} ${GREEN}Rediron Branding                  ${CYAN}                   ║${NC}"
                echo -e "${CYAN}║ ${YELLOW}5)${NC} ${GREEN}Install Agent2                    ${CYAN}                   ║${NC}"
                echo -e "${CYAN}║ ${YELLOW}6)${NC} ${RED}Back to Main Menu                  ${CYAN}                   ║${NC}"
                echo -e "${CYAN}╚═════════════════════════════════════════════════════════╝${NC}"

                read -p "Enter your choice (1-6): " monitoring_choice

case $monitoring_choice in
                    1)
                        install_database_server
                        read -p "Press [Enter] key to continue..."
                        ;;
                    2)
                        install_web_server
                        read -p "Press [Enter] key to continue..."
                        ;;
                    3)
                        install_proxy_server
                        read -p "Press [Enter] key to continue..."
                        ;;
                    4)
                        rediron_branding
                        read -p "Press [Enter] key to continue..."
                        ;;
                    5)
                        install_agent2
                        read -p "Press [Enter] key to continue..."
                        ;;
		    6)
            		echo "Returning to Main Menu..."
            		return
            		;;
        		*)
            		echo -e "${RED}Invalid choice. Please select a valid option.${NC}"
            		return
            		;;
                esac
   }
# Function to install a proxy server
install_proxy_server() {
    echo -e "${BLUE}Installing Proxy Server...${NC}"

#===============================================
# Disable SELINUX
#===============================================
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
systemctl stop firewalld.service

file="/etc/zabbix/zabbix_proxy.conf"
rpm -Uvh https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-release-7.0-5.el9.noarch.rpm
dnf clean all
dnf install -y zabbix-proxy-mysql zabbix-sql-scripts zabbix-selinux-policy zabbix-agent2 zabbix-agent2-plugin-*
dnf install -y mysql-server
systemctl start mysqld
systemctl enable mysqld
echo "Enter OS root user password if not please set for mysql_secure_installation"
mysql_secure_installation

read -s -p "Enter the new mysql root password to config: " MYSQL_ROOT_PASSWORD
echo
read -s -p "Enter the new mysql zabbix password to config: " ZABBIX_PASSWORD
echo
read -p "Enter the Zabbix server IP: " ZABBIX_IP
echo

ZABBIX_DB="zabbix_proxy"
ZABBIX_USER="zabbix"

# Run the MySQL commands
mysql -uroot -p$MYSQL_ROOT_PASSWORD <<MYSQL_SCRIPT
CREATE DATABASE $ZABBIX_DB CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER '$ZABBIX_USER'@'localhost' IDENTIFIED BY '$ZABBIX_PASSWORD';
GRANT ALL PRIVILEGES ON $ZABBIX_DB.* TO '$ZABBIX_USER'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
FLUSH PRIVILEGES;
MYSQL_SCRIPT


echo "Enter mysql zabbix user password:"
cat /usr/share/zabbix-sql-scripts/mysql/proxy.sql | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix_proxy

mysql -uroot -p$MYSQL_ROOT_PASSWORD <<MYSQL_SCRIPT
SET GLOBAL log_bin_trust_function_creators = 0;
FLUSH PRIVILEGES;
MYSQL_SCRIPT


sed -i "/^"Server=127.0.0.1"/d" /etc/zabbix/zabbix_proxy.conf
sed -i '/^Hostname=Zabbix proxy$/d' /etc/zabbix/zabbix_proxy.conf
sed -i "/^# Server=/a\\Server=$ZABBIX_IP" "/etc/zabbix/zabbix_proxy.conf"
sed -i "/^# Hostname=/a\\Hostname=$HOSTNAME_VAR" "/etc/zabbix/zabbix_proxy.conf"
sed -i "/^# DBPassword=/a\\DBPassword=$ZABBIX_PASSWORD" "/etc/zabbix/zabbix_proxy.conf"

systemctl restart zabbix-proxy
systemctl enable zabbix-proxy

#===============================================
# Install the REQUIRED repository RPM's:
#===============================================
rpm -Uvh "https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-release-7.0-5.el9.noarch.rpm"
rpm -Uvh "https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-agent2-7.0.3-release1.el9.x86_64.rpm"
rpm -Uvh "https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-get-7.0.3-release1.el9.x86_64.rpm"
rpm -Uvh "https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-sender-7.0.3-release1.el9.x86_64.rpm"


echo "Configuring Zabbix-agent2"
echo "PCHI_proxy=10.233.54.6"
echo "HMU_proxy=10.92.187.6"
echo "ZUR_proxy=10.22.128.6"
echo "RED-PROXY=10.40.45.133"
echo "localhost=127.0.0.1"

read -p "According to your environment, enter your ZBX proxy or server IP address:"  RESP
sed -i "s/ServerActive=127.0.0.1/ServerActive=127.0.0.1,$RESP/g" /etc/zabbix/zabbix_agent2.conf
sed -i "s/Server=127.0.0.1/Server=127.0.0.1,$RESP/g" /etc/zabbix/zabbix_agent2.conf
sed -i "s/Hostname=Zabbix server/Hostname=$HOSTNAME_VAR/g" /etc/zabbix/zabbix_agent2.conf

systemctl restart zabbix-agent2
systemctl enable zabbix-agent2

    # Add commands to install the proxy server
    echo -e "${GREEN}Proxy Server installation complete.${NC}"
}

# Function to install a web server
install_web_server() {
    echo -e "${BLUE}Installing Web Server...${NC}"
    # Add commands to install the web server
    file="/etc/zabbix/zabbix_server.conf"

#===============================================
# Set   hostname:
#===============================================
read -p "Enter the Hostname to set: " hname
hostnamectl set-hostname $hname

#===============================================
# Create ms_sysops directories:
#===============================================
mkdir -p /opt/ms_sysops
cd /opt/ms_sysops
mkdir oci_scripts oci_logs  logs

# Disable Zabbix packages provided by EPEL:
#===============================================
if [[ -f /etc/yum.repos.d/epel.repo ]]; then
   echo "Disabling Zabbix packages in EPEL repository"
   sed -i '/\[epel\]/a excludepkgs=zabbix*' /etc/yum.repos.d/epel.repo
fi

#===============================================
# Disable SELINUX & Install Security updates:
#===============================================
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
systemctl stop firewalld.service

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Install Zabbix repository
echo "Installing Zabbix repository"
rpm -Uvh https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-release-7.0-5.el9.noarch.rpm

#===============================================
# Install the REQUIRED repository RPM's:
#===============================================
rpm -Uvh "https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-agent2-7.0.3-release1.el9.x86_64.rpm"
rpm -Uvh "https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-get-7.0.3-release1.el9.x86_64.rpm"
rpm -Uvh "https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-sender-7.0.3-release1.el9.x86_64.rpm"


# Clean all dnf cache
echo "Cleaning dnf cache"
dnf clean all

#===============================================
# Install Zabbix server, frontend, agent, and other components
#===============================================
echo "Installing Zabbix server, frontend, agent, and related components"
dnf install -y zabbix-server-pgsql zabbix-web-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent2 zabbix-agent2-plugin-*
# Zabbix config file changes
# Prompt the user for the DB host IP
read -p "Enter the DB host IP: " IP
# Prompt the user for the DB user password (input hidden)
read -s -p "Enter the Database "Zabbix" user password: " passwd
echo # Move to a new line after hidden input
# Apply the sed commands to insert the configurations
sed -i "/^# LogFile=/a\\LogFile=/var/log/zabbix/zabbix_server.log" "$file"
sed -i "/^# LogFileSize=/a\\LogFileSize=10" "$file"
sed -i "/^# DebugLevel=/a\\DebugLevel=3" "$file"
sed -i "/^# PidFile=/a\\PidFile=/run/zabbix/zabbix_server.pid" "$file"
sed -i "/^# SocketDir=/a\\SocketDir=/run/zabbix" "$file"
sed -i "/^# DBHost=/a\\DBHost=$IP" "$file"
sed -i "/^# DBName=/a\\DBName=zabbix" "$file"
sed -i "/^# DBUser=/a\\DBUser=zabbix" "$file"
sed -i "/^# DBPassword=/a\\DBPassword=$passwd" "$file"
sed -i "/^# DBPort=/a\\DBPort=5432" "$file"
echo "Configuration updated successfully."

#restart zabbix services
systemctl enable zabbix-server nginx php-fpm
systemctl restart zabbix-server nginx php-fpm

sed -i "s/Hostname=Zabbix server/Hostname=$HOSTNAME/g" /etc/zabbix/zabbix_agent2.conf

systemctl restart zabbix-agent2
systemctl enable zabbix-agent2


    echo -e "${GREEN}Web Server installation complete.${NC}"
}

# Function to install a database server
install_database_server() {
    echo -e "${BLUE}Installing Database Server...${NC}"
    # Add commands to install the database server

#===============================================
#firewall to be stopped
#===============================================
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
systemctl stop firewalld.service

file1="/var/lib/pgsql/16/data/pg_hba.conf"
file2="/var/lib/pgsql/16/data/postgresql.conf"
#===============================================
# Disable Zabbix packages provided by EPEL:
#===============================================
if [[ -f /etc/yum.repos.d/epel.repo ]]; then
   echo "Disabling Zabbix packages in EPEL repository"
   sed -i '/\[epel\]/a excludepkgs=zabbix*' /etc/yum.repos.d/epel.repo
fi

#===============================================
# Update the System: Security updates
#===============================================
#dnf update --security -y

#===============================================
# Set SELINUX to disabled
#===============================================
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

#===============================================
# Create postgres OS user and add to wheel group:
#===============================================
useradd -m -s /bin/bash postgres

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Add the postgres user to the wheel group
usermod -aG wheel postgres

# Ensure the wheel group has sudo privileges
if ! grep -q '^%wheel' /etc/sudoers; then
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
else
    echo "The wheel group is already configured in /etc/sudoers"
fi

echo "Postgres user has been added to the wheel group and wheel group has sudo privileges."

# Install Zabbix repository and install postgres packages
echo "Installing Zabbix repository"
rpm -Uvh https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-release-7.0-5.el9.noarch.rpm
echo "Cleaning dnf cache"
dnf clean all
dnf install -y zabbix-server-pgsql zabbix-sql-scripts zabbix-selinux-policy zabbix-agent2 zabbix-agent2-plugin-*

#===============================================
# Disable the built-in PostgreSQL module:
#===============================================
dnf -qy module disable postgresql


#===============================================
# Install the REQUIRED repository RPM's:
#===============================================
dnf install -y "https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm"
rpm -Uvh "https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-release-7.0-5.el9.noarch.rpm"
rpm -Uvh "https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-agent2-7.0.3-release1.el9.x86_64.rpm"
rpm -Uvh "https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-agent2-plugin-postgresql-7.0.3-release1.el9.x86_64.rpm"
rpm -Uvh "https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-get-7.0.3-release1.el9.x86_64.rpm"
rpm -Uvh "https://repo.zabbix.com/zabbix/7.0/oracle/9/x86_64/zabbix-sender-7.0.3-release1.el9.x86_64.rpm"


#===============================================
# Install PostgreSQL:
#===============================================
dnf install -y postgresql16-server

#===============================================
# Adjust Ownership and Permissions
#===============================================
chown -R postgres:postgres /var/lib/pgsql/16/data

#===============================================
# Initialize PostgreSQL database as user postgres:
#===============================================
/usr/pgsql-16/bin/postgresql-16-setup initdb

#===============================================
# Enable and start the PostgreSQL database:
#===============================================
systemctl enable postgresql-16
systemctl start postgresql-16


#===============================================
# Install Misc Packages:
#===============================================
dnf install -y postfix telnet curl nmap rsync dos2unix wget curl wireshark-cli

#===============================================
# set parameter to allow DB to accept incoming connections:
#===============================================

read -p "Enter the Network interface for DB access (example 10.40.45.0/24): " netint
sed -i "s|host    all             all             127.0.0.1/32            scram-sha-256|host    all             all             $netint            trust|" "$file1"
sed -i "s|host    replication     all             127.0.0.1/32            scram-sha-256|host    replication     all             $netint            md5|" "$file1"

#listen_addresses =
sed -i "/^#listen_addresses =/a\\listen_addresses = '*'" "$file2"


#===========================================================================
#creating zabbix user and set password &  import initial schema and data
#===========================================================================

echo "Creating the "zabbix" user and set the password"
sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix

zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix

systemctl restart postgresql-16

#===============================================
# Create alias commands for red-monitor-db01:
#===============================================
cat <<EOL > /etc/profile.d/zbxsys.sh
alias zconf="cd /u01/app/zabbix-agent/etc/"
alias zconf2="cd /etc/zabbix/"
alias zlog="cd /var/log/zabbix/"
alias ocs="cd /opt/ms_sysops/oci_scripts/"
alias ocl="cd /opt/ms_sysops/oci_logs/"
alias repo="cd /etc/yum.repos.d/"
alias yumr="cd /etc/yum.repo.d/"
alias profile="cd /etc/profile.d/"
alias vlog="cd /var/log"
alias pro="cd /etc/profile.d"
alias sud="cd /etc/sudoers.d/"
alias key="cd /root/.ssh"
alias post="cd /etc/postifx"
alias sysctl="cat /etc/sysctl.conf"
alias secure="cat /var/log/secure"
alias mess="cat /var/log/messages"
alias zrestart='service zabbix-agent restart'
alias z2restart="systemctl restart zabbix-agent2"
alias z2status="systemctl status zabbix-agent2"
EOL




echo "Configuring Zabbix-agent2"
echo "PCHI_proxy=10.233.54.6"
echo "HMU_proxy=10.92.187.6"
echo "ZUR_proxy=10.22.128.6"
echo "RED-PROXY=10.40.45.133"
echo "localhost=127.0.0.1"

read -p "According to your environment, enter your ZBX proxy or server IP address:"  RESP
sed -i "s/ServerActive=127.0.0.1/ServerActive=127.0.0.1,$RESP/g" /etc/zabbix/zabbix_agent2.conf
sed -i "s/Server=127.0.0.1/Server=127.0.0.1,$RESP/g" /etc/zabbix/zabbix_agent2.conf
sed -i "s/Hostname=Zabbix server/Hostname=$HOSTNAME/g" /etc/zabbix/zabbix_agent2.conf

systemctl restart zabbix-agent2
systemctl enable zabbix-agent2



    echo -e "${GREEN}Database Server installation complete.${NC}"
}
# Function to install jumpcloud
function install_jumpcloud {
    clear
    echo "╔═════════════════════════════════════════════════════════╗"
    echo "║   Select a customer from the list below!                ║"
    echo "╠═════════════════════════════════════════════════════════╣"
    echo "║ 1) Hallmark                                             ║"
    echo "║ 2) Party City                                           ║"
    echo "║ 3) Pet Food Express                                     ║"
    echo "║ 4) RedIron Corporate                                    ║"
    echo "║ 5) RedIron Technologies                                 ║"
    echo "║ 6) Travel Traders                                       ║"
    echo "║ 7) Zurchers                                             ║"
    echo "║ 8) Main Menu                                            ║"
    echo "╚═════════════════════════════════════════════════════════╝"

    read -p "Enter your choice (1-8): " customer_choice

    case $customer_choice in
        1)
            echo "You selected Hallmark. Installing JumpCloud for Hallmark..."
            ;;
        2)
            yum install -y auth-config
yum install -y tar telnet htop screen curl nmap rsync
yum install -y oddjob oddjob-mkhomedir sssd openldap-clients auth-config


echo '# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON    on

URI ldaps://ldap.jumpcloud.com:636

BASE ou=Users,o=6553c50d1500f1b17cd7fffc,dc=jumpcloud,dc=com
TLS_REQCERT never
TLS_CACERTDIR /etc/openldap/cacerts' > /etc/openldap/ldap.conf


mkdir -p /etc/openldap/cacerts

echo '[sssd]
config_file_version = 2
services = nss, pam, ssh, autofs
domains = jumpcloud
debug_level = 3

[nss]

[pam]

[domain/jumpcloud]
debug_level = 5
id_provider = ldap
enumerate = false
ldap_schema = rfc2307
debug_level = 6
ldap_tls_reqcert = never
auth_provider = ldap
ldap_group_name = cn
ldap_user_home_directory = homeDirectory
ldap_uri = ldaps://ldap.jumpcloud.com:636
ldap_search_base = o=6553c50d1500f1b17cd7fffc,dc=jumpcloud,dc=com
ldap_default_bind_dn = uid=pc-sysadmin,ou=Users,o=6553c50d1500f1b17cd7fffc,dc=jumpcloud,dc=com
ldap_default_authtok = SOYuKzJzB@0#


#ldap_user_ssh_public_key = sshKey
ldap_use_tokengroups = False
ldap_tls_cacert = /etc/openldap/cacerts/jumpcloud.ldap.pem



[pam]
[domain/jumpcloud]
auth_provider = ldap
id_provider = ldap
enumerate = false
cache_credentials = true
debug_level = 9
min_id = 500
[autofs]

[nss]
homedir_substring = /home' >/etc/sssd/sssd.conf

chmod 600 /etc/sssd/sssd.conf


echo -n | openssl s_client -connect ldap.jumpcloud.com:636 -showcerts | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/openldap/cacerts/jumpcloud.chain.pem

echo -n | openssl s_client -connect ldap.jumpcloud.com:636 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/openldap/cacerts/jumpcloud.ldap.pem

cd /etc/openldap/cacerts/

ln -s /etc/openldap/cacerts/jumpcloud.chain.pem /etc/openldap/cacerts/a71f64ec.1
ln -s /etc/openldap/cacerts/jumpcloud.ldap.pem /etc/openldap/cacerts/a71f64ec.0

echo '#!/bin/sh
# print out the hash values
#

for i in $*
do
        h=`openssl x509 -hash -noout -in $i`
        echo "$h.0 => $i"
done' > /etc/pki/tls/misc/c_hash

chmod +x /etc/pki/tls/misc/c_hash

/etc/pki/tls/misc/c_hash /etc/openldap/cacerts/jumpcloud.ldap.pem
/etc/pki/tls/misc/c_hash /etc/openldap/cacerts/jumpcloud.chain.pem

update-crypto-policies --set LEGACY

perl -pi -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
perl -pi -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/50-cloud-init.conf


echo 'session    required     pam_mkhomedir.so skel=/etc/skel/' >> /etc/pam.d/sshd

echo '# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON    on

URI ldaps://ldap.jumpcloud.com:636

BASE ou=Users,o=6553c50d1500f1b17cd7fffc,dc=jumpcloud,dc=com
TLS_REQCERT never
TLS_CACERTDIR /etc/openldap/cacerts' > /etc/openldap/ldap.conf

# remove the ri ldap certs

rm -rf /etc/openldap/cacerts/redirontechrootCA.pem

rm -rf /etc/openldap/cacerts/8d55763f.0

authconfig --enablemkhomedir --enablepamaccess --update

rm -rf /etc/sssd/conf.d/authconfig-sssd.conf

# rhel 7 and 8 systemctl restarts
systemctl restart sshd.service
systemctl restart sssd.service
systemctl restart oddjobd.service


perl -pi -e 's/installonly_limit=3/installonly_limit=2/' /etc/yum.conf
#############################################
# selinux disabled
#############################################
perl -pi -e 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0

echo 'Cmnd_Alias CMD_APPLICATIONS = \
    /usr/bin/rpm,\
    /usr/bin/yum,\
    /usr/bin/tar,\
    /usr/bin/crontab,\
    /usr/bin/sudoedit /etc/tomax/*,\
    /usr/bin/cp /etc/tomax/*,\
    /u01/app/oraInventory/orainstRoot.sh,\
    /u01/app/oracle/product/*/root.sh,\
    /u01/app/ri-hosting/systemd-services/*,\
    /bin/cp /etc/security/limits,\
    /usr/bin/sudoedit /etc/security/limits,\
    /bin/cat /var/log/maillog*,\
    /bin/cat /var/log/messages*,\
    /bin/cat /opt/oracle/dcs/log/*.log,\
    /opt/oracle/dcs/bin/dbcli' > /etc/sudoers.d/00_apps_alias


echo 'Cmnd_Alias SU_SUP = \
    /bin/su - ftpdl,\
    /bin/su - jboss*,\
    /bin/su - oas,\
    /bin/su - rf*,\
    /bin/su - tomax,\
    /bin/su - tomcat*

%risupport         ALL =(ALL) PASSWD: SU_SUP' > /etc/sudoers.d/00-risupport

echo '%ridba         ALL =(ALL) PASSWD: SU_APPLICATIONS, CMD_APPLICATIONS

Cmnd_Alias SU_APPLICATIONS = \
    /bin/su - oracle*,\
    /bin/su - grid*,\
    /bin/su - oas*,\
    /bin/su - tomax*,\
    /bin/su - rf*,\
    /bin/su - jboss*,\
    /bin/su - tomcat*,\
    /bin/su - ftpdl,\
    /bin/su - postgres*,\
    /bin/su - zabbix*' > /etc/sudoers.d/00-ridba

echo '%tzlroot   ALL=(ALL) ALL' > /etc/sudoers.d/10-jumpcloud


chmod 440 /etc/sudoers.d/10-jumpcloud
chmod 440 /etc/sudoers.d/00-risupport
chmod 440 /etc/sudoers.d/00-ridba


            ;;
        3)

        yum install -y auth-config
yum install -y tar telnet htop screen curl nmap rsync
yum install -y oddjob oddjob-mkhomedir sssd openldap-clients auth-config


echo '# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON    on

URI ldaps://ldap.jumpcloud.com:636

BASE ou=Users,o=65cfbc6dcde01fef84c770b7,dc=jumpcloud,dc=com
TLS_REQCERT never
TLS_CACERTDIR /etc/openldap/cacerts' > /etc/openldap/ldap.conf


mkdir -p /etc/openldap/cacerts

echo '[sssd]
config_file_version = 2
services = nss, pam, ssh, autofs
domains = jumpcloud
debug_level = 3

[nss]

[pam]

[domain/jumpcloud]
debug_level = 5
id_provider = ldap
enumerate = false
ldap_schema = rfc2307
debug_level = 6
ldap_tls_reqcert = never
auth_provider = ldap
ldap_group_name = cn
ldap_user_home_directory = homeDirectory
ldap_uri = ldaps://ldap.jumpcloud.com:636
ldap_search_base = o=65cfbc6dcde01fef84c770b7,dc=jumpcloud,dc=com
ldap_default_bind_dn = uid=pfe-sysadmin,ou=Users,o=65cfbc6dcde01fef84c770b7,dc=jumpcloud,dc=com
ldap_default_authtok = GYQNe6FwC5ZT


#ldap_user_ssh_public_key = sshKey
ldap_use_tokengroups = False
ldap_tls_cacert = /etc/openldap/cacerts/jumpcloud.ldap.pem



[pam]
[domain/jumpcloud]
auth_provider = ldap
id_provider = ldap
enumerate = false
cache_credentials = true
debug_level = 9
min_id = 500
[autofs]

[nss]
homedir_substring = /home' >/etc/sssd/sssd.conf

chmod 600 /etc/sssd/sssd.conf


echo -n | openssl s_client -connect ldap.jumpcloud.com:636 -showcerts | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/openldap/cacerts/jumpcloud.chain.pem

echo -n | openssl s_client -connect ldap.jumpcloud.com:636 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/openldap/cacerts/jumpcloud.ldap.pem

cd /etc/openldap/cacerts/

ln -s /etc/openldap/cacerts/jumpcloud.chain.pem /etc/openldap/cacerts/a71f64ec.1
ln -s /etc/openldap/cacerts/jumpcloud.ldap.pem /etc/openldap/cacerts/a71f64ec.0

echo '#!/bin/sh
# print out the hash values
#

for i in $*
do
        h=`openssl x509 -hash -noout -in $i`
        echo "$h.0 => $i"
done' > /etc/pki/tls/misc/c_hash

chmod +x /etc/pki/tls/misc/c_hash

/etc/pki/tls/misc/c_hash /etc/openldap/cacerts/jumpcloud.ldap.pem
/etc/pki/tls/misc/c_hash /etc/openldap/cacerts/jumpcloud.chain.pem

update-crypto-policies --set LEGACY

perl -pi -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
perl -pi -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/50-cloud-init.conf


echo 'session    required     pam_mkhomedir.so skel=/etc/skel/' >> /etc/pam.d/sshd

echo '# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON    on

URI ldaps://ldap.jumpcloud.com:636

BASE ou=Users,o=65cfbc6dcde01fef84c770b7,dc=jumpcloud,dc=com
TLS_REQCERT never
TLS_CACERTDIR /etc/openldap/cacerts' > /etc/openldap/ldap.conf

# remove the ri ldap certs

rm -rf /etc/openldap/cacerts/redirontechrootCA.pem

rm -rf /etc/openldap/cacerts/8d55763f.0

authconfig --enablemkhomedir --enablepamaccess --update

rm -rf /etc/sssd/conf.d/authconfig-sssd.conf

# rhel 7 and 8 systemctl restarts
systemctl restart sshd.service
systemctl restart sssd.service
systemctl restart oddjobd.service


perl -pi -e 's/installonly_limit=3/installonly_limit=2/' /etc/yum.conf
#############################################
# selinux disabled
#############################################
perl -pi -e 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0

echo 'Cmnd_Alias CMD_APPLICATIONS = \
    /usr/bin/rpm,\
    /usr/bin/yum,\
    /usr/bin/tar,\
    /usr/bin/crontab,\
    /usr/bin/sudoedit /etc/tomax/*,\
    /usr/bin/cp /etc/tomax/*,\
    /u01/app/oraInventory/orainstRoot.sh,\
    /u01/app/oracle/product/*/root.sh,\
    /u01/app/ri-hosting/systemd-services/*,\
    /bin/cp /etc/security/limits,\
    /usr/bin/sudoedit /etc/security/limits,\
    /bin/cat /var/log/maillog*,\
    /bin/cat /var/log/messages*,\
    /bin/cat /opt/oracle/dcs/log/*.log,\
    /opt/oracle/dcs/bin/dbcli' > /etc/sudoers.d/00_apps_alias


echo 'Cmnd_Alias SU_SUP = \
    /bin/su - ftpdl,\
    /bin/su - jboss*,\
    /bin/su - oas,\
    /bin/su - rf*,\
    /bin/su - tomax,\
    /bin/su - tomcat*

%risupport         ALL =(ALL) PASSWD: SU_SUP' > /etc/sudoers.d/00-risupport

echo '%ridba         ALL =(ALL) PASSWD: SU_APPLICATIONS, CMD_APPLICATIONS

Cmnd_Alias SU_APPLICATIONS = \
    /bin/su - oracle*,\
    /bin/su - grid*,\
    /bin/su - oas*,\
    /bin/su - tomax*,\
    /bin/su - rf*,\
    /bin/su - jboss*,\
    /bin/su - tomcat*,\
    /bin/su - ftpdl,\
    /bin/su - postgres*,\
    /bin/su - zabbix*' > /etc/sudoers.d/00-ridba

echo '%tzlroot   ALL=(ALL) ALL' > /etc/sudoers.d/10-jumpcloud


chmod 440 /etc/sudoers.d/10-jumpcloud
chmod 440 /etc/sudoers.d/00-risupport
chmod 440 /etc/sudoers.d/00-ridba



            ;;
        4)
            echo "You selected RedIron Corporate. Installing JumpCloud for RedIron Corporate..."
            ;;
        5)

yum install -y auth-config
yum install -y tar telnet htop screen curl nmap rsync
yum install -y oddjob oddjob-mkhomedir sssd openldap-clients auth-config


echo '# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON    on

URI ldaps://ldap.jumpcloud.com:636

BASE ou=Users,o=64c812e8fc20d34a54aa3574,dc=jumpcloud,dc=com
TLS_REQCERT never
TLS_CACERTDIR /etc/openldap/cacerts' > /etc/openldap/ldap.conf


mkdir -p /etc/openldap/cacerts

echo '[sssd]
config_file_version = 2
services = nss, pam, ssh, autofs
domains = jumpcloud
debug_level = 3

[nss]

[pam]

[domain/jumpcloud]
debug_level = 5
id_provider = ldap
enumerate = false
ldap_schema = rfc2307
debug_level = 6
ldap_tls_reqcert = never
auth_provider = ldap
ldap_group_name = cn
ldap_user_home_directory = homeDirectory
ldap_uri = ldaps://ldap.jumpcloud.com:636
#ldap_uri = ldap://ldap.jumpcloud.com:389
#ldap_search_base = dc=jumpcloud,dc=com
ldap_search_base = o=64c812e8fc20d34a54aa3574,dc=jumpcloud,dc=com
ldap_default_bind_dn = uid=sysadmin,ou=Users,o=64c812e8fc20d34a54aa3574,dc=jumpcloud,dc=com
ldap_default_authtok = @Rediron2023


#ldap_user_ssh_public_key = sshKey
ldap_use_tokengroups = False
ldap_tls_cacert = /etc/openldap/cacerts/jumpcloud.ldap.pem



[pam]
[domain/jumpcloud]
auth_provider = ldap
id_provider = ldap
enumerate = false
cache_credentials = true
debug_level = 9
min_id = 500
[autofs]

[nss]
homedir_substring = /home' >/etc/sssd/sssd.conf

chmod 600 /etc/sssd/sssd.conf


echo -n | openssl s_client -connect ldap.jumpcloud.com:636 -showcerts | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/openldap/cacerts/jumpcloud.chain.pem

echo -n | openssl s_client -connect ldap.jumpcloud.com:636 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/openldap/cacerts/jumpcloud.ldap.pem

cd /etc/openldap/cacerts/

ln -s /etc/openldap/cacerts/jumpcloud.chain.pem /etc/openldap/cacerts/a71f64ec.1
ln -s /etc/openldap/cacerts/jumpcloud.ldap.pem /etc/openldap/cacerts/a71f64ec.0

echo '#!/bin/sh
# print out the hash values
#

for i in $*
do
        h=`openssl x509 -hash -noout -in $i`
        echo "$h.0 => $i"
done' > /etc/pki/tls/misc/c_hash

chmod +x /etc/pki/tls/misc/c_hash

/etc/pki/tls/misc/c_hash /etc/openldap/cacerts/jumpcloud.ldap.pem
/etc/pki/tls/misc/c_hash /etc/openldap/cacerts/jumpcloud.chain.pem

update-crypto-policies --set LEGACY

perl -pi -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
perl -pi -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/50-cloud-init.conf


echo 'session    required     pam_mkhomedir.so skel=/etc/skel/' >> /etc/pam.d/sshd

echo '# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON    on

URI ldaps://ldap.jumpcloud.com:636

BASE ou=Users,o=64c812e8fc20d34a54aa3574,dc=jumpcloud,dc=com
TLS_REQCERT never
TLS_CACERTDIR /etc/openldap/cacerts' > /etc/openldap/ldap.conf

# remove the ri ldap certs

rm -rf /etc/openldap/cacerts/redirontechrootCA.pem

rm -rf /etc/openldap/cacerts/8d55763f.0

authconfig --enablemkhomedir --enablepamaccess --update

rm -rf /etc/sssd/conf.d/authconfig-sssd.conf

# rhel 7 and 8 systemctl restarts
systemctl restart sshd.service
systemctl restart sssd.service
systemctl restart oddjobd.service


perl -pi -e 's/installonly_limit=3/installonly_limit=2/' /etc/yum.conf
#############################################
# selinux disabled
#############################################
perl -pi -e 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0

echo 'Cmnd_Alias CMD_APPLICATIONS = \
    /usr/bin/rpm,\
    /usr/bin/yum,\
    /usr/bin/tar,\
    /usr/bin/crontab,\
    /usr/bin/sudoedit /etc/tomax/*,\
    /usr/bin/cp /etc/tomax/*,\
    /u01/app/oraInventory/orainstRoot.sh,\
    /u01/app/oracle/product/*/root.sh,\
    /u01/app/ri-hosting/systemd-services/*,\
    /bin/cp /etc/security/limits,\
    /usr/bin/sudoedit /etc/security/limits,\
    /bin/cat /var/log/maillog*,\
    /bin/cat /var/log/messages*,\
    /bin/cat /opt/oracle/dcs/log/*.log,\
    /opt/oracle/dcs/bin/dbcli' > /etc/sudoers.d/00_apps_alias


echo 'Cmnd_Alias SU_SUP = \
    /bin/su - ftpdl,\
    /bin/su - jboss*,\
    /bin/su - oas,\
    /bin/su - rf*,\
    /bin/su - tomax,\
    /bin/su - tomcat*

%risupport         ALL =(ALL) PASSWD: SU_SUP' > /etc/sudoers.d/00-risupport

echo '%ridba         ALL =(ALL) PASSWD: SU_APPLICATIONS, CMD_APPLICATIONS

Cmnd_Alias SU_APPLICATIONS = \
    /bin/su - oracle*,\
    /bin/su - grid*,\
    /bin/su - oas*,\
    /bin/su - tomax*,\
    /bin/su - rf*,\
    /bin/su - jboss*,\
    /bin/su - tomcat*,\
    /bin/su - ftpdl,\
    /bin/su - postgres*,\
    /bin/su - zabbix*' > /etc/sudoers.d/00-ridba

echo '%tzlroot   ALL=(ALL) ALL' > /etc/sudoers.d/10-jumpcloud


chmod 440 /etc/sudoers.d/10-jumpcloud
chmod 440 /etc/sudoers.d/00-risupport
chmod 440 /etc/sudoers.d/00-ridba

            ;;
        6)
            yum install -y auth-config
yum install -y tar telnet htop screen curl nmap rsync
yum install -y oddjob oddjob-mkhomedir sssd openldap-clients auth-config


echo '# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON    on

URI ldaps://ldap.jumpcloud.com:636

BASE ou=Users,o=65b175955d61bb4f667f89bd,dc=jumpcloud,dc=com
TLS_REQCERT never
TLS_CACERTDIR /etc/openldap/cacerts' > /etc/openldap/ldap.conf


mkdir -p /etc/openldap/cacerts

echo '[sssd]
config_file_version = 2
services = nss, pam, ssh, autofs
domains = jumpcloud
debug_level = 3

[nss]

[pam]

[domain/jumpcloud]
debug_level = 5
id_provider = ldap
enumerate = false
ldap_schema = rfc2307
debug_level = 6
ldap_tls_reqcert = never
auth_provider = ldap
ldap_group_name = cn
ldap_user_home_directory = homeDirectory
ldap_uri = ldaps://ldap.jumpcloud.com:636
ldap_search_base = o=65b175955d61bb4f667f89bd,dc=jumpcloud,dc=com
ldap_default_bind_dn = uid=ttr-sysadmin,ou=Users,o=65b175955d61bb4f667f89bd,dc=jumpcloud,dc=com
ldap_default_authtok = YCjWdXzhz10D

#ldap_user_ssh_public_key = sshKey
ldap_use_tokengroups = False
ldap_tls_cacert = /etc/openldap/cacerts/jumpcloud.ldap.pem



[pam]
[domain/jumpcloud]
auth_provider = ldap
id_provider = ldap
enumerate = false
cache_credentials = true
debug_level = 9
min_id = 500
[autofs]

[nss]
homedir_substring = /home' >/etc/sssd/sssd.conf

chmod 600 /etc/sssd/sssd.conf


echo -n | openssl s_client -connect ldap.jumpcloud.com:636 -showcerts | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/openldap/cacerts/jumpcloud.chain.pem

echo -n | openssl s_client -connect ldap.jumpcloud.com:636 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/openldap/cacerts/jumpcloud.ldap.pem

cd /etc/openldap/cacerts/

ln -s /etc/openldap/cacerts/jumpcloud.chain.pem /etc/openldap/cacerts/a71f64ec.1
ln -s /etc/openldap/cacerts/jumpcloud.ldap.pem /etc/openldap/cacerts/a71f64ec.0

echo '#!/bin/sh
# print out the hash values
#

for i in $*
do
        h=`openssl x509 -hash -noout -in $i`
        echo "$h.0 => $i"
done' > /etc/pki/tls/misc/c_hash

chmod +x /etc/pki/tls/misc/c_hash

/etc/pki/tls/misc/c_hash /etc/openldap/cacerts/jumpcloud.ldap.pem
/etc/pki/tls/misc/c_hash /etc/openldap/cacerts/jumpcloud.chain.pem

update-crypto-policies --set LEGACY

perl -pi -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
perl -pi -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/50-cloud-init.conf


echo 'session    required     pam_mkhomedir.so skel=/etc/skel/' >> /etc/pam.d/sshd

echo '# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON    on

URI ldaps://ldap.jumpcloud.com:636

BASE ou=Users,o=65b175955d61bb4f667f89bd,dc=jumpcloud,dc=com
TLS_REQCERT never
TLS_CACERTDIR /etc/openldap/cacerts' > /etc/openldap/ldap.conf

# remove the ri ldap certs

rm -rf /etc/openldap/cacerts/redirontechrootCA.pem

rm -rf /etc/openldap/cacerts/8d55763f.0

authconfig --enablemkhomedir --enablepamaccess --update

rm -rf /etc/sssd/conf.d/authconfig-sssd.conf

# rhel 7 and 8 systemctl restarts
systemctl restart sshd.service
systemctl restart sssd.service
systemctl restart oddjobd.service


perl -pi -e 's/installonly_limit=3/installonly_limit=2/' /etc/yum.conf
#############################################
# selinux disabled
#############################################
perl -pi -e 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0

echo 'Cmnd_Alias CMD_APPLICATIONS = \
    /usr/bin/rpm,\
    /usr/bin/yum,\
    /usr/bin/tar,\
    /usr/bin/crontab,\
    /usr/bin/sudoedit /etc/tomax/*,\
    /usr/bin/cp /etc/tomax/*,\
    /u01/app/oraInventory/orainstRoot.sh,\
    /u01/app/oracle/product/*/root.sh,\
    /u01/app/ri-hosting/systemd-services/*,\
    /bin/cp /etc/security/limits,\
    /usr/bin/sudoedit /etc/security/limits,\
    /bin/cat /var/log/maillog*,\
    /bin/cat /var/log/messages*,\
    /bin/cat /opt/oracle/dcs/log/*.log,\
    /opt/oracle/dcs/bin/dbcli' > /etc/sudoers.d/00_apps_alias


echo 'Cmnd_Alias SU_SUP = \
    /bin/su - ftpdl,\
    /bin/su - jboss*,\
    /bin/su - oas,\
    /bin/su - rf*,\
    /bin/su - tomax,\
    /bin/su - tomcat*

%risupport         ALL =(ALL) PASSWD: SU_SUP' > /etc/sudoers.d/00-risupport

echo '%ridba         ALL =(ALL) PASSWD: SU_APPLICATIONS, CMD_APPLICATIONS

Cmnd_Alias SU_APPLICATIONS = \
    /bin/su - oracle*,\
    /bin/su - grid*,\
    /bin/su - oas*,\
    /bin/su - tomax*,\
    /bin/su - rf*,\
    /bin/su - jboss*,\
    /bin/su - tomcat*,\
    /bin/su - ftpdl,\
    /bin/su - postgres*,\
    /bin/su - zabbix*' > /etc/sudoers.d/00-ridba

echo '%tzlroot   ALL=(ALL) ALL' > /etc/sudoers.d/10-jumpcloud


chmod 440 /etc/sudoers.d/10-jumpcloud
chmod 440 /etc/sudoers.d/00-risupport
chmod 440 /etc/sudoers.d/00-ridba




            ;;
        7)
            yum install -y auth-config
yum install -y tar telnet htop screen curl nmap rsync
yum install -y oddjob oddjob-mkhomedir sssd openldap-clients auth-config


echo '# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON    on

URI ldaps://ldap.jumpcloud.com:636

BASE ou=Users,o=6544001bb6b16403375874a0,dc=jumpcloud,dc=com
TLS_REQCERT never
TLS_CACERTDIR /etc/openldap/cacerts' > /etc/openldap/ldap.conf


mkdir -p /etc/openldap/cacerts

echo '[sssd]
config_file_version = 2
services = nss, pam, ssh, autofs
domains = jumpcloud
debug_level = 3

[nss]

[pam]

[domain/jumpcloud]
debug_level = 5
id_provider = ldap
enumerate = false
ldap_schema = rfc2307
debug_level = 6
ldap_tls_reqcert = never
auth_provider = ldap
ldap_group_name = cn
ldap_user_home_directory = homeDirectory
ldap_uri = ldaps://ldap.jumpcloud.com:636
ldap_search_base = o=6544001bb6b16403375874a0,dc=jumpcloud,dc=com
ldap_default_bind_dn = uid=zur-sysadmin,ou=Users,o=6544001bb6b16403375874a0,dc=jumpcloud,dc=com
ldap_default_authtok = uNkgL5tvgnYY

#ldap_user_ssh_public_key = sshKey
ldap_use_tokengroups = False
ldap_tls_cacert = /etc/openldap/cacerts/jumpcloud.ldap.pem



[pam]
[domain/jumpcloud]
auth_provider = ldap
id_provider = ldap
enumerate = false
cache_credentials = true
debug_level = 9
min_id = 500
[autofs]

[nss]
homedir_substring = /home' >/etc/sssd/sssd.conf

chmod 600 /etc/sssd/sssd.conf


echo -n | openssl s_client -connect ldap.jumpcloud.com:636 -showcerts | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/openldap/cacerts/jumpcloud.chain.pem

echo -n | openssl s_client -connect ldap.jumpcloud.com:636 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/openldap/cacerts/jumpcloud.ldap.pem

cd /etc/openldap/cacerts/

ln -s /etc/openldap/cacerts/jumpcloud.chain.pem /etc/openldap/cacerts/a71f64ec.1
ln -s /etc/openldap/cacerts/jumpcloud.ldap.pem /etc/openldap/cacerts/a71f64ec.0

echo '#!/bin/sh
# print out the hash values
#

for i in $*
do
        h=`openssl x509 -hash -noout -in $i`
        echo "$h.0 => $i"
done' > /etc/pki/tls/misc/c_hash

chmod +x /etc/pki/tls/misc/c_hash

/etc/pki/tls/misc/c_hash /etc/openldap/cacerts/jumpcloud.ldap.pem
/etc/pki/tls/misc/c_hash /etc/openldap/cacerts/jumpcloud.chain.pem

update-crypto-policies --set LEGACY

perl -pi -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
perl -pi -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/50-cloud-init.conf


echo 'session    required     pam_mkhomedir.so skel=/etc/skel/' >> /etc/pam.d/sshd

echo '# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON    on

URI ldaps://ldap.jumpcloud.com:636

BASE ou=Users,o=6544001bb6b16403375874a0,dc=jumpcloud,dc=com
TLS_REQCERT never
TLS_CACERTDIR /etc/openldap/cacerts' > /etc/openldap/ldap.conf

# remove the ri ldap certs

rm -rf /etc/openldap/cacerts/redirontechrootCA.pem

rm -rf /etc/openldap/cacerts/8d55763f.0

authconfig --enablemkhomedir --enablepamaccess --update

rm -rf /etc/sssd/conf.d/authconfig-sssd.conf

# rhel 7 and 8 systemctl restarts
systemctl restart sshd.service
systemctl restart sssd.service
systemctl restart oddjobd.service


perl -pi -e 's/installonly_limit=3/installonly_limit=2/' /etc/yum.conf
#############################################
# selinux disabled
#############################################
perl -pi -e 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0

echo 'Cmnd_Alias CMD_APPLICATIONS = \
    /usr/bin/rpm,\
    /usr/bin/yum,\
    /usr/bin/tar,\
    /usr/bin/crontab,\
    /usr/bin/sudoedit /etc/tomax/*,\
    /usr/bin/cp /etc/tomax/*,\
    /u01/app/oraInventory/orainstRoot.sh,\
    /u01/app/oracle/product/*/root.sh,\
    /u01/app/ri-hosting/systemd-services/*,\
    /bin/cp /etc/security/limits,\
    /usr/bin/sudoedit /etc/security/limits,\
    /bin/cat /var/log/maillog*,\
    /bin/cat /var/log/messages*,\
    /bin/cat /opt/oracle/dcs/log/*.log,\
    /opt/oracle/dcs/bin/dbcli' > /etc/sudoers.d/00_apps_alias


echo 'Cmnd_Alias SU_SUP = \
    /bin/su - ftpdl,\
    /bin/su - jboss*,\
    /bin/su - oas,\
    /bin/su - rf*,\
    /bin/su - tomax,\
    /bin/su - tomcat*

%risupport         ALL =(ALL) PASSWD: SU_SUP' > /etc/sudoers.d/00-risupport

echo '%ridba         ALL =(ALL) PASSWD: SU_APPLICATIONS, CMD_APPLICATIONS

Cmnd_Alias SU_APPLICATIONS = \
    /bin/su - oracle*,\
    /bin/su - grid*,\
    /bin/su - oas*,\
    /bin/su - tomax*,\
    /bin/su - rf*,\
    /bin/su - jboss*,\
    /bin/su - tomcat*,\
    /bin/su - ftpdl,\
    /bin/su - postgres*,\
    /bin/su - zabbix*' > /etc/sudoers.d/00-ridba

echo '%tzlroot   ALL=(ALL) ALL' > /etc/sudoers.d/10-jumpcloud


chmod 440 /etc/sudoers.d/10-jumpcloud
chmod 440 /etc/sudoers.d/00-risupport
chmod 440 /etc/sudoers.d/00-ridba



                ;;
        8)
            echo "Returning to Main Menu..."
            return
            ;;
        *)
            echo -e "${RED}Invalid choice. Please select a valid option.${NC}"
            return
            ;;
    esac

}



# Function to display menu and install selected software stack
rediron_branding() {

FILE_PATH="/usr/share/zabbix/local/conf/brand.conf.php"

# Create the directory if it doesn't exist
mkdir -p $(dirname "$FILE_PATH")

# Write the content to the file
cat <<EOL > "$FILE_PATH"
<?php
return [
    'BRAND_FOOTER' => '© REDIRON TECHNOLOGIES',
    'BRAND_HELP_URL' => 'https://redirontech.com/',
];
?>
EOL

chmod 644 "$FILE_PATH"

#Configure Zabbix left banner side bar name if we were not set on while Zabbix config

sed -i "s/\$ZBX_SERVER_NAME *= *'Zabbix';/\$ZBX_SERVER_NAME = 'Rediron Monitoring';/" /etc/zabbix/web/zabbix.conf.php

#Change the page title name
sed -i "s/('Zabbix')/('RI')/g" /usr/share/zabbix/include/page_header.php

#Changing dashaboard system information parameter names
sed -i "s/Zabbix/Rediron Monitoring/g" /usr/share/zabbix/app/partials/administration.system.info.php

#Logo changes through css file
#Blue theme changes

sed -i "422s|.*|background: url('data:image/png;base64,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') no-repeat;|" /usr/share/zabbix/assets/styles/blue-theme.css

sed -i "428s|.*|background: url('data:image/png;base64,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') no-repeat;|" /usr/share/zabbix/assets/styles/blue-theme.css

sed -i "434s|.*|background: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABcAAAAYCAYAAAARfGZ1AAAAAXNSR0IArs4c6QAAA1JJREFUSEutlU9vHEUQxX/V3TOz42xsIjve8E9xzAUimYCCQBYIJL4EIASfgAPwPTggThw4wIFbOHLLKUiIG4mQAkSOCDgWOIlje/94d3q6C/XEBuz1wiKlLivtdL+qrvfqlWwVaFbnQORhReWU3CvStU7/CWpU8DYgag/liqKIglUwYghEjCpKOjdemIiMgwentAIMnRwBN1gMBPBRMdEzYzIqUiHHv/lQ5SmbCpyodhBKDu6ky+n/FM2P1rB9n0sXV3llfQ1rLRFlxptDWcbAgxhOVrsIiYcUx3FhCCEQsOz4u2w/vsLZ+5tU5l/AE1QCn/NdVHOiBuygC01vU8WKpvsuZyglZWGpgUG9Q5EtUDc0pZMPnjlGaANedakkw9aBYZFjDdQJVGBYWOb3atYK4dxuF6kLjDq+Xlrk1c0tkAj7YpgI7iXHRmUvzxGVBlwbxQjBRJJ6fr7wAquXv0PbEb32PXsXX0IT4/8FHiRDYmSQl/tPHVfExsIiT23cxpoAt2/QO7symdC/el51mQb86iOnWf1jA7EB1m/SXzo/HXjTcx8ZtWYwCsHURBMxUciCJTgof/0J7Sw39H3z2us89+2V6cCVnFEd6J9qozHgYpKk4jNLL5vn3NXL0DkPLtDr14T5WWxz5u+YSChyoPPJjhNjTVTDrfc/pPPpJxCn0XnVJYGrKgkghTGWGLWZxma0YsT4wJWVp3l+/TeoQjo1XeVBcu6N+hQff9QIXLQm2Db+vQ9YbDkYwbVnV1i68SOmmcxjzOuoKx4MkUpO7T1V2cKqJA+kW3rsZ59TvvEuM6nG3oCd2XmcefC6ozG552n8UQZ51hCZrMmFFlU2pNzcIs62UZPh7txk8OQzjZcdrX4i+CSdi0DdPkO48wtzVpre//DO2yx/dQlbH7bp/w2e+q941t56kwtffEmy6W5/xOajc5zZi40IDmIMXKWm9GkFgNcI2cmx8U/bqJfD6bu36J14jFYEt71Jr7NMZUbk6fJxrpgW2PXiFCUjTGF5YndwWF77qdLy8GT8npWosQycslB4Ovd2ic3qAxkYp8nxJq2qySM0+YtTpZ8JsuOcJu94mBGsMhscMirnVIdDfJKBHK/XaRM7jVSuoJI9rr/4Mn8CkEfCy+fakQAAAAAASUVORK5CYII=') no-repeat; }|" /usr/share/zabbix/assets/styles/blue-theme.css

#Dark theme changes
sed -i "427s|.*|background: url('data:image/png;base64,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') no-repeat;|" /usr/share/zabbix/assets/styles/dark-theme.css


sed -i "433s|.*|background: url('data:image/png;base64,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') no-repeat;|" /usr/share/zabbix/assets/styles/dark-theme.css

sed -i "439s|.*|background: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABcAAAAYCAYAAAARfGZ1AAAAAXNSR0IArs4c6QAAA1JJREFUSEutlU9vHEUQxX/V3TOz42xsIjve8E9xzAUimYCCQBYIJL4EIASfgAPwPTggThw4wIFbOHLLKUiIG4mQAkSOCDgWOIlje/94d3q6C/XEBuz1wiKlLivtdL+qrvfqlWwVaFbnQORhReWU3CvStU7/CWpU8DYgag/liqKIglUwYghEjCpKOjdemIiMgwentAIMnRwBN1gMBPBRMdEzYzIqUiHHv/lQ5SmbCpyodhBKDu6ky+n/FM2P1rB9n0sXV3llfQ1rLRFlxptDWcbAgxhOVrsIiYcUx3FhCCEQsOz4u2w/vsLZ+5tU5l/AE1QCn/NdVHOiBuygC01vU8WKpvsuZyglZWGpgUG9Q5EtUDc0pZMPnjlGaANedakkw9aBYZFjDdQJVGBYWOb3atYK4dxuF6kLjDq+Xlrk1c0tkAj7YpgI7iXHRmUvzxGVBlwbxQjBRJJ6fr7wAquXv0PbEb32PXsXX0IT4/8FHiRDYmSQl/tPHVfExsIiT23cxpoAt2/QO7symdC/el51mQb86iOnWf1jA7EB1m/SXzo/HXjTcx8ZtWYwCsHURBMxUciCJTgof/0J7Sw39H3z2us89+2V6cCVnFEd6J9qozHgYpKk4jNLL5vn3NXL0DkPLtDr14T5WWxz5u+YSChyoPPJjhNjTVTDrfc/pPPpJxCn0XnVJYGrKgkghTGWGLWZxma0YsT4wJWVp3l+/TeoQjo1XeVBcu6N+hQff9QIXLQm2Db+vQ9YbDkYwbVnV1i68SOmmcxjzOuoKx4MkUpO7T1V2cKqJA+kW3rsZ59TvvEuM6nG3oCd2XmcefC6ozG552n8UQZ51hCZrMmFFlU2pNzcIs62UZPh7txk8OQzjZcdrX4i+CSdi0DdPkO48wtzVpre//DO2yx/dQlbH7bp/w2e+q941t56kwtffEmy6W5/xOajc5zZi40IDmIMXKWm9GkFgNcI2cmx8U/bqJfD6bu36J14jFYEt71Jr7NMZUbk6fJxrpgW2PXiFCUjTGF5YndwWF77qdLy8GT8npWosQycslB4Ovd2ic3qAxkYp8nxJq2qySM0+YtTpZ8JsuOcJu94mBGsMhscMirnVIdDfJKBHK/XaRM7jVSuoJI9rr/4Mn8CkEfCy+fakQAAAAAASUVORK5CYII=') no-repeat; }|" /usr/share/zabbix/assets/styles/dark-theme.css

echo "RedIron Branding changes applied"
}
#Function Install RI-agent2

install_agent2 () {

rpm -Uvh https://repo.zabbix.com/zabbix/7.0/oracle/8/x86_64/zabbix-release-latest-7.0.el8.noarch.rpm

dnf install -y zabbix-agent2 zabbix-get zabbix-sender zabbix-agent2-plugin-*

# Clean all dnf cache
echo "Cleaning dnf cache"
dnf clean all

read -p "According to your environment, enter your ZBX proxy or server IP address:"  RESP
sed -i "s/ServerActive=127.0.0.1/ServerActive=127.0.0.1,$RESP/g" /etc/zabbix/zabbix_agent2.conf
sed -i "s/Server=127.0.0.1/Server=127.0.0.1,$RESP/g" /etc/zabbix/zabbix_agent2.conf
sed -i "s/Hostname=Zabbix server/Hostname=$HOSTNAME_VAR/g" /etc/zabbix/zabbix_agent2.conf
sed -i '290 i Include=/u01/app/zabbix-agent/userparams.conf.d' /etc/zabbix/zabbix_agent2.conf
# Remove existing Zabbix user entry from /etc/passwd if it exists
    if grep -q "^zabbix:" /etc/passwd; then
        echo "Removing existing Zabbix user entry from /etc/passwd..."
        sudo sed -i '/^zabbix:/d' /etc/passwd
    else
        echo "No existing Zabbix user entry found."
    fi

    # After installing modify Zabbix user entry /etc/passwd
    echo " Zabbix user login shell change in /etc/passwd..."
    echo "zabbix:x:200:200:Zabbix Monitoring System:/var/lib/zabbix:/bin/bash" | sudo tee -a /etc/passwd > /dev/null
    groupadd -g 200 monitoring
    usermod -aG monitoring zabbix
    usermod -aG dba zabbix
    usermod -aG tomax zabbix

    #changing permission
cd /var/log/
chown zabbix:zabbix zabbix/ -R

cd /var/run
chown zabbix:zabbix zabbix/ -R


cd /var/lib/
mkdir zabbix
chown zabbix:monitoring zabbix/ -R

cd /u01/app/
chown zabbix:monitoring zabbix-agent/ -R

mkdir -p /run/zabbix
touch /run/zabbix/agent.sock
chown zabbix:monitoring /run/zabbix/agent.sock

systemctl daemon-reload
systemctl enable zabbix-agent2
systemctl restart zabbix-agent2

}	

# Main script execution
while true; do
    clear
    echo -e "${CYAN}╔═════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   RedIron Genie - Select from the wish list below!      ║${NC}"
    echo -e "${CYAN}╠═════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ ${YELLOW}1)${NC} ${GREEN}Disable Firewall                  ${CYAN}                   ║${NC}"
    echo -e "${CYAN}║ ${YELLOW}2)${NC} ${GREEN}Set Timezone                      ${CYAN}                   ║${NC}"
    echo -e "${CYAN}║ ${YELLOW}3)${NC} ${GREEN}RI-Monitoring                     ${CYAN}                   ║${NC}"
    echo -e "${CYAN}║ ${YELLOW}4)${NC} ${GREEN}Install JumpCloud                 ${CYAN}                   ║${NC}"
    echo -e "${CYAN}║ ${YELLOW}5)${NC} ${RED}Exit                                ${CYAN}                   ║${NC}"
    echo -e "${CYAN}╚═════════════════════════════════════════════════════════╝${NC}"

    read -p "Enter your choice (1-5): " main_choice
case $main_choice in
    1)
        disable_firewall
        read -p "Press [Enter] key to continue..."
        ;;
    2)
        set_timezone
        read -p "Press [Enter] key to continue..."
        ;;
    3)
        install_ri-monitoring
        #read -p "Press [Enter] key to continue..."
        ;;
    4)
        install_jumpcloud
        read -p "Press [Enter] key to continue..."
        ;;
    5)
        echo -e "${RED}Exiting...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice. Please select a valid option.${NC}"
        ;;
esac
done
