
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 3 - Projeto em PHP - TravelList"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# Projeto em PHP - TravelList


##### COMANDOS UTEIS

cd /home/fernando/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo
docker-compose up -d
docker-compose exec app ls -l
http://localhost:8000
http://192.168.136.128:8000
http://192.168.0.109:8000/
make up
make stop
curl http://192.168.0.109:8000/
make exec-app


## PENDENTE
- Ler
https://docs.newrelic.com/docs/errors-inbox/errors-inbox/
- Subir um TravelList via Docker no Debian. Ver sobre o .env, variaveis, etc
/home/fernando/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo
https://dev.to/vumdao/5-minutes-travellist-laravel-demo-2fcj
https://devpress.csdn.net/cicd/62eca52b19c509286f41776b.html

- Subir APM nele




- Seguindo tutorial:

<https://dev.to/vumdao/5-minutes-travellist-laravel-demo-2fcj>


- Criado script
/home/fernando/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo/start.sh

~~~~BASH
#!/usr/bin/env bash
set -e

role=${CONTAINER_ROLE:-app}
env=${APP_ENV:-production}

if [ "$env" != "local" ]; then
    echo "Caching configuration..."
    (cd /var/www/html && php artisan config:cache && php artisan route:cache && php artisan view:cache)
fi

if [ "$role" = "app" ]; then
    exec php-fpm
elif [ "$role" = "scheduler" ]; then
    echo "Queue role"
    while [ true ]
    do
      php /var/www/artisan schedule:run --verbose --no-interaction &
      sleep 60
    done
elif [ "$role" = "queue" ]; then
    echo "Running the queue..."
    /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
else
    echo "Could not match the container role \"$role\""
    exit 1
fi
~~~~




- Ajustando Dockerfile

DE:

~~~~DOCKERFILE
FROM php:7.4-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www

USER $user

~~~~


PARA:

~~~~DOCKERFILE
FROM php:7.4-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    supervisor

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# setup redis
RUN pecl install redis \
        && docker-php-ext-enable redis

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www
ADD composer.json ./
RUN composer install --prefer-dist --no-scripts --no-autoloader --no-interaction --no-ansi --optimize-autoloader


COPY . /var/www/
VOLUME /var/www/storage /var/www/bootstrap
# Create system user to run Composer and Artisan Commands


COPY docker/start.sh /usr/local/bin/start
RUN chown -R $user: /var/www \
    && chmod u+x /usr/local/bin/start
COPY docker/supervisord.conf /etc/supervisor/supervisord.conf

USER $user

CMD ["/usr/local/bin/start"]
~~~~






- Estes já estavam ok:
/home/fernando/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo/docker-compose/nginx/travellist.conf
/home/fernando/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo/docker-compose/mysql/init_db.sql

 Setting Up the Application’s .env File

cd travellist-laravel-demo-tutorial-4.0.1
cp .env.example .env




    Modify .env to correct information

.env

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=travellist
DB_USERNAME=user
DB_PASSWORD=password

- Editado

~~~~bash

fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ vi .env
You have new mail in /var/mail/fernando
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$

~~~~



Create docker-compose.yaml with support all three roles

    Web server exec php-fpm
    Scheduler runner php /var/www/artisan schedule:run
    Queue worker /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

- Editando:
/home/fernando/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo/docker-compose.yml

ANTES

~~~~YAML
version: "3.7"
services:
  app:
    build:
      args:
        user: sammy
        uid: 1000
      context: ./
      dockerfile: Dockerfile
    image: travellist
    container_name: travellist-app
    restart: unless-stopped
    working_dir: /var/www/
    volumes:
      - ./:/var/www
    networks:
      - travellist

  db:
    image: mysql:5.7
    container_name: travellist-db
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: ${DB_DATABASE}
      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
      MYSQL_PASSWORD: ${DB_PASSWORD}
      MYSQL_USER: ${DB_USERNAME}
      SERVICE_TAGS: dev
      SERVICE_NAME: mysql
    volumes:
      - ./docker-compose/mysql:/docker-entrypoint-initdb.d
    networks:
      - travellist

  nginx:
    image: nginx:alpine
    container_name: travellist-nginx
    restart: unless-stopped
    ports:
      - "8000:80"
    volumes:
      - ./:/var/www
      - ./docker-compose/nginx:/etc/nginx/conf.d
    networks:
      - travellist

networks:
  travellist:
    driver: bridge

~~~~



depois

~~~~yaml
version: "3.7"
services:
  app:
    build:
      args:
        user: www-data
        uid: 1000
      context: ./
      dockerfile: Dockerfile
    image: travellist
    container_name: travellist-app
    restart: unless-stopped
    working_dir: /var/www/
    volumes:
      - ./:/var/www
      - composer_cache:/home/.sammy/.composer
    networks:
      - travellist
    environment:
      APP_ENV: local
      CONTAINER_ROLE: app

  scheduler:
    image: travellist
    container_name: travellist-scheduler
    depends_on:
      - app
    restart: unless-stopped
    working_dir: /var/www/
    volumes:
      - ./:/var/www
      - composer_cache:/home/.sammy/.composer
    networks:
      - travellist
    environment:
      APP_ENV: local
      CONTAINER_ROLE: scheduler

  queue:
    image: travellist
    container_name: travellist-queue
    depends_on:
      - app
    volumes:
      - ./:/var/www
      - composer_cache:/home/.sammy/.composer
    environment:
      APP_ENV: local
      CONTAINER_ROLE: queue
      CACHE_DRIVER: redis
      SESSION_DRIVER: redis
      QUEUE_DRIVER: redis
      REDIS_HOST: redis

  redis:
    container_name: travellist-redis
    image: redis:4-alpine
    ports:
      - 16379:6379

  db:
    image: mysql:5.7
    container_name: travellist-db
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: travellist
      MYSQL_ROOT_PASSWORD: password
      MYSQL_PASSWORD: password
      MYSQL_USER: user
      SERVICE_TAGS: dev
      SERVICE_NAME: mysql
    volumes:
      - ./docker-compose/mysql:/docker-entrypoint-initdb.d
    networks:
      - travellist

  nginx:
    image: nginx:alpine
    container_name: travellist-nginx
    restart: unless-stopped
    ports:
      - "8000:80"
    volumes:
      - ./:/var/www
      - ./docker-compose/nginx:/etc/nginx/conf.d
    networks:
      - travellist

networks:
  travellist:
    driver: bridge
volumes:
  composer_cache:
~~~~





 Run composer install to install the application dependencies

$ chmod -R 777 storage .env

$ docker-compose up -d

