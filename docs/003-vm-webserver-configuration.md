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
pkg install bison automake autoconf libtool re2c pcre gcc libxml2
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

Edit Nginx config `/usr/local/etc/nginx/nginx.conf`

```bash

http {
    server {
        location / {
            root /usr/local/www/nginx;
            index data.php;
        }

        location ~\.php$ {
            root /usr/local/www/nginx;
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index data.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }
    }
}
```

Copy the provided site to `nginx` folder

```bash
cp /root/epitech-nsa-pool/ressources/app/data.php /usr/local/www/nginx
```

Enable Nginx

```bash
nano /etc/rc.conf
```

```bash
nginx_enable=yes
```

Enable mysql-server

```bash
mysql_server=yes
```

If you have rights problems during mysqli connection, alter user to grant access with the command

```bash
alter user 'backend'@'%' identified with mysql_native_password by 'Bit8Q6aG6'
```
