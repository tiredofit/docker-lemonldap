FROM tiredofit/debian:jessie
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Environment Variables
   ENV PORTAL_HOSTNAME=sso.example.com \
       MANAGER_HOSTNAME=manager.sso.example.com \
       RELOAD_HOSTNAME=reload.sso.example.com \
       TEST_HOSTNAME=test.sso.example.com \
       DOMAIN_NAME=example.com

# Update system
   RUN apt-get -y update && \
       apt-get -y dist-upgrade && \

# Install LemonLDAP::NG repo
       apt-get -y install apt-transport-https && \
       curl https://lemonldap-ng.org/_media/rpm-gpg-key-ow2 | apt-key add - && \
       echo "deb https://lemonldap-ng.org/deb stable main" > /etc/apt/sources.list.d/lemonldap-ng.list && \
       echo "deb-src https://lemonldap-ng.org/deb stable main" >> /etc/apt/sources.list.d/lemonldap-ng.list && \

# Install LemonLDAP::NG packages
       apt-get -y update && \
       apt-get install -y \
               lemonldap-ng \
               lemonldap-ng-fastcgi-server \
               libauthcas-perl \
               libauthen-captcha-perl \
               liblasso-perl \
               mariadb-client \
               mongodb-clients \
               && \
               
       rm -rf /var/lib/apt/lists/* && \
       cp -R /etc/lemonldap-ng/nginx-lmlog.conf /etc/nginx/conf.d/ && \
       rm -rf /etc/lemonldap-ng/for_etc_hosts /etc/lemonldap-ng/*.conf

### Add Files
   ADD install /

### Networking Setup
   EXPOSE 80

### Entrypoint Setup
   ENTRYPOINT ["/init"]
