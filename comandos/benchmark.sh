#!/bin/bash

# Configurações
DB_USER="testuser"
DB_PASS="testpassword"
DB_NAME="testdb"
DURATION=60
THREADS=16
INTERVAL=10
NETWORK_NAME="sysbench"

# Criando rede Docker
#docker network create $NETWORK_NAME 

# Container MySQL com 4 CPU, 4GB RAM, buffer pool 3G
docker run -d \
  --name mysql_high \
  --network $NETWORK_NAME \
  --cpus="4" \
  --memory="4g" \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=$DB_NAME \
  -e MYSQL_USER=$DB_USER \
  -e MYSQL_PASSWORD=$DB_PASS \
  -p 3307:3306 \
  mysql:8.0 \
  --default-authentication-plugin=mysql_native_password \
  --innodb-buffer-pool-size=3G

echo "Aguardando o MySQL (mysql_high) iniciar..."
sleep 10

echo "Preparando banco (mysql_high)..."
sysbench oltp_read_only \
  --mysql-host=mysql_high \
  --mysql-port=3306 \
  --mysql-user=$DB_USER \
  --mysql-password=$DB_PASS \
  --mysql-db=$DB_NAME \
  prepare

echo "Rodando benchmark (mysql_high)..."
sysbench oltp_read_only \
  --mysql-host=mysql_high \
  --mysql-port=3306 \
  --mysql-user=$DB_USER \
  --mysql-password=$DB_PASS \
  --mysql-db=$DB_NAME \
  --threads=$THREADS \
  --time=$DURATION \
  --report-interval=$INTERVAL \
  run

echo "Finalizando e limpando (mysql_high)..."
sysbench oltp_read_only \
  --mysql-host=mysql_high \
  --mysql-port=3306 \
  --mysql-user=$DB_USER \
  --mysql-password=$DB_PASS \
  --mysql-db=$DB_NAME \
  cleanup
docker rm -f mysql_high

# Container MySQL com 1.5 CPU, 512MB RAM, buffer pool 256M
docker run -d \
  --name mysql_low \
  --network $NETWORK_NAME \
  --cpus="1.5" \
  --memory="512m" \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=$DB_NAME \
  -e MYSQL_USER=$DB_USER \
  -e MYSQL_PASSWORD=$DB_PASS \
  -p 3306:3306 \
  mysql:8.0 \
  --default-authentication-plugin=mysql_native_password \
  --innodb-buffer-pool-size=256M

echo "Aguardando o MySQL (mysql_low) iniciar..."
sleep 25

echo "Preparando banco (mysql_low)..."
sysbench oltp_read_only \
  --mysql-host=mysql_low \
  --mysql-port=3306 \
  --mysql-user=$DB_USER \
  --mysql-password=$DB_PASS \
  --mysql-db=$DB_NAME \
  prepare

echo "Rodando benchmark (mysql_low)..."
sysbench oltp_read_only \
  --mysql-host=mysql_low \
  --mysql-port=3306 \
  --mysql-user=$DB_USER \
  --mysql-password=$DB_PASS \
  --mysql-db=$DB_NAME \
  --threads=$THREADS \
  --time=$DURATION \
  --report-interval=$INTERVAL \
  run

echo "Finalizando e limpando (mysql_low)..."
sysbench oltp_read_only \
  --mysql-host=mysql_low \
  --mysql-port=3306 \
  --mysql-user=$DB_USER \
  --mysql-password=$DB_PASS \
  --mysql-db=$DB_NAME \
  cleanup
docker rm -f mysql_low

# Remover rede Docker
docker network rm $NETWORK_NAME

echo "✅ Benchmark finalizado."
