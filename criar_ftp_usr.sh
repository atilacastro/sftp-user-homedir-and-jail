#!/bin/sh

##################################################
# Autor     : Átila Castro                       #
# Descrição : Criar usuário FTP + HOME_Dir +     #
# Permissões + Jail no sshd_config               #
##################################################
################### & ############################

# Variáveis
data=$(date +"%d_%m_%H:%M:%S")
SSHD="/etc/ssh/sshd_config"
LOG="/var/log/criar_ftp_user.log"
userexist="cat /etc/passwd | grep -i $user | wc -l"
direxist="/data/$empresa"

echo "|---------------------------------|"
echo "|$data - Inicio do Script|"
echo "|---------------------------------|"
echo "|----------------------------------------------------------------|" >> $LOG
echo "|$data - Inicio                                         |" >> $LOG
echo "|LOG Detalhado das ações do Script em /var/log/criar_ftp_user.log|" >> $LOG
echo "|----------------------------------------------------------------|" >> $LOG

echo "|---------------------------------------------|"
echo "|Este script executa as seguintes ações:      |"
echo "|1 - Cria usuário e insere no grupo sftpusers |"
echo "|2 - Cria diretorio com o nome da empresa     |"
echo "|3 - Atribui as devidas permissões            |"
echo "|-------------------------------------------- |"
echo -n "Digite o nome da empresa: "
read empresa;
echo -n "Digite o nome do usuário: "
read user;
if [ -z $empresa ] || [ -z $user ];
  then
   echo "Erro! Insira o nome da empresa e o nome do usuário"
   exit 1
  else
   if [ -d $direxist ] || [ $userexist -ge "1" ];
     then
     echo "Diretório já existe ou Usuário já existe."
else
 useradd -G gftp -d /data/$empresa -s /sbin/nologin $user >> $LOG
 echo -n "Insira a senha para $user: "
 passwd $user >> $LOG
 echo -n "Atribuido o diretório ao root..." >> $LOG
 echo /n >> $LOG
  sudo chown root:root "/data/$empresa" >> $LOG
 echo -n "Atribuindo permissão 755 ao diretório..." >> $LOG
 echo /n >> $LOG
  sudo chmod 755 "/data/$empresa" >> $LOG
 echo -n "Criando diretório INSPECOES..." >> $LOG
 echo /n >> $LOG
  sudo mkdir "/data/$empresa/INSPECOES" >> $LOG
 echo -n "Atribuido o diretório ao usuário "$user" e ao grupo sftpusers..." >> $LOG
 echo /n >> $LOG
  sudo chown $user:gftp /data/$empresa/* >> $LOG
 echo -n "Atribuindo permissão recursiva ao diretório..." >> $LOG
 echo /n >> $LOG
  sudo chmod 755 -R /data/$empresa/* >> $LOG
 echo /n >> $LOG
 sudo echo Match User $user >> $SSHD
sudo echo "       " ChrootDirectory /data/$empresa >> $SSHD
sudo echo "       " X11Forwarding no >> $SSHD
sudo echo "       " AllowTcpForwarding no >> $SSHD
sudo echo "#      " PermitTTY no >> $SSHD
sudo echo "       " ForceCommand internal-sftp >> $SSHD
echo " Sucesso! Detalhes em /var/log/criar_ftp_user.log "
echo "|----------------------------------------------------------------------------------|" >> $LOG
echo "|Alterado o arquivo /etc/ssh/sshd_config para fazer o Jail do usuário no diretório.|" >> $LOG
echo "|$data - Fim                                                              |" >> $LOG
echo "|----------------------------------------------------------------------------------|" >> $LOG
echo "|------------------------------|"
echo "|$data - Fim do Script|"
echo "|------------------------------|"
echo "End"
fi
fi
