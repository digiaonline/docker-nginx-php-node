FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get install -y \
    curl \
    supervisor

ADD supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

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

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y nginx

ADD nginx/default.conf /etc/nginx/conf.d/default.conf

RUN curl -sL https://deb.nodesource.com/setup | bash - && \
  apt-get install -y nodejs

ADD run.sh /run.sh
RUN chmod 755 /*.sh

RUN mkdir -p /code && rm -fr /usr/share/nginx/html && ln -s /code /usr/share/nginx/html
ADD html/ /code

EXPOSE 80 443
WORKDIR /usr/share/nginx/html
CMD ["/run.sh"]
