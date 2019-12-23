FROM tiredofit/nginx:alpine-3.11
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

ENV LEMONLDAP_VERSION=2.0.7 \
    AUTHCAS_VERSION=1.7 \
    LASSO_VERSION=2.6.0 \
    LIBU2F_VERSION=1.1.0 \
    MINIFY_VERSION=2.3.6 \
    DOMAIN_NAME=example.com \
    HANDLER_HOSTNAME=handler.sso.example.com \
    PORTAL_HOSTNAME=sso.example.com \
    MANAGER_HOSTNAME=manager.sso.example.com \
    TEST_HOSTNAME=test.sso.example.com \
    NGINX_APPLICATION_CONFIGURATION=FALSE \
    NGINX_AUTHENTICATION_TYPE=NONE \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_USER=llng \
    NGINX_GROUP=llng \
    NGINX_LOG_ACCESS_LOCATION=/www/logs/http \
    NGINX_LOG_ACCESS_FILE=access.log \
    NGINX_LOG_ERROR_FILE=error.log \
    NGINX_LOG_ERROR_LOCATION=/www/logs/http \
    PATH=/usr/share/lemonldap-ng/bin:${PATH}

RUN set -x && \
# Create User
    addgroup -g 2884 llng && \
    adduser -S -D -G llng -u 2884 -h /var/lib/lemonldap-ng/ llng && \
    \
# Build Dependencies
    apk update && \
    apk upgrade && \
    apk add --no-cache --virtual .lemonldap-build-deps \
            autoconf \
            automake \
            build-base \
            check-dev \
            coreutils \
            expat-dev \
            g++ \
            gcc \
            go \
            git \
            gd-dev \
            gengetopt-dev \
            glib-dev \
            gmp-dev \
            gtk-doc \
            help2man \
            imagemagick6-dev \
            json-c-dev \
            openssl-dev \
            libtool \
            krb5-dev \
            make \
            nodejs \
            nodejs-npm \
            musl-dev \
            perl-dev \
            py2-pip \
            py-six \
            py-yuicompressor \
            redis \
            wget \
            xmlsec-dev \
            && \
	    \
    apk add --no-cache --virtual .lemonldap-run-deps \
            fail2ban \
            gd \
            imagemagick6 \
            imagemagick6-libs \
            krb5-libs \
            mariadb-client \
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
            perl-crypt-x509 \
            perl-dbd-mysql \
            perl-dbd-sqlite \
            perl-dbi \
            perl-digest-md5 \
            perl-digest-sha1 \
            perl-cgi-emulate-psgi \
            perl-fcgi \
            perl-fcgi-procmanager \
            perl-glib \
            perl-html-template \
            perl-io \
            perl-io-socket-ssl \
            perl-io-string \
            perl-json \
            perl-ldap \
            perl-log-log4perl \
            perl-lwp-protocol-https \
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
            perl-xml-sax \
            rsyslog \
            xmlsec \
            && \
            \
### Compile libu2f-server for 2FA Support
       mkdir -p /usr/src/libu2f && \
       curl -ssL https://developers.yubico.com/libu2f-server/Releases/libu2f-server-$LIBU2F_VERSION.tar.xz | tar xvfJ - --strip 1 -C /usr/src/libu2f && \
       cd /usr/src/libu2f && \
       ./configure \
            --build=$CBUILD \
            --host=$CHOST \
            --prefix=/usr \
            --sysconfdir=/etc \
            --mandir=/usr/share/man \
            --localstatedir=/var \
            --enable-tests && \
       make && \
       make install && \
      \
### Install Perl Modules Manually not available in Repository
      ln -s /usr/bin/perl /usr/local/bin/perl && \
      curl -L http://cpanmin.us -o /usr/bin/cpanm && \
      chmod +x /usr/bin/cpanm && \
      cpanm -n \
          Auth::Yubikey_WebClient \
          Authen::Radius \
          Authen::Captcha \
          CGI::Compile \
          Convert::PEM \
          Convert::Base32 \
          Crypt::U2F::Server::Simple \
          Crypt::URandom \
          Digest::HMAC_SHA1 \
          Digest::SHA \
          Email::Sender \
          GD::SecurityImage \
          GSSAPI \
          HTTP::Headers \
          HTTP::Request \
          Image::Magick \
          LWP::UserAgent \
          Mouse \
