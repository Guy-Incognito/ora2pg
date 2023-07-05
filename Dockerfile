FROM perl:slim

ARG ORA2PG_VERSION=24.0

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

ADD /assets /assets

# Instal Oracle Client
RUN mkdir /usr/lib/oracle/12.2/client64/network/admin -p

RUN alien -i /assets/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm &&\
    alien -i /assets/oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm &&\
    alien -i /assets/oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm

ENV ORACLE_HOME=/usr/lib/oracle/12.2/client64
ENV TNS_ADMIN=/usr/lib/oracle/12.2/client64/network/admin
ENV LD_LIBRARY_PATH=/usr/lib/oracle/12.2/client64/lib
ENV PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/oracle/12.2/client64/bin

# Install DBI module with Postgres, Oracle and Compress::Zlib module
RUN cpan install Test::NoWarnings &&\
    cpan install DBI &&\
    cpan install DBD::Pg &&\
    cpan install Bundle::Compress::Zlib &&\
    cpanm install DBD::Oracle@1.82

# Install ora2pg
RUN curl -L -o /tmp/ora2pg.zip https://github.com/darold/ora2pg/archive/v$ORA2PG_VERSION.zip &&\
    (cd /tmp && unzip ora2pg.zip && rm -f ora2pg.zip) &&\
    mv /tmp/ora2pg* /tmp/ora2pg &&\
    (cd /tmp/ora2pg && perl Makefile.PL && make && make install)

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
