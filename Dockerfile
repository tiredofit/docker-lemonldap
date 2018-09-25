FROM tiredofit/alpine:3.7
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Environment Variables
ENV LEMONLDAP_VERSION=master \
    AUTHCAS_VERSION=1.7 \
    LASSO_VERSION=2.5.1 \
    DOMAIN_NAME=example.com \
    HANDLER_HOSTNAME=handler.sso.example.com \
    PORTAL_HOSTNAME=sso.example.com \
    MANAGER_HOSTNAME=manager.sso.example.com \
    TEST_HOSTNAME=test.sso.example.com \
    PATH=/usr/share/lemonldap-ng/bin:${PATH}

# Build Dependencies
RUN set -x && \
    apk update && \
    apk add --no-cache --virtual .lemonldap-build-deps \
            autoconf \
            automake \
            build-base \
            coreutils \
            expat-dev \
            g++ \
            gcc \
            go \
            git \
            gd-dev \
            glib-dev \
            gmp-dev \
	    gtk-doc \
            imagemagick6-dev \
            libtool \
            make \
            mongodb \
            nodejs \
            nodejs-npm \
            musl-dev \
            openssl-dev \
            perl-dev \
            py2-pip \
            py-yuicompressor \
            redis \
            wget \
            xmlsec-dev \
            && \
	    \
    apk add --no-cache --virtual .lemonldap-run-deps \
            fail2ban \
            imagemagick6 \
            mariadb-client \
            mongodb-tools \
            nginx \
            openssl \
            perl \
            perl-apache-session \
            perl-authen-sasl \
            perl-cache-cache \
            perl-clone \
            perl-config-inifiles \
            perl-crypt-openssl-bignum \
            perl-crypt-openssl-rsa \
            perl-crypt-rijndael \
            #perl-crypt-x509 \
            perl-dbd-mysql \
            perl-dbd-sqlite \
            perl-dbi \
            #perl-digest-hmac \
            perl-cgi-emulate-psgi \
            perl-fcgi \
            perl-fcgi-procmanager \
            perl-glib \
            perl-html-template \
            perl-io \
            perl-io-socket-ssl \
            perl-json \
            perl-ldap \
            perl-log-log4perl \
            perl-mime-lite \
            perl-mime-tools \
            perl-net-cidr \
            perl-net-cidr-lite \
            perl-net-ssleay \
            perl-plack \
            perl-regexp-common \
            perl-test-mockobject \
            perl-test-pod \
            perl-unicode-string \
            perl-uri \
            perl-utils \
            perl-xml-libxml \
            perl-xml-libxml-simple \
            perl-xml-libxslt \
            rsyslog \
            xmlsec \
            && \
            \
### Install Perl Modules Manually not available in Repository
      ln -s /usr/bin/perl /usr/local/bin/perl && \
      curl -L http://cpanmin.us -o /usr/bin/cpanm && \
      chmod +x /usr/bin/cpanm && \
      cpanm -n \
          CGI::Compile \
          Convert::PEM \
          Crypt::OpenSSL::X509 \
          Digest::HMAC_SHA1 \
          Digest::MD5 \
          Digest::SHA \
          Email::Sender \
          GD::SecurityImage \
          HTTP::Headers \
          HTTP::Request \
          IO::String \
          Image::Magick \
          LWP::UserAgent \
          LWP::Protocol::https \
          Mouse \
          MongoDB \
          Net::CIDR \
          Net::LDAP \
          Net::OAuth \
          Net::OpenID::Common \
          Net::OpenID::Consumer \
          Net::OpenID::Server \
          Regexp::Assemble \
          Redis \
          SOAP::Lite \
          String::Random \
          URI::Escape \
	  XML::SAX \
          && \
          \
### Install various GO, NodeJS Packages for Optimization and adjust temporary symlinks
    cd /usr/src && \
    npm install coffeescript && \
    go get github.com/tdewolff/minify/cmd/minify && \
    ln -s /usr/src/.node_modules/coffeescript/bin/coffee /usr/bin/ && \
    ln -s /usr/bin/yuicompressor /usr/bin/yui-compressor && \
    ln -s /root/go/minify /usr/bin/ && \

### Install Lasso
    git clone -b master https://git.entrouvert.org/lasso.git /usr/src/lasso && \
    cd /usr/src/lasso && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make check && \
    make install && \

### Install AuthCAS
    mkdir -p /usr/src/authcas && \
    curl https://sourcesup.renater.fr/frs/download.php/file/5125/AuthCAS-${AUTHCAS_VERSION}tar.gz | tar xvfz - --strip 1 -C /usr/src/authcas && \
    cd /usr/src/authcas && \
    perl Makefile.PL && \
    make && \
    make install && \

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
         APACHEUSER=nginx \
         APACHEGROUP=nginx \
         FASTCGISOCKDIR=/var/run/llng-fastcgi-server \
         PROD=yes \
         install && \

### Compile Various Apache::Session Modules
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
    perl Makefile.PL && \
    make && \
    make test && \
    make install && \

# Shuffle some Files around
    mkdir -p /assets/lemonldap /assets/conf && \
    cp -R /var/lib/lemonldap-ng/conf/* /assets/conf/ && \
    cp -R /etc/lemonldap-ng/lemonldap-ng.ini /assets/lemonldap && \
    ln -s /usr/share/lemonldap-ng/portal/static/bwr/jquery-ui/jquery-ui.* /usr/share/lemonldap-ng/doc/pages/documentation/current/lib/scripts/ && \
    ln -s /usr/share/lemonldap-ng/manager/static/bwr/jquery/dist/jquery.* /usr/share/lemonldap-ng/doc/pages/documentation/current/lib/scripts/jquery/ && \
    rm -rf /etc/nginx/conf.d && \

# Cleanup
    rm -rf /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/* && \
    rm -rf /root/.cpanm /root/.cache /root/.npm /root/.config /root/.bash_history /root/go && \
    rm -rf /usr/src/* && \
    rm -rf /usr/bin/yui-compressor /usr/bin/coffee /usr/bin/minify && \
    apk del .lemonldap-build-deps && \
    rm -rf /tmp/* /var/cache/apk/* 

### Networking Setup
EXPOSE 80 2884

### Add Files and Assets
ADD install /
