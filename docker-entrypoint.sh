#!/usr/bin/env bash

source /etc/bash.bashrc.phpenv_setup

version=$1

if ! [ -x '/upload/script' ]
then
  >&2 echo "This image needs an externally mounted volume at /upload that contains an executable file called 'script'."
  >&2 echo "Since we don't have that, we don't know how to get the php that would be built out of this ephemeral container."
  exit 1
fi

# make sure php-build is up-to-date
cd /usr/local/phpenv/plugins/php-build; git pull

# hack in instruction to configure php build --with-apxs2 for apache .so
if [ -f "share/php-build/definitions/$version" ]
then
  echo 'with_apxs2 "/usr/bin/apxs2"' | cat - share/php-build/definitions/$version > share/php-build/definitions/$version-apache
fi

if [ -f share/php-build/definitions/$version-apache ]
then
  mv share/php-build/definitions/$version-apache share/php-build/definitions/$version
else
  >&2 echo "Failed setting up php build configuration for apache."
  exit 1
fi

# Run the build
cd /
phpenv install "$version"

# If the build succeeded, run the upload script to send it out into the world.
if [ $? -eq 0 ]
then
  /upload/script "$version" "/usr/local/phpenv/versions"
fi
