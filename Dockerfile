FROM tiredofit/debian:stretch
LABEL maintainer="Dave Conroy <dave at tiredofit dot ca>"

### Environment Variables
ENV LEMONLDAP_VERSION=1.9.18 \
    MINIFY_VERSION=2.3.6 \
    DOMAIN_NAME=example.com \
    HANDLER_HOSTNAME=handler.sso.example.com \
    MANAGER_HOSTNAME=manager.sso.example.com \
    PORTAL_HOSTNAME=sso.example.com \
    TEST_HOSTNAME=test.sso.example.com \
    PATH=/usr/share/lemonldap-ng/bin:${PATH}

# Update system
RUN set -x && \
    apt-get -y update && \
    apt-get -y dist-upgrade && \
    \
# Install LemonLDAP::NG repo
    apt-get -y install apt-transport-https && \
    curl https://lemonldap-ng.org/_media/rpm-gpg-key-ow2 | apt-key add - && \
    echo "deb     https://lemonldap-ng.org/deb stable main" > /etc/apt/sources.list.d/lemonldap-ng.list && \
    echo "deb-src https://lemonldap-ng.org/deb stable main" >> /etc/apt/sources.list.d/lemonldap-ng.list && \
    \
# Install LemonLDAP::NG packages
    apt-get -y install \
            fail2ban \
            git \
            iptables \
            libapache-session-ldap-perl \
            libapache-session-perl \
            libauthcas-perl \
            libauthen-captcha-perl \
            libauthen-sasl-perl \
            libcache-cache-perl \
            libclone-perl \
            libconfig-inifiles-perl \
            libconvert-pem-perl \
            libcrypt-openssl-bignum-perl \
            libcrypt-openssl-rsa-perl \
            libcrypt-openssl-x509-perl \
            libcrypt-rijndael-perl \
            libdbd-sqlite3-perl \
            libdbi-perl \
            libdigest-hmac-perl \
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
            liblog-log4perl-perl \
            libmime-lite-perl \
            libmime-tools-perl \
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
            libu2f-server0 \
            libunicode-string-perl \
            liburi-perl \
            libwww-perl \
            libxml-libxml-perl \
            libxml-libxslt-perl \
            libxml-simple-perl \
            make \
            mariadb-client \
            mongodb-clients \
            mongodb-server \
            nginx \
            nginx-extras \
            perl-modules \
            rsyslog

### Install various GO, NodeJS Packages for Optimization and adjust temporary symlinks
RUN apt-get install -y coffeescript && \
    cd /usr/src && \
    mkdir -p /usr/src/minify && \
    curl -sSL https://github.com/tdewolff/minify/releases/download/v${MINIFY_VERSION}/minify_${MINIFY_VERSION}_linux_amd64.tar.gz | tar xvfz - --strip 1 -C /usr/src/minify && \
    mv /usr/src/minify /usr/bin/ && \
    chmod +x /usr/bin/minify && \
    \
### Checkout and Install LemonLDAP
    mkdir -p /usr/src/lemonldap-ng && \
    git clone https://gitlab.ow2.org/lemonldap-ng/lemonldap-ng /usr/src/lemonldap-ng && \
    cd /usr/src/lemonldap-ng && \
    if [ "$LEMONLDAP_VERSION" != "master" ]; then git checkout tags/v$LEMONLDAP_VERSION; fi && \
    make dist && \
    make PREFIX=/usr \
         LMPREFIX=/usr/share/lemonldap-ng \
         SBINDIR=/usr/sbin \
         INITDIR=/etc/init.d \
         ETCDFEAULTDIR=/etc/default \
         DATADIR=/var/lib/lemonldap-ng \
         DOCUMENTROOT=/usr/share/lemonldap-ng \
         PORTALSITEDIR=/usr/share/lemonldap-ng/portal \
         MANAGERSITEDIR=/usr/share/lemonldap-ng/manager \
         CONFDIR=/etc/lemonldap-ng \
         CRONDIR=/etc/cron.d \
         APACHEUSER=www-data \
         APACHEGROUP=www-data \
         FASTCGISOCKDIR=/var/run/llng-fastcgi-server \
         PROD=yes \
         install && \
    \
### Install various Apache::Session Modules    
    cd /usr/src/ && \
    git clone https://github.com/LemonLDAPNG/Apache-Session-LDAP && \
    git clone https://github.com/LemonLDAPNG/Apache-Session-NoSQL && \
    git clone https://github.com/LemonLDAPNG/Apache-Session-Browseable && \
    git clone https://github.com/LemonLDAPNG/apache-session-mongodb && \
    \
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
    \
### Shuffle some Files around
    mkdir -p /assets/lemonldap /assets/conf && \
    cp -R /var/lib/lemonldap-ng/conf/* /assets/conf/ && \
    cp -R /etc/lemonldap-ng/lemonldap-ng.ini /assets/lemonldap && \
    \
### Cleanup
    rm -rf /usr/src/* /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/* && \
    apt-get purge -y libmodule-build-perl mongodb-server && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/log/*

### Networking Configuration
   EXPOSE 80 2884

### Files Setup
   ADD install /
