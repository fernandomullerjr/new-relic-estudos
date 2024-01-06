
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