$ docker-compose exec app ls -l
total 256
-rw-rw-r-- 1 1000 1000    737 May 14  2020 Dockerfile
drwxrwxr-x 6 1000 1000   4096 May 14  2020 app
-rwxr-xr-x 1 1000 1000   1686 May 14  2020 artisan
drwxr-xr-x 2 root root   4096 Dec 25 08:47 bootstrap
-rw-rw-r-- 1 1000 1000   1501 May 14  2020 composer.json
-rw-rw-r-- 1 1000 1000 181665 May 14  2020 composer.lock
drwxrwxr-x 2 1000 1000   4096 May 14  2020 config
drwxrwxr-x 5 1000 1000   4096 May 14  2020 database
drwxrwxr-x 4 1000 1000   4096 May 14  2020 docker-compose
-rw-rw-r-- 1 1000 1000   1016 May 14  2020 docker-compose.yml
-rw-rw-r-- 1 1000 1000   1013 May 14  2020 package.json
-rw-rw-r-- 1 1000 1000   1405 May 14  2020 phpunit.xml
drwxrwxr-x 5 1000 1000   4096 May 14  2020 public
-rw-rw-r-- 1 1000 1000    814 May 14  2020 readme.md
drwxrwxr-x 6 1000 1000   4096 May 14  2020 resources
drwxrwxr-x 2 1000 1000   4096 May 14  2020 routes
-rw-rw-r-- 1 1000 1000    563 May 14  2020 server.php
drwxr-xr-x 2 root root   4096 Dec 25 08:47 storage
drwxrwxr-x 4 1000 1000   4096 May 14  2020 tests
-rw-rw-r-- 1 1000 1000    538 May 14  2020 webpack.mix.js

$ docker-compose exec app composer install

🚀 Check http://localhost:8000 



- ERRO

~~~~BASH

fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ docker-compose up -d
Creating network "travellist-laravel-demo_travellist" with driver "bridge"
Creating network "travellist-laravel-demo_default" with the default driver
Creating volume "travellist-laravel-demo_composer_cache" with default driver
Building app
[+] Building 5.2s (23/23) FINISHED                                                                                                                                                                                                                                             docker:default
 => [internal] load .dockerignore                                                                                                                                                                                                                                                        0.0s
 => => transferring context: 88B                                                                                                                                                                                                                                                         0.0s
 => [internal] load build definition from Dockerfile                                                                                                                                                                                                                                     0.0s
 => => transferring dockerfile: 1.33kB                                                                                                                                                                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/composer:latest                                                                                                                                                                                                                       4.3s
 => [internal] load metadata for docker.io/library/php:7.4-fpm                                                                                                                                                                                                                           4.3s
 => [auth] library/composer:pull token for registry-1.docker.io                                                                                                                                                                                                                          0.0s
 => [auth] library/php:pull token for registry-1.docker.io                                                                                                                                                                                                                               0.0s
 => CACHED [stage-0  1/15] FROM docker.io/library/php:7.4-fpm@sha256:3ac7c8c74b2b047c7cb273469d74fc0d59b857aa44043e6ea6a0084372811d5b                                                                                                                                                    0.0s
 => [internal] load build context                                                                                                                                                                                                                                                        0.1s
 => => transferring context: 334.61kB                                                                                                                                                                                                                                                    0.0s
 => CACHED FROM docker.io/library/composer:latest@sha256:1f88162f6d30fe394990edd298f181f66e8a4ba36d3e102213c2d4a8eb8654a5                                                                                                                                                                0.0s
 => CANCELED [stage-0  2/15] RUN apt-get update && apt-get install -y     git     curl     libpng-dev     libonig-dev     libxml2-dev     zip     unzip     supervisor                                                                                                                   0.8s
 => CACHED [stage-0  3/15] RUN apt-get clean && rm -rf /var/lib/apt/lists/*                                                                                                                                                                                                              0.0s
 => CACHED [stage-0  4/15] RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd                                                                                                                                                                                            0.0s
 => CACHED [stage-0  5/15] RUN pecl install redis         && docker-php-ext-enable redis                                                                                                                                                                                                 0.0s
 => CACHED [stage-0  6/15] COPY --from=composer:latest /usr/bin/composer /usr/bin/composer                                                                                                                                                                                               0.0s
 => CACHED [stage-0  7/15] RUN useradd -G www-data,root -u 1000 -d /home/www-data www-data                                                                                                                                                                                               0.0s
 => CACHED [stage-0  8/15] RUN mkdir -p /home/www-data/.composer &&     chown -R www-data:www-data /home/www-data                                                                                                                                                                        0.0s
 => CACHED [stage-0  9/15] WORKDIR /var/www                                                                                                                                                                                                                                              0.0s
 => CACHED [stage-0 10/15] ADD composer.json ./                                                                                                                                                                                                                                          0.0s
 => CACHED [stage-0 11/15] RUN composer install --prefer-dist --no-scripts --no-autoloader --no-interaction --no-ansi --optimize-autoloader                                                                                                                                              0.0s
 => CACHED [stage-0 12/15] COPY . /var/www/                                                                                                                                                                                                                                              0.0s
 => ERROR [stage-0 13/15] COPY docker/start.sh /usr/local/bin/start                                                                                                                                                                                                                      0.0s
 => CACHED [stage-0 14/15] RUN chown -R www-data: /var/www     && chmod u+x /usr/local/bin/start                                                                                                                                                                                         0.0s
 => ERROR [stage-0 15/15] COPY docker/supervisord.conf /etc/supervisor/supervisord.conf                                                                                                                                                                                                  0.0s
------
 > [stage-0 13/15] COPY docker/start.sh /usr/local/bin/start:
------
------
 > [stage-0 15/15] COPY docker/supervisord.conf /etc/supervisor/supervisord.conf:
------
Dockerfile:50
--------------------
  48 |     RUN chown -R $user: /var/www \
  49 |         && chmod u+x /usr/local/bin/start
  50 | >>> COPY docker/supervisord.conf /etc/supervisor/supervisord.conf
  51 |
  52 |     USER $user
--------------------
ERROR: failed to solve: failed to compute cache key: failed to calculate checksum of ref 396f8278-0362-4c61-a475-2fb66801378c::rahayo1o8nnoggykw7x0awiu0: "/docker/supervisord.conf": not found
ERROR: Service 'app' failed to build : Build failed
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ docker-compose exec app ls -l
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$

~~~~



## PENDENTE
- Tratar erro no build.
- Ver sobre usuario www-data vs sammy.
- Subir APM na aplicação.





## Dia 06/01/2024

- Tratar erro no build.

- Criando arquivo de conf para o supervisor:

~~~~conf
[supervisord]
logfile=/dev/null             ; (main log file;default $CWD/supervisord.log)
logfile_maxbytes=0            ; (max main logfile bytes b4 rotation;default 50MB)
logfile_backups=0             ; (num of main logfile rotation backups;default 10)
loglevel=info                 ; (log level;default info; others: debug,warn,trace)
pidfile=/tmp/supervisord.pid  ; (supervisord pidfile;default supervisord.pid)
nodaemon=true                 ; (start in foreground if true;default false)

; the below section must remain in the config file for RPC
; (supervisorctl/web interface) to work, additional interfaces may be
; added by defining them in separate rpcinterface: sections
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock ; use a unix:// URL  for a unix socket

[program:queue-worker]
command=php artisan queue:work --daemon --delay=2 --sleep=1 --tries=3
directory=/var/www
redirect_stderr=true
autostart=true
autorestart=true
stdout_logfile_maxbytes=0
stderr_logfile_maxbytes=0
stdout_logfile=/dev/stdout
~~~~




$ docker-compose up -d

$ docker-compose exec app ls -l


- Buildando.
- Novo erro:

~~~~bash

fernando@debian10x64:~$ cd ~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ docker-compose up -d
Building app
[+] Building 30.1s (4/4) FINISHED                                                                                                                                                                                                                                              docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                                                                                                                     0.0s
 => => transferring dockerfile: 1.33kB                                                                                                                                                                                                                                                   0.0s
 => [internal] load .dockerignore                                                                                                                                                                                                                                                        0.0s
 => => transferring context: 88B                                                                                                                                                                                                                                                         0.0s
 => ERROR [internal] load metadata for docker.io/library/composer:latest                                                                                                                                                                                                                30.0s
 => ERROR [internal] load metadata for docker.io/library/php:7.4-fpm                                                                                                                                                                                                                    30.0s
------
 > [internal] load metadata for docker.io/library/composer:latest:
------
------
 > [internal] load metadata for docker.io/library/php:7.4-fpm:
------
Dockerfile:29
--------------------
  27 |
  28 |     # Get latest Composer
  29 | >>> COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
  30 |
  31 |     # Create system user to run Composer and Artisan Commands
--------------------
ERROR: failed to solve: DeadlineExceeded: DeadlineExceeded: DeadlineExceeded: composer:latest: failed to do request: Head "https://registry-1.docker.io/v2/library/composer/manifests/latest": dial tcp 3.219.239.5:443: i/o timeout
ERROR: Service 'app' failed to build : Build failed
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
You have new mail in /var/mail/fernando
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ date
Mon 01 Jan 2024 05:07:08 PM -03
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$


~~~~




- Tentando abrir:

<https://registry-1.docker.io/v2/library/composer/manifests/latest>

erro:

~~~~json
errors	
0	
code	"UNAUTHORIZED"
message	"authentication required"
detail	
0	
Type	"repository"
Class	""
Name	"library/composer"
Action	"pull"
~~~~



https://hub.docker.com/_/composer/tags
docker pull composer:2.6.6

- Pull tá ok:

~~~~bash
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ docker pull composer:latest
latest: Pulling from library/composer
661ff4d9561e: Already exists
fbc99979baa6: Already exists
47536423e079: Already exists
1be6d4fc569f: Already exists
0d66ed8a08e8: Already exists
9c89438a3af7: Already exists
032cda9d3dce: Already exists
64252f72f3b7: Already exists
74b1388b45b1: Already exists
f96fa6dac320: Already exists
594b5f962aa6: Already exists
00dba960c1f9: Already exists
4b1cd4fd5b56: Already exists
8efd93cef2cf: Already exists
Digest: sha256:1f88162f6d30fe394990edd298f181f66e8a4ba36d3e102213c2d4a8eb8654a5
Status: Downloaded newer image for composer:latest
docker.io/library/composer:latest
You have new mail in /var/mail/fernando
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ date
Mon 01 Jan 2024 05:11:59 PM -03
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
~~~~



- Agora cessou erro do composer, novo erro:

~~~~bash

fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ docker-compose up -d
Building app
[+] Building 5.4s (9/22)                                                                                                                                                                                                                                                       docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                                                                                                                     0.0s
 => => transferring dockerfile: 1.33kB                                                                                                                                                                                                                                                   0.0s
 => [internal] load .dockerignore                                                                                                                                                                                                                                                        0.0s
 => => transferring context: 88B                                                                                                                                                                                                                                                         0.0s
 => [internal] load metadata for docker.io/library/composer:latest                                                                                                                                                                                                                       0.0s
 => [internal] load metadata for docker.io/library/php:7.4-fpm                                                                                                                                                                                                                           1.6s
 => [auth] library/php:pull token for registry-1.docker.io                                                                                                                                                                                                                               0.0s
 => CACHED [stage-0  1/15] FROM docker.io/library/php:7.4-fpm@sha256:3ac7c8c74b2b047c7cb273469d74fc0d59b857aa44043e6ea6a0084372811d5b                                                                                                                                                    0.0s
 => [internal] load build context                                                                                                                                                                                                                                                        0.0s
 => => transferring context: 8.29kB                                                                                                                                                                                                                                                      0.0s
 => CACHED FROM docker.io/library/composer:latest                                                                                                                                                                                                                                        0.0s
 => ERROR [stage-0  2/15] RUN apt-get update && apt-get install -y     git     curl     libpng-dev     libonig-dev     libxml2-dev     zip     unzip     supervisor                                                                                                                      3.7s
------
 > [stage-0  2/15] RUN apt-get update && apt-get install -y     git     curl     libpng-dev     libonig-dev     libxml2-dev     zip     unzip     supervisor:
1.606 Get:1 http://deb.debian.org/debian bullseye InRelease [116 kB]
1.683 Get:2 http://deb.debian.org/debian-security bullseye-security InRelease [48.4 kB]
1.725 Get:3 http://deb.debian.org/debian bullseye-updates InRelease [44.1 kB]
1.780 Get:4 http://deb.debian.org/debian bullseye/main amd64 Packages [8062 kB]
3.099 Reading package lists...
3.537 E: Release file for http://deb.debian.org/debian-security/dists/bullseye-security/InRelease is not valid yet (invalid for another 4d 11h 23min 36s). Updates for this repository will not be applied.
3.537 E: Release file for http://deb.debian.org/debian/dists/bullseye-updates/InRelease is not valid yet (invalid for another 4d 18h 3min 16s). Updates for this repository will not be applied.
------
Dockerfile:8
--------------------
   7 |     # Install system dependencies
   8 | >>> RUN apt-get update && apt-get install -y \
   9 | >>>     git \
  10 | >>>     curl \
  11 | >>>     libpng-dev \
  12 | >>>     libonig-dev \
  13 | >>>     libxml2-dev \
  14 | >>>     zip \
  15 | >>>     unzip \
  16 | >>>     supervisor
  17 |
--------------------
ERROR: failed to solve: process "/bin/sh -c apt-get update && apt-get install -y     git     curl     libpng-dev     libonig-dev     libxml2-dev     zip     unzip     supervisor" did not complete successfully: exit code: 100
ERROR: Service 'app' failed to build : Build failed
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ date
Mon 01 Jan 2024 05:12:27 PM -03
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$

~~~~







ERROR: failed to solve: process "/bin/sh -c apt-get update && apt-get install -y     git     curl     libpng-dev     libonig-dev     libxml2-dev     zip     unzip     supervisor" did not complete successfully: exit code: 100
ERROR: Service 'app' failed to build : Build failed
You have new mail in /var/mail/fernando




DE:


# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    supervisor




- Testes com outro dockerfile, segue com erro:


ERROR: failed to solve: process "/bin/sh -c apt-get update && apt-get install -y \t\tlibfreetype-dev \t\tlibjpeg62-turbo-dev \t\tlibpng-dev \t&& docker-php-ext-configure gd --with-freetype --with-jpeg \t&& docker-php-ext-install -j$(nproc) gd" did not complete successfully: exit code: 100
ERROR: Service 'app' failed to build : Build failed



## PENDENTE
- Tratar erro no build.
        Ver erros:
        3.650 E: Release file for http://deb.debian.org/debian-security/dists/bullseye-security/InRelease is not valid yet (invalid for another 4d 11h 7min 41s). Updates for this repository will not be applied.
        3.650 E: Release file for http://deb.debian.org/debian/dists/bullseye-updates/InRelease is not valid yet (invalid for another 4d 17h 47min 21s). Updates for this repository will not be applied.
- Ver sobre usuario www-data vs sammy.
- Subir APM na aplicação.











https://askubuntu.com/questions/1096930/sudo-apt-update-error-release-file-is-not-yet-valid

This is a timezone issue. Try restarting your Docker host. It worked for me.

sudo timedatectl set-time '15:17:00'
sudo timedatectl set-time '2024-01-06'







cd /home/fernando/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo
docker-compose up -d
docker-compose exec app ls -l



- Build OK

porém ocorrem erros nos containers

~~~~bash

fernando@debian10x64:~$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS                            PORTS                                   NAMES
6d51a640717d   travellist     "docker-php-entrypoi…"   21 minutes ago   Restarting (126) 26 seconds ago                                           travellist-scheduler
74bccefbd243   travellist     "docker-php-entrypoi…"   21 minutes ago   Restarting (126) 26 seconds ago                                           travellist-app
50813c60099e   mysql:5.7      "docker-entrypoint.s…"   21 minutes ago   Up 4 minutes                      3306/tcp, 33060/tcp                     travellist-db
ae4a81738a69   nginx:alpine   "/docker-entrypoint.…"   21 minutes ago   Up 4 minutes                      0.0.0.0:8000->80/tcp, :::8000->80/tcp   travellist-nginx
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$
fernando@debian10x64:~$ docker logs travellist-app
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
fernando@debian10x64:~$
fernando@debian10x64:~$ date
Sat 06 Jan 2024 07:38:00 PM -03
fernando@debian10x64:~$

~~~~








/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied




docker-compose exec app ls -l





- Efetuados ajustes no Dockerfile e docker-compose, para deixar o www-data com permissões.
- Segue com erro:

~~~~bash

fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ docker logs travellist-app
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
/usr/local/bin/docker-php-entrypoint: 9: exec: /usr/local/bin/start: Permission denied
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ date
Sat 06 Jan 2024 08:00:33 PM -03
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$

~~~~








- Dockerfile ajustado:

~~~~DOCKERFILE
FROM php:7.4-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    supervisor

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# setup redis
RUN pecl install redis \
        && docker-php-ext-enable redis

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
#RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user && \
    chown -R $user:$user /var/www/


# Set working directory
WORKDIR /var/www
ADD composer.json ./
RUN composer install --prefer-dist --no-scripts --no-autoloader --no-interaction --no-ansi --optimize-autoloader


COPY . /var/www/
VOLUME /var/www/storage /var/www/bootstrap
# Create system user to run Composer and Artisan Commands


COPY docker/start.sh /usr/local/bin/start
RUN chown -R $user: /var/www \
    && chmod u+x /usr/local/bin/start
COPY docker/supervisord.conf /etc/supervisor/supervisord.conf

RUN chmod 755 /usr/local/bin/start
RUN chown -R $user:$user /usr/local/bin/start

USER $user

CMD ["/usr/local/bin/start"]
~~~~






- OK, agora containers subiram:

~~~~bash

fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS                                         NAMES
8cf4eb2da48c   travellist       "docker-php-entrypoi…"   17 seconds ago   Up 15 seconds   9000/tcp                                      travellist-scheduler
3c47cfae817e   travellist       "docker-php-entrypoi…"   17 seconds ago   Up 15 seconds   9000/tcp                                      travellist-queue
cdedb62b34b3   travellist       "docker-php-entrypoi…"   18 seconds ago   Up 17 seconds   9000/tcp                                      travellist-app
7f612b588bfd   nginx:alpine     "/docker-entrypoint.…"   16 minutes ago   Up 17 seconds   0.0.0.0:8000->80/tcp, :::8000->80/tcp         travellist-nginx
d6f5cf1f240b   redis:4-alpine   "docker-entrypoint.s…"   16 minutes ago   Up 17 seconds   0.0.0.0:16379->6379/tcp, :::16379->6379/tcp   travellist-redis
26444659059d   mysql:5.7        "docker-entrypoint.s…"   16 minutes ago   Up 17 seconds   3306/tcp, 33060/tcp                           travellist-db
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ date
Sat 06 Jan 2024 08:08:49 PM -03
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$

~~~~



- Novo erro:

~~~~bash
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ curl http://192.168.136.128:8000
<br />
<b>Warning</b>:  require(/var/www/public/../vendor/autoload.php): failed to open stream: No such file or directory in <b>/var/www/public/index.php</b> on line <b>24</b><br />
<br />
<b>Fatal error</b>:  require(): Failed opening required '/var/www/public/../vendor/autoload.php' (include_path='.:/usr/local/lib/php') in <b>/var/www/public/index.php</b> on line <b>24</b><br />
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ date
Sat 06 Jan 2024 08:10:18 PM -03
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
~~~~




- Logs do NGINX retornam 200:

~~~~bash
2024/01/06 23:08:30 [notice] 1#1: start worker process 27
2024/01/06 23:08:30 [notice] 1#1: start worker process 28
192.168.136.1 - - [06/Jan/2024:23:10:07 +0000] "GET / HTTP/1.1" 200 396 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0"
192.168.136.1 - - [06/Jan/2024:23:10:07 +0000] "GET /favicon.ico HTTP/1.1" 200 0 "http://192.168.136.128:8000/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0"
172.18.0.1 - - [06/Jan/2024:23:10:16 +0000] "GET / HTTP/1.1" 200 396 "-" "curl/7.64.0"
172.18.0.1 - - [06/Jan/2024:23:11:24 +0000] "GET / HTTP/1.1" 200 396 "-" "curl/7.64.0"
192.168.136.1 - - [06/Jan/2024:23:13:34 +0000] "GET / HTTP/1.1" 200 396 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0"
192.168.136.1 - - [06/Jan/2024:23:13:34 +0000] "GET /favicon.ico HTTP/1.1" 200 0 "http://192.168.136.128:8000/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0"
192.168.136.1 - - [06/Jan/2024:23:13:34 +0000] "GET / HTTP/1.1" 200 396 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0"
192.168.136.1 - - [06/Jan/2024:23:13:34 +0000] "GET / HTTP/1.1" 200 396 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0"
192.168.136.1 - - [06/Jan/2024:23:13:35 +0000] "GET / HTTP/1.1" 200 396 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0"
192.168.136.1 - - [06/Jan/2024:23:15:44 +0000] "GET / HTTP/1.1" 200 396 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0"
192.168.136.1 - - [06/Jan/2024:23:15:44 +0000] "GET /favicon.ico HTTP/1.1" 200 0 "http://192.168.136.128:8000/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0"
192.168.136.1 - - [06/Jan/2024:23:15:46 +0000] "GET / HTTP/1.1" 200 396 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0"
192.168.136.1 - - [06/Jan/2024:23:15:46 +0000] "GET /favicon.ico HTTP/1.1" 200 0 "http://192.168.136.128:8000/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0"
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$

~~~~





- Subindo novo TravelList, com base no projeto original da Digital Ocean:
/home/fernando/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo


- Mesmo erro:

http://192.168.0.109:8000/

~~~~bash
Warning: require(/var/www/public/../vendor/autoload.php): failed to open stream: No such file or directory in /var/www/public/index.php on line 24

Fatal error: require(): Failed opening required '/var/www/public/../vendor/autoload.php' (include_path='.:/usr/local/lib/php') in /var/www/public/index.php on line 24
~~~~







User
erro ao tentar acessar pagina php 


Warning: require(/var/www/public/../vendor/autoload.php): failed to open stream: No such file or directory in /var/www/public/index.php on line 24

Fatal error: require(): Failed opening required '/var/www/public/../vendor/autoload.php' (include_path='.:/usr/local/lib/php') in /var/www/public/index.php on line 24
ChatGPT

O erro que você está enfrentando indica que o arquivo /var/www/public/../vendor/autoload.php não pode ser encontrado. Aqui estão algumas sugestões para resolver esse problema:

    Verifique a existência do arquivo:
    Certifique-se de que o arquivo autoload.php está presente no diretório especificado. Você pode verificar se o arquivo existe executando o seguinte comando no terminal:

    bash

ls /var/www/public/../vendor/autoload.php

Se o arquivo não existir, pode ser necessário instalar as dependências do Composer novamente.

Execute o Composer Install:
Se você estiver usando o Composer para gerenciar as dependências do seu projeto, execute o seguinte comando na raiz do seu projeto para instalar as dependências:

bash

composer install

Isso garantirá que o arquivo autoload.php e outras dependências sejam instalados corretamente.

Verifique a Estrutura do Projeto:
Certifique-se de que a estrutura do seu projeto esteja correta. O arquivo index.php parece estar na pasta /var/www/public/, e o autoload.php deve estar na pasta vendor dentro do diretório raiz do seu projeto.

Verifique as Permissões de Arquivo:
Certifique-se de que o usuário do servidor web tem permissões adequadas para ler os arquivos no seu projeto. Você pode precisar ajustar as permissões usando o comando chmod:

bash

chmod -R 755 /var/www/public

Certifique-se de ajustar as permissões conforme necessário para o seu ambiente.

Corrija o Caminho do Autoload:
Se o seu projeto estiver em um ambiente diferente do esperado, ajuste o caminho do autoload.php no seu arquivo index.php para refletir a estrutura correta do projeto.

Em vez de:

php

require('/var/www/public/../vendor/autoload.php');

Você pode tentar:

php

    require(__DIR__ . '/../vendor/autoload.php');

    Isso constrói o caminho de forma mais confiável, independentemente do diretório de trabalho atual.

Após realizar essas verificações e correções, o problema deve ser resolvido. Se o erro persistir, revise seu código e verifique se não há problemas adicionais na lógica de inclusão de arquivos.














- Executando composer install

~~~~bash
  - Installing theseer/tokenizer (1.1.3): Extracting archive
  - Installing sebastian/code-unit-reverse-lookup (1.0.1): Extracting archive
  - Installing phpunit/php-code-coverage (7.0.10): Extracting archive
  - Installing doctrine/instantiator (1.3.0): Extracting archive
  - Installing phpspec/prophecy (v1.10.3): Extracting archive
  - Installing phar-io/version (2.0.1): Extracting archive
  - Installing phar-io/manifest (1.0.3): Extracting archive
  - Installing myclabs/deep-copy (1.9.5): Extracting archive
  - Installing phpunit/phpunit (8.5.4): Extracting archive
Package phpunit/php-token-stream is abandoned, you should avoid using it. No replacement was suggested.
Generating optimized autoload files
> Illuminate\Foundation\ComposerScripts::postAutoloadDump
> @php artisan package:discover --ansi
Discovered Package: facade/ignition
Discovered Package: fideloper/proxy
Discovered Package: laravel/tinker
Discovered Package: nesbot/carbon
Discovered Package: nunomaduro/collision
Package manifest generated successfully.
35 packages you are using are looking for funding.
Use the `composer fund` command to find out more!
sammy@802d153c93ce:/var/www$
sammy@802d153c93ce:/var/www$
sammy@802d153c93ce:/var/www$
sammy@802d153c93ce:/var/www$

~~~~






- Agora ao acessar
<http://192.168.0.109:8000/>

resolveu problema.
novo erro:

~~~~bash
RuntimeException
No application encryption key has been specified.
http://192.168.0.109:8000/
Hide solutions
Your app key is missing

Generate your application encryption key using php artisan key:generate.
Read more

    Laravel installation
~~~~







- Logs do Laravel, erro:

~~~~bash
sammy@802d153c93ce:/var/www$ tail storage/logs/laravel.log -n 88
[2024-01-06 23:25:57] dev.ERROR: No application encryption key has been specified. {"exception":"[object] (RuntimeException(code: 0): No application encryption key has been specified. at /var/www/vendor/laravel/framework/src/Illuminate/Encryption/EncryptionServiceProvider.php:80)
[stacktrace]
#0 /var/www/vendor/laravel/framework/src/Illuminate/Support/helpers.php(433): Illuminate\\Encryption\\EncryptionServiceProvider->Illuminate\\Encryption\\{closure}('')
#1 /var/www/vendor/laravel/framework/src/Illuminate/Encryption/EncryptionServiceProvider.php(84): tap('', Object(Closure))
#2 /var/www/vendor/laravel/framework/src/Illuminate/Encryption/EncryptionServiceProvider.php(61): Illuminate\\Encryption\\EncryptionServiceProvider->key(Array)
#3 /var/www/vendor/laravel/framework/src/Illuminate/Encryption/EncryptionServiceProvider.php(33): Illuminate\\Encryption\\EncryptionServiceProvider->parseKey(Array)
#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(801): Illuminate\\Encryption\\EncryptionServiceProvider->Illuminate\\Encryption\\{closure}(Object(Illuminate\\Foundation\\Application), Array)
#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(687): Illuminate\\Container\\Container->build(Object(Closure))
#6 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(796): Illuminate\\Container\\Container->resolve('encrypter', Array, true)
#7 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(633): Illuminate\\Foundation\\Application->resolve('encrypter', Array)
#8 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(781): Illuminate\\Container\\Container->make('encrypter', Array)
#9 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(955): Illuminate\\Foundation\\Application->make('encrypter')
#10 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(875): Illuminate\\Container\\Container->resolveClass(Object(ReflectionParameter))
#11 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(836): Illuminate\\Container\\Container->resolveDependencies(Array)
#12 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(687): Illuminate\\Container\\Container->build('App\\\\Http\\\\Middle...')
#13 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(796): Illuminate\\Container\\Container->resolve('App\\\\Http\\\\Middle...', Array, true)
#14 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(633): Illuminate\\Foundation\\Application->resolve('App\\\\Http\\\\Middle...', Array)
#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(781): Illuminate\\Container\\Container->make('App\\\\Http\\\\Middle...', Array)
#16 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(156): Illuminate\\Foundation\\Application->make('App\\\\Http\\\\Middle...')
#17 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(103): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(Illuminate\\Http\\Request))
#18 /var/www/vendor/laravel/framework/src/Illuminate/Routing/Router.php(687): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))
#19 /var/www/vendor/laravel/framework/src/Illuminate/Routing/Router.php(662): Illuminate\\Routing\\Router->runRouteWithinStack(Object(Illuminate\\Routing\\Route), Object(Illuminate\\Http\\Request))
#20 /var/www/vendor/laravel/framework/src/Illuminate/Routing/Router.php(628): Illuminate\\Routing\\Router->runRoute(Object(Illuminate\\Http\\Request), Object(Illuminate\\Routing\\Route))
#21 /var/www/vendor/laravel/framework/src/Illuminate/Routing/Router.php(617): Illuminate\\Routing\\Router->dispatchToRoute(Object(Illuminate\\Http\\Request))
#22 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Http/Kernel.php(165): Illuminate\\Routing\\Router->dispatch(Object(Illuminate\\Http\\Request))
#23 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(128): Illuminate\\Foundation\\Http\\Kernel->Illuminate\\Foundation\\Http\\{closure}(Object(Illuminate\\Http\\Request))
#24 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Http/Middleware/TransformsRequest.php(21): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(Illuminate\\Http\\Request))
#25 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(167): Illuminate\\Foundation\\Http\\Middleware\\TransformsRequest->handle(Object(Illuminate\\Http\\Request), Object(Closure))
#26 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Http/Middleware/TransformsRequest.php(21): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(Illuminate\\Http\\Request))
#27 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(167): Illuminate\\Foundation\\Http\\Middleware\\TransformsRequest->handle(Object(Illuminate\\Http\\Request), Object(Closure))
#28 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Http/Middleware/ValidatePostSize.php(27): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(Illuminate\\Http\\Request))
#29 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(167): Illuminate\\Foundation\\Http\\Middleware\\ValidatePostSize->handle(Object(Illuminate\\Http\\Request), Object(Closure))
#30 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Http/Middleware/CheckForMaintenanceMode.php(63): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(Illuminate\\Http\\Request))
#31 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(167): Illuminate\\Foundation\\Http\\Middleware\\CheckForMaintenanceMode->handle(Object(Illuminate\\Http\\Request), Object(Closure))
#32 /var/www/vendor/fideloper/proxy/src/TrustProxies.php(57): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(Illuminate\\Http\\Request))
#33 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(167): Fideloper\\Proxy\\TrustProxies->handle(Object(Illuminate\\Http\\Request), Object(Closure))
#34 /var/www/vendor/laravel/framework/src/Illuminate/Pipeline/Pipeline.php(103): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(Illuminate\\Http\\Request))
#35 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Http/Kernel.php(140): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))
#36 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Http/Kernel.php(109): Illuminate\\Foundation\\Http\\Kernel->sendRequestThroughRouter(Object(Illuminate\\Http\\Request))
#37 /var/www/public/index.php(55): Illuminate\\Foundation\\Http\\Kernel->handle(Object(Illuminate\\Http\\Request))
#38 {main}
"}
[2024-01-06 23:25:57] dev.ERROR: No application encryption key has been specified. {"exception":"[object] (RuntimeException(code: 0): No application encryption key has been specified. at /var/www/vendor/laravel/framework/src/Illuminate/Encryption/EncryptionServiceProvider.php:80)
[stacktrace]
#0 /var/www/vendor/laravel/framework/src/Illuminate/Support/helpers.php(433): Illuminate\\Encryption\\EncryptionServiceProvider->Illuminate\\Encryption\\{closure}('')
#1 /var/www/vendor/laravel/framework/src/Illuminate/Encryption/EncryptionServiceProvider.php(84): tap('', Object(Closure))
#2 /var/www/vendor/laravel/framework/src/Illuminate/Encryption/EncryptionServiceProvider.php(61): Illuminate\\Encryption\\EncryptionServiceProvider->key(Array)
#3 /var/www/vendor/laravel/framework/src/Illuminate/Encryption/EncryptionServiceProvider.php(33): Illuminate\\Encryption\\EncryptionServiceProvider->parseKey(Array)
#4 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(801): Illuminate\\Encryption\\EncryptionServiceProvider->Illuminate\\Encryption\\{closure}(Object(Illuminate\\Foundation\\Application), Array)
#5 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(687): Illuminate\\Container\\Container->build(Object(Closure))
#6 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(796): Illuminate\\Container\\Container->resolve('encrypter', Array, true)
#7 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(633): Illuminate\\Foundation\\Application->resolve('encrypter', Array)
#8 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(781): Illuminate\\Container\\Container->make('encrypter', Array)
#9 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(955): Illuminate\\Foundation\\Application->make('encrypter')
#10 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(875): Illuminate\\Container\\Container->resolveClass(Object(ReflectionParameter))
#11 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(836): Illuminate\\Container\\Container->resolveDependencies(Array)
#12 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(687): Illuminate\\Container\\Container->build('App\\\\Http\\\\Middle...')
#13 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(796): Illuminate\\Container\\Container->resolve('App\\\\Http\\\\Middle...', Array, true)
#14 /var/www/vendor/laravel/framework/src/Illuminate/Container/Container.php(633): Illuminate\\Foundation\\Application->resolve('App\\\\Http\\\\Middle...', Array)
#15 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(781): Illuminate\\Container\\Container->make('App\\\\Http\\\\Middle...', Array)
#16 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Http/Kernel.php(204): Illuminate\\Foundation\\Application->make('App\\\\Http\\\\Middle...')
#17 /var/www/vendor/laravel/framework/src/Illuminate/Foundation/Http/Kernel.php(178): Illuminate\\Foundation\\Http\\Kernel->terminateMiddleware(Object(Illuminate\\Http\\Request), Object(Illuminate\\Http\\Response))
#18 /var/www/public/index.php(60): Illuminate\\Foundation\\Http\\Kernel->terminate(Object(Illuminate\\Http\\Request), Object(Illuminate\\Http\\Response))
#19 {main}
"}
sammy@802d153c93ce:/var/www$
~~~~














RuntimeException
No application encryption key has been specified.
http://192.168.0.109:8000/
Hide solutions
Your app key is missing

Generate your application encryption key using php artisan key:generate.
ChatGPT

O erro que você está enfrentando indica que a chave de criptografia da aplicação não foi configurada no Laravel. Para resolver isso, você precisa gerar uma chave de aplicativo usando o comando php artisan key:generate. Aqui estão os passos para corrigir o problema:

    Abra um terminal na raiz do seu projeto Laravel.

    Execute o seguinte comando para gerar a chave de aplicativo:

    bash

php artisan key:generate

Isso gerará uma nova chave de aplicativo e a colocará no arquivo .env do seu projeto.

Após executar o comando, verifique o arquivo .env na raiz do seu projeto Laravel. Deve haver uma linha semelhante a esta:

dotenv

APP_KEY=base64:your_generated_key_here

Certifique-se de que a chave de aplicativo foi gerada corretamente e está presente no arquivo .env.

Se a chave ainda não estiver presente no arquivo .env ou se você quiser regenerá-la, execute novamente o comando php artisan key:generate.

Após gerar a chave de aplicativo, limpe o cache do Laravel para garantir que as alterações sejam refletidas. Execute o seguinte comando:

bash

    php artisan cache:clear

    Este comando limpa o cache da aplicação Laravel.

    Reinicie o servidor de desenvolvimento (se estiver usando o servidor embutido do Laravel) ou o servidor web que você está usando.

Após seguir esses passos, o erro relacionado à chave de criptografia da aplicação deve ser resolvido. Certifique-se de sempre gerar a chave de aplicativo quando iniciar um novo projeto Laravel ou ao clonar um projeto existente.











- Ajustado

sammy@802d153c93ce:/var/www$ php artisan key:generate
Application key set successfully.
sammy@802d153c93ce:/var/www$ cat .env
APP_NAME=Travellist
APP_ENV=dev
APP_KEY=base64:dTwxwHY1lXdo1xPUeDnB/jZJdGYPsFvh+ErvBLTNQVQ=

sammy@802d153c93ce:/var/www$ php artisan cache:clear
Application cache cleared!
sammy@802d153c93ce:/var/www$
sammy@802d153c93ce:/var/www$












## PENDENTE

- Ajustar Dockerfile para efetuar composer install
- Adicionar APP_KEY ao .env.example









- Ajustar Dockerfile para efetuar composer install
/home/fernando/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo/Dockerfile

~~~~DOCKERFILE
# Instale as dependências usando o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-interaction --no-scripts --no-suggest
~~~~




- Adicionar APP_KEY ao .env.example
ajustado:
/home/fernando/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo/.env.example








## PENDENTE
- Ler
https://docs.newrelic.com/docs/errors-inbox/errors-inbox/
- Subir APM na aplicação Travellist.
- Ler
https://adevait.com/laravel/containerizing-laravel-applications-with-docker








https://one.newrelic.com/marketplace/install-data-source?account=4301656&duration=1800000&filters=%28domain%20IN%20%28%27APM%27%2C%20%27EXT%27%29%20AND%20type%20IN%20%28%27APPLICATION%27%2C%20%27SERVICE%27%29%29&state=74a66fde-29c7-63ab-c911-dbdb51ab4b21

Configure the New Relic PHP daemon Docker container

First you will set up the PHP daemon container, then the PHP agent container.
Step null:

Start by creating a docker network for the daemon container and your application container to facilitate communication between the containers.
docker network create newrelic-php

Start the daemon container.
docker run -d --name newrelic-php-daemon --network newrelic-php newrelic/php-daemon





Configure your Docker container with the PHP agent

This will involve setting up the daemon and PHP agent in different containers.
1Step 1: Download the Docker file

Note the location of where the file is downloaded. You will run the docker build command in the next step from the same directory.
Dockerfile 18 lines 817.0 B

ARG IMAGE_NAME

FROM ${IMAGE_NAME}


ARG NEW_RELIC_AGENT_VERSION

ARG NEW_RELIC_LICENSE_KEY

ARG NEW_RELIC_APPNAME


RUN curl -L https://download.newrelic.com/php_agent/archive/${NEW_RELIC_AGENT_VERSION}/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux.tar.gz | tar -C /tmp -zx \

    && export NR_INSTALL_USE_CP_NOT_LN=1 \

    && export NR_INSTALL_SILENT=1 \

    && /tmp/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux/newrelic-install install \

    && rm -rf /tmp/newrelic-php5-* /tmp/nrinstall*


RUN find /etc /opt/etc /usr/local/etc -type f -name newrelic.ini \

    -exec sed -i \

        -e "s/REPLACE_WITH_REAL_KEY/${NEW_RELIC_LICENSE_KEY}/" \

        -e "s/newrelic.appname[[:space:]]=[[:space:]].*/newrelic.appname = \"${NEW_RELIC_APPNAME}\"/" \

        -e '$anewrelic.daemon.address="newrelic-php-daemon:31339"' {} \;