#          MongoDB \
          Net::Facebook::Oauth2 \
          Net::LDAP \
          Net::OAuth \
          Net::OpenID::Common \
          Net::SMTP \
          Regexp::Assemble \
          Redis \
          Sentry::Raven \
          SOAP::Lite \
          String::Random \
          Text::Unidecode \
          URI::Escape \
          Web::ID \
    && \
### Install various GO, NodeJS Packages for Optimization and adjust temporary symlinks
    cd /usr/src && \
    npm install coffeescript && \
    mkdir -p /usr/src/minify && \
    curl -sSL https://github.com/tdewolff/minify/releases/download/v${MINIFY_VERSION}/minify_${MINIFY_VERSION}_linux_amd64.tar.gz | tar xvfz - --strip 1 -C /usr/src/minify && \
    mv /usr/src/minify /usr/bin/ && \
    chmod +x /usr/bin/minify && \
    npm install -g uglify-js && \
    ln -s /usr/src/.node_modules/coffeescript/bin/coffee /usr/bin/ && \
    ln -s /usr/bin/yuicompressor /usr/bin/yui-compressor && \
  \
### Install Lasso
    mkdir -p /usr/src/lasso && \
    git clone git://git.entrouvert.org/lasso.git && \
    cd /usr/src/lasso && \
    ./autogen.sh --prefix=/usr --disable-java --disable-python --disable-php5 --disable-tests && \
    make && \
    make check && \
    make install && \
    \
### Install AuthCAS
    mkdir -p /usr/src/authcas && \
    curl https://sourcesup.renater.fr/frs/download.php/file/5125/AuthCAS-${AUTHCAS_VERSION}tar.gz | tar xvfz - --strip 1 -C /usr/src/authcas && \
    cd /usr/src/authcas && \
    perl Makefile.PL && \
    make && \
    make install && \
    \
### Checkout and Install LemonLDAP
    mkdir -p /usr/src/lemonldap-ng && \
    git clone https://gitlab.ow2.org/lemonldap-ng/lemonldap-ng /usr/src/lemonldap-ng && \
    cd /usr/src/lemonldap-ng && \
    if [ "$LEMONLDAP_VERSION" != "master" ] ; then git checkout v$LEMONLDAP_VERSION; fi && \
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
         APACHEUSER=llng \
         APACHEGROUP=llng \
         FASTCGISOCKDIR=/var/run/llng-fastcgi-server \
         PROD=yes \
         install && \
    \
### Compile Various Apache::Session Modules
    cd /usr/src/ && \
    git clone https://github.com/LemonLDAPNG/Apache-Session-LDAP && \
    git clone https://github.com/LemonLDAPNG/Apache-Session-NoSQL && \
    git clone https://github.com/LemonLDAPNG/Apache-Session-Browseable && \
#    git clone https://github.com/LemonLDAPNG/apache-session-mongodb && \
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
#    cd /usr/src/apache-session-mongodb && \
#    perl Makefile.PL && \
#    make && \
#    make test && \
#    make install && \
    \
# Shuffle some Files around
    mkdir -p /assets/lemonldap /assets/conf && \
    cp -R /var/lib/lemonldap-ng/conf/* /assets/conf/ && \
    cp -R /etc/lemonldap-ng/lemonldap-ng.ini /assets/lemonldap && \
    ln -s /usr/share/lemonldap-ng/portal/static/bwr/jquery-ui/jquery-ui.* /usr/share/lemonldap-ng/doc/pages/documentation/current/lib/scripts/ && \
    ln -s /usr/share/lemonldap-ng/manager/static/bwr/jquery/dist/jquery.* /usr/share/lemonldap-ng/doc/pages/documentation/current/lib/scripts/jquery/ && \
    rm -rf /etc/nginx/conf.d && \
    \
# Cleanup
    rm -rf /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/* && \
    rm -rf /root/.cpanm /root/.cache /root/.npm /root/.config /root/.bash_history /root/go && \
    rm -rf /usr/src/* && \
    rm -rf /usr/bin/yui-compressor /usr/bin/coffee /usr/bin/minify && \
    apk del .lemonldap-build-deps && \
#    apk del mongodb && \
#    deluser mongodb && \
    deluser nginx && \
    deluser redis && \
    rm -rf /tmp/* /var/cache/apk/* 

### Networking Setup
EXPOSE 80 2884

### Add Files and Assets
ADD install /
