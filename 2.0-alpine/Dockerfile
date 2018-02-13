FROM tiredofit/alpine:edge
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

ARG AUTHCAS_VERSION=1.7 
ARG LASSO_VERSION=2.5.1 

# Build Dependencies
RUN echo 'http://dl-4.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache --virtual build-deps \
            coreutils \
            build-base \
            make \
            subversion \
            wget \
            gcc \
            g++ \
            git \
            expat-dev \
            gd-dev \
            glib-dev \
            gmp-dev \
            xmlsec-dev \
            libxml2-dev \
            libtool \
            libxslt-dev \
            perl-dev \
            #php5-dev \
            #python-dev \
            mysql-dev \
            musl-dev \
            py2-pip \
            && \
	
    apk add --no-cache --virtual run-deps \
            libressl \
            nginx \
            perl \
            perl-apache-session \
            perl-authen-sasl \
            perl-cache-cache \
            perl-clone \
            perl-config-inifiles \
            perl-crypt-rijndael \
            perl-crypt-openssl-bignum \
            perl-crypt-openssl-rsa \
            perl-crypt-x509 \
            perl-dbd-mysql \
            perl-dbd-sqlite \
            perl-dbi \
            perl-digest-hmac \
            perl-fcgi \
            perl-fcgi-procmanager \
            perl-glib \
            perl-html-template \ 
            perl-io \
            perl-io-socket-ssl \
            perl-io-stringy \
            perl-json \
            perl-mime-lite \
            perl-mime-tools \
            perl-net-cidr \
            perl-net-cidr-lite \
            perl-net-ssleay \
            perl-ldap \
            perl-plack \
            perl-regexp-common \
            perl-soap-lite \
            perl-string-random \
            perl-test-mockobject \
            perl-test-pod \
            perl-unicode-string \
            perl-uri \
            perl-utils \
            perl-xml-libxml \
            perl-xml-libxml-simple \
            perl-xml-libxslt \
            #php5-cli \
            xmlsec

  RUN ln -s /usr/bin/perl /usr/local/bin/perl && \
      curl -L http://cpanmin.us -o /usr/bin/cpanm && \
      chmod +x /usr/bin/cpanm && \
      cpanm -n \
#          Apache::Session \#          Authen::SASL \#          Cache::Cache \#          Clone \#          Config::IniFiles \
          Convert::PEM \
#          Crypt::OpenSSL::Bignum \#          Crypt::OpenSSL::RSA \#          Crypt::OpenSSL::X509 \#          DBD::mysql \#          DBD::SQLite \#          DBI \#          Digest::HMAC \
          Email::Sender \
#          FCGI \#          FCGI::ProcManager \          GD::SecurityImage \
#          Glib \#         HTML::Template \#          IO \#          IO::Socket::SSL \#          IO::String \#          JSON \
          LWP \
#          MIME::Lite \#          MIME::Tools \
          Mouse \
          Net::CIDR \
#          Net::CIDR::Lite \
          Net::LDAP \
          Net::OAuth \
          Net::OpenID::Common \
          Net::OpenID::Consumer \
          Net::OpenID::Server \
#          Net::SSLeay \#          Plack \#          Regexp::Common \
          SOAP::Lite \
#          String::Random \#          Test::MockObject \
          Test::Object
#          Test::Pod \#          Unicode::String \#          URI \
#          XML::XSLT \
#          XML::LibXML::Simple
         
RUN  rm -rf /root/.cpanm 

### Install Lasso
RUN mkdir -p /usr/src/lasso && \
    curl https://dev.entrouvert.org/releases/lasso/lasso-${LASSO_VERSION}.tar.gz | tar xvfz - --strip 1 -C /usr/src/lasso && \
    pip install six && \
    cd /usr/src/lasso && \
    ## xmlsec/soap.h replacement - https://dev.entrouvert.org/issues/18771
    curl -o soap.patch https://dev.entrouvert.org/attachments/download/19731/0001-replace-use-of-xmlsec-soap.h-which-is-deprecated-fix.patch && \
    patch -p1 < soap.patch && \
    ./configure && \
    make && \
    make check && \
    make install

### Install AuthCAS
RUN mkdir -p /usr/src/authcas && \
    curl https://sourcesup.renater.fr/frs/download.php/file/5125/AuthCAS-${AUTHCAS_VERSION}tar.gz | tar xvfz - --strip 1 -C /usr/src/authcas && \
    cd /usr/src/authcas && \
    perl Makefile.PL && \
    make && \
    make test && \
    make install


### Checkout LemonLDAP
RUN apk add git && \
    mkdir -p /usr/src/lemonldap-ng && \
    git clone https://gitlab.ow2.org/lemonldap-ng/lemonldap-ng /usr/src/lemonldap-ng

RUN cd /usr/src/lemonldap-ng && \
    make dist && \
    make install


### Nginx Setup
RUN  sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/www:\/bin\/bash/g" /etc/passwd && \
     sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/www:\/bin\/bash/g" /etc/passwd- 

### Environment Variables
ENV PORTAL_HOSTNAME=sso.example.com \
    MANAGER_HOSTNAME=manager.sso.example.com \
    RELOAD_HOSTNAME=reload.sso.example.com

RUN cd /usr/local/lemonldap-ng/etc && \
    rm -rf cron.d default init.d

RUN cp -R /usr/local/lemonldap-ng/etc /usr/local/lemonldap-ng/etc2

ADD install /

### Networking Setup
EXPOSE 80 443
