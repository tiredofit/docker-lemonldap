FROM tiredofit/nginx:alpine-3.14
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV LEMONLDAP_VERSION=2.0.12 \
    AUTHCAS_VERSION=1.7 \
    LASSO_VERSION=v2.7.0 \
    LIBU2F_VERSION=master \
    MINIFY_VERSION=2.3.6 \
    DOMAIN_NAME=example.com \
    API_HOSTNAME=api.manager.sso.example.com \
    HANDLER_HOSTNAME=handler.sso.example.com \
    MANAGER_HOSTNAME=manager.sso.example.com \
    PORTAL_HOSTNAME=sso.example.com \
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
            imagemagick-dev \
            json-c-dev \
            openssl-dev \
            libtool \
            krb5-dev \
            make \
            mongo-c-driver-dev \
            nodejs \
            npm \
            musl-dev \
            perl-dev \
            py-pip \
            py-six \
            py3-sphinx \
            redis \
            sphinx \
            wget \
            xmlsec-dev \
            && \
	    \
    apk add --no-cache --virtual .lemonldap-run-deps \
            fail2ban \
            gd \
            ghostscript-fonts \
            imagemagick \
            imagemagick-libs \
            imagemagick-perlmagick \
            krb5-libs \
            mariadb-client \
            mongo-c-driver \
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
            perl-dbd-pg \
            perl-dbi \
            perl-digest-md5 \
            perl-digest-sha1 \
            perl-cgi-emulate-psgi \
            perl-fcgi \
            perl-fcgi-procmanager \
            perl-glib \
            perl-http-headers-fast \
            perl-http-entity-parser \
            perl-html-template \
            perl-io \
            perl-io-socket-ssl \
            perl-io-string \
            perl-json \
            perl-ldap \
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
            postgresql-client \
            rsyslog \
            s6 \
            xmlsec \
            && \
    \
    ### Install Sphinx dependencies for Document Building for Manager
    pip install sphinx_bootstrap_theme && \
    \
    ### Compile libu2f-server for 2FA Support
    mkdir -p /usr/src/libu2f && \
    git clone https://github.com/Yubico/libu2f-server /usr/src/libu2f && \
    cd /usr/src/libu2f && \
    git checkout ${LIBU2F_VERSION} && \
    ./autogen.sh && \
    ./configure \
        --build=$CBUILD \
        --host=$CHOST \
        --prefix=/usr \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --localstatedir=/var \
        --enable-tests && \
    make -j$(nproc) && \
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
        Cookie::Baker \
        Cookie::Baker::XS \
        Crypt::OpenSSL::X509 \
        Crypt::U2F::Server::Simple \
        Crypt::URandom \
        DateTime::Format::RFC3339 \
        Digest::HMAC_SHA1 \
        Digest::SHA \
        Email::Sender \
        GD::SecurityImage \
        GSSAPI \
        HTTP::Headers \
        HTTP::Request \
        LWP::UserAgent \
        Mouse \
        MongoDB \
        Net::Facebook::Oauth2 \
        Net::LDAP \
        Net::OAuth \
        Net::OpenID::Common \
        Net::SMTP \
        Regexp::Assemble \
        Redis \
        Sentry::Raven \
        String::Random \
        Text::Unidecode \
        Time::Fake \
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
    git checkout ${LASSO_VERSION} && \
    ./autogen.sh \
                --prefix=/usr \
                --disable-java \
                --disable-php5 \
                --disable-python \
                --disable-tests && \
    make -j$(nproc) && \
    make check && \
    make install && \
    \
### Install AuthCAS
    mkdir -p /usr/src/authcas && \
    curl https://sourcesup.renater.fr/frs/download.php/file/5125/AuthCAS-${AUTHCAS_VERSION}tar.gz | tar xvfz - --strip 1 -C /usr/src/authcas && \
    cd /usr/src/authcas && \
    perl Makefile.PL && \
    make -j$(nproc) && \
    make install && \
    \
### Checkout and Install LemonLDAP
    mkdir -p /usr/src/lemonldap-ng && \
    git clone https://gitlab.ow2.org/lemonldap-ng/lemonldap-ng /usr/src/lemonldap-ng && \
    cd /usr/src/lemonldap-ng && \
    if [ "$LEMONLDAP_VERSION" != "master" ] ; then git checkout v$LEMONLDAP_VERSION; fi && \
    make dist && \
    make documentation && \
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
    git clone https://github.com/LemonLDAPNG/apache-session-mongodb && \
    \
    cd /usr/src/Apache-Session-NoSQL && \
    perl Makefile.PL && \
    make -j$(nproc) && \
    make test && \
    make install && \
    cd .. && \
    cd /usr/src/Apache-Session-LDAP && \
    perl Makefile.PL && \
    make -j$(nproc) && \
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
    \
    mkdir -p /var/run/llng-fastcgi-server && \
    chown -R llng /var/run/llng-fastcgi-server && \
    \
    # Shuffle some Files around
    mkdir -p /assets/llng/conf && \
    mv /var/lib/lemonldap-ng/conf/* /assets/llng/conf/ && \
    mv /etc/lemonldap-ng/lemonldap-ng.ini /assets/llng/conf/ && \
    mkdir -p /var/run/llng-fastcgi-server && \
    chown -R llng /var/run/llng-fastcgi-server && \
    ln -s /usr/share/lemonldap-ng/doc /usr/share/lemonldap-ng/manager/doc && \
    ln -s /usr/share/lemonldap-ng/portal /usr/share/lemonldap-ng/portal/htdocs && \
    rm -rf /etc/nginx/conf.d/* && \
    \
# Cleanup
    rm -rf /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/* && \
    rm -rf /root/.cpanm /root/.cache /root/.npm /root/.config /root/.bash_history /root/go && \
    rm -rf /usr/src/* && \
    rm -rf /usr/bin/yuicompressor /usr/bin/yui-compressor /usr/bin/coffee /usr/bin/minify && \
    rm -rf /etc/fail2ban/jail.d/* && \
    apk del .lemonldap-build-deps && \
    deluser nginx && \
    deluser redis && \
    rm -rf /tmp/* /var/cache/apk/*

### Networking Setup
EXPOSE 80 2884

### Add Files and Assets
ADD install /