2Step 2: Name your application

You'll use this to find your data later, so choose a unique and meaningful name. See our docs

.
Name*
Instrumenting your apps
The following commands will configure all PHP apps on your host to report as a single APM entity. If you have multiple apps on your system and would prefer to configure them separately, edit the directories in the `find` commands below.
3Step 3: Build and run the Docker image for the PHP agent.

Enter the name of the Docker image you want to instrument, then run the docker build command below from the directory where you saved the Dockerfile.
docker build -t "php_application_with_newrelic" --build-arg NEW_RELIC_AGENT_VERSION=10.10.0.1 --build-arg NEW_RELIC_LICENSE_KEY=  --build-arg NEW_RELIC_APPNAME="PHP Application" --build-arg IMAGE_NAME="" .

Run your new docker image. Docker will run your image connected to the newrelic-php network.
docker run --network newrelic-php -p 8080:80 "php_application_with_newrelic"

Note, you may need to alter the -p argument depending on how your image is configured


- Exemplo de como ficaria:

~~~~DOCKERFILE

## NEWRELIC
ARG IMAGE_NAME
FROM ${IMAGE_NAME}

ARG NEW_RELIC_AGENT_VERSION
ARG NEW_RELIC_LICENSE_KEY
ARG NEW_RELIC_APPNAME

