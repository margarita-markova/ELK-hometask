#!/bin/bash

TRUSTED_IP=192.168.45.30

systemctl stop firewalld

#install prerequisites 
yum install -y java-1.8.0-openjdk
yum install -y java-1.8.0-openjdk-devel

#elasticsearch
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
touch /tmp/elasticsearch.repo
echo -e "[elasticsearch-7.x] \nname=Elasticsearch repository for 7.x packages \nbaseurl=https://artifacts.elastic.co/packages/7.x/yum" > /tmp/elasticsearch.repo
echo -e "gpgcheck=1 \ngpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch \nenabled=1 \nautorefresh=1 \ntype=rpm-md" >> /tmp/elasticsearch.repo
mv /tmp/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo

sudo chmod -R 755 /etc/elasticsearch

yum install -y elasticsearch

echo 'node.name: node1' >> /etc/elasticsearch/elasticsearch.yml
echo 'cluster.initial_master_nodes: node1' >> /etc/elasticsearch/elasticsearch.yml
echo 'network.host: 192.168.46.30' >> /etc/elasticsearch/elasticsearch.yml
echo 'http.port: 9200' >> /etc/elasticsearch/elasticsearch.yml

systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service

yum install -y kibana

echo 'server.host: 192.168.46.30' >> /etc/kibana/kibana.yml
echo 'elasticsearch.hosts: ["http://192.168.46.30:9200"]' >> /etc/kibana/kibana.yml

systemctl enable kibana.service
systemctl start kibana.service

