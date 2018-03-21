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

#define PAM_SM_AUTH

#ifndef __PCHD_VERSION__
  #define __PCHD_VERSION__  "0.0.0"
  #define __PCHD_VERSION_D__ 0.0.0
  #define __AUTHOR__ "Mark Coccimiglio"
  #define __AUTHOR_EMAIL__ "mcoccimiglio@rice.edu"
  #define __APP__ pam_checkhomedir
#endif

#include <security/pam_modules.h>
#include <security/_pam_macros.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mount.h>
#include <pwd.h>
#include <dirent.h>
#include <string.h>
#include <syslog.h>

PAM_EXTERN int
 pam_sm_authenticate
  (pam_handle_t *pamh, int flags, int argc, const char *argv[])
   {
     return (PAM_IGNORE);
   }

PAM_EXTERN int
  pam_sm_setcred
   (pam_handle_t *pamh,int flags,int argc, const char **argv)
    {
      return (PAM_IGNORE);
    }
PAM_EXTERN int
    pam_sm_acct_mgmt
    (pam_handle_t *pamh, int flags, int argc, const char *argv[]) {
    	return (PAM_IGNORE);
}

PAM_EXTERN int
  pam_sm_open_session
     (pam_handle_t *pamh, int flags, int argc, const char *argv[]) {
    	  return (PAM_IGNORE);
}

PAM_EXTERN int
  pam_sm_close_session
    (pam_handle_t *pamh, int flags, int argc, const char *argv[]) {
    	return (PAM_IGNORE);
}

PAM_EXTERN int
  pam_sm_chauthtok
    (pam_handle_t *pamh, int flags, int argc, const char *argv[]) {
      return (PAM_IGNORE);
}

#ifdef PAM_MODULE_ENTRY
 PAM_MODULE_ENTRY("pam_checkhomedir");
#endif
