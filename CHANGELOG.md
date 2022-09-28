## 2.0.35 2022-09-28 <dave at tiredofit dot ca>

   ### Added
      - Introduce seperate logs for impersonation along with logrotation

   ### Changed
      - Fix error on startup with directory permissions


## 2.0.34 2022-09-28 <dave at tiredofit dot ca>

All users of this image are recommended to upgrade to resolve space issues with faulty log rotation.

   ### Added
      - LemonLDAP:NG 2.0.15.1
      - LASSO 2.8.0

   ### Changed
      - Fix Logrotation for individual nginx configurations
      - Cleanup variables as per shellcheck
      - Move around functions


## 2.0.33 2022-09-14 <dave at tiredofit dot ca>

   ### Added
      - LemonLDAP:NG 2.0.15


## 2.0.32 2022-09-14 <dave at tiredofit dot ca>

   ### Added
      - LemonLDAP 2.0.15


## 2.0.31 2022-08-17 <dave at tiredofit dot ca>

   ### Changed
      - Fix for impersonation site enabled nginx configuration
      - Switch to exec statements for launching processes


## 2.0.30 2022-08-11 <dave at tiredofit dot ca>

   ### Changed
      - Bring in nginx defaults
      - Switch to custom_files function


## 2.0.29 2022-08-08 <dave at tiredofit dot ca>

   ### Changed
      - Close open quote


## 2.0.28 2022-08-05 <dave at tiredofit dot ca>

   ### Changed
      - Change the way fail2ban is being used - Rely on base image included features and refactor configuration


## 2.0.27 2022-06-28 <dave at tiredofit dot ca>

   ### Changed
      - Fix for "test" site


## 2.0.26 2022-06-28 <dave at tiredofit dot ca>

   ### Changed
      - Bugfix for 2.0.25 with misspelled folder name


## 2.0.25 2022-06-24 <dave at tiredofit dot ca>

   ### Added
      - Update to support tiredofit/nginx:6.0.0 syntax


## 2.0.24 2022-05-24 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.16 base


## 2.0.23 2022-04-05 <dave at tiredofit dot ca>

   ### Added
      - LaSSO 2.8.0


## 2.0.22 2022-03-22 <dave at tiredofit dot ca>

   ### Changed
      - Refresh image


## 2.0.21 2022-02-22 <dave at tiredofit dot ca>

   ### Added
      - LemonLDAP:NG 2.0.14


## 2.0.20 2022-02-10 <dave at tiredofit dot ca>

   ### Changed
      - Update to support upstream base image features


## 2.0.19 2021-12-20 <dave at tiredofit dot ca>

   ### Added
      - Update to Alpine 3.15 base


## 2.0.18 2021-12-16 <dave at tiredofit dot ca>

   ### Added
      - Add Fail2ban Zabbix Template


## 2.0.17 2021-12-07 <dave at tiredofit dot ca>

   ### Added
      - Add Zabbix auto register for templates function


## 2.0.16 2021-09-24 <dave at tiredofit dot ca>

   ### Added
      - Add custom fluent-bit parsing logic for log shipping


## 2.0.15 2021-09-06 <dave at tiredofit dot ca>

   ### Changed
      - Add access format to test vhost


## 2.0.14 2021-09-06 <dave at tiredofit dot ca>

   ### Changed
      - Change Log Handler to llng_standard


## 2.0.13 2021-09-05 <dave at tiredofit dot ca>

   ### Added
      - Add blocked logs configuration environment variable


## 2.0.12 2021-09-04 <dave at tiredofit dot ca>

   ### Added
      - Add customizable location for log path, log file and log user file

   ### Changed
      - Change the way logrotation is configured to support future log parsing capabilities


## 2.0.11 2021-09-01 <dave at tiredofit dot ca>

   ### Changed
      - Pin Apache-Session-MongoDB to 0.21


## 2.0.10 2021-08-30 <dave at tiredofit dot ca>

   ### Added
      - Update nginx configuration to support logshipping


## 2.0.9 2021-08-27 <dave at tiredofit dot ca>

   ### Changed
      - Add Patch for 2.0.13 v2 https://gitlab.ow2.org/lemonldap-ng/lemonldap-ng/-/issues/2595


## 2.0.8 2021-08-23 <dave at tiredofit dot ca>

   ### Added
      - LemonLDAP:NG 2.0.13


## 2.0.7 2021-07-24 <dave at tiredofit dot ca>

   ### Added
      - LemonLDAP:NG 2.0.12
      - Alpine 3.14 base


## 2.0.6 2021-06-03 <dave at tiredofit dot ca>

   ### Added
      - Add perl-dbd-pg package


## 2.0.5 2021-06-02 <dave at tiredofit dot ca>

   ### Added
      - Update LaSSO to 2.7.0 2021-28091
      - Cleanup filesystem


## 2.0.3 2021-05-13 <dave at tiredofit dot ca>

   ### Changed
      - Fix for Local Session cache not creating lock directory


