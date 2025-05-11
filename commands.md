# DOCKER SCRIPTS

## MYSQL

### buildar a imagem Dockerfile
    docker build -t meu_mysql .


### RODAR CONTAINER 
    docker run -d --name mysql_container --network sysbench --cpus="1.5" --memory="512m" -p 3306:3306 meu_mysql

    docker stop mysql_container

    docker rm mysql_container

    docker run -d --name mysql_container --network sysbench --cpus="3" --memory="3g" -p 3306:3306 meu_mysql
    

### ENTRAR BASH E SETAR POOL_SIZE:
    
    docker exec -it mysql_container bash
    mysql -u root -prootpassword



## SYSBENCH

#### entrar no bash e setar pool_size

    docker exec -it sysbench bash
    
    mysql -u root -prootpassword

    SHOW VARIABLES LIKE 'innodb_buffer_pool_size';

    
    SET GLOBAL innodb_buffer_pool_size = 3221225472; -> 3GB



    






# SYSBENCH SCRIPTS

### PREPARE

    sysbench oltp_read_only --mysql-host=mysql_container --mysql-user=testuser --mysql-password=testpassword --mysql-db=testdb --tables=10 --table-size=100000 prepare


### LIMPAR CACHE:

sysbench oltp_read_write \
  --mysql-host=mysql_container \
  --mysql-user=testuser \
  --mysql-password=testpassword \
  --mysql-db=testdb \
  cleanup



### APENAS SELECT: 
    
    sysbench oltp_read_only --mysql-host=mysql_container --mysql-user=testuser --mysql-password=testpassword --mysql-db=testdb --threads=32 --time=30 --report-interval=10 --tables=10 --table-size=100000 run

### SELECT COM WHERE:
    sysbench oltp_point_select --mysql-host=mysql_container --mysql-user=testuser --mysql-password=testpassword --mysql-db=testdb --tables=10 --table-size=100000--threads=32 --time=30 --report-interval=10 --histogram run
        

### LEITURA E ESCRITA:

    sysbench oltp_read_write \
    --mysql-host=mysql_container \
    --mysql-user=testuser \
    --mysql-password=testpassword \
    --mysql-db=testdb \
    --threads=16 \
    --time=30 \
    --report-interval=10 \
    --tables=10 \
    --table-size=100000 \
    run



