#!/bin/bash
#INSTALANDO PACOTES NECESSARIOS PARA O FUNCIONAMENTO 
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
touch /etc/apt/sources.list.d/elastic.list
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" >> /etc/apt/sources.list.d/elastic.list
apt-get -y update 
apt-get -y install  awscli
apt-get -y install openjdk-8-jre 
apt-get -y install logstash

#COPIANDO A CHAVE SSH E COLOCANDO NO DIRETORIO .SSH 

aws s3 cp s3://sshkeyeks/kibana-cluster /root
touch /root/.ssh/id_rsa
mv /root/kibana-cluster /root/.ssh/id_rsa
chmod 400 /root/.ssh/id_rsa 

#ADICIONANDO A  CHAVE PUBLICA DO BITBUCKET AO KNOW HOSTS

touch /root/.ssh/known_hosts
ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts


#COPIANDO ARQUIVOS DE CONFIGURACAO

 git clone git@bitbucket.org:smartmei/kibana-iac.git /home/ubuntu/kibana-iac
 cd /home/ubuntu/kibana-iac/ 
 git pull origin teste-arquivos
 rm -rf /etc/kibana/kibana.yml
 cp /home/ubuntu/kibana-iac/conf_files/logstash-nginx-es.conf /etc/logstash/conf.d


#STARDANDO O LOGSTASH

systemctl start logstash