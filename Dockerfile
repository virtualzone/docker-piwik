from	ubuntu:12.04

env	DEBIAN_FRONTEND noninteractive

run	dpkg-divert --local --rename --add /sbin/initctl
run	ln -s /bin/true /sbin/initctl

run	echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
run	apt-get --yes update
run	apt-get --yes upgrade
run	apt-get --yes install mysql-server php5-mysql nginx supervisor wget

run	sed -i '3 i\daemon off;' /etc/nginx/nginx.conf
run	sed -i -e "s/\;daemonize = yes/daemonize = no/" /etc/php5/fpm/php-fpm.conf
run	sed -i -e "s/\;cgi\.fix_pathinfo=1/cgi\.fix_pathinfo=0/" /etc/php5/fpm/php.ini
run	sed -i -e "s/listen = 127\.0\.0\.1\:9000/listen = \/var\/run\/php5-fpm.sock/" /etc/php5/fpm/pool.d/www.conf
add	./nginx-default.conf /etc/nginx/sites-available/default
add 	./supervisord.conf /etc/supervisor/supervisord.conf
add	./start /start
run	chmod +x /start

run	mkdir -p /srv/www/piwik
run	wget -O - http://builds.piwik.org/latest.tar.gz | tar -C /srv/www/piwik --strip-components=1 -zx
run	chown -R www-data:www-data /srv/www/piwik

expose  80

cmd	["/start"]
