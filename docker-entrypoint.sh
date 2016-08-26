#!/usr/bin/env bash

source /etc/bash.bashrc.phpenv_setup

version=$1

if ! [ -x '/upload/script' ]
then
  >&2 echo "This image needs an externally mounted volume at /upload that contains an executable file called 'script'."
  >&2 echo "Since we don't have that, we don't know how to get the php that would be built out of this ephemeral container."
  exit 1
fi

phpenv install "$version"

if [ $? -eq 0 ]
then
  /upload/script "$version" "/usr/local/phpenv/versions"
fi
