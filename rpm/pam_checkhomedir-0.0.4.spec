%define		name		pam_checkhomedir
%define		version		0.0.4
%define		release		0%{?dist}

Name:		%{name}
Version:	%{version}
Release:	%{release}
Summary:	Check that a user's home directory is present on the system.

License:	GPLv3
URL:		https://github.com/MarkCotch/pam_checkhomedir
Source0:	%{name}-%{version}.tar.gz

Requires:	pam
Requires:	perl

%description
NOTE: This package currently works but is considered BETA.

The design of this PAM Module is to test for the presence of the user's home directory. If the Home Directory is not found we return a non-PAM_SUCCESS return code. Basically the module pulls the proper $HOME from getpwnam(user) and does a "Blind Open" ( opendir( struct_getpwdnam->pw_dir ) ). We DO NOT first test to see if the directory exists. This is deliberate. If the user's home directory is auto-mounted (e.g. autofs) then it will not show if we try to pre-test for its existence. We want the underlying file system/mounts to intercept the open request, block, and mount the home directory before releasing the I/O blocking.

Security NOTE: We currently do NOT test ownership or permissions at this time. Depending on how you configure PAM the user's home directory may mount regardless if the users credential are valid. YMMV.

%prep
%setup -q


%install
mkdir -p   %{buildroot}/usr/lib64/security/
mv    -v   pam_checkhomedir.so %{buildroot}/usr/lib64/security/

mkdir -p   %{buildroot}/usr/share/man/man8/
mv    -v   pam_checkhomedir.8 %{buildroot}/usr/share/man/man8/

mkdir -p   %{buildroot}/usr/share/doc/%{name}-%{version}
mv    -v   README.md %{buildroot}/usr/share/doc/%{name}-%{version}/
mv    -v   LICENSE   %{buildroot}/usr/share/doc/%{name}-%{version}/

%post
grep -q pam_checkhomedir.so /etc/pam.d/system-auth   || perl -i -pe 's/(^auth.*pam_env.so.*$)/$1\nauth        required      pam_checkhomedir.so /' /etc/pam.d/system-auth
grep -q pam_checkhomedir.so /etc/pam.d/password-auth || perl -i -pe 's/(^auth.*pam_env.so.*$)/$1\nauth        required      pam_checkhomedir.so /' /etc/pam.d/password-auth

%postun
(( $1 )) || perl -i -pe 's/^.*pam_checkhomedir.*\n$//' /etc/pam.d/system-auth
(( $1 )) || perl -i -pe 's/^.*pam_checkhomedir.*\n$//' /etc/pam.d/password-auth


%files
/usr/lib64/security/pam_checkhomedir.so
/usr/share/man/man8/pam_checkhomedir.8.gz
/usr/share/doc/%{name}-%{version}



%changelog
