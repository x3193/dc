#!/bin/bash

exec /usr/sbin/sshd -D
/usr/sbin/apache2 -k start
