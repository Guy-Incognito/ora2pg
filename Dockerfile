FROM perl:slim

ARG ORA2PG_VERSION=23.1

# ugly fix for "update-alternatives" missing directories in slim image
RUN mkdir -p /usr/share/man/man1 &&\
    mkdir -p /usr/share/man/man7
RUN apt-get update && apt-get install -y -q --no-install-recommends \
        cpanminus \
        unzip \
        curl \
        ca-certificates \
        rpm \
        alien \
        libaio1 \
        # Install postgresql
        postgresql-client \
        # Install mysql
        libdbd-mysql \
        #install Perl Database Interface
        libdbi-perl \
        bzip2 \
        libpq-dev \
        gnupg2 \
        libdbd-pg-perl
# passwordfile cannot be empty 
ADD /assets/passwd /etc/passwd
RUN chmod g+w /etc/passwd
RUN mkdir -p /.postgresql/
ADD /assets/ /assets/
ADD certs/rds-combined-ca-bundle.pem /tmp/rds-ca/aws-rds-ca-bundle.pem
ADD certs/rds-combined-ca-bundle.pem /.postgresql/root.crt
ADD certs/sb1a-issuing-ca.crt /usr/local/share/ca-certificates/
ADD certs/sb1a-root-ca.crt /usr/local/share/ca-certificates/

RUN cd /tmp/rds-ca && cat aws-rds-ca-bundle.pem|awk 'split_after==1{n++;split_after=0} /-----END CERTIFICATE-----/ {split_after=1} {print > "cert" n ""}' \
    && for CERT in /tmp/rds-ca/cert*; do mv $CERT /usr/local/share/ca-certificates/aws-rds-ca-$(basename $CERT).crt; done \
    && rm -rf /tmp/rds-ca \
    && update-ca-certificates


# Instal Oracle Client
RUN mkdir /usr/lib/oracle/19.15/client64/network/admin/ora2pg -p
ADD admin/ora2pg/cwallet.sso /usr/lib/oracle/19.15/client64/network/admin/ora2pg/cwallet.sso
RUN chown 1707009071.170700513 /usr/lib/oracle/19.15/client64/network/admin/ora2pg/cwallet.sso
ADD admin/sqlnet.ora /usr/lib/oracle/19.15/client64/network/admin/sqlnet.ora

VOLUME /usr/lib/oracle/19.15/client64/network/admin

RUN alien -i /assets/oracle-instantclient19.15-basic-19.15.0.0.0-2.x86_64.rpm &&\
    alien -i /assets/oracle-instantclient19.15-devel-19.15.0.0.0-2.x86_64.rpm &&\
    alien -i /assets/oracle-instantclient19.15-sqlplus-19.15.0.0.0-2.x86_64.rpm

ENV ORACLE_HOME=/usr/lib/oracle/19.15/client64
ENV TNS_ADMIN=/usr/lib/oracle/19.15/client64/network/admin
ENV LD_LIBRARY_PATH=/usr/lib/oracle/19.15/client64/lib
ENV PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/oracle/19.15/client64/bin

# Install DBI module with Postgres, Oracle and Compress::Zlib module
RUN cpan install Test::NoWarnings &&\
    cpan install DBI &&\
    cpan install DBD::Pg &&\
    cpan install Bundle::Compress::Zlib &&\
    cpanm install DBD::Oracle@1.82

# Install ora2pg
RUN curl -L -o /tmp/ora2pg.zip https://github.com/darold/ora2pg/archive/v$ORA2PG_VERSION.zip &&\
    (cd /tmp && unzip ora2pg.zip && rm -f ora2pg.zip) &&\
    mv /tmp/ora2pg* /tmp/ora2pg

COPY Ora2Pg.pm /tmp/ora2pg/lib/Ora2Pg.pm
RUN (cd /tmp/ora2pg && perl Makefile.PL && make && make install)

# config directory
RUN mkdir /config
RUN cp /etc/ora2pg/ora2pg.conf.dist /etc/ora2pg/ora2pg.conf.backup  &&\
    cp /etc/ora2pg/ora2pg.conf.dist /config/ora2pg.conf
VOLUME /config

# output directory
RUN mkdir /data
VOLUME /data

ADD entrypoint.sh /usr/bin/entrypoint.sh

WORKDIR /

ENTRYPOINT ["entrypoint.sh"]

CMD ["ora2pg"]
