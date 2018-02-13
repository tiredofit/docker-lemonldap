# tiredofit/lemonldap

# Introduction

This will build a container for [LemonLDAP::NG](https://lemonldap-ng.org/) a web based manager for Authentication (SAML, OAUTH, CAS) 

* This Container uses a [customized Debian Linux base](https://hub.docker.com/r/tiredofit/debian) which includes [s6 overlay](https://github.com/just-containers/s6-overlay) enabled for PID 1 Init capabilities, [zabbix-agent](https://zabbix.org) for individual container monitoring, Cron also installed along with other tools (bash,curl, less, logrotate, nano, vim) for easier management. It also supports sending to external SMTP servers..

## UNDER ACTIVE DEVELOPMENT

[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy](https://github.com/tiredofit)

# Table of Contents

- [Introduction](#introduction)
  | [Changelog](CHANGELOG.md)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
  | [Database](#database)
  | [Data Volumes](#data-volumes)
  | [Environment Variables](#environmentvariables)   
  | [Networking](#networking)
- [Maintenance](#maintenance)
  | [Shell Access](#shell-access)
   - [References](#references)

# Prerequisites

You must have access to create records on your DNS server to be able to setup the demo installation before configuration.


# Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/tiredofit/lemonldap) and is the 
recommended method of installation.


```bash
docker pull tiredofit/lemonldap
```

# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.
* Add records for your main, and manager names into DNS
* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

Once run, visit the Manager URL and login as `dwho/dwho`

# Configuration

### Persistent Storage

To be updated

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/debian),  below is the complete list of available options that can be used to customize your installation.

There are a huge amount of configuration variables and it is recommended that you get comfortable for a few hours with the [LemonLDAP::NG Documentation](https://lemonldap-ng.org/documentation/1.9/start)

| Parameter | Description |
|-----------|-------------|
| `CONFIG_TYPE` | Configuration type (`FILE`, `MYSQL`, `MONGO`, `LDAP`, `SOAP`) - Default `FILE` |
| `DOMAIN_NAME` | Your domain name e.g. `example.org` |
| `MANAGER_HOSTNAME` | FQDN for Manager e.g. `manager.sso.example.org` |
| `PORTAL_HOSTNAME` | FQDN for public portal/main URL e.g. `sso.example.org` |
| `RELOAD_HOSTNAME` | FQDN for Configuration reload URL e.g. `reload.sso.example.org`
| `TEST_HOSTNAME` | FQDN for test URL to prove that LemonLDAP works e.g. `test.sso.example.org`
| `PASSWORD_REGEXP` | |

#### Database Settings

Depending on what was chosen for the `CONFIG_TYPE` and `CACHE_TYPE`, these Database related variables would be used.

| Parameter | Description |
|-----------|-------------|
| `DB_HOST` | Hostname of Database Server e.g. `db`|
| `DB_PORT` | Port of DB server e.g. `3306` - Defaults to chosen DB type's port |
| `DB_NAME` | Name of Database e.g. `lemonldap` |
| `DB_USER` | Username to access database server e.g. `lemonldap` |
| `DB_PASS` | Password for above user e.g. `password` |

#### LDAP Settings
Depending on what was chosen for the `CONFIG_TYPE` and `CACHE_TYPE`, these LDAP related variables would be used.

| Parameter | Description |
|-----------|-------------|
| `LDAP_HOST` | Hostname of LDAP Server|
| `LDAP_CONF_BASE` | |
| `LDAP_BIND_DN` | Bind Username for LDAP|
| `LDAP_BIND_PASS` | Password for above username |
| `LDAP_OBJECT_CLASS` | |
| `LDAP_ATTRIBUTE_ID` | |
| `LDAP_ATTRIBUTE_CONTENT` | |
| `LDAP_GROUP_BASE` | |
| `LDAP_GROUP_OBJECT_CLASS` | |
| `LDAP_GROUP_ATTRIBUTE_NAME` | |
| `LDAP_GROUP_ATTRIBUTE_NAME_USER` | |
| `LDAP_GROUP_ATTRIBUTE_NAME_SEARCH` | |

#### SMTP Settings

| Parameter | Description |
|-----------|-------------|
| `SMTP_HOST` | Hostname of SMTP Server |
| `SMTP_USER` | |
| `SMTP_PASS` | |
| `SMTP_MAIL_FROM` | |
| `SMTP_MAIL_REPLY_TO` | |
| `SMTP_MAIL_URL` | |
| `SMTP_CONFIRM_SUBJECT` | |
| `SMTP_CONFIRM_BODY` | |
| `SMTP_MAIL_SUBJECT` | |
| `SMTP_MAIL_BODY` | |
| `SMTP_MAIL_LDAP_FILTER` | |



### Portal Settings
| Parameter | Description |
|-----------|-------------|
| `PORTAL_LOCAL_CONF` | Default: `FALSE` |               
| `PORTAL_SKIN` | Default: `pastel` |
| `PORTAL_USER_ATTRIBUTE` | Default: `mail` |
| `PORTAL_EXPORTED_ATTRIBUTES` | Default: `uid mail` |
| `PORTAL_LDAP_PPOLICY_CONTROL` | 
| `PORTAL_STORE_PASSWORD_IN_SESSION` | 
| `PORTAL_LDAP_SET_PASSWORD` | 


### Handler Settings
| Parameter | Description |
|-----------|-------------|
| `CACHE_TYPE` | Session Cache type (`FILE` only available for now) - Default `FILE` |
| `CACHE_TYPE_FILE_NAMESPACE` | Default: `lemonldap-ng-config` |
| `CACHE_TYPE_FILE_EXPIRY` | Default: `600` |
| `CACHE_TYPE_FILE_DIR_MASK` | Default: `007` |
| `CACHE_TYPE_FILE_PATH` | Default: `/tmp` |
| `CACHE_TYPE_FILE_DEPTH` | Default: `0` |
| `HANDLER_CACHE_TYPE` | Default: `FILE` |
| `HANDLER_CACHE_TYPE_FILE_NAMESPACE` | Default: `lemonldap-ng-sessions` |
| `HANDLER_CACHE_TYPE_FILE_EXPIRY` | Default: `600` |
| `HANDLER_CACHE_TYPE_FILE_DIR_MASK` | Default: `007` |
| `HANDLER_CACHE_TYPE_FILE_PATH` | Default: `/tmp` |
| `HANDLER_CACHE_TYPE_FILE_DEPTH` | Default: `3` |
| `HANDLER_STATUS` | Default: `FALSE` |
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


# Maintenance
#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. lemonldap) bash
```

# References

* https://lemonldap-ng.org

