pkg install git

git clone https://github.FreeBSD.org/ports.git /usr/ports

cd /usr/ports

git checkout 2022Q4

pkg install bison automake autoconf libtool re2c pcre gcc libxml2

cd /usr/ports/lang/php74

make clean config install clean

cd /usr/ports/lang/php74-extensions

make clean config install clean