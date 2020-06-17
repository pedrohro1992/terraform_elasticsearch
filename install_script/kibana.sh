#!/bin/bash


while [ `ps ax | grep -i apt | grep -vw grep | wc -l` -gt 0 ]; do
    echo "Running APT processes detected ... sleeping"
    sleep 5
done



#SETANDO A VARIAVEL DE AMBIENTE COM O IP DO SERVIDOR

echo "HOST_IP="$(hostname -i)"" >> /etc/environment

#INSTALANDO PACOTES NECESSARIOS PARA O FUNCIONAMENTO 
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
touch /etc/apt/sources.list.d/elastic.list
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" >> /etc/apt/sources.list.d/elastic.list
apt-get -y update 
apt-get -y install  awscli
apt-get -y install openjdk-8-jre
apt-get -y install nginx 
apt-get -y install kibana 




#COPIANDO A CHAVE SSH E COLOCANDO NO DIRETORIO .SSH 

aws s3 cp s3://sshkeyeks/kibana-cluster /root
touch /root/.ssh/id_rsa
mv /root/kibana-cluster /root/.ssh/id_rsa
chmod 400 /root/.ssh/id_rsa                           

#ADICIONANDO A  CHAVE PUBLICA DO BITBUCKET AO KNOW HOSTS

touch /root/.ssh/known_hosts
ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts

#COPIANDO OS ARQUIVOS DO BITBUCKET 

 git clone git@bitbucket.org:smartmei/kibana-iac.git /home/ubuntu/kibana-iac
 cd /home/ubuntu/kibana-iac/ 
 git pull origin teste-arquivos
 rm -rf /etc/kibana/kibana.yml
 cp /home/ubuntu/kibana-iac/conf_files/kibana.yml /etc/kibana
 rm -rf /etc/nginx/sites-enabled/default
 cp /home/ubuntu/kibana-iac/conf_files/kibana /etc/nginx/sites-available/
 chown ubuntu:ubuntu /etc/nginx/sites-available/kibana 
 ln -s /etc/nginx/sites-available/kibana /etc/nginx/sites-enabled/kibana
 chown ubuntu:ubuntu /etc/nginx/sites-enabled/kibana





#ESTARTANDO O EKS

systemctl restart kibana
nginx -s reload 
systemctl start logstash







