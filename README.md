pam_checkhomedir Copyright (c) 2018 Mark Coccimiglio
mcoccimiglio@rice.edu

NOTE: This package currently works but is considered BETA.

The design of this PAM Module is to test for the presence of the user's
home directory.  If the Home Directory is not found we return a non-PAM_SUCCESS
return code.  Basically the module pulls the proper $HOME from getpwnam(user) and
does a "Blind Open" ( opendir( struct_getpwdnam->pw_dir ) ).  We DO NOT first
test to see if the directory exists.  This is deliberate.  If the user's home
directory is auto-mounted (e.g. autofs) then it will not show if we try to
pre-test for its existence.  We want the underlying file system/mounts to intercept
the open request, block, and mount the home directory before releasing the I/O
blocking.  

Security NOTE:  We currently do NOT test ownership or permissions at this time.
Depending on how you configure PAM the user's home directory may mount regardless
if the users credential are valid.  YMMV.

Dependcies: pam
Build Dependcies: pam-devel (el) or libpam0g-dev (deb)
