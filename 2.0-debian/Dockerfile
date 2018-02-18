FROM tiredofit/debian:stretch
LABEL maintainer="Dave Conroy <dave at tiredofit dot ca>"

### Environment Variables
   ENV PORTAL_HOSTNAME=sso.example.com \
       MANAGER_HOSTNAME=manager.sso.example.com \
       HANDLER_HOSTNAME=handler.sso.example.com \
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
    apt-get install -y \
            fail2ban \
            git \
            iptables \
            lemonldap-ng \
            lemonldap-ng-fastcgi-server \
            libapache-session-ldap-perl \
            libapache-session-perl \
            libauthcas-perl \
            libauthcas-perl \
            libauthen-captcha-perl \
            libauthen-captcha-perl \
            libauthen-sasl-perl \
            libcache-cache-perl \
            libcache-cache-perl \
            libclone-perl \
            libconfig-inifiles-perl \
            libconvert-pem-perl \
            libcrypt-openssl-rsa-perl \
            libcrypt-openssl-x509-perl \
            libcrypt-rijndael-perl \
            libdbd-sqlite3-perl \
            libdbi-perl \
            libdigest-hmac-perl \
            libdigest-sha-perl \
            libdigest-sha-perl \
            libemail-date-format-perl \
            libemail-sender-perl \
            libgd-securityimage-perl \
            libglib-perl \
            libhtml-template-perl \
            libimage-magick-perl \
            libio-string-perl \
            libjs-jquery \
            libjson-perl \
            liblasso-perl \
            liblasso-perl \
            libmime-lite-perl \
            libmodule-build-perl \
            libmodule-build-perl \
            libmongodb-perl \
            libmouse-perl \
            libnet-cidr-lite-perl \
            libnet-ldap-perl \
            libnet-openid-consumer-perl \
            libnet-openid-server-perl \
            libplack-perl \
            libredis-perl \
            libregexp-assemble-perl \
            libregexp-common-perl \
            libsoap-lite-perl \
            libstring-random-perl \
            libtest-mockobject-perl \
            libtest-pod-perl \
            libunicode-string-perl \
            libwww-perl \
            libxml-libxml-perl \
            libxml-libxslt-perl \
            libxml-simple-perl \
            make \
            mariadb-client \
            mongodb-clients \
            mongodb-server \
            perl-modules \
            && \
            
    cp -R /etc/lemonldap-ng /etc/lemonldap-ng2 && \
    rm -rf /etc/lemonldap-ng/for_etc_hosts /etc/lemonldap-ng/*.conf && \
    
    cd /usr/src/ && \
    git clone https://github.com/LemonLDAPNG/Apache-Session-LDAP && \
    git clone https://github.com/LemonLDAPNG/Apache-Session-NoSQL && \
    git clone https://github.com/LemonLDAPNG/Apache-Session-Browseable && \
    git clone https://github.com/LemonLDAPNG/apache-session-mongodb && \

    cd /usr/src/Apache-Session-NoSQL && \
    perl Makefile.PL && \
    make && \
    make test && \
    make install && \
    cd .. && \
    cd /usr/src/Apache-Session-LDAP && \
    perl Makefile.PL && \
    make && \
    make test && \
    make install && \
    cd .. && \
    cd /usr/src/Apache-Session-Browseable && \
    perl Build.PL && \
    ./Build && \
    ./Build test && \
    ./Build install && \
    cd .. && \
    cd /usr/src/apache-session-mongodb && \
    apt-get -y install mongodb && \
    perl Makefile.PL && \
    make && \
    make test && \
    make install && \
    cd .. && \

    rm -rf /usr/src/* && \
    apt-get purge -y libmodule-build-perl mongodb-server && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/log/*

### Files Setup
   ADD install /
