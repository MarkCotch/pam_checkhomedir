/*
    pam_checkhomedir -- PAM Module, checks for users $HOME.
    Copyright (c) 2018 Mark Coccimiglio

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.



*/

#ifndef __PCHD_VERSION__
  #define __PCHD_VERSION__    "0.0.2
  #define __PCHD_VERSION_D__   0.0.2
  #define __COPYRIGHT__       "2018"
  #define __COPYRIGHT_D__      2018
  #define __AUTHOR__ "Mark Coccimiglio"
  #define __AUTHOR_EMAIL__ "mcoccimiglio@rice.edu"
  #define __APP__ "pam_checkhomedir"
#endif

#define PAM_SM_AUTH
#define PAM_SM_SESSION

#include <security/pam_modules.h>
#include <security/_pam_macros.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <pwd.h>
#include <dirent.h>
#include <syslog.h>

#define __DEBUG__ (0)

int checkhomedir (pam_handle_t *pamh, int flags, int argc, const char *argv[]) {
      const char  *service;
      const char  *user;
      const char  *authtok;

      if (__DEBUG__) syslog (LOG_NOTICE, "DEBUG:checkhomedir");
      if ( pam_get_item(pamh, PAM_SERVICE, (const void **)(const void *)&service ) != PAM_SUCCESS || !service || !*service) {
          syslog (LOG_NOTICE, "Unable to retrieve the PAM service name for :%s STOP.", service);
          return (PAM_AUTH_ERR);
        }
      if (__DEBUG__) syslog(LOG_NOTICE, "DEBUG:We have service '%s' ...continue. ", service);
      if (pam_get_item( pamh, PAM_USER, (const void **)(const void *)&user ) != PAM_SUCCESS || !user || !*user) {
          /* User name is not set.  Tell pam to get user name */
          if (__DEBUG__) syslog (LOG_NOTICE, "DEBUG:No user provided,  Asking PAM for username.");
          if ( pam_get_user (pamh, &user, NULL) != PAM_SUCCESS || !user || !*user ) {
           syslog (LOG_NOTICE, "pam_checkhomedir(%s:auth): Unable to retrieve the PAM user name, is NULL, or zero length, for '%s' ", service, user);
           return (PAM_USER_UNKNOWN);
         }
      }

      /* Validate User */
      struct passwd *_userInfo=getpwnam(user);
      if (! _userInfo) {
        char __tempNotice[256]={0};
        syslog (LOG_NOTICE, "pam_checkhomedir(%s): Unable to locate user ID : '%s' STOP.", service, user);
        return (PAM_USER_UNKNOWN);
      }
      if (__DEBUG__) syslog (LOG_NOTICE, "DEBUG:We have validated user: '%s' ...continue.", user);

      DIR *_homeDIR;
      if ( (_homeDIR=opendir(_userInfo->pw_dir) ) ) {
        syslog (LOG_NOTICE, "pam_checkhomedir(%s): Validated home dir: '%s' ", service, _userInfo->pw_dir);
        closedir (_homeDIR);
        return (PAM_SUCCESS);
      }
      closedir (_homeDIR);
      syslog (LOG_NOTICE, "pam_checkhomedir(%s): Have NOT validated home dir: '%s' ", service, _userInfo->pw_dir);
      return (PAM_PERM_DENIED);
}

PAM_EXTERN int
  pam_sm_authenticate
   (pam_handle_t *pamh, int flags, int argc, const char **argv) {
     openlog(NULL , LOG_PID, LOG_AUTHPRIV);
     if (__DEBUG__) syslog (LOG_NOTICE, "DEBUG:pam_checkhomedir:pam_sm_authenticate");
     return ( checkhomedir(pamh, flags, argc, argv) );

}

PAM_EXTERN int
  pam_sm_setcred
   (pam_handle_t *pamh, int flags, int argc, const char **argv) {
     openlog(NULL , LOG_PID, LOG_AUTHPRIV);
     if (__DEBUG__) syslog (LOG_NOTICE, "DEBUG:pam_checkhomedir:pam_sm_setcred");
     return ( checkhomedir(pamh, flags, argc, argv) );
}

PAM_EXTERN int
  pam_sm_acct_mgmt
    (pam_handle_t *pamh, int flags, int argc, const char **argv) {
      openlog(NULL , LOG_PID, LOG_AUTHPRIV);
      if (__DEBUG__) syslog (LOG_NOTICE, "DEBUG:pam_checkhomedir:pam_sm_acct_mgmt");
      return ( checkhomedir(pamh, flags, argc, argv) );
}

PAM_EXTERN int
  pam_sm_open_session
    (pam_handle_t *pamh, int flags, int argc, const char **argv) {
      openlog(NULL , LOG_PID, LOG_AUTHPRIV);
      if (__DEBUG__) syslog (LOG_NOTICE, "DEBUG:pam_checkhomedir:pam_sm_open_session");
      return ( checkhomedir(pamh, flags, argc, argv) );
}

PAM_EXTERN int
  pam_sm_close_session
    (pam_handle_t *pamh, int flags, int argc, const char **argv) {
      openlog(NULL , LOG_PID, LOG_AUTHPRIV);
      if (__DEBUG__) syslog (LOG_NOTICE, "DEBUG:pam_checkhomedir:pam_sm_close_session");
    	return ( PAM_IGNORE );
}

PAM_EXTERN int
  pam_sm_chauthtok
    (pam_handle_t *pamh, int flags, int argc, const char **argv) {
      openlog(NULL , LOG_PID, LOG_AUTHPRIV);
      if (__DEBUG__) syslog (LOG_NOTICE, "DEBUG:pam_checkhomedir:pam_sm_chauthtok");
      return ( PAM_IGNORE );
}

#ifdef PAM_MODULE_ENTRY
 PAM_MODULE_ENTRY(__APP__);
#endif