RUN curl -L https://download.newrelic.com/php_agent/archive/${NEW_RELIC_AGENT_VERSION}/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux.tar.gz | tar -C /tmp -zx \
    && export NR_INSTALL_USE_CP_NOT_LN=1 \
    && export NR_INSTALL_SILENT=1 \
    && /tmp/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux/newrelic-install install \
    && rm -rf /tmp/newrelic-php5-* /tmp/nrinstall*

RUN find /etc /opt/etc /usr/local/etc -type f -name newrelic.ini \
    -exec sed -i \
        -e "s/REPLACE_WITH_REAL_KEY/${NEW_RELIC_LICENSE_KEY}/" \
        -e "s/newrelic.appname[[:space:]]=[[:space:]].*/newrelic.appname = \"${NEW_RELIC_APPNAME}\"/" \
        -e '$anewrelic.daemon.address="newrelic-php-daemon:31339"' {} \;
## FINAL DA INSTALAÇÃO DO NEW RELIC
~~~~










- Parando

~~~~bash

fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ make stop
docker-compose stop
Stopping travellist-app   ... done
Stopping travellist-db    ... done
Stopping travellist-nginx ... done
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
You have new mail in /var/mail/fernando
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ docker ps
CONTAINER ID   IMAGE                 COMMAND                  CREATED         STATUS         PORTS       NAMES
3346e9339f04   newrelic/php-daemon   "sh /usr/bin/docker-…"   3 minutes ago   Up 3 minutes   31339/tcp   newrelic-php-daemon
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$ docker stop newrelic-php-daemon
newrelic-php-daemon
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/travellist-laravel-demo$

