{
   "applicationList" : {
      "1sample" : {
         "catname" : "Sample applications",
         "test1" : {
            "options" : {
               "description" : "A simple application displaying authenticated user",
               "display" : "auto",
               "logo" : "demo.png",
               "name" : "Application Test 1",
               "uri" : "http://test.sso.example.com/"
            },
            "type" : "application"
         },
         "type" : "category"
      },
      "2administration" : {
         "catname" : "Administration",
         "manager" : {
            "options" : {
               "description" : "Configure LemonLDAP::NG WebSSO",
               "display" : "auto",
               "logo" : "configure.png",
               "name" : "WebSSO Manager",
               "uri" : "http://manager.sso.example.com/manager.html"
            },
            "type" : "application"
         },
         "notifications" : {
            "options" : {
               "description" : "Explore WebSSO notifications",
               "display" : "auto",
               "logo" : "database.png",
               "name" : "Notifications explorer",
               "uri" : "http://manager.sso.example.com/notifications.html"
            },
            "type" : "application"
         },
         "sessions" : {
            "options" : {
               "description" : "Explore WebSSO sessions",
               "display" : "auto",
               "logo" : "database.png",
               "name" : "Sessions explorer",
               "uri" : "http://manager.sso.example.com/sessions.html"
            },
            "type" : "application"
         },
         "type" : "category"
      },
      "3documentation" : {
         "catname" : "Documentation",
         "localdoc" : {
            "options" : {
               "description" : "Documentation supplied with LemonLDAP::NG",
               "display" : "on",
               "logo" : "help.png",
               "name" : "Local documentation",
               "uri" : "http://manager.sso.example.com/doc/"
            },
            "type" : "application"
         },
         "officialwebsite" : {
            "options" : {
               "description" : "Official LemonLDAP::NG Website",
               "display" : "on",
               "logo" : "network.png",
               "name" : "Offical Website",
               "uri" : "http://lemonldap-ng.org/"
            },
            "type" : "application"
         },
         "type" : "category"
      }
   },
   "authentication" : "Demo",
   "cfgAuthor" : "The LemonLDAP::NG team",
   "cfgNum" : 1,
   "cookieName" : "lemonldap",
   "demoExportedVars" : {
      "cn" : "cn",
      "mail" : "mail",
      "uid" : "uid"
   },
   "domain" : "example.com",
   "exportedHeaders" : {
      "test.sso.example.com" : {
         "Auth-User" : "$uid"
      },
      "test2.example.com" : {
         "Auth-User" : "$uid"
      }
   },
   "exportedVars" : {
      "UA" : "HTTP_USER_AGENT"
   },
   "globalStorage" : "Apache::Session::File",
   "globalStorageOptions" : {
      "Directory" : "/var/lib/lemonldap-ng/sessions",
      "LockDirectory" : "/var/lib/lemonldap-ng/sessions/lock",
      "generateModule" : "Lemonldap::NG::Common::Apache::Session::Generate::SHA256"
   },
   "groups" : {},
   "localSessionStorage" : "Cache::FileCache",
   "localSessionStorageOptions" : {
      "cache_depth" : 3,
      "cache_root" : "/tmp",
      "default_expires_in" : 600,
      "directory_umask" : "007",
      "namespace" : "lemonldap-ng-sessions"
   },
   "locationRules" : {
      "manager.sso.example.com" : {
         "(?#Configuration)^/(manager\\.html|conf/)" : "$uid eq \"dwho\"",
         "(?#Notifications)/notifications" : "$uid eq \"dwho\" or $uid eq \"rtyler\"",
         "(?#Sessions)/sessions" : "$uid eq \"dwho\" or $uid eq \"rtyler\"",
         "default" : "$uid eq \"dwho\""
      },
      "test.sso.example.com" : {
         "^/logout" : "logout_sso",
         "default" : "accept"
      },
      "test2.example.com" : {
         "^/logout" : "logout_sso",
         "default" : "accept"
      }
   },
   "loginHistoryEnabled" : 1,
   "macros" : {
      "_whatToTrace" : "$_auth eq 'SAML' ? \"$_user\\@$_idpConfKey\" : \"$_user\""
   },
   "mailUrl" : "http://sso.example.com/mail.pl",
   "notification" : 1,
   "notificationStorage" : "File",
   "notificationStorageOptions" : {
      "dirName" : "/var/lib/lemonldap-ng/notifications"
   },
   "passwordDB" : "Demo",
   "persistentStorage" : "Apache::Session::File",
   "persistentStorageOptions" : {
      "Directory" : "/var/lib/lemonldap-ng/psessions",
      "LockDirectory" : "/var/lib/lemonldap-ng/psessions/lock"
   },
   "portal" : "http://sso.example.com/",
   "portalSkin" : "bootstrap",
   "portalSkinBackground" : "1280px-Cedar_Breaks_National_Monument_partially.jpg",
   "registerDB" : "Demo",
   "registerUrl" : "http://sso.example.com/register.pl",
   "reloadUrls" : {
      "reload.sso.example.com" : "http://reload.sso.example.com/reload"
   },
   "securedCookie" : 0,
   "sessionDataToRemember" : {},
   "timeout" : 72000,
   "userDB" : "Demo",
   "whatToTrace" : "_whatToTrace"
}
