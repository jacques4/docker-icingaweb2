# rancher server backup image
FROM php:5.6-apache
MAINTAINER remo.wenger@mimacom.com

# set variables
ENV ICINGAWEB_VERSION 2.4.1
ENV ICINGAWEB_SETUP_TOKEN none

# install dependencies

# download icingaweb2 sources
RUN curl -o /tmp/icingaweb2.tar.gz -SL "https://github.com/Icinga/icingaweb2/archive/v${ICINGAWEB_VERSION}.tar.gz" \
&&  mkdir /usr/share/icingaweb2/ \
&&  tar xf /tmp/icingaweb2.tar.gz --strip-components=1 -C /usr/share/icingaweb2 \
&&  rm -f /tmp/icingaweb2.tar.gz
&&  /usr/share/icingaweb2/bin/icingacli /usr/local/bin/icingacli

# set up apache vHost
RUN cp /usr/share/icingaweb2/packages/files/apache/icingaweb2.conf /etc/apache2/conf-enabled/ \
&&  echo "RedirectMatch ^/$ /icingaweb2" >> /etc/apache2/conf-enabled/redirect.conf \
&&  a2enmod rewrite \
&&  echo "date.timezone = UTC" > /usr/local/etc/php/conf.d/timeszone.ini


# volume
VOLUME /etc/icingaweb2

# install the entrypoint
COPY entrypoint.sh /entrypoint.sh


# start
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "apache2-foreground" ]