## 2.0.2 2021-05-08 <dave at tiredofit dot ca>

   ### Changed
      - Fix for not outputting log information when LOG_TYPE=CONSOLE


## 2.0.1 2021-05-01 <dave at tiredofit dot ca>

   ### Changed
      - Fix for MODE=HANDLER when CONFIG_TYPE=REST


## 2.0.0 2021-04-13 <dave at tiredofit dot ca>

   ### Added
      - MultiArch builds (amd64, armv6, armv7, aarch64)
      - MODE environment variable expanded to allow for disparate Handlers, Portals, and Managers.
      - LaSSO 2.6.1.3

   ### Changed
      - Overhauled Image rewriting all intialization scripts for more flexibility

   ### Removed
      - Log4Perl Logging Option. - LOG_TYPE=FILE is the same as LOG_TYPE=SYSLOG
      - Configuration options that weren't entirely necessary to be put in the Auto Generated lemonldap-ng.ini


## 1.9.9 2021-04-13 <dave at tiredofit dot ca>

   ### Changed
      - Fix Zabbix Agent looping


## 1.9.8 2021-03-27 <dave at tiredofit dot ca>

   ### Changed
      - More Documentation Fixes


## 1.9.7 2021-03-25 <dave at tiredofit dot ca>

   ### Changed
      - Fix Documentation not building for Manager


## 1.9.6 2021-03-15 <dave at tiredofit dot ca>

   ### Changed
      - Switch to imagemagick perl package instead of compiling
      - Update startup scripts


## 1.9.5 2021-02-11 <dave at tiredofit dot ca>

   ### Added
      - LemonLDAP:NG 2.0.11
      - Re-Add MongoDB support


## 1.9.4 2021-01-17 <dave at tiredofit dot ca>

   ### Added
      - LemonLDAP:NG 2.10.0
      - Alpine 3.13 base


## 1.9.3 2020-10-03 <dave at tiredofit dot ca>

   ### Changed
      - Fix permissiosn when applying custom-script


## 1.9.2 2020-09-12 <dave at tiredofit dot ca>

   ### Changed
      - Patchup to 1.9.0


## 1.9.1 2020-09-12 <dave at tiredofit dot ca>

   ### Changed
      - Add Cookie::Baker:XS Package
      - Repair faulty nginx configuration for Portal
      - Add HTTP::Headers::Fast due to broken build


## 1.9.0 2020-09-06 <dave at tiredofit dot ca>

   ### Added
      - LemonLDAP:NG 2.0.9
      - Alpine 3.12
      - Python 3 for building
      - Lasso 2.6.1.2

   ### Changed
      - Nginx configuration files for portal and test to address security issue
      - Patch to libu2f-server to use libjson >0.14
      - Removed some symlinks / hacks for documentation display in manager


## 1.8.2 2020-06-23 <dave at tiredofit dot ca>

   ### Added
      - Add symbolic link to fix mail logo not showing


## 1.8.1 2020-06-22 <dave at tiredofit dot ca>

   ### Added
      - Add `ghostscript-fonts` package to solve missing CAPTCHA images


## 1.8.0 2020-06-09 <dave at tiredofit dot ca>

   ### Added
      - Update to support tiredofit/alpine 5.0.0 base image


## 1.7.1 2020-05-08 <ldgabet@github>

   ###
      - Added symlink for Manager images to display properly

## 1.7.0 2020-05-08 <dave at tiredofit dot ca>

   ### Added
      - Implemented Manager API Support

   ### Changed
      - Altered image to support changes to tiredofit/alpine and tiredofit/nginx base images

   ### Reverted
      - Removed SOAP support


## 1.6.5 2020-05-06 <dave at tiredofit dot ca>

   ### Added
      - LemonLDAP:NG 2.0.8
      - Lasso 2.6.1

   ### Reverted
      - Removed SOAP::Lite

## 1.6.4 2020-04-21 <dave at tiredofit dot ca>

   ### Added
      - Add Perl Module Crypt::OpenSSL:X509
      - Prepare for LLNG 2.0.8 Release


## 1.6.3 2020-03-04 <dave at tiredofit dot ca>

   ### Added
      - Update image to support new tiredofit/alpine:4.4.0 base


## 1.6.2 2020-01-02 <dave at tiredofit dot ca>

   ### Changed
      - Further Changes supporting tireodfit/alpine base image


## 1.6.1 2020-01-02 <dave at tiredofit dot ca>

   ### Changed
      - Move Adding hosts for localhost handler to main lemonldap init script


## 1.6.0 2019-12-29 <dave at tiredofit dot ca>

   ### Added
      - Update to support new tiredofit/alpine base image


## 1.5.2 2019-12-18 <dave at tiredofit dot ca>

   ### Changed
      - Change more hardcoded usernames to dynamic user/group names


## 1.5.1 2019-12-16 <dave at tiredofit dot ca>

   ### Changed
      - Fix nginx configuration to stop barking for site optimization


