# VM Webserver Configuration

## Webserver Setup

Install Git

```bash
pkg install git
```

Clone FreeBSD ports repo

```bash
git clone https://github.FreeBSD.org/ports.git /usr/ports
```

Move to directory

```bash
cd /usr/ports
```

Find the branch `2022Q4`

```bash
git checkout 2022Q4
```

Move to `php74` folder

```bash
cd /usr/ports/lang/php74
```

Install the packages

```bash
pkg install bison automake autoconfig libtool re2c rccp pcre
```

Install with Makefile

```bash
make clean config install clean
```

Check if php is installed

```bash
php -v
```

Install extensions

```bash
cd /usr/ports/lang/php74-extensions
```

Install with Makefile

```bash
make clean config install clean
```
