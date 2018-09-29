FROM perl

RUN apt update && apt install -y unzip rpm alien

# Install ora2pg

RUN curl -L -o /tmp/ora2pg.zip https://github.com/darold/ora2pg/archive/v18.2.zip &&\
    (cd /tmp && unzip ora2pg.zip && rm -f ora2pg.zip) &&\
    mv /tmp/ora2pg* /tmp/ora2pg &&\
    (cd /tmp/ora2pg && perl Makefile.PL && make && make install)

# Install postgresql

RUN apt install -y postgresql-client


ADD /assets /assets

# Instal Oracle Client

RUN mkdir /usr/lib/oracle/12.2/client64/network/admin -p

RUN apt-get install -y libaio1

RUN alien -i /assets/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm &&\
    alien -i /assets/oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm &&\
    alien -i /assets/oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm

ENV ORACLE_HOME=/usr/lib/oracle/12.2/client64
ENV TNS_ADMIN=/usr/lib/oracle/12.2/client64/network/admin
ENV LD_LIBRARY_PATH=/usr/lib/oracle/12.2/client64/lib
ENV PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/oracle/12.2/client64/bin

# Instal Oracle database driver for the DBI module

RUN apt-get install -y libdbi-perl &&\
    perl -MCPAN -e 'install DBI' &&\
    perl -MCPAN -e 'install DBD::Pg'

RUN curl -L http://www.perl.org/CPAN/authors/id/P/PY/PYTHIAN/DBD-Oracle-1.74.tar.gz | (cd /tmp && tar -zxvf -) && \
    mv /tmp/DBD-Ora* /tmp/DBD-Oracle

RUN cd /tmp/DBD-Oracle && perl Makefile.PL -l && make && make install

# config directory
RUN mkdir /config
RUN cp /etc/ora2pg/ora2pg.conf.dist /etc/ora2pg/ora2pg.conf.backup  &&\
    cp /etc/ora2pg/ora2pg.conf.dist /config/ora2pg.conf
VOLUME /config

# output directory
RUN mkdir /data
VOLUME /data

ADD entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

CMD ["ora2pg"]
