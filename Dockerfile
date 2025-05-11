FROM mysql:8.0

ENV MYSQL_ROOT_PASSWORD=rootpassword
ENV MYSQL_DATABASE=testdb
ENV MYSQL_USER=testuser
ENV MYSQL_PASSWORD=

CMD ["--default-authentication-plugin=mysql_native_password"]