# -----------------------------------------------------------------------------
# docker-piwik
#
# Builds a basic docker image that can run Piwik (http://piwik.org) and serve
# all of it's assets.
#
# Authors: Isaac Bythewood
# Updated: Aug 19th, 2014
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------


# Base system is the LTS version of Ubuntu.
from   ubuntu:12.04


# Make sure we don't get notifications we can't answer during building.
env    DEBIAN_FRONTEND noninteractive


# An annoying error message keeps appearing unless you do this.
run    dpkg-divert --local --rename --add /sbin/initctl
run    ln -s /bin/true /sbin/initctl


# Download and install everything from the repos and add geo location database
add    ./apt/sources.list /etc/apt/sources.list
run    apt-get --yes update; apt-get --yes upgrade
run	   apt-get --yes install git supervisor nginx php5-mysql php5-gd mysql-server pwgen wget
run    mkdir -p /srv/www/; cd /srv/www/; git clone -b 1.X https://github.com/piwik/piwik.git
run    cd /srv/www/piwik/misc; wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz; gzip -d GeoLiteCity.dat.gz


# Load in all of our config files.
add    ./nginx/nginx.conf /etc/nginx/nginx.conf
add    ./nginx/sites-enabled/default /etc/nginx/sites-enabled/default
add    ./php5/fpm/php-fpm.conf /etc/php5/fpm/php-fpm.conf
add    ./php5/fpm/php.ini /etc/php5/fpm/php.ini
add    ./php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf
add    ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf
add    ./supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/nginx.conf
add    ./supervisor/conf.d/mysqld.conf /etc/supervisor/conf.d/mysqld.conf
add    ./supervisor/conf.d/php5-fpm.conf /etc/supervisor/conf.d/php5-fpm.conf
add    ./mysql/my.cnf /etc/mysql/my.cnf
add    ./scripts/start /start


# Fix all permissions
run	   chmod +x /start; chown -R www-data:www-data /srv/www/piwik


# 80 is for nginx web, /data contains static files and database /start runs it.
expose 80
volume ["/data"]
cmd    ["/start"]

