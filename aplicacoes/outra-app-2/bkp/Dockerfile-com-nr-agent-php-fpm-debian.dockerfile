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
    wget \
    gnupg

## apm - new relic
RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list
RUN wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -
RUN apt-get update -y

## apm - new relic
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -qq install newrelic-php5
RUN NR_INSTALL_KEY=${NR_INSTALL_KEY} newrelic-install install
RUN find ${NR_DIR_PHP} -type f -name newrelic.ini -exec sed -i -e "s/REPLACE_WITH_REAL_KEY/${NR_INSTALL_KEY}/" -e "s/newrelic.appname[[:space:]]=[[:space:]].*/newrelic.appname = \"travellist-app-teste\"/" {} \; 2>/dev/null


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
