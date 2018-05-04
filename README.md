# tiredofit/lemonldap

[![Build Status](https://img.shields.io/docker/build/tiredofit/lemonldap.svg)](https://hub.docker.com/r/tiredofit/lemonldap)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/lemonldap.svg)](https://hub.docker.com/r/tiredofit/lemonldap)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/lemonldap.svg)](https://hub.docker.com/r/tiredofit/lemonldap)
[![Docker 
Layers](https://images.microbadger.com/badges/image/tiredofit/lemonldap.svg)](https://microbadger.com/images/tiredofit/lemonldap)


# Introduction

This will build a container for [LemonLDAP::NG](https://lemonldap-ng.org/) a web based manager for Authentication (SAML, OPENID Connect, CAS) using Nginx

* This Container uses a [customized Debian Linux base](https://hub.docker.com/r/tiredofit/debian) which includes [s6 overlay](https://github.com/just-containers/s6-overlay) enabled for PID 1 Init capabilities, [zabbix-agent](https://zabbix.org) for individual container monitoring, Cron also installed along with other tools (bash,curl, less, logrotate, nano, vim) for easier management. It also supports sending to external SMTP servers..

* Fail2ban Included for blocking brute force attacks.

[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy](https://github.com/tiredofit)

# Table of Contents

- [Introduction](#introduction)
    - [Changelog](CHANGELOG.md)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Database](#database)
    - [Data Volumes](#data-volumes)
    - [Environment Variables](#environmentvariables)   
    - [Networking](#networking)
- [Maintenance](#maintenance)
    - [Shell Access](#shell-access)
   - [References](#references)

# Prerequisites

You must have access to create records on your DNS server to be able to setup the demo installation before configuration.


# Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/tiredofit/lemonldap) and is the 
recommended method of installation.


```bash
docker pull tiredofit/lemonldap
```

The following image tags are available:

* `latest` - LemonLDAP 1.9.x Branch w/ Debian Stretch
* `1.9-latest` - LemonLDAP 1.9.x Branch w/ Debian Stretch
* `1.9-alpine-latest` - LemonLDAP 1.9.x Branch w/ Alpine Linux
* `2.0-latest` - LemonLDAP 2.0 Development Branch w/ Debian Stretch
* `2.0-alpine-latest` - LemonLDAP 2.0 Development Branch w/Alpine Linux (not working)


# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Add records for your main, and manager names into DNS (ie `handler.sso.example.com`. `manager.sso.example.com`, `sso.example.com`, `test.sso.example.com`)

* Set various [environment variables](#environment-variables) to understand the capabilities of this image. A Sample `docker-compose.yml` is provided that will work right out of the box for most people without any fancy optimizations.

* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

Once run, visit the Manager URL and login as `dwho/dwho`

# Configuration

### Persistent Storage

The following directories should be mapped for persistent storage in order to utilize the container effectively.

| Folder    | Description |
|-----------|-------------|
| `/etc/lemonldap-ng/` | (Optional) - LemonLDAP core configuration files. Auto Generates on Container startup |
| `/var/lib/lemonldap-ng/conf` | Actual Configuration of LemonLDAP (lmConf-X.js files) |
| `/var/lib/lemonldap-ng/sessions` | (Optional) - Storage of Sessions of users
| `/assets/custom` | Ability to overwrite themes/inject into image upon bootup for theming /etc.
| `/www/logs` | Log files for individual services

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/debian),  below is the complete list of available options that can be used to customize your installation.

There are a huge amount of configuration variables and it is recommended that you get comfortable for a few hours with the [LemonLDAP::NG Documentation](https://lemonldap-ng.org/documentation/1.9/start)

By Default this image is ready to run out of the box, without having to alter any of the settings with the exception of the `_HOSTNAME` vars. You can also change the majority of these settings from within the Manager. There are instances where these variables would want to be set if you are running multiple handlers or need to enforce a Global Setting for one specific installation.

| Parameter | Description |
|-----------|-------------|
| `CONFIG_TYPE` | Configuration type (`FILE`, `MYSQL`, `MONGO`, `LDAP`, `REDIS`, `SOAP`) - Default `FILE` |
| `DOMAIN_NAME` | Your domain name e.g. `example.org` |
| `MANAGER_HOSTNAME` | FQDN for Manager e.g. `manager.sso.example.org` |
| `PORTAL_HOSTNAME` | FQDN for public portal/main URL e.g. `sso.example.org` |
| `HANDLER_HOSTNAME` | FQDN for Configuration reload URL e.g. `reload.sso.example.org` |
| `TEST_HOSTNAME` | FQDN for test URL to prove that LemonLDAP works e.g. `test.sso.example.org` |
| `MODE` | Type of Install - `HANDLER` for handler duties only, Default `MASTER` for Portal, Manager, Handler |
| `PASSWORD_REGEXP` | Setting Password Regular Expression Rules (Currently Unsued)|
| `SETUP_TYPE` | Default: `AUTO` to auto generate lemonldap-ng.ini on bootup, otherwise let admin control configuration.

#### Database Settings

Depending on what was chosen for the `CONFIG_TYPE` and `CACHE_TYPE`, these Database related variables would be used.

| Parameter | Description |
|-----------|-------------|
| `DB_HOST` | Hostname of Database Server e.g. `db`|
| `DB_PORT` | Port of DB server e.g. `3306` - Defaults to chosen DB type's port |
| `DB_NAME` | Name of Database e.g. `lemonldap` |
| `DB_USER` | Username to access database server e.g. `lemonldap` |
| `DB_PASS` | Password for above user e.g. `password` |
| `REDIS_HOST` | Hostname of Redis Server if used `e.g. lemonldap-redis |
| `REDIS_PORT` | Port of Redis Server default: `6379` |

#### LDAP Settings
Depending on what was chosen for the `CONFIG_TYPE` and `CACHE_TYPE`, these LDAP related variables would be used.

| Parameter | Description |
|-----------|-------------|
| `LDAP_HOST` | Hostname of LDAP Server|
| `LDAP_CONF_BASE` | See LemonLDAP Documentation |
| `LDAP_BIND_DN` | Bind Username for LDAP|
| `LDAP_BIND_PASS` | Password for above username |
| `LDAP_OBJECT_CLASS` | See LemonLDAP Documentation |
| `LDAP_ATTRIBUTE_ID` | See LemonLDAP Documentation |
| `LDAP_ATTRIBUTE_CONTENT` | See LemonLDAP Documentation |
| `LDAP_GROUP_BASE` | See LemonLDAP Documentation |
| `LDAP_GROUP_OBJECT_CLASS` | See LemonLDAP Documentation |
| `LDAP_GROUP_ATTRIBUTE_NAME` | See LemonLDAP Documentation |
| `LDAP_GROUP_ATTRIBUTE_NAME_USER` | See LemonLDAP Documentation |
| `LDAP_GROUP_ATTRIBUTE_NAME_SEARCH` | See LemonLDAP Documentation |

#### SOAP Settings

Depending if `SOAP` was chosedn for `CONFIG_TYPE`, these variables would be used.

| Parameter | Description |
|-----------|-------------|
| `SOAP_HOST` | Hostname of Master SOAP Server e.g. `https://sso.example.com/index.pl/config` |
| `SOAP_USER` | Username to fetch Configuration Information |
| `SOAP_PASS` | Password to fetch Configuration Information |

#### SMTP Settings

| Parameter | Description |
|-----------|-------------|
| `SMTP_HOST` | Hostname of SMTP Server |
| `SMTP_USER` | Username to access SMTP Server|
| `SMTP_PASS` | Password to access SMTP Server|
| `SMTP_MAIL_FROM` | From Address for Mail |
| `SMTP_MAIL_REPLY_TO` | Reply To for Mail |
| `SMTP_MAIL_URL` | Mail URL. See LemonLDAP Documentation |
| `SMTP_CONFIRM_SUBJECT` | Subject line for Messages of Confirmated Password Change|
| `SMTP_CONFIRM_BODY` | See LemonLDAP Documentation |
| `SMTP_MAIL_SUBJECT` | Subject Line for Change Password |
| `SMTP_MAIL_BODY` | See LemonLDAP Documentation |
| `SMTP_MAIL_LDAP_FILTER` | See LemonLDAP Documentation |



### Portal Settings
| Parameter | Description |
|-----------|-------------|
| `PORTAL_LOCAL_CONF` | See LemonLDAP Documentation Default: `FALSE` |               
| `PORTAL_SKIN` | Default: `bootstrap` - See LemonLDAP Documentation |
| `PORTAL_USER_ATTRIBUTE` | Default: `mail` See LemonLDAP Documentation |
| `PORTAL_EXPORTED_ATTRIBUTES` | Default: `uid mail` See LemonLDAP Documentation |
| `PORTAL_LDAP_PPOLICY_CONTROL` | See LemonLDAP Documentation | 
| `PORTAL_STORE_PASSWORD_IN_SESSION` | See LemonLDAP Documentation |
| `PORTAL_LDAP_SET_PASSWORD` | See LemonLDAP Documentation |
| `MANAGER_TEMPLATE_DIR` | Default: `/usr/share/lemonldap-ng/portal/templates` |

### Handler Settings
| Parameter | Description |
|-----------|-------------|
| `CACHE_TYPE` | Session Cache type (`FILE` only available for now) - Default `FILE` |
| `CACHE_TYPE_FILE_NAMESPACE` | Default: `lemonldap-ng-config` |
| `CACHE_TYPE_FILE_EXPIRY` | Default: `600` |
| `CACHE_TYPE_FILE_DIR_MASK` | Default: `007` |
| `CACHE_TYPE_FILE_PATH` | Default: `/tmp` |
| `CACHE_TYPE_FILE_DEPTH` | Default: `0` |
| `HANDLER_ALLOWED_IPS` | If you need to access access to `/reload` other than localhost add a comma seperated list or hosts or networks here e.g. `172.16.0.0/12,192.168.0.253` |
| `HANDLER_CACHE_TYPE` | Default: `FILE` |
| `HANDLER_CACHE_TYPE_FILE_NAMESPACE` | Default: `lemonldap-ng-sessions` |
| `HANDLER_CACHE_TYPE_FILE_EXPIRY` | Default: `600` |
| `HANDLER_CACHE_TYPE_FILE_DIR_MASK` | Default: `007` |
| `HANDLER_CACHE_TYPE_FILE_PATH` | Default: `/tmp` |
| `HANDLER_CACHE_TYPE_FILE_DEPTH` | Default: `3` |
| `HANDLER_SOCKET_TCP_ENABLE` | Enable TCP Connections to socket instead of /var/run/llng-fastcgi-server/llng-fastcgi.sock - Default `TRUE` |
| `HANDLER_SOCKET_TCP_PORT` | Port to listen on for Handler Default `2884` |
| `HANDLER_STATUS` | Allow Status on Handler Default: `TRUE` |
| `HANDLER_REDIRECT_ON_ERROR` | Default: `TRUE` |

### Manager Options

| Parameter | Description |
|-----------|-------------|
| `MANAGER_PROTECTION` | Default: `manager` |
| `MANAGER_LOG_LEVEL` | Default: `warn` |
| `MANAGER_STATIC_PREFIX` | Default: `/static` |
| `MANAGER_TEMPLATE_DIR` | Default: `/usr/share/lemonldap-ng/manager/templates` |
| `MANAGER_LANGUAGE` | Default: `en` |
| `MANAGER_ENABLED_MODULES` | Default: `"conf, sessions, notifications"` |


### Networking

The following ports are exposed.

| Port      | Description |
|-----------|-------------|
| `80` | HTTP |
| `2884` | llng-fastcgi-server Handler |

# Maintenance
#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. lemonldap) bash
```

# References

* https://lemonldap-ng.org