## 1.5.0 2019-12-16 <dave at tiredofit dot ca>

   ### Added
      - Switch to using tiredofit/nginx as base image to take advantage of functionality

   ### Reverted
      - Removal of MongoDB Driver


## 1.4.4-dev 2019-09-18 <dave at tiredofit dot ca>

* Update for LLNG LDAP Error Logging as per issue #1909 https://gitlab.ow2.org/lemonldap-ng/lemonldap-ng/issues/1909#note_48620

## 1.4.3 2019-09-18 <dave at tiredofit dot ca>

* LemonLDAP:NG 2.0.6

## 1.4.2 2019-09-18 <dave at tiredofit dot ca>

* Add uglify-js node module for building

## 1.4.1 2019-07-09 <dave at tiredofit dot ca>

* Add Auth::Yubikey_WebClient
* Add Text::Unidecode
* Properly remove MongoDB and leave MongoDB Tools

## 1.4 2019-06-29 <dave at tiredofit dot ca>

* LemonLDAP:NG 2.0.5
* Alpine 3.10

## 1.3 2019-05-21 <dave at tiredofit dot ca>

* Add Impersonation functionality to load create custom Vhost, and load a seperate theme with the new fields required to support.

## 1.2.7 2019-05-13 <dave at tiredofit dot ca>

* LemonLDAP:NG 2.0.4

## 1.2.6 2019-04-11 <dave at tiredofit dot ca>

* LemonLDAP:NG 2.0.3

## 1.2.5 2019-04-01 <dave at tiredofit dot ca>

* Update Lasso to pull from Git repository due to failed compilation

## 1.2.4 2019-03-14 <dave at tiredofit dot ca>

* Add Sentry Logging Support

## 1.2.3 2019-03-12 <dave at tiredofit dot ca>

* Add Portal Status Capability

## 1.2.2 2019-02-14 <dave at tiredofit dot ca>

* Add OpenID Connect Key rotation

## 1.2.1 2019-02-13 <dave at tiredofit dot ca>

* LemonLDAP 2.0.2

## 1.2 2019-01-13 <dave at tiredofit dot ca>

* LemonLDAP 2.0.1
* Remove Apache
* Enable Configuration for REST
* Add IP Allow list for REST/SOAP
* Removed many options from the Cofniguration generator, The configuration is far too complex to support so many usage cases, and best left to user switching to `SETUP_TYPE=MANUAL`
* Many bugfixes

## 1.0.3 2018-11-19 <dave at tiredofit dot ca>

* LemonLDAP 2.0 Final Release

## 1.0.2 2018-11-19 <dave at tiredofit dot ca>

* Compress layers in Dockerfile

## 1.0.1 2018-11-19 <dave at tiredofit dot ca>

* Stop using go to get minify, rely on github release

## 1.0 2018-08-03 <dave at tiredofit dot ca>

* Fully Support LemonLDAP 2.0
* Add modules for TOTP, UFS, WebID, Oauth (Facebook)
* Minor pathname fixups
* Update Nginx configuration

## 0.92 2018-07-09 <dave at tiredofit dot ca>

* More logging tweaks
* Squash Image
* Add Authen::Captcha

## 0.91 2018-07-09 <dave at tiredofit dot ca>

* Logging Tweak

## 0.9 2018-07-06 <dave at tiredofit dot ca>

* Ability to choose Apache2 or Nginx for serving requests

## 0.82 2018-06-16 <dave at tiredofit dot ca>

* Update to LemonLDAP 1.9.17

## 0.81 2018-04-28 <dave at tiredofit dot ca>

* Add PORTAL_CACHE_TYPE


## 0.8 2018-04-28 <dave at tiredofit dot ca>

* Fix for Getting LemonLDAP version in setup script

## 0.7 2018-04-27 <dave at tiredofit dot ca>

* Rollback to Alpine 3.7
* Pull master for Lasso
* Grab a few modules from CPAN instead of package manager

## 0.6 2018-02-22 <dave at tiredofit dot ca>

* Add Global and Per Service Logging

## 0.5 2018-02-22 <dave at tiredofit dot ca>

* Add Fail2Ban
* Allow Fail2Ban to be disabled
* Allow to customize how many handler processes

## 0.4 2018-02-22 <dave at tiredofit dot ca>

* Create Minified Assets upon install

## 0.3 2018-02-22 <dave at tiredofit dot ca>

* Working Release
* Supports both 1.9x and 2.x Branches (Set LEMONLDAP_VERSION in Dockerfile)
* Alpine Edge
* Pulling from Git
* Redis, Mongo support
* TCP Sockets enabled by default for Handler

## 0.2 2018-02-20 <dave at tiredofit dot ca>

* Add Reverse Proxy Detection

## 0.1 2017-06-14 Dave Conroy <daveconroy@selfdesign.org>

* Initial Release
* Alpine 3.6
* Nginx Backend
* SVN Trunk
