#!/bin/bash

exec /usr/sbin/sshd -D
exec /usr/sbin/apache2 -D
