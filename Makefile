# VeraCrypt Makefile for FreeBSD Ports
# 
# Make sure to fetch VeraCrypt 1.16 (Unix EOL sources) from https://veracrypt.codeplex.com/
# i.e. with wget -O /usr/ports/distfiles/VeraCrypt_1.16.tar.gz \
# 'http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=veracrypt&DownloadId=1477912&FileTime=130886989050730000&Build=21031'

PORTNAME=	veracrypt
PORTVERSION=	1.16
PORTREVISION=	1
CATEGORIES=	security
MASTER_SITES=	SF/wxwindows/${WX_VER}/:wxwidgets \
		ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-11/v2-20/:rsa \
		http://mirrors.rit.edu/zi/pkcs-11/v2-20/:rsa
DISTFILES=	${VC_SRCFILE}:tc \
		wxWidgets-${WX_VER}.tar.bz2:wxwidgets \
		pkcs11.h:rsa \
		pkcs11f.h:rsa \
		pkcs11t.h:rsa
EXTRACT_ONLY=	${VC_SRCFILE} wxWidgets-${WX_VER}.tar.bz2

MAINTAINER=	tkuiper@inxsoft.net
COMMENT=	Free open-source disk encryption software

BUILD_DEPENDS=	nasm:${PORTSDIR}/devel/nasm
RUN_DEPENDS=	sudo:${PORTSDIR}/security/sudo

WRKSRC=		${WRKDIR}/src

USES=		fuse iconv pkgconfig gmake
RESTRICTED=	May not be redistributed.  Must accept license to download.
NO_CDROM=	May not be redistributed.  Must accept license to download.
NO_PACKAGE=	May not be redistributed.  Must accept license to download.

VC_SRCFILE=	VeraCrypt_1.16.tar.gz
WX_VER=		2.8.12

LICENSE_FILE=	${WRKSRC}/License.txt

PLIST_FILES=	bin/veracrypt

OPTIONS_DEFINE=	X11 DOCS
X11_DESC=	With GUI (depends on X)
WGET=		wget

.include <bsd.port.options.mk>

.if ${PORT_OPTIONS:MDOCS}
PLIST_FILES+=	%%DOCSDIR%%/VeraCrypt\ User\ Guide.pdf
PLIST_FILES+=	%%DOCSDIR%%/License.txt
.endif

.if ${PORT_OPTIONS:MX11}
USE_GNOME=	gtk20
NOGUI=
.else
NOGUI=		NOGUI=1
.endif

do-build:
	@${MKDIR} ${WRKDIR}/rsa
	@${CP} ${DISTDIR}/pkcs11.h ${WRKDIR}/rsa
	@${CP} ${DISTDIR}/pkcs11t.h ${WRKDIR}/rsa
	@${CP} ${DISTDIR}/pkcs11f.h ${WRKDIR}/rsa
	@${ECHO_MSG} "===>  Building for wxWidgets dependency"
	@${CP} patch/Application.cpp work/src/Main/Application.cpp
	@(cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${MAKE_CMD} ${NOGUI} PKCS11_INC=${WRKDIR}/rsa WX_ROOT=${WRKDIR}/wxWidgets-${WX_VER} wxbuild)
	@${ECHO_MSG} "===>  Building for ${PKGNAME}"
	@(cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${MAKE_CMD} ${NOGUI} WXSTATIC=0 PKCS11_INC=${WRKDIR}/rsa)

do-install:
	@${INSTALL_PROGRAM} ${WRKSRC}/Main/veracrypt ${STAGEDIR}${PREFIX}/bin
.if ${PORT_OPTIONS:MDOCS}
	@${MKDIR} ${STAGEDIR}${DOCSDIR}
	@${INSTALL_DATA} ${WRKSRC}/License.txt ${STAGEDIR}${DOCSDIR}
	@${INSTALL_DATA} ${WRKSRC}/Release/Setup\ Files/VeraCrypt\ User\ Guide.pdf ${STAGEDIR}${DOCSDIR}
.endif

.include <bsd.port.mk>
