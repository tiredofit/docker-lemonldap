FROM tiredofit/debian:stretch
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Environment Variables
   ENV PORTAL_HOSTNAME=sso.example.com \
       MANAGER_HOSTNAME=manager.sso.example.com \
       RELOAD_HOSTNAME=reload.sso.example.com \
       TEST_HOSTNAME=test.sso.example.com \
       DOMAIN_NAME=example.com \
       PATH=/usr/share/lemonldap-ng/bin:${PATH}

# Update system
   RUN apt-get -y update && \
       apt-get -y dist-upgrade && \

# Install LemonLDAP::NG repo
    apt-get -y install apt-transport-https && \
    curl https://lemonldap-ng.org/_media/rpm-gpg-key-ow2 | apt-key add - && \

    echo "deb https://lemonldap-ng.org/deb 2.0 main" > /etc/apt/sources.list.d/lemonldap-ng.list && \
    echo "deb-src https://lemonldap-ng.org/deb 2.0 main" >> /etc/apt/sources.list.d/lemonldap-ng.list && \

# Install LemonLDAP::NG packages
    apt-get -y update && \
    apt-get install -y \
            lemonldap-ng \
            lemonldap-ng-fastcgi-server \
            libapache-session-ldap-perl \
            libauthcas-perl \
            libauthen-captcha-perl \
            libglib-perl \
            liblasso-perl \
            make \
            mariadb-client \
            mongodb-clients \
            && \
            
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    cp -R /etc/lemonldap-ng/nginx-lmlog.conf /etc/nginx/conf.d/ && \
    cp -R /etc/lemonldap-ng /etc/lemonldap-ng2 && \
    rm -rf /etc/lemonldap-ng/for_etc_hosts /etc/lemonldap-ng/*.conf && \
    
    mkdir -p /usr/src/apache-session-nosql && \
    curl -sSL http://search.cpan.org/CPAN/authors/id/C/CO/COUDOT/Apache-Session-NoSQL-0.2.tar.gz | tar xvfz - --strip 1 -C /usr/src/apache-session-nosql && \
    cd /usr/src/apache-session-nosql && \
    perl Makefile.PL && \
    make install && \
    rm -rf /usr/src/*
            
### Files Setup
   ADD install /

### Networking Setup
   EXPOSE 80

### Entrypoint Setup
   ENTRYPOINT ["/init"]
