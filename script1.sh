#!/bin/bash

#install prerequisites 
yum install -y java-1.8.0-openjdk
yum install -y java-1.8.0-openjdk-devel  
yum install -y unzip

#setting up tomcat
#environment variables
CATALINA_HOME=/usr/share/tomcat/apache-tomcat-8.5.42
JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.212.b04-0.el7_6.x86_64/bin
JRE_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.212.b04-0.el7_6.x86_64/jre

#logstash
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
touch /tmp/logstash.repo
echo -e "[logstash-7.x] \nname=Elastic repository for 7.x packages \nbaseurl=https://artifacts.elastic.co/packages/7.x/yum" > /tmp/logstash.repo
echo -e "gpgcheck=1 \ngpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch \nenabled=1 \nautorefresh=1 \ntype=rpm-md" >> /tmp/logstash.repo
mv /tmp/logstash.repo /etc/yum.repos.d/logstash.repo

yum install -y logstash

#tomcat installation
useradd tomcat

mkdir -p /usr/share/tomcat
wget -P /tmp ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.42/bin/apache-tomcat-8.5.42.zip 
unzip /tmp/apache-tomcat-8.5.42.zip -d /usr/share/tomcat

touch $CATALINA_HOME/bin/setenv.sh
sudo chmod 755 $CATALINA_HOME/bin/*.sh
sudo chown -R tomcat:tomcat $CATALINA_HOME

echo \#\!/bin/bash > $CATALINA_HOME/bin/setenv.sh
echo "export CATALINA_HOME=${CATALINA_HOME}" >> $CATALINA_HOME/bin/setenv.sh
echo "export JAVA_HOME=${JAVA_HOME}" >> $CATALINA_HOME/bin/setenv.sh
echo "export JRE_HOME=${JRE_HOME}" >> $CATALINA_HOME/bin/setenv.sh

#adding .war file and autodeploy it
cp /vagrant/logstash-ex.conf /etc/logstash/conf.d/logstash.conf

echo 'http.host: 192.168.45.30' >> /etc/logstash/logstash.yml

${CATALINA_HOME}/bin/catalina.sh start

systemctl daemon-reload
systemctl enable logstash.service
systemctl start logstash.service

