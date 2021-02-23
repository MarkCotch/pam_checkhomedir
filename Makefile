include	/etc/os-release
NAME = pam_checkhomedir
VERSION = 0.0.3
CC=gcc
CFLAGS=-I. -lm
DEPS =
OBJ =
PREFIX =

%.o: %.c $(DEPS)
	$(CC) -c -fPIC -o $@ $< $(CFLAGS)

$(NAME):
	echo "$(ID_LIKE)"
	$(CC) -fPIC -shared -o $@.so $@.c $(CFLAGS)

test%:
	$(CC) -o a.$@ $@.c $< $(CFLAGS)

clean:
	rm -rvf *.o a.* *.so $(NAME)-$(VERSION)/ rpm/$(NAME)-$(VERSION).tar.gz

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

source: pam_checkhomedir
	mkdir -p $(NAME)-$(VERSION)
	cp    -v LICENSE             $(NAME)-$(VERSION)/
	cp    -v pam_checkhomedir.8  $(NAME)-$(VERSION)/
	cp    -v pam_checkhomedir.so $(NAME)-$(VERSION)/
	cp    -v README.md           $(NAME)-$(VERSION)/
	tar    czvf rpm/$(NAME)-$(VERSION).tar.gz  $(NAME)-$(VERSION)/

install_docs:
	install -v -o root -g root -m 755 pam_checkhomedir.8 $(PREFIX)/usr/share/man/man8/

install_bin_"debian":
	install -v -o root -g root -m 755 pam_checkhomedir.so $(PREFIX)/lib/x86_64-linux-gnu/security/

install_conf_"debian":
	install -v -o root -g root -m 755 checkhomedir $(PREFIX)/usr/share/pam-configs/checkhomedir
	pam-auth-update --package

install_bin_"fedora":
	install -v -o root -g root -m 755 pam_checkhomedir.so $(PREFIX)/usr/lib64/security/

install_conf_"fedora":
	grep -q pam_checkhomedir.so /etc/pam.d/system-auth   || perl -i -pe 's/(^auth.*pam_env.so.*$$)/$$1\nauth        required      pam_checkhomedir.so /' /etc/pam.d/system-auth
	grep -q pam_checkhomedir.so /etc/pam.d/password-auth || perl -i -pe 's/(^auth.*pam_env.so.*$$)/$$1\nauth        required      pam_checkhomedir.so /' /etc/pam.d/password-auth

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

updateversion: clean
	@(( NEWVER )) || echo 'update version requires define NEWVER. (e.g. make NEWVER=x.x.x updateversion)'
	@(( NEWVER )) || exit
	@echo $(NEWVER)

#	perl -i -pe 's/^(VERSION =).*/\1 $(NEWVER)/' Makefile
#	perl -i -pe 's/^(.*#define __PCHD_VERSION__).*$$/ \1  "$(NEWVER)" /'  $(NAME).c
#	perl -i -pe 's/^(.*#define __PCHD_VERSION_D__).*$$/ \1  $(NEWVER) /'  $(NAME).c
#	cp -v rpm/$(NAME)-$(VERSION).spec  rpm/$(NAME)-$(NEWVER).spec
#	perl -i -pe 's/^(%define.*version.*)%d.*$$/ \1  $(NEWVER) /' rpm/$(NAME)-$(NEWVER).spec
#	perl -i -pe "s/.TH.*$/.TH man 8 \"$$(date "+%d %b %Y")\" \"$(NEWVER)\" \"$(NAME) man page\" " $(NAME).8
