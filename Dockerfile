FROM ubuntu:14.04
MAINTAINER Germán Moya <pbacterio@gmail.com>

# To allow unicode databases
RUN locale-gen en_US.utf8

RUN apt-get update; apt-get install -y postgresql

# Launcher script
ADD run /var/lib/postgresql/
RUN chmod +x /var/lib/postgresql/run

# Recreate cluster with utf8 encoding.
RUN pg_dropcluster 9.3 main
RUN pg_createcluster --locale en_US.utf8 9.3 main

# Allow remote connections
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf
RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/9.3/main/pg_hba.conf

RUN ls -l /var/lib/postgresql
RUN touch /var/lib/postgresql/first_run

USER postgres
WORKDIR /var/lib/postgresql

VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

EXPOSE 5432

CMD ["/var/lib/postgresql/run"]