~~~~





## PENDENTE
- Ler
https://docs.newrelic.com/docs/errors-inbox/errors-inbox/
- Subir APM na aplicação Travellist.
- Ler
https://adevait.com/laravel/containerizing-laravel-applications-with-docker







## Dia 07/01/2024

- Subindo aplicação:
cd /home/fernando/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo
make up
curl http://192.168.0.109:8000/

~~~~bash
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo$ pwd
/home/fernando/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
You have new mail in /var/mail/fernando
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo$ make up

fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo$
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED        STATUS          PORTS                                   NAMES
802d153c93ce   travellist     "docker-php-entrypoi…"   15 hours ago   Up 18 seconds   9000/tcp                                travellist-app
e62315538563   mysql:5.7      "docker-entrypoint.s…"   15 hours ago   Up 18 seconds   3306/tcp, 33060/tcp                     travellist-db
4797d39ce57b   nginx:alpine   "/docker-entrypoint.…"   15 hours ago   Up 18 seconds   0.0.0.0:8000->80/tcp, :::8000->80/tcp   travellist-nginx
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo$

fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo$ curl http://192.168.0.109:8000/ | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
<html>  0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
<head>
    <link rel="stylesheet" href="/css/global.css" type="text/css">
    <link rel="stylesheet" href="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v5.3.0/css/ol.css" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Anton&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Hind&display=swap" rel="stylesheet">

    <script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v5.3.0/build/ol.js"></script>
    <script src="/js/map.js"></script>

