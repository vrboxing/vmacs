#!/bin/sh
workingdir=`dirname $0`
# instead usr/include
# sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /


# export PATH=/usr/local/opt/gcc/bin:$PATH
prefix=/usr/local/emacs
if [ ! -d /usr/local/emacs ]; then
    sudo mkdir -p /usr/local/emacs ;
    sudo chown ${USER}:admin  /usr/local/emacs;
fi
echo ${prefix}
# echo ${workingdir}/emacs-env
# source ${workingdir}/emacs-env
export PATH=$PATH:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/gnu-sed/bin
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PATH="/usr/local/opt/texinfo/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/gcc/9

./autogen.sh
# CC=/usr/local/opt/gcc/bin/gcc-9 \
CC='clang' \
./configure \
--disable-silent-rules \
--enable-locallisppath=/usr/local/share/emacs/site-lisp \
--prefix=${prefix} \
--with-nativecomp \
--with-gnutls \
--without-x \
--without-dbus \
--without-imagemagick \
--with-modules \
--with-ns \
--with-xml2 \
--disable-ns-self-contained \
CC='clang'
# --with-xwidgets \
# ./configure -C
# cd lisp;make autoload
# git clean -fdx
make -j 4 ||git clean -fdx&&make bootstrap -j 4
echo more info see INSTALL.REPO when compile error
function catch_errors() {
    echo "script aborted, because of errors";
    exit $?;
}

trap catch_errors ERR;

make install
rm -rf ${prefix}/Emacs.app
cp -rf nextstep/Emacs.app  ${prefix}/Emacs.app
mv -f ${prefix}/bin/emacs ${prefix}/bin/emacsbak
cat >${prefix}/bin/emacs << EOS
#!/bin/bash
exec ${prefix}/Emacs.app/Contents/MacOS/Emacs "\$@"
EOS

chmod 755 ${prefix}/bin/emacs

make -C ~/.emacs.d dump
