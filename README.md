# github.com/tiredofit/docker-lemonldap

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-lemonldap?style=flat-square)](https://github.com/tiredofit/docker-lemonldap/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-lemonldapmain.yml?branch=main&style=flat-square)](https://github.com/tiredofit/docker-lemonldap.git/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/lemonldap.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/lemonldap/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/lemonldap.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/lemonldap/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *
## About

This will build a Docker Image [LemonLDAP::NG](https://lemonldap-ng.org/) an elegant web based manager for Authentication (SAML, OpenID Connect, CAS) served by Nginx.

* Sane defaults to have a working solution by just running the image
* Automatically generates configuration files on startup, or option to use your own
* Option to just use image as a Handler for external servers
* Handler Option to use file base socket or listen on TCP
* Fail2ban Included for blocking brute force attacks.
* Ready to work out the box for SAML, OpenID, 2FA/2OTP
* Additional modules compiled for Redis, Mysql, Postgres, LDAP Session/Config Storage
* Choice of Logging (Console, File, Syslog)

*This is an incredibly complex piece of software and this image tries to get you up and running with sane defaults, you will need to switch eventually over to manually configuring the configuration file when depending on your usage case*

## Maintainer

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [REST Settings](#rest-settings)
    - [Portal Settings](#portal-settings)
    - [Handler Settings](#handler-settings)
    - [Manager Options](#manager-options)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)

## Prerequisites and Assumptions
*  Assumes you are using some sort of SSL terminating reverse proxy such as:
   *  [Traefik](https://github.com/tiredofit/docker-traefik)
   *  [Nginx](https://github.com/jc21/nginx-proxy-manager)
   *  [Caddy](https://github.com/caddyserver/caddy)
* You must have access to create records on your DNS server to be able to setup the demo installation before configuration.


## Installation

### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/lemonldap)

```bash
docker pull docker.io/tiredofdit/lemonldap:(imagetag)
```

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/docker-lemonldap/pkgs/container/docker-lemonldap) 
 
```
docker pull ghcr.io/tiredofit/docker-lemonldap:(imagetag)
``` 

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Version | Container OS | Tag          |
| ------- | ------------ | ------------ |
| latest  | Alpine       | `:latest`    |
| 2.0.x   | Alpine       | `2.0-latest` |


## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.
* If you'd like to just use it in Handler mode, you will find another sample docker-compose.yml file that should get you started.
* Add records for your main, and manager names into DNS (ie `handler.sso.example.com`. `api.manager.sso.example.com`, `manager.sso.example.com`, `sso.example.com`, `test.sso.example.com`)
* Set various [environment variables](#environment-variables) to understand the capabilities of this image. A Sample `docker-compose.yml` is provided that will work right out of the box for most people without any fancy optimizations.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
* Once run, visit the Manager URL and login as `dwho/dwho`

### Persistent Storage

The following directories should be mapped for persistent storage in order to utilize the container effectively.

| Folder                            | Description                                                                          |
| --------------------------------- | ------------------------------------------------------------------------------------ |
| `/etc/lemonldap-ng/`              | (Optional) - LemonLDAP core configuration files. Auto Generates on Container startup |
| `/var/lib/lemonldap-ng/conf`      | Actual Configuration of LemonLDAP (lmConf-X.js files)                                |
| `/var/lib/lemonldap-ng/sessions`  | (Optional) - Storage of Sessions of users                                            |
| `/var/lib/lemonldap-ng/psessions` | (Optional) - Storage of Sessions of users                                            |
| `/assets/custom`                  | Ability to overwrite themes/inject into image upon bootup for theming /etc.          |
| `/www/logs`                       | Log files for individual services                                                    |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`, `nano`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |
| [Nginx](https://github.com/tiredofit/docker-nginx/)    | Nginx webserver                        |


There are a huge amount of configuration variables and it is recommended that you get comfortable for a few hours with the [LemonLDAP::NG Documentation](https://lemonldap-ng.org/documentation/2.0/start)

You will eventually based on your usage case switch over to `SETUP_TYPE=MANUAL` and edit your own `lemonldap-ng.ini`. While I've tried to make this as easy to use as possible, once in production you'll find much better success with large implementations with this approach.

By Default this image is ready to run out of the box, without having to alter any of the settings with the exception of the `_HOSTNAME` vars. You can also change the majority of these settings from within the Manager. There are instances where these variables would want to be set if you are running multiple handlers or need to enforce a Global Setting for one specific installation.

| Parameter          | Description                                                                                    | Default               |
| ------------------ | ---------------------------------------------------------------------------------------------- | --------------------- |
| `SETUP_TYPE`       | `AUTO` to auto generate lemonldap-ng.ini on bootup, otherwise let admin control configuration. | `AUTO`                |
| `MODE`             | Type of Install - `HANDLER` for handler duties only, `MASTER` for Portal, Manager, Handler     | `MASTER`              |
|                    | Or any combo of `API`, `HANDLER`, `MANAGER`, `PORTAL`, `TEST`                                  |                       |
| `CONFIG_TYPE`      | Configuration type (`FILE`, `REST`) -                                                          | `FILE`                |
| `DOMAIN_NAME`      | Your domain name e.g. `example.org`                                                            |                       |
| `API_HOSTNAME`     | FQDN for Manager API e.g. `api.manager.sso.example.org`                                        |                       |
| `MANAGER_HOSTNAME` | FQDN for Manager e.g. `manager.sso.example.org`                                                |                       |
| `PORTAL_HOSTNAME`  | FQDN for public portal/main URL e.g. `sso.example.org`                                         |                       |
| `HANDLER_HOSTNAME` | FQDN for Configuration reload URL e.g. `handler.sso.example.org`                               |                       |
| `TEST_HOSTNAME`    | FQDN for test URL to prove that LemonLDAP works e.g. `test.sso.example.org`                    |                       |
| `LOG_FILE`         | LL:NG main log file                                                                            | `lemonldap.log`       |
| `LOG_FILE_USER`    | LL:NG User log file                                                                            | `lemonldap-user.log`  |
| `LOG_PATH`         | Log Path                                                                                       | `/www/logs/lemonldap` |
| `LOG_TYPE`         | How to Log - Options `CONSOLE` or `FILE`                                                       | `CONSOLE`             |
| `LOG_LEVEL`        | LogLevel - Options `warn, notice, info, error, debug`                                          | `info`                |
| `USER_LOG_TYPE`    | How to Log User actions - Options `CONSOLE, FILE, SYSLOG`                                      | `CONSOLE`             |

#### REST Settings

Depending if `REST` was chosen for `CONFIG_TYPE`, these variables would be used.

| Parameter   | Description                                                                      | Default |
| ----------- | -------------------------------------------------------------------------------- | ------- |
| `REST_HOST` | Hostname of Master REST Server e.g. `https://sso.example.com/index.psgi/config/` |         |
| `REST_USER` | Username to fetch Configuration Information                                      |         |
| `REST_PASS` | Password to fetch Configuration Information                                      |         |

#### Portal Settings
| Parameter                 | Description                                                                          | Default                                    |
| ------------------------- | ------------------------------------------------------------------------------------ | ------------------------------------------ |
| `PORTAL_CACHE_TYPE`       | Only Cache Type available for now -                                                  | `FILE`                                     |
| `PORTAL_TEMPLATE_DIR`     |                                                                                      | `/usr/share/lemonldap-ng/portal/templates` |
| `PORTAL_LOG_TYPE`         | Override Portal Log - Options `CONSOLE` or `FILE`                                    | `CONSOLE`                                  |
| `PORTAL_LOG_LEVEL`        | Override Portal LogLevel - Options `warn, notice, info, error, debug`                | `info`                                     |
| `PORTAL_USER_LOG_TYPE`    | Override Portal Log User actions - Options `CONSOLE` or `FILE`                       | `CONSOLE`                                  |
| `PORTAL_ENABLE_REST`      | Allow REST access to the Portal -                                                    | `FALSE`                                    |
| `PORTAL_REST_ALLOWED_IPs` | If above options enabled, provide comma seperated list of IP/Network to allow access | `0.0.0.0/0`                                |
| `ENABLE_IMPERSONATION`    | If you wish to allow impersonation using a seperate theme set to `TRUE`              | `FALSE`                                    |
| `IMPERSONATE_HOSTNAME`    | Hostname to use to load the custom impersonation theme                               |                                            |
| `IMPERSONATE_THEME`       | Theme to use to load the impersonation theme                                         |                                            |

- With impersonation, if you enable it, it will add a new field to your login screen, which may not be what you want if this is a production system. You will need to create two custom themes (one as a replica of bootstrap, and one for impersonation). In the custom theme, make modifications to `login.tpl` to stop it from loading impersonation.tpl, yet in your impersonation theme, leave it in there. Then, when one of your admin/support team visits the custom `IMPERSONATE_HOSTNAME` you have defined it will load the full theme with allows to impersonate, where as the default theme will not show this.

#### Handler Settings
| Parameter                           | Description                                                                                                                                            | Default                 |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------- |
| `CACHE_TYPE`                        | Session Cache type (`FILE` only available for now) -                                                                                                   | `FILE`                  |
| `CACHE_TYPE_FILE_NAMESPACE`         |                                                                                                                                                        | `lemonldap-ng-config`   |
| `CACHE_TYPE_FILE_EXPIRY`            |                                                                                                                                                        | `600`                   |
| `CACHE_TYPE_FILE_DIR_MASK`          |                                                                                                                                                        | `007`                   |
| `CACHE_TYPE_FILE_PATH`              |                                                                                                                                                        | `/tmp`                  |
| `CACHE_TYPE_FILE_DEPTH`             |                                                                                                                                                        | `0`                     |
| `HANDLER_ALLOWED_IPS`               | If you need to access access to `/reload` other than localhost add a comma seperated list or hosts or networks here e.g. `172.16.0.0/12,192.168.0.253` |
| `HANDLER_CACHE_TYPE`                |                                                                                                                                                        | `FILE`                  |
| `HANDLER_CACHE_TYPE_FILE_NAMESPACE` |                                                                                                                                                        | `lemonldap-ng-sessions` |
| `HANDLER_CACHE_TYPE_FILE_EXPIRY`    |                                                                                                                                                        | `600`                   |
| `HANDLER_CACHE_TYPE_FILE_DIR_MASK`  |                                                                                                                                                        | `007`                   |
| `HANDLER_CACHE_TYPE_FILE_PATH`      |                                                                                                                                                        | `/tmp`                  |
| `HANDLER_CACHE_TYPE_FILE_DEPTH`     |                                                                                                                                                        | `3`                     |
| `HANDLER_SOCKET_TCP_ENABLE`         | Enable TCP Connections to socket instead of /var/run/llng-fastcgi-server/llng-fastcgi.sock -                                                           | `TRUE`                  |
| `HANDLER_SOCKET_TCP_PORT`           | Port to listen on for Handler                                                                                                                          | `2884`                  |
| `HANDLER_STATUS`                    | Allow Status on Handler                                                                                                                                | `TRUE`                  |
| `HANDLER_REDIRECT_ON_ERROR`         |                                                                                                                                                        | `TRUE`                  |
| `HANDLER_LOG_TYPE`                  | Override Handler Log - Options `CONSOLE, FILE, SYSLOG`                                                                                                 | `CONSOLE`               |
| `HANDLER_LOG_LEVEL`                 | Override Handler LogLevel - Options `warn, notice, info, error, debug`                                                                                 | `info`                  |
| `HANDLER_PROCESSES`                 | Amount of LLNG Handler processes to spawn                                                                                                              | `7`                     |
| `HANDLER_USER_LOG_TYPE`             | Override Handler Log User actions - Options `CONSOLE` or `FILE`                                                                                        | `CONSOLE`               |

#### Manager Options
| Parameter                 | Description                                                                                                                                      | Default                                     |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------- |
| `MANAGER_PROTECTION`      |                                                                                                                                                  | `manager`                                   |
| `MANAGER_LOG_LEVEL`       |                                                                                                                                                  | `warn`                                      |
| `MANAGER_STATIC_PREFIX`   |                                                                                                                                                  | `/static`                                   |
| `MANAGER_TEMPLATE_DIR`    |                                                                                                                                                  | `/usr/share/lemonldap-ng/manager/templates` |
| `MANAGER_LANGUAGE`        |                                                                                                                                                  | `en`                                        |
| `MANAGER_ENABLE_API`      | Enable Manager API -                                                                                                                             | `FALSE`                                     |
| `MANAGER_ALLOWED_IPS`     | If you need to access access to API other than localhost add a comma seperated list or hosts or networks here e.g. `172.16.0.0/12,192.168.0.253` |
| `MANAGER_ENABLED_MODULES` |                                                                                                                                                  | `"conf, sessions, notifications"`           |
| `MANAGER_LOG_TYPE`        | Override Manager Log - Options `CONSOLE` or `FILE`                                                                                               | `CONSOLE`                                   |
| `MANAGER_LOG_LEVEL`       | Override Manager LogLevel - Options `warn, notice, info, error, debug`                                                                           | `info`                                      |
| `MANAGER_USER_LOG_TYPE`   | Override Manager Log User actions - Options `CONSOLE` or `FILE`                                                                                  | `CONSOLE`                                   |


### Networking

The following ports are exposed.

| Port   | Description  |
| ------ | ------------ |
| `80`   | HTTP         |
| `2884` | LLNG Handler |

* * *
## Maintenance

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

``bash
docker exec -it (whatever your container name is) bash
``
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for personalized support
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.
## References

* https://lemonldap-ng.org
