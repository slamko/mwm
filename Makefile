# mwm - micro window manager
# See LICENSE file for copyright and license details.

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# Xinerama, comment if you don't want it
XINERAMALIBS  = -lXinerama
XINERAMAFLAGS = -DXINERAMA

# freetype
FREETYPELIBS = -lfontconfig -lXft
FREETYPEINC = /usr/include/freetype2
# OpenBSD (uncomment)
#FREETYPEINC = ${X11INC}/freetype2
#MANPREFIX = ${PREFIX}/man

# includes and libs
INCS = -I${X11INC} -I${FREETYPEINC}
LIBS = -L${X11LIB} -lX11 ${XINERAMALIBS} ${FREETYPELIBS}

# flags
CPPFLAGS = -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_POSIX_C_SOURCE=200809L -DVERSION=\"${VERSION}\" ${XINERAMAFLAGS}
#CFLAGS   = -g -std=c99 -pedantic -Wall -O0 ${INCS} ${CPPFLAGS}
CFLAGS   = -std=c99 -pedantic -Wall -Wno-deprecated-declarations -Os ${INCS} ${CPPFLAGS}
LDFLAGS  = ${LIBS}

# Solaris
#CFLAGS = -fast ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = ${LIBS}

# compiler and linker
CC = cc

all: options mwm

options:
	@echo mwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

mwm:
	${CC} -o $@ mwm.c ${CFLAGS} ${LDFLAGS}

clean:
	rm -f mwm ${OBJ} mwm-${VERSION}.tar.gz

dist: clean
	mkdir -p mwm-${VERSION}
	cp -R LICENSE Makefile README mwm.c mwm.png mwm-${VERSION}
	tar -cf mwm-${VERSION}.tar mwm-${VERSION}
	gzip mwm-${VERSION}.tar
	rm -rf mwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f mwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/mwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < mwm.1 > ${DESTDIR}${MANPREFIX}/man1/mwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/mwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/mwm\
		${DESTDIR}${MANPREFIX}/man1/mwm.1

.PHONY: all options mwm clean dist install uninstall
