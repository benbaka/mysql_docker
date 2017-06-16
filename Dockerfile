from ubuntu:16.04

RUN echo "Updating sources list"
ADD ./sources.list  /etc/apt/sources.list

RUN echo "Update system"
RUN apt-get update \
    && apt-get install -y debconf-utils \
    && echo "mysql-server-5.7 mysql-server/root_password password admin" | debconf-set-selections \
    && echo "mysql-server-5.7 mysql-server/root_password_again password admin" | debconf-set-selections

RUN echo "Installing mysql-server"
RUN apt-get -y install mysql-server 

RUN echo "Add my.cnf file" 
ADD ./my.cnf /etc/mysql/my.cnf

RUN echo "Add mysql conf file for setting bind address"
ADD ./mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

# Start mysql service
RUN service mysql restart

RUN echo "Create admin account"
RUN /usr/bin/mysqld_safe & sleep 10s && echo "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'admin' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql -u root --password=admin
    
EXPOSE 3306

CMD '/usr/bin/mysqld_safe'