100  4113    0  4113    0     0   108k      0 --:--:-- --:--:-- --:--:--  108k
(23) Failed writing body
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo$
~~~~





- Subir APM na aplicação Travellist.

<https://one.newrelic.com/marketplace/install-data-source?account=4301656&duration=1800000&filters=%28domain%20IN%20%28%27APM%27%2C%20%27EXT%27%29%20AND%20type%20IN%20%28%27APPLICATION%27%2C%20%27SERVICE%27%29%29&state=74a66fde-29c7-63ab-c911-dbdb51ab4b21>

Select the package manager installed on your host

We will streamline your installation process by providing executable commands that are specific to your environment
apt
yum
2Step 2: Configure the New Relic apt repository
echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | sudo tee /etc/apt/sources.list.d/newrelic.list
3Step 3: Trust the New Relic GPG key
wget -O- https://download.newrelic.com/548C16BF.gpg | sudo apt-key add -
4Step 4: Update apt
sudo apt-get update








- Dockerfile

DE:

~~~~DOCKERFILE
FROM php:7.4-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instale as dependências usando o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-interaction --no-scripts --no-suggest

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user


# Set working directory
WORKDIR /var/www

USER $user

~~~~


PARA:

~~~~DOCKERFILE
FROM php:7.4-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

## apm - new relic
RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list
RUN wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

