#!/bin/bash

id -un
echo "run-apache2.sh"
apache2
exec /usr/sbin/sshd -D
exit 0
