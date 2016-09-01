#!/bin/bash

exec /usr/sbin/sshd -D
exec top -bcn 1
