include	/etc/os-release
CC=gcc
CFLAGS=-I. -lm
DEPS =
OBJ =


%.o: %.c $(DEPS)
	$(CC) -c -fPIC -o $@ $< $(CFLAGS)

pam_checkhomedir:
	echo "$(ID_LIKE)"
	$(CC) -fPIC -shared -o $@.so $@.c $(CFLAGS)

test%:
	$(CC) -o a.$@ $@.c $< $(CFLAGS)

clean:
	rm -vf *.o a.* *.so

###
### Installers
###

install: install_bin install_conf

install_bin: install_bin_$(ID_LIKE)

install_conf: install_conf_$(ID_LIKE)

install_bin_"debian":
	install -v -o root -g root -m 755 pam_checkhomedir.so /lib/x86_64-linux-gnu/security/

install_conf_"debian":
	install -v -o root -g root -m 755 checkhomedir /usr/share/pam-configs/checkhomedir
	pam-auth-update --package

install_bin_"fedora":
	install -v -o root -g root -m 755 pam_checkhomedir.so /usr/lib64/security/

install_conf_"fedora":
	grep -q pam_checkhomedir.so /etc/pam.d/system-auth   || perl -i -pe 's/(^auth.*pam_unix.so.*$$)/$$1\nauth         required     pam_checkhomedir.so /' /etc/pam.d/system-auth
	grep -q pam_checkhomedir.so /etc/pam.d/password-auth || perl -i -pe 's/(^auth.*pam_unix.so.*$$)/$$1\nauth         required     pam_checkhomedir.so /' /etc/pam.d/password-auth

###
### Uninstallers
###

uninstall: uninstall_bin uninstall_conf

uninstall_bin: uninstall_bin_$(ID_LIKE)

uninstall_conf: uninstall_conf_$(ID_LIKE)

uninstall_bin_"debian":
	rm -vf /usr/lib64/security/pam_checkhomedir.so

uninstall_conf_"debian":
	rm -vf /usr/share/pam-configs/checkhomedir
	pam-auth-update --package

uninstall_bin_"fedora":
	rm -vf /usr/lib64/security/pam_checkhomedir.so

uninstall_conf_"fedora":
	perl -i -pe 's/^.*pam_checkhomedir.*\n$$//' /etc/pam.d/system-auth
	perl -i -pe 's/^.*pam_checkhomedir.*\n$$//' /etc/pam.d/password-auth