## apm - new relic
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -qq install newrelic-php5
RUN NR_INSTALL_KEY=$NR_INSTALL_KEY newrelic-install install
RUN find /etc /opt/etc /usr/local/etc -type f -name newrelic.ini -exec sed -i -e "s/REPLACE_WITH_REAL_KEY/$NR_INSTALL_KEY/" -e "s/newrelic.appname[[:space:]]=[[:space:]].*/newrelic.appname = \"travellist-app-teste\"/" {} \; 2>/dev/null

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instale as dependências usando o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-interaction --no-scripts --no-suggest

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user


# Set working directory
WORKDIR /var/www

USER $user


~~~~





- ERRO 

~~~~BASH

fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo$ make build-no-cache
docker-compose build --no-cache
db uses an image, skipping
nginx uses an image, skipping
Building app
[+] Building 1.2s (8/20)                                                                                                                                                                                                                                                       docker:default
 => [internal] load .dockerignore                                                                                                                                                                                                                                                        0.0s
 => => transferring context: 88B                                                                                                                                                                                                                                                         0.0s
 => [internal] load build definition from Dockerfile                                                                                                                                                                                                                                     0.0s
 => => transferring dockerfile: 1.58kB                                                                                                                                                                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/composer:latest                                                                                                                                                                                                                       0.0s
 => [internal] load metadata for docker.io/library/php:7.4-fpm                                                                                                                                                                                                                           0.5s
 => CACHED [stage-0  1/15] FROM docker.io/library/php:7.4-fpm@sha256:3ac7c8c74b2b047c7cb273469d74fc0d59b857aa44043e6ea6a0084372811d5b                                                                                                                                                    0.0s
 => CACHED FROM docker.io/library/composer:latest                                                                                                                                                                                                                                        0.0s
 => [stage-0  2/15] RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list                                                                                                                                                         0.2s
 => ERROR [stage-0  3/15] RUN wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -                                                                                                                                                                                        0.4s
------
 > [stage-0  3/15] RUN wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -:
0.277 /bin/sh: 1: wget: not found
0.333 E: gnupg, gnupg2 and gnupg1 do not seem to be installed, but one of them is required for this operation
------
Dockerfile:9
--------------------
   7 |     ## apm - new relic
   8 |     RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list
   9 | >>> RUN wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -
  10 |
  11 |     # Install system dependencies
--------------------
ERROR: failed to solve: process "/bin/sh -c wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -" did not complete successfully: exit code: 255
ERROR: Service 'app' failed to build : Build failed
make: *** [Makefile:12: build-no-cache] Error 1
fernando@debian10x64:~/cursos/new-relic/new-relic-estudos/aplicacoes/outra-app-2/travellist-laravel-demo$

~~~~