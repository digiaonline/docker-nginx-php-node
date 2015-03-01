FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

# Install core dependencies
RUN apt-get update && \
  apt-get install -y \
    curl \
    git-core \
    supervisor

ADD supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install Nginx
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y nginx

ADD nginx/default.conf /etc/nginx/conf.d/default.conf

# Add user 'nginx' to administrators
RUN usermod -u 1000 nginx

# Install PHP-FPM
RUN apt-get update && \
  apt-get install -y \
    php5-cli \
    php5-curl \
    php5-fpm \
    php5-gd \
    php5-intl \
    php5-mcrypt \
    php5-mysql

ADD php/www.conf /etc/php5/fpm/pool.d/www.conf

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup | bash - && \
  apt-get install -y nodejs

# Setup the run script
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Setup the public folder
ADD app /app

# Expose ports, set working directory and execute the run script
EXPOSE 80 443
WORKDIR /app
CMD ["/run.sh"]
