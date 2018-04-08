FROM prophusion/prophusion-base:18.04

# Enable source repositories to allow installation of PHP's build dependencies
RUN sed 's/# deb-src/deb-src/' /etc/apt/sources.list > /etc/apt/sources.list2; \
    mv /etc/apt/sources.list2 /etc/apt/sources.list

# install php-build
RUN mkdir /usr/local/phpenv/plugins; \
    cd /usr/local/phpenv/plugins; \
    git clone https://github.com/CHH/php-build.git

# install build dependencies
RUN ["/bin/bash", "-c", "apt-get update && apt-get install -y libmcrypt-dev libreadline-dev apache2 \
 && apt-get build-dep -y php7.2-dev"]

# RUN ["/bin/bash", "-c", "source /etc/bash.bashrc.phpenv_setup ; apt-get install -y libmcrypt-dev libreadline-dev \
# && apt-get build-dep -y php"]

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
