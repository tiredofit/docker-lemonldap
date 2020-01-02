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
