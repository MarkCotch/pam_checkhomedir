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

install: install_bin install_conf install_docs

install_bin: install_bin_$(ID_LIKE)

install_conf: install_conf_$(ID_LIKE)

install_bin_debian: install_bin_"debian"

install_conf_debian: install_conf_"debian"

install_bin_fedora: install_bin_"fedora"

install_conf_fedora: install_conf_"fedora"

install_docs:
	install -v -o root -g root -m 755 pam_checkhomedir.8 /usr/share/man/man8/

install_bin_"debian":
	install -v -o root -g root -m 755 pam_checkhomedir.so /lib/x86_64-linux-gnu/security/

install_conf_"debian":
	install -v -o root -g root -m 755 checkhomedir /usr/share/pam-configs/checkhomedir
	pam-auth-update --package

install_bin_"fedora":
	install -v -o root -g root -m 755 pam_checkhomedir.so /usr/lib64/security/

install_conf_"fedora":
	grep -q pam_checkhomedir.so /etc/pam.d/system-auth   || perl -i -pe 's/(^auth.*pam_unix.so.*$$)/auth        required      pam_checkhomedir.so \n$$1/' /etc/pam.d/system-auth
	grep -q pam_checkhomedir.so /etc/pam.d/password-auth || perl -i -pe 's/(^auth.*pam_unix.so.*$$)/auth        required      pam_checkhomedir.so \n$$1/' /etc/pam.d/password-auth

###
### Uninstallers
###

uninstall: uninstall_bin uninstall_conf uninstall_docs

uninstall_bin: uninstall_bin_$(ID_LIKE)

uninstall_conf: uninstall_conf_$(ID_LIKE)

uninstall_bin_debian: uninstall_bin_"debian"

uninstall_conf_debian: uninstall_conf_"debian"

uninstall_docs:
	rm -vf /usr/share/man/man8/pam_checkhomedir.8

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
