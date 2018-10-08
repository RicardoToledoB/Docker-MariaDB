FROM debian

RUN apt-get update && apt-get install -y \
    rsync mariadb-server vim

RUN sed -i 's/.*bind-address.*/bind-address = 0.0.0.0/g' "/etc/mysql/mariadb.conf.d/50-server.cnf"  

ENV MAKE_NEW_DATABASE="MUJOJO" \
    MAKE_USERNAME="ricardo" \
    MAKE_USER_PASSWORD="secret123secret" \
    MAKE_ROOT_PASSWORD="secret123secret" 

COPY script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh
RUN /usr/local/bin/script.sh

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

CMD ["mysqld_safe"]